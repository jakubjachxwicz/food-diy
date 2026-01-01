<?php

require_once 'src/controllers/AppController.php';
require_once 'src/controllers/AuthController.php';
require_once 'src/controllers/RecipeController.php';

require_once 'src/repositories/UserRepository.php';
require_once 'src/repositories/RecipeRepository.php';

require_once 'Database.php';

class Routing 
{
    public static $routes = [
        '' => [
            'controller' => 'AppController',
            'action' => 'default',
            'method' => 'GET',
            'protected' => true
        ],
        'login' => [
            'controller' => 'AppController',
            'action' => 'login',
            'method' => 'GET'
        ],
        'register' => [
            'controller' => 'AppController',
            'action' => 'register',
            'method' => 'GET'
        ],
        'recipes' => [
            'controller' => 'AppController',
            'action' => 'recipes',
            'method' => 'GET',
            'protected' => true
        ],
        'recipe' => [
            'controller' => 'AppController',
            'action' => 'recipe',
            'method' => 'GET',
            'protected' => true
        ],
        'add-recipe' => [
            'controller' => 'AppController',
            'action' => 'addRecipe',
            'method' => 'GET',
            'protected' => true
        ],
        'account' => [
            'controller' => 'AppController',
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
        ],

        'api/recipes/popular' => [
            'controller' => 'RecipeController',
            'action' => 'getPopularRecipesWithCategoryAndTags',
            'method' => 'GET',
            'protected' => true
        ],
        'api/recipes/categories' => [
            'controller' => 'RecipeController',
            'action' => 'getRecipesByCategory',
            'method' => 'GET',
            'protected' => true
        ],
        'api/categories' => [
            'controller' => 'RecipeController',
            'action' => 'getAvailableCategories',
            'method' => 'GET',
            'protected' => true
        ],
        'api/recipes/tags' => [
            'controller' => 'RecipeController',
            'action' => 'getRecipesByTag',
            'method' => 'GET',
            'protected' => true
        ],
        'api/tags' => [
            'controller' => 'RecipeController',
            'action' => 'getAvailableTags',
            'method' => 'GET',
            'protected' => true
        ],
        'api/recipes/search' => [
            'controller' => 'RecipeController',
            'action' => 'searchRecipes',
            'method' => 'GET',
            'protected' => true
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

        $controllerClass = $route['controller'];
        $action = $route['action'];

        $database = new Database();

        switch ($controllerClass)
        {
            case AppController::class:
                $controller = AppController::getInstance();
                break;
            case AuthController::class:
                $repository = new UserRepository($database);
                $controller = AuthController::getInstance($repository);
                break;
            case RecipeController::class:
                $repository = new RecipeRepository($database);
                $controller = RecipeController::getInstance($repository);
                break;
        }

        $controller->$action();
    }
}