select 
    city,
    count_if(is_active = true) as active_clients,
    count_if(is_active = false) as inactive_clients
from {{ ref('dim_customer') }}
group by city
order by inactive_clients desc