<?php

require_once 'src/controllers/SecurityController.php';
require_once 'src/controllers/AppController.php';
require_once 'src/controllers/AuthController.php';

class Routing 
{
    public static $routes = [
        'login' => [
            'controller' => 'SecurityController',
            'action' => 'login',
            'method' => 'GET'
        ],
        'register' => [
            'controller' => 'SecurityController',
            'action' => 'register',
            'method' => 'GET'
        ],
        'recipes' => [
            'controller' => 'SecurityController',
            'action' => 'recipes',
            'method' => 'GET',
            'protected' => true
        ],
        'recipe' => [
            'controller' => 'SecurityController',
            'action' => 'recipe',
            'method' => 'GET',
            'protected' => true
        ],
        'add-recipe' => [
            'controller' => 'SecurityController',
            'action' => 'addRecipe',
            'method' => 'GET',
            'protected' => true
        ],
        'account' => [
            'controller' => 'SecurityController',
            'action' => 'account',
            'method' => 'GET',
            'protected' => true
        ],

        // API routes
        'api/auth/register' => [
            'controller' => 'AuthController',
            'action' => 'handleRegister',
            'method' => 'POST'
        ],
        'api/auth/login' => [
            'controller' => 'AuthController',
            'action' => 'handleLogin',
            'method' => 'POST'
        ],
        'api/auth/logout' => [
            'controller' => 'AuthController',
            'action' => 'handleLogout',
            'method' => 'POST'
        ],
        'api/auth/check' => [
            'controller' => 'AuthController',
            'action' => 'checkAuth',
            'method' => 'GET'
        ]
    ];
    
    public static function route($path) 
    {
        $requestMethod = $_SERVER['REQUEST_METHOD'];

        if (!isset(self::$routes[$path]))
        {
            http_response_code(404);
            include 'public/views/404.html';
            return;
        }

        $route = self::$routes[$path];
        
        if ($route['method'] !== $requestMethod) 
        {
            http_response_code(405);
            echo json_encode(['success' => false, 'message' => 'Method not allowed']);
            return;
        }

        if (isset($route['protected']) && $route['protected']) 
        {
            require_once 'config/session.php';
            if (!isAuthenticated()) 
            {
                header('Location: /login');
                return;
            }
        }

        $controller = $route['controller'];
        $action = $route['action'];

        $controllerObj = new $controller();
        $controllerObj->$action();
    }
}