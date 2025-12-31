with film as (
    select * from {{ ref('stg_film') }}
),
actor as (
    select * from {{ ref('stg_actor') }}
),
film_actor as (
    select * from {{ ref('stg_film_actor') }}
),

joined as (
    select
        fa.actor_id,
        a.first_name,
        a.last_name,
        fa.film_id,
        f.title as film_title,
        f.rental_rate,
        f.rating
    from film_actor fa
    join film f on fa.film_id = f.film_id
    join actor a on fa.actor_id = a.actor_id
)

select * from joined