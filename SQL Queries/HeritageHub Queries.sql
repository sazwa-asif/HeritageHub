                                                --HeritageHub SQL QUERIES



                                                --INFORMATION SITE PAGE QUERIES
    
-- Media Table Creation
Create Table Media (id Number primary key, image_name varchar2(255), image_data blob);


--Directory Creation
Create directory image_dir as 'D:\NED UNI\semester 4\DBMS\DBMS HERITAGE PROJECT\Heritage Project\Media';


--Grant Access
grant read on directory image_dir to public;

--Replace Directory
REPLACE DIRECTORY IMAGE_DIR AS 'D:\NED UNI\semester 4\DBMS\DBMS HERITAGE PROJECT\Heritage Project\Backend\static\images';


-- Media Table Entry

--Hiran Minar
DECLARE
img BLOB;
file_loc BFILE;
dest_offset NUMBER := 1;
src_offset NUMBER := 1;
BEGIN
file_loc := BFILENAME('IMAGE_DIR', 'hiran.jpg');
DBMS_LOB.OPEN(file_loc, DBMS_LOB.LOB_READONLY);
INSERT INTO media (id, image_name, image_data)
VALUES (1, 'Sample Image', EMPTY_BLOB())
RETURNING image_data INTO img;
DBMS_LOB.LOADFROMFILE(img, file_loc, DBMS_LOB.GETLENGTH(file_loc));
DBMS_LOB.CLOSE(file_loc);
COMMIT;
END;
/


--Mohenjo Daro
DECLARE
img BLOB;
file_loc BFILE;
dest_offset NUMBER := 1;
src_offset NUMBER := 1;
BEGIN
file_loc := BFILENAME('IMAGE_DIR', 'mohenjo_daro.jpg');
DBMS_LOB.OPEN(file_loc, DBMS_LOB.LOB_READONLY);
INSERT INTO media (id, image_name, image_data)
VALUES (1, 'Sample Image', EMPTY_BLOB())
RETURNING image_data INTO img;
DBMS_LOB.LOADFROMFILE(img, file_loc, DBMS_LOB.GETLENGTH(file_loc));
DBMS_LOB.CLOSE(file_loc);
COMMIT;
END;
/


--Shalimar Garden
DECLARE
img BLOB;
file_loc BFILE;
BEGIN
file_loc := BFILENAME('IMAGE_DIR', 'shalimar.jpg');
DBMS_LOB.OPEN(file_loc, DBMS_LOB.LOB_READONLY);
INSERT INTO media (id, image_name, image_data)
VALUES (5, 'Shalimar Garden', EMPTY_BLOB())
RETURNING image_data INTO img;
DBMS_LOB.LOADFROMFILE(img, file_loc, DBMS_LOB.GETLENGTH(file_loc));
DBMS_LOB.CLOSE(file_loc);
COMMIT;
END;
/



--Makli Graveyard
DECLARE
img BLOB;
file_loc BFILE;
BEGIN
file_loc := BFILENAME('IMAGE_DIR', 'makli_graveyard.jpg');
DBMS_LOB.OPEN(file_loc, DBMS_LOB.LOB_READONLY);
INSERT INTO media (id, image_name, image_data)
VALUES (4, 'Makli Graveyard', EMPTY_BLOB())
RETURNING image_data INTO img;
DBMS_LOB.LOADFROMFILE(img, file_loc, DBMS_LOB.GETLENGTH(file_loc));
DBMS_LOB.CLOSE(file_loc);
COMMIT;
END;
/


--Mohatta Palace
DECLARE
img BLOB;
file_loc BFILE;
BEGIN
file_loc := BFILENAME('IMAGE_DIR', 'mohatta.jpg');
DBMS_LOB.OPEN(file_loc, DBMS_LOB.LOB_READONLY);
INSERT INTO media (id, image_name, image_data)
VALUES (6, 'Mohatta Palace', EMPTY_BLOB())
RETURNING image_data INTO img;
DBMS_LOB.LOADFROMFILE(img, file_loc, DBMS_LOB.GETLENGTH(file_loc));
DBMS_LOB.CLOSE(file_loc);
COMMIT;
END;
/


