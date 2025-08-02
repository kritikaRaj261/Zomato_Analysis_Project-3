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

