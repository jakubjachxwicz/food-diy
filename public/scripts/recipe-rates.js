const rateRecipeButton = document.querySelector('#rateRecipeButton');
const ratingPopup = document.querySelector('.rating-popup');
const closePopupButton = document.querySelector('#closePopupButton');
const ratingInput = document.querySelector('#ratingInput');
const rateButton = document.querySelector('#rateButton');
const popupErrorOutput = document.querySelector('#popupErrorOutput');


rateRecipeButton.addEventListener('click', () => {
    if (ratingPopup.style.display === 'none')
    {
        popupErrorOutput.textContent = '';
        ratingPopup.style.display = 'flex';
    }
    else
        ratingPopup.style.display = 'none';
});

closePopupButton.addEventListener('click', () => {
    ratingPopup.style.display = 'none';
});


document.addEventListener('DOMContentLoaded', async () => {
    const params = new URLSearchParams(window.location.search);
    const recipeId = params.get('id');
    
    try 
    {
        const response = await fetch('api/recipe/current-user-rating?id=' + recipeId, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        console.log(response);
        const data = await response.json();

        if (!response.ok)
        {
            console.log(data);
        }

        if (data.has_rating)
        {
            ratingInput.value = data.rating;
        }
    } catch (error)
    {
        console.log(error);
    }
});


rateButton.addEventListener('click', async () => {
    const selectedRating = ratingInput.value;
    if (![1, 2, 3, 4, 5].includes(Number(selectedRating)))
    {
        popupErrorOutput.textContent = 'Niepoprawna wartość';
        return;
    }

    const params = new URLSearchParams(window.location.search);
    const recipeId = params.get('id');
    
    try 
    {
        const response = await fetch(`api/recipe/rate-recipe?id=${recipeId}&rate=${selectedRating}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        console.log(response);
        await response.json();

        if (!response.ok)
        {
            if (response.status === 400 || response.status === 404)
            {
                popupErrorOutput.textContent = 'Niepoprawne id przepisu';
                return;
            } else if (response.status === 422)
            {
                popupErrorOutput.textContent = 'Niepoprawna wartość';
                return;
            }
            else throw 'Nieznany błąd';
        }

        ratingPopup.style.display = 'none';
    } catch (error)
    {
        console.log(error);
        popupErrorOutput.textContent = 'Wystąpił nieznany błąd';
    }
});