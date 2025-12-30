{/* <div class="recipe-card">
    <img src="public/static/cynamonki.jpeg" alt="Cynamonki">

    <div class="recipe-card-content">
        <h3>Cynamonki</h3>
        <span>Autor: maticracow</span>
        <span>deser</span>
        <span>tagi: jesień, lukier</span>
    </div>

    <div class="recipe-card-footer">
        <div>
            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#e3e3e3"><path d="M480-320q75 0 127.5-52.5T660-500q0-75-52.5-127.5T480-680q-75 0-127.5 52.5T300-500q0 75 52.5 127.5T480-320Zm0-72q-45 0-76.5-31.5T372-500q0-45 31.5-76.5T480-608q45 0 76.5 31.5T588-500q0 45-31.5 76.5T480-392Zm0 192q-146 0-266-81.5T40-500q54-137 174-218.5T480-800q146 0 266 81.5T920-500q-54 137-174 218.5T480-200Zm0-300Zm0 220q113 0 207.5-59.5T832-500q-50-101-144.5-160.5T480-720q-113 0-207.5 59.5T128-500q50 101 144.5 160.5T480-280Z"/></svg>
            <span>127</span>
        </div>
        <div>
            <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#e3e3e3"><path d="m384-334 96-74 96 74-36-122 90-64H518l-38-124-38 124H330l90 64-36 122ZM233-120l93-304L80-600h304l96-320 96 320h304L634-424l93 304-247-188-247 188Zm247-369Z"/></svg>
            <span>4/5</span>
        </div>
    </div>
</div> */}

const recipeList = document.querySelector('.recipe-list');

document.addEventListener('DOMContentLoaded', () => {
    renderRecipeList();
});


const renderRecipeList = async () => {
    const params = new URLSearchParams(window.location.search);
    const listParam = params.get("list");

    try
    {
        const response = await fetch('/api/recipes/popular', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        const data = await response.json();
        if (data.success) {
            data.recipes.forEach(recipe => {
                const card = document.createElement('div');
                card.className = 'recipe-card';

                const img = document.createElement('img');
                // TODO image handling
                img.src = 'public/static/cynamonki.jpeg';
                img.alt = 'cynamonki';
                card.appendChild(img);

                const content = document.createElement('div');
                content.className = 'recipe-card-content';

                const h3 = document.createElement('h3');
                h3.textContent = recipe.recipe_name;
                content.appendChild(h3);

                const author = document.createElement('span');
                author.textContent = `Autor: ${recipe.author}`;
                content.appendChild(author);

                const type = document.createElement('span');
                type.textContent = recipe.category;
                content.appendChild(type);

                const tags = document.createElement('span');
                tags.textContent = `tagi: ${recipe.tags.join(', ')}`;
                content.appendChild(tags);

                card.appendChild(content);

                const footer = document.createElement('div');
                footer.className = 'recipe-card-footer';

                const viewsDiv = document.createElement('div');
                viewsDiv.innerHTML = `
                    <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#e3e3e3">
                        <path d="M480-320q75 0 127.5-52.5T660-500q0-75-52.5-127.5T480-680q-75 0-127.5 52.5T300-500q0 75 52.5 127.5T480-320Zm0-72q-45 0-76.5-31.5T372-500q0-45 31.5-76.5T480-608q45 0 76.5 31.5T588-500q0 45-31.5 76.5T480-392Zm0 192q-146 0-266-81.5T40-500q54-137 174-218.5T480-800q146 0 266 81.5T920-500q-54 137-174 218.5T480-200Zm0-300Zm0 220q113 0 207.5-59.5T832-500q-50-101-144.5-160.5T480-720q-113 0-207.5 59.5T128-500q50 101 144.5 160.5T480-280Z"/>
                    </svg>
                    <span>${recipe.views}</span>
                `;
                footer.appendChild(viewsDiv);

                const ratingDiv = document.createElement('div');
                ratingDiv.innerHTML = `
                    <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#e3e3e3">
                        <path d="m384-334 96-74 96 74-36-122 90-64H518l-38-124-38 124H330l90 64-36 122ZM233-120l93-304L80-600h304l96-320 96 320h304L634-424l93 304-247-188-247 188Zm247-369Z"/>
                    </svg>
                    <span>${recipe.rating}</span>
                `;
                footer.appendChild(ratingDiv);

                card.appendChild(footer);

                recipeList.appendChild(card);
            })
        } else {
            // TODO display failure info on the page
            // and check response as well

            alert('Fetching data failed: ' + data.message);
        }
    } catch (error) {
        console.error('Error during fetching recipe data:', error);
        alert('An error occurred during fetching recipe data.');
    }
};
