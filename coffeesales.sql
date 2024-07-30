select * from coffee
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'coffee';

UPDATE coffee
SET transaction_date = TO_DATE(transaction_date, 'DD-MM-YYYY')
WHERE transaction_date LIKE '__-__-____';

ALTER TABLE coffee
ADD COLUMN transaction_month text

UPDATE coffee
SET transaction_month = TRIM(TO_CHAR(TO_DATE(transaction_date, 'YYYY-MM-DD'), 'Month'));

ALTER TABLE coffee
ADD COLUMN transaction_day text

UPDATE coffee
SET transaction_day = TRIM(TO_CHAR(TO_DATE(transaction_date, 'YYYY-MM-DD'), 'Day'));

ALTER TABLE coffee
ALTER COLUMN transaction_date TYPE DATE USING transaction_date::DATE;

UPDATE coffee
SET transaction_time = TO_TIMESTAMP(transaction_time, 'HH24:MI:SS')::TIME;

ALTER TABLE coffee
ALTER COLUMN transaction_time TYPE TIME USING transaction_time::TIME;

ALTER TABLE coffee
ALTER COLUMN unit_price TYPE double precision 

select * from coffee
/*total sales by month wise*/

select round(sum(transaction_qty::numeric *unit_price::numeric),2) 
as total_sales from coffee where extract(month from transaction_date)=5



select transaction_month, 
round(sum(transaction_qty::numeric *unit_price::numeric),2) 
as total_sales 
from coffee group by transaction_month



WITH monthly_sales AS (
    SELECT 
        EXTRACT(MONTH FROM transaction_date) AS month,
        ROUND(SUM(transaction_qty::numeric * unit_price::numeric), 2) AS total_sales
    FROM 
        coffee
   /* WHERE 
        EXTRACT(MONTH FROM transaction_date) IN (4, 5)*/
    GROUP BY 
        EXTRACT(MONTH FROM transaction_date)
)
SELECT 
    month,
    total_sales,
    (total_sales - LAG(total_sales) OVER (ORDER BY month)) / 
    LAG(total_sales) OVER (ORDER BY month) * 100 AS mom_increase_percentage
FROM 
    monthly_sales
ORDER BY 
    month;



select * from coffee

Select extract(month from transaction_date) as Month,
count(transaction_id)as total_order_count from coffee 
group by extract(month from transaction_date)


SELECT 
    TRIM(TO_CHAR(transaction_date, 'Month')) AS month,
    COUNT(transaction_id) AS total_order_count
FROM 
    coffee
GROUP BY 
    TRIM(TO_CHAR(transaction_date, 'Month')),
    EXTRACT(MONTH FROM transaction_date)
ORDER BY 
    EXTRACT(MONTH FROM transaction_date);

WITH monthly_orders AS (
    SELECT 
        EXTRACT(MONTH FROM transaction_date) AS month,
       count(transaction_id) AS total_orders
    FROM 
        coffee
     GROUP BY 
        EXTRACT(MONTH FROM transaction_date)
)
SELECT 
    month,
    total_orders,
    ROUND((total_orders - LAG(total_orders) OVER (ORDER BY month)) / 
    LAG(total_orders) OVER (ORDER BY month)::numeric *100,2) AS mom_increase_percentage
FROM 
    monthly_orders
ORDER BY 
    month;


WITH monthly_orders AS (
    SELECT 
        EXTRACT(MONTH FROM transaction_date) AS month,
        COUNT(transaction_id) AS total_orders
    FROM 
        coffee
    
    GROUP BY 
        EXTRACT(MONTH FROM transaction_date)
)
SELECT 
    month,
    total_orders,
    LAG(total_orders) OVER (ORDER BY month) AS previous_month_orders,
    ROUND(
        CASE
            WHEN LAG(total_orders) OVER (ORDER BY month) IS NULL THEN NULL
            ELSE
                (total_orders - LAG(total_orders) OVER (ORDER BY month))::numeric /
                NULLIF(LAG(total_orders) OVER (ORDER BY month), 0) * 100
        END,
        2
    ) AS mom_increase_percentage
FROM 
    monthly_orders
ORDER BY 
    month;



SELECT 
    TRIM(TO_CHAR(transaction_date, 'Month')) AS month,
    sum(transaction_qty) AS total_qty
FROM 
    coffee
GROUP BY 
    TRIM(TO_CHAR(transaction_date, 'Month')),
    EXTRACT(MONTH FROM transaction_date)
ORDER BY 
    EXTRACT(MONTH FROM transaction_date);

WITH monthly_qty AS (
    SELECT 
        EXTRACT(MONTH FROM transaction_date) AS month,
       sum(transaction_qty) AS total_qty
    FROM 
        coffee
     GROUP BY 
        EXTRACT(MONTH FROM transaction_date)
)
SELECT 
    month,
    total_qty,
    ROUND((total_qty - LAG(total_qty) OVER (ORDER BY month)) / 
    LAG(total_qty) OVER (ORDER BY month)::numeric *100,2) AS mom_increase_percentage
FROM 
    monthly_qty
ORDER BY 
    month;
	

	






