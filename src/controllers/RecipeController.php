<?php

require_once 'src/repositories/RecipeRepository.php';
require_once 'src/repositories/UserRepository.php';
require_once 'config/session.php';

class RecipeController
{
    private static $instance = null;
    private RecipeRepository $recipeRepository;
    private UserRepository $userRepository;

    private function __construct(RecipeRepository $recipeRepository, UserRepository $userRepository) 
    {
        $this->recipeRepository = $recipeRepository;
        $this->userRepository = $userRepository;

        header('Content-Type: application/json');
    }

    private function __clone() {}
    public function __wakeup()
    {
        throw new \Exception("Cannot unserialize singleton");
    }

    public static function getInstance(RecipeRepository $recipeRepository, UserRepository $userRepository): self
    {
        if (self::$instance === null) 
        {
            self::$instance = new self($recipeRepository, $userRepository);
        }

        return self::$instance;
    }


    public function getPopularRecipesWithCategoryAndTags()
    {
        try
        {
            $result = [];
            
            $recipes = $this->recipeRepository->getPopularRecipes();
            foreach ($recipes as $recipe)
            {
                if ($this->shouldIncludeRecipe($recipe))
                {
                    $recipe['tags'] = $this->recipeRepository->getRecipeTags($recipe['recipe_id']);
                    $result[] = $recipe;
                }
            }

            echo json_encode([
                'success' => true,
                'recipes' => $result
            ]);
        } catch (Exception $e) 
        {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Unexpected error occurred'
            ]);
            error_log($e->getMessage());
        }
    }

    public function getRecipesByCategory()
    {
        try
        {
            if (!isset($_GET['category']))
            {
                http_response_code(400);
                echo json_encode([
                    'success' => false,
                    'message' => 'Category not provided'
                ]);
                return;
            }

            $result = [];

            $recipes = $this->recipeRepository->getRecipesByCategory($_GET['category']);
            foreach ($recipes as $recipe)
            {
                if ($this->shouldIncludeRecipe($recipe))
                {
                    $recipe['tags'] = $this->recipeRepository->getRecipeTags($recipe['recipe_id']);
                    $result[] = $recipe;
                }
            }

            echo json_encode([
                'success' => true,
                'recipes' => $result
            ]);
        } catch (Exception $e) 
        {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Unexpected error occurred'
            ]);
            error_log($e->getMessage());
        }
    }

    public function getAvailableCategories()
    {
        try
        {
            $categories = $this->recipeRepository->getAllCategories();

            echo json_encode([
                'success' => true,
                'categories' => $categories
            ]);
        } catch (Exception $e) 
        {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Unexpected error occurred'
            ]);
            error_log($e->getMessage());
        }
    }

    public function getRecipesByTag()
    {
        try
        {
            if (!isset($_GET['tag']))
            {
                http_response_code(400);
                echo json_encode([
                    'success' => false,
                    'message' => 'Tag not provided'
                ]);
                return;
            }

            $result = [];

            $recipes = $this->recipeRepository->getRecipesByTag($_GET['tag']);
            foreach ($recipes as $recipe)
            {
                if ($this->shouldIncludeRecipe($recipe))
                {
                    $recipe['tags'] = $this->recipeRepository->getRecipeTags($recipe['recipe_id']);
                    $result[] = $recipe;
                }
            }

            echo json_encode([
                'success' => true,
                'recipes' => $result
            ]);
        } catch (Exception $e)
        {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Unexpected error occurred'
            ]);
            error_log($e->getMessage());
        }
    }

    public function getAvailableTags()
    {
        try
        {
            $tags = $this->recipeRepository->getAllTags();

            echo json_encode([
                'success' => true,
                'tags' => $tags
            ]);
        } catch (Exception $e) 
        {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Unexpected error occurred'
            ]);
            error_log($e->getMessage());
        }
    }

    public function searchRecipes()
    {
        try
        {
            if (!isset($_GET['term']))
            {
                http_response_code(400);
                echo json_encode([
                    'success' => false,
                    'message' => 'Search term not provided'
                ]);
                return;
            }

            $result = [];

            $recipes = $this->recipeRepository->getRecipesBySearchTerm($_GET['term']);
            foreach ($recipes as $recipe)
            {
                if ($this->shouldIncludeRecipe($recipe))
                {
                    $recipe['tags'] = $this->recipeRepository->getRecipeTags($recipe['recipe_id']);
                    $result[] = $recipe;
                }
            }

            echo json_encode([
                'success' => true,
                'recipes' => $result
            ]);
        } catch (Exception $e)
        {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Unexpected error occurred'
            ]);
            error_log($e->getMessage());
        }
    }

    public function getRecipe()
    {
        try
        {
            if (!isset($_GET['id']) || $_GET['id'] === '' || !is_numeric($_GET['id']))
            {
                http_response_code(400);
                echo json_encode([
                    'success' => false,
                    'message' => 'Invalid recipe id provided'
                ]);
                return;
            }

            $id = $_GET['id'];

            $recipe = $this->recipeRepository->getRecipeById($id);
            if ($recipe === false)
            {
                http_response_code(404);
                echo json_encode([
                    'success' => false,
                    'message' => 'Recipe not found'
                ]);
                return;
            }

            if (!$recipe['active'])
            {
                $userId = getCurrentUserId();
                if ($userId !== $recipe['author_id'])
                {
                    $userRole = $this->userRepository->getUserRole($userId);

                    if ($userRole['privilege_level'] === 3)
                    {
                        http_response_code(403);
                        echo json_encode([
                            'success' => false,
                            'message' => 'You do not have sufficient privileges to view this recipe'
                        ]);
                        return;
                    }
                }
            }

            $recipe['tags'] = $this->recipeRepository->getRecipeTags($id);
            $recipe['ingredients'] = $this->recipeRepository->getIngredientsByRecipeId($id);

            echo json_encode([
                'success' => true,
                'recipe' => $recipe
            ]);
        } catch (Exception $e)
        {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Unexpected error occurred'
            ]);
            error_log($e->getMessage());
        }
    }

    private function shouldIncludeRecipe($recipe)
    {
        if ($recipe['active'])
            return true;
        
        $userId = getCurrentUserId();
        if ($userId === $recipe['author_id'])
            return true;
        
        $userRole = $this->userRepository->getUserRole($userId);
        if ($userRole['privilege_level'] === 3)
            return false;
        
        return true;
    }

    public function isRecipeFavourite()
    {
        try
        {
            if (!isset($_GET['id']) || $_GET['id'] === '' || !is_numeric($_GET['id']))
            {
                http_response_code(400);
                echo json_encode([
                    'success' => false,
                    'message' => 'Invalid recipe id provided'
                ]);
                return;
            }
            
            $userId = getCurrentUserId();
            $recipeId = $_GET['id'];

            $record = $this->recipeRepository->getIsRecipeFavourite($userId, $recipeId);

            echo json_encode([
                'success' => true,
                'is_favourite' => $record === false ? false : true
            ]);
        } catch (Exception $e)
        {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Unexpected error occurred'
            ]);
            error_log($e->getMessage());
        }
    }

    public function toggleRecipeFavourite()
    {
        try
        {
            if (!isset($_GET['id']) || $_GET['id'] === '' || !is_numeric($_GET['id']))
            {
                http_response_code(400);
                echo json_encode([
                    'success' => false,
                    'message' => 'Invalid recipe id provided'
                ]);
                return;
            }
            
            $userId = getCurrentUserId();
            $recipeId = $_GET['id'];

            $recipe = $this->recipeRepository->getRecipeById($recipeId);
            if ($recipe === false)
            {
                http_response_code(404);
                echo json_encode([
                    'success' => false,
                    'message' => 'Recipe not found'
                ]);
                return;
            }

            $record = $this->recipeRepository->getIsRecipeFavourite($userId, $recipeId);
            if ($record === false)
                $this->recipeRepository->setRecipeFavourite($userId, $recipeId);
            else
                $this->recipeRepository->removeFavouriteRecipe($userId, $recipeId);

            echo json_encode([
                'success' => true
            ]);
        } catch (Exception $e)
        {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Unexpected error occurred'
            ]);
            error_log($e->getMessage());
        }
    }

    public function getCurrentUserRating()
    {
        try
        {
            if (!isset($_GET['id']) || $_GET['id'] === '' || !is_numeric($_GET['id']))
            {
                http_response_code(400);
                echo json_encode([
                    'success' => false,
                    'message' => 'Invalid recipe id provided'
                ]);
                return;
            }
            
            $userId = getCurrentUserId();
            $recipeId = $_GET['id'];

            $recipe = $this->recipeRepository->getRecipeById($recipeId);
            if ($recipe === false)
            {
                http_response_code(404);
                echo json_encode([
                    'success' => false,
                    'message' => 'Recipe not found'
                ]);
                return;
            }

            $rating = $this->recipeRepository->getUserRatingForRecipe($userId, $recipeId);
            if ($rating === false)
            {
                echo json_encode([
                    'success' => true,
                    'has_rating' => false,
                    'rating' => -1
                ]);
                return;
            }

            echo json_encode([
                'success' => true,
                'has_rating' => true,
                'rating' => $rating['rating']
            ]);
        } catch (Exception $e)
        {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Unexpected error occurred'
            ]);
            error_log($e->getMessage());
        }
    }

    public function rateRecipe()
    {
        try
        {
            if (!isset($_GET['id']) || $_GET['id'] === '' || !is_numeric($_GET['id']) ||
                !isset($_GET['rate']) || $_GET['rate'] === '' || !is_numeric($_GET['rate']))
            {
                http_response_code(400);
                echo json_encode([
                    'success' => false,
                    'message' => 'Invalid data provided'
                ]);
                return;
            }
            
            $userId = getCurrentUserId();
            $recipeId = $_GET['id'];
            $rate = $_GET['rate'];

            if (!in_array($rate, ["1", "2", "3", "4", "5"], true)) 
            {
                http_response_code(422);
                echo json_encode([
                    'success' => false,
                    'message' => 'Invalid rate value'
                ]);
                return;
            }

            $recipe = $this->recipeRepository->getRecipeById($recipeId);
            if ($recipe === false)
            {
                http_response_code(404);
                echo json_encode([
                    'success' => false,
                    'message' => 'Recipe not found'
                ]);
                return;
            }

            $this->recipeRepository->saveRecipeRate($userId, $recipeId, $rate);

            echo json_encode([
                'success' => true
            ]);
        } catch (Exception $e)
        {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Unexpected error occurred'
            ]);
            error_log($e->getMessage());
        }
    }

    public function getAccountInfo()
    {
        try
        {
            $userId = getCurrentUserId();
            if ($userId === null)
            {
                http_response_code(401);
                echo json_encode([
                    'success' => false,
                    'message' => 'User not authorized'
                ]);
                return;
            }

            $user = $this->userRepository->getById($userId);
            $addedRecipes = $this->recipeRepository->getRecipesForUser($userId);
            $favouriteRecipes = $this->recipeRepository->getFavouriteRecipes($userId);
            $favouriteRecipesFiltered = array_filter($favouriteRecipes, fn($fr) => $this->shouldIncludeRecipe($fr));

            $result = [
                'username' => $user['username'],
                'added_recipes' => $addedRecipes,
                'favourite' => $favouriteRecipesFiltered,
            ];

            echo json_encode([
                'success' => true,
                'data' => $result
            ]);
        } catch (Exception $e)
        {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Unexpected error occurred'
            ]);
            error_log($e->getMessage());
        }
    }

    public function addRecipe()
    {
        try
        {
            $userId = getCurrentUserId();
            if ($userId === null)
            {
                http_response_code(401);
                echo json_encode([
                    'success' => false,
                    'message' => 'User not authorized'
                ]);
                return;
            }

            $input = json_decode(file_get_contents('php://input'), true);

            $pdo = $this->recipeRepository->getConnection();
            $pdo->beginTransaction();

            $category = $this->recipeRepository->getCategoryId($input['category']);

            $recipe = [
                'name' => $input['recipe_name'],
                'description' => $input['description'],
                'instruction' => $input['instruction'],
                'tips' => $input['tips'],
                'portions' => $input['portions'],
                'author_id' => $userId,
                'difficulty' => $input['difficulty'],
                'category_id' => $category['category_id']
            ];
            $recipe_data = $this->recipeRepository->createRecipe($recipe);
            $recipe_id = $recipe_data['recipe_id'];

            foreach ($input['ingredients'] as $ingredient) 
            {
                $this->recipeRepository->createIngredient($ingredient, $recipe_id);
            }

            foreach ($input['tags'] as $tag) 
            {
                $this->recipeRepository->createTag($tag, $recipe_id);
            }
            
            $pdo->commit();

            echo json_encode([
                'success' => true,
                'recipe_id' => $recipe_id
            ]);
        } catch (Exception $e)
        {
            if (isset($pdo) && $pdo->inTransaction())
                $pdo->rollBack();
            
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Unexpected error occurred'
            ]);
            error_log($e->getMessage());
        }
    }

    public function editRecipe()
    {
        try
        {
            $userId = getCurrentUserId();
            if ($userId === null)
            {
                http_response_code(401);
                echo json_encode([
                    'success' => false,
                    'message' => 'User not authorized'
                ]);
                return;
            }

            $input = json_decode(file_get_contents('php://input'), true);

            $pdo = $this->recipeRepository->getConnection();
            $pdo->beginTransaction();

            $category = $this->recipeRepository->getCategoryId($input['category']);

            $recipe_id = $input['recipe_id'];

            $recipe = [
                'recipe_id' => $recipe_id,
                'name' => $input['recipe_name'],
                'description' => $input['description'],
                'instruction' => $input['instruction'],
                'tips' => $input['tips'],
                'portions' => $input['portions'],
                'difficulty' => $input['difficulty'],
                'category_id' => $category['category_id']
            ];
            $this->recipeRepository->updateRecipe($recipe);

            $this->recipeRepository->deleteIngredients($recipe_id);
            foreach ($input['ingredients'] as $ingredient) 
            {
                $this->recipeRepository->createIngredient($ingredient, $recipe_id);
            }

            $this->recipeRepository->deleteTags($recipe_id);
            foreach ($input['tags'] as $tag) 
            {
                $this->recipeRepository->createTag($tag, $recipe_id);
            }
            
            $pdo->commit();

            echo json_encode([
                'success' => true,
                'recipe_id' => $recipe_id
            ]);
        } catch (Exception $e)
        {
            if (isset($pdo) && $pdo->inTransaction())
                $pdo->rollBack();
            
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Unexpected error occurred'
            ]);
            error_log($e->getMessage());
        }
    }

    public function deleteRecipe()
    {
        try
        {
            if (!isset($_GET['id']) || $_GET['id'] === '' || !is_numeric($_GET['id']))
            {
                http_response_code(400);
                echo json_encode([
                    'success' => false,
                    'message' => 'Invalid recipe id provided'
                ]);
                return;
            }
            
            $userId = getCurrentUserId();
            $recipeId = $_GET['id'];

            $recipe = $this->recipeRepository->getRecipeById($recipeId);
            if ($recipe === false)
            {
                http_response_code(404);
                echo json_encode([
                    'success' => false,
                    'message' => 'Recipe not found'
                ]);
                return;
            }

            if ($recipe['author_id'] != $userId)
            {
                http_response_code(401);
                echo json_encode([
                    'success' => false,
                    'message' => 'Unauthorized to perform this action'
                ]);
                return;
            }

            $this->recipeRepository->deleteRecipe($recipeId);

            echo json_encode([
                'success' => true
            ]);
        } catch (Exception $e)
        {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Unexpected error occurred'
            ]);
            error_log($e->getMessage());
        }
    }
}