<?php

require_once 'Repository.php';

class UserRepository extends Repository
{
    private $users = [];
    
    // public function __construct()
    // {
    //     $this->users = [
    //         [
    //             'id' => 1,
    //             'firstName' => 'John',
    //             'lastName' => 'Doe',
    //             'username' => 'johndoe',
    //             'email' => 'john@doe.com',
    //             'passwordHash' => '$2y$12$examplehashstringforpassword1234567890'
    //         ]
    //     ];
    // }

    public function createUser(array $user): ?int 
    {
        $query = $this->database->connect()->prepare(
            'INSERT INTO uzytkownicy (nazwa, imie, nazwisko, email, haslo) 
            VALUES (:nazwa, :imie, :nazwisko, :email, :password)
            RETURNING uzytkownik_id'
        );

        $query->bindParam(':nazwa', $user['username']);
        $query->bindParam(':imie', $user['firstName']);
        $query->bindParam(':nazwisko', $user['lastName']);
        $query->bindParam(':email', $user['email']);
        $query->bindParam(':password', $user['passwordHash']);

        $query->execute();
        
        return $query->fetchColumn();
    }
    
    public function findByEmail(string $email)
    {
        // foreach ($this->users as $user) {
        //     if ($user['email'] === $email) {
        //         return $user;
        //     }
        // }       
        return null;
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