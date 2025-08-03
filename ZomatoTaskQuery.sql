-- Task1.Write a query to find the top 5 most frequently ordered dishes by customer called "Arjun Mehta" in the last 1 year.
SELECT 
    o.order_item,
    COUNT(o.order_item) AS order_count
FROM 
    customer c
INNER JOIN 
    orders o ON c.customer_id = o.customer_id
WHERE 
    c.customer_name = 'Anita Verma'
    AND o.order_date >= CURDATE() - INTERVAL 1 YEAR
GROUP BY 
    o.order_item
ORDER BY 
    order_count DESC
LIMIT 5;

-- methos-2
With CT_Rank as 
(
SELECT 
    o.order_item,
    COUNT(o.order_item) AS order_count,
    DENSE_RANK() OVER (ORDER BY COUNT(o.order_item) DESC) AS RN
FROM 
    customer c
INNER JOIN 
    orders o ON c.customer_id = o.customer_id
WHERE 
    c.customer_name = 'Anita Verma'
    AND o.order_date >= CURDATE() - INTERVAL 1 YEAR
GROUP BY 
    o.order_item
    )
    select * from CT_Rank
    where RN<=5;
    

-- 2 TASK Question: Identify the time slots during which the most orders are placed, based on 2-hour intervals.

SELECT * FROM ORDERS
SELECT count(order_id),
CASE 
WHEN HOUR(ORDER_TIME) BETWEEN 0 AND 1 THEN  '0-2'
WHEN HOUR(ORDER_TIME)  BETWEEN 2 AND 3 THEN '2-4'
WHEN HOUR(ORDER_TIME)  BETWEEN 4 AND 5 THEN '4-6'
WHEN HOUR(ORDER_TIME)  BETWEEN 6 AND 7 THEN '6-8'
WHEN HOUR(ORDER_TIME)  BETWEEN 8 AND 9 THEN '8-10'
WHEN HOUR(ORDER_TIME)  BETWEEN 10 AND 11 THEN '10-12'
WHEN HOUR(ORDER_TIME)  BETWEEN 12 AND 13 THEN '12-14'
WHEN HOUR(ORDER_TIME)  BETWEEN 14 AND 15 THEN '14-16'
WHEN HOUR(ORDER_TIME)  BETWEEN 16 AND 17 THEN '16-18'
WHEN HOUR(ORDER_TIME)  BETWEEN 18 AND 19 THEN '18-20'
WHEN HOUR(ORDER_TIME)  BETWEEN 20 AND 21 THEN '20-22'
WHEN HOUR(ORDER_TIME)  BETWEEN 22 AND 23 THEN '22-24'
END AS 'Timeslot'
 FROM ORDERS
 group by Timeslot
 order by count(order_id) desc
 limit 1
 
WITH CT_TABLE AS 
(
    SELECT 
        CASE 
            WHEN HOUR(order_time) BETWEEN 0 AND 1 THEN '0-2'
            WHEN HOUR(order_time) BETWEEN 2 AND 3 THEN '2-4'
            WHEN HOUR(order_time) BETWEEN 4 AND 5 THEN '4-6'
            WHEN HOUR(order_time) BETWEEN 6 AND 7 THEN '6-8'
            WHEN HOUR(order_time) BETWEEN 8 AND 9 THEN '8-10'
            WHEN HOUR(order_time) BETWEEN 10 AND 11 THEN '10-12'
            WHEN HOUR(order_time) BETWEEN 12 AND 13 THEN '12-14'
            WHEN HOUR(order_time) BETWEEN 14 AND 15 THEN '14-16'
            WHEN HOUR(order_time) BETWEEN 16 AND 17 THEN '16-18'
            WHEN HOUR(order_time) BETWEEN 18 AND 19 THEN '18-20'
            WHEN HOUR(order_time) BETWEEN 20 AND 21 THEN '20-22'
            WHEN HOUR(order_time) BETWEEN 22 AND 23 THEN '22-24'
        END AS timeslot,
        COUNT(order_id) AS order_count,
        DENSE_RANK() OVER (ORDER BY COUNT(order_id) DESC) AS rn
    FROM orders
    GROUP BY timeslot
)
SELECT * 
FROM CT_TABLE
WHERE rn = 1;

 -- TASK3 Question: Find the average order value per customer who has placed more than 750 orders.
 SELECT * FROM CUSTOMER
 SELECT * FROM ORDERS
 
 SELECT AVG(total_amount) as oder_value,
 count(order_id) as countorder,
 c.customer_id,customer_name
 FROM CUSTOMER C
 INNER JOIN ORDERS O
 ON C.CUSTOMER_ID=O.CUSTOMER_ID
 group by customer_id,customer_name
 having COUNT(Order_id)>750
 
 /*
 -- Task 4. High-Value Customers
Question: List the customers who have spent more than 1000 in total on food orders.
Return customer_name and customer_id!
*/


