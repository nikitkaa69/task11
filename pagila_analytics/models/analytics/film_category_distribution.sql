select 
    category_name,
    count(film_id) as count_film_category
from {{ ref('dim_film') }}
where category_name is not null
group by category_name
order by count_film_category desc