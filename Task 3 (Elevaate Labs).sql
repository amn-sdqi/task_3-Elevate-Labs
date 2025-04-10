#use amaan;

# 1. Write a query to find the popularity and  release day of all the movies which were released in 2013 December. 
# Return the result ordered by popularity in descending order.

SELECT popularity, day, month, year FROM movies
WHERE year=2013;

#------------------------------------------------------------------------------------------------------------------------------------------------------
# 2. Write a query to find the total count of the movies that were released in December 2013 and the day was Wednesday.

SELECT count(title) as Total_Movies FROM movies
WHERE month='Dec' AND year=2013;

#------------------------------------------------------------------------------------------------------------------------------------------------------
# 3. How many movies have been directed by Sam Mendes, James Cameron, and Christopher Nolan?

SELECT (SELECT director_name from directors WHERE id=director_id ) as Director_Name ,count(director_id) as Total_Movies from movies
WHERE director_id IN (
	SELECT id from directors
    WHERE director_name IN ('Sam Mendes', 'James Cameron', 'Christopher Nolan')
    )
	GROUP BY director_id;

#------------------------------------------------------------------------------------------------------------------------------------------------------
# 4. Find all the movies that were released on Wednesday directed by Christopher Nolan.

SELECT title,(SELECT director_name from directors WHERE id=director_id ) as Director_Name FROM movies
WHERE day='Wednesday' 
AND director_id IN (
	SELECT id FROM directors
    WHERE director_name='Christopher Nolan'
    );

#------------------------------------------------------------------------------------------------------------------------------------------------------
# 5. Write a query to find the top 5 directors with the highest total movie revenue?

SELECT director_name FROM directors
WHERE id IN (
	SELECT director_id FROM movies
    ORDER BY revenue 
    )
    LIMIT 5;

#------------------------------------------------------------------------------------------------------------------------------------------------------
# 6. Show only the directors who have directed more than 2 movies.

SELECT director_name FROM directors
WHERE id in (
	SELECT DISTINCT director_id FROM movies
    group by director_id 
    HAVING director_id > 2
	);

#------------------------------------------------------------------------------------------------------------------------------------------------------
# 7. For each state, display the State, 
# concatenated customer names (in the format FirstName LastName), 
# and the total revenue generated from orders in that state. 
# Sort the result by total revenue in descending order. (3 marks)

SELECT 
    State, 
    (SELECT GROUP_CONCAT(FirstName, ' ', LastName) 
     FROM cust 
     WHERE cust.State = c.State) AS CustomerNames, 
    (SELECT SUM(TotalAmount) 
     FROM orders 
     WHERE CustomerID IN (SELECT CustomerID FROM cust WHERE State = c.State)) AS TotalRevenue
FROM cust c
GROUP BY State
ORDER BY TotalRevenue DESC;

#------------------------------------------------------------------------------------------------------------------------------------------------------
# 8. 
# Find the top 2(3) customers (by CustomerID) who have placed the highest total order amounts, 
# but only include customers who have placed more than 1(2) orders. 
# Display their CustomerID, total order amount, 
# and the number of orders they have placed. 
# Sort the result by the total order amount in descending order. (3 marks)

SELECT CustomerID, SUM(TotalAmount) AS TotalOrderAmount, COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) > 1
ORDER BY TotalOrderAmount DESC
LIMIT 2;


#------------------------------------------------------------------------------------------------------------------------------------------------------
# 9. Find all orders placed by customers in Texas (TX) or California (CA). (2 marks)
SELECT *, (
	SELECT STATE FROM cust 
    WHERE cust.CustomerID=orders.CustomerID
    )as State 
FROM orders
WHERE CustomerID IN (
	SELECT CustomerID FROM cust
    WHERE State='TX' or State='CA'
    );


