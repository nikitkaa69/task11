with source as (
    select * from {{ source('pagila', 'customer') }}
),

renamed as (
    select
        customer_id,
        store_id,
        first_name,
        last_name,
        email,
        address_id,
        activebool as is_active,
        create_date,
        last_update
    from source
)

select * from renamed