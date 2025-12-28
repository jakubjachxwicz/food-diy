<?php

require_once 'config/session.php';
require_once 'src/repositories/UserRepository.php';

class AuthController 
{
    private static $instance = null;
    
    private UserRepository $userRepository;

    private function __clone() {}
    public function __wakeup()
    {
        throw new \Exception("Cannot unserialize singleton");
    }

    public static function getInstance(UserRepository $repository): self
    {
        if (self::$instance === null) {
            self::$instance = new self($repository);
        }

        return self::$instance;
    }

    private function __construct(UserRepository $repository) 
    {
        $this->userRepository = $repository;

        header('Content-Type: application/json');
    }

    public function handleRegister()
    {
        try 
        {
            $input = json_decode(file_get_contents('php://input'), true);
            
            $errors = $this->validateRegistration($input);
            if (!empty($errors)) 
            {
                http_response_code(400);
                echo json_encode([
                    'success' => false,
                    'errors' => $errors
                ]);
                return;
            }
            
            if ($this->userRepository->findByEmail($input['email'])) 
            {
                http_response_code(409);
                echo json_encode([
                    'success' => false,
                    'message' => 'Email is taken'
                ]);
                return;
            }
            
            $passwordHash = password_hash($input['password'], PASSWORD_BCRYPT, ['cost' => 12]);
            
            $userId = $this->userRepository->createUser([
                'firstName' => $input['firstName'],
                'lastName' => $input['lastName'],
                'username' => $input['username'],
                'email' => $input['email'],
                'passwordHash' => $passwordHash
            ]);

            if ($userId) 
            {
                $_SESSION['user_id'] = $userId;
                $_SESSION['email'] = $input['email'];
                regenerateSession();
                
                http_response_code(201);
                echo json_encode([
                    'success' => true,
                    'message' => 'User registered successfully',
                    'user' => [
                        'id' => $userId,
                        'email' => $input['email']
                    ]
                ]);
            } else 
            {
                throw new Exception('Failed to create user');
            }
            
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
    
    public function handleLogin()
    {
        try 
        {
            $input = json_decode(file_get_contents('php://input'), true);
            
            if (empty($input['email']) || empty($input['password'])) 
            {
                http_response_code(400);
                echo json_encode([
                    'success' => false,
                    'message' => 'Email and password required'
                ]);
                return;
            }
            
            $user = $this->userRepository->findByEmail($input['email']);
            
            if (!$user) 
            {
                http_response_code(401);
                echo json_encode([
                    'success' => false,
                    'message' => 'Invalid credentials'
                ]);
                return;
            }
            
            if (!password_verify($input['password'], $user['password_hash'])) 
            {
                http_response_code(401);
                echo json_encode([
                    'success' => false,
                    'message' => 'Invalid credentials'
                ]);
                return;
            }
            
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['email'] = $user['email'];
            regenerateSession();
            
            $this->userRepository->updateLastLogin($user['id']);
            
            echo json_encode([
                'success' => true,
                'message' => 'Login successful',
                'user' => [
                    'id' => $user['id'],
                    'email' => $user['email'],
                    'name' => $user['name'] ?? ''
                ]
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
    
    public function handleLogout()
    {
        session_destroy();
        
        echo json_encode([
            'success' => true,
            'message' => 'Logged out successfully'
        ]);
    }
    
    public function checkAuth()
    {
        if (isAuthenticated()) 
        {
            $userId = getCurrentUserId();
            $user = $this->userRepository->getById($userId);
            
            echo json_encode([
                'success' => true,
                'authenticated' => true,
                'user' => [
                    'id' => $user['id'],
                    'email' => $user['email'],
                    'name' => $user['name'] ?? ''
                ]
            ]);
        } else 
        {
            echo json_encode([
                'success' => true,
                'authenticated' => false
            ]);
        }
    }
    
    // TODO: Improve this
    private function validateRegistration($input): array
    {
        $errors = [];
        
        if (empty($input['email'])) 
            {
            $errors['email'] = 'Email is required';
        } elseif (!filter_var($input['email'], FILTER_VALIDATE_EMAIL)) 
        {
            $errors['email'] = 'Invalid email format';
        }
        
        if (empty($input['password'])) 
        {
            $errors['password'] = 'Password is required';
        } elseif (strlen($input['password']) < 8) 
        {
            $errors['password'] = 'Password must be at least 8 characters';
        }
        
        if (isset($input['password_confirm']) && $input['password'] !== $input['password_confirm']) 
        {
            $errors['password_confirm'] = 'Passwords do not match';
        }
        
        return $errors;
    }
}