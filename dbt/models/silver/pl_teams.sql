with teams_24_25 as (

    select
        '2024/2025' as season,
        id as team_id,
        name as team_name,
        tla,
        founded as founded_year,
        venue as stadium,
        area_code as country
    from {{ source('pl_data', 'football_data_pl_teams_2024_25') }}

),

teams_25_26 as (

    select
        '2025/2026' as season,
        id as team_id,
        name as team_name,
        tla,
        founded as founded_year,
        venue as stadium,
        area_code as country
    from {{ source('pl_data', 'football_data_pl_teams_2025_26') }}

),

teams_26_27 as (

    select
        '2026/2027' as season,
        id as team_id,
        name as team_name,
        tla,
        founded as founded_year,
        venue as stadium,
        area_code as country
    from {{ source('pl_data', 'football_data_pl_teams_2026_27') }}

)

select * from teams_24_25

union all

select * from teams_25_26

union all

select * from teams_26_27
