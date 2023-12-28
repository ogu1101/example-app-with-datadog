# Datadog を使用したサンプルアプリケーション

## 概要

このリポジトリには、以下のコンテナが含まれています。

- アプリケーション（ Web サービス）
- Datadog Agent
- PostgreSQL
- Jenkins

## 前提

1. `.env` ファイルの `DD_API_KEY` に Datadog の API Key を設定してください。

2. `src/main/resources/application.properties` ファイルの `management.datadog.metrics.export.apiKey` に Datadog の API Key を設定してください。

## 有効化されている Datadog の機能

- ライブプロセス
- APM
- Continuous Profiler
- ログ管理（トレースと接続済み）
- ASM
- CI Visibility
- DBM（トレースと接続済み）

## ビルドと実行

### アプリケーションコンテナイメージのビルド

Dockerfile が存在するディレクトリで、以下のコマンドを実行してください。

```bash
docker build . \
    -t example-app-with-datadog-app \
    --build-arg DD_GIT_REPOSITORY_URL=github.com/ogu1101/example-app-with-datadog \
    --build-arg DD_GIT_COMMIT_SHA=$(git rev-parse HEAD)
```

### コンテナの起動

docker-compose.yml が存在するディレクトリで、以下のコマンドを実行してください。

```bash
docker-compose up -d
```

### HTTP リクエストの送信

アプリケーションコンテナに HTTP リクエストを送信するには、以下のコマンドを実行してください。

```bash
curl -v -X POST -H 'Content-Type:application/json' -d '{"message":"Hello", "target":"Kagetaka"}' 127.0.0.1:8080/greeting
```

## アプリケーションについて

- このリポジトリに含まれるアプリケーションは、Java で記述された Web サービスです。
- Web フレームワークとして、Spring Boot を使用しています。
- HTTP リクエストの内容を PostgreSQL に登録します。 
- ログは、Datadog でパースされるように、JSON 形式で出力するように設定しています。

## Jenkins について

### URL

http://localhost:8888

### 注意事項

- [Jenkins への Datadog プラグイン導入](https://docs.datadoghq.com/ja/continuous_integration/pipelines/jenkins/?tab=linux#datadog-jenkins-%E3%83%97%E3%83%A9%E3%82%B0%E3%82%A4%E3%83%B3%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)、Jenkins への Maven 導入、および Jenkins ジョブの作成は、手動で行う必要があります。