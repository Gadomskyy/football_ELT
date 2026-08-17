WITH base_matches AS (
    SELECT
    *
    FROM {{ ref('pl_matches') }}
    WHERE match_status = 'FINISHED'
),

home_team_match AS (
SELECT
    match_id,
    season_id,
    match_date,
    matchday,
    competition_id,
    competition_code, 
    'HOME' AS home_away,
    home_team_id,
    score_full_time,
    score_full_time_home AS goals_for,
    score_full_time_away AS goals_against,
    (score_full_time_home - score_full_time_away) AS goal_difference,
    CASE
        WHEN score_full_time_home > score_full_time_away THEN 'WIN'
        WHEN score_full_time_home = score_full_time_away THEN 'DRAW'
        ELSE 'LOSS'
        END AS result,
    CASE
        WHEN score_full_time_home > score_full_time_away THEN 3
        WHEN score_full_time_home = score_full_time_away THEN 1
        ELSE 0
    END AS points
FROM base_matches
),
    
away_team_match AS (
SELECT
    match_id,
    season_id,
    match_date,
    matchday,
    competition_id,
    competition_code, 
    'AWAY' AS home_away,
    away_team_id,
    score_full_time,
    score_full_time_away AS goals_for,
    score_full_time_home AS goals_against,
    (score_full_time_away - score_full_time_home) AS goal_difference,
    CASE
        WHEN score_full_time_away > score_full_time_home THEN 'WIN'
        WHEN score_full_time_home = score_full_time_away THEN 'DRAW'
        ELSE 'LOSS'
        END AS result,
    CASE
        WHEN score_full_time_away > score_full_time_home THEN 3
        WHEN score_full_time_home = score_full_time_away THEN 1
        ELSE 0
    END AS points
FROM base_matches
)

SELECT * FROM home_team_match

UNION ALL

SELECT * FROM away_team_match