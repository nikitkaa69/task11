with category_revenue as (
    select 
        f.category_name as name,
        sum(p.revenue_amount) as rental_revenue
    from {{ ref('fact_revenue') }} p
    join {{ ref('fact_rental') }} r on p.rental_id = r.rental_id
    join {{ ref('dim_film') }} f on r.film_id = f.film_id
    group by f.category_name
),
ranked as (
    select 
        name, 
        rental_revenue,
        rank() over (order by rental_revenue desc) as rn
    from category_revenue
)

select name, rental_revenue
from ranked
where rn = 1