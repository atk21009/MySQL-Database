-- INSERT USER

call insert_data("USA", "Arizona", "123 Fake Street", "85142", "Taylor", "Password", "taylor@test.com", "Taylor", "Atkin");

DROP PROCEDURE insert_data;

DELIMITER //
CREATE PROCEDURE insert_data(
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
END //