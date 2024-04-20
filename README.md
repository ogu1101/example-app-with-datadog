# Datadog を使用したサンプルアプリケーション

## 概要

このリポジトリには、Java アプリケーション（ Web サービス）のソースコードが含まれています。

そのアプリケーションを Docker Compose または Google Kubernetes Engine（ GKE ）を使用して実行するためのソースコードも含まれています。

また、アプリケーション以外に以下のコンテナおよびサービスも実行されます。

- Datadog Agent コンテナ
- PostgreSQL コンテナ（ Docker Compose の場合のみ）
- Jenkins コンテナ（ Docker Compose の場合のみ）
- Cloud SQL for PostgreSQL（ GKE の場合のみ）

## アプリケーションについて

- Web フレームワークとして、Spring Boot を使用しています。
- HTTP リクエストの内容を PostgreSQL に登録します。
- ログは、Datadog でパースされるように JSON 形式で出力するように設定しています。
- `mvn test` コマンドを実行することで、単体テストを実行できます。

## 有効化されている Datadog 機能

CI Visibility 以外は、手動作業なしに以下の Datadog 機能が有効化されます。

CI Visibility を有効化するには、手動で [Jenkins への Datadog プラグイン導入](https://docs.datadoghq.com/ja/continuous_integration/pipelines/jenkins/?tab=linux#datadog-jenkins-%E3%83%97%E3%83%A9%E3%82%B0%E3%82%A4%E3%83%B3%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)および Jenkins ジョブの作成を行う必要があります。

- Live Processes
- Application Performance Monitoring
- Continuous Profiler
- Log Management（トレースと接続済み）
- Application Security Management
- CI Visibility（ Docker Compose の場合のみ）
- Database Monitoring（トレースと接続済み、Docker Compose の場合のみ）
- Network Performance Monitoring（ GKE の場合のみ）
- Universal Service Monitoring（ GKE の場合のみ）

## ビルドと実行（ Docker Compose を使用する場合）

### 前提条件

- Docker をインストールしてください。インストール方法については、こちらの[ドキュメント](https://docs.docker.com/engine/install/)を参照してください。
- このリポジトリの Datadog Agent コンテナは、Docker Compose を使用する場合、Mac OS でのみ実行可能です。

### 事前作業

`.env` ファイルの `DD_API_KEY` に Datadog の API キーを設定してください。

### アプリケーションコンテナイメージのビルド

Dockerfile が存在するディレクトリで以下のコマンドを実行してください。

```bash
docker build . \
    -t example-app-with-datadog-app \
    --build-arg DD_GIT_REPOSITORY_URL=github.com/ogu1101/example-app-with-datadog \
    --build-arg DD_GIT_COMMIT_SHA=$(git rev-parse HEAD)
```

### コンテナの起動

compose.yaml が存在するディレクトリで以下のコマンドを実行してください。

```bash
docker-compose up -d
```

### HTTP リクエストの送信

アプリケーションコンテナに HTTP リクエストを送信するには、以下のコマンドを実行してください。

```bash
curl -v -X POST -H 'Content-Type:application/json' -d '{"message":"Hello", "target":"Kagetaka"}' 127.0.0.1:8080/greeting
```

### Jenkins の URL

http://localhost:8888

### コンテナの停止

compose.yaml が存在するディレクトリで以下のコマンドを実行してください。

```bash
docker-compose down
```

## ビルドと実行（ GKE を使用する場合）

### 前提条件

- こちらの[ドキュメント](https://docs.docker.com/engine/install/)を参考に Docker をインストールしてください。
- マルチプラットフォームコンテナイメージを作成するために、こちらの[ドキュメント](https://docs.docker.com/desktop/containerd/#turn-on-the-containerd-image-store-feature)を参考に Docker Desktop の `Use containerd for pulling and storing images` を有効化してください。
- こちらの[ドキュメント](https://helm.sh/ja/)を参考に `Helm` をインストールしてください。
- その他の前提条件については、こちらの[ドキュメント](https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke?utm_medium=WEB_IO&in=terraform%2Fkubernetes&utm_content=DOCS&utm_source=WEBSITE&utm_offer=ARTICLE_PAGE#prerequisites)を参照してください。
- こちらの[ドキュメント](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)を参考に `Terraform` をインストールしてください。

### 事前作業

`.env` ファイルの `DD_API_KEY` に Datadog の API キーを設定してください。

### `terraform.tfvars` の変更

`terraform/terraform.tfvars` ファイルを以下のとおりに変更してください。

- `project_id` に Google Could のプロジェクト ID を設定してください。
- Google Cloud リソース名の重複を避けるために、`env` に任意の値を設定してください。
- こちらの[サイト](https://www.cman.jp/network/support/go_access.cgi)でグローバル IP アドレスを確認し、`your_global_ip_address` にグローバル IP アドレスを設定してください。

### Google Cloud リソースの作成

`terraform` ディレクトリで以下のコマンドを実行してください。

```bash
terraform init
terraform apply
```

`terraform apply` コマンド実行時に、以下のような値が出力されます。

```bash
artifact_registry_repository_name = "shuhei-repository"
cloud_sql_instance_name = "shuhei-cloud-sql"
global_ip_address_name = "shuhei-ip-address"
kubernetes_cluster_name = "shuhei-gke"
project_id = "datadog-sandbox"
region = "us-central1"
service_account_id = "shuhei-service-account-id"
```

### アプリケーションコンテナイメージのビルドとプッシュ

`terraform apply` コマンドの実行結果をもとに以下のコマンドを変更してください。

Dockerfile が存在するディレクトリで以下のコマンドを実行してください。

```bash
docker buildx build . \
    -t ${region}-docker.pkg.dev/${project_id}/${artifact_registry_repository_name}/example-app-with-datadog-app:latest \
    --platform linux/amd64,linux/arm64 \
    --build-arg DD_GIT_REPOSITORY_URL=github.com/ogu1101/example-app-with-datadog \
    --build-arg DD_GIT_COMMIT_SHA=$(git rev-parse HEAD)

docker push ${region}-docker.pkg.dev/${project_id}/${artifact_registry_repository_name}/example-app-with-datadog-app:latest
```

コマンドの例は、以下のとおりです。

```bash
docker buildx build . \
    -t us-central1-docker.pkg.dev/datadog-sandbox/shuhei-repository/example-app-with-datadog-app:latest \
    --platform linux/amd64,linux/arm64 \
    --build-arg DD_GIT_REPOSITORY_URL=github.com/ogu1101/example-app-with-datadog \
    --build-arg DD_GIT_COMMIT_SHA=$(git rev-parse HEAD)

docker push us-central1-docker.pkg.dev/datadog-sandbox/shuhei-repository/example-app-with-datadog-app:latest
```

### `manifests.yaml` の変更

`terraform apply` コマンドの実行結果をもとに `k8s/manifests.yaml` ファイルを以下のとおりに変更してください。

変更箇所には、`# REPLACE ME` というコメントが記載されています。

#### `Deployment` リソース

- `spec.template.spec.containers.name=app` の `image`
  に `${region}-docker.pkg.dev/${project_id}/${artifact_registry_repository_name}/example-app-with-datadog-app:latest`
  を設定してください。
- `spec.template.spec.containers.name=cloud-sql-proxy` の `args[2]`
  に `${project_id}:${region}:${cloud_sql_instance_name}` を設定してください。

#### `Ingress` リソース

- `metadata.annotations.kubernetes.io/ingress.global-static-ip-name` に `${global_ip_address_name}` を設定してください。

### Kubernetes リソースのデプロイ

`terraform apply` コマンドの実行結果をもとに以下のコマンドを変更してください。

また、`api-key` には、Datadog の API キーを、`app-key` には、Datadog の APP キーを設定してください。

`k8s` ディレクトリで以下のコマンドを実行してください。

```bash
gcloud container clusters get-credentials --zone ${region} ${kubernetes_cluster_name}

helm repo add datadog https://helm.datadoghq.com

helm install datadog-operator datadog/datadog-operator

kubectl create secret generic datadog-secret --from-literal api-key=XXXXX --from-literal app-key=XXXXX

kubectl apply -f datadog-agent.yaml -f service-account.yaml

kubectl annotate serviceaccount \
  ksa-cloud-sql  \
  iam.gke.io/gcp-service-account=${service_account_id}@${project_id}.iam.gserviceaccount.com

kubectl apply -f manifests.yaml
```

`gcloud container clusters get-credentials` コマンドの例は、以下のとおりです。

```bash
gcloud container clusters get-credentials --zone us-central1 shuhei-gke
```

`kubectl annotate serviceaccount` コマンドの例は、以下のとおりです。

```bash
kubectl annotate serviceaccount \
  ksa-cloud-sql  \
  iam.gke.io/gcp-service-account=shuhei-service-account-id@datadog-sandbox.iam.gserviceaccount.com
```

### HTTP リクエストの送信

リクエスト送信先のグローバル IP アドレスを確認するために、`kubectl get service app` コマンドを実行してください。

実行結果の例は、以下のとおりです。

```bash
shuhei.ogura@COMP-R7QQCTJ177 k8s % kubectl get service app
NAME   TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)          AGE
app    LoadBalancer   10.187.247.149   35.238.101.70   8080:31303/TCP   38h
```

以下コマンドの ${EXTERNAL-IP} を上記の `EXTERNAL-IP` に置換したうえで、以下コマンドを実行してください。

```bash
curl -v -X POST -H 'Content-Type:application/json' -d '{"message":"Hello", "target":"Kagetaka"}' ${EXTERNAL-IP}:8080/greeting
```

コマンドの例は、以下のとおりです。

```bash
curl -v -X POST -H 'Content-Type:application/json' -d '{"message":"Hello", "target":"Kagetaka"}' 35.238.101.70:8080/greeting
```

### Kubernetes リソースの削除

`k8s` ディレクトリで以下のコマンドを実行してください。

```bash
kubectl delete -f manifests.yaml -f service-account.yaml -f datadog-agent.yaml
```

### Google Cloud リソースの削除

`terraform` ディレクトリで以下のコマンドを実行してください。

```bash
terraform destroy
```

## References

- [Spring Initializr](https://start.spring.io/)
- [Provision a GKE cluster (Google Cloud)](https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke)
- [Google Kubernetes Engine から Cloud SQL に接続する](https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine?hl=ja)
- [基本的な本番環境クラスタ用にネットワークを構成する](https://cloud.google.com/kubernetes-engine/docs/tutorials/configure-networking?hl=ja)
- [Google Cloud リソース別の Terraform 公式ページ](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
