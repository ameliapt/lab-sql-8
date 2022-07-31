-- SQL LAB 2.8
USE sakila;

-- 1. Write a query to display for each store its store ID, city, and country.
SELECT 
	s.store_id,
	c.city,
    cou.country
FROM store as s
JOIN address as a
ON s.address_id = a.address_id
JOIN city as c
ON a.city_id = c.city_id
JOIN country as cou
ON c.country_id = cou.country_id;

-- 2. Write a query to display how much business, in dollars, each store brought in.
SELECT 
	s.store_id,
	CONCAT(sum(p.amount), "$") as business
FROM payment as p
JOIN staff as s
ON p.staff_id = s.staff_id
GROUP BY store_id;

-- 3. Which film categories are longest?
SELECT 
	c.name as TOP_categories_by_duration, 
	sec_to_time(round(avg(length*60))) as duration_h
FROM category as c
JOIN film_category as fc
ON c.category_id = fc.category_id
JOIN film as f
ON fc.film_id = f.film_id
GROUP BY c.name
ORDER BY duration_h DESC LIMIT 5;


-- 4. Display the most frequently rented movies in descending order.
SELECT
    f.title as movie,
	count(p.customer_id) as num_rentals
FROM payment as p
LEFT JOIN rental as r
ON p.rental_id = r.rental_id
LEFT JOIN inventory as i
ON r.inventory_id = i.inventory_id
LEFT JOIN film as f
ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY num_rentals DESC;


-- 5. List the top five genres in gross revenue in descending order.
SELECT 
	c.name as genre,
    sum(p.amount) as gross_revenue
FROM payment as p
LEFT JOIN rental as r
ON p.rental_id = r.rental_id
LEFT JOIN inventory as i
ON r.inventory_id = i.inventory_id
LEFT JOIN film_category as fc
ON i.film_id = fc.film_id
LEFT JOIN category as c
ON fc.category_id = c.category_id
GROUP BY genre
ORDER BY gross_revenue DESC LIMIT 5;


-- 6. Is "Academy Dinosaur" available for rent from Store 1? 
SELECT 
    f.title as movie,
	i.store_id,
    count(i.film_id) as units_available_for_rent
FROM rental as r
LEFT JOIN inventory as i
ON r.inventory_id = i.inventory_id
LEFT JOIN film as f
ON i.film_id = f.film_id
WHERE (i.store_id = 1) and (f.title = 'ACADEMY DINOSAUR')
GROUP BY movie;


-- 7. Get all pairs of actors that worked together.
SELECT 
f.title as movie, 
CONCAT (a1.first_name, ' ', a1.last_name) as actor_1, 
CONCAT (a2.first_name, ' ', a2.last_name) as actor_2
FROM film as f
	INNER JOIN film_actor as fa
	ON f.film_id = fa.film_id
    INNER JOIN actor as a1
    ON fa.actor_id = a1.actor_id
	INNER JOIN film_actor as fa2
    on f.film_id = fa2.film_id
    INNER JOIN actor as a2
    ON fa2.actor_id = a2.actor_id
WHERE a1.actor_id > a2.actor_id;

-- 8. For each film, list actor that has acted in more films.
SELECT
	a.first_name, 
	a.last_name,
	COUNT(*) as film_count
FROM actor as a
JOIN film_actor as fa
ON a.actor_id = fa.actor_id
GROUP BY first_name, last_name
ORDER BY film_count DESC;