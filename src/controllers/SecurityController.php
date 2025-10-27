<?php

require_once 'AppController.php';

class SecurityController extends AppController
{
    public function login()
    {
        // TODO Get data from login form and process it
        
        return $this->render('login');
    }

    public function register()
    {
        return $this->render('register');
    }
}
