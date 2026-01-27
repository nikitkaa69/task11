with source as (
    select * from {{ source('pagila', 'film_category') }}
),

renamed as (
    select
        film_id,
        category_id,
        last_update
    from source
)

select * from renamed