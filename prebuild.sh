#!/bin/bash
set -e
set -x

gcloud config set project $GOOGLE_CLOUD_PROJECT
./setup.sh deploy_files