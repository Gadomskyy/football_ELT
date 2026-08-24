with base_matches as (
    select *
    from {{ ref('pl_matches') }}
    where match_status = 'FINISHED'
),

matches as (
    select
        match_id,
        season_id,
        match_date,
        match_status,
        matchday,
        referee,
        competition_id,
        competition_code,
        home_team_id,
        away_team_id,
        score_half_time_home as half_time_home_goals,
        score_half_time_away as half_time_away_goals,
        (score_full_time_home - score_half_time_home) as second_half_home_goals,
        (score_full_time_away - score_half_time_away) as second_half_away_goals,
        score_full_time,
        score_full_time_home as home_goals,
        score_full_time_away as away_goals,
        (score_full_time_home + score_full_time_away) as total_goals,
        case
            when score_full_time_home > score_full_time_away
                then 1
            else 0
        end as is_home_win,
        case
            when score_full_time_home < score_full_time_away
                then 1
            else 0
        end as is_away_win,
        case
            when score_full_time_home = score_full_time_away
                then 1
            else 0
        end as is_draw
    from base_matches
)

select
    *,
    case
        when is_home_win = 1 then 3
        when is_draw = 1 then 1
        else 0
    end as home_points,
    case
        when is_away_win = 1 then 3
        when is_draw = 1 then 1
        else 0
    end as away_points
from matches
