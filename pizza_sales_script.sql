use pizzahut;

#Retrieve the total number of orders placed.
select count(*) total_orders from orders;

#Calculate the total revenue generated from pizza sales.
select round(sum(od.quantity* p.price),2) total_sales
from order_details od join pizzas p
on od.pizza_id = p.pizza_id;

#Identify the highest-priced pizza.
select pt.name, p.price
from pizza_types pt join pizzas p
on pt.pizza_type_id = p.pizza_type_id
order by p.price desc limit 1;

#Identify the most common pizza size ordered.
select p.size, count(od.order_details_id) order_count
from pizzas p join order_details od
on p.pizza_id = od.pizza_id
group by p.size order by order_count desc limit 1

#List the top 5 most ordered pizza types along with their quantities.
select pt.name name, sum(od.quantity) quantity
from pizza_types pt join pizzas p
on pt.pizza_type_id = p.pizza_type_id
join order_details od on
od.pizza_id = p.pizza_id 
group by name order by quantity desc limit 5;

#Join the necessary tables to find the total quantity of each pizza category ordered.
select pt.category , sum(od.quantity) quantity from pizza_types pt
join pizzas p on pt.pizza_type_id = p.pizza_type_id
join order_details od
on od.pizza_id = p.pizza_id
group by pt.category order by quantity;

#Determine the distribution of orders by hour of the day.
select hour(time) hours, count(order_id) orders from orders
group by hour(time);

#Join relevant tables to find the category-wise distribution of pizzas.
select category, count(name) qunatity from pizza_types
group by category;

#Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0) avg_qty_per_day from 
(select o.date, sum(od.quantity) quantity from orders o 
join order_details od on
o.order_id = od.order_id 
group by o.date) order_qty;

#Determine the top 3 most ordered pizza types based on revenue.
select pt.name name , sum(od.quantity * p.price) revenue
from pizza_types pt join pizzas p
on pt.pizza_type_id = p.pizza_type_id
join order_details od 
on od.pizza_id = p.pizza_id 
group by name order by revenue desc limit 3;

#Calculate the percentage contribution of each pizza type to total revenue.
select pt.category category , 
concat(round(sum(od.quantity * p.price) / (select round(sum(o.quantity* p.price),2) total_sales
from order_details o join pizzas p
on o.pizza_id = p.pizza_id) *100 , 2), '%') percentage
from pizza_types pt join pizzas p
on pt.pizza_type_id = p.pizza_type_id
join order_details od 
on od.pizza_id = p.pizza_id 
group by category order by Percentage desc

#Analyze the cumulative revenue generated over time.
select date, sum(revenue) over(order by date) cum_revenue
from
(select o.date date,
sum(od.quantity * p.price) revenue
from order_details od join pizzas p
on od.pizza_id = p.pizza_id
join orders o on
o.order_id = od.order_id 
group by date) as sales;

#Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category, name revenue, 
rank() over (partition by category order by revenue) as rn
from 
(select pt.category category, pt.name name, sum(od.quantity* p.price) revenue
from pizza_types pt join pizzas p
on pt.pizza_type_id = p.pizza_type_id
join order_details od
on od.pizza_id = p.pizza_id
group by category , name) as a;








