# Zomato_Analysis_Project-3

## SQL Project: Data Analysis for Zomato – A Food Delivery Company
## Overview
This project demonstrates my SQL problem-solving skills through the analysis of data for Zomato, a popular food delivery company in India. 
The project involves setting up the database, importing data, handling null values, and solving a variety of business problems using complex SQL queries.
## Project Structure
**1.Database Setup**: Creation of the zomato_db database and the required tables.

**2.Data Import**: Inserting sample data into the tables.

**3.Data Cleaning**: Handling missing values and ensuring data integrity.

**4.Business Problems**: Solving 20 specific business problems using SQL queries.
## DataBase Setup
```sql
Create database zomato_db;
```
## Table Creation
```sql

--Customer Table--
CREATE TABLE CUSTOMER
(
customer_id  INT PRIMARY KEY,
customer_name Varchar(50),
reg_date Date
)

--Restaurant Table--
CREATE TABLE restaurant
(
restaurant_id INT primary Key,
restaurant_name varchar(80),
city varchar(50),
opening_hours varchar(60)
);


-- Orders Table
CREATE TABLE Orders
(
order_id INT PRIMARY KEY,
customer_id INT , -- This is coming from customer table
restaurant_id INT , -- This is coming from restaurant table
order_item varchar(80),
order_date DATE,
order_time TIME,
order_status VARCHAR(70),
total_amount FLOAT
);

--- Rider Table--
CREATE TABLE Rider
(
rider_id INT  PRIMARY KEY,
rider_name varchar(80),
sign_up  DATE
);

-- Delivery Table --
CREATE TABLE Delivery
(
delivery_id INT PRIMARY KEY,
order_id INT, -- coming from order table
delivery_status Varchar(80),
delivery_time Time,
rider_id INT -- coming from rider table
)
```

## Adding Constraints to Link Fact and Dimension Tables
```sql
-- ADD Foreign Key constraiints Order table for customer
ALTER TABLE orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id)
REFERENCES customer(customer_id);

-- ADD Foreign Key constraiints Order table for restaurant
ALTER TABLE orders
ADD CONSTRAINT fk_restaurant
FOREIGN KEY (restaurant_id)
REFERENCES restaurant(restaurant_id);

 -- ADD Foreign Key constraiints delivery table for order
ALTER TABLE Delivery
ADD CONSTRAINT fk_Order
foreign key (order_id)
REFERENCES orders(order_id);

ALTER TABLE Delivery
ADD CONSTRAINT fk_rider
foreign key (rider_id)
REFERENCES Rider(rider_id);

ALTER TABLE Delivery
DROP FOREIGN KEY fk_rider;

ALTER TABLE Delivery
ADD CONSTRAINT fk_rider
FOREIGN KEY (rider_id)
REFERENCES Rider(rider_id);
```
## Inserting Data into Tables
**Method 1**: Use SQL INSERT statements to manually add records.
**Method 2**: Import data from CSV files with column names and data types aligned to the table structure.
```sql
---Method-1--
INSERT INTO rider (rider_id, rider_name, sign_up) VALUES
(1, 'Ravi Kumar', '2023-01-05'),
(2, 'Anil Singh', '2023-02-10'),
(3, 'Sunil Yadav', '2023-03-12'),
(4, 'Ramesh Vern', '2023-04-15'),
(5, 'Amit Patel', '2023-05-18'),
(6, 'Suresh Reddy', '2023-06-20'),
(7, 'Mahesh Gupta', '2023-07-22'),
(8, 'Pankaj Sharma', '2023-08-25'),
(9, 'Rohit Mehra', '2023-09-05'),
(10, 'Arvind Joshi', '2023-10-10'),
(11, 'Sandeep Rao', '2023-11-15'),
(12, 'Deepak Choi', '2023-12-01'),
(13, 'Manoj Tiwari', '2024-01-25'),
(14, 'Siddharth Jai', '2023-02-28'),
(15, 'Vinay Dubey', '2023-03-22'),
(16, 'Ashok Malhot', '2023-04-30'),
(17, 'Ravi Ranjan', '2023-05-15'),
(18, 'Naveen Nair', '2023-06-05'),
(19, 'Pawan Kumar', '2023-07-12'),
(20, 'Karthik Iyer', '2023-08-08'),
(21, 'Rajesh Shukl', '2023-09-17'),
(22, 'Gopal Das', '2023-10-21'),
(23, 'Lokesh Agraw', '2023-11-28'),
(24, 'Vikas Anand', '2024-01-05'),
(25, 'Mukesh Char', '2024-01-12'),
(26, 'Rahul Bhatia', '2024-02-01'),
(27, 'Sahil Khan', '2024-02-08'),
(28, 'Vijay Singh', '2024-02-15'),
(29, 'Amit Singh', '2024-02-20'),
(30, 'Kiran Desai', '2024-07-20'),
(31, 'Vikram Sharma', '2024-07-25'),
(32, 'Nisha Patel', '2024-07-28'),
(33, 'Raj Kumar', '2024-08-01'),
(34, 'Sanjay Kumar', '2024-08-05');
```
**Note** Rest table I have imported using Method-2

