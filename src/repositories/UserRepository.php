<?php

require_once 'Repository.php';

class UserRepository extends Repository
{
    public function createUser(array $user): ?int 
    {
        $query = $this->database->connect()->prepare(
            'INSERT INTO users (username, first_name, last_name, email, password) 
            VALUES (:username, :firstName, :lastName, :email, :password)
            RETURNING user_id'
        );

        $query->bindParam(':username', $user['username']);
        $query->bindParam(':firstName', $user['firstName']);
        $query->bindParam(':lastName', $user['lastName']);
        $query->bindParam(':email', $user['email']);
        $query->bindParam(':password', $user['password']);

        $query->execute();
        
        return $query->fetchColumn();
    }
    
    public function findByEmail(string $email)
    {
        $query = $this->database->connect()->prepare('
            SELECT * FROM users 
            WHERE email = :email
        ');

        $query->bindParam(':email', $email);
        $query->execute();

        if ($query->rowCount() == 0)
            return null;

        $row = $query->fetch();
        return [
            'user_id' => $row['user_id'],
            'username' => $row['username'],
            'firstName' => $row['first_name'],
            'lastName' => $row['last_name'],
            'email' => $row['email'],
            'password' => $row['password'],
            'privilege_level' => $row['privilege_level']
        ];
    }
    
    public function getById(int $id): ?array
    {
        $query = $this->database->connect()->prepare('
            SELECT * FROM users
            WHERE user_id = :userId
        ');

        $query->bindParam(':userId', $id);
        $query->execute();

        return $query->fetch(PDO::FETCH_ASSOC);
    }

    public function getUserRole(int $userId)
    {
        $query = $this->database->connect()->prepare('
            SELECT privilege_level FROM users 
            WHERE user_id = :id
        ');

        $query->bindParam(':id', $userId);
        $query->execute();

        return $query->fetch();
    }

    public function getAllUsers()
    {
        $query = $this->database->connect()->prepare('
            SELECT user_id, email, privilege_level 
            FROM users 
            WHERE privilege_level != 1
        ');

        $query->execute();

        return $query->fetchAll(PDO::FETCH_ASSOC);
    }

    public function updateRoleForUser($userId, $role)
    {
        $query = $this->database->connect()->prepare('
            UPDATE users
            SET privilege_level = :role
            WHERE user_id = :user_id
        ');

        $query->bindParam(':user_id', $userId);
        $query->bindParam(':role', $role);
        $query->execute();
    }
}