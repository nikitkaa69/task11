with source as (
    select * from {{ source('pagila', 'inventory') }}
),

renamed as (
    select
        inventory_id,
        film_id,
        store_id,
        last_update
    from source
)

select * from renamed