with pl_matches_24_25 as (
    select
        {{ generate_season_code("season_startDate", "season_endDate") }} as season,
        id as match_id,
        date(timestamp(utcdate)) as match_date,
        utcdate as match_date_utc,
        status as match_status,
        matchday,
        json_extract_scalar(referees, '$[0].name') as referee,
        competition_id,
        competition_name,
        competition_code,
        season_id,
        hometeam_id as home_team_id,
        awayteam_id as away_team_id,
        score_winner,
        score_fulltime_home as score_full_time_home,
        score_fulltime_away as score_full_time_away,
        concat(score_fulltime_home, ":", score_fulltime_away) as score_full_time,
        score_halftime_home as score_half_time_home,
        score_halftime_away as score_half_time_away,
        concat(score_halftime_home, ":", score_halftime_away) as score_half_time
    from {{ source('pl_data', 'football_data_pl_matches_2024_25') }}
),

pl_matches_25_26 as (
    select
        {{ generate_season_code("season_startDate", "season_endDate") }} as season,
        id as match_id,
        date(timestamp(utcdate)) as match_date,
        utcdate as match_date_utc,
        status as match_status,
        matchday,
        json_extract_scalar(referees, '$[0].name') as referee,
        competition_id,
        competition_name,
        competition_code,
        season_id,
        hometeam_id as home_team_id,
        awayteam_id as away_team_id,
        score_winner,
        score_fulltime_home as score_full_time_home,
        score_fulltime_away as score_full_time_away,
        concat(score_fulltime_home, ":", score_fulltime_away) as score_full_time,
        score_halftime_home as score_half_time_home,
        score_halftime_away as score_half_time_away,
        concat(score_halftime_home, ":", score_halftime_away) as score_half_time
    from {{ source('pl_data', 'football_data_pl_matches_2025_26') }}
),

pl_matches_26_27 as (
    select
        {{ generate_season_code("season_startDate", "season_endDate") }} as season,
        id as match_id,
        date(timestamp(utcdate)) as match_date,
        utcdate as match_date_utc,
        status as match_status,
        matchday,
        json_extract_scalar(referees, '$[0].name') as referee,
        competition_id,
        competition_name,
        competition_code,
        season_id,
        hometeam_id as home_team_id,
        awayteam_id as away_team_id,
        score_winner,
        cast(score_fulltime_home as int) as score_full_time_home,
        cast(score_fulltime_away as int) as score_full_time_away,
        concat(score_fulltime_home, ":", score_fulltime_away) as score_full_time,
        cast(score_halftime_home as int) as score_half_time_home,
        cast(score_halftime_away as int) as score_half_time_away,
        concat(score_halftime_home, ":", score_halftime_away) as score_half_time
    from {{ source('pl_data', 'football_data_pl_matches_2026_27') }}
)

select * from pl_matches_24_25

union all

select * from pl_matches_25_26

union all

select * from pl_matches_26_27
