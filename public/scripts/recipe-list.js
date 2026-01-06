const params = new URLSearchParams(window.location.search);
const listParam = params.get('list');

const recipeList = document.querySelector('.recipe-list');

document.addEventListener('DOMContentLoaded', async () => {
    if (listParam === 'categories' || listParam === 'tags')
        await renderFiltering(listParam);
    else if (listParam === 'search')
        renderSearchBar();

    await renderRecipeList();
});


const filteringContainer = document.querySelector('.filtering-container');

const renderFiltering = async (filteringType) => {
    try
    {
        const response = await fetch(filteringType === 'categories' ? 'api/categories' : 'api/tags', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        const data = await response.json();
        if (data.success) 
        {
            const options = filteringType === 'categories' ? data.categories : data.tags;
            
            const filteringOption = document.createElement('div');
            filteringOption.id = 'filteringOption';

            const selectedSpan = document.createElement('span');
            selectedSpan.id = 'selectedOption';
            selectedSpan.textContent = options[0];
            selectedSpan.dataset.value = options[0];
            filteringOption.appendChild(selectedSpan);

            // Arrow SVG
            const arrowSvg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
            arrowSvg.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
            arrowSvg.setAttribute('height', '24px');
            arrowSvg.setAttribute('width', '24px');
            arrowSvg.setAttribute('viewBox', '0 -960 960 960');
            arrowSvg.setAttribute('fill', '#e3e3e3');

            const arrowPath = document.createElementNS('http://www.w3.org/2000/svg', 'path');
            arrowPath.setAttribute(
                'd',
                'M480-344 240-584l56-56 184 184 184-184 56 56-240 240Z'
            );

            arrowSvg.appendChild(arrowPath);
            filteringOption.appendChild(arrowSvg);

            // Dropdown
            const dropdown = document.createElement('div');
            dropdown.className = 'filtering-dropdown';

            options.forEach(option => {
                const item = document.createElement('div');
                item.dataset.value = option;
                item.textContent = option;

                item.addEventListener('click', () => {
                    selectedSpan.textContent = option;
                    selectedSpan.dataset.value = option;
                });

                dropdown.appendChild(item);
            });

            filteringOption.appendChild(dropdown);

            filteringOption?.addEventListener('click', () => {
                dropdown.style.display = dropdown.style.display === 'flex' ? 'none' : 'flex';
            });

            filteringContainer.appendChild(filteringOption);

            // Filter icon SVG
            const filterSvg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
            filterSvg.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
            filterSvg.setAttribute('height', '24px');
            filterSvg.setAttribute('width', '24px');
            filterSvg.setAttribute('viewBox', '0 -960 960 960');
            filterSvg.setAttribute('fill', '#e3e3e3');

            const filterPath = document.createElementNS('http://www.w3.org/2000/svg', 'path');
            filterPath.setAttribute(
                'd',
                'M440-160q-17 0-28.5-11.5T400-200v-240L168-736q-15-20-4.5-42t36.5-22h560q26 0 36.5 22t-4.5 42L560-440v240q0 17-11.5 28.5T520-160h-80Zm40-308 198-252H282l198 252Zm0 0Z'
            );

            filterSvg.appendChild(filterPath);
            filterSvg.addEventListener('click', async () => renderRecipeList());
            
            filteringContainer.appendChild(filterSvg);
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

const renderSearchBar = () => {
    const wrapperDiv = document.createElement("div");

    const input = document.createElement("input");
    input.type = "text";
    input.id = "searchTermInput";

    wrapperDiv.appendChild(input);

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
    "M784-120 532-372q-30 24-69 38t-83 14q-109 0-184.5-75.5T120-580q0-109 75.5-184.5T380-840q109 0 184.5 75.5T640-580q0 44-14 83t-38 69l252 252-56 56ZM380-400q75 0 127.5-52.5T560-580q0-75-52.5-127.5T380-760q-75 0-127.5 52.5T200-580q0 75 52.5 127.5T380-400Z"
    );

    svg.addEventListener('click', async () => await renderRecipeList());

    svg.appendChild(path);

    filteringContainer.appendChild(wrapperDiv);
    filteringContainer.appendChild(svg);
    // filteringContainer.style.cursor = none;
};


const renderRecipeList = async () => {
    try
    {
        recipeList.replaceChildren();
        
        let url = '';
        switch (listParam)
        {
            case 'categories':
                const categorySelection = document.querySelector('#selectedOption');
                const category = categorySelection.dataset.value;

                url = '/api/recipes/categories?category=' + category;
                break;
            case 'tags':
                const tagSelection = document.querySelector('#selectedOption');
                const tag = tagSelection.dataset.value;

                url = '/api/recipes/tags?tag=' + tag;
                break;
            case 'search':
                const searchInput = document.querySelector('#searchTermInput');
                const searchTerm = searchInput.value;
                if (!searchTerm)
                    return;

                url = '/api/recipes/search?term=' + searchTerm;
                break;
            default:
                url = '/api/recipes/popular';
                break;
        }
        
        const response = await fetch(url, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        console.log(response);
        

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
                    <span>${recipe.rating ?? 'brak'}</span>
                `;
                footer.appendChild(ratingDiv);

                card.appendChild(footer);

                card.addEventListener('click', () => location.replace(`/recipe?id=${recipe.recipe_id}`));

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