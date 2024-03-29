SET `foreign_key_checks` = 0;

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`
(
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `uname` VARCHAR(127) NOT NULL,
  `pw` CHAR(64) NOT NULL,
  `salt` CHAR(64) NOT NULL,
  `level` INT UNSIGNED,
  `bdate` DATE,
  `fname` VARCHAR(127) NOT NULL,
  `mname` VARCHAR(127),
  `lname` VARCHAR(127) NOT NULL,
  `sex` ENUM('M','F'),
  `email` VARCHAR(127) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`uname`),
  UNIQUE (`email`)
) DEFAULT CHARACTER SET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `file`;
CREATE TABLE `file`
(
  `id` CHAR(64) NOT NULL,
  `type` VARCHAR(127) NOT NULL,
  `content` LONGBLOB NOT NULL,
  PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET=latin1 COLLATE=latin1_swedish_ci;

DROP TABLE IF EXISTS `image`;
CREATE TABLE `image`
(
  `file_id` CHAR(64) NOT NULL,
  PRIMARY KEY (`file_id`),
  FOREIGN KEY (`file_id`)
    REFERENCES `file`(`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) DEFAULT CHARACTER SET=latin1, COLLATE=latin1_swedish_ci;

DROP TABLE IF EXISTS `board`;
CREATE TABLE `board`
(
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(127) NOT NULL,
  `admin_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE (`name`),
  FOREIGN KEY (`admin_id`)
    REFERENCES `user`(`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) DEFAULT CHARACTER SET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `xref_board_mod`;
CREATE TABLE `xref_board_mod`
(
  `board_id` INT UNSIGNED NOT NULL,
  `mod_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`board_id`, `mod_id`),
  FOREIGN KEY (`board_id`)
    REFERENCES `board`(`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (`mod_id`)
    REFERENCES `user`(`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) DEFAULT CHARACTER SET=latin1, COLLATE=latin1_swedish_ci;

DROP TABLE IF EXISTS `article`;
CREATE TABLE `article`
(
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(127) NOT NULL,
  `content` LONGTEXT NOT NULL,
  `ctime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mtime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `vcount` INT UNSIGNED,
  `upcount` INT UNSIGNED,
  `dwcount` INT UNSIGNED,
  `user_id` INT UNSIGNED NOT NULL,
  `board_id` INT UNSIGNED NOT NULL,
  `prev_id` INT UNSIGNED,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`)
    REFERENCES `user`(`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (`board_id`)
    REFERENCES `board`(`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (`prev_id`)
    REFERENCES `article`(`id`)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) DEFAULT CHARACTER SET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`
(
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `content` LONGTEXT NOT NULL,
  `ctime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mtime` DATETIME,
  `upcount` INT UNSIGNED,
  `dwcount` INT UNSIGNED,
  `user_id` INT UNSIGNED NOT NULL,
  `parent_id` INT UNSIGNED,
  `article_id` INT UNSIGNED NOT NULL,
  `image_id` CHAR(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`article_id`)
    REFERENCES `article`(`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (`user_id`)
    REFERENCES `user`(`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (`image_id`)
    REFERENCES `image`(`file_id`),
  FOREIGN KEY (`parent_id`)
    REFERENCES `comment`(`id`)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) DEFAULT CHARACTER SET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `xref_image_article`;
CREATE TABLE `xref_image_article`
(
  `image_id` CHAR(64) NOT NULL,
  `article_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`image_id`, `article_id`),
  FOREIGN KEY (`image_id`)
    REFERENCES `image`(`file_id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (`article_id`)
    REFERENCES `article`(`id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) DEFAULT CHARACTER SET=latin1, COLLATE=latin1_swedish_ci;

SET `foreign_key_checks` = 1;
