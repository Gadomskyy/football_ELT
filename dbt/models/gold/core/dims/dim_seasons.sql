with seasons as (

    select
        season_id,
        season,
        season_start_date,
        season_end_date
    from {{ ref('pl_winners') }}

)

select
    season_id,
    season,
    season_start_date,
    season_end_date,
    extract(year from season_start_date) as start_year,
    extract(year from season_end_date) as end_year
from seasons
