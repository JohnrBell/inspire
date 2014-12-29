CREATE TABLE categories(
id serial primary key,
name varchar(255),
descrip text,
score integer
);

CREATE TABLE posts(
id serial primary key,
parent_category_id integer,
title varchar(255),
msg text,
author varchar(255),
score integer,
birth varchar(255),
death varchar(255),
url text
);

CREATE TABLE replies(
id serial primary key,
parent_post_id integer,
author varchar(255),
msg text, 
score integer,
birth varchar(255)
);

CREATE TABLE subscriptions(
id serial primary key,
parent_post_id integer,
parent_category_id integer,
contact_info varchar(255)
);



