with base_match_team as (
    select *
    from {{ ref('fct_match_team') }}
),

team_season as (
    select
        season_id,
        team_id,
        count(*) as matches_played,
        sum(case
            when result = 'WIN' then 1
            else 0
        end) as wins,
        sum(case
            when result = 'DRAW' then 1
            else 0
        end) as draws,
        sum(case
            when result = 'LOSS' then 1
            else 0
        end) as losses,
        sum(goals_for) as goals_scored,
        sum(goals_against) as goals_conceded,
        sum(goal_difference) as goal_difference,
        sum(points) as points,
        round(sum(points) / count(*), 2) as points_per_game,
        round(sum(goals_for) / count(*), 2) as goals_scored_per_game,
        round(sum(goals_against) / count(*), 2) as goals_against_per_game,
        sum(case
            when goals_against = 0 then 1
            else 0
        end) as clean_sheets,
        sum(case
            when home_away = 'HOME' then points
            else 0
        end) as home_points,
        sum(case
            when home_away = 'AWAY' then points
            else 0
        end) as away_points
    from base_match_team
    group by 1, 2
)

select
    *,
    rank()
        over (partition by season_id order by points desc, goal_difference desc)
        as table_position
from team_season