select c.customer_id,customer_name ,
sum(total_amount) as total_order
from customer c
inner join orders o
on c.customer_id=o.customer_id
group by 1,2
having sum(total_amount)> 1000

/*
5. Orders Without Delivery
Question: Write a query to find orders that were placed but not delivered.
Return each restaurant name, city, and number of not delivered orders.
*/

SELECT 
    r.restaurant_name,
    r.city,
    COUNT(o.order_id) AS not_delivered_orders
FROM 
    orders o
INNER JOIN 
    restaurant r ON o.restaurant_id = r.restaurant_id
LEFT JOIN 
    delivery d ON o.order_id = d.order_id
WHERE 
    d.delivery_id IS NULL
GROUP BY 
    r.restaurant_name, r.city;

-- Method-2
SELECT 
    r.restaurant_name,
    r.city,
    COUNT(o.order_id) AS not_delivered_orders
FROM 
    orders o
INNER JOIN 
    restaurant r ON o.restaurant_id = r.restaurant_id
WHERE 
    o.order_id NOT IN (SELECT order_id FROM delivery d)
GROUP BY 
    r.restaurant_name, r.city;
    
/*
Restaurant Revenue Ranking:
Rank restaurants by their total revenue from the last year, including their name, total revenue, and rank within their city.
*/

select 
r.restaurant_name,
sum(total_amount) as revenue,
r.city,
rank() over (partition by r.city order by sum(total_amount) desc) as rn
 from orders o
inner join restaurant r
on o.restaurant_id=r.restaurant_id
where o.order_date>= curdate()- interval-1 year
group by 1,3

/*
Q. 7
Most Popular Dish by City:
Identify the most popular dish in each city based on the number of orders.
*/


with ct_rankdish as
(
select 
r.city,
o.order_item as dish,
count(order_id) as number_of_orders,
rank() over (partition by r.city order by count(order_id) desc) as rn
from orders o
inner join restaurant r
on o.restaurant_id=r.restaurant_id
group by 1,2
)
select * from ct_rankdish
where rn=1

/*Q. 8 Customer Churn:
Find customers who haven’t placed an order in 2028 but did in 2024.*/

select distinct c.customer_name
from customer c
inner join orders o
on c.customer_id=o.customer_id
where year(order_date)='2024'
and o.customer_id NOT IN (SELECT  distinct customer_id from orders where year(order_date)='2028')

/*Q. 9 Cancellation Rate Comparison:
Calculate and compare the order cancellation rate for each restaurant between the current year and the previous year.
*/
WITH ct_cancellation_rate_2023 AS (
    SELECT 
        r.restaurant_id,
        r.restaurant_name,
        COUNT(o.order_id) AS total_orders,
        COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) AS Not_delivered
    FROM orders o
    INNER JOIN restaurant r ON o.restaurant_id = r.restaurant_id
    LEFT JOIN delivery d ON o.order_id = d.order_id
    WHERE YEAR(o.order_date) = 2023
    GROUP BY r.restaurant_id, r.restaurant_name
),

ct_cancellation_rate_2024 AS (
    SELECT 
        r.restaurant_id,
        r.restaurant_name,
        COUNT(o.order_id) AS total_orders,
        COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) AS Not_delivered
    FROM orders o
    INNER JOIN restaurant r ON o.restaurant_id = r.restaurant_id
    LEFT JOIN delivery d ON o.order_id = d.order_id
    WHERE YEAR(o.order_date) = 2024
    GROUP BY r.restaurant_id, r.restaurant_name
),

