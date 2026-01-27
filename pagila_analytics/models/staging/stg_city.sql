with source as (
    select * from {{ source('pagila', 'city') }}
),

renamed as (
    select
        city_id,
        city,
        country_id,
        last_update
    from source
)

select * from renamed