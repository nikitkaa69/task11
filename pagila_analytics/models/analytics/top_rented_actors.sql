select 
    a.actor_id,
    a.first_name,
    a.last_name,
    count(r.rental_id) as rentals_count
from {{ ref('int_film_actor_bridge') }} a
join {{ ref('stg_inventory') }} i on a.film_id = i.film_id
join {{ ref('fact_rental') }} r on i.inventory_id = r.inventory_id
group by 
    a.actor_id,
    a.first_name, 
    a.last_name
order by rentals_count desc
limit 10