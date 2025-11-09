#  TO CREATE THE DATABASE
CREATE DATABASE olist_store;
USE olist_store;

SHOW VARIABLES LIKE 'secure_file_priv';

# TABLE SCHEMA
CREATE TABLE olist_customers_dataset (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state CHAR(2));
    
# TO IMPORT THE DATA INTO CUSTOMERS TABLE
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv"
INTO TABLE olist_customers_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT * FROM Olist_customers_dataset;
SELECT COUNT(*) FROM olist_customers_dataset;


# TABLE SCHEMA
CREATE TABLE olist_geolocation_dataset (
    geolocation_zip_code_prefix VARCHAR(10) PRIMARY KEY,
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
    );
    
# TO IMPORT THE DATA INTO GEOLOCATION TABLE
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_geolocation_dataset.csv"
INTO TABLE olist_geolocation_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SHOW WARNINGS;
SELECT COUNT(*) FROM olist_geolocation_dataset;


# TABLE SCHEMA
create table olist_order_items (
	order_id varchar(50) primary key,
	order_item_id varchar(50),
	product_id varchar(50),
	seller_id varchar(50),
	shipping_limit_date date,
	price float,
	freight_value float);
    
# TO IMPORT THE DATA INTO ORDER_ITEM TABLE
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items.csv"
INTO TABLE olist_order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


# TABLE SCHEMA
CREATE TABLE olist_order_payments (
    order_id VARCHAR(50) PRIMARY KEY,
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10,2));
    
# TO IMPORT THE DATA INTO ORDER_PAYMENTS TABLE
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_payments_dataset.csv"
INTO TABLE olist_order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


# TABLE SCHEMA
CREATE TABLE olist_order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date VARCHAR(10),
    review_answer_timestamp VARCHAR(10)
);

# TO IMPORT THE DATA INTO ORDER_REVIEWS TABLE
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset.csv"
INTO TABLE olist_order_reviews
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


# TABLE SCHEMA
CREATE TABLE olist_orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp VARCHAR(25),
    order_approved_at VARCHAR(25),
    order_delivered_carrier_date VARCHAR(25),
    order_delivered_customer_date VARCHAR(25),
    order_estimated_delivery_date VARCHAR(25));
   
# TO IMPORT THE DATA INTO THE ORDERS TABLE
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv"
INTO TABLE olist_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


# TABLE SCHEMA
CREATE TABLE olist_products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(50),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT);


# TO IMPORT THE DATA INTO THE PRODUCTS TABLE
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv"
INTO TABLE olist_products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


# TABLE SCHEMA
CREATE TABLE olist_sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state CHAR(2));
    
# TO IMPORT THE DATA INTO SELLERS TABLE
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_sellers_dataset.csv"
INTO TABLE olist_sellers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS; 


# TABLE SCHEMA
CREATE TABLE product_category_translation (
    product_category_name VARCHAR(50) PRIMARY KEY,
    product_category_name_english VARCHAR(50));
    
# TO IMPORT THE DATA INTO THE CATEGORY_TRANSLATION TABLE    
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_category_name_translation.csv"
INTO TABLE product_category_translation
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS; 


# TABLE SCHEMA
CREATE TABLE product_categories (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(50));
    
# TO IMPORT THE DATA INTO THE CATEGORIES TABLE
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products_dataset.csv"
INTO TABLE product_categories
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS; 


# ALL SCHEMAS WITH INSERTED DATA
Select * from Olist_customers_dataset;
Select * from olist_geolocation_dataset;
Select * from Olist_orders;
Select * from Olist_order_payments;
Select * from olist_order_reviews;
Select * from olist_order_items;
Select * from olist_products;
Select * from olist_sellers;
Select * from product_categories;
Select * from product_category_translation;


### WEEKDAY VS WEEKEND
SELECT COUNT(*) FROM olist_orders;
SELECT COUNT(*) FROM olist_order_payments;

SELECT
  CASE
    WHEN WEEKDAY(order_purchase_timestamp) IN (5, 6) THEN 'Weekend'
    ELSE 'Weekday'
  END AS day_type,
  COUNT(*) AS total_orders,
  SUM(payment_value) AS total_payment,
  AVG(payment_value) AS avg_payment
FROM olist_orders o
JOIN olist_order_payments p ON o.order_id = p.order_id
GROUP BY day_type;

####  ALONG WITH THE PERCENTAGE
WITH payment_stats AS (
  SELECT
    CASE
      WHEN WEEKDAY(o.order_purchase_timestamp) IN (5, 6) THEN 'Weekend'
      ELSE 'Weekday'
    END AS day_type,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(p.payment_value) AS total_payment,
    AVG(p.payment_value) AS avg_payment
  FROM Olist_orders o
  JOIN Olist_order_payments p ON o.order_id = p.order_id
  GROUP BY day_type
),
total AS (
  SELECT SUM(total_payment) AS grand_total FROM payment_stats
)
SELECT
  ps.day_type,
  ps.total_orders,
  ps.total_payment,
  ps.avg_payment,
  ROUND((ps.total_payment / t.grand_total) * 100, 2) AS payment_percentage
FROM payment_stats ps, total t;



### NUMBER OF ORDERS WITH REVIEWS SCORE 5 AND PAYMENT TYPE AS CREDIT CARD.
SELECT COUNT(DISTINCT o.order_id) AS credit_card_5star_orders
FROM Olist_orders o
JOIN olist_order_reviews r ON o.order_id = r.order_id
JOIN Olist_order_payments p ON o.order_id = p.order_id
WHERE r.review_score = 5
  AND p.payment_type = 'credit_card';
  
  
  
### AVERAGE NUMBER OF DAYS FOR THE ORDER DELIVERED TO THE CUSTOMER OF PET SHOP
  
SELECT
  ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 0) AS avg_delivery_days
FROM olist_orders o
JOIN olist_order_items i ON o.order_id = i.order_id
JOIN olist_products p ON i.product_id = p.product_id
WHERE p.product_category_name = 'pet_shop'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_purchase_timestamp IS NOT NULL
  AND o.order_delivered_customer_date > o.order_purchase_timestamp;

  
  
  ### AVERAGE PRICE AND PAYMENT VALUE FOR THE CUSTOMERS OF THE SAO PAULO CITY
SELECT
  ROUND(AVG(oi.price), 2) AS avg_item_price,
  ROUND(AVG(op.payment_value), 2) AS avg_payment_value
FROM Olist_customers_dataset c
JOIN Olist_orders o ON c.customer_id = o.customer_id
JOIN olist_order_items oi ON o.order_id = oi.order_id
JOIN Olist_order_payments op ON o.order_id = op.order_id
WHERE c.customer_city = 'sao paulo';


### RELATIONSHIP BETWEEN SHIPPING DAYS AND REVIEW SCORE
SELECT
  r.review_score,
  ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 0) AS avg_shipping_days,
  COUNT(*) AS total_reviews
FROM Olist_orders o
JOIN olist_order_reviews r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
AND o.order_delivered_customer_date > o.order_purchase_timestamp
GROUP BY r.review_score
ORDER BY r.review_score;

# TOTAL SALES , TOTAL ORDERS, TOTAL PROFIT
SELECT
    ROUND(SUM(p.payment_value), 2) AS total_sales,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(i.price - i.freight_value), 2) AS total_profit
FROM olist_orders AS o
JOIN olist_order_items AS i ON o.order_id = i.order_id
JOIN olist_order_payments AS p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered';





