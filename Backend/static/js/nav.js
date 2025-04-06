
document.addEventListener("DOMContentLoaded", function () {
    fetch("/load_navbar")
        .then(response => response.text())
        .then(data => {
            document.getElementById("nav-container").innerHTML = data;
            
            initializeSidebar();
        })
        .catch(error => console.error("Error loading navbar:", error));
});

function initializeSidebar() {
    const sidebar = document.getElementById("sidebar");
    const openMenu = document.getElementById("openMenu");
    const closeMenu = document.getElementById("closeMenu");

    if (openMenu && closeMenu && sidebar) {
        openMenu.addEventListener("click", function () {
            sidebar.classList.add("active"); 
        });

        closeMenu.addEventListener("click", function () {
            sidebar.classList.remove("active"); 
        });

        document.addEventListener("click", function (event) {
            if (!sidebar.contains(event.target) && !openMenu.contains(event.target)) {
                sidebar.classList.remove("active");
            }
        });
    } else {
        console.error("Sidebar elements not found!");
    }
}