--Taxila
DECLARE
img BLOB;
file_loc BFILE;
BEGIN
file_loc := BFILENAME('IMAGE_DIR', 'taxila.jpg');
DBMS_LOB.OPEN(file_loc, DBMS_LOB.LOB_READONLY);
INSERT INTO media (id, image_name, image_data)
VALUES (2, 'Hiran Minar', EMPTY_BLOB())
RETURNING image_data INTO img;
DBMS_LOB.LOADFROMFILE(img, file_loc, DBMS_LOB.GETLENGTH(file_loc));
DBMS_LOB.CLOSE(file_loc);
COMMIT;
END;
/


--Rohtas Fort
DECLARE
img BLOB;
file_loc BFILE;
BEGIN
file_loc := BFILENAME('IMAGE_DIR', 'rohtas.jpg');
DBMS_LOB.OPEN(file_loc, DBMS_LOB.LOB_READONLY);
INSERT INTO media (id, image_name, image_data)
VALUES (7, 'Rohtas Fort', EMPTY_BLOB())
RETURNING image_data INTO img;
DBMS_LOB.LOADFROMFILE(img, file_loc, DBMS_LOB.GETLENGTH(file_loc));
DBMS_LOB.CLOSE(file_loc);
COMMIT;
END;
/



--Harappa
DECLARE
img BLOB;
file_loc BFILE;
BEGIN
file_loc := BFILENAME('IMAGE_DIR', 'harappa.jpg');
DBMS_LOB.OPEN(file_loc, DBMS_LOB.LOB_READONLY);
INSERT INTO media (id, image_name, image_data)
VALUES (8, 'Rohtas Fort', EMPTY_BLOB())
RETURNING image_data INTO img;
DBMS_LOB.LOADFROMFILE(img, file_loc, DBMS_LOB.GETLENGTH(file_loc));
DBMS_LOB.CLOSE(file_loc);
COMMIT;
END;
/



--Baltit Fort
DECLARE
img BLOB;
file_loc BFILE;
BEGIN
file_loc := BFILENAME('IMAGE_DIR', 'baltit.jpg');
DBMS_LOB.OPEN(file_loc, DBMS_LOB.LOB_READONLY);
INSERT INTO media (id, image_name, image_data)
VALUES (9, 'Baltit Fort', EMPTY_BLOB())
RETURNING image_data INTO img;
DBMS_LOB.LOADFROMFILE(img, file_loc, DBMS_LOB.GETLENGTH(file_loc));
DBMS_LOB.CLOSE(file_loc);
COMMIT;
END;
/


--CHECK IMAGE ENTRY
select id, image_name, dbms_LOB.GETLENGTH(image_data) as image_size from media;




--HERITAGE TABLE CREATION
CREATE TABLE heritage_site (id INT PRIMARY KEY,    name VARCHAR(255),    overview CLOB,    history CLOB,    architecture CLOB);



--HERITAGE TABLE ENTRY


--Mohenjo Daro
INSERT INTO heritage_site (id, name, overview, history, architecture) VALUES (1, 'Mohenjo-daro',
TO_CLOB('Mohenjo-daro, meaning "Mound of the Dead," is one of the most significant archaeological sites of the ancient Indus Valley Civilization, located in present-day Sindh, Pakistan. Dating back to around 2500 BCE, it was one of the earliest major urban centers in human history. The city was a hub of commerce, trade, and culture, demonstrating a high level of urban planning and engineering sophistication.'),
TO_CLOB('Mohenjo-daro was built around 2500 BCE and remained one of the most significant cities of the Indus Valley Civilization for several centuries. The city reached its peak between 2600 and 1900 BCE, serving as a major administrative, economic, and cultural center.'),
TO_CLOB('Mohenjo-daro is an extraordinary example of early urban planning and civil engineering. The city was divided into two major areas: the Citadel and the Lower Town. The Citadel, located on a raised platform, housed important structures, including the Great Bath, large assembly halls, and possible administrative buildings.')
);
COMMIT;


