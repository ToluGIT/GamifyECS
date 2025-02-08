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
  text     VARCHAR(1024) NOT NULL,       
  FOREIGN KEY (gameId) REFERENCES boardgames(id)
);

create table if not exists users (
    username varchar(50) not null primary key,
    password varchar(500) not null,
    enabled boolean not null
);

create table if not exists authorities (
    username varchar(50) not null,
    authority varchar(50) not null,
    constraint fk_authorities_users 
    foreign key(username) references users(username),
    UNIQUE INDEX ix_auth_username (username, authority)
);