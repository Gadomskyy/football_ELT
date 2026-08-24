with pl_winners_bronze as (
    select
        id as season_id,
        {{ generate_season_code("startDate", "endDate") }} as season,
        cast(startdate as date) as season_start_date,
        cast(enddate as date) as season_end_date,
        --manually add missing winners data
        case
            when startdate = '2023-08-11' then 'Manchester City FC'
            when startdate = '2024-08-16' then 'Liverpool FC'
            when startdate = '2025-08-15' then 'Arsenal FC'
            else winner_name
        end as winner,
        winner_id,
        winner_tla
    from {{ source('pl_data', 'football_data_pl_winners_bronze') }}
    where startdate > '1992-08-13' --start of 92/93 season, first PL season
),

available_teams as (
    select distinct
        team_id,
        team_name,
        tla
    from {{ ref('pl_teams') }}
)


select
    season_id,
    season,
    season_start_date,
    season_end_date,
    winner,
    cast(case
        when winner_id is null then a.team_id
        else winner_id
    end
    as int) as winner_id,
    case
        when winner_tla is null then a.tla
        else winner_tla
    end as winner_tla
from pl_winners_bronze p
left join available_teams a on p.winner = a.team_name
