-- INSERT ORDERS

SELECT user_id FROM user WHERE username LIKE '%Test%' AND email LIKE "%test@byui.edu%";
CALL orders("Test", "test@byui.edu", 4, 4);

DROP PROCEDURE orders;

DELIMITER //
CREATE PROCEDURE orders(
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
			SET quantity = ((SELECT quantity FROM inventory) - quantity_ordered)
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
END //