const recipeNameInput = document.querySelector('#recipeNameInput');
const recipeDescriptionInput = document.querySelector('#recipeDescriptionInput');
const recipeInstructionInput = document.querySelector('#recipeInstructionInput');
const recipeTipsInput = document.querySelector('#recipeTipsInput');
const selectedIngredientsContainer = document.querySelector('.selected-ingredients');
const newIngredientInput = document.querySelector('#newIngredientInput');
const addIngredientButton = document.querySelector('#addIngredientButton');


let selectedIngredients = [];
const generateUniqueId = (items) => {
    if (items.length === 0) return 1;
    return Math.max(...items.map(item => item.id)) + 1;
};


const renderSelectedIngredients = () => {
    selectedIngredientsContainer.replaceChildren();
    
    selectedIngredients.forEach(ingredient => {
        const wrapper = document.createElement("div");

        const span = document.createElement("span");
        span.textContent = ingredient.ingredient_name;

        const svgNS = "http://www.w3.org/2000/svg";
        const svg = document.createElementNS(svgNS, "svg");

        svg.setAttribute("xmlns", svgNS);
        svg.setAttribute("height", "24px");
        svg.setAttribute("width", "24px");
        svg.setAttribute("viewBox", "0 -960 960 960");
        svg.setAttribute("fill", "#e3e3e3");

        const path = document.createElementNS(svgNS, "path");
        path.setAttribute(
        "d",
        "M280-120q-33 0-56.5-23.5T200-200v-520h-40v-80h200v-40h240v40h200v80h-40v520q0 33-23.5 56.5T680-120H280Zm400-600H280v520h400v-520ZM360-280h80v-360h-80v360Zm160 0h80v-360h-80v360ZM280-720v520-520Z"
        );

        svg.appendChild(path);

        svg.addEventListener('click', () => {
            console.log('cipunia');
            
            selectedIngredients = selectedIngredients.filter(
                item => {
                    item.ingredient_id !== ingredient.ingredient_id;
                    renderSelectedIngredients;
                }
            );
            renderSelectedIngredients();
        });

        wrapper.appendChild(span);
        wrapper.appendChild(svg);

        selectedIngredientsContainer.appendChild(wrapper);
    });
};


document.addEventListener('DOMContentLoaded', async () => {

});


addIngredientButton.addEventListener('click', () => {
    const newIngredient = newIngredientInput.value;
    if (!newIngredient)
        return;

    selectedIngredients.push({ 
        ingredient_id: generateUniqueId(selectedIngredients), 
        ingredient_name: newIngredient 
    });


    renderSelectedIngredients();
    newIngredientInput.value = '';
});


