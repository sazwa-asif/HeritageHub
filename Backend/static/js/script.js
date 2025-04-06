
let prevScrollPos = window.scrollY;

window.onscroll = function () {
    let currentScrollPos = window.scrollY;
    
    if (prevScrollPos > currentScrollPos) {
        document.getElementById("nav").classList.remove("hidden");
    } else {
        document.getElementById("nav").classList.add("hidden");
    }
    
    prevScrollPos = currentScrollPos;
};