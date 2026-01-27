with enriched_customers as (
    select * from {{ ref('int_customer_enriched') }}
)

select 
    customer_id,
    first_name,
    last_name,
    -- added a convenient field for analysts
    first_name || ' ' || last_name as full_name,
    email,
    is_active,
    address,
    city,
    country,
    store_id
from enriched_customers