DROP TABLE IF EXISTS uzytkownicy;
CREATE TABLE uzytkownicy (
    uzytkownik_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazwa VARCHAR(30) NOT NULL,
    imie VARCHAR(40) NOT NULL,
    nazwisko VARCHAR(80) NOT NULL,
    email VARCHAR(254) NOT NULL,
    haslo VARCHAR(60) NOT NULL,
    poziom_uprawnien INTEGER NOT NULL DEFAULT 3,
    CONSTRAINT unq_nazwa UNIQUE (nazwa),
    CONSTRAINT unq_email UNIQUE (email)
);