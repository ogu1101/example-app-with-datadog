#!/bin/bash

# 各種 Google Cloud API の有効化
gcloud services enable artifactregistry.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable sqladmin.googleapis.com

# Google Cloud リソースの作成
cd terraform || exit
terraform init
terraform apply

# アプリケーションコンテナイメージのビルドとプッシュ
cd ..
gcloud auth configure-docker us-central1-docker.pkg.dev
docker buildx build . \
    -t us-central1-docker.pkg.dev/tribal-iridium-308123/shuhei-repository/example-app-with-datadog-app:latest \
    --platform linux/amd64,linux/arm64 \
    --build-arg DD_GIT_REPOSITORY_URL=github.com/ogu1101/example-app-with-datadog \
    --build-arg DD_GIT_COMMIT_SHA="$(git rev-parse HEAD)"
docker push us-central1-docker.pkg.dev/tribal-iridium-308123/shuhei-repository/example-app-with-datadog-app:latest

# Kubernetes リソースのデプロイ
cd k8s || exit
gcloud container clusters get-credentials --zone us-central1 shuhei-gke
helm repo add datadog https://helm.datadoghq.com
helm install datadog-operator datadog/datadog-operator
# 以下コマンドの "${API-KEY}" を Datadog の API キーに、"${APP-KEY}" を Datadog の APP キーに置き換えてください。
kubectl create secret generic datadog-secret --from-literal api-key="${API-KEY}" --from-literal app-key="${APP-KEY}"
kubectl apply -f datadog-agent.yaml -f service-account.yaml
kubectl annotate serviceaccount \
  ksa-cloud-sql  \
  iam.gke.io/gcp-service-account=shuhei-service-account-id@tribal-iridium-308123.iam.gserviceaccount.com
kubectl apply -f manifests.yaml

# HTTP リクエストの送信
kubectl get service app
curl -v -X POST -H 'Content-Type:application/json' -d '{"message":"Hello", "target":"Kagetaka"}' 34.66.183.124:8080/greeting
