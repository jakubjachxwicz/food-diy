<?php

require_once('Repository.php');

class RecipeRepository extends Repository
{
    public function getPopularRecipes()
    {
        $query = $this->database->connect()->query('
            SELECT recipe_id, recipe_name, users.username AS author, views, 
                fun_recipe_rating(recipe_id) AS rating, categories.category_name AS category
            FROM recipes
            JOIN users ON users.user_id = recipes.author_id
            JOIN categories ON categories.category_id = recipes.category_id
            WHERE active = true AND fun_recipe_rating(recipe_id) IS NOT NULL
            ORDER BY fun_recipe_rating(recipe_id) DESC
            LIMIT 10
        ');
        $rows = $query->fetchAll(PDO::FETCH_ASSOC);

        return $rows;
    }

    public function getRecipeTags($recipeId)
    {
        $query = $this->database->connect()->prepare('
            SELECT tag_name FROM tags
            JOIN tags_recipes ON tags.tag_id = tags_recipes.tag_id
            WHERE tags_recipes.recipe_id = :recipeId
        ');

        $query->bindParam(':recipeId', $recipeId);
        $query->execute();

        return $query->fetchAll(PDO::FETCH_COLUMN);
    }

    public function getRecipesByCategory($category)
    {
        $query = $this->database->connect()->prepare('
            SELECT recipe_id, recipe_name, users.username AS author, views, 
            fun_recipe_rating(recipe_id) AS rating, categories.category_name AS category
            FROM recipes
            JOIN users ON users.user_id = recipes.author_id
            JOIN categories ON categories.category_id = recipes.category_id
            WHERE active = true AND categories.category_name = :category
            LIMIT 10
        ');

        $query->bindParam(':category', $category);
        $query->execute();

        return $query->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getAllCategories()
    {
        $query = $this->database->connect()->query('
            SELECT category_name FROM categories
        ');
        $rows = $query->fetchAll(PDO::FETCH_COLUMN);

        return $rows;
    }

    public function getRecipesByTag($tag)
    {
        $query = $this->database->connect()->prepare('
            SELECT r.recipe_id, r.recipe_name, u.username AS author, r.views,
                fun_recipe_rating(r.recipe_id) AS rating, c.category_name AS category
            FROM recipes r
            JOIN users u ON u.user_id = r.author_id
            JOIN categories c ON c.category_id = r.category_id
            WHERE r.active = true AND EXISTS (
              SELECT 1
              FROM tags_recipes tr
              JOIN tags tt ON tr.tag_id = tt.tag_id
              WHERE tr.recipe_id = r.recipe_id
            	AND tt.tag_name = :tag
            )
            LIMIT 10;
        ');

        $query->bindParam(':tag', $tag);
        $query->execute();

        return $query->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getAllTags()
    {
        $query = $this->database->connect()->query('
            SELECT tag_name FROM tags
        ');
        $rows = $query->fetchAll(PDO::FETCH_COLUMN);

        return $rows;
    }

    public function getRecipesBySearchTerm($searchTerm)
    {
        $query = $this->database->connect()->prepare('
            SELECT recipe_id, recipe_name, users.username AS author, views,
                fun_recipe_rating(recipe_id) AS rating, categories.category_name AS category
            FROM recipes
            JOIN users ON users.user_id = recipes.author_id
            JOIN categories ON categories.category_id = recipes.category_id
            WHERE active = true AND recipe_name ILIKE :search
            LIMIT 10
        ');

        $param = '%' . $searchTerm . '%';
        $query->bindParam(':search', $param);
        $query->execute();

        return $query->fetchAll(PDO::FETCH_ASSOC);
    }
}