--Taxila
INSERT INTO heritage_site (id, name, overview, history, architecture)
VALUES
(2, 'Taxila',
TO_CLOB('Taxila is an ancient city in modern-day Pakistan that served as a major center for Buddhist learning and trade. The city''s ruins showcase a blend of Greek, Persian, and Indian cultural influences, reflecting its historical importance.'),
TO_CLOB('Taxila dates back to around 1000 BCE and flourished under various rulers, including the Achaemenid Empire, Alexander the Great, and the Maurya and Kushan dynasties. The city became a renowned center for education, attracting scholars from across Asia.'),
TO_CLOB('The ruins of Taxila feature well-planned monasteries, stupas, and a sophisticated urban layout. The Dharmarajika Stupa and Jaulian monastery are notable examples of Buddhist architecture, demonstrating the region''s religious and artistic achievements.')
);
COMMIT;


--Hiran Minar
INSERT INTO heritage_site (id, name, overview, history, architecture)
VALUES
(3, 'Hiran Minar',
TO_CLOB('Hiran Minar is a Mughal-era complex in Sheikhupura, Pakistan, built by Emperor Jahangir in memory of his beloved pet deer, Mansraj. The site reflects the Mughal love for nature and architecture. It consists of a tall minaret, a water tank, and a baradari (pavilion) surrounded by a picturesque landscape.'),
TO_CLOB('Constructed in 1606, Hiran Minar was initially designed as a hunting retreat for Jahangir. The site was later expanded to include a large water reservoir, allowing Mughal royals to enjoy the tranquility of nature while resting at the pavilion. The minaret served as a landmark for travelers and hunters.'),
TO_CLOB('The architectural style of Hiran Minar features a circular minaret with calligraphic inscriptions, a baradari with finely carved arches, and a symmetrical water reservoir with a unique rainwater collection system. The structure reflects Mughal engineering and their deep appreciation for aesthetics.')
);
COMMIT;



--Makli Graveyard
INSERT INTO heritage_site (id, name, overview, history, architecture)
VALUES
(4, 'Makli Graveyard',
TO_CLOB('Makli Necropolis, one of the world''s largest funerary sites, is located in Thatta, Pakistan. It spans over 10 square kilometers and contains elaborate tombs of rulers, scholars, and saints, showcasing a blend of Islamic, Persian, and Hindu architectural styles.'),
TO_CLOB('Makli Graveyard dates back to the 14th century and served as the final resting place for many rulers of Sindh. It remained a prominent burial site for nearly 400 years, reflecting the region''s rich cultural and political history.'),
TO_CLOB('The architecture at Makli features intricate stone carvings, domed mausoleums, and grand entrance gates. The tombs of Jam Nizamuddin and Isa Khan Tarkhan are among the most famous, highlighting the artistic craftsmanship of the time.')
);
COMMIT;


--Mohatta Palace
IINSERT INTO heritage_site (id, name, overview, history, architecture)
VALUES
(6, 'Mohatta Palace',
TO_CLOB('The Mohatta Palace is a magnificent heritage building located in Karachi, Pakistan. Built in 1927 by Shivratan Chandraratan Mohatta, a prominent Hindu businessman, the palace is known for its exquisite Rajput and Mughal architectural influences. Today, it serves as a museum showcasing Pakistan''s rich cultural and artistic history.'),
TO_CLOB('Mohatta Palace was originally built as a summer home for Shivratan Mohatta and his family. However, after the partition of India in 1947, the palace was acquired by the Government of Pakistan and later transformed into a museum. It has since been used for various cultural and artistic exhibitions.'),
TO_CLOB('The palace is constructed using pink Jodhpur stone and local yellow stone from Gizri, giving it a striking contrast. It features intricate jharokhas (overhanging enclosed balconies), domes, and carved windows. The grand interiors include marble staircases, spacious halls, and a beautiful rooftop terrace that offers stunning views of the city.')
);
COMMIT;


