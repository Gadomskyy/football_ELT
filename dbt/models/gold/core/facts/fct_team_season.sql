WITH base_match_team AS (
    SELECT
    *
    FROM {{ ref('fct_match_team') }}
),

team_season AS (
SELECT
season_id,
team_id,
COUNT(*) AS matches_played,
SUM(CASE
    WHEN result = 'WIN' THEN 1
    ELSE 0 END) AS wins,
SUM(CASE
    WHEN result = 'DRAW' THEN 1
    ELSE 0 END) AS draws,
SUM(CASE
    WHEN result = 'LOSS' THEN 1
    ELSE 0 END) AS losses,
SUM(goals_for) AS goals_scored,
SUM(goals_against) AS goals_conceded,
SUM(goal_difference) AS goal_difference,
SUM(points) AS points,
ROUND(SUM(points) / COUNT(*), 2) AS points_per_game,
ROUND(SUM(goals_for) / COUNT(*), 2) AS goals_scored_per_game,
ROUND(SUM(goals_against) / COUNT(*), 2) AS goals_against_per_game,
SUM(CASE
    WHEN goals_against = 0 THEN 1
    ELSE 0 END) AS clean_sheets,
SUM(CASE
    WHEN home_away = 'HOME' THEN points
    ELSE 0 END) AS home_points,
SUM(CASE
    WHEN home_away = 'AWAY' THEN points
    ELSE 0 END) AS away_points
FROM base_match_team
GROUP BY 1,2
)

SELECT
*,
RANK() OVER(PARTITION BY season_id ORDER BY points DESC, goal_difference DESC) AS table_position
FROM team_season
