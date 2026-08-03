from __future__ import annotations
import os
from datetime import datetime, timezone
from airflow.sdk import dag, task
from src.common.api_to_bigquery import extract_flatten_and_load

#VARIABLES
SEASON = 2025
STATUS = 'FINISHED'

API_URL = (
    "https://api.football-data.org/v4/competitions/PL/matches"
)

GCP_PROJECT_ID = os.getenv(
    "GCP_PROJECT_ID",
    "jga-sandbox",
)

GCP_LOCATION = os.getenv(
    "GCP_LOCATION",
    "EU",
)


@dag(
    dag_id="football_data_pl_bronze",
    description=(
        "Premier League API -> pandas DataFrame -> BigQuery bronze"
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
    def load_matches() -> dict:
        api_key = os.getenv(
            "FOOTBALL_DATA_API_KEY"
        )

        if not api_key:
            raise RuntimeError(
                "No FOOTBALL_DATA_API_KEY."
            )

        return extract_flatten_and_load(
            api_url=API_URL,
            records_key="matches",
            headers={
                "X-Auth-Token": api_key,
            },
            params={
            "season": SEASON,
            "status": STATUS,
            },
            project_id=GCP_PROJECT_ID,
            dataset_id="bronze",
            table_name=f"football_data_pl_matches_bronze_{SEASON}",
            location=GCP_LOCATION,
            write_disposition="WRITE_TRUNCATE",
        )
    load_matches()


dag = football_data_pl_bronze()