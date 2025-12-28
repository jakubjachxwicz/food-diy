const logoutButton = document.querySelector('#logoutButton');

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