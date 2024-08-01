#!/bin/bash

# IAMロール名とポリシーARNの設定
IAM_ROLE_NAME="hands-on-iam-role"
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

echo "IAMロール '$IAM_ROLE_NAME' が作成されました。"
echo "IAMロールのARN: $IAM_ROLE_ARN"