#!/bin/bash

# 日付を取得してフォーマット
DATE=$(date +%Y%m%d)

# IAMロール名とポリシーARNの設定
IAM_ROLE_NAME="hands-on-iam-role-$DATE"
ADMIN_POLICY_ARN="arn:aws:iam::aws:policy/AdministratorAccess"

# IAMロールの信頼ポリシードキュメント
TRUST_POLICY=$(cat <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
)

# IAMロールの作成
aws iam create-role --role-name $IAM_ROLE_NAME --assume-role-policy-document "$TRUST_POLICY"

# 管理者権限を付与
aws iam attach-role-policy --role-name $IAM_ROLE_NAME --policy-arn $ADMIN_POLICY_ARN

# IAMロールが作成されるのを待つ
sleep 10

# IAMロールのARNを取得
IAM_ROLE_ARN=$(aws iam get-role --role-name $IAM_ROLE_NAME --query 'Role.Arn' --output text)

echo -e "IAMロール '\033[1m$IAM_ROLE_NAME\033[0m' が作成されました。"
echo -e "\033[1m以下をメモ帳にコピーしてください\033[0m"
echo "$IAM_ROLE_ARN"
