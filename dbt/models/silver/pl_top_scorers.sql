with top_scorers_24_25 as (
    select
        '2024/2025' as season,
        player_id,
        player_name,
        player_nationality,
        playedmatches as played_matches,
        goals,
        coalesce(cast(assists as int), 0) as assists,
        coalesce(cast(penalties as int), 0) as penalties,
        goals + coalesce(cast(assists as int), 0) as canadian_points
    from {{ source('pl_data', 'football_data_pl_top_scorers_2024_25') }}
),

top_scorers_25_26 as (
    select
        '2025/2026' as season,
        player_id,
        player_name,
        player_nationality,
        playedmatches as played_matches,
        goals,
        coalesce(cast(assists as int), 0) as assists,
        coalesce(cast(penalties as int), 0) as penalties,
        goals + coalesce(cast(assists as int), 0) as canadian_points
    from {{ source('pl_data', 'football_data_pl_top_scorers_2025_26') }}
),

top_scorers_26_27 as (
    select
        '2026/2027' as season,
        player_id,
        player_name,
        player_nationality,
        playedmatches as played_matches,
        goals,
        coalesce(cast(assists as int), 0) as assists,
        coalesce(cast(penalties as int), 0) as penalties,
        goals + coalesce(cast(assists as int), 0) as canadian_points
    from {{ source('pl_data', 'football_data_pl_top_scorers_2026_27') }}
)


select * from top_scorers_24_25

union all

select * from top_scorers_25_26

union all

select * from top_scorers_26_27
