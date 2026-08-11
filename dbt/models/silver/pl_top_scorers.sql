WITH top_scorers_24_25 AS (
    SELECT
    '2024/2025' AS season,
    player_id,
    player_name,
    player_nationality,
    playedMatches AS played_matches,
    goals,
    COALESCE(CAST(assists AS int), 0) AS assists,
    COALESCE(CAST(penalties AS int), 0) AS penalties,
    goals + COALESCE(CAST(assists AS int), 0) AS canadian_points
    FROM {{ source('pl_data', 'football_data_pl_top_scorers_2024_25') }}
),

top_scorers_25_26 AS (
    SELECT
    '2025/2026' AS season,
    player_id,
    player_name,
    player_nationality,
    playedMatches AS played_matches,
    goals,
    COALESCE(CAST(assists AS int), 0) AS assists,
    COALESCE(CAST(penalties AS int), 0) AS penalties,
    goals + COALESCE(CAST(assists AS int), 0) AS canadian_points
    FROM {{ source('pl_data', 'football_data_pl_top_scorers_2025_26') }}
),

top_scorers_26_27 AS (
    SELECT
    '2026/2027' AS season,
    player_id,
    player_name,
    player_nationality,
    playedMatches AS played_matches,
    goals,
    COALESCE(CAST(assists AS int), 0) AS assists,
    COALESCE(CAST(penalties AS int), 0) AS penalties,
    goals + COALESCE(CAST(assists AS int), 0) AS canadian_points
    FROM {{ source('pl_data', 'football_data_pl_top_scorers_2026_27') }}
)


SELECT * FROM top_scorers_24_25

UNION ALL

SELECT * FROM top_scorers_25_26

UNION ALL

SELECT * FROM top_scorers_26_27
