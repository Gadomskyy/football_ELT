WITH base_matches AS (
    SELECT
    *
    FROM {{ ref('pl_matches') }}
),

matches AS (
SELECT
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
score_half_time_home AS half_time_home_goals,
score_half_time_away AS half_time_away_goals,
(score_full_time_home - score_half_time_home) AS second_half_home_goals,
(score_full_time_away - score_half_time_away) AS second_half_away_goals,
score_full_time,
score_full_time_home AS home_goals,
score_full_time_away AS away_goals,
(score_full_time_home + score_full_time_away) AS total_goals,
CASE
    WHEN score_full_time_home > score_full_time_away
    THEN 1 ELSE 0 END AS is_home_win,
CASE
    WHEN score_full_time_home < score_full_time_away
    THEN 1 ELSE 0 END AS is_away_win,
CASE
    WHEN score_full_time_home = score_full_time_away
    THEN 1 ELSE 0 END AS is_draw
FROM base_matches
)

SELECT
*,
CASE
    WHEN is_home_win = 1 THEN 3
    WHEN is_draw = 1 THEN 1
    ELSE 0 END AS home_points,
CASE
    WHEN is_away_win = 1 THEN 3
    WHEN is_draw = 1 THEN 1
    ELSE 0 END AS away_points
FROM matches  

