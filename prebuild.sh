#!/bin/bash
set -e
set -x

#echo "K_SERVICE: $K_SERVICE"
#echo "GOOGLE_CLOUD_REGION: $GOOGLE_CLOUD_REGION"
#echo "GOOGLE_CLOUD_PROJECT: $GOOGLE_CLOUD_PROJECT"
#echo "APP_DIR: $APP_DIR"

gcloud config set project $GOOGLE_CLOUD_PROJECT
PROJECT_ID=$GOOGLE_CLOUD_PROJECT
NAME=crb-test

if ! gsutil ls gs://$PROJECT_ID > /dev/null 2> /dev/null; then
  echo "Creating GCS bucket gs://$PROJECT_ID"
  gsutil mb -b on gs://$PROJECT_ID
fi

GCS_BASE_PATH=gs://$PROJECT_ID/$NAME

echo "Starting copying of application files to $GCS_BASE_PATH"
gsutil -m rsync -r -x ".*/__pycache__/.*|[.].*" ./app $GCS_BASE_PATH
echo "Application files have been copied"
gsutil -h "Content-Type:text/plain" cp ./*.yaml $GCS_BASE_PATH/
echo "All done"