--Rohtas Fort
INSERT INTO heritage_site (id, name, overview, history, architecture)
VALUES
(7, 'Rohtas Fort',
TO_CLOB('Rohtas Fort, built by Sher Shah Suri in the 16th century, is a UNESCO World Heritage Site known for its massive defensive walls and strategic location. It was designed to serve as a military stronghold against the Mughal emperor Humayun.'),
TO_CLOB('Construction of Rohtas Fort began in 1541 CE under Sher Shah Suri, who sought to secure his rule by controlling key trade and military routes. The fort remained a significant defensive structure throughout the Mughal and British colonial periods.'),
TO_CLOB('Rohtas Fort is an architectural marvel, featuring a 4-kilometer-long perimeter with 12 grand gates, intricate stone carvings, and functional elements like barracks and water reservoirs. The Sohail Gate and Haveli Man Singh are among its notable structures.')
);
COMMIT;


--Harappa
INSERT INTO heritage_site (id, name, overview, history, architecture)
VALUES
(8, 'Harappa',
TO_CLOB('Harappa, along with Mohenjo-daro, was one of the principal cities of the Indus Valley Civilization. Located in Punjab, Pakistan, Harappa was a well-planned urban settlement, known for its advanced drainage systems and granaries.'),
TO_CLOB('Harappa flourished between 2600 and 1900 BCE, serving as a major trade and agricultural center. Archaeological discoveries suggest that it was home to a sophisticated society with standardized weights, seals, and writing scripts.'),
TO_CLOB('The city''s architecture includes well-planned streets, multi-roomed houses made of baked bricks, and large communal granaries. The presence of a fortified citadel and a marketplace suggests a highly organized urban life.')
);
COMMIT;


--Shalimar Garden
INSERT INTO heritage_site (id, name, overview, history, architecture)
VALUES
(10, 'Shalimar Garden',
TO_CLOB('Shalimar Garden is a stunning Mughal-era garden located in Lahore, Pakistan. Built during the reign of Emperor Shah Jahan in 1641, it is one of the finest examples of Persian-style garden design in the Indian subcontinent. The garden is renowned for its intricate landscaping, flowing water channels, and historical significance.'),
TO_CLOB('The construction of Shalimar Garden began in 1641 under the supervision of Shah Jahan''s noblemen. It was influenced by the Persian concept of paradise gardens, incorporating terraced levels, fountains, and lush greenery. The garden served as a retreat for Mughal royalty and a venue for grand festivities.'),
TO_CLOB('Shalimar Garden is structured in three terraces, each serving a different purpose. The first terrace, ''Farah Baksh'' (Bestower of Pleasure), features large pools and fountains. The second, ''Faiz Baksh'' (Bestower of Goodness), consists of elegant pavilions and lush floral arrangements. The third, ''Hayat Baksh'' (Bestower of Life), contains smaller waterfalls and resting areas, creating a harmonious blend of nature and architecture.')
);
COMMIT;


                                                -- USER REGISTRATION PAGE


--CREATION OF USER REGISTRATION TABLE
CREATE TABLE user_registration ( user_id INT PRIMARY KEY,  username VARCHAR2(25) NOT NULL,  email VARCHAR2(100) NOT NULL UNIQUE,    password VARCHAR2(255) NOT NULL);


--TABLE ALTER
ALTER TABLE user_registration DROP COLUMN EMAIL;
ALTER TABLE user_registration ADD CONSTRAINT unique_username UNIQUE (USERNAME);


-- TRIGGER CREATION
CREATE OR REPLACE TRIGGER trg_user_id
BEFORE INSERT ON user_registration
FOR EACH ROW
BEGIN
   :NEW.user_id := user_id_seq.NEXTVAL;
END;
 /


--CREATE SEQUENCE
CREATE SEQUENCE user_id_seq   START WITH 1  INCREMENT BY 1 NOCACHE;

--CHECK SEQUENCE
SELECT sequence_name FROM user_sequences WHERE sequence_name = 'USER_ID_SEQ';

--INSERT INTO REGISTRATION TABLE
Insert into user_registration(user_id,username,password) VALUES (1,'test user','test password');
COMMIT;


