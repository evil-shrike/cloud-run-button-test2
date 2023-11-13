set -e
#set -x

PROJECT_ID=$(gcloud config get-value project 2> /dev/null)
NAME=crb-test

deploy_files() {
  if ! gsutil ls gs://$PROJECT_ID > /dev/null 2> /dev/null; then
    echo "Creating GCS bucket gs://$PROJECT_ID"
    gsutil mb -b on gs://$PROJECT_ID
  fi

  GCS_BASE_PATH=gs://$PROJECT_ID/$NAME

  echo "Starting copying of application files to $GCS_BASE_PATH"
  gsutil -m rsync -r -x ".*/__pycache__/.*|[.].*" ./app $GCS_BASE_PATH
  echo "Application files have been copied"
  gsutil -m -h "Content-Type:text/plain" cp ./*.yaml $GCS_BASE_PATH/
  echo "All done"
}

"$1"