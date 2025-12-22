with source as (
    select * from {{ source('pagila', 'film') }}
),

renamed as (
    select
        film_id,
        title,
        description,
        release_year,
        language_id,
        original_language_id,
        rental_duration,
        rental_rate,
        length,
        replacement_cost,
        rating,
        last_update,
        special_features
    from source
)

select * from renamed