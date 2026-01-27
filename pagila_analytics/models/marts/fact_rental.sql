with rental_facts as (
    select * from {{ ref('int_rental_facts') }}
),
inventory as (
    select * from {{ ref('stg_inventory') }}
)

select
    r.rental_id,
    r.inventory_id,
    r.customer_id,
    r.staff_id,
    i.film_id,
    i.store_id,
    r.rental_date::date as rental_date_key,
    
    r.rental_date as rental_ts,
    r.return_date as return_ts,
    
    datediff('day', r.rental_date, r.return_date) as rental_duration_days,
    
    case when r.return_date is null then true else false end as is_rental_active,
    
    r.payment_amount
from rental_facts r
left join inventory i on r.inventory_id = i.inventory_id