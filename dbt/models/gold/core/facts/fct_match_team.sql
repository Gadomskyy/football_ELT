with base_matches as (
    select *
    from {{ ref('pl_matches') }}
    where match_status = 'FINISHED'
),

home_team_match as (
    select
        match_id,
        season_id,
        match_date,
        matchday,
        competition_id,
        competition_code,
        'HOME' as home_away,
        home_team_id as team_id,
        score_full_time,
        score_full_time_home as goals_for,
        score_full_time_away as goals_against,
        (score_full_time_home - score_full_time_away) as goal_difference,
        case
            when score_full_time_home > score_full_time_away then 'WIN'
            when score_full_time_home = score_full_time_away then 'DRAW'
            else 'LOSS'
        end as result,
        case
            when score_full_time_home > score_full_time_away then 3
            when score_full_time_home = score_full_time_away then 1
            else 0
        end as points
    from base_matches
),

away_team_match as (
    select
        match_id,
        season_id,
        match_date,
        matchday,
        competition_id,
        competition_code,
        'AWAY' as home_away,
        away_team_id as team_id,
        score_full_time,
        score_full_time_away as goals_for,
        score_full_time_home as goals_against,
        (score_full_time_away - score_full_time_home) as goal_difference,
        case
            when score_full_time_away > score_full_time_home then 'WIN'
            when score_full_time_home = score_full_time_away then 'DRAW'
            else 'LOSS'
        end as result,
        case
            when score_full_time_away > score_full_time_home then 3
            when score_full_time_home = score_full_time_away then 1
            else 0
        end as points
    from base_matches
)

select * from home_team_match

union all

select * from away_team_match
