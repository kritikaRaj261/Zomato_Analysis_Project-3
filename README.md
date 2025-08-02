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

    