last_year_ratio AS (
    SELECT 
        restaurant_id,
        restaurant_name,
        ROUND(Not_delivered * 100.0 / NULLIF(total_orders, 0), 2) AS cancel_rate_2023
    FROM ct_cancellation_rate_2023
),

current_year_ratio AS (
    SELECT 
        restaurant_id,
        restaurant_name,
        ROUND(Not_delivered * 100.0 / NULLIF(total_orders, 0), 2) AS cancel_rate_2024
    FROM ct_cancellation_rate_2024
)

-- Final comparison
SELECT 
    c.restaurant_id AS rest_id,
    c.restaurant_name,
    l.cancel_rate_2023 AS lastyearRatio_ratio,
    c.cancel_rate_2024 AS currentYearRatio_ratio,
    ROUND(c.cancel_rate_2024 - l.cancel_rate_2023, 2) AS cancellation_rate_diff
FROM 
    last_year_ratio l
INNER JOIN 
    current_year_ratio c ON l.restaurant_id = c.restaurant_id
ORDER BY 
    rest_id;
    
  /*  
 10 Rider Average Delivery Time
Determine each rider's average delivery time.
*/
select * from rider
select * from delivery

SELECT 
    o.order_id,
    d.rider_id,
    o.order_time,
    d.delivery_time,
    (UNIX_TIMESTAMP(d.delivery_time) - UNIX_TIMESTAMP(o.order_time)) / 60 AS delivery_duration_mins
FROM orders o
JOIN delivery d ON o.order_id = d.order_id
WHERE d.delivery_status = 'Delivered';




/*
Q.11 Monthly Restaurant Growth Ratio
Calculate each restaurant’s growth ratio based on the total number of delivered orders since its joining.
*/

with Growth_ratio as
(
select o.restaurant_id ,o.order_date,
-- Month(o.order_date) as Month,
DATE_FORMAT(o.order_date, '%m-%y') AS month_year,
count(o.order_id) as Current_Month_order ,
LAG(count(o.order_id),1) over (partition by o.restaurant_id order by DATE_FORMAT(o.order_date, '%m-%y')) as Previous_Month_order
from orders o
inner join delivery d
on o.order_id=d.order_id
where delivery_status='Delivered'
group by  1,2,3
order by 3
)
select restaurant_id,month_year,
Current_Month_order,Previous_Month_order,
(Current_Month_order-Previous_Month_order)/Previous_Month_order*100 as GrowthRatio
from Growth_ratio


/*
Q.12 Customer Segmentation
Customer Segmentation: Segment customers into 'Gold' or 'Silver' 
groups based on their total spending compared to the average order value (AOV).
 If a customer’s total spending exceeds the AOV, label them as 'Gold'; 
 otherwise, label them as 'Silver'. Write an SQL query to determine each segment's..total number of orders and total revenue 
*/

select * from orders

with CT_Customer as 
(
select customer_id,
count(o.order_id) as order_count,
sum(total_amount) as Revenue,
CASE WHEN SUM(total_amount)> (SELECT AVG(total_amount) FROM orders) then 'Gold'
ELSE 'Silver'
end as 'CustomerSegment'
from orders o
group by customer_id
)
select sum(order_count) as Total_Order,sum(Revenue) as Revenue,CustomerSegment
 from CT_Customer
 group by CustomerSegment
 
 /*
 Q.13 Rider Monthly Earnings:
Calculate each rider’s total monthly earnings, assuming they earn 8% of the order amount.
*/
select d.rider_id,
DATE_FORMAT(o.order_date,'%m-%y') as Month,
sum(total_amount) Total_Amount,
Sum(total_amount)*0.08 as Rider_Earning
 from orders o
inner join delivery d
on o.order_id=d.order_id
group by 1,2
order by 1,2,3

/*
Q.14 Rider Ratings Analysis:
Find the number of 5-star, 4-star, and 3-star ratings each rider has.
Riders receive this rating based on delivery time.
If orders are delivered in less than 15 minutes of order received time, the rider gets a 5-star rating.
If they deliver between 15 and 20 minutes, they get a 4-star rating.
If they deliver after 20 minutes, they get a 3-star rating.
*/



