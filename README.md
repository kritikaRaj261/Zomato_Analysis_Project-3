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
