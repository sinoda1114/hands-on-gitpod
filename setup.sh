#!/bin/bash

# IAMロールARNを入力
echo "Enter the IAM Role ARN (e.g., arn:aws:iam::<AWS_ACCOUNT_ID>:role/hands-on-iam-role):"
read IAM_ROLE_ARN
SESSION_NAME="gitpod-session"
DURATION_SECONDS=43200  # 12時間（最大値）

# 一時的な認証情報を取得
CREDENTIALS=$(aws sts assume-role --role-arn $IAM_ROLE_ARN --role-session-name $SESSION_NAME --duration-seconds $DURATION_SECONDS --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' --output text)

# 環境変数に設定
export AWS_ACCESS_KEY_ID=$(echo $CREDENTIALS | cut -f1 -d ' ')
export AWS_SECRET_ACCESS_KEY=$(echo $CREDENTIALS | cut -f2 -d ' ')
export AWS_SESSION_TOKEN=$(echo $CREDENTIALS | cut -f3 -d ' ')

# 設定が成功したことを確認するためのメッセージ
echo "AWS認証情報を設定しました。"

# 確認のために任意のAWS CLIコマンドを実行
aws sts get-caller-identity
