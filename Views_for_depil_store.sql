-- Представления

/* 1. Создайте представление, которое выводит имя (firstname), фамилию (lastname) из таблицы clients
и статус (statuses) из таблицы client_statuses клиента: */

CREATE OR REPLACE VIEW clients_and_statuses(id, firstname, lastname, status) AS
SELECT
    c.id,
    c.firstname,
    c.lastname,
    cs.statuses
FROM clients c
LEFT JOIN client_statuses cs
ON c.status_id = cs.id
ORDER BY c.id;

SELECT * FROM clients_and_statuses;

/* 2. Создайте представление, которое выводит название товара (products.name), название склада (storehouses.name)
и остаток этого товара на складе (remains.value): */

CREATE OR REPLACE VIEW product_remains (id, name, storehouse, remain) AS
SELECT
    p.id,
    p.name AS product,
    s.name AS storehouse,
    r.value
FROM products p
JOIN storehouses s
LEFT JOIN remains r
ON r.product_id = p.id AND s.id = r.storehouse_id
ORDER BY p.id;

SELECT * FROM product_remains;

/* 3. Создайте представление, которое выводит имена клиентов (clients.firstname, clients.lastname)
и акции, которые включены для этих клиентов (discounts.product_id, discounts.discount): */

CREATE OR REPLACE VIEW client_discounts (id, name, product_id, product_name, discount) AS
SELECT
    c.id,
    CONCAT (c.lastname, ' ', c.firstname) AS client,
    d.product_id,
    p.name AS product_name,
    d.discount
FROM clients c
RIGHT JOIN discounts d
ON c.id = d.client_id
LEFT JOIN products p
ON p.id = d.product_id
ORDER BY c.id;

SELECT * FROM client_discounts;
