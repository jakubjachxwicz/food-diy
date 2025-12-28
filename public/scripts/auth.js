const registerForm = document.querySelector('#registerForm');
const loginForm = document.querySelector('#loginForm');
const createAccountButton = document.querySelector('#createAccountButton');

createAccountButton?.addEventListener('click', () => {
    window.location.replace('/register');
});

loginForm?.addEventListener('submit', async (e) => {
    e.preventDefault();

    const errorOutput = document.querySelector('#error-output');
    errorOutput.textContent = "";

    const email = document.querySelector('#emailInput').value;
    const password = document.querySelector('#passwordInput').value;

    try
    {
        const response = await fetch('/api/auth/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ email, password })  
        });

        const data = await response.json();
        if (data.success) {
            window.location.href = '/recipes';
        } else {
            // TODO display failure info on the page
            // and check response as well
            
            alert('Login failed: ' + data.message);
        }
    } catch (error) {
        console.error('Error during login:', error);
        alert('An error occurred during login. Please try again later.');
    }
});

registerForm?.addEventListener('submit', async (e) => {
    e.preventDefault();

    const errorOutput = document.querySelector('#error-output');
    errorOutput.textContent = "";

    const firstName = document.querySelector('#firstNameInput').value;
    const lastName = document.querySelector('#lastNameInput').value;
    const username = document.querySelector('#usernameInput').value;
    const email = document.querySelector('#emailInput').value;
    const password = document.querySelector('#passwordInput').value;
    const confirmPassword = document.querySelector('#passwordConfirmInput').value;

    if (!firstName || !lastName || !username || !email || !password || !confirmPassword) 
    {
        errorOutput.textContent = "Uzupełnij wszystkie pola.";
        return;
    }

    const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;
    if (!passwordRegex.test(password)) 
    {
        errorOutput.textContent = "Hasło musi zawierać minimum 8 znaków, w tym małe i wielkie litery oraz cyfry.";
        return;
    }

    if (password != confirmPassword)
    {
        errorOutput.textContent = "Hasła nie są takie same.";
        return;
    }

    const agreeTerms = document.querySelector('#terms-accepted-checkbox').checked;
    if (!agreeTerms)
    {
        errorOutput.textContent = "Zaakceptuj regulamin serwisu w celu rejestracji.";
        return;
    }

    try
    {
        const response = await fetch('/api/auth/register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ firstName, lastName, username, email, password })  
        });

        console.log(response);
        
        data = await response.json();
        if (data.success)
        {
            window.location.href = '/recipes';
        } else {
            errorOutput.textContent = "Nie udało się zarejestrować użytkownika, spróbuj ponownie.";
        }
    } catch (error) {
        errorOutput.textContent = "Nie udało się zarejestrować użytkownika, spróbuj ponownie.";
    }
});