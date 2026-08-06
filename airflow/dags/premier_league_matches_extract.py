from __future__ import annotations
import os
from datetime import datetime, timezone
from airflow.sdk import dag, task
from src.common.api_to_bigquery import extract_flatten_and_load
from src.common.commons import GCP_PROJECT_ID, GCP_LOCATION

#VARIABLES
SEASONS = [2024, 2025, 2026]

API_URL = (
    "https://api.football-data.org/v4/competitions/PL/matches"
)

@dag(
    dag_id="football_data_pl_bronze",
    description=(
        """
        Loads Premier League matches from the football-data.org API into a BigQuery table in the bronze layer.
        Contains data for the seasons: 2024/2025, 2025/2026, and 2026/2027.       
        """
    ),
    schedule=None,
    start_date=datetime(2026,1,1,tzinfo=timezone.utc),
    catchup=False,
    max_active_runs=1,
    tags=[
        "football-data",
        "premier-league",
        "bronze"
    ],
)
def football_data_pl_bronze():

    @task(task_id="load_pl_matches_to_bronze")
    def load_matches(season: int) -> dict:
        api_key = os.getenv(
            "FOOTBALL_DATA_API_KEY"
        )

        if not api_key:
            raise RuntimeError(
                "No FOOTBALL_DATA_API_KEY."
            )

        season_end = str(season + 1)[-2:]

        table_name = (
            f"football_data_pl_matches_"
            f"{season}_{season_end}"
        )

        return extract_flatten_and_load(
            api_url=API_URL,
            records_key="matches",
            headers={
                "X-Auth-Token": api_key,
            },
            params={
                "season": season,
            },
            project_id=GCP_PROJECT_ID,
            dataset_id="bronze",
            table_name=table_name,
            location=GCP_LOCATION,
            write_disposition="WRITE_TRUNCATE",
        )

    
    load_matches.expand(season=SEASONS)


dag = football_data_pl_bronze()