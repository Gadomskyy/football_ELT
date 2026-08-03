from __future__ import annotations

import pendulum

try:
    # Airflow 3
    from airflow.sdk import DAG
    from airflow.providers.standard.operators.bash import BashOperator
except ImportError:
    # Zgodność z Airflow 2
    from airflow import DAG
    from airflow.operators.bash import BashOperator

from airflow.providers.google.cloud.operators.bigquery import (
    BigQueryInsertJobOperator,
)


PROJECT_ID = "jga-sandbox"
LOCATION = "EU"


with DAG(
    dag_id="setup_smoke_test",
    description="Test połączenia Airflow z BigQuery i dbt",
    schedule=None,
    start_date=pendulum.datetime(2026, 1, 1, tz="UTC"),
    catchup=False,
    tags=["setup"],
) as dag:

    test_bigquery_connection = BigQueryInsertJobOperator(
        task_id="test_bigquery_connection",
        gcp_conn_id="google_cloud_default",
        project_id=PROJECT_ID,
        location=LOCATION,
        configuration={
            "query": {
                "query": """
                    SELECT
                        CURRENT_TIMESTAMP() AS checked_at,
                        'Airflow -> BigQuery działa' AS status
                """,
                "useLegacySql": False,
            }
        },
    )

    test_dbt_connection = BashOperator(
        task_id="test_dbt_connection",
        bash_command="""
            dbt debug \
              --project-dir /opt/airflow/dbt \
              --profiles-dir /opt/airflow/dbt_profiles
        """,
    )

    test_bigquery_connection >> test_dbt_connection