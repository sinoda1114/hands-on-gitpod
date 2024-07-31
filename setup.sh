#!/bin/bash

# AWSアカウントIDを自動的に取得
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# IAMロール名とセッション名の設定
IAM_ROLE_NAME="hands-on-iam-role"
SESSION_NAME="gitpod-session"

# IAMロールの信頼ポリシードキュメント
TRUST_POLICY='{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "sts:AssumeRole"
        }
    ]
}'

# IAMロールの作成
aws iam create-role --role-name $IAM_ROLE_NAME --assume-role-policy-document "$TRUST_POLICY"

# 管理者権限を付与
ADMIN_POLICY_ARN="arn:aws:iam::aws:policy/AdministratorAccess"
aws iam attach-role-policy --role-name $IAM_ROLE_NAME --policy-arn $ADMIN_POLICY_ARN

# IAMロールが作成されるのを待つ
sleep 10

# 一時的な認証情報を取得
CREDENTIALS=$(aws sts assume-role --role-arn arn:aws:iam::$AWS_ACCOUNT_ID:role/$IAM_ROLE_NAME --role-session-name $SESSION_NAME --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' --output text)

# 環境変数に設定
export AWS_ACCESS_KEY_ID=$(echo $CREDENTIALS | cut -f1 -d ' ')
export AWS_SECRET_ACCESS_KEY=$(echo $CREDENTIALS | cut -f2 -d ' ')
export AWS_SESSION_TOKEN=$(echo $CREDENTIALS | cut -f3 -d ' ')

# 設定が成功したことを確認するためのメッセージ
echo "AWS認証情報を設定しました。"

# 確認のために任意のAWS CLIコマンドを実行
aws sts get-caller-identity
