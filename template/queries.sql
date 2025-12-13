-- Add any queries that you write against the database in this file
-- Add any stored procedures, triggers, or views as needed here

SELECT m.title, g.name AS genre
FROM movie m
JOIN movie_genre mg ON m.id = mg.movie_id
JOIN genre g ON mg.genre_id = g.id
ORDER BY m.title;
--lsists the moviees with they genres
 
SELECT u.first_name, u.last_name, m.title, r.stars, r.body_text
FROM reviews r
JOIN users u ON r.user_id = u.id
JOIN movie m ON r.movie_id = m.id;
--lists reviews with usernames and tites
 
SELECT m.title, AVG(r.stars) AS avg_rating
FROM movie m
LEFT JOIN reviews r ON m.id = r.movie_id
GROUP BY m.id
ORDER BY avg_rating DESC;
--lists movies with they avg ratings
 
SELECT m.title, COUNT(*) AS genre_count
FROM movie m
JOIN movie_genre mg ON m.id = mg.movie_id
GROUP BY m.id
HAVING COUNT(*) > 1;
--shows movies with more than one genre
 
SELECT
    title,
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM movie;
--orders movies by revenue
 
(
    SELECT 
        m.title,
        r.stars,
        COUNT(*) AS review_count
    FROM reviews r
    JOIN movie m ON r.movie_id = m.id
    GROUP BY m.title, r.stars
)
UNION ALL
(
    SELECT
        m.title,
        NULL AS stars,
        COUNT(*) AS review_count
    FROM reviews r
    JOIN movie m ON r.movie_id = m.id
    GROUP BY m.title
)
UNION ALL
(

    SELECT
        NULL AS title,
        NULL AS stars,
        COUNT(*) AS review_count
    FROM reviews
);
--shows movies with number of reviews per star rating, total reviews per movie, and overall total reviews
 
WITH RECURSIVE follow_graph AS (

    SELECT 
        follower_id,
        following_id,
        CAST(CONCAT(follower_id, ',', following_id) AS CHAR(200)) AS path
    FROM follow
    WHERE follower_id = 1

    UNION ALL

    SELECT
        f.follower_id,
        f.following_id,
        CONCAT(fg.path, ',', f.following_id)
    FROM follow f
    JOIN follow_graph fg 
        ON fg.following_id = f.follower_id
    WHERE FIND_IN_SET(f.following_id, fg.path) = 0
)
SELECT DISTINCT following_id
FROM follow_graph
WHERE following_id != 1;
--shows all users followed directly or indirectly by user 1
 
SELECT u.id, u.first_name, u.last_name
FROM users u
WHERE NOT EXISTS (
    SELECT ml.id
    FROM movielists ml
    JOIN movie_movielists mml ON ml.id = mml.movielists_id
    WHERE ml.user_id = u.id AND ml.name = 'Favorites'              
    AND NOT EXISTS (
        SELECT 1
        FROM reviews r
        WHERE r.user_id = u.id
        AND r.movie_id = mml.movie_id
    )
);
--shows users who have reviewed movies in their fav list
 
SELECT
    p.first_name,
    p.last_name,
    AVG(m.revenue) AS avg_revenue
FROM crew c
JOIN person p ON c.person_id = p.id
JOIN movie m ON c.movie_id = m.id
WHERE c.job = 'Director'
GROUP BY p.id
ORDER BY avg_revenue DESC;
--lists directors with their average movie interview and lists them in order starting from the highest
 
CREATE INDEX idx_reviews_movie ON reviews(movie_id);
CREATE INDEX idx_movie_cast_person ON movie_cast(person_id);
--indexs
 
DELIMITER $$

CREATE TRIGGER validate_like
BEFORE INSERT ON likes
FOR EACH ROW
BEGIN
    IF (NEW.review_id IS NOT NULL AND NEW.comment_id IS NOT NULL)
       OR (NEW.review_id IS NULL AND NEW.comment_id IS NULL) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Like must reference exactly one target.';
    END IF;
