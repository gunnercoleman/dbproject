-- Add your database schema definitions (CREATE TABLE statements) here
-- Add any necessary indexes, constraints, or relationships between tables
-- Add any user roles or permissions
--
-- You are NOT required to add the schema for tables provided to you in the movies.sql database.


create table movielists (
    id bigint(20) unsigned auto_increment primary key,
    name varchar(255) not null,
    description varchar(100) not null,
    user_id bigint(20) unsigned
);

create table user (
    id bigint(20) unsigned auto_increment primary key,
    first_name varchar(255) not null,
    last_name varchar(255) not null,    
    location varchar(100) not null,
    age int(3),
    following_id bigint(20) unsigned,        
    followers_id bigint(20) unsigned
);