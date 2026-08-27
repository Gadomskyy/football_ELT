import os

#COMMON VARIABLES

GCP_PROJECT_ID = os.getenv(
    "GCP_PROJECT_ID",
    "jga-sandbox",
)

GCP_LOCATION = os.getenv(
    "GCP_LOCATION",
    "europe-central2",
)

DBT_PROJECT_DIR = "/opt/airflow/dbt"
DBT_PROFILES_DIR = "/opt/airflow/dbt_profiles"