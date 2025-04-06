
from flask import Flask, render_template, send_file, url_for, request, redirect, flash, session,redirect,jsonify
import cx_Oracle
from flask_session import Session
import io
from passlib.hash import sha256_crypt
import os
import json
import requests  
import pandas as pd
from flask import Response


app = Flask(__name__, template_folder="templates", static_folder="static")
app.secret_key = 'your_secret_keya_very_long_and_random_string'  

app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"  
Session(app)

def get_db_connection():
    dsn = cx_Oracle.makedsn("localhost", 1521, service_name="xe") 
    return cx_Oracle.connect(user="system", password="admin", dsn=dsn)



# REGISTRATION FORM
@app.route("/register", methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form.get("username")
        password = request.form.get("password")
        confirm = request.form.get("confirm")

        if password != confirm:
            flash("Passwords do not match!", "danger")
            return render_template('register.html')

        hashed_password = sha256_crypt.hash(password)  

        conn = get_db_connection()
        cursor = conn.cursor()

        try:
            cursor.execute("SELECT 1 FROM user_registration WHERE username = :username", {"username": username})
            if cursor.fetchone():
                flash("Username already exists!", "danger")
                return render_template('register.html')

            cursor.execute(
                "INSERT INTO user_registration (user_id, username, password) VALUES (user_seq.NEXTVAL, :username, :password)",
                {"username": username, "password": hashed_password}
            )
            conn.commit()
            flash("Registration successful! You can now log in.", "success")
            return redirect(url_for('welcome'))

        except cx_Oracle.DatabaseError as e:
            flash(f"Database error: {e}", "danger")
            return render_template('register.html')

        finally:
            cursor.close()
            conn.close()

    return render_template('register.html')  

# LOGIN FORM
@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("SELECT user_id, password FROM user_registration WHERE username = :username", {"username": username})
        user_data = cursor.fetchone()

        cursor.close()
        conn.close()

        if user_data:
            user_id, stored_password = user_data[0], user_data[1]
            if sha256_crypt.verify(password, stored_password):
                session["user"] = username  
                session["user_id"] = user_id  
                
                print("Session User ID (After Login):", session.get("user_id"))

                flash("Login successful!", "success")

                next_page = session.pop('next', None)  
                if next_page:
                    return redirect(next_page)

            else:
                flash("Invalid username or password!", "danger")
        else:
            flash("User not found!", "danger")

    return render_template("login.html")


#  HOME PAGE
@app.route("/")
def welcome():
    return render_template("index.html")

# NAVBAR
@app.route("/load_navbar")
def load_navbar():
    return render_template("navbar.html")

# INFORMATION SITE
@app.route("/first")
def information_site():
    return render_template("Information_Site.html")


#EVENTS 
@app.route("/events")
def events_site():
    return render_template("events.html")


#AWARENESS
@app.route("/awareness")
def awareness():
    return render_template("awareness.html")


#ANALYTICS
@app.route("/analytics")
def visitor_analytics_page():
    return render_template("visitor_analytics.html")

# FEEDBACK PAGE
@app.route("/feedback")
def feedback():
    return render_template("feedback.html")

@app.route("/submit_feedback", methods=["POST"])
def submit_feedback():
    username = request.form.get("username")
    message = request.form.get("message")

    if not username or not message:
        return jsonify({"status": "error", "message": "Username and Feedback are required!"})

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Get user_id from username
        cursor.execute("SELECT user_id FROM user_registration WHERE username = :username", {"username": username})
        result = cursor.fetchone()

        if not result:
            return jsonify({"status": "error", "message": "Username does not exist!"})

        user_id = result[0] 

        # Insert Feedback
        cursor.execute(
            "INSERT INTO feedback (feedback_id, user_id, message) VALUES (feedback_seq.NEXTVAL, :user_id, :message)",
            {"user_id": user_id, "message": message}
        )
        conn.commit()

        return jsonify({"status": "success", "message": "Thank you for your feedback!"})

    except cx_Oracle.DatabaseError as e:
        print(f"Database Error: {e}")  
        return jsonify({"status": "error", "message": "A database error occurred. Please try again later."})

    finally:
        cursor.close()
        conn.close()


@app.route('/get_feedbacks', methods=['GET'])
def get_feedbacks():
    conn = get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute("""
        SELECT u.username, f.message
        FROM feedback f
        JOIN user_registration u ON f.user_id = u.user_id
    """)
    
    feedbacks = cursor.fetchall()
    
    print("Fetched Feedbacks:", feedbacks)  # Debugging output

    feedback_list = []
    for username, message in feedbacks:
        feedback_list.append({
            "username": username,
            "message": str(message.read()) if hasattr(message, 'read') else str(message)  # Convert CLOB to string
        })

    cursor.close()
    conn.close()

    print("Final JSON Response:", {"status": "success", "feedbacks": feedback_list})  # Debugging output
    
    return jsonify({"status": "success", "feedbacks": feedback_list})





# TICKETING
@app.route("/ticket")
def ticketing_page():
    return render_template("ticketing.html")


# E-TICKET
@app.route('/Eticket', methods=['GET', 'POST'])
def generate_ticket():
    if 'user' not in session:
        flash("You must be logged in to generate a ticket!", "danger")
        session['next'] = url_for("generate_ticket")  
        return redirect(url_for("login"))  

    username = session["user"]  

    # Get ticket details from form
    heritage_site = request.form.get('heritageSite')
    category = request.form.get('ticketCategory')
    quantity = request.form.get('ticketQuantity')
    visit_date = request.form.get('visitDate')

    return render_template(
        'eticket.html', 
        username=username,  
        heritage_site=heritage_site, 
        category=category, 
        quantity=quantity, 
        visit_date=visit_date
    )



# SHOP PAGE
@app.route("/shop")
def shop():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM products")
    products = cursor.fetchall()
    cursor.close()
    return render_template('shop.html', products=products)


@app.route("/product_image/<int:product_id>")
def get_product_image(product_id):
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT image_data FROM products WHERE product_id = :id", {"id": product_id})
    result = cursor.fetchone()

    if result and result[0]:
        image_blob = result[0].read() if hasattr(result[0], "read") else result[0]
        cursor.close()
        conn.close()
        return send_file(io.BytesIO(image_blob), mimetype="image/jpeg")

    cursor.close()
    conn.close()
    return "No image found", 404




@app.route('/add_to_cart', methods=['POST'])
def add_to_cart():
    product_id = request.form.get('product_id')
    quantity = int(request.form.get('quantity', 1))

    # Connect to the database to check stock
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT stock FROM products WHERE product_id = :id", {"id": product_id})
    stock = cursor.fetchone()

    if stock is None:
        flash("Product not found.", "danger")
        return redirect('/shop')

    stock = stock[0]  

    if quantity > stock:
        flash(f"Only {stock} available for Product ID {product_id}.", "danger")
        return redirect('/shop')

    if 'cart' not in session:
        session['cart'] = {}

    cart = session['cart']
    if product_id in cart:
        cart[product_id] += quantity
    else:
        cart[product_id] = quantity

    session.modified = True
    return redirect('/cart')




@app.route('/cart')
def cart():
    if 'cart' not in session or not session['cart']:
        return render_template('cart.html', cart_items=[], total=0, warnings=[])

    if 'user' not in session:
        flash("You need to log in to proceed to checkout.", "warning")
        session['next'] = url_for("cart")  # Store the intended page
        return redirect(url_for("login"))  # Redirect to login

    cart = session['cart']
    product_ids = list(cart.keys())

    if not product_ids:
        return render_template('cart.html', cart_items=[], total=0, warnings=[])

    conn = get_db_connection()
    cursor = conn.cursor()

    placeholders = ', '.join(f':{i + 1}' for i in range(len(product_ids)))
    query = f"SELECT product_id, name, description, price, stock FROM products WHERE product_id IN ({placeholders})"

    cursor.execute(query, product_ids)
    products = cursor.fetchall()

    total = 0
    cart_items = []
    warnings = []

    for product in products:
        product_id = str(product[0])
        quantity = cart.get(product_id, 0)
        price = product[3] if product[3] is not None else 0
        stock = product[4] if product[4] is not None else 0

        subtotal = quantity * price
        total += subtotal

        if stock < quantity:
            warnings.append(f"⚠️ Only {stock} left for {product[1]}, but you have {quantity} in the cart!")

        cart_items.append({'product': product, 'quantity': quantity, 'subtotal': subtotal})

    cursor.close()
    conn.close()

    return render_template('cart.html', cart_items=cart_items, total=total, warnings=warnings)




@app.route('/update_cart', methods=['POST'])
def update_cart():
    product_id = request.form.get('product_id')
    action = request.form.get('action')

    if 'cart' not in session or product_id not in session['cart']:
        flash("Item not found in cart!", "danger")
        return redirect('/cart')

    if action == "increase":
        session['cart'][product_id] += 1
    elif action == "decrease":
        if session['cart'][product_id] > 1:
            session['cart'][product_id] -= 1
        else:
            del session['cart'][product_id]  # Remove from cart if quantity is 0

    session.modified = True
    return redirect('/cart')



@app.route('/checkout', methods=['POST'])
def checkout():
    if 'user' not in session:  
        flash("You must be logged in to proceed to checkout!", "danger")
        return redirect(url_for("login", next=url_for("cart")))  

    user_id = session["user_id"]  
    total = request.form.get('total')

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        
        cursor.execute("INSERT INTO orders (user_id, total_amount) VALUES (:1, :2)", 
                       (user_id, total))
        conn.commit()  

        # Get the last inserted order_id
        cursor.execute("SELECT order_seq.CURRVAL FROM dual")
        order_id = cursor.fetchone()[0]
        print(f"Order ID: {order_id}")  

        cart = session.get('cart', {})

        for product_id, quantity in cart.items():
            cursor.execute("SELECT price, stock FROM products WHERE product_id = :1", (product_id,))
            product = cursor.fetchone()
            if not product:
                flash(f"Product ID {product_id} not found.", "danger")
                continue
            
            price, stock = product

            if stock >= quantity:
                cursor.execute("INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (:1, :2, :3, :4)",
                               (order_id, product_id, quantity, price))
                
                # Update stock in products table
                cursor.execute("UPDATE products SET stock = stock - :1 WHERE product_id = :2", (quantity, product_id))
            else:
                flash(f"Not enough stock for {product_id}. Only {stock} available.", "danger")
                return redirect('/cart')

        conn.commit()  # Commit the transaction to save changes
        session.pop('cart', None)  # Clear cart after successful payment
        flash("Your order has been placed successfully!", "success")
        return redirect(url_for("cart"))  # Redirect to payment success

    except cx_Oracle.DatabaseError as e:
        print(f"Database Error: {e}")
        flash("A database error occurred. Please try again later.", "danger")
        return redirect('/cart')

    finally:
        cursor.close()
        conn.close()

@app.route('/mock_payment', methods=['POST'])
def mock_payment():
    total = request.form.get('total')

    # Simulating success or failure
    payment_status = "Success"  # Change to "Failed" to simulate failure

    if payment_status == "Success":
        return redirect(url_for('payment_success', amount=total))
    else:
        return redirect(url_for('payment_failed'))


@app.route('/payment_success')
def payment_success():
    amount = request.args.get('amount', 0)
    return render_template('payment_success.html', amount=amount)



#  MOHENJO DARO PAGE
@app.route("/mohenjodaro")
def third():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT overview, history, architecture FROM heritage_site WHERE id = 1")
    result = cursor.fetchone()

    if result:
       
        overview = result[0].read() if result[0] else "No data available"
        history = result[1].read() if result[1] else "No data available"
        architecture = result[2].read() if result[2] else "No data available"
    else:
        overview, history, architecture = "No data available", "No data available", "No data available"

    cursor.close()
    conn.close()

    return render_template("mohenjodaro.html", overview=overview, history=history, architecture=architecture)



@app.route("/baltit")
def fourth():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT overview, history, architecture FROM heritage_site WHERE id = 9")
    result = cursor.fetchone()

    if result:
      
        overview = result[0].read() if result[0] else "No data available"
        history = result[1].read() if result[1] else "No data available"
        architecture = result[2].read() if result[2] else "No data available"
    else:
        overview, history, architecture = "No data available", "No data available", "No data available"

    cursor.close()
    conn.close()

    return render_template("baltit.html", overview=overview, history=history, architecture=architecture)

@app.route("/taxila")
def fifth():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT overview, history, architecture FROM heritage_site WHERE id = 2")
    result = cursor.fetchone()

    if result:
   
        overview = result[0].read() if result[0] else "No data available"
        history = result[1].read() if result[1] else "No data available"
        architecture = result[2].read() if result[2] else "No data available"
    else:
        overview, history, architecture = "No data available", "No data available", "No data available"

    cursor.close()
    conn.close()

    return render_template("taxila.html", overview=overview, history=history, architecture=architecture)



@app.route("/makli")
def sixth():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT overview, history, architecture FROM heritage_site WHERE id = 4")
    result = cursor.fetchone()

    if result:
      
        overview = result[0].read() if result[0] else "No data available"
        history = result[1].read() if result[1] else "No data available"
        architecture = result[2].read() if result[2] else "No data available"
    else:
        overview, history, architecture = "No data available", "No data available", "No data available"

    cursor.close()
    conn.close()

    return render_template("makli_graveyard.html", overview=overview, history=history, architecture=architecture)

@app.route("/mohatta")
def seventh():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT overview, history, architecture FROM heritage_site WHERE id = 6")
    result = cursor.fetchone()

    if result:
       
        overview = result[0].read() if result[0] else "No data available"
        history = result[1].read() if result[1] else "No data available"
        architecture = result[2].read() if result[2] else "No data available"
    else:
        overview, history, architecture = "No data available", "No data available", "No data available"

    cursor.close()
    conn.close()

    return render_template("mohatta.html", overview=overview, history=history, architecture=architecture)


@app.route("/shalimar")
def eigth():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT overview, history, architecture FROM heritage_site WHERE id = 10")
    result = cursor.fetchone()

    if result:
 
        overview = result[0].read() if result[0] else "No data available"
        history = result[1].read() if result[1] else "No data available"
        architecture = result[2].read() if result[2] else "No data available"
    else:
        overview, history, architecture = "No data available", "No data available", "No data available"

    cursor.close()
    conn.close()

    return render_template("shalimar.html", overview=overview, history=history, architecture=architecture)

@app.route("/rohtas")
def nine():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT overview, history, architecture FROM heritage_site WHERE id = 7")
    result = cursor.fetchone()

    if result:
        
        overview = result[0].read() if result[0] else "No data available"
        history = result[1].read() if result[1] else "No data available"
        architecture = result[2].read() if result[2] else "No data available"
    else:
        overview, history, architecture = "No data available", "No data available", "No data available"

    cursor.close()
    conn.close()

    return render_template("rohtas.html", overview=overview, history=history, architecture=architecture)



@app.route("/harappa")
def ten():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT overview, history, architecture FROM heritage_site WHERE id = 8")
    result = cursor.fetchone()

    if result:
       
        overview = result[0].read() if result[0] else "No data available"
        history = result[1].read() if result[1] else "No data available"
        architecture = result[2].read() if result[2] else "No data available"
    else:
        overview, history, architecture = "No data available", "No data available", "No data available"

    cursor.close()
    conn.close()

    return render_template("harappa.html", overview=overview, history=history, architecture=architecture)


@app.route("/hiran")
def eleven():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT overview, history, architecture FROM heritage_site WHERE id = 3")
    result = cursor.fetchone()

    if result:
     
        overview = result[0].read() if result[0] else "No data available"
        history = result[1].read() if result[1] else "No data available"
        architecture = result[2].read() if result[2] else "No data available"
    else:
        overview, history, architecture = "No data available", "No data available", "No data available"

    cursor.close()
    conn.close()

    return render_template("hiran.html", overview=overview, history=history, architecture=architecture)


# Route to fetch an image from the database
@app.route("/get_image")
def get_image():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT image_data FROM media WHERE id = 3")
    result = cursor.fetchone()

    if result and result[0]:  
        image_blob = result[0].read()  
    else:
        return "No image found", 404

    cursor.close()
    conn.close()

    return send_file(io.BytesIO(image_blob), mimetype="image/jpeg")




@app.route("/baltit_image")
def get_baltitimage():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT image_data FROM media WHERE id = 9")
    result = cursor.fetchone()

    if result and result[0]:  
        image_blob = result[0].read()  
    else:
        return "No image found", 404

    cursor.close()
    conn.close()

    return send_file(io.BytesIO(image_blob), mimetype="image/jpeg")


@app.route("/taxila_image")
def get_taxilaimage():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT image_data FROM media WHERE id = 2")
    result = cursor.fetchone()

    if result and result[0]:  
        image_blob = result[0].read()  
    else:
        return "No image found", 404

    cursor.close()
    conn.close()

    return send_file(io.BytesIO(image_blob), mimetype="image/jpeg")



@app.route("/makli_image")
def get_makliimage():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT image_data FROM media WHERE id = 4")
    result = cursor.fetchone()

    if result and result[0]:  
        image_blob = result[0].read()  
    else:
        return "No image found", 404

    cursor.close()
    conn.close()

    return send_file(io.BytesIO(image_blob), mimetype="image/jpeg")

@app.route("/mohatta_image")
def get_mohattaimage():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT image_data FROM media WHERE id = 6")
    result = cursor.fetchone()

    if result and result[0]:  
        image_blob = result[0].read()  
    else:
        return "No image found", 404

    cursor.close()
    conn.close()

    return send_file(io.BytesIO(image_blob), mimetype="image/jpeg")


@app.route("/rohtas_image")
def get_rohtasimage():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT image_data FROM media WHERE id = 7")
    result = cursor.fetchone()

    if result and result[0]:  
        image_blob = result[0].read()  
    else:
        return "No image found", 404

    cursor.close()
    conn.close()

    return send_file(io.BytesIO(image_blob), mimetype="image/jpeg")


@app.route("/harappa_image")
def get_harappaimage():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT image_data FROM media WHERE id = 8")
    result = cursor.fetchone()

    if result and result[0]:  
        image_blob = result[0].read()  
    else:
        return "No image found", 404

    cursor.close()
    conn.close()

    return send_file(io.BytesIO(image_blob), mimetype="image/jpeg")

@app.route("/hiran_image")
def get_hiranimage():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT image_data FROM media WHERE id = 1")
    result = cursor.fetchone()

    if result and result[0]:  
        image_blob = result[0].read()  
    else:
        return "No image found", 404

    cursor.close()
    conn.close()

    return send_file(io.BytesIO(image_blob), mimetype="image/jpeg")



@app.route("/shalimar_image")
def get_shalimarimage():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT image_data FROM media WHERE id = 5")
    result = cursor.fetchone()

    if result and result[0]:  
        image_blob = result[0].read()  
    else:
        return "No image found", 404

    cursor.close()
    conn.close()

    return send_file(io.BytesIO(image_blob), mimetype="image/jpeg")






# VISITOR LOGGING
@app.route('/api/log-visit', methods=['POST'])
def log_visit():
    data = request.json
    user_id = data.get("user_id")

    if not user_id:
        return jsonify({"error": "User ID is required"}), 400

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("INSERT INTO visitor_logs (log_id, user_id, login_time) VALUES (visitor_seq.NEXTVAL, :user_id, SYSTIMESTAMP)", {"user_id": user_id})
        conn.commit()
        return jsonify({"message": "Visit logged successfully"})

    except cx_Oracle.DatabaseError as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()



# API to fetch visitor analytics
@app.route('/api/visitor-analytics', methods=['GET'])
def get_visitor_analytics():
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("SELECT TO_CHAR(login_time, 'YYYY-MM-DD'), COUNT(*) FROM visitor_logs GROUP BY TO_CHAR(login_time, 'YYYY-MM-DD') ORDER BY TO_CHAR(login_time, 'YYYY-MM-DD')")
        data = cursor.fetchall()
        
        analytics = [{"date": date, "count": count} for date, count in data]

        return jsonify(analytics)  

    except cx_Oracle.DatabaseError as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()



@app.route('/api/visitors-per-site', methods=['GET'])
def visitors_per_site():
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("""
            SELECT h.name, COUNT(v.log_id) 
            FROM visitor_logs v
            JOIN heritage_site h ON v.site_id = h.id
            GROUP BY h.name
            ORDER BY COUNT(v.log_id) DESC
        """)
        data = cursor.fetchall()

        analytics = [{"site_name": row[0], "visitor_count": row[1]} for row in data]

        return jsonify(analytics)

    except cx_Oracle.DatabaseError as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


@app.route('/api/weekly-visitors', methods=['GET'])
def weekly_visitors():
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("""
            SELECT h.name, COUNT(v.log_id) 
            FROM visitor_logs v
            JOIN heritage_site h ON v.site_id = h.id
            WHERE v.visit_date >= TRUNC(SYSDATE, 'IW')  -- Start of this week
            GROUP BY h.name
            ORDER BY COUNT(v.log_id) DESC
        """)
        data = cursor.fetchall()

        weekly_visits = [{"site_name": row[0], "visitor_count": row[1]} for row in data]
        return jsonify(weekly_visits)

    except cx_Oracle.DatabaseError as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()



@app.route('/api/monthly-visitors', methods=['GET'])
def monthly_visitors():
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("""
            SELECT h.name, COUNT(v.log_id) 
            FROM visitor_logs v
            JOIN heritage_site h ON v.site_id = h.id
            WHERE v.visit_date >= TRUNC(SYSDATE, 'MM')  -- Start of this month
            GROUP BY h.name
            ORDER BY COUNT(v.log_id) DESC
        """)
        data = cursor.fetchall()

        monthly_visits = [{"site_name": row[0], "visitor_count": row[1]} for row in data]
        return jsonify(monthly_visits)

    except cx_Oracle.DatabaseError as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


@app.route('/export-visitors', methods=['GET'])
def export_visitors():
    conn = get_db_connection()
    cursor = conn.cursor()

    
    cursor.execute("SELECT USER_ID, SITE_ID, VISIT_DATE FROM visitor_logs")
    data = cursor.fetchall()

    df = pd.DataFrame(data, columns=["User ID", "Site ID", "Visit Date"])

    output = io.BytesIO()
    with pd.ExcelWriter(output, engine="xlsxwriter") as writer:
        df.to_excel(writer, index=False, sheet_name="Visitor Data")

    output.seek(0)

    return send_file(
        output,
        mimetype="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        as_attachment=True,
        download_name="visitor_data.xlsx"
    )



if __name__ == "__main__":
    app.run(debug=True)
