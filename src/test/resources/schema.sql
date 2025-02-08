DROP TABLE IF EXISTS authorities;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS boardgames;
create table if not exists boardgames (
  id       BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name    VARCHAR(128) NOT NULL,
  level   INT NOT NULL,
  minPlayers INT NOT NULL,
  maxPlayers VARCHAR(50) NOT NULL,
  gameType VARCHAR(50) NOT NULL
);

create table if not exists reviews (
  id       BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  gameId   BIGINT NOT NULL,	
  text     VARCHAR(1024) NOT NULL, -- removed UNIQUE constraint
  FOREIGN KEY (gameId) REFERENCES boardgames(id)
);

-- Add these security tables
create table if not exists users (
    username varchar(50) not null primary key,
    password varchar(500) not null,
    enabled boolean not null
);

create table if not exists authorities (
    username varchar(50) not null,
    authority varchar(50) not null,
    constraint fk_authorities_users 
    foreign key(username) references users(username)
);

create unique index if not exists ix_auth_username 
    on authorities (username, authority);

-- Remove this as we included it in the reviews table creation
-- alter table reviews
--  add constraint game_review_fk foreign key (gameId)
--  references boardgames (id);

insert into boardgames (name, level, minPlayers, maxPlayers, gameType)
values ('Splendor', 3, 2, '4', 'Strategy Game');
 
insert into boardgames (name, level, minPlayers, maxPlayers, gameType)
values ('Clue', 2, 1, '6', 'Strategy Game'); 

insert into boardgames (name, level, minPlayers, maxPlayers, gameType)
values ('Linkee', 1, 2, '+', 'Trivia Game'); 
 
insert into reviews (gameId, text)
values (1, 'A great strategy game. The one who collects 15 points first wins. Calculation skill is required.');

insert into reviews (gameId, text)
values (1, 'Collecting gemstones makes me feel like a wealthy merchant. Highly recommend!');
 
insert into reviews (gameId, text)
values (2, 'A detective game to guess the criminal, weapon, and place of the crime scene. It is more fun with more than 3 players.');

INSERT INTO users (username, password, enabled)
VALUES ('bugtester', '$2a$10$XXX', true);

INSERT INTO authorities (username, authority)
VALUES ('bugtester', 'ROLE_USER');