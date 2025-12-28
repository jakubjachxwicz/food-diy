DROP TABLE IF EXISTS users;
CREATE TABLE users (
    user_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(30) NOT NULL,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(254) NOT NULL,
    password VARCHAR(60) NOT NULL,
    privilege_level INTEGER NOT NULL DEFAULT 3,
    CONSTRAINT unq_username UNIQUE (username),
    CONSTRAINT unq_email UNIQUE (email)
);

INSERT INTO public.users (username, first_name, last_name, email, password, privilege_level) 
VALUES ('admin', 'Admin', 'Admin', 'admin@admin.com', '$2y$12$HgRveHJvZNdy2kNREezU9ehxkwqWYeIHFpkRkEG6XFVrujg9/4XCK', 1);
INSERT INTO public.users (username, first_name, last_name, email, password, privilege_level) 
VALUES ('majamod', 'Maja', 'Mod', 'maja@mod.com', '$2y$12$HgRveHJvZNdy2kNREezU9ehxkwqWYeIHFpkRkEG6XFVrujg9/4XCK', 2);
INSERT INTO public.users (username, first_name, last_name, email, password, privilege_level) 
VALUES ('andrzejmod', 'Andrzej', 'Mod', 'andrzej@mod.com', '$2y$12$HgRveHJvZNdy2kNREezU9ehxkwqWYeIHFpkRkEG6XFVrujg9/4XCK', 2);

INSERT INTO public.users (username, first_name, last_name, email, password) 
VALUES ('jacex', 'Jacek', 'Mostek', 'jacek@mostek.com', '$2y$12$HgRveHJvZNdy2kNREezU9ehxkwqWYeIHFpkRkEG6XFVrujg9/4XCK');
INSERT INTO public.users (username, first_name, last_name, email, password) 
VALUES ('izaaa', 'Izabela', 'Trebeusz', 'iza@trebeusz.com', '$2y$12$HgRveHJvZNdy2kNREezU9ehxkwqWYeIHFpkRkEG6XFVrujg9/4XCK');