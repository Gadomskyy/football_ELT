from __future__ import annotations
from datetime import datetime, timezone
from airflow.sdk import dag, task
from src.common.commons import DBT_PROJECT_DIR, DBT_PROFILES_DIR


@dag(
    dag_id="football_data_pl_silver",
    description="Builds and tests all dbt Silver models.",
    schedule=None,
    start_date=datetime(2026, 1, 1, tzinfo=timezone.utc),
    catchup=False,
    max_active_runs=1,
    tags=[
        "football-data",
        "premier-league",
        "dbt",
        "silver",
    ],
)
def football_data_pl_silver():

    @task.bash(task_id="install_dependencies")
    def install_dependencies() -> str:
        return f"""
        set -e

        dbt deps \
            --project-dir {DBT_PROJECT_DIR} \
            --profiles-dir {DBT_PROFILES_DIR}
        """

    @task.bash(task_id="build_silver")
    def build_silver() -> str:
        return f"""
        set -e

        dbt build \
            --project-dir {DBT_PROJECT_DIR} \
            --profiles-dir {DBT_PROFILES_DIR} \
            --select "path:models/silver" \
            --no-partial-parse
        """


    deps = install_dependencies()
    silver = build_silver()

    deps >> silver

dag = football_data_pl_silver()