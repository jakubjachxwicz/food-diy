<?php

class AppController 
{
    private static $instance = null;

    private function __construct() { }

    private function __clone() {}
    public function __wakeup()
    {
        throw new \Exception("Cannot unserialize singleton");
    }

    public static function getInstance(): self
    {
        if (self::$instance === null) 
        {
            self::$instance = new self();
        }

        return self::$instance;
    }


    public function login()
    {
        require_once 'config/session.php';
        if (isAuthenticated())
            header('Location: /recipes');
        
        return $this->render('login');
    }

    public function register()
    {
        require_once 'config/session.php';
        if (isAuthenticated())
            header('Location: /recipes');
        
        return $this->render('register');
    }

    public function recipes()
    {
        return $this->render('recipe-list');
    }

    public function default()
    {
        header('Location: /recipes');
    }

    public function recipe()
    {
        return $this->render('recipe');
    }

    public function addRecipe()
    {
        return $this->render('add-recipe');
    }

    public function account()
    {
        return $this->render('account');
    }
    
    
    private function render(string $template = null, array $variables = [])
    {
        $templatePath = 'public/views/'. $template.'.html';
        $templatePath404 = 'public/views/404.html';
        $output = "";
                 
        if (file_exists($templatePath))
        {
            extract($variables);
            
            ob_start();
            include $templatePath;
            $output = ob_get_clean();
        } else 
        {
            ob_start();
            include $templatePath404;
            $output = ob_get_clean();
        }
        echo $output;
    }

}