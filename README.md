# Datadog を使用したサンプルアプリケーション

## 概要

このリポジトリには、以下のコンテナが含まれています。

- アプリケーション（ Web サービス）
- Datadog Agent
- PostgreSQL
- Jenkins

## アプリケーションについて

- このリポジトリに含まれるアプリケーションは、Java で記述された Web サービスです。
- Web フレームワークとして、Spring Boot を使用しています。
- HTTP リクエストの内容を PostgreSQL に登録します。
- ログは、Datadog でパースされるように JSON 形式で出力するように設定しています。
- Jenkins ジョブから `mvn test` コマンドを実行することにより、単体テストを実行できます。
- DB 接続設定の都合により、ローカルホストで単体テストを実行できません。

## 有効化されている Datadog 機能

CI Visibility 以外は、手動作業なしに以下の Datadog 機能が有効化されます。

CI Visibility
を有効化するには、手動で [Jenkins への Datadog プラグイン導入](https://docs.datadoghq.com/ja/continuous_integration/pipelines/jenkins/?tab=linux#datadog-jenkins-%E3%83%97%E3%83%A9%E3%82%B0%E3%82%A4%E3%83%B3%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)
、および Jenkins ジョブの作成を行う必要があります。

- ライブプロセス
- APM
- Continuous Profiler
- ログ管理（トレースと接続済み）
- ASM
- CI Visibility
- DBM（トレースと接続済み）

## ビルドと実行

### 事前作業

1. `.env` ファイルの `DD_API_KEY` に Datadog の API キーを設定してください。

2. `src/main/resources/application.properties` ファイルの `management.datadog.metrics.export.apiKey` に Datadog の API
   キーを設定してください。

### アプリケーションコンテナイメージのビルド

Dockerfile が存在するディレクトリで以下のコマンドを実行してください。

```bash
docker build . \
    -t example-app-with-datadog-app \
    --build-arg DD_GIT_REPOSITORY_URL=github.com/ogu1101/example-app-with-datadog \
    --build-arg DD_GIT_COMMIT_SHA=$(git rev-parse HEAD)
```

### コンテナの起動

docker-compose.yml が存在するディレクトリで以下のコマンドを実行してください。

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
