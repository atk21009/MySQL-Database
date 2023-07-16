-- SELECT Statement
SELECT * FROM user;
SELECT * FROM country;
SELECT * FROM city;
SELECT * FROM address;

SELECT * FROM posts;
SELECT * FROM posts_has_user;
SELECT * FROM directmessages;
SELECT * FROM messages;

SELECT * FROM inventory;
SELECT * FROM orders;
SELECT * FROM recent_orders;
SELECT * FROM order_history;



SELECT u.username, c.city, ctry.country, p.caption
FROM user u
	INNER JOIN address a 
		ON a.address_id = u.address_id
	INNER JOIN city c 
		ON c.city_id = a.city_id
	INNER JOIN country ctry 
		ON ctry.country_id = c.country_id
	INNER JOIN posts_has_user phs 
		ON u.user_id = phs.user_id
	INNER JOIN posts p 
		ON phs.posts_id = p.posts_id;

SELECT u.username, i.quantity, p.product, a.address
FROM orders o
	INNER JOIN user u
		ON o.user_id = u.user_id
	INNER JOIN inventory i
		ON i.inventory_id = o.inventory_id
	INNER JOIN product p
		ON i.product_id = p.product_id
	INNER JOIN address a
		ON a.address_id = o.address_id
GROUP BY o.user_id;

SELECT u.user_id, m.message, m.recipient
FROM user u
	INNER JOIN directmessages dm
		ON u.user_id = dm.user_id
	INNER JOIN messages m
		ON dm.user_id = m.user_id
GROUP BY u.user_id