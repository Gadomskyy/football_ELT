ARG AIRFLOW_BASE_IMAGE
FROM ${AIRFLOW_BASE_IMAGE}

ARG AIRFLOW_VERSION

COPY requirements.txt /requirements.txt

RUN pip install --no-cache-dir \
    "apache-airflow==${AIRFLOW_VERSION}" \
    -r /requirements.txt

USER root

RUN mkdir -p \
    /opt/airflow/dbt_profiles \
    /opt/airflow/gcp \
    /opt/airflow/src \
    /opt/airflow/data \
    && chown -R airflow:0 \
    /opt/airflow/dbt_profiles \
    /opt/airflow/gcp \
    /opt/airflow/src \
    /opt/airflow/data

USER airflow