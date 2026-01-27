with source as (
    select * from {{ source('pagila', 'address') }}
),

renamed as (
    select
        address_id,
        address,
        address2,
        district,
        city_id,
        postal_code,
        phone,
        last_update
    from source
)

select * from renamed