--CHECK INSERTION
select * from user_registration;


                                                        --SOUVINIER SHOP PAGE

--CREATE PRODUCT TABLE
CREATE TABLE products (
product_id NUMBER PRIMARY KEY,
name VARCHAR2(255),
description VARCHAR2(1000),
price NUMBER(10,2),
stock NUMBER,
image_url VARCHAR2(500)
);


--ALTER PRODUCT TABLE
ALTER TABLE products DROP COLUMN image_url;
ALTER TABLE products ADD image_data BLOB;


--CREATE ORDER TABLE
CREATE TABLE orders (
order_id NUMBER PRIMARY KEY,
user_id NUMBER,
total_amount NUMBER(10,2),
status VARCHAR2(50) DEFAULT 'Pending',
FOREIGN KEY (user_id) REFERENCES user_registration(user_id)
);


--CREATE ORDER ITEM TABLE
CREATE TABLE order_items (
order_item_id NUMBER PRIMARY KEY,
order_id NUMBER,
product_id NUMBER,
quantity NUMBER,
price NUMBER(10,2),
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);


--CREATE SEQUENCE FOR ALL 3 TABLE

--PRODUCT SEQUENCE
CREATE SEQUENCE product_seq START WITH 1 INCREMENT BY 1;

--ORDER SEQUENCE
CREATE SEQUENCE order_seq START WITH 1 INCREMENT BY 1;

--ORDER ITEM SEQUENCE
CREATE SEQUENCE order_item_seq START WITH 1 INCREMENT BY 1;


--PRODUCT TRIGGER
CREATE OR REPLACE TRIGGER product_trigger
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
SELECT product_seq.NEXTVAL INTO :NEW.product_id FROM DUAL;
END;
/


--ORDER TRIGGER
CREATE OR REPLACE TRIGGER order_trigger
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
SELECT order_seq.NEXTVAL INTO :NEW.order_id FROM DUAL;
END;
/


--ORDER ITEM TRIGGER
CREATE OR REPLACE TRIGGER order_item_trigger
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
SELECT order_item_seq.NEXTVAL INTO :NEW.order_item_id FROM DUAL;
END;
/


--JOIN QUERY FOR ORDER DETAILS
SELECT o.order_id, u.username, p.name, oi.quantity, oi.priceFROM orders oJOIN user_registration u ON o.user_id = u.user_idJOIN order_items oi ON o.order_id = oi.order_idJOIN products p ON oi.product_id = p.product_id;


--INSERTION INTO PRODUCT TABLE
IMAGE 1
DECLARE
img BLOB;
file_loc BFILE;
BEGIN

file_loc := BFILENAME('IMAGE_DIR', 'shop1.jpg');
DBMS_LOB.OPEN(file_loc, DBMS_LOB.LOB_READONLY);

INSERT INTO products (product_id, name, description, price, stock, image_data)
VALUES (1, 'Priest Sculpture',
'A bust portrait of a bearded nobleman or high priest in sandstone',
1200, 10, EMPTY_BLOB())
RETURNING image_data INTO img;

DBMS_LOB.LOADFROMFILE(img, file_loc, DBMS_LOB.GETLENGTH(file_loc));
DBMS_LOB.CLOSE(file_loc);
COMMIT;
END;
/



--IMAGE 2
DECLARE
img BLOB;
file_loc BFILE;
BEGIN
file_loc := BFILENAME('IMAGE_DIR', 'shop2.jpg');
DBMS_LOB.OPEN(file_loc, DBMS_LOB.LOB_READONLY);
INSERT INTO products (product_id, name, description, price, stock, image_data)
VALUES (2, 'Terracotta Figure',
'Terracotta figures made of fire-baked clay, handcrafted using the pinching method',
1999, 10, EMPTY_BLOB())
RETURNING image_data INTO img;
DBMS_LOB.LOADFROMFILE(img, file_loc, DBMS_LOB.GETLENGTH(file_loc));
DBMS_LOB.CLOSE(file_loc);
COMMIT;
END;
/



