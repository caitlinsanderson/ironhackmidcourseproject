##query returning the buy id, customer, id, whether or not they chose ANY trade,
	#the retail price of the buy, if they preferred cash at the beginning,
	#the total number of items in the buy, the postal code of the customer, and 
	#the gender of the customer##
WITH cte_items_per_buy AS
(
	SELECT buy_id, COUNT(id) AS total_items
	FROM items
	GROUP BY buy_id
)
SELECT
	b.id AS buy_id,
	b.customer_id,
	b.points_return AS chose_trade,
	b.retail_price AS total_offer,
	b.is_prefer_cash AS payout_preference,
	cte.total_items,
	ca.postal_code,
	g.name AS gender
FROM buys AS b
JOIN cte_items_per_buy AS cte
	ON b.id = cte.buy_id
JOIN customer_addresses AS ca
	ON b.customer_id = ca.customer_id
JOIN customers AS c
	ON b.customer_id = c.id
JOIN genders AS g
	ON c.gender_id = g.id
ORDER BY buy_id;

##query getting a list of buy_ids and their corresponding customer_ids
	#where the customer has purchased from us in the past
	#also including the total order they have made
	#and the total spent##
SELECT 
	b.id AS buy_id,
	s.*
FROM sellers_who_bought AS s
JOIN buys AS b
	ON s.customer_id = b.customer_id;

##query giving me a list of all the brandclasses in a buy by buy id##
SELECT b.id AS buy_id, 
	STRING_AGG(bc.name, ',') AS brand_class_list
FROM buys AS b
JOIN items AS i
	ON b.id = i.buy_id
JOIN brand_classes AS bc
	ON i.brand_class_id = bc.id
GROUP BY b.id;


