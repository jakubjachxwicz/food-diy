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
        foreach ($this->users as $user) {
            if ($user['id'] === $id) {
                return $user;
            }
        }
        return null;
    }
    
    public function updateLastLogin(int $userId): void
    {
        foreach ($this->users as $key => $user) {
            if ($user['id'] === $userId) {
                $this->users[$key]['last_login'] = date('Y-m-d H:i:s');
                break;
            }
        }       
    }
}