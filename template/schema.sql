-- Add your database schema definitions (CREATE TABLE statements) here
-- Add any necessary indexes, constraints, or relationships between tables
-- Add any user roles or permissions
--
-- You are NOT required to add the schema for tables provided to you in the movies.sql database.


CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    location VARCHAR(150),
    age INT UNSIGNED
);
 
 
CREATE TABLE person (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    place_of_birth VARCHAR(150) NOT NULL
);
 
 
CREATE TABLE movie (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    release_date DATE NOT NULL,
    runtime SMALLINT UNSIGNED NOT NULL,
    budget BIGINT UNSIGNED NOT NULL,
    revenue BIGINT UNSIGNED NOT NULL,
    overview TEXT NOT NULL
);
 
 
CREATE TABLE genre (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);
 
 
CREATE TABLE movielists (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
 
 
CREATE TABLE reviews (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    stars ENUM('1','2','3','4','5') NOT NULL,
    body_text TEXT NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    movie_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (movie_id) REFERENCES movie(id)
);
 
 
CREATE TABLE comment (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    body_text VARCHAR(500) NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    review_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (review_id) REFERENCES reviews(id)
);
 
 
CREATE TABLE likes (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    is_liked BOOLEAN NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    review_id BIGINT UNSIGNED,
    comment_id BIGINT UNSIGNED,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (review_id) REFERENCES reviews(id),
    FOREIGN KEY (comment_id) REFERENCES comment(id)
);
 
 
CREATE TABLE follow (
    follower_id BIGINT UNSIGNED NOT NULL,
    following_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (follower_id, following_id),
    FOREIGN KEY (follower_id) REFERENCES users(id),
    FOREIGN KEY (following_id) REFERENCES users(id)
);
 
 
CREATE TABLE crew (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    person_id BIGINT UNSIGNED NOT NULL,
    movie_id BIGINT UNSIGNED NOT NULL,
    job ENUM('Director','Producer','Screenplay','Writer','Executive producer') NOT NULL,
    FOREIGN KEY (person_id) REFERENCES person(id),
    FOREIGN KEY (movie_id) REFERENCES movie(id)
);
 
 
CREATE TABLE movie_cast (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    person_id BIGINT UNSIGNED NOT NULL,
    movie_id BIGINT UNSIGNED NOT NULL,
    character_name VARCHAR(100) NOT NULL,
    cast_order SMALLINT UNSIGNED,
    FOREIGN KEY (person_id) REFERENCES person(id),
    FOREIGN KEY (movie_id) REFERENCES movie(id)
);
 
CREATE TABLE movie_genre (
    movie_id BIGINT UNSIGNED NOT NULL,
    genre_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (movie_id, genre_id),
    FOREIGN KEY (movie_id) REFERENCES movie(id),
    FOREIGN KEY (genre_id) REFERENCES genre(id)
);
 
 
CREATE TABLE movie_movielists (
    movie_id BIGINT UNSIGNED NOT NULL,
    movielists_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (movie_id, movielists_id),
    FOREIGN KEY (movie_id) REFERENCES movie(id),
    FOREIGN KEY (movielists_id) REFERENCES movielists(id)
);
 







 