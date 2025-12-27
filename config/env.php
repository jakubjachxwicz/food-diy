<?php

$env_file = __DIR__ . '/../.env';

if (!file_exists($env_file)) 
{
    throw new RuntimeException('.env file not found');
}

$lines = file($env_file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

foreach ($lines as $line) 
{
    if (str_starts_with(trim($line), '#')) 
        continue;

    [$name, $value] = array_map('trim', explode('=', $line, 2));
    $value = trim($value, "\"'");

    $_ENV[$name] = $value;
    putenv("$name=$value");
}