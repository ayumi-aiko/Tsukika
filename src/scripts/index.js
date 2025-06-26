// Toggle hamburger menu
function toggleMenu() {
    document.getElementById('sideMenu').classList.toggle('open');
}

// Close menu when clicking outside
document.addEventListener('click', function (event) {
    const menu = document.getElementById('sideMenu');
    const button = document.querySelector('.hamburger-menu');
    const isClickInsideMenu = menu.contains(event.target);
    const isClickOnButton = button.contains(event.target);
    if(!isClickInsideMenu && !isClickOnButton) {
        menu.classList.remove('open');
    }
});