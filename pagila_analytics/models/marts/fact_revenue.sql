with payment as (
    select * from {{ ref('stg_payment') }}
)

select
    payment_id,
    customer_id,
    staff_id,
    rental_id,
    -- payment date
    payment_date::date as payment_date_key,
    payment_date as payment_ts,
    amount as revenue_amount
from payment