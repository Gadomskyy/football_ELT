WITH pl_winners_bronze AS (
    SELECT
    id AS season_id,
    {{ generate_season_code("startDate", "endDate") }} AS season,
    CAST(startDate AS DATE) AS season_start_date,
    CAST(endDate AS DATE) AS season_end_date,
    --manually add missing winners data
    CASE 
        WHEN startDate = '2023-08-11' THEN 'Manchester City FC'
        WHEN startDate = '2024-08-16' THEN 'Liverpool FC'
        WHEN startDate = '2025-08-15' THEN 'Arsenal FC'
        ELSE winner_name END AS winner,
    winner_id,
    winner_tla
    FROM {{ source('pl_data', 'football_data_pl_winners_bronze') }}
    WHERE startDate > '1992-08-13' --start of 92/93 season, first PL season
),

available_teams AS (
    SELECT DISTINCT
        team_id, 
        team_name,
        tla
        FROM {{ ref('pl_teams') }}
)


SELECT
    season_id,
    season,
    season_start_date,
    season_end_date,
    winner,
    CAST(CASE 
        WHEN winner_id IS NULL THEN a.team_id
        ELSE winner_id END 
        AS int) AS winner_id,
    CASE 
        WHEN winner_tla IS NULL THEN a.tla
        ELSE winner_tla END AS winner_tla
FROM pl_winners_bronze p
LEFT JOIN available_teams a ON p.winner = a.team_name