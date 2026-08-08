from __future__ import annotations
import os
from datetime import datetime, timezone
from airflow.sdk import dag, task
from src.common.api_to_bigquery import extract_flatten_and_load
from src.common.commons import GCP_PROJECT_ID, GCP_LOCATION

#VARIABLES
SEASONS = [2024, 2025, 2026]
LIMIT = 100

API_URL = (
    "https://api.football-data.org/v4/competitions/PL/scorers"
)

@dag(
    dag_id="football_data_pl_top_scorers_bronze",
    description=(
        """
        Loads Premier League top-scorers from the football-data.org API into a BigQuery table in the bronze layer.       
        """
    ),
    schedule="@daily",
    start_date=datetime(2026,1,1,tzinfo=timezone.utc),
    catchup=False,
    max_active_runs=1,
    tags=[
        "football-data",
        "premier-league",
        "bronze"
    ],
)
def football_data_pl_top_scorers_bronze():

    @task(task_id="load_pl_top_scorers_to_bronze")
    def load_top_scorers(season: int) -> dict:
        api_key = os.getenv(
            "FOOTBALL_DATA_API_KEY"
        )

        if not api_key:
            raise RuntimeError(
                "No FOOTBALL_DATA_API_KEY."
            )

        season_end = str(season + 1)[-2:]

        table_name = (
            f"football_data_pl_top_scorers_"
            f"{season}_{season_end}"
        )

        return extract_flatten_and_load(
            api_url=API_URL,
            records_key="scorers",
            headers={
                "X-Auth-Token": api_key,
            },
            params={
                "season": season,
                "limit" : LIMIT
            },
            project_id=GCP_PROJECT_ID,
            dataset_id="bronze",
            table_name=table_name,
            location=GCP_LOCATION,
            write_disposition="WRITE_TRUNCATE",
            allow_empty=(season == max(SEASONS)), #allows for empty list for the last season - as it can be the future one
            empty_schema_template_table=(
                "football_data_pl_top_scorers_2025_26" #creates an empty table with a schema as in the specified table
                if season == max(SEASONS)
                else None),
        )

    
    load_top_scorers.expand(season=SEASONS)


dag = football_data_pl_top_scorers_bronze()