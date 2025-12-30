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
}