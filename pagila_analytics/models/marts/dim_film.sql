with film as (
    select * from {{ ref('stg_film') }}
),
language as (
    select * from {{ ref('stg_language') }}
),
film_category as (
    select * from {{ ref('stg_film_category') }}
),
category as (
    select * from {{ ref('stg_category') }}
)

select
    f.film_id,
    f.title,
    f.description,
    f.release_year,
    c.category_name,
    l.language_name,
    f.rental_duration,
    f.rental_rate,
    f.length,
    f.replacement_cost,
    f.rating,
    f.special_features
from film f
left join language l on f.language_id = l.language_id
left join film_category fc on f.film_id = fc.film_id
left join category c on fc.category_id = c.category_id