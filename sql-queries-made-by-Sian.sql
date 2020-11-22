#2. Create SQL queries selecting the columns you want to work with in 
	#items , customers, buys tables 
	
SELECT id, 
	offer_value, 
	offer_return_cash, 
	buy_id, 
	customer_id, 
	brand_class_id
FROM items;

SELECT id, 
	email, 
	accepts_newsletter, 
	gender_id
FROM customers;

SELECT id, 
	retail_price, 
	cash_sum, 
	points_sum, 
	points_return, 
	is_prefer_cash 
FROM buys;

#3. Select all the data from table `buys` for those columns 
SELECT id, 
	retail_price, 
	cash_sum, 
	points_sum, 
	points_return, 
	is_prefer_cash 
FROM buys;

#5[sic]. Use the _alter table_ command to add a new column to any of your tables. 
	#You can hardcode a fixed (dummy) variable or drop and re add a field (optional)

#I will first create some new tables and then create some new columns in my buys table

#I first want to create a lookup table that will create buckets of "buy values" so that I can then 
	#create a column in the buy table, which will categorize each buy into one of these buckets based
	#on the total buy value.  This will allow me to analyze how much the overall value of a buy may or
	#may not influence the probability that a customer will choose to accept trade points. 
	 
CREATE TABLE IF NOT EXISTS buy_value_lookup
(
	buy_value_id serial PRIMARY KEY,
	bucket_range int4range NOT NULL
);

INSERT INTO buy_value_lookup (buy_value_id, bucket_range) 
	VALUES
    (1, '[0, 25]'),
    (2, '[26, 50]'),
    (3, '[51, 75]'),
	(4, '[76, 100]'),
	(5, '[101, 150]'),
	(6, '[151, 1000]');

#I now want to create a similar lookup table that will create ranges of total items sold to include
	#a column in the buys table to classify each buy by the total items sold to us and see 
	#if this has an influence on our ability to predict whether or not a customer will choose trade

CREATE TABLE IF NOT EXISTS total_items_lookup
(
	total_items_id serial PRIMARY KEY,
	bucket_range int4range NOT NULL
);

INSERT INTO total_items_lookup (total_items_id, bucket_range) 
	VALUES
    (1, '[1, 3]'),
    (2, '[4, 6]'),
    (3, '[7, 9]'),
	(4, '[10, 21]');
	
#Now I will create two new columns in the buys table, to correspond to the new tables
	#just created and categorize each buy by the "total value bucket" and "total items sold bucket".

ALTER TABLE buys
ADD COLUMN buy_value_id integer,
ADD COLUMN total_items_id integer;

#After going through this exercise, I have decided this is not the best approach to creating the bins that I 
	#and I will do this in Python.  Accordingly, I will not use these lookup tables.  

#6. Use sql query to find how many rows of data you have in one of your tables
SELECT COUNT(*)
FROM buys;
	#answer = 6945

#7.  Now we will try to find the unique values in some of the categorical columns:
    - how many unique values in the column 'postal code'?
SELECT COUNT(DISTINCT postal_code)
FROM customer_addresses;
	#answer = 332
	
    - What are the unique values in the column `gender`?
SELECT DISTINCT gender_id
FROM customers;
	#answer: 1,2,3

SELECT DISTINCT name
FROM genders;
	#answer = Male, None, Female

    - how many unique values in the column `id` in buys table?
	
SELECT COUNT(DISTINCT id)
FROM buys;
	#answer = 6945

    - What are the unique values in the column `points_return`?

SELECT DISTINCT points_return
FROM buys;
	#answer: false, null, true

    - What are the unique values in the column `material_id`?

SELECT DISTINCT material_id
FROM items;
	#answer: 1,3,4,5,6,7,8,9,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37
			#38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,58,59,60,61,62,63,64,65,66,67,68,69,70
			#71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,
			#102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,
			#126,128,129,130,131,132,133,134,135,137,138,139,140,141,142,143,144,145,146,147,148,149,150,null
    
8.  Arrange the data in buys table by decreasing order of the `retail price` of the buys. 
	#Return only the `customer_id` of the top 50 customers with the highest `retail price` in your data.
	
	SELECT customer_id
	FROM buys
	ORDER BY retail_price DESC
	LIMIT 50;
	
9.  What is the average retail price of all the customers in your buys table?

SELECT ROUND(AVG(retail_price),2)
FROM buys;

10. In this exercise we will use a simple group by query to check the properties of some of the 
	#categorical variables in your item table. Note wherever `offer value` is asked, 
	#please take the average of the column `offer value': 

    #What is the average offer value of the buys? 
		#The returned result should have only two columns, offer value and buy id

SELECT buy_id,
	ROUND(AVG(offer_value),2) AS Avg_Offer
