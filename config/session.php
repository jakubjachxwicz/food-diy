<?php

ini_set('session.cookie_httponly', 1);
ini_set('session.cookie_secure', 0);
ini_set('session.cookie_samesite', 'Strict');
ini_set('session.use_only_cookies', 1);
ini_set('session.use_strict_mode', 1);
ini_set('session.cookie_lifetime', 0);
ini_set('session.gc_maxlifetime', 3600);

session_name('FOOD_DIY_SESSION');

if (session_status() === PHP_SESSION_NONE) 
{
    session_start();
}

function regenerateSession() 
{
    session_regenerate_id(true);
}

function isAuthenticated(): bool 
{
    return isset($_SESSION['user_id']) && $_SESSION['user_id'] > 0;
}

function getCurrentUserId(): ?int 
{
    return $_SESSION['user_id'] ?? null;
}