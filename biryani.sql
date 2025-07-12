-- Biryani Database Query Exercises Solutions
-- Project 3 - Complete SQL Query Solutions

-- ==============================================
-- EASY QUERIES
-- ==============================================

-- 1a. Retrieve each variety's biryani_id, name, region, and whether it's vegetarian
SELECT biryani_id, name, region, vegetarian
FROM BiryaniVarieties;

-- 1b. Spicy non-veg biryanis: Find the name and spice_level of all biryanis where vegetarian = FALSE and spice_level >= 7
SELECT name, spice_level
FROM BiryaniVarieties
WHERE vegetarian = FALSE AND spice_level >= 7;

-- 1c. Available menu items: Show each restaurant's name and the name of biryanis they offer where available = TRUE
SELECT R.name AS restaurant_name, B.name AS biryani_name
FROM Restaurants R
JOIN Menu M ON R.restaurant_id = M.restaurant_id
JOIN BiryaniVarieties B ON M.biryani_id = B.biryani_id
WHERE M.available = TRUE;

-- ==============================================
-- MEDIUM QUERIES
-- ==============================================

-- 2a. For each biryani variety, count how many distinct ingredients it uses
SELECT B.biryani_id, B.name, COUNT(DISTINCT R.ingredient_id) AS ingredient_count
FROM BiryaniVarieties B
JOIN Recipes R ON B.biryani_id = R.biryani_id
GROUP BY B.biryani_id, B.name
ORDER BY ingredient_count DESC;

-- 2b. Calculate total quantity_sold and total total_amount for each biryani across all restaurants
SELECT B.biryani_id, B.name, 
       SUM(S.quantity_sold) AS total_quantity_sold,
       SUM(S.total_amount) AS total_amount
FROM BiryaniVarieties B
JOIN Sales S ON B.biryani_id = S.biryani_id
GROUP BY B.biryani_id, B.name
ORDER BY total_quantity_sold DESC;

-- 2c. For each restaurant, compute the average rating from Reviews, show only those with average >= 4
SELECT R.restaurant_id, R.name, AVG(Rev.rating) AS avg_rating
FROM Restaurants R
JOIN Reviews Rev ON R.restaurant_id = Rev.restaurant_id
GROUP BY R.restaurant_id, R.name
HAVING AVG(Rev.rating) >= 4
ORDER BY avg_rating DESC;

-- 2d. List all biryani varieties (name) that include at least one allergen ingredient
SELECT DISTINCT B.name
FROM BiryaniVarieties B
JOIN Recipes R ON B.biryani_id = R.biryani_id
JOIN Ingredients I ON R.ingredient_id = I.ingredient_id
WHERE I.is_allergen = TRUE
ORDER BY B.name;

-- ==============================================
-- HARD QUERIES
-- ==============================================

-- 3a. For each month in 2025, find the biryani with the highest quantity_sold
WITH MonthlySales AS (
    SELECT 
        EXTRACT(MONTH FROM S.sale_date) AS month_num,
        MONTHNAME(S.sale_date) AS month_name,
        B.biryani_id,
        B.name,
        SUM(S.quantity_sold) AS monthly_quantity
    FROM Sales S
    JOIN BiryaniVarieties B ON S.biryani_id = B.biryani_id
    WHERE EXTRACT(YEAR FROM S.sale_date) = 2025
    GROUP BY EXTRACT(MONTH FROM S.sale_date), MONTHNAME(S.sale_date), B.biryani_id, B.name
),
RankedSales AS (
    SELECT 
        month_num,
        month_name,
        biryani_id,
        name,
        monthly_quantity,
        RANK() OVER (PARTITION BY month_num ORDER BY monthly_quantity DESC) AS rank_num
    FROM MonthlySales
)
SELECT month_name, biryani_id, name, monthly_quantity
FROM RankedSales
WHERE rank_num = 1
ORDER BY month_num;

-- 3b. Identify menu entries where average sale price differs by more than 10% from listed price
WITH SaleAverages AS (
    SELECT 
        S.restaurant_id,
        S.biryani_id,
        AVG(S.total_amount / S.quantity_sold) AS avg_sale_price
    FROM Sales S
    GROUP BY S.restaurant_id, S.biryani_id
)
SELECT 
    M.restaurant_id,
    M.biryani_id,
    M.price AS menu_price,
    SA.avg_sale_price,
    ABS(((SA.avg_sale_price - M.price) / M.price) * 100) AS percentage_difference
