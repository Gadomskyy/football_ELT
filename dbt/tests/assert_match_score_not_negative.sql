SELECT
* 
FROM {{ ref('pl_matches') }}
WHERE (score_full_time_home < 0 OR score_full_time_away < 0)
    OR (score_half_time_home < 0 OR score_half_time_away < 0)