SELECT  
    rider_id,
    Rating,
    COUNT(*) AS Rating_Count
FROM (
    SELECT 
        d.rider_id,
        TIMESTAMPDIFF(MINUTE, o.order_time, d.delivery_time) AS delivery_duration_mins,
        CASE 
            WHEN TIMESTAMPDIFF(MINUTE, o.order_time, d.delivery_time) < 15 THEN '5-Star Rating'
            WHEN TIMESTAMPDIFF(MINUTE, o.order_time, d.delivery_time) BETWEEN 15 AND 20 THEN '4-Star Rating'
            ELSE '3-Star Rating'
        END AS Rating
    FROM orders o
    INNER JOIN delivery d ON o.order_id = d.order_id
    WHERE d.delivery_status = 'Delivered'
) k
GROUP BY rider_id, Rating
ORDER BY rider_id, Rating;

/*Q.15 Order Frequency by Day:
-- Analyze order frequency per day of the week and identify the peak day for each restaurant.*/

WITH CT_TABLE AS 
(
SELECT 
-- o.order_date,
r.restaurant_name,
DAYNAME(order_date) AS day_name,
COUNT(o.order_id) AS ORDER_COUNT,
RANK() OVER(partition by r.restaurant_name ORDER BY COUNT(o.order_id) DESC) AS RN
 FROM Orders o
inner join restaurant r
on o.restaurant_id=r.restaurant_id
GROUP BY 1,2
ORDER BY 1,3 DESC
)
SELECT * FROM CT_TABLE
WHERE RN=1


/* Q.16 Customer Lifetime Value (CLV):
-- Calculate the total revenue generated by each customer over all their orders.*/
SELECT 
	c.customer_name ,
    sum(total_amount) as CLV
FROM orders o
inner join customer c
on o.customer_id=c.customer_id
group by c.customer_name 

/*
Q.17 Monthly Sales Trends:
-- Identify sales trends by comparing each month's total sales to the previous month.*/
select 
DATE_FORMAT(Order_date, '%m-%y') as Month,
sum(total_amount) as Current_Month_sales,
LAG(sum(total_amount),1) over( order by DATE_FORMAT(Order_date, '%m-%y') ) as Previou_Month_sales
 from orders
 group by 1

/*
Q.18 Rider Efficiency:
-- Evaluate rider efficiency by determining average delivery times and identifying those with the lowest and highest averages.*/


WITH CT_table AS (
    SELECT 
        d.rider_id,
        (UNIX_TIMESTAMP(d.delivery_time) - UNIX_TIMESTAMP(o.order_time)) / 60 AS delivery_duration_mins
    FROM orders o
    INNER JOIN delivery d ON o.order_id = d.order_id
    WHERE d.delivery_status = 'Delivered'
),
Average_Time_ct AS (
    SELECT 
        rider_id,
        AVG(delivery_duration_mins) AS avg_deliveryTime
    FROM CT_table
    GROUP BY rider_id
)
SELECT 
    MIN(avg_deliveryTime) AS Min_DeliveryTime,
    MAX(avg_deliveryTime) AS Max_DeliveryTime
FROM Average_Time_ct;

/*Q.19 Order Item Popularity:
-- Track the popularity of specific order items over time and identify seasonal demand spikes.*/

select 
      order_item,
      SeasonCategory,
	count(order_id) as Total_orders  from 
(
SELECT 
    order_item,order_id,
    MONTH(order_date) AS Month,
    CASE 
        WHEN MONTH(order_date) BETWEEN 4 AND 6 THEN 'Spring'
        WHEN MONTH(order_date) > 6 AND MONTH(order_date) < 9 THEN 'Summer'
        ELSE 'Winter'
    END AS SeasonCategory
FROM orders
)sub
group by 1,2
order by 1,3


/*Q.20 Rank each city based on the total revenue fro last year 2024*/
SELECT 
    r.city,
    SUM(o.total_amount) AS Revenue,
    RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS CITY_RANK
FROM orders o
INNER JOIN restaurant r ON o.restaurant_id = r.restaurant_id
WHERE o.order_date >= CURDATE() - INTERVAL 1 YEAR
GROUP BY r.city;