FROM Menu M
JOIN SaleAverages SA ON M.restaurant_id = SA.restaurant_id AND M.biryani_id = SA.biryani_id
WHERE ABS(((SA.avg_sale_price - M.price) / M.price) * 100) > 10
ORDER BY percentage_difference DESC;

-- 3c. Compare average ratings for each biryani between summer (June-August) and winter (December-February) 2025
WITH SeasonalRatings AS (
    SELECT 
        B.biryani_id,
        B.name,
        CASE 
            WHEN EXTRACT(MONTH FROM Rev.review_date) IN (6, 7, 8) THEN 'Summer'
            WHEN EXTRACT(MONTH FROM Rev.review_date) IN (12, 1, 2) THEN 'Winter'
            ELSE 'Other'
        END AS season,
        Rev.rating
    FROM BiryaniVarieties B
    JOIN Reviews Rev ON B.biryani_id = Rev.biryani_id
    WHERE EXTRACT(YEAR FROM Rev.review_date) = 2025
    AND EXTRACT(MONTH FROM Rev.review_date) IN (1, 2, 6, 7, 8, 12)
)
SELECT 
    biryani_id,
    name,
    AVG(CASE WHEN season = 'Summer' THEN rating END) AS summer_avg_rating,
    AVG(CASE WHEN season = 'Winter' THEN rating END) AS winter_avg_rating,
    AVG(CASE WHEN season = 'Summer' THEN rating END) - AVG(CASE WHEN season = 'Winter' THEN rating END) AS rating_difference
FROM SeasonalRatings
GROUP BY biryani_id, name
HAVING AVG(CASE WHEN season = 'Summer' THEN rating END) IS NOT NULL 
   AND AVG(CASE WHEN season = 'Winter' THEN rating END) IS NOT NULL
ORDER BY rating_difference DESC;

-- ==============================================
-- ADDITIONAL UTILITY QUERIES
-- ==============================================

-- Verify data integrity: Check for any orphaned records
SELECT 'Orphaned Menu entries' AS issue, COUNT(*) AS count
FROM Menu M
LEFT JOIN Restaurants R ON M.restaurant_id = R.restaurant_id
LEFT JOIN BiryaniVarieties B ON M.biryani_id = B.biryani_id
WHERE R.restaurant_id IS NULL OR B.biryani_id IS NULL

UNION ALL

SELECT 'Orphaned Recipe entries' AS issue, COUNT(*) AS count
FROM Recipes R
LEFT JOIN BiryaniVarieties B ON R.biryani_id = B.biryani_id
LEFT JOIN Ingredients I ON R.ingredient_id = I.ingredient_id
WHERE B.biryani_id IS NULL OR I.ingredient_id IS NULL

UNION ALL

SELECT 'Orphaned Review entries' AS issue, COUNT(*) AS count
FROM Reviews Rev
LEFT JOIN Restaurants R ON Rev.restaurant_id = R.restaurant_id
LEFT JOIN BiryaniVarieties B ON Rev.biryani_id = B.biryani_id
WHERE R.restaurant_id IS NULL OR B.biryani_id IS NULL

UNION ALL

SELECT 'Orphaned Sales entries' AS issue, COUNT(*) AS count
FROM Sales S
LEFT JOIN Restaurants R ON S.restaurant_id = R.restaurant_id
LEFT JOIN BiryaniVarieties B ON S.biryani_id = B.biryani_id
WHERE R.restaurant_id IS NULL OR B.biryani_id IS NULL;

-- Summary statistics
SELECT 
    (SELECT COUNT(*) FROM BiryaniVarieties) AS total_biryani_varieties,
    (SELECT COUNT(*) FROM Ingredients) AS total_ingredients,
    (SELECT COUNT(*) FROM Restaurants) AS total_restaurants,
    (SELECT COUNT(*) FROM Menu) AS total_menu_items,
    (SELECT COUNT(*) FROM Reviews) AS total_reviews,
    (SELECT COUNT(*) FROM Sales) AS total_sales_records,
    (SELECT COUNT(*) FROM Recipes) AS total_recipe_entries;

-- END OF QUERY EXERCISES
