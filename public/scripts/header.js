let burgerMenuButton = document.querySelector(".burger-menu-button");

burgerMenuButton.addEventListener("click", () => {
    document.querySelector(".nav-toggled-menu").classList.toggle("toggled");
    document.querySelector(".burger-menu-button").classList.toggle("toggled");
});