-- Add your database schema definitions (CREATE TABLE statements) here
-- Add any necessary indexes, constraints, or relationships between tables
-- Add any user roles or permissions
--
-- You are NOT required to add the schema for tables provided to you in the movies.sql database.


create table users (
    id bigint unsigned auto_increment primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,   
    reviews_list varchar(100) not null, 
    location varchar(150) not null,
    age int unsigned,
    follower_count bigint unsigned,        
    followers_id bigint unsigned not null
);

create table person (
    id bigint unsigned auto_increment primary key,
    first_name varchar(100) not null,
    last_name varchar(100) not null,    
    dob date not null,      
    place_of_birth varchar(150) not null   
);

create table movie (
    id bigint unsigned auto_increment primary key,    
    title varchar(100) not null,
    release_date date not null,         
    runtime smallint unsigned not null,
    budget bigint unsigned not null,
    revenue bigint unsigned not null,   
    overview text not null
);

create table genre (
    id bigint unsigned auto_increment primary key,
    name varchar(50) not null
);

create table movielists (
    id bigint unsigned auto_increment primary key,
    name varchar(100) not null,
    description text not null,
    user_id bigint unsigned not null,
    foreign key (user_id) references users(id)
);

create table reviews (
    id bigint unsigned auto_increment primary key,
    stars enum('1','2','3','4','5') not null,
    body_text text not null,
    comment_id bigint unsigned,
    user_id bigint unsigned not null,
    likes_id bigint unsigned not null,
    movie_id bigint unsigned not null
);

create table crew (
    id bigint unsigned auto_increment primary key,
    person_id bigint unsigned not null,
    movie_id bigint unsigned not null,
    job enum('Director','Producer','Screenplay','Writer','Executive producer') not null
);

create table movie_cast (
    id bigint unsigned auto_increment primary key,
    person_id bigint unsigned not null, 
    movie_id bigint unsigned not null,   
    character_name varchar(100) not null,
    cast_order smallint unsigned
    foreign key (person_id) references person(id)
    foreign key (movie_id) references movie(id)
);

create table movie_genre (
    primary key (movie_id, genre_id),  
    movie_id bigint unsigned not null,
    genre_id bigint unsigned not null
);

create table movie_movielists(
    primary key (movie_id, movielists_id),    
    movie_id bigint unsigned not null,
    movielists_id bigint unsigned not null
);


create table follow (
    id bigint unsigned auto_increment primary key,
    follower_id bigint unsigned not null,
    following_id bigint unsigned not null,
    foreign key (follower_id) references users(id),
    foreign key (following_id) references users(id),    
);
 
create table likes(
    id bigint unsigned auto_increment primary key,
    is_liked boolean not null,
    user_id bigint unsigned not null
);
 
create table comment(
    id bigint unsigned auto_increment primary key,
    body_text varchar(500) not null,
    user_id bigint unsigned,
    likes_id bigint unsigned,
    foreign key (user_id) references users(id),
    foreign key (reviews_id) references users(id)
);
 

 







 