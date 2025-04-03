-- The ratio of male to female customers is about 68:32, using the data the store has on female customers,
 -- what strategy do you recommend the store puts in place to attract more female customers.
WITH total AS (
    SELECT
        Gender,
        COUNT(Customer_ID) AS client_count
    FROM dbo.shopping_trends_updated
    GROUP BY Gender
)
SELECT
    SUM(CASE WHEN Gender = 'Male' THEN client_count ELSE 0 END) AS count_male,
    SUM(CASE WHEN Gender = 'Female' THEN client_count ELSE 0 END) AS count_female,
    ROUND(SUM(CASE WHEN Gender = 'Male' THEN client_count ELSE 0 END) * 100.0 / 
         (SUM(client_count)), 2) AS pct_male,
    ROUND(SUM(CASE WHEN Gender = 'Female' THEN client_count ELSE 0 END) * 100.0 / 
         (SUM(client_count)), 2) AS pct_female
FROM total;

-- What Female Age Group do we mostly serve

SELECT
    CASE
        WHEN Age BETWEEN 18 AND 31 THEN '18-31'
        WHEN Age BETWEEN 32 AND 45 THEN '32-45'
        WHEN Age BETWEEN 46 AND 59 THEN '46-59'
        WHEN Age BETWEEN 60 AND 70 THEN '60-70'
    END AS age_groups,
    COUNT(Customer_ID) AS client_count
FROM dbo.shopping_trends_updated
WHERE Gender = 'Female'
GROUP BY    CASE
        WHEN Age BETWEEN 18 AND 31 THEN '18-31'
        WHEN Age BETWEEN 32 AND 45 THEN '32-45'
        WHEN Age BETWEEN 46 AND 59 THEN '46-59'
        WHEN Age BETWEEN 60 AND 70 THEN '60-70'
END
ORDER BY client_count DESC;


# -- What is the most and least popular category

SELECT
Category,
COUNT(Customer_ID) as client_count
FROM dbo.shopping_trends_updated
Group By Category
Order by 2
;

# Most popular item

SELECT
Item_Purchased,
count(Customer_ID) as items_purchased
FROM dbo.shopping_trends_updated
group by Item_Purchased
order by 2 desc
-- Limit 20
;

-- Which season has the most purchases

SELECT

Season,
count(Customer_ID) as purchase_count

FROM dbo.shopping_trends_updated
where Season is not null
Group by Season
Order by 2 desc
;

-- Most popular payment method

SELECT
Payment_Method,
count(Customer_ID) as purchase_count

FROM dbo.shopping_trends_updated
Group by Payment_Method
Order by 2 Desc;


-- Most popular shipping type

SELECT

	Shipping_Type,
    count(Customer_ID) as purchase_count

FROM dbo.shopping_trends_updated
group by Shipping_Type
order by 2 desc;

 -- What is the most popular age group served?
 -- Find the most purchased item by that age group

 -- With age_data as(
SELECT
    age_groups,
    Item_Purchased,
    COUNT(Customer_ID) AS client_count
FROM (
    SELECT
        CASE
            WHEN Age BETWEEN 18 AND 31 THEN '18-31'
            WHEN Age BETWEEN 32 AND 45 THEN '32-45'
            WHEN Age BETWEEN 46 AND 59 THEN '46-59'
            WHEN Age BETWEEN 60 AND 70 THEN '60-70'
        END AS age_groups,
        Item_Purchased,
        Customer_ID
    FROM dbo.shopping_trends_updated
) AS subquery
WHERE age_groups = '46-59'
GROUP BY age_groups, Item_Purchased
ORDER BY client_count DESC;
# -- )
;

-- What is the most popular age group served?
 -- Find the most common payment method used by the most popular age group served.
 SELECT
    age_groups,
    Payment_Method,
    COUNT(Customer_ID) AS no_clients  -- Place the count here to correctly aggregate after grouping
FROM (
    SELECT
        Age,
        Payment_Method,
        Customer_ID,
        CASE
            WHEN Age BETWEEN 18 AND 31 THEN '18-31'
            WHEN Age BETWEEN 32 AND 45 THEN '32-45'
            WHEN Age BETWEEN 46 AND 59 THEN '46-59'
            WHEN Age BETWEEN 60 AND 70 THEN '60-70'
        END AS age_groups
    FROM dbo.shopping_trends_updated
) AS t
WHERE age_groups = '46-59'  -- Use WHERE to filter by age_groups since it's now a derived column in the subquery
GROUP BY age_groups, Payment_Method
ORDER BY no_clients DESC;
