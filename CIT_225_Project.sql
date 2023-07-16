-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema cit225_project
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema cit225_project
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `cit225_project` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `cit225_project` ;

-- -----------------------------------------------------
-- Table `cit225_project`.`country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cit225_project`.`country` (
  `country_id` INT NOT NULL AUTO_INCREMENT,
  `country` VARCHAR(50) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`country_id`),
  UNIQUE INDEX `country_UNIQUE` (`country` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cit225_project`.`city`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cit225_project`.`city` (
  `city_id` INT NOT NULL AUTO_INCREMENT,
  `country_id` INT NOT NULL,
  `city` VARCHAR(50) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`city_id`),
  UNIQUE INDEX `city_UNIQUE` (`city` ASC) VISIBLE,
  INDEX `fk_city_country1_idx` (`country_id` ASC) VISIBLE,
  CONSTRAINT `fk_city_country`
    FOREIGN KEY (`country_id`)
    REFERENCES `cit225_project`.`country` (`country_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cit225_project`.`address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cit225_project`.`address` (
  `address_id` INT NOT NULL AUTO_INCREMENT,
  `city_id` INT NOT NULL,
  `address` VARCHAR(50) NOT NULL,
  `address2` VARCHAR(50) NULL DEFAULT NULL,
  `postal_code` VARCHAR(10) NULL DEFAULT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  INDEX `fk_address_city1_idx` (`city_id` ASC) VISIBLE,
  CONSTRAINT `fk_address_city`
    FOREIGN KEY (`city_id`)
    REFERENCES `cit225_project`.`city` (`city_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cit225_project`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cit225_project`.`user` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(16) NOT NULL,
  `password` VARCHAR(32) NOT NULL,
  `create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `email` VARCHAR(255) NOT NULL,
  `firstname` VARCHAR(20) NOT NULL,
  `lastname` VARCHAR(20) NOT NULL,
  `address_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `address_id`),
  INDEX `fk_user_address1_idx` (`address_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_address`
    FOREIGN KEY (`address_id`)
    REFERENCES `cit225_project`.`address` (`address_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 16
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cit225_project`.`directmessages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cit225_project`.`directmessages` (
  `user_id` INT NOT NULL,
  `recipient` INT NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`, `recipient`),
  INDEX `fk_direct messages_user1_idx` (`recipient` ASC) VISIBLE,
  CONSTRAINT `fk_direct messages_user1`
    FOREIGN KEY (`recipient`)
    REFERENCES `cit225_project`.`user` (`user_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cit225_project`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cit225_project`.`product` (
  `product_id` INT NOT NULL AUTO_INCREMENT,
  `product` VARCHAR(45) NOT NULL,
  `amount` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`product_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cit225_project`.`inventory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cit225_project`.`inventory` (
  `inventory_id` INT NOT NULL AUTO_INCREMENT,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `product_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  PRIMARY KEY (`inventory_id`),
  INDEX `fk_inventory_product1_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `fk_inventory_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `cit225_project`.`product` (`product_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cit225_project`.`messages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cit225_project`.`messages` (
  `message` MEDIUMTEXT NOT NULL,
  `user_id` INT NOT NULL,
  `recipient` INT NOT NULL,
  `sent_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `fk_messages_direct messages1_idx` (`user_id` ASC, `recipient` ASC) VISIBLE,
  CONSTRAINT `fk_messages_direct messages1`
    FOREIGN KEY (`user_id` , `recipient`)
    REFERENCES `cit225_project`.`directmessages` (`user_id` , `recipient`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cit225_project`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cit225_project`.`orders` (
  `orders_id` INT NOT NULL AUTO_INCREMENT,
  `order_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` INT NOT NULL,
  `inventory_id` INT NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `address_id` INT NOT NULL,
  PRIMARY KEY (`orders_id`),
  INDEX `fk_orders_user1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_orders_inventory1_idx` (`inventory_id` ASC) VISIBLE,
  INDEX `fk_orders_address1_idx` (`address_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_address`
    FOREIGN KEY (`address_id`)
    REFERENCES `cit225_project`.`address` (`address_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_orders_inventory`
    FOREIGN KEY (`inventory_id`)
    REFERENCES `cit225_project`.`inventory` (`inventory_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_orders_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `cit225_project`.`user` (`user_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 16
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cit225_project`.`order_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cit225_project`.`order_history` (
  `order_history_id` INT NOT NULL AUTO_INCREMENT,
  `orders_id` INT NOT NULL,
  `amount` INT NOT NULL,
  `payment_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_history_id`),
  INDEX `fk_order_history_orders1_idx` (`orders_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_history_orders`
    FOREIGN KEY (`orders_id`)
    REFERENCES `cit225_project`.`orders` (`orders_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 27
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cit225_project`.`posts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cit225_project`.`posts` (
  `posts_id` INT NOT NULL AUTO_INCREMENT,
  `caption` MEDIUMTEXT NULL DEFAULT NULL,
  `address_id` INT NOT NULL,
  `image` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`posts_id`),
  INDEX `fk_posts_address1_idx` (`address_id` ASC) VISIBLE,
  CONSTRAINT `fk_posts_address`
    FOREIGN KEY (`address_id`)
    REFERENCES `cit225_project`.`address` (`address_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cit225_project`.`posts_has_user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cit225_project`.`posts_has_user` (
  `posts_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`posts_id`, `user_id`),
  INDEX `fk_posts_has_user_user1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_posts_has_user_posts1_idx` (`posts_id` ASC) VISIBLE,
  CONSTRAINT `fk_posts_has_posts`
    FOREIGN KEY (`posts_id`)
    REFERENCES `cit225_project`.`posts` (`posts_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_posts_has_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `cit225_project`.`user` (`user_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cit225_project`.`recent_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cit225_project`.`recent_orders` (
  `recent_orders_id` INT NOT NULL AUTO_INCREMENT,
  `orders_id` INT NOT NULL,
  `amount` DECIMAL(5,2) NOT NULL,
  `payment_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`recent_orders_id`),
  INDEX `fk_recent_orders_orders1_idx` (`orders_id` ASC) VISIBLE,
  CONSTRAINT `fk_recent_orders`
    FOREIGN KEY (`orders_id`)
    REFERENCES `cit225_project`.`orders` (`orders_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 27
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `cit225_project` ;

-- -----------------------------------------------------
-- procedure create_message
-- -----------------------------------------------------

DELIMITER $$
USE `cit225_project`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_message`(
    IN user_from INT, 
    IN user_to INT, 
    IN message MEDIUMTEXT
    )
BEGIN
		DECLARE sql_error TINYINT DEFAULT FALSE;
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
			SET sql_error = TRUE;
		-- Disable autocommit
        SET AUTOCOMMIT=0;
        
        -- start transaction scope
        START TRANSACTION;
        
        -- statements
        INSERT INTO directmessages(user_id, recipient)
			VALUES(user_from, user_to);
		INSERT INTO messages(user_id, recipient, message)
			VALUES(user_from, user_to, message);
        
	IF sql_error = FALSE THEN 
		COMMIT;
		SELECT "The transaction was committed";
	ELSE
		ROLLBACK;
		SELECT "The transaction was rolled back";	
	END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure create_posts
-- -----------------------------------------------------

DELIMITER $$
USE `cit225_project`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_posts`(
    IN username_in VARCHAR(16), 
    IN email_in VARCHAR(255), 
    IN image VARCHAR(45),
    IN address INT,
    IN caption_in MEDIUMTEXT
    )
BEGIN
		DECLARE sql_error TINYINT DEFAULT FALSE;
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
			SET sql_error = TRUE;
		-- Disable autocommit
        SET AUTOCOMMIT=0;
        
        SET @USER_ID = (SELECT user_id FROM user WHERE username = username_in AND email = email_in);
        SET @Address_ID = (IF(ISNULL(address), (SELECT address_id FROM user WHERE username = username_in AND email = email_in), address ));
        -- start transaction scope
        START TRANSACTION;
        
        -- statements
        INSERT INTO posts(caption, address_id, image)
			VALUES(caption_in, @Address_ID, image);
		SET @posts = last_insert_id();
		INSERT INTO posts_has_user(posts_id, user_id)
			VALUES(@posts, @USER_ID);
        
	IF sql_error = FALSE THEN 
		COMMIT;
		SELECT "The transaction was committed";
	ELSE
		ROLLBACK;
		SELECT "The transaction was rolled back", @USER_ID, @Address_ID;	
	END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure insert_data
-- -----------------------------------------------------

DELIMITER $$
USE `cit225_project`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_data`(
	IN country_name VARCHAR(50),
    IN city_name VARCHAR(50),
    IN address VARCHAR(50), 
    IN postalCode VARCHAR(10), 
    IN username VARCHAR(16), 
    IN password VARCHAR(32), 
    IN email VARCHAR(255), 
    IN firstname VARCHAR(20), 
    IN lastname VARCHAR(20))
BEGIN
		DECLARE sql_error TINYINT DEFAULT FALSE;
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
			SET sql_error = TRUE;
		-- Disable autocommit
        SET AUTOCOMMIT=0;
        -- start transaction scope
        START TRANSACTION;
        
        -- insert statements
        INSERT IGNORE INTO country (country) 
			VALUES (country_name);
        INSERT IGNORE INTO city (country_id, city) 
			VALUES ((SELECT country_id FROM country WHERE country = country_name), city_name);
        INSERT IGNORE INTO address (city_id, address, postal_code) 
			VALUES ((SELECT city_id FROM city WHERE city = city_name), address, postalCode);
        INSERT IGNORE INTO user (username, password, email, firstname, lastname, address_id)
			VALUES(username, password, email, firstname, lastname, (SELECT address_id FROM address WHERE city_id = (SELECT city_id FROM city WHERE city = city_name)));
	IF sql_error = FALSE THEN 
		COMMIT;
		SELECT "The transaction was committed";
	ELSE
		ROLLBACK;
		SELECT "The transaction was rolled back";	
	END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure orders
-- -----------------------------------------------------

DELIMITER $$
USE `cit225_project`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `orders`(
    IN username_in VARCHAR(16), 
    IN email_in VARCHAR(255), 
    IN product INT,
    IN quantity_ordered INT)
BEGIN
		DECLARE sql_error TINYINT DEFAULT FALSE;
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
			SET sql_error = TRUE;
		-- Disable autocommit
        SET AUTOCOMMIT=0;
        
        SET @USER_ID = (SELECT user_id FROM user WHERE username = username_in AND email = email_in);
        SET @Address_ID = (SELECT address_id FROM user WHERE username = username_in AND email = email_in);
        SET @Amount = ((SELECT amount FROM product WHERE product_id = product) * quantity_ordered);
        SET @Inventory_id = (SELECT inventory_id FROM inventory WHERE product_id = product);
        -- start transaction scope
        START TRANSACTION;
        
        -- statements
        UPDATE inventory
			SET quantity = (100 - quantity_ordered)
            WHERE product_id = product;
		INSERT INTO orders (user_id, inventory_id, address_id)
			VALUES (@USER_ID, @Inventory_id, @Address_ID);
		SET @orders_ID = last_insert_id();
		INSERT INTO recent_orders (orders_id, amount)
			VALUES(@orders_ID, @Amount);
		INSERT INTO order_history (orders_id, amount)
			VALUES(@orders_ID, @Amount);
	IF sql_error = FALSE THEN 
		COMMIT;
		SELECT "The transaction was committed";
	ELSE
		ROLLBACK;
		SELECT "The transaction was rolled back", @USER_ID, @Address_ID, @Amount, @Inventory_id, @orders_ID;	
	END IF;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
