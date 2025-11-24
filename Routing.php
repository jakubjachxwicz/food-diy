<?php

require_once 'src/controllers/SecurityController.php';

class Routing 
{
    public static $routes = [
        'login' => [
            'controller' => 'SecurityController',
            'action' => 'login'
        ],
        'register' => [
            'controller' => 'SecurityController',
            'action' => 'register'
        ],
        'recipes' => [
            'controller' => 'SecurityController',
            'action' => 'recipes'
        ],
        'recipe' => [
            'controller' => 'SecurityController',
            'action' => 'recipe'
        ],
        'add-recipe' => [
            'controller' => 'SecurityController',
            'action' => 'addRecipe'
        ],
        'account' => [
            'controller' => 'SecurityController',
            'action' => 'account'
        ]
    ];
    
    public static function route($path) 
    {
        switch ($path) 
        {
            case 'login':
            case 'register':
            case 'recipes':
            case 'recipe':
            case 'add-recipe':
            case 'account':
                $controller = self::$routes[$path]['controller'];
                $action = self::$routes[$path]['action'];

                $controllerObj = new $controller();
                $controllerObj->$action();
                break;
            default:
                include 'public/views/404.html';
                break;
        }
    }
}

?>