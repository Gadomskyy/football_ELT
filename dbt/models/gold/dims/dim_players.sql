WITH base_players AS (
    SELECT
    *
    FROM {{ ref('pl_squads') }}
)

SELECT
    player_id,
    player_name,
    player_position,
    player_dob,
    player_nationality,
    MAX(season) AS last_season
FROM base_players
GROUP BY 1,2,3,4,5