with teams_24_25 as (

    select *
    from {{ source('pl_data', 'football_data_pl_teams_2024_25') }}

),

teams_25_26 as (

    select *
    from {{ source('pl_data', 'football_data_pl_teams_2025_26') }}

),

teams_26_27 as (

    select *
    from {{ source('pl_data', 'football_data_pl_teams_2026_27') }}

),

players_24_25 as (
    select
        '2024/2025' as season,
        t.id as team_id,
        t.name as team_name,
        safe_cast(json_value(player, '$.id') as int64) as player_id,
        json_value(player, '$.name') as player_name,
        json_value(player, '$.position') as player_detailed_position,
        {{ player_position("JSON_VALUE(player, '$.position')") }} as player_position,
        safe_cast(json_value(player, '$.dateOfBirth') as date) as player_dob,
        json_value(player, '$.nationality') as player_nationality
    from teams_24_25 as t,
        unnest(json_extract_array(t.squad)) as player
),

players_25_26 as (
    select
        '2025/2026' as season,
        t.id as team_id,
        t.name as team_name,
        safe_cast(json_value(player, '$.id') as int64) as player_id,
        json_value(player, '$.name') as player_name,
        json_value(player, '$.position') as player_detailed_position,
        {{ player_position("JSON_VALUE(player, '$.position')") }} as player_position,
        safe_cast(json_value(player, '$.dateOfBirth') as date) as player_dob,
        json_value(player, '$.nationality') as player_nationality
    from teams_25_26 as t,
        unnest(json_extract_array(t.squad)) as player
),

players_26_27 as (
    select
        '2026/2027' as season,
        t.id as team_id,
        t.name as team_name,
        safe_cast(json_value(player, '$.id') as int64) as player_id,
        json_value(player, '$.name') as player_name,
        json_value(player, '$.position') as player_detailed_position,
        {{ player_position("JSON_VALUE(player, '$.position')") }} as player_position,
        safe_cast(json_value(player, '$.dateOfBirth') as date) as player_dob,
        json_value(player, '$.nationality') as player_nationality
    from teams_26_27 as t,
        unnest(json_extract_array(t.squad)) as player
)

select * from players_24_25

union all

select * from players_25_26

union all

select * from players_26_27