END$$

DELIMITER ;
--ensures that a like references either a review or a comment, but not both or neither - this one was created with the help of chatgpt
 
CREATE USER 'gunnercoleman'@'localhost' IDENTIFIED BY 'Password1234';
GRANT SELECT, INSERT, UPDATE, DELETE ON letterboxed.* TO 'gunnercoleman'@'localhost';
DROP USER 'gunnercoleman'@'localhost';
 
INSERT INTO users (first_name, last_name, location, age)
VALUES ('Konrad', 'sankiewicz', 'dublin', 19);
 
SELECT
    u.id,
    u.first_name,
    u.last_name,
    u.location,
    u.age,
 
   
    (
        SELECT COUNT(*)
        FROM follow f
        WHERE f.follower_id = u.id
    ) AS following_count,
 
   
    (
        SELECT COUNT(*)
        FROM follow f
        WHERE f.following_id = u.id
    ) AS follower_count
 
FROM users u
WHERE u.id = 1;  
 
UPDATE users
SET
    first_name = 'John',
    last_name = 'Williams',
    location = 'Houston, TX',
    age = 30
WHERE id = 1;
 
DELIMITER $$
 
CREATE PROCEDURE create_user_account (
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_location VARCHAR(150),
    IN p_age INT
)
BEGIN
    INSERT INTO users (first_name, last_name, location, age)
    VALUES (p_first_name, p_last_name, p_location, p_age);
END $$
 
DELIMITER ;
 
CALL create_user_account('firstname', 'surname', 'location', age);
 
DELIMITER $$
 
CREATE PROCEDURE get_user_profile (
    IN p_user_id BIGINT
)
BEGIN
    SELECT
        u.id,
        u.first_name,
        u.last_name,
        u.location,
        u.age,
 
        -- Following count
        (SELECT COUNT(*)
         FROM follow f
         WHERE f.follower_id = u.id) AS following_count,
 
        -- Follower count
        (SELECT COUNT(*)
         FROM follow f
         WHERE f.following_id = u.id) AS follower_count
    FROM users u
    WHERE u.id = p_user_id;
END $$
 
DELIMITER ;
CALL get_user_profile(1);
DELIMITER $$
 
CREATE PROCEDURE update_user_profile (
    IN p_user_id BIGINT,
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_location VARCHAR(150),
    IN p_age INT
)
BEGIN
    UPDATE users
    SET
        first_name = p_first_name,
        last_name = p_last_name,
        location = p_location,
        age = p_age
    WHERE id = p_user_id;
END $$
 
DELIMITER ;
 
CALL update_user_profile(
    1,
    'name',
    'surname',
    'location',
    age
);
 
DELIMITER $$
 
