with match_team as (
    select *
    from {{ ref('fct_match_team') }}
),

seasons as (
    select *
    from {{ ref('dim_seasons') }}
),

teams as (
    select *
    from {{ ref('dim_teams') }}
),

metrics_to_date as (
    select
        seasons.season_id,
        seasons.season,
        teams.team_id,
        teams.team_name,
        matchday,
        count(*)
            over (partition by seasons.season_id, teams.team_id order by matchday)
            as matches_played,
        sum(case when result = 'WIN' then 1 else 0 end)
            over (partition by seasons.season_id, teams.team_id order by matchday)
            as wins_to_date,
        sum(case when result = 'DRAW' then 1 else 0 end)
            over (partition by seasons.season_id, teams.team_id order by matchday)
            as draws_to_date,
        sum(case when result = 'LOSS' then 1 else 0 end)
            over (partition by seasons.season_id, teams.team_id order by matchday)
            as losses_to_date,
        sum(goals_for)
            over (partition by seasons.season_id, teams.team_id order by matchday)
            as goals_for_to_date,
        sum(goals_against)
            over (partition by seasons.season_id, teams.team_id order by matchday)
            as goals_against_to_date,
        sum(goal_difference)
            over (partition by seasons.season_id, teams.team_id order by matchday)
            as goal_difference_to_date,
        sum(points)
            over (partition by seasons.season_id, teams.team_id order by matchday)
            as points_to_date
    from match_team
    join seasons on match_team.season_id = seasons.season_id
    join teams on match_team.team_id = teams.team_id
)

select
    *,
    rank() over (
        partition by season_id, matchday
        order by points_to_date desc, goal_difference_to_date desc, goals_for_to_date desc
    ) as position_after_matchday
from metrics_to_date
