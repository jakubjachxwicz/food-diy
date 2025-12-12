<?php

class UserRepository 
{
    private $users = [];
    
    public function __construct()
    {
        $this->users = [
            [
                'id' => 1,
                'firstName' => 'John',
                'lastName' => 'Doe',
                'username' => 'johndoe',
                'email' => 'john@doe.com',
                'passwordHash' => '$2y$12$examplehashstringforpassword1234567890'
            ]
        ];
    }

    public function createUser(array $user): ?int 
    {
        $newId = count($this->users) + 1;
        
        $user['id'] = $newId;
        
        $this->users[] = $user;
        
        return $newId;
    }
    
    public function findByEmail(string $email): ?array
    {
        foreach ($this->users as $user) {
            if ($user['email'] === $email) {
                return $user;
            }
        }       
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