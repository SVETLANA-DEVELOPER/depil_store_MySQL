-- Решим задачи и сделаем характерные выборки
-- Найти все товары, цена которых выше средней (вложенный запрос)

SELECT
    id, name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- Показать товары и названия их каталогов (вложенный коррелированный запрос)

SELECT
    id, name, (SELECT name FROM categories WHERE id = products.categories_id)
FROM products;

-- Показать всех клиентов, которые не сделали ни одного в интернет-магазине (вложенный запрос)

SELECT
    id, firstname, lastname, gender, birthday_at
FROM clients
WHERE id NOT IN (SELECT clients_id FROM orders);

-- Сколько заказов сделал каждый пользователь (COUNT, вложенный запрос)

SELECT
    id, CONCAT(clients.firstname, ' ', clients.lastname), (SELECT COUNT(*) FROM orders WHERE clients_id = clients.id)
    FROM clients
    GROUP BY id
    ORDER BY id;

-- Показать все товары и их бренды (JOIN)

SELECT
    products.id, products.name, brands.name
FROM products
LEFT JOIN brands
ON brands.id = products.brands_id;

-- Показать остатки товаров на складах и названия складов. Определить товары, которые закончились. (JOIN, RIGHT JOIN)

SELECT
    remains.product_id, products.name, remains.value, storehouses.name
FROM remains
JOIN products
ON remains.product_id = products.id
RIGHT JOIN storehouses
ON remains.storehouse_id = storehouses.id
ORDER BY value;
