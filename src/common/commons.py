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
