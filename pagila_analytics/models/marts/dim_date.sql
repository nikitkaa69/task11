-- Generating a sequence of days
with date_spine as (
  select 
    dateadd(day, seq4(), '2005-01-01') as date_day
  from table(generator(rowcount => 10000)) -- generating 10k days
)

select
    date_day as date_id,
    year(date_day) as year,
    month(date_day) as month,
    monthname(date_day) as month_name,
    quarter(date_day) as quarter,
    dayofweek(date_day) as day_of_week_iso, -- 1 - monday
    dayname(date_day) as day_name,
    -- Weekend flag
    case when dayofweekiso(date_day) in (6, 7) then true else false end as is_weekend
from date_spine
where date_day <= '2030-12-31'