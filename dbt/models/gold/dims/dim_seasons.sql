WITH seasons AS (

    SELECT
        season_id,
        season,
        season_start_date,
        season_end_date
    FROM {{ ref('pl_winners') }}

)

SELECT
    season_id,
    season,
    season_start_date,
    season_end_date,
    EXTRACT(YEAR FROM season_start_date) AS start_year,
    EXTRACT(YEAR FROM season_end_date) AS end_year
FROM seasons