#!/bin/bash

# 必須変数に値が設定されているか確認
if [ -z "$ACCESS_PROTOCOL" ]; then
echo "変数 ACCESS_PROTOCOL が指定されていないため起動を中断します"
exit 1
fi
if [ -z "$ACCESS_HOSTNAME" ]; then
echo "変数 ACCESS_HOSTNAME が指定されていないため起動を中断します"
exit 1
fi
if [ -z "$ACCESS_URL" ]; then
echo "変数 ACCESS_URL が指定されていないため起動を中断します"
exit 1
fi

if [ "$ACCESS_TOKEN_DISABLE" = "true" ]; then
  echo "ACCESS_TOKEN_DISABLE 変数が設定されています。ACCESS_TOKEN_IDに値が設定されていてもTOKEN認証を無視します"
else
  echo "ACCESS_TOKEN_DISABLE 変数は指定されていません"
fi

# TOKENが設定されている場合の起動

if [ ! "$ACCESS_TOKEN_DISABLE" = "true" ]; then
# ACCESS_TOKEN_DISABLEがtrueでない場合のみIDが指定されているかたしかめTOKENの値が指定されている場合TOKEN認証ありで起動する
    if [ -n "$ACCESS_TOKEN_ID" ]; then
        cloudflared access "${ACCESS_PROTOCOL}" --hostname "${ACCESS_HOSTNAME}" --url "${ACCESS_URL}" --id "${ACCESS_TOKEN_ID}" --secret "${ACCESS_TOKEN_SECRET}"
    fi
fi

# TOKENが指定されていて、ACCESS_TOKEN_DISABLE変数がtrueの場合TOKENによる認証をスルーして起動する
if [ "$ACCESS_TOKEN_DISABLE" = "true" ]; then
    if [ -n "$ACCESS_TOKEN_ID" ]; then
        cloudflared access "${ACCESS_PROTOCOL}" --hostname "${ACCESS_HOSTNAME}" --url "${ACCESS_URL}"
    fi
fi

# IDが指定されていない場合は起動変数にsecretを含まない
if [ ! -n "$ACCESS_TOKEN_ID" ]; then
    cloudflared access "${ACCESS_PROTOCOL}" --hostname "${ACCESS_HOSTNAME}" --url "${ACCESS_URL}"
fi