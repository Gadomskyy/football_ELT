-- teams cannot play against themselves in a match

SELECT 
* 
FROM {{ ref('pl_matches') }}
WHERE home_team_id = away_team_id