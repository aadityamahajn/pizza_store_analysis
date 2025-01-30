USE pizzahut;

#Retrieve the total number of orders placed.
SELECT 
    COUNT(*) AS total_orders
FROM 
    orders;

#Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS total_sales
FROM 
    order_details od
JOIN 
    pizzas p ON od.pizza_id = p.pizza_id;

#Identify the highest-priced pizza.
SELECT
  pt.name, p.price
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

#Identify the most common pizza size ordered.
SELECT 
    p.size, 
    COUNT(od.order_details_id) AS order_count
FROM 
    pizzas p
JOIN 
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY 
    p.size
ORDER BY 
    order_count DESC
LIMIT 
    1;

#List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pt.name AS name,
    SUM(od.quantity) AS quantity
FROM
    pizza_types pt 
JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN
    order_details od ON od.pizza_id = p.pizza_id 
GROUP BY
    name
ORDER BY 
    quantity DESC
LIMIT 
     5;

#Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pt.category,
    SUM(od.quantity) AS quantity
FROM 
    pizza_types pt
JOIN 
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN 
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY 
    pt.category
ORDER BY 
    quantity;

#Determine the distribution of orders by hour of the day.
SELECT
    HOUR(time) AS hours,
    COUNT(order_id) AS orders
FROM
    orders
GROUP BY
    hours
ORDER BY 
    hours ASC;

#Join relevant tables to find the category-wise distribution of pizzas.
SELECT
    category,
    COUNT(name) AS quantity
FROM
    pizza_types
GROUP BY
    category;

#Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
     round(avg(quantity),0) AS avg_qty_per_day 
FROM
    (SELECT 
          o.date, SUM(od.quantity) AS quantity 
     FROM 
          orders o 
     JOIN 
         order_details od ON o.order_id = od.order_id 
     GROUP BY 
         o.date) 
     order_qty;

#Determine the top 3 most ordered pizza types based on revenue.
SELECT
     pt.name name , 
     sum(od.quantity * p.price) AS revenue
FROM 
     pizza_types pt 
JOIN 
     pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN 
     order_details od ON od.pizza_id = p.pizza_id 
GROUP BY
     name 
ORDER BY
     revenue desc 
LIMINT
     3;

#Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
     pt.category category , 
CONCAT(round(SUM(od.quantity * p.price)/(SELECT round(SUM(o.quantity* p.price),2) 
     AS total_sales
FROM
     order_details o 
JOIN 
     pizzas p ON o.pizza_id = p.pizza_id) *100 , 2), '%') percentage
FROM 
     pizza_types pt join pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN 
     order_details od ON od.pizza_id = p.pizza_id 
GROUP BY
    category 
ORDER BY 
    Percentage DESC;

#Analyze the cumulative revenue generated over time.
SELECT 
      date, SUM(revenue) OVER(ORDER BY date) cum_revenue
FROM
     (SELECT
            o.date date,
            SUM(od.quantity * p.price) AS revenue
      FROM 
           order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id
           JOIN orders o ON o.order_id = od.order_id 
           GROUP BY date)
AS sales;

#Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT
      category, name revenue, 
      rank() over (partition BY category ORDER BY revenue) AS rn
FROM 
     (SELECT 
            pt.category AS category, pt.name AS name, sum(od.quantity* p.price) AS revenue
      FROM
            pizza_types pt JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
            JOIN order_details od ON od.pizza_id = p.pizza_id
      GROUP BY category , name) 
AS a;





