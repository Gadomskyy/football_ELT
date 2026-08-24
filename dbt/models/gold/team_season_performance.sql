with team_season as (
    select
    *
    from {{ ref('fct_team_season') }}
),

teams as (
    select
    * 
    from {{ ref('dim_teams') }}
),

seasons as (
    select
    *
    from {{ ref('dim_seasons') }}
),

winners as (
    select
    *
    from {{ ref('pl_winners') }}
)

select
team_season.season_id,
seasons.season,
team_season.team_id,
teams.team_name,
team_season.wins,
team_season.draws,
team_season.losses,
team_season.points,
team_season.points_per_game,
team_season.home_points,
team_season.away_points,
team_season.goals_scored,
team_season.goals_conceded,
team_season.goal_difference,
team_season.clean_sheets,
team_season.table_position,
case when winners.winner_id is not null then 1 else 0 end as is_winner
from team_season
join teams on team_season.team_id = teams.team_id
join seasons on team_season.season_id = seasons.season_id
left join winners on team_season.team_id = winners.winner_id and team_season.season_id = winners.season_id
