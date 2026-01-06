const recipeNameInput = document.querySelector('#recipeNameInput');
const recipeDescriptionInput = document.querySelector('#recipeDescriptionInput');
const recipeInstructionInput = document.querySelector('#recipeInstructionInput');
const recipeTipsInput = document.querySelector('#recipeTipsInput');
const recipePortionsInput = document.querySelector('#recipePortionsInput');
const recipeDifficultyInput = document.querySelector('#recipeDifficultyInput');
const selectedIngredientsContainer = document.querySelector('.selected-ingredients');
const newIngredientInput = document.querySelector('#newIngredientInput');
const addIngredientButton = document.querySelector('#addIngredientButton');
const warningOutput = document.querySelector('#warningOutput');
const selectedCategorySpan = document.querySelector('#selectedCategorySpan');
const selectCategoryButton = document.querySelector('#selectCategoryButton');
const selectTagsButton = document.querySelector('#selectTagsButton');
const categoriesPopup = document.querySelector('#categoriesPopup');
const tagsPopup = document.querySelector('#tagsPopup');
const createRecipeButton = document.querySelector('.add-recipe-button');


let selectedIngredients = [];
const generateUniqueId = (items) => {
    if (items.length === 0) return 1;
    return Math.max(...items.map(item => item.ingredient_id)) + 1;
};

let availableCategories = [];
let availableTags = [];
let selectedTags = [];  


const renderWarning = (message) => {
    warningOutput.textContent = message;
    warningOutput.style.display = 'block';
};

const renderError = () => {
    const disablableElements = document.querySelectorAll('.disablable');
    disablableElements.forEach(element => {
        element.style.display = 'none';
    });

    const header = document.querySelector('#header');
    header.textContent = 'Wystąpił nieznany błąd';
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
            selectedIngredients = selectedIngredients.filter(
                item => item.ingredient_id !== ingredient.ingredient_id
            );
            
            renderSelectedIngredients();
        });

        wrapper.appendChild(span);
        wrapper.appendChild(svg);

        selectedIngredientsContainer.appendChild(wrapper);
    });
};


const getAvailableCategories = async () => {
    try 
    {
        let response = await fetch('api/categories', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            }
        });

        if (!response.ok)
        {
            renderError();
            return false;
        }

        let data = await response.json();
        availableCategories = data.categories;
        return true;
    } catch (error) {
        renderError();
        return false;
    }
};

const getAvailableTags = async () => {
    try 
    {
        let response = await fetch('api/tags', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            }
        });

        if (!response.ok)
        {
            renderError();
            return false;
        }

        let data = await response.json();
        availableTags = data.tags;
        return true;
    } catch (error) {
        renderError();
        return false;
    }
};

selectCategoryButton.addEventListener('click', () =>
    categoriesPopup.style.display = categoriesPopup.style.display === 'flex' ? 'none' : 'flex'
);

selectTagsButton.addEventListener('click', () => 
    tagsPopup.style.display = tagsPopup.style.display === 'flex' ? 'none' : 'flex'
);

document.addEventListener('DOMContentLoaded', async () => {
    let success;
    success = await getAvailableCategories();
    if (!success) return;
    success = await getAvailableTags();
    if (!success) return;

    console.log(availableCategories);
    console.log(availableTags);
    
    availableCategories.forEach(category => {
        const item = document.createElement('div');
        item.dataset.value = category;
        item.textContent = category;

        item.addEventListener('click', (event) => {
            event.stopPropagation();

            selectedCategorySpan.textContent = category;
            selectedCategorySpan.dataset.value = category;
            categoriesPopup.style.display = 'none';
            
        });

        categoriesPopup.appendChild(item);
    });

    availableTags.forEach(tag => {
        const item = document.createElement('div');
        
        const checkbox = document.createElement('input');
        checkbox.type = 'checkbox';
        checkbox.value = tag;
        checkbox.id = `tag-${tag}`;

        const span = document.createElement('span');
        span.textContent = tag;
        
        checkbox.addEventListener('change', () => {
            if (checkbox.checked) {
                selectedTags.push(tag);
            } else {
                const index = selectedTags.indexOf(tag);
                if (index > -1) {
                    selectedTags.splice(index, 1);
                }
            }
        });
        
        item.addEventListener('click', (event) => {
            event.stopPropagation();
        });
        
        item.appendChild(checkbox);
        item.appendChild(span);

        tagsPopup.appendChild(item);
    });
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


createRecipeButton.addEventListener('click', async () => {
    warningOutput.style.display = 'none';
    
    const recipeName = recipeNameInput.value.trim();
    const recipeDescription = recipeDescriptionInput.value.trim();
    const recipeInstruction = recipeInstructionInput.value.trim();
    const recipeTips = recipeTipsInput.value.trim();
    const recipePortions = recipePortionsInput.value.trim();
    const recipeDifficulty = parseInt(recipeDifficultyInput.value);
    const recipeCategory = selectedCategorySpan.dataset.value;
    const recipeTags = selectedTags;
    const ingredients = selectedIngredients.map(ingredient => ingredient.ingredient_name);

    // Validation
    if (!recipeName) {
        renderWarning('Nazwa przepisu jest wymagana');
        return;
    }
    
    if (recipeName.length > 100) {
        renderWarning('Nazwa przepisu może mieć maksymalnie 100 znaków');
        return;
    }
    
    if (recipeDescription.length > 800) {
        renderWarning('Opis może mieć maksymalnie 800 znaków');
        return;
    }
    
    if (!recipeInstruction) {
        renderWarning('Instrukcja przygotowania jest wymagana');
        return;
    }
    
    if (recipeTips.length > 400) {
        renderWarning('Wskazówki mogą mieć maksymalnie 400 znaków');
        return;
    }
    
    if (recipePortions.length > 10) {
        renderWarning('Porcje mogą mieć maksymalnie 10 znaków');
        return;
    }
    
    if (!recipeDifficulty || isNaN(recipeDifficulty) || recipeDifficulty < 1 || recipeDifficulty > 10) {
        renderWarning('Poziom trudności musi być liczbą od 1 do 10');
        return;
    }
    
    if (!recipeCategory) {
        renderWarning('Kategoria jest wymagana');
        return;
    }

    const recipeData = {
        recipe_name: recipeName,
        description: recipeDescription,
        instruction: recipeInstruction,
        tips: recipeTips,
        portions: recipePortions,
        difficulty: recipeDifficulty,
        category: recipeCategory,
        tags: recipeTags,
        ingredients: ingredients
    };

    console.log(recipeData);
    
});