--IMAGE 3
DECLARE
img BLOB;
file_loc BFILE;
BEGIN
file_loc := BFILENAME('IMAGE_DIR', 'shop3.jpg');
DBMS_LOB.OPEN(file_loc, DBMS_LOB.LOB_READONLY);
INSERT INTO products (product_id, name, description, price, stock, image_data)
VALUES (3, 'Terracotta Figure',
'Terracotta figures made of fire-baked clay, handcrafted using the pinching method',
1499, 10, EMPTY_BLOB())
RETURNING image_data INTO img;
DBMS_LOB.LOADFROMFILE(img, file_loc, DBMS_LOB.GETLENGTH(file_loc));
DBMS_LOB.CLOSE(file_loc);
COMMIT;
END;
/


--IMAGE 4
DECLARE
img BLOB;
file_loc BFILE;
BEGIN
file_loc := BFILENAME('IMAGE_DIR', 'shop4.jpg');
DBMS_LOB.OPEN(file_loc, DBMS_LOB.LOB_READONLY);
INSERT INTO products (product_id, name, description, price, stock, image_data)
VALUES (4, 'Seals',
'Seals made of terracotta and soapstone with the motifs of animals, human figure, and god',
800, 10, EMPTY_BLOB())
RETURNING image_data INTO img;
DBMS_LOB.LOADFROMFILE(img, file_loc, DBMS_LOB.GETLENGTH(file_loc));
DBMS_LOB.CLOSE(file_loc);
COMMIT;
END;
/



--IMAGE 5
DECLARE
img BLOB;
file_loc BFILE;
BEGIN
file_loc := BFILENAME('IMAGE_DIR', 'shop5.jpg');
DBMS_LOB.OPEN(file_loc, DBMS_LOB.LOB_READONLY);
INSERT INTO products (product_id, name, description, price, stock, image_data)
VALUES (5, 'Seals',
'Seals made of terracotta and soapstone with the motifs of animals',
650, 10, EMPTY_BLOB())
RETURNING image_data INTO img;
DBMS_LOB.LOADFROMFILE(img, file_loc, DBMS_LOB.GETLENGTH(file_loc));
DBMS_LOB.CLOSE(file_loc);
COMMIT;
END;
/



--IMAGE 6
DECLARE
img BLOB;
file_loc BFILE;
BEGIN
file_loc := BFILENAME('IMAGE_DIR', 'shop6.jpg');
DBMS_LOB.OPEN(file_loc, DBMS_LOB.LOB_READONLY);
INSERT INTO products (product_id, name, description, price, stock, image_data)
VALUES (6, 'Terracotta Figure',
'Terracotta bird made of fire-baked clay, handcrafted using the pinching method',
1399, 10, EMPTY_BLOB())
RETURNING image_data INTO img;
DBMS_LOB.LOADFROMFILE(img, file_loc, DBMS_LOB.GETLENGTH(file_loc));
DBMS_LOB.CLOSE(file_loc);
COMMIT;
END;
/



                                                            --FEEDBACK PAGE

--FEEDBACK TABLE CREATION
CREATE TABLE feedback (
feedback_id NUMBER PRIMARY KEY,
user_id INT NOT NULL,
message CLOB,
FOREIGN KEY (user_id) REFERENCES user_registration(user_id) ON DELETE CASCADE
);


--FEEDBACK SEQUENCE
CREATE SEQUENCE feedback_seq
START WITH 1
INCREMENT BY 1;


--FEEDBACK TRIGGER
CREATE OR REPLACE TRIGGER feedback_trigger
BEFORE INSERT ON feedback
FOR EACH ROW
BEGIN
IF :NEW.feedback_id IS NULL THEN
SELECT feedback_seq.NEXTVAL INTO :NEW.feedback_id FROM DUAL;
END IF;
END;
/



                                                        --VISITOR ANALYTICS
--CREATE VISITOR TABLE
CREATE TABLE visitor_logs (
log_id NUMBER PRIMARY KEY,
user_id NUMBER NOT NULL,
login_time TIMESTAMP DEFAULT SYSTIMESTAMP
);



--VISITOR SEQUENCE
CREATE SEQUENCE visitor_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;


