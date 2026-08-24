WITH base_teams AS (
    SELECT
    *
    FROM {{ ref('pl_teams') }}
)

SELECT 
team_id,
team_name,
tla,
founded_year,
stadium,
country,
MAX(season) AS last_season
FROM base_teams
GROUP BY 1,2,3,4,5,6