-- Add sample data for the database tables that you create in this file


INSERT INTO users (first_name, last_name, location, age) VALUES
('John', 'Doe', 'New York, NY', 25),
('Jane', 'Smith', 'Los Angeles, CA', 30),
('Alice', 'Johnson', 'Chicago, IL', 27),
('Bob', 'Brown', 'San Francisco, CA', 22),
('Charlie', 'Davis', 'Austin, TX', 35);
 
INSERT INTO person (first_name, last_name, dob, place_of_birth) VALUES
('Robert', 'Downey', '1965-04-04', 'New York, NY'),
('Chris', 'Evans', '1981-06-13', 'Boston, MA'),
('Scarlett', 'Johansson', '1984-11-22', 'New York, NY'),
('Christopher', 'Nolan', '1970-07-30', 'London, UK'),
('Quentin', 'Tarantino', '1963-03-27', 'Knoxville, TN');
 
INSERT INTO movie (title, release_date, runtime, budget, revenue, overview) VALUES
('Iron Man', '2008-05-02', 126, 140000000, 585000000, 'A billionaire industrialist builds a powered exoskeleton.'),
('Avengers: Endgame', '2019-04-26', 181, 356000000, 2798000000, 'The Avengers assemble once more to undo Thanos'' actions.'),
('Lost in Translation', '2003-09-12', 102, 4000000, 119700000, 'A fading movie star and a young woman form an unlikely bond in Tokyo.'),
('Inception', '2010-07-16', 148, 160000000, 829900000, 'A thief steals corporate secrets through dream-sharing technology.'),
('Pulp Fiction', '1994-10-14', 154, 8000000, 213900000, 'The lives of two mob hitmen, a boxer, and a pair of diner bandits intertwine.');
 
INSERT INTO genre (name) VALUES
('Action'), ('Adventure'), ('Drama'), ('Comedy'), ('Thriller'), ('Sci-Fi'), ('Crime');
 
INSERT INTO movielists (name, description, user_id) VALUES
('Watchlist', 'Movies I want to watch', 1),
('Favorites', 'My favorite movies', 1),
('Watchlist', 'Movies I want to watch', 2),
('Favorites', 'My favorite movies', 2),
('Watchlist', 'Movies I want to watch', 3);
 
INSERT INTO movie_movielists (movie_id, movielists_id) VALUES
(1, 1),
(2, 1),
(3, 3),
(4, 2),
(5, 4);
 
INSERT INTO reviews (stars, body_text, user_id, movie_id) VALUES
('5', 'Amazing performance by Robert Downey Jr.', 1, 1),
('4', 'Loved the action scenes!', 2, 1),
('5', 'Mind-blowing movie, Nolan is genius!', 3, 4),
('3', 'Good but a bit confusing.', 1, 4),
('5', 'Classic Tarantino style.', 2, 5);
 
INSERT INTO comment (body_text, user_id, review_id) VALUES
('Totally agree!', 2, 1),
('I felt the same way.', 3, 2),
('Nolan never disappoints.', 1, 3),
('Confusing but enjoyable.', 4, 4),
('Pulp Fiction is timeless.', 5, 5);
 
INSERT INTO likes (is_liked, user_id, review_id) VALUES
(TRUE, 1, 2),
(TRUE, 2, 3),
(TRUE, 3, 1),
(TRUE, 4, 5),
(TRUE, 5, 4);
 
INSERT INTO follow (follower_id, following_id) VALUES
(1, 2),
(1, 3),
(2, 1),
(3, 4),
(4, 5),
(5, 1);
 
INSERT INTO crew (person_id, movie_id, job) VALUES
(4, 4, 'Director'),  -- Christopher Nolan directs Inception
(5, 5, 'Director');  -- Quentin Tarantino directs Pulp Fiction
 
INSERT INTO movie_cast (person_id, movie_id, character_name, cast_order) VALUES
(1, 1, 'Tony Stark / Iron Man', 1),
(2, 2, 'Steve Rogers / Captain America', 1),
(3, 1, 'Natasha Romanoff / Black Widow', 2);
 
INSERT INTO movie_genre (movie_id, genre_id) VALUES
(1, 1), (1, 2),    -- Iron Man: Action, Adventure
(2, 1), (2, 2),    -- Avengers: Action, Adventure
(3, 3),             -- Lost in Translation: Drama
(4, 1), (4, 6),    -- Inception: Action, Sci-Fi
(5, 3), (5, 7);    -- Pulp Fiction: Drama, Crime