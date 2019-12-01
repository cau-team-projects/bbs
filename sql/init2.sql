INSERT INTO `user` (
  `uname`,
  `pw`,
  `salt`,
  `level`,
  `bdate`,
  `fname`,
  `mname`,
  `lname`,
  `sex`,
  `email`
)
VALUES(
  'admin',
  SHA2('pw', 256),
  SHA2('salt', 256),
  9,
  CURDATE(),
  'admin',
  NULL,
  'mr',
  'M',
  'admin@example.com'
);

INSERT INTO `user` (
  `uname`,
  `pw`,
  `salt`,
  `level`,
  `bdate`,
  `fname`,
  `mname`,
  `lname`,
  `sex`,
  `email`
)
VALUES(
  'testuser',
  SHA2(RAND(), 256),
  SHA2('salt', 256),
  3,
  CURDATE(),
  'john',
  NULL,
  'doe',
  'M',
  'testuser@example.com'
);

INSERT INTO `board`(
  `name`,
  `admin_id`
)
SELECT
  'notice' AS `name`,
  `id`
FROM `user`
WHERE `uname` = 'admin';

INSERT INTO `board`(
  `name`,
  `admin_id`
)
SELECT
  'free' AS `name`,
  `id`
FROM `user`
WHERE `uname` = 'admin';

INSERT INTO `article`(
  `title`,
  `content`,
  `user_id`,
  `board_id`
)
SELECT
  'welcome to our bulletin board system' AS `title`,
  'This is test notice article' AS `content`,
  (SELECT `id` FROM `user` WHERE `uname` = 'admin') AS `user_id`,
  (SELECT `id` FROM `board` WHERE `name` = 'notice') AS `board_id`
;

INSERT INTO `article`(
  `title`,
  `content`,
  `user_id`,
  `board_id`
)
SELECT
  'This is free board' AS `title`,
  'You can write any articles here' AS `content`,
  (SELECT `id` FROM `user` WHERE `uname` = 'admin') AS `user_id`,
  (SELECT `id` FROM `board` WHERE `name` = 'free') AS `board_id`
;

INSERT INTO `article`(
  `title`,
  `content`,
  `user_id`,
  `board_id`
)
SELECT
  'Hello' AS `title`,
  'World!' AS `content`,
  (SELECT `id` FROM `user` WHERE `uname` = 'testuser') AS `user_id`,
  (SELECT `id` FROM `board` WHERE `name` = 'free') AS `board_id`
;

INSERT INTO `comment`(
  `content`,
  `user_id`,
  `article_id`
)
SELECT
  'Very useful article!' AS `content`,
  (SELECT `id` FROM `user` WHERE `uname` = 'admin') AS `user_id`,
  (SELECT `id` FROM `article` WHERE `user_id` = 1 LIMIT 1) AS `article_id`
;
