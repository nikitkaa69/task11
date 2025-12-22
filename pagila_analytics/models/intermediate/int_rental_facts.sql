with rental as (
    select * from {{ ref('stg_rental') }}
),
payment as (
    select * from {{ ref('stg_payment') }}
),

joined as (
    select
        r.rental_id,
        r.customer_id,
        r.staff_id,
        r.rental_date,
        r.return_date,
        p.amount as payment_amount,
        p.payment_date
    from rental r
    left join payment p on r.rental_id = p.rental_id
)

select * from joined