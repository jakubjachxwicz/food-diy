const recipeTitleField = document.querySelector('#recipeTitleField');
const recipeDescriptionField = document.querySelector('#recipeDescriptionField');
const recipeCategoryField = document.querySelector('#recipeCategoryField');
const recipeTagsField = document.querySelector('#recipeTagsField');
const recipeAuthorField = document.querySelector('#recipeAuthorField');
const recipeDateAddedField = document.querySelector('#recipeDateAddedField');
const recipePortionsField = document.querySelector('#recipePortionsField');
const recipeDifficultyField = document.querySelector('#recipeDifficultyField');
const recipeViewsField = document.querySelector('#recipeViewsField');
const recipeRatingField = document.querySelector('#recipeRatingField');
const recipeInstructionField = document.querySelector('#recipeInstructionField');
const recipeTipsLabel = document.querySelector('#recipeTipsLabel');
const recipeTipsField = document.querySelector('#recipeTipsField');
const addToFavouriteButton = document.querySelector('#addToFavouriteButton');
const archiveRecipeButton = document.querySelector('#archiveRecipeButton');


document.addEventListener('DOMContentLoaded', async () => {
    const params = new URLSearchParams(window.location.search);
    const recipeId = params.get('id');
    
    try 
    {
        const response = await fetch('api/recipe?id=' + recipeId, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        console.log(response);

        if (!response.ok)
        {
            renderErrorInfo(response.status);
        }
        
        const data = await response.json();
        const recipe = data.recipe;

        if (!recipe.active)
        {
            const isArchivedDisplay = document.querySelector('#archived');
            archiveRecipeButton.textContent = 'Przywróć';
            isArchivedDisplay.style.display = 'block';
        }
        recipeTitleField.textContent = recipe.recipe_name;
        recipeDescriptionField.textContent = recipe.recipe_description ?? '';
        recipeCategoryField.textContent = recipe.category ?? '';
        recipeTagsField.textContent = recipe.tags.length > 0 ? `tagi: ${recipe.tags.join(', ')}` : '';
        recipeAuthorField.textContent = recipe.author;
        recipeDateAddedField.textContent = `Data dodania: ${recipe.date_added.split("-").reverse().join(".")}`;
        recipePortionsField.textContent = recipe.portions ? `Porcje: ${recipe.portions}` : '';
        recipeDifficultyField.textContent = `Poziom trudności: ${recipe.difficulty}/10`;
        recipeViewsField.textContent = recipe.views;
        recipeRatingField.textContent = recipe.rating ?? 'brak ocen';
        recipeInstructionField.innerHTML = recipe.instruction.replace(/\\r\\n|\\n/g, "<br>");

        if (recipe.tips)
        {
            recipeTipsField.innerHTML = recipe.tips.replace(/\\r\\n|\\n/g, "<br>");
        } else
        {
            recipeTipsLabel.style.display = 'none';
            recipeTipsField.style.display = 'none';
        }

        const ingredientList = document.querySelector('.ingredients-list');

        recipe.ingredients.forEach((ingredient) => {
            const ingredientRow = document.createElement("div");
            ingredientRow.className = "ingredient-row";

            const span = document.createElement("span");
            span.textContent = ingredient.ingredient_name;

            const emptyDiv = document.createElement("div");

            ingredientRow.appendChild(span);
            ingredientRow.appendChild(emptyDiv);

            ingredientList.appendChild(ingredientRow);
        });


        await renderFavouriteButton();
        await renderArchiveButton();
    } catch (error)
    {
        const pageContent = document.getElementsByClassName('page-content');
        Array.from(pageContent).forEach(el => {
            el.style.display = 'none';
        });

        const contentDiv = document.querySelector('.content-section');
        contentDiv.replaceChildren();
        contentDiv.classList = ['error-output'];

        contentDiv.textContent = 'Wystąpił nieznany błąd';            
    }

    addToFavouriteButton.addEventListener('click', addToFavouriteHandler);
});


const renderErrorInfo = (status) => {
    const pageContent = document.getElementsByClassName('page-content');
    Array.from(pageContent).forEach(el => {
        el.style.display = 'none';
    });

    const contentDiv = document.querySelector('.content-section');
    contentDiv.replaceChildren();
    contentDiv.classList = ['error-output'];

    contentDiv.textContent = 'Wystąpił nieznany błąd';

    switch (status)
    {
        case 400:
            contentDiv.textContent = 'Niepoprawne id przepisu';
            break;
        case 404:
            contentDiv.textContent = 'Nie znaleziono przepisu';
            break;
        case 403:
            contentDiv.textContent = 'Brak uprawnień aby zobaczyć ten przepis';
            break;
        case 500:
            contentDiv.textContent = 'Wystąpił nieznany błąd';
            break;
    }
}


const renderFavouriteButton = async () => {
    try
    {
        const params = new URLSearchParams(window.location.search);
        const recipeId = params.get('id');
        
        const response = await fetch('api/recipe/is-favourite?id=' + recipeId, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok)
            throw 'Error while fetching isFavourite data';

        const data = await response.json();
        if (data.is_favourite)
            addToFavouriteButton.classList.add('disabled-button');
    } catch (error)
    {
        console.log(error);
        
        const pageContent = document.getElementsByClassName('page-content');
        Array.from(pageContent).forEach(el => {
            el.style.display = 'none';
        });

        const contentDiv = document.querySelector('.content-section');
        contentDiv.replaceChildren();
        contentDiv.classList = ['error-output'];

        contentDiv.textContent = 'Wystąpił nieznany błąd';
    }
};


const renderArchiveButton = async () => {
    const response = await fetch('api/user/privilege', {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    });

    if (!response.ok)
        throw 'Unexpected error';

    const data = await response.json();
    console.log(data);
    
    if (data.privilege < 3)
    {
        const params = new URLSearchParams(window.location.search);
        const recipeId = params.get('id');
        
        archiveRecipeButton.style.display = 'block';

        archiveRecipeButton.addEventListener('click', async () => {
            const archiveResponse = await fetch(`api/recipe/archive?id=${recipeId}`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            if (!archiveResponse.ok)
                throw 'Unexpected error';

            const archiveResult = await archiveResponse.json();
            console.log(archiveResult);
            if (archiveResult.success)
                location.reload();
 
            throw 'Wystąpił nieznany błąd';
        });
    }
};


const addToFavouriteHandler = async () => {
    try
    {
        const params = new URLSearchParams(window.location.search);
        const recipeId = params.get('id');
        
        const response = await fetch('api/recipe/toggle-favourite?id=' + recipeId, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok)
        {
            alert('Wystąpił nieznany błąd');
            return;
        }

        addToFavouriteButton.classList.toggle('disabled-button');
    } catch (error)
    {
        alert('Wystąpił nieznany błąd');
        return;
    }
};