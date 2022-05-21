CF_TOKEN_ID=${CF_TOKEN_ID}
CF_TOKEN_SECRET=${CF_TOKEN_SECRET}

screen -UAmdS debug cloudflared access tcp --hostname hoge.example.com --url localhost:30000 --id ${CF_TOKEN_ID} --secret ${CF_TOKEN_SECRET}
screen -r debug