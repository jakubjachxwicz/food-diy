const logoutButton = document.querySelector('#logoutButton');
const accountName = document.querySelector('.username');
const addedRecipesList = document.querySelector('#addedRecipesList');
const favouriteRecipesList = document.querySelector('#favouriteRecipesList');
const recipeContainer = document.querySelector('.recipes-container');


logoutButton?.addEventListener('click', async () => {
    try
    {
        const response = await fetch('/api/auth/logout', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        data = await response.json();
        if (data.success)
        {
            window.location.href = '/login';
        } else {
            alert('Wsytąpił nieznany błąd');
        }
    } catch (error) {
        console.error(error);
        alert('Wsytąpił nieznany błąd');
    }
});


document.addEventListener('DOMContentLoaded', async () => {
    try 
    {
        const response = await fetch('api/account/info', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        const result = await response.json();
        console.log(result);
        
        if (!response.ok)
        {
            renderErrorInfo();
            return;
        }

        const data = result.data;

        accountName.textContent = data.username;

        const added = data.added_recipes;
        if (added.length === 0)
        {
            const noAddedRecipesDiv = document.createElement('div');
            noAddedRecipesDiv.className = 'no-recipes-info';
            noAddedRecipesDiv.textContent = 'Brak dodanych przepisów';

            addedRecipesList.appendChild(noAddedRecipesDiv);
        } else
        {
            renderRecipeList(added, addedRecipesList);
        }

        const favourite = data.favourite;
        if (favourite.length === 0)
        {
            const noFavouriteRecipesDiv = document.createElement('div');
            noFavouriteRecipesDiv.className = 'no-recipes-info';
            noFavouriteRecipesDiv.textContent = 'Brak polubionych przepisów';

            favouriteRecipesList.appendChild(noFavouriteRecipesDiv);
        } else
        {
            renderRecipeList(favourite, favouriteRecipesList, false);
        }
    } catch (error)
    {
        console.log(error);
        
        renderErrorInfo();
    }
});


const deleteRecipe = async (recipe_id) => {
    try {
        const response = await fetch(`api/recipes/delete?id=${recipe_id}`, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json'
            }
        });
        if (!response.ok)
        {
            alert('Wystąpił nieznany błąd');
        }

        location.reload();
    } catch (error) {
        alert('Wystąpił nieznany błąd');
    }
};


const renderRecipeList = (recipes, container, renderButtons = true) => {
    recipes.forEach((recipe, index) => {
        if (index > 0)
        {
            const divider = document.createElement("div");
            divider.className = "list-divider";

            container.appendChild(divider);
        }

        const recipeItem = document.createElement("div");
        recipeItem.className = "recipe-item";

        const img = document.createElement("img");
        img.src = "public/static/cynamonki.jpeg";
        img.alt = "potrawa";

        const contentWrapper = document.createElement("div");

        const title = document.createElement("div");
        title.className = "recipe-title";
        title.textContent = recipe.recipe_name;
        title.addEventListener('click', () => location.replace(`recipe?id=${recipe.recipe_id}`));

        const options = document.createElement("div");
        options.className = "recipe-options";

        if (renderButtons)
        {
            const editLink = document.createElement("a");
            editLink.textContent = "Edytuj";
            editLink.addEventListener('click', () => location.replace(`/add-recipe?edit-recipe-id=${recipe.recipe_id}`))

            const deleteLink = document.createElement("a");
            deleteLink.textContent = "Usuń";
            deleteLink.addEventListener('click', async () => {
                confirm('Czy na pewno chcesz trwale usunąć ten przepis?')
                await deleteRecipe(recipe.recipe_id);
            });

            options.appendChild(editLink);
            options.appendChild(document.createTextNode("\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0"));
            options.appendChild(deleteLink);
        }

        contentWrapper.appendChild(title);
        contentWrapper.appendChild(options);

        recipeItem.appendChild(img);
        recipeItem.appendChild(contentWrapper);

        container.appendChild(recipeItem);
    });
};


const renderErrorInfo = () => {
    recipeContainer.replaceChildren();

    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-div'
    errorDiv.textContent = 'Nie udało się załadować danych użytkownika';

    recipeContainer.appendChild(errorDiv);
}