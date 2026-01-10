const returnButton = document.querySelector('#returnButton');
const usersContainer = document.querySelector('#usersContainer');


returnButton.addEventListener('click', () => location.replace('/account'));

document.addEventListener('DOMContentLoaded', async () => {
    try 
    {
        const response = await fetch('api/users', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok)
        {
            console.error('Error occured');
            return;
        }

        const data = await response.json();
        console.log(data);
        
        const users = data.users;

        users.forEach(user => {
            const userSection = document.createElement("div");
            userSection.className = "userSection";

            const span = document.createElement("span");
            span.textContent = user.email;

            const normalId = `normalUser_${user.user_id}`;
            const modId = `mod_${user.user_id}`;
            const radioName = `roles_${user.user_id}`;

            const normalDiv = document.createElement("div");
            normalDiv.innerHTML = `
                <label for="${normalId}">Zwykły użytkownik</label>
                <input
                    type="radio"
                    name="${radioName}"
                    value="3"
                    ${user.privilege_level == 3 ? "checked" : ""}
                    id="${normalId}">`;

            const modDiv = document.createElement("div");
            modDiv.innerHTML = `
                <label for="${modId}">Mod</label>
                <input
                    type="radio"
                    name="${radioName}"
                    value="2"
                    ${user.privilege_level == 2 ? "checked" : ""}
                    id="${modId}">`;

            const button = document.createElement("button");
            button.className = "saveButton";
            button.textContent = "Zapisz";
            button.addEventListener('click', async () => {
                const selected = document.querySelector(`input[name="${radioName}"]:checked`);
                if (selected) 
                {
                    const value = parseInt(selected.value, 10);
                    
                    const savingResponse = await fetch(`api/users/update-role?user_id=${user.user_id}&role=${value}`, {
                        method: 'GET',
                        headers: {
                            'Content-Type': 'application/json'
                        }
                    });

                    if (!response.ok)
                    {
                        console.error('Unexpected error');
                        return;
                    }

                    const savingResponseData = await savingResponse.json();
                    if (savingResponseData.success)
                    {
                        alert('Dane o użytkowniku zapisano pomyślnie');
                        location.reload();
                    }
                }
            });

            userSection.append(span, normalDiv, modDiv, button);
            usersContainer.appendChild(userSection);
        });
    } catch (error)
    {
        console.log(error);
    }
});