with customer as (
    select * from {{ ref('stg_customer') }}
),
address as (
    select * from {{ ref('stg_address') }}
),
city as (
    select * from {{ ref('stg_city') }}
),
country as (
    select * from {{ ref('stg_country') }}
),

joined as (
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.is_active,
        a.address,
        ci.city,
        co.country
    from customer c
    left join address a on c.address_id = a.address_id
    left join city ci on a.city_id = ci.city_id
    left join country co on ci.country_id = co.country_id
)

select * from joined