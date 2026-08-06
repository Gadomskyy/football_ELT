from __future__ import annotations
import os
from datetime import datetime, timezone
from airflow.sdk import dag, task
from src.common.api_to_bigquery import extract_flatten_and_load
from src.common.commons import GCP_PROJECT_ID, GCP_LOCATION

#VARIABLES

API_URL = ("https://api.football-data.org/v4/competitions/PL")

@dag(
    dag_id="football_data_pl_winners_bronze",
    description=(
        """
        Loads Premier League winners from the football-data.org API into a BigQuery table in the bronze layer.     
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
def football_data_pl_winners_bronze():

    @task(task_id = "load_pl_winners_to_bronze")
    def load_winners() -> dict:
        api_key = os.getenv("FOOTBALL_DATA_API_KEY")

        if not api_key:
            raise RuntimeError(
                "No FOOTBALL_DATA_API_KEY."
            )

        return extract_flatten_and_load(
            api_url = API_URL,
            records_key = "seasons",
            project_id = GCP_PROJECT_ID,
            dataset_id = "bronze",
            table_name = "football_data_pl_winners_bronze",
            headers = {
                "X-Auth-Token": api_key,
            },
            location = GCP_LOCATION,
            write_disposition = "WRITE_TRUNCATE"
        )

    load_winners()

dag = football_data_pl_winners_bronze()
