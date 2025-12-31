<?php

require_once 'src/repositories/RecipeRepository.php';

class RecipeController
{
    private static $instance = null;
    private RecipeRepository $recipeRepository;

    private function __construct(RecipeRepository $repository) 
    {
        $this->recipeRepository = $repository;

        header('Content-Type: application/json');
    }

    private function __clone() {}
    public function __wakeup()
    {
        throw new \Exception("Cannot unserialize singleton");
    }

    public static function getInstance(RecipeRepository $repository): self
    {
        if (self::$instance === null) 
        {
            self::$instance = new self($repository);
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
                $recipe['tags'] = $this->recipeRepository->getRecipeTags($recipe['recipe_id']);
                $result[] = $recipe;
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
                $recipe['tags'] = $this->recipeRepository->getRecipeTags($recipe['recipe_id']);
                $result[] = $recipe;
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
}