<?php

require_once('Repository.php');

class RecipeRepository extends Repository
{
    public function getPopularRecipes()
    {
        $query = $this->database->connect()->query('
            SELECT recipe_id, recipe_name, author_id, users.username AS author, views, active, 
                fun_recipe_rating(recipe_id) AS rating, categories.category_name AS category
            FROM recipes
            JOIN users ON users.user_id = recipes.author_id
            JOIN categories ON categories.category_id = recipes.category_id
            WHERE fun_recipe_rating(recipe_id) IS NOT NULL
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
            SELECT recipe_id, recipe_name, author_id, users.username AS author, views, active, 
            fun_recipe_rating(recipe_id) AS rating, categories.category_name AS category
            FROM recipes
            JOIN users ON users.user_id = recipes.author_id
            JOIN categories ON categories.category_id = recipes.category_id
            WHERE categories.category_name = :category
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
            SELECT r.recipe_id, r.recipe_name, author_id, u.username AS author, r.views, active,
                fun_recipe_rating(r.recipe_id) AS rating, c.category_name AS category
            FROM recipes r
            JOIN users u ON u.user_id = r.author_id
            JOIN categories c ON c.category_id = r.category_id
            WHERE EXISTS (
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
            SELECT recipe_id, recipe_name, author_id, users.username AS author, views, active,
                fun_recipe_rating(recipe_id) AS rating, categories.category_name AS category
            FROM recipes
            JOIN users ON users.user_id = recipes.author_id
            JOIN categories ON categories.category_id = recipes.category_id
            WHERE recipe_name ILIKE :search
            LIMIT 10
        ');

        $param = '%' . $searchTerm . '%';
        $query->bindParam(':search', $param);
        $query->execute();

        return $query->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getRecipeById($id)
    {
        $query = $this->database->connect()->prepare('
            SELECT recipe_id, recipe_name, recipe_description, instruction, tips, portions, author_id, users.username AS author, 
                views, date_added, active, difficulty, fun_recipe_rating(recipe_id) AS rating, categories.category_name AS category
            FROM recipes
            JOIN users ON users.user_id = recipes.author_id
            JOIN categories ON categories.category_id = recipes.category_id
            WHERE recipe_id = :id
        ');

        $query->bindParam(':id', $id);
        $query->execute();

        return $query->fetch(PDO::FETCH_ASSOC);
    }

    public function getIngredientsByRecipeId($id)
    {
        $query = $this->database->connect()->prepare('
            SELECT ingredient_name FROM ingredients
            WHERE recipe_id = :id
        ');

        $query->bindParam(':id', $id);
        $query->execute();

        return $query->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getIsRecipeFavourite($userId, $recipeId)
    {
        $query = $this->database->connect()->prepare('
            SELECT 1 FROM favourite_recipes
            WHERE recipe_id = :recipeId AND user_id = :userId
        ');

        $query->bindParam(':recipeId', $recipeId);
        $query->bindParam(':userId', $userId);
        $query->execute();

        return $query->fetch();
    }

    public function setRecipeFavourite($userId, $recipeId)
    {
        $query = $this->database->connect()->prepare('
            INSERT INTO favourite_recipes(recipe_id, user_id)
            VALUES (:recipeId, :userId)
            ON CONFLICT (recipe_id, user_id) DO NOTHING
        ');

        $query->bindParam(':recipeId', $recipeId);
        $query->bindParam(':userId', $userId);
        $query->execute();
    }

    public function removeFavouriteRecipe($userId, $recipeId)
    {
        $query = $this->database->connect()->prepare('
            DELETE FROM favourite_recipes
            WHERE recipe_id = :recipeId AND user_id = :userId
        ');

        $query->bindParam(':recipeId', $recipeId);
        $query->bindParam(':userId', $userId);
        $query->execute();
    }

    public function toggleFavouriteRecipe($userId, $recipeId)
    {
        $query = $this->database->connect()->prepare('
        DO $$
        BEGIN
            IF EXISTS (
                SELECT 1
                FROM favourite_recipes
                WHERE recipe_id = :recipeId
                AND user_id = :userId
            ) THEN
                DELETE FROM favourite_recipes
                WHERE recipe_id = :recipeId
                AND user_id = :userId;
            ELSE
                INSERT INTO favourite_recipes(recipe_id, user_id)
                VALUES (:recipeId, :userId);
            END IF;
        END $$;
        ');

        $query->bindParam(':recipeId', $recipeId);
        $query->bindParam(':userId', $userId);
        $query->execute();
    }

    public function getUserRatingForRecipe($userId, $recipeId)
    {
        $query = $this->database->connect()->prepare('
            SELECT rating FROM recipe_ratings
            WHERE recipe_id = :recipeId AND user_id = :userId
        ');

        $query->bindParam(':recipeId', $recipeId);
        $query->bindParam(':userId', $userId);
        $query->execute();

        return $query->fetch(PDO::FETCH_ASSOC);
    }

    public function saveRecipeRate($userId, $recipeId, $rate)
    {
        $query = $this->database->connect()->prepare('
            INSERT INTO recipe_ratings (recipe_id, user_id, rating)
            VALUES (:recipeId, :userId, :rate)
            ON CONFLICT (recipe_id, user_id)
            DO UPDATE SET rating = EXCLUDED.rating
        ');

        $query->bindParam(':recipeId', $recipeId);
        $query->bindParam(':userId', $userId);
        $query->bindParam(':rate', $rate);
        $query->execute();
    }

    public function getRecipesForUser($userId)
    {
        $query = $this->database->connect()->prepare('
            SELECT recipe_id, recipe_name
            FROM recipes
            WHERE author_id = :userId
        ');

        $query->bindParam(':userId', $userId);
        $query->execute();

        return $query->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getFavouriteRecipes($userId)
    {
        $query = $this->database->connect()->prepare('
            SELECT recipes.recipe_id, recipe_name, active, author_id
            FROM recipes
            JOIN favourite_recipes 
            ON favourite_recipes.recipe_id = recipes.recipe_id
            WHERE favourite_recipes.user_id = :userId
        ');

        $query->bindParam(':userId', $userId);
        $query->execute();

        return $query->fetchAll(PDO::FETCH_ASSOC);
    }

    public function createRecipe($recipe)
    {
        $query = $this->database->connect()->prepare('
            INSERT INTO recipes
            (recipe_name, recipe_description, instruction, tips, portions, author_id, date_added, active, views, difficulty, category_id)
        ');

        $query->bindParam(':userId', $userId);
        $query->execute();

        return $query->fetchAll(PDO::FETCH_ASSOC);
    }
}