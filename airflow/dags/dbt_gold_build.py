from __future__ import annotations
from datetime import datetime, timezone
from airflow.sdk import dag, task
from src.common.commons import DBT_PROJECT_DIR, DBT_PROFILES_DIR


@dag(
    dag_id="football_data_pl_gold",
    description="Builds and tests all dbt Gold models.",
    schedule=None,
    start_date=datetime(2026, 1, 1, tzinfo=timezone.utc),
    catchup=False,
    max_active_runs=1,
    tags=[
        "football-data",
        "premier-league",
        "dbt",
        "gold",
    ],
)
def football_data_pl_gold():

    @task.bash(task_id="build_dims")
    def build_dims() -> str:
        return f"""
        set -e

        dbt build \
            --project-dir {DBT_PROJECT_DIR} \
            --profiles-dir {DBT_PROFILES_DIR} \
            --select "path:models/gold/core/dims" \
            --no-partial-parse
        """

    @task.bash(task_id="build_facts")
    def build_facts() -> str:
        return f"""
        set -e

        dbt build \
            --project-dir {DBT_PROJECT_DIR} \
            --profiles-dir {DBT_PROFILES_DIR} \
            --select "path:models/gold/core/facts" \
            --no-partial-parse
        """

    @task.bash(task_id="build_reporting")
    def build_reporting() -> str:
        return f"""
        set -e

        dbt build \
            --project-dir {DBT_PROJECT_DIR} \
            --profiles-dir {DBT_PROFILES_DIR} \
            --select "path:models/gold/reporting" \
            --no-partial-parse
        """


    dims = build_dims()
    facts = build_facts()
    reporting = build_reporting()

    dims >> facts >> reporting
    
dag = football_data_pl_gold()