## Checking for NULL Values in Columns
```sql
- CHHeck Null value in the table
select * from customer
where customer_id is NULL
OR customer_name IS NULL
OR reg_date IS NULL

-- Check NULL VALUES IN RESTAURANT TABLE
SELECT * FROM restaurant
WHERE restaurant_id IS NULL
OR restaurant_name IS NULL
OR city IS NULL
OR opening_hours IS NULL

-- CHECK NULL IN  Delivery TABLE
SELECT * FROM Delivery
WHERE delivery_id IS NULL
OR order_id IS NULL
OR delivery_status IS NULL
OR delivery_time IS NULL
OR rider_id IS NULL
 
 -- CHECK NULL IN RIDER TABLE
 select * from rider
 WHERE rider_id IS NULL
 OR rider_name IS NULL
  
select * from orders
WHERE order_id IS NULL
OR customer_id IS NULL
OR restaurant_id IS NULL
OR order_item IS NULL
OR order_date IS NULL
OR order_time IS NULL
OR order_status IS NULL
OR total_amount IS NULL
```
## 4. Data Analysis & Findings
**Task1.Write a query to find the top 5 most frequently ordered dishes by customer called "Anita Verma" in the last 1 year.**
```sql
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


-- Method-2
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
```

**Task 2. Question: Identify the time slots during which the most orders are placed, based on 2-hour intervals.**
```sql

--Method-1

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

---Method-2--

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
```

 **Task 3 Question: Find the average order value per customer who has placed more than 750 orders.**
 ```sql
 SELECT AVG(total_amount) as oder_value,
 count(order_id) as countorder,
 c.customer_id,customer_name
 FROM CUSTOMER C
 INNER JOIN ORDERS O
 ON C.CUSTOMER_ID=O.CUSTOMER_ID
 group by customer_id,customer_name
 having COUNT(Order_id)>750
 ```

 **Task 4. High-Value Customers
Question: List the customers who have spent more than 1000 in total on food orders.
Return customer_name and customer_id!**
```sql
select c.customer_id,customer_name ,
sum(total_amount) as total_order
from customer c
inner join orders o
on c.customer_id=o.customer_id
group by 1,2
having sum(total_amount)> 1000
```

**Task 5. Orders Without Delivery
Question: Write a query to find orders that were placed but not delivered.
Return each restaurant name, city, and number of not delivered orders.**
```sql
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
```

**Task6Restaurant Revenue Ranking:
Rank restaurants by their total revenue from the last year, including their name, total revenue, and rank within their city.**
```sql

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
```


**Task 7:Most Popular Dish by City:
Identify the most popular dish in each city based on the number of orders.**
```sql
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
```
**Task 8: Customer Churn:
Find customers who haven’t placed an order in 2028 but did in 2024.**
```sql
select distinct c.customer_name
from customer c
inner join orders o
on c.customer_id=o.customer_id
where year(order_date)='2024'
and o.customer_id NOT IN (SELECT  distinct customer_id from orders where year(order_date)='2028')
```

**Task 9:Cancellation Rate Comparison:
Calculate and compare the order cancellation rate for each restaurant between the current year and the previous year.**
```sql
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
```
   
  
 **10 Rider Average Delivery Time
Determine each rider's average delivery time.**

```sql

SELECT 
    o.order_id,
    d.rider_id,
    o.order_time,
    d.delivery_time,
    (UNIX_TIMESTAMP(d.delivery_time) - UNIX_TIMESTAMP(o.order_time)) / 60 AS delivery_duration_mins
FROM orders o
JOIN delivery d ON o.order_id = d.order_id
WHERE d.delivery_status = 'Delivered';

```



**Q.11 Monthly Restaurant Growth Ratio
Calculate each restaurant’s growth ratio based on the total number of delivered orders since its joining.**
```sql
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
```

**Q.12 Customer Segmentation
Customer Segmentation: Segment customers into 'Gold' or 'Silver' 
groups based on their total spending compared to the average order value (AOV).
 If a customer’s total spending exceeds the AOV, label them as 'Gold'; 
 otherwise, label them as 'Silver'. Write an SQL query to determine each segment's..total number of orders and total revenue** 
```sql

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
 ```
 
 **Q.13 Rider Monthly Earnings:
Calculate each rider’s total monthly earnings, assuming they earn 8% of the order amount.**
```sql
select d.rider_id,
DATE_FORMAT(o.order_date,'%m-%y') as Month,
sum(total_amount) Total_Amount,
Sum(total_amount)*0.08 as Rider_Earning
 from orders o
inner join delivery d
on o.order_id=d.order_id
group by 1,2
order by 1,2,3
```

**Q.14 Rider Ratings Analysis:
Find the number of 5-star, 4-star, and 3-star ratings each rider has.
Riders receive this rating based on delivery time.
If orders are delivered in less than 15 minutes of order received time, the rider gets a 5-star rating.
If they deliver between 15 and 20 minutes, they get a 4-star rating.
If they deliver after 20 minutes, they get a 3-star rating.**
```sql
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
```
**Q.15 Order Frequency by Day:
Analyze order frequency per day of the week and identify the peak day for each restaurant.**
```sql
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
```

**Q.16 Customer Lifetime Value (CLV):
 Calculate the total revenue generated by each customer over all their orders.**
```sql
SELECT 
	c.customer_name ,
    sum(total_amount) as CLV
FROM orders o
inner join customer c
on o.customer_id=c.customer_id
group by c.customer_name 
```

**Q.17 Monthly Sales Trends:
Identify sales trends by comparing each month's total sales to the previous month.**
```sql
select 
DATE_FORMAT(Order_date, '%m-%y') as Month,
sum(total_amount) as Current_Month_sales,
LAG(sum(total_amount),1) over( order by DATE_FORMAT(Order_date, '%m-%y') ) as Previou_Month_sales
 from orders
 group by 1
```

   



