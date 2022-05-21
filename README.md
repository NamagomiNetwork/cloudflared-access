# cloudflared-auto-access

cloudflare TCP tunnelのアクセスコマンドをコンテナで実行するイメージ

## 使い方
docker-compose.ymlとaccess-command.shをサーバーに配置します<br>
docker-composeおよびaccess-command.shは適宜書き換えてください

## `access-command.sh` のsample

```
CF_TOKEN_ID=${CF_TOKEN_ID}
CF_TOKEN_SECRET=${CF_TOKEN_SECRET}

screen -UAmdS debug cloudflared access tcp --hostname hoge.example.com --url localhost:30000 --id ${CF_TOKEN_ID} --secret ${CF_TOKEN_SECRET}
screen -r debug
```

## 注意点

- access-command.shの最後にいずれかのscreenにAttachするようにしてください。(docker側に終了判定されるため)