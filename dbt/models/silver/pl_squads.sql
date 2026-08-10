WITH teams_24_25 AS (

    SELECT *
    FROM {{ source('pl_data', 'football_data_pl_teams_2024_25') }}

),
teams_25_26 AS (

    SELECT *
    FROM {{ source('pl_data', 'football_data_pl_teams_2025_26') }}

),
teams_26_27 AS (

    SELECT *
    FROM {{ source('pl_data', 'football_data_pl_teams_2026_27') }}

),

players_24_25 AS (
SELECT
    '2024/2025' AS season,
    t.id AS team_id,
    t.name AS team_name,
    SAFE_CAST(JSON_VALUE(player, '$.id') AS INT64) AS player_id,
    JSON_VALUE(player, '$.name') AS player_name,
    JSON_VALUE(player, '$.position') AS player_position,
    SAFE_CAST(JSON_VALUE(player, '$.dateOfBirth') AS DATE) AS player_dob,
    JSON_VALUE(player, '$.nationality') AS player_nationality
FROM teams_24_25 AS t,
UNNEST(JSON_EXTRACT_ARRAY(t.squad)) AS player
),

players_25_26 AS (
SELECT
    '2025/2026' AS season,
    t.id AS team_id,
    t.name AS team_name,
    SAFE_CAST(JSON_VALUE(player, '$.id') AS INT64) AS player_id,
    JSON_VALUE(player, '$.name') AS player_name,
    JSON_VALUE(player, '$.position') AS player_position,
    SAFE_CAST(JSON_VALUE(player, '$.dateOfBirth') AS DATE) AS player_dob,
    JSON_VALUE(player, '$.nationality') AS player_nationality
FROM teams_25_26 AS t,
UNNEST(JSON_EXTRACT_ARRAY(t.squad)) AS player
),

players_26_27 AS (
SELECT
    '2026/2027' AS season,
    t.id AS team_id,
    t.name AS team_name,
    SAFE_CAST(JSON_VALUE(player, '$.id') AS INT64) AS player_id,
    JSON_VALUE(player, '$.name') AS player_name,
    JSON_VALUE(player, '$.position') AS player_position,
    SAFE_CAST(JSON_VALUE(player, '$.dateOfBirth') AS DATE) AS player_dob,
    JSON_VALUE(player, '$.nationality') AS player_nationality
FROM teams_26_27 AS t,
UNNEST(JSON_EXTRACT_ARRAY(t.squad)) AS player
)

SELECT * FROM players_24_25

UNION ALL

SELECT * FROM players_25_26

UNION ALL

SELECT * FROM players_26_27