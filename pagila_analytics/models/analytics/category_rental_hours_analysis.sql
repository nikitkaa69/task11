with base_data as (
    select 
        f.category_name as name,
        c.city,
        datediff('second', r.rental_ts, r.return_ts) / 3600 as rent_hours
    from {{ ref('fact_rental') }} r
    join {{ ref('dim_film') }} f on r.film_id = f.film_id
    join {{ ref('dim_customer') }} c on r.customer_id = c.customer_id
    where r.return_ts is not null
),

aggregated as (
    select 
        name,
        case 
            when city ilike 'a%' then 'Starts with A'
            when city like '%-%' then 'Contains hyphen (-)'
        end as criteria,
        sum(rent_hours) as total_rent_hours
    from base_data
    where city ilike 'a%' or city like '%-%'
    group by name, criteria
),

ranked as (
    select 
        criteria,
        name,
        round(total_rent_hours, 2) as time_rent,
        row_number() over (partition by criteria order by total_rent_hours desc) as rn
    from aggregated
)

select criteria, name, time_rent
from ranked
where rn = 1