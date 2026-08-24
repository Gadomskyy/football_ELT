with base_teams as (
    select *
    from {{ ref('pl_teams') }}
)

select
    team_id,
    team_name,
    tla,
    founded_year,
    stadium,
    country,
    max(season) as last_season
from base_teams
group by 1, 2, 3, 4, 5, 6
