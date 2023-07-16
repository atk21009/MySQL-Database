-- CREATE POSTS

SELECT address_id FROM user WHERE username = "Test" AND email = "test@byui.edu";

call create_message(10, 11, "HEY FRIEND!");

DROP procedure create_message;

DELIMITER //
CREATE PROCEDURE create_message(
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
END //