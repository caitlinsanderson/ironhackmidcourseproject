#query 4: has the customer chosen trade in the past? buy_id and customer_id for any buy where a customer chose trade and has sold to us
#more than once

SELECT b2.id AS buy_id, b1.customer_id
FROM buys AS b1
JOIN buys AS b2
ON b1.customer_id = b2.customer_id
WHERE b1.points_return = True
GROUP BY b1.customer_id, b2.id
HAVING COUNT(b1.customer_id) >1
ORDER BY b2.id;

#query 5: the total number of times the customer associated to a particular buy has bought from us in the past, for each buy_id

WITH cte_total_buys_count AS
(
SELECT customer_id, COUNT(id) AS total_buys
FROM buys
GROUP BY customer_id
)
SELECT b.id AS buy_id, cte.*
FROM buys AS b
JOIN cte_total_buys_count AS cte
ON b.customer_id = cte.customer_id
ORDER BY b.id;