WITH base_players AS (
    SELECT 
    *
    FROM {{ ref('pl_squads') }}

),

latest_player_record AS (

    SELECT
        player_id,
        player_name,
        player_position,
        player_dob,
        player_nationality,
        season,
        ROW_NUMBER() OVER (
            PARTITION BY player_id
            ORDER BY season DESC
        ) AS row_num

    FROM base_players

),

player_seasons AS (

    SELECT
        player_id,
        MIN(season) AS first_season,
        MAX(season) AS last_season
    FROM base_players
    GROUP BY player_id

)

SELECT
    p.player_id,
    p.player_name,
    p.player_position AS latest_position,
    p.player_dob,
    p.player_nationality,
    s.first_season,
    s.last_season
FROM latest_player_record p
LEFT JOIN player_seasons s
    ON p.player_id = s.player_id
WHERE p.row_num = 1