FROM items
GROUP BY buy_id; 

    #What is the average offer value of each brand? 
	#The returned result should have only two columns, offer value and brand, with as many rows as brands
    
SELECT b.name AS brand_name, 
	ROUND(AVG(i.offer_value),2) AS Avg_Offer
FROM items AS i
JOIN brands AS b
ON i.brand_id = b.id
GROUP BY brand_name
HAVING ROUND(AVG(offer_value),2) IS NOT NULL
ORDER BY Avg_Offer DESC;
	
	#What is the average offer value by customerid? 
	#The returned result should have only two columns, customerid (not name) and offer value
	
SELECT customer_id, 
	ROUND(AVG(offer_value),2) AS Avg_Offer
FROM items
GROUP BY customer_id
HAVING ROUND(AVG(offer_value),2) IS NOT NULL
ORDER BY Avg_Offer DESC;
	
    #what is the average offer value by month? 
	 #the returned result will have as many rows as you have months and years in your dataset.

WITH cte_monthyear AS
(
	SELECT TO_CHAR(signature_timestamp, 'YYYY') AS year,
		TO_CHAR(signature_timestamp, 'MM') AS month, 
		id
	FROM buys
)
SELECT cte.year, cte.month, ROUND(AVG(i.offer_value),2) 
FROM items AS i
JOIN cte_monthyear AS cte
ON i.buy_id = cte.id
GROUP BY cte.year, cte.month
ORDER BY cte.year, cte.month;

    #Is there any obvious correlation re offer value between the columns `material_id` and `pattern_id`? 
	#You can analyse this by grouping the data by one of the variables and then 
	#aggregating the results of the other column. 
	#Visually check if there is a positive correlation or negative correlation or no 
	#correlation between the variables.

SELECT material_id, ROUND(AVG(offer_value),2) AS avg_offer
FROM items
GROUP BY material_id
HAVING material_id IS NOT NULL
ORDER BY 2 DESC;


WITH cte_pattern AS
(
	SELECT pattern_id,
		RANK() OVER (ORDER BY AVG(offer_value)) AS pattern_rank
	FROM items
	GROUP BY pattern_id
	HAVING pattern_id IS NOT NULL
)
SELECT material_id, 
	ROUND(AVG(offer_value),2) AS avg_offer,
	pattern_id,
	RANK() OVER (ORDER BY AVG(offer_value)) AS pattern_rank
FROM items
GROUP BY material_id, pattern_id
ORDER BY avg_offer DESC; 

#11. Your analysis is only focused on the customers with the following properties:

    #have accepted only cash in the past
    #have been a customer on more than one occasion

		#In order to know whether or not someone has been a customer on more than one occasion, I will need 
			#to create a table and import a CSV file from Shopify that has the information on 
			#customers who have purchased from us.  

DROP TABLE customer_purchases_from_shopify;
CREATE TABLE IF NOT EXISTS customer_purchases_from_shopify
(
  	id serial PRIMARY KEY,
  	first_name VARCHAR(50),
  	last_name VARCHAR(50),
	email VARCHAR(250),
	company VARCHAR(250),
	address1 VARCHAR(250),
	address2 VARCHAR(250),
	city VARCHAR(50),
	province VARCHAR(50),
	province_code VARCHAR(5),
	country VARCHAR(50),
	country_code CHAR(2),
	zip VARCHAR(20),
	phone VARCHAR(50),
	accepts_marketing boolean,
	total_spent float,
	total_orders integer,
	tags TEXT,
	note TEXT,
	tax_exempt boolean
);
	
COPY customer_purchases_from_shopify
(
	first_name,
	last_name,
	email,
	company,
	address1,
	address2,
	city,
	province,
	province_code,
	country,
	country_code,
	zip,
	phone,
	accepts_marketing,
	total_spent,
	total_orders,
	tags,
	note,
	tax_exempt
)
FROM '/Users/caitlinsanderson/Documents/ironhack_course_work/mid-course project/customer_purchases_from_shopify.csv'
DELIMITER ','
CSV HEADER;

CREATE VIEW cash_only_purchasers AS
WITH cte_customer_id_email AS
(
	SELECT DISTINCT(b.customer_id), c.email
	FROM buys AS b
	JOIN customers AS c
		ON b.customer_id = c.id
	WHERE b.points_return = False AND c.email IS NOT NULL
)
SELECT DISTINCT(cte.customer_id) 
FROM cte_customer_id_email AS cte
JOIN customer_purchases_from_shopify AS cps
ON cte.email = cps.email
WHERE total_orders > 1;

SELECT * FROM cash_only_purchasers;
	
