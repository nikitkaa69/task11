with actor_stats as (
    select 
        a.first_name, 
        a.last_name, 
        count(*) as child_films
    from {{ ref('dim_film') }} f
    join {{ ref('int_film_actor_bridge') }} a on f.film_id = a.film_id
    where f.category_name = 'Children'
    group by a.first_name, a.last_name
),
ranked as (
    select
        *,
        dense_rank() over (order by child_films desc) as rank_position
    from actor_stats
)

select first_name, last_name, child_films
from ranked
where rank_position < 4