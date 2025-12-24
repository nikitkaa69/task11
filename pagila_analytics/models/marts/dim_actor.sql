with actors as (
    select * from {{ ref('stg_actor') }}
)

select
    actor_id,
    first_name,
    last_name,
    first_name || ' ' || last_name as full_name
from actors