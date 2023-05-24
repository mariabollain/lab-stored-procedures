use sakila;

# 1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies.
# Convert the query into a simple stored procedure.
 
DELIMITER //
create procedure customers_action()
begin
select first_name, last_name, email 
from customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name = "Action"
group by first_name, last_name, email;
end //
DELIMITER ;

drop procedure if exists customers_action;

CALL customers_action;


# 2. Now keep working on the previous stored procedure to make it more dynamic. 
# Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. 
# For eg., it could be action, animation, children, classics, etc.

DELIMITER //
create procedure customers_category(in category char(20))
begin
select first_name, last_name, email 
from customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name = category
group by first_name, last_name, email;
end //
DELIMITER ;

CALL customers_category("Animation");

# 3. Write a query to check the number of movies released in each movie category. 
# Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. 
# Pass that number as an argument in the stored procedure.

SELECT category_id, COUNT(film_id) AS number_films 
FROM film_category
GROUP BY category_id;

DELIMITER //
create procedure count_films_category(in filter_number int)
begin
SELECT category_id, COUNT(film_id) AS number_films 
FROM film_category
GROUP BY category_id
HAVING number_films > filter_number;
end //
DELIMITER ;

CALL count_films_category(70);

drop procedure if exists count_films_category;