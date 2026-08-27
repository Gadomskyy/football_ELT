with base_seasons as (
    select *
    from {{ ref('dim_seasons') }}
),

base_team_season as (
    select *
    from {{ ref('fct_team_season') }}
),

base_match as (
    select *
    from {{ ref('fct_match') }}
),

base_teams as (
    select *
    from {{ ref('dim_teams') }}
),


base_players as (
    select *
    from {{ ref('dim_players') }}
),

base_top_scorer as (
    select *
    from {{ ref('fct_player_season') }}
),

season_summary as (
    select
        base_seasons.season_id,
        base_seasons.season,
        count(*) as total_matches,
        sum(base_match.is_home_win) as total_home_wins,
        sum(base_match.is_away_win) as total_away_wins,
        sum(base_match.is_draw) as total_draws,
        sum(base_match.home_goals + base_match.away_goals) as total_goals,
        sum(base_match.home_goals) as total_home_goals,
        sum(base_match.away_goals) as total_away_goals
    from base_seasons
    join base_match on base_seasons.season_id = base_match.season_id
    group by 1, 2
),

season_winners as (
    select
        base_team_season.season_id,
        base_team_season.team_id,
        base_teams.team_name,
        base_team_season.points
    from base_team_season
    join base_teams on base_team_season.team_id = base_teams.team_id
    where table_position = 1
),

top_scorers as (
    select
        base_top_scorer.player_id,
        base_top_scorer.season,
        base_players.player_name,
        base_top_scorer.goals,
        row_number()
            over (
                partition by base_top_scorer.season
                order by
                    base_top_scorer.goals desc,
                    base_top_scorer.assists desc,
                    base_top_scorer.played_matches desc
            )
            as top_scorer_rank
    from base_top_scorer
    left join base_players on base_top_scorer.player_id = base_players.player_id
)

select
    season_summary.season_id,
    season_summary.season,
    season_summary.total_matches,
    season_summary.total_home_wins,
    season_summary.total_away_wins,
    season_summary.total_draws,
    season_summary.total_goals,
    season_summary.total_home_goals,
    season_summary.total_away_goals,
    season_winners.team_id as winning_team_id,
    season_winners.team_name as winning_team_name,
    top_scorers.player_id as top_scorer_player_id,
    top_scorers.player_name as top_scorer_player_name,
    top_scorers.goals as top_scorer_goals
from season_summary
join season_winners on season_summary.season_id = season_winners.season_id
join top_scorers on season_summary.season = top_scorers.season and top_scorers.top_scorer_rank = 1
