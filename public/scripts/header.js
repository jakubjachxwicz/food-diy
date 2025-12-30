const burgerMenuButton = document.querySelector(".burger-menu-button");

const popularRecipesButton = document.querySelector("#popularRecipesButton");
const recipeCategoriesButton = document.querySelector("#recipeCategoriesButton");
const recipeTagsButton = document.querySelector("#recipeTagsButton");
const searchRecipesButton = document.querySelector("#searchRecipesButton");
const addRecipeButton = document.querySelector("#addRecipeButton");
const accountButton = document.querySelector("#accountButton");

const popularNavButton = document.querySelector("#popularNavButton");
const categoriesNavButton = document.querySelector("#categoriesNavButton");
const tagsNavButton = document.querySelector("#tagsNavButton");
const searchNavButton = document.querySelector("#searchNavButton");

burgerMenuButton.addEventListener("click", () => {
    document.querySelector(".nav-toggled-menu").classList.toggle("toggled");
    document.querySelector(".burger-menu-button").classList.toggle("toggled");
});

popularRecipesButton.addEventListener("click", () => location.replace("/recipes?list=popular"));
recipeCategoriesButton.addEventListener("click", () => location.replace("/recipes?list=categories"));
recipeTagsButton.addEventListener("click", () => location.replace("/recipes?list=tags"));
searchRecipesButton.addEventListener("click", () => location.replace("/recipes?list=search"));
addRecipeButton.addEventListener("click", () => location.replace("/add-recipe"));
accountButton.addEventListener("click", () => location.replace("/account"));

popularNavButton.addEventListener("click", () => location.replace("/recipes?list=popular"));
categoriesNavButton.addEventListener("click", () => location.replace("/recipes?list=categories"));
tagsNavButton.addEventListener("click", () => location.replace("/recipes?list=tags"));
searchNavButton.addEventListener("click", () => location.replace("/recipes?list=search"));

const path = window.location.pathname;
const lastSegment = path.substring(path.lastIndexOf("/") + 1);

switch (lastSegment)
{
    case "recipes":
        const params = new URLSearchParams(window.location.search);
        const listParam = params.get("list");

        switch (listParam)
        {
            case "categories":
                recipeCategoriesButton.classList.add("selected-header-item");
                categoriesNavButton.classList.add("selected-nav-item");
                break;
            case "tags":
                recipeTagsButton.classList.add("selected-header-item");
                tagsNavButton.classList.add("selected-nav-item");
                break;
            case "search":
                searchRecipesButton.classList.add("selected-header-item");
                searchNavButton.classList.add("selected-nav-item");
                break;
            default:
                popularRecipesButton.classList.add("selected-header-item");
                popularNavButton.classList.add("selected-nav-item");
                break;
        }

        break;
    case "add-recipe":
        addRecipeButton.classList.add("selected-header-item");
        break;
    case "account":
        accountButton.classList.add("selected-header-item");
        break;
}