with base_players as (
    select *
    from {{ ref('pl_squads') }}
),

base_top_scorers as (
    select *
    from {{ ref('pl_top_scorers') }}
)

select
    base_players.player_id,
    base_players.season,
    base_players.team_id,
    base_top_scorers.played_matches,
    base_top_scorers.goals,
    base_top_scorers.assists,
    base_top_scorers.penalties,
    (base_top_scorers.goals - base_top_scorers.penalties) as non_penalties_goals,
    base_top_scorers.canadian_points
from base_players
join base_top_scorers on
    base_players.player_id = base_top_scorers.player_id
    and base_players.season = base_top_scorers.season
