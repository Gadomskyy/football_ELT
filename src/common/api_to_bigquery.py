from __future__ import annotations
import json
from typing import Any
import pandas as pd
import requests
from google.cloud import bigquery


def extract_flatten_and_load(
    *,
    api_url: str,
    records_key: str,
    project_id: str,
    dataset_id: str,
    table_name: str,
    headers: dict[str, str] | None = None,
    params: dict[str, Any] | None = None,
    location: str = "europe-central2",
    timeout_seconds: int = 60,
    write_disposition: str = "WRITE_TRUNCATE",
    allow_empty: bool = False
) -> dict[str, Any]:
    """
    Fetches JSON from the API, flattens the specified list of records
    into a pandas DataFrame, and loads it into a BigQuery table.

    The function does not perform business transformations.
    It preserves column names based on the JSON structure.

    Parameters
    ----------
    api_url:
        Full URL of the API endpoint.

    records_key:
        Name of the field in the JSON response that contains the list of records,
        e.g. "matches" or "teams".

    project_id:
        GCP project ID.

    dataset_id:
        BigQuery dataset, e.g. "bronze".

    table_name:
        BigQuery table name.

    headers:
        Optional HTTP headers, e.g. API token.

    params:
        Optional HTTP query parameters.

    location:
        BigQuery location, e.g. "EU".

    write_disposition:
        WRITE_TRUNCATE – replaces the table,
        WRITE_APPEND – appends data,
        WRITE_EMPTY – works only for an empty table.
    """

    response = requests.get(
        api_url,
        headers=headers,
        params=params,
        timeout=timeout_seconds,
    )

    response.raise_for_status()

    payload = response.json()

    records = payload.get(records_key)

    table_id = (
        f"{project_id}."
        f"{dataset_id}."
        f"{table_name}"
    )

    if not isinstance(records, list):
        raise ValueError(
            f"Field '{records_key}' does not exist "
            "or does not contain a list of records."
        )

    if not records:
        if allow_empty:
            result = {
                "table_id": table_id,
                "source_records": 0,
                "loaded_rows": 0,
                "status": "empty_source_accepted",
            }

            print(
                f"API returned an empty '{records_key}' list. "
                f"No data was loaded into {table_id}."
            )

            return result

        raise ValueError(
            f"Field '{records_key}' contains an empty list."
        )
    
    dataframe = pd.json_normalize(
        records,
        sep="_",
    )

    for column in dataframe.columns:
        contains_nested_values = dataframe[column].apply(
            lambda value: isinstance(value, (list, dict))
        ).any()

        if contains_nested_values:
            dataframe[column] = dataframe[column].apply(
                _serialize_nested_value
            )

    client = bigquery.Client(
        project=project_id,
        location=location,
    )

    job_config = bigquery.LoadJobConfig(
        write_disposition=write_disposition,
    )

    load_job = client.load_table_from_dataframe(
        dataframe=dataframe,
        destination=table_id,
        job_config=job_config,
        location=location,
    )

    load_job.result()

    loaded_table = client.get_table(table_id)

    result = {
        "table_id": table_id,
        "loaded_rows": loaded_table.num_rows,
        "loaded_columns": len(loaded_table.schema),
        "source_records": len(records),
    }

    print(f"Loaded table: {result}")

    return result


def _serialize_nested_value(value: Any) -> Any:
    """
    Converts a list or dictionary to JSON text.
    Returns other values unchanged.
    """
    if isinstance(value, (list, dict)):
        return json.dumps(
            value,
            ensure_ascii=False,
        )

    return value