with base_players as (
    select *
    from {{ ref('pl_squads') }}

),

latest_player_record as (

    select
        player_id,
        player_name,
        player_position,
        player_dob,
        player_nationality,
        season,
        row_number() over (
            partition by player_id
            order by season desc
        ) as row_num

    from base_players

),

player_seasons as (

    select
        player_id,
        min(season) as first_season,
        max(season) as last_season
    from base_players
    group by player_id

)

select
    p.player_id,
    p.player_name,
    p.player_position as latest_position,
    p.player_dob,
    p.player_nationality,
    s.first_season,
    s.last_season
from latest_player_record p
left join player_seasons s
    on p.player_id = s.player_id
where p.row_num = 1