#I also want to create a view of all customer_ids and their total purchases who have sold to us, 
	#regardless of whether they accepted trade or cash for me to use in my analysis: 

DROP VIEW sellers_who_bought;
CREATE VIEW sellers_who_bought AS
WITH cte_customer_id_email AS
(
	SELECT DISTINCT(b.customer_id), c.email
	FROM buys AS b
	JOIN customers AS c
		ON b.customer_id = c.id
	WHERE c.email IS NOT NULL
)
SELECT DISTINCT(cte.customer_id), cps.total_orders, cps.total_spent
FROM cte_customer_id_email AS cte
JOIN customer_purchases_from_shopify AS cps
ON cte.email = cps.email;	

SELECT * FROM sellers_who_bought;

    #For the rest of the customer profiles, you are not too concerned. 
	#Write a simple query that captures such data with columns which may be interesting, 
	#in your perspective, to understand the behaviour of such customers. 

SELECT cop.customer_id, 
	g.name AS gender,
	cps.total_spent,
	c.accepts_newsletter,
	COUNT(b.id) AS num_buys
FROM cash_only_purchasers AS cop
JOIN buys AS b
	ON cop.customer_id = b.customer_id
JOIN customers AS c
	ON b.customer_id = c.id
JOIN customer_purchases_from_shopify AS cps
	ON c.email = cps.email
JOIN genders AS g 
	ON c.gender_id = g.id
GROUP BY 
	cop.customer_id, 
	g.name,
	cps.total_spent,
	c.accepts_newsletter;

#12. You want to find a list of customers whose average points sum is higher than the 
	#average points sum of all the customers in the database. 
	#Write a query to show the list of such customers. You might need to use a subquery for this problem.

WITH cte_big_traders AS
(
	SELECT customer_id, ROUND(AVG(points_sum),2) AS avg_points
	FROM buys
	GROUP BY customer_id
)
SELECT customer_id
FROM cte_big_traders
WHERE avg_points > (
					SELECT ROUND(AVG(points_sum),2)
					FROM buys
					)
;

	
#13. Since this is something that you are regularly interested in, create a view of the same query.

CREATE VIEW big_traders AS
WITH cte_big_traders AS
(
	SELECT customer_id, ROUND(AVG(points_sum),2) AS avg_points
	FROM buys
	GROUP BY customer_id
)
SELECT customer_id
FROM cte_big_traders
WHERE avg_points > (
					SELECT ROUND(AVG(points_sum),2)
					FROM buys
					)
;
	
SELECT * FROM big_traders;	

#14. What is the number of customers or buys who accepted the points vs number of people who did not?
	
SELECT 
	COUNT(DISTINCT (id)) AS traders,
	(
	SELECT COUNT(DISTINCT (id)) AS cash_please
	FROM buys
	WHERE points_return = False
	)
FROM buys
WHERE points_return = True;
	#answer = 2739 buys w/trade, 3952 w/cash-only

SELECT 
	COUNT(DISTINCT (customer_id)) AS traders,
	(
	SELECT COUNT(DISTINCT (customer_id)) AS cash_please
	FROM buys
	WHERE points_return = False
	)
FROM buys
WHERE points_return = True;
	#answer = 1170 customers who have chosen trade; 1769 who get cash-only
	
#15. Provide the postcode and gender (not name) details of a customer that is the 15th highest 
	#`points_sum` in your database.
	
WITH cte_total_points AS
(
	SELECT customer_id, SUM(points_sum) AS total_points
	FROM buys
	GROUP BY customer_id
	HAVING SUM(points_sum) IS NOT NULL
)
SELECT cte.customer_id, 
	cte.total_points, 
	ca.postal_code, 
	g.name AS gender
FROM cte_total_points AS cte
JOIN customer_addresses AS ca
	ON cte.customer_id = ca.customer_id
JOIN customers AS c
	ON ca.customer_id = c.id
JOIN genders AS g
	ON c.gender_id = g.id
ORDER By total_points DESC
OFFSET 14 LIMIT 1;
	#answer: customer_id = 172, total_points =1083.50, postal_code ="10115", gender ="Male"
	
#16. Provide the postcode and gender (not name) details of a customer that is the 15th highest 
	#`retail_price` in your database.

SELECT b.customer_id, ca.postal_code, g.name, b.retail_price
FROM buys AS b
JOIN customer_addresses AS ca
	ON b.customer_id = ca.customer_id
JOIN customers AS c
	ON b.customer_id = c.id
JOIN genders AS g
	ON c.gender_id = g.id
WHERE retail_price IS NOT NULL
ORDER BY retail_price DESC
OFFSET 14 LIMIT 1;
	#answer: customer_id = 628, postal_code = null, gender = female, retail_price = 1,317.00EUR
