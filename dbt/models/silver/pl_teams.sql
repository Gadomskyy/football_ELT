WITH teams_24_25 AS (

    SELECT
        '2024/2025' AS season,
        id AS team_id,
        name AS team_name,
        tla,
        founded AS founded_year,
        venue AS stadium,
        area_code AS country
    FROM {{ source('pl_data', 'football_data_pl_teams_2024_25') }}

),

teams_25_26 AS (

    SELECT
        '2025/2026' AS season,
        id AS team_id,
        name AS team_name,
        tla,
        founded AS founded_year,
        venue AS stadium,
        area_code AS country
    FROM {{ source('pl_data', 'football_data_pl_teams_2025_26') }}

),

teams_26_27 AS (

    SELECT
        '2026/2027' AS season,
        id AS team_id,
        name AS team_name,
        tla,
        founded AS founded_year,
        venue AS stadium,
        area_code AS country
    FROM {{ source('pl_data', 'football_data_pl_teams_2026_27') }}

)

SELECT * FROM teams_24_25

UNION ALL

SELECT * FROM teams_25_26

UNION ALL

SELECT * FROM teams_26_27