CREATE PROCEDURE follow_user (
    IN p_follower_id BIGINT,
    IN p_following_id BIGINT
)
BEGIN
    -- Prevent following yourself
    IF p_follower_id = p_following_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'You cannot follow yourself.';
    END IF;
 
    -- Check if the relationship already exists
    IF EXISTS (
        SELECT 1
        FROM follow
        WHERE follower_id = p_follower_id
          AND following_id = p_following_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Already following this user.';
    END IF;
 
    -- Insert the follow relationship
    INSERT INTO follow (follower_id, following_id)
    VALUES (p_follower_id, p_following_id);
END $$
 
DELIMITER ;
 
CALL follow_user(1, 6);
 
DELIMITER $$
 
CREATE PROCEDURE unfollow_user (
    IN p_follower_id BIGINT,
    IN p_following_id BIGINT
)
BEGIN
    -- Check if the relationship exists
    IF NOT EXISTS (
        SELECT 1
        FROM follow
        WHERE follower_id = p_follower_id
          AND following_id = p_following_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'You are not following this user.';
    END IF;
 
    -- Delete the follow relationship
    DELETE FROM follow
    WHERE follower_id = p_follower_id
      AND following_id = p_following_id;
END $$
 
DELIMITER ;
CALL unfollow_user(1, 3);  -- User 1 unfollows User 3
 
 
DELIMITER $$
 
CREATE PROCEDURE log_movie (
    IN p_user_id BIGINT,
    IN p_movie_id BIGINT,
    IN p_stars ENUM('1','2','3','4','5'),
    IN p_review_text TEXT,
    IN p_like TINYINT(1)
)
BEGIN
    DECLARE new_review_id BIGINT;
 
    -- 1. Insert review/log entry (rating and text are optional)
    INSERT INTO reviews (stars, body_text, user_id, movie_id)
    VALUES (p_stars, p_review_text, p_user_id, p_movie_id);
 
    SET new_review_id = LAST_INSERT_ID();
 
 
    -- 2. If user wants to "like" the movie log, insert into likes table
    IF p_like = 1 THEN
        INSERT INTO likes (is_liked, user_id, review_id)
        VALUES (1, p_user_id, new_review_id);
    END IF;
 
 
    -- 3. Automatically remove the movie from the user's Watchlist
    DELETE mm
    FROM movie_movielists mm
    JOIN movielists ml
        ON mm.movielists_id = ml.id
    WHERE ml.user_id = p_user_id
      AND ml.name = 'Watchlist'
      AND mm.movie_id = p_movie_id;
 
END $$
 
DELIMITER ;
 
CALL log_movie(user_id, movie_id, 'stars', 'reviewtext', like);
CALL log_movie(1, 4, '5', 'Amazing movie!', 1);
 
DELIMITER $$
 
CREATE PROCEDURE search_movies (
    IN p_query VARCHAR(255)
)
BEGIN
    SELECT
        m.id,
        m.title,
        m.release_date,
        m.runtime
    FROM movie m
    WHERE LOWER(m.title) LIKE CONCAT('%', LOWER(p_query), '%')
    ORDER BY m.title;
END $$
 
DELIMITER ;
CALL search_movies('searchtermgoeshere');
 
DELIMITER $$
 
CREATE PROCEDURE search_actors (
    IN p_query VARCHAR(255)
)
BEGIN
    SELECT
        p.id AS person_id,
        CONCAT(p.first_name, ' ', p.last_name) AS actor_name,
        m.title AS movie,
        mc.character_name
    FROM person p
    JOIN movie_cast mc ON p.id = mc.person_id
    JOIN movie m ON mc.movie_id = m.id
    WHERE LOWER(CONCAT(p.first_name, ' ', p.last_name))
          LIKE CONCAT('%', LOWER(p_query), '%')
    ORDER BY actor_name;
END $$
 
DELIMITER ;
CALL search_actors('scar');
 
DELIMITER $$
 
CREATE PROCEDURE search_all (
    IN p_query VARCHAR(255)
)
BEGIN
    (
        SELECT
            'movie' AS type,
            m.id AS entity_id,
            m.title AS name
        FROM movie m
        WHERE LOWER(m.title) LIKE CONCAT('%', LOWER(p_query), '%')
    )
   
    UNION
   
    (
        SELECT
            'actor' AS type,
            p.id AS entity_id,
            CONCAT(p.first_name, ' ', p.last_name) AS name
        FROM person p
        JOIN movie_cast mc ON mc.person_id = p.id
        WHERE LOWER(CONCAT(p.first_name, ' ', p.last_name))
              LIKE CONCAT('%', LOWER(p_query), '%')
    )
   
    UNION
   
    (
        SELECT
            'crew' AS type,
            p.id AS entity_id,
            CONCAT(p.first_name, ' ', p.last_name) AS name
        FROM person p
        JOIN crew c ON c.person_id = p.id
        WHERE LOWER(CONCAT(p.first_name, ' ', p.last_name))
              LIKE CONCAT('%', LOWER(p_query), '%')
    )
   
    ORDER BY name;
END $$
 
DELIMITER ;
CALL search_all('anything');
