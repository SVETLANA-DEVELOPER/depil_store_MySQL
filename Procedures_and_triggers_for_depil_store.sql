-- Хранимые процедуры / триггеры;

-- Процедура, возвращающая количество клиентов интернет-магазина, которые сделали хотя бы один заказ:

DELIMITER //

SELECT @total//

DROP PROCEDURE IF EXISTS clients_total//
CREATE PROCEDURE clients_total (OUT total INT)
BEGIN
    SELECT
        COUNT(*) INTO total
    FROM clients c
    WHERE c.id IN (SELECT clients_id FROM orders);
END//

DELIMITER ;

CALL clients_total (@total);

SELECT @total;

-- Процедура, показывающая количество заказов, которые сделал каждый клиент:

DELIMITER //

DROP PROCEDURE IF EXISTS orders_total//
CREATE PROCEDURE orders_total ()
BEGIN
	SELECT
	    c.id,
	    CONCAT (c.firstname, ' ', c.lastname),
	    COUNT(*)
	FROM clients c
	JOIN orders o ON o.clients_id = c.id
	GROUP BY c.id;
END//

DELIMITER ;

CALL orders_total ();

-- Процедура, которая выводитт N-e количество клиентов:

DELIMITER //

DROP PROCEDURE IF EXISTS n_clients//
CREATE PROCEDURE n_clients (IN n INT)
    BEGIN
    	DECLARE i INT DEFAULT 0;
    IF (n > 0) THEN
        cycle: WHILE i < n+1 DO
            IF i > n THEN LEAVE cycle;
            END IF;
            SELECT id, firstname, lastname, gender FROM clients c LIMIT i;
            SET i = i + 1;
        END WHILE cycle;
    ELSE
        SELECT 'Введите положительное число';
    END IF;
    END//

DELIMITER ;

CALL n_clients (4);

-- Процедура, которая определяет самый популярный товар в интернет-магазине (который заказали больше всего раз):

DELIMITER //

DROP PROCEDURE IF EXISTS popular_product//
CREATE PROCEDURE popular_product ()
BEGIN

    SELECT
	     p.id AS product_id,
		 COUNT(*) AS cnt
	FROM orders_lists ol
	JOIN products p
	ON ol.product_id = p.id
	GROUP BY p.id
	ORDER BY cnt DESC
	LIMIT 1;
END//

DELIMITER ;

CALL popular_product()

-- Триггер, который запрещает удаление администратора:

DELIMITER //

DROP TRIGGER IF EXISTS admin_alive//
CREATE TRIGGER admin_alive
BEFORE DELETE ON admin
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Пощади админа! Он хороший :)';
END//

DELIMITER ;

DELETE FROM admin;

-- Триггер, который проставляет поле brands_id в таблице products, если вдруг вставилась запись без указания бренда. Указывает 7 - not brand:

DELIMITER //

DROP TRIGGER IF EXISTS check_brand//
CREATE TRIGGER check_brand
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    DECLARE br_id INT;
    SELECT id INTO br_id FROM brands WHERE id = 7;
    SET NEW.brands_id = COALESCE(NEW.brands_id, br_id);
END//

DELIMITER ;

INSERT INTO products
     (name, description, price, brands_id, categories_id)
VALUES ('Пленочный воск Selfie', 'Специально разработан технологами для депиляции на лице.', 1195, NULL, 1);
