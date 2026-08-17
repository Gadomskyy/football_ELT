WITH pl_matches_24_25 AS (
    SELECT 
    {{ generate_season_code("season_startDate", "season_endDate") }} AS season,
    id AS match_id,
    DATE(TIMESTAMP(utcDate)) AS match_date,
    utcDate AS match_date_utc,
    status as match_status,
    matchday,
    JSON_EXTRACT_SCALAR(referees, '$[0].name') AS referee,
    competition_id,
    competition_name,
    competition_code,
    season_id,
    homeTeam_id AS home_team_id,
    awayTeam_id AS away_team_id,
    score_winner,
    score_fullTime_home AS score_full_time_home,
    score_fullTime_away AS score_full_time_away,
    CONCAT(score_fullTime_home, ":", score_fullTime_away) AS score_full_time,
    score_halfTime_home AS score_half_time_home,
    score_halfTime_away AS score_half_time_away,
    CONCAT(score_halfTime_home, ":", score_halfTime_away) AS score_half_time
    FROM {{ source('pl_data', 'football_data_pl_matches_2024_25') }}
),
pl_matches_25_26 AS (
    SELECT 
    {{ generate_season_code("season_startDate", "season_endDate") }} AS season,
    id AS match_id,
    DATE(TIMESTAMP(utcDate)) AS match_date,
    utcDate AS match_date_utc,
    status as match_status,
    matchday,
    JSON_EXTRACT_SCALAR(referees, '$[0].name') AS referee,
    competition_id,
    competition_name,
    competition_code,
    season_id,
    homeTeam_id AS home_team_id,
    awayTeam_id AS away_team_id,
    score_winner,
    score_fullTime_home AS score_full_time_home,
    score_fullTime_away AS score_full_time_away,
    CONCAT(score_fullTime_home, ":", score_fullTime_away) AS score_full_time,
    score_halfTime_home AS score_half_time_home,
    score_halfTime_away AS score_half_time_away,
    CONCAT(score_halfTime_home, ":", score_halfTime_away) AS score_half_time
    FROM {{ source('pl_data', 'football_data_pl_matches_2025_26') }}
),
pl_matches_26_27 AS (
    SELECT 
    {{ generate_season_code("season_startDate", "season_endDate") }} AS season,
    id AS match_id,
    DATE(TIMESTAMP(utcDate)) AS match_date,
    utcDate AS match_date_utc,
    status as match_status,
    matchday,
    JSON_EXTRACT_SCALAR(referees, '$[0].name') AS referee,
    competition_id,
    competition_name,
    competition_code,
    season_id,
    homeTeam_id AS home_team_id,
    awayTeam_id AS away_team_id,
    score_winner,
    CAST(score_fullTime_home AS INT) AS score_full_time_home,
    CAST(score_fullTime_away AS INT) AS score_full_time_away,
    CONCAT(score_fullTime_home, ":", score_fullTime_away) AS score_full_time,
    CAST(score_halfTime_home AS INT) AS score_half_time_home,
    CAST(score_halfTime_away AS INT) AS score_half_time_away,
    CONCAT(score_halfTime_home, ":", score_halfTime_away) AS score_half_time
    FROM {{ source('pl_data', 'football_data_pl_matches_2026_27') }}
)

SELECT * FROM pl_matches_24_25

UNION ALL

SELECT * FROM pl_matches_25_26

UNION ALL

SELECT * FROM pl_matches_26_27