--VISITOR TRIGGER
CREATE OR REPLACE TRIGGER visitor_logs_trigger
BEFORE INSERT ON visitor_logs
FOR EACH ROW
BEGIN
SELECT visitor_seq.NEXTVAL INTO :NEW.log_id FROM DUAL;
END;
/



--ALTER TABLE
ALTER TABLE visitor_logs
ADD CONSTRAINT fk_visitor_user FOREIGN KEY (user_id)
REFERENCES user_registration(user_id) ON DELETE CASCADE;



--INSERTION IN TABLE
INSERT INTO visitor_logs (user_id) VALUES (1);
COMMIT;



--ALTER TABLE AGAIN
ALTER TABLE visitor_logs ADD site_id NUMBER REFERENCES heritage_site(id);
ALTER TABLE visitor_logs RENAME COLUMN login_time TO visit_date;
ALTER TABLE visitor_logs DROP CONSTRAINT fk_visitor_user;
ALTER TABLE visitor_logs MODIFY user_id NULL;



--INSERTION
(  Sites range from 1 to 10  User IDs go from 101 to 122)
INSERT INTO visitor_logs (user_id, site_id, visit_date) VALUES (NULL, 1, TO_DATE('2024-03-01', 'YYYY-MM-DD'));
INSERT INTO visitor_logs (user_id, site_id, visit_date) VALUES (NULL, 1, TO_DATE('2024-03-02', 'YYYY-MM-DD'));
INSERT INTO visitor_logs (user_id, site_id, visit_date) VALUES (NULL, 2, TO_DATE('2024-03-05', 'YYYY-MM-DD'));
INSERT INTO visitor_logs (user_id, site_id, visit_date) VALUES (NULL, 4, TO_DATE('2024-03-04', 'YYYY-MM-DD'));
INSERT INTO visitor_logs (user_id, site_id, visit_date) VALUES (NULL, 10, TO_DATE('2024-03-06', 'YYYY-MM-DD'));
INSERT INTO visitor_logs (user_id, site_id, visit_date) VALUES (NULL, 7, TO_DATE('2024-03-06', 'YYYY-MM-DD'));
INSERT INTO visitor_logs (user_id, site_id, visit_date) VALUES (NULL, 8, TO_DATE('2024-03-07', 'YYYY-MM-DD'));
INSERT INTO visitor_logs (user_id, site_id, visit_date) VALUES (NULL, 3, TO_DATE('2024-03-07', 'YYYY-MM-DD'));
INSERT INTO visitor_logs (user_id, site_id, visit_date) VALUES (NULL, 1, TO_DATE('2025-03-19 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (101, 1, TO_DATE('2025-03-19 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (102, 2, TO_DATE('2025-03-19 12:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (103, 3, TO_DATE('2025-03-20 14:15:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (104, 4, TO_DATE('2025-03-21 16:45:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (105, 1, TO_DATE('2025-03-22 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (106, 2, TO_DATE('2025-03-22 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (107, 3, TO_DATE('2025-03-23 13:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (108, 4, TO_DATE('2025-03-24 18:05:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (109, 5, TO_DATE('2025-03-25 15:10:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)   VALUES (110, 6, TO_DATE('2025-03-26 17:45:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (111, 7, TO_DATE('2025-03-27 19:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (112, 1, TO_DATE('2025-03-28 11:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (113, 2, TO_DATE('2025-03-29 13:50:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (114, 3, TO_DATE('2025-03-30 08:40:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (115, 4, TO_DATE('2025-03-31 10:10:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)   VALUES (116, 1, TO_DATE('2025-04-01 09:30:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (117, 2, TO_DATE('2025-04-02 14:45:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (118, 3, TO_DATE('2025-04-03 11:15:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (119, 4, TO_DATE('2025-04-04 16:20:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (120, 7, TO_DATE('2025-04-05 10:50:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (121, 8, TO_DATE('2025-04-06 13:35:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO visitor_logs (user_id, site_id, visit_date)    VALUES (122, 10, TO_DATE('2025-04-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));
COMMIT;