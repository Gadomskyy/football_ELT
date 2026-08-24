with match_team as (
    select 
    *
    from {{ ref('fct_match_team') }}
),

seasons as (
    select
    *
    from {{ ref('dim_seasons') }}
),

teams as (
    select
    *
    from {{ ref('dim_teams') }}
),

metrics_to_date as (
    select
        seasons.season_id,
        seasons.season,
        teams.team_id,
        teams.team_name,
        matchday,
        COUNT(*) OVER (PARTITION BY seasons.season_id, teams.team_id ORDER BY matchday) as matches_played,
        SUM(CASE WHEN result = 'WIN' THEN 1 ELSE 0 END) OVER (PARTITION BY seasons.season_id, teams.team_id ORDER BY matchday) as wins_to_date,
        SUM(CASE WHEN result = 'DRAW' THEN 1 ELSE 0 END) OVER (PARTITION BY seasons.season_id, teams.team_id ORDER BY matchday) as draws_to_date,
        SUM(CASE WHEN result = 'LOSS' THEN 1 ELSE 0 END) OVER (PARTITION BY seasons.season_id, teams.team_id ORDER BY matchday) as losses_to_date,
        SUM(goals_for) OVER (PARTITION BY seasons.season_id, teams.team_id ORDER BY matchday) as goals_for_to_date,
        SUM(goals_against) OVER (PARTITION BY seasons.season_id, teams.team_id ORDER BY matchday) as goals_against_to_date,
        SUM(goal_difference) OVER (PARTITION BY seasons.season_id, teams.team_id ORDER BY matchday) as goal_difference_to_date,
        SUM(points) OVER (PARTITION BY seasons.season_id, teams.team_id ORDER BY matchday) as points_to_date
    from match_team
    join seasons on match_team.season_id = seasons.season_id
    join teams on match_team.team_id = teams.team_id
)

select
    *,
    RANK() OVER (
        PARTITION BY season_id, matchday 
        ORDER BY points_to_date DESC, goal_difference_to_date DESC, goals_for_to_date DESC
    ) as position_after_matchday
from metrics_to_date
