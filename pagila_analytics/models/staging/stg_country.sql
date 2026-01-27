with source as (
    select * from {{ source('pagila', 'country') }}
),

renamed as (
    select
        country_id,
        country,
        last_update
    from source
)

select * from renamed