with date_spine as (

    select date
    from unnest(
        generate_date_array(
            date('2020-01-01'),
            date('2030-12-31'),
            interval 1 day
        )
    ) as date

)

select
    cast(format_date('%Y%m%d', date) as int64) as date_key,
    date,
    extract(year from date) as year,
    extract(quarter from date) as quarter,
    extract(month from date) as month,
    format_date('%B', date) as month_name,
    format_date('%Y-%m', date) as year_month,
    extract(isoyear from date) as iso_year,
    extract(isoweek from date) as iso_week,
    extract(day from date) as day_of_month,
    extract(dayofweek from date) as day_of_week,
    format_date('%A', date) as day_name,
    extract(dayofweek from date) in (1, 7) as is_weekend

from date_spine

