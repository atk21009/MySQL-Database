-- CREATE POSTS

SELECT address_id FROM user WHERE username = "Test" AND email = "test@byui.edu";

call create_posts("Test", "test@byui.edu", "img/TEST.png", 4, "HELLO WORLD!");

DROP procedure create_posts;

DELIMITER //
CREATE PROCEDURE create_posts(
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
END //