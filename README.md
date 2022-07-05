# cloudflared-access

cloudflared access をdockerで行うイメージです

# 起動方法

## 設定する変数

下記の変数を指定してください

### 必須の変数

- `ACCESS_PROTOCOL`
    - プロトコルを指定します(例: rdp , tcp)
- `ACCESS_HOSTNAME`
    - アクセスするホスト名を指定します (例: api.example.com)
- `ACCESS_URL`
    - 公開するポートを指定します (例: 127.0.0.1:7000 , 0.0.0.0:90000)

### 必須ではない変数

- `ACCESS_TOKEN_ID`
    - [Service Token](https://developers.cloudflare.com/cloudflare-one/identity/service-tokens/) による認証が必要な場合Client IDを指定してください
    - Service Tokenによる認証が一時的に無効化されている場合などは `ACCESS_TOKEN_DISABLE` 変数の値に `true` を設定してください
- `ACCESS_SECRET_ID`
    - [Service Token](https://developers.cloudflare.com/cloudflare-one/identity/service-tokens/) による認証が必要な場合Client secretを指定してください
    - Service Tokenによる認証が一時的に無効化されている場合などは `ACCESS_TOKEN_DISABLE` 変数の値に `true` を設定してください
- `ACCESS_TOKEN_DISABLE`
    - デフォルトでは、 `ACCESS_TOKEN_ID` の値が設定されている場合、access起動フラグにTOKENを指定します。
    - 一時的に無効化されている場合などaccessフラグにTOKENを含まない場合この変数の値に `true`を設定してください
    - `true` 以外の値を設定しても無効化されません

## 使用するイメージ

amd環境の場合: `ghcr.io/namagominetwork/cloudflared-access-amd64:<VERSION>`
arm環境の場合: `ghcr.io/namagominetwork/cloudflared-access-arm64:<VERSION>`

### バージョンについて

本イメージのバージョン形式は `<リリース年>.<リリース月>.<リリース月のリリースバージョン>-cloudflared.cloudflared<リリース年>.<リリース月>.<リリース月のリリースバージョン>` となっております

> 例: 2022.7.0-cloudflared22.7.0

最新バージョンは次のページで確認してください:  [amd](https://github.com/NamagomiNetwork/cloudflared-access/pkgs/container/cloudflared-access-amd64) [arm](https://github.com/NamagomiNetwork/cloudflared-access/pkgs/container/cloudflared-access-arm64)
## docker-compose

### TOKEN認証あり

docker-compose.yaml

```yaml
services:
  cloudflared-access:
    image: ghcr.io/namagominetwork/cloudflared-access-amd64:2022.7.0-cloudflared22.7.0
    tty: true
    stdin_open: true
    network_mode: host
    # 自動起動を行う場合下記の行のコメントアウトを削除してください
    #restart: always
    environment:
      - ACCESS_PROTOCOL=tcp
      - ACCESS_HOSTNAME=tcp-app.example.com
      - ACCESS_URL=127.0.0.1:8800
      # TOKEN認証を無効化する場合下記の値を true に設定してください
      - ACCESS_TOKEN_DISABLE=false
      - ACCESS_TOKEN_ID=your cloudflare Service token client_ID
      - ACCESS_TOKEN_SECRET=your cloudflare Service token client_secret
```

### TOKEN認証なし

docker-compose.yaml

```yaml
services:
  cloudflared-access:
    image: ghcr.io/namagominetwork/cloudflared-access-amd64:2022.7.0-cloudflared22.7.0
    stdin_open: true
    network_mode: host
    # 自動起動を行う場合下記の行のコメントアウトを削除してください
    #restart: always
    environment:
      - ACCESS_PROTOCOL=tcp
      - ACCESS_HOSTNAME=tcp-app.example.com
      - ACCESS_URL=127.0.0.1:8800
```

## k8s( Kubernetes )

### TOKEN認証あり

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/name: cloudflared-access
  name: cloudflared-access
  namespace: cloudflared-access
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: cloudflared-access
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app.kubernetes.io/name: cloudflared-access
    spec:
      containers:
        - env:
            - name: ACCESS_PROTOCOL
              value: tcp
            - name: ACCESS_HOSTNAME
              value: tcp-app.example.com
            - name: ACCESS_URL
              value: 127.0.0.1:8800
              # TOKEN認証を無効化する場合下記の値を true に設定してください
            - name: ACCESS_TOKEN_DISABLE
              value: false
            - name: ACCESS_TOKEN_ID
              value: your cloudflare Service token client_ID
              # シークレットの管理は各自で行ってください(シークレットリソースを利用するなど)
            - name: ACCESS_TOKEN_SECRET
              value: your cloudflare Service token client_secret
        image: ghcr.io/namagominetwork/cloudflared-access-amd64:2022.7.0-cloudflared22.7.0
        name: cloudflared-access
        resources: 
            limits:
              memory: "250Mi"
              cpu: "500m"
        ports:
        - containerPort: 8800
status: {}
```

### TOKEN認証なし

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/name: cloudflared-access
  name: cloudflared-access
  namespace: cloudflared-access
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: cloudflared-access
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app.kubernetes.io/name: cloudflared-access
    spec:
      containers:
        - env:
            - name: ACCESS_PROTOCOL
              value: tcp
            - name: ACCESS_HOSTNAME
              value: tcp-app.example.com
            - name: ACCESS_URL
              value: 127.0.0.1:8800
        image: ghcr.io/namagominetwork/cloudflared-access-amd64:2022.7.0-cloudflared22.7.0
        name: cloudflared-access
        resources: 
            limits:
              memory: "250Mi"
              cpu: "500m"
        ports:
        - containerPort: 8800
status: {}
```

### Service

pod内にアクセスするために、NodeportやLoadBalancerを利用してアクセスできるようにしてください。

ここではLoadBalancerのyamlをサンプルとしておいておきます

```yaml
apiVersion: v1
kind: Service
metadata:
  name: cloudflared-access-lb
  namespace: cloudflared-access
spec:
  selector:
    app.kubernetes.io/name: cloudflared-access
  ports:
    - port: 8800
      protocol: TCP
      targetPort: 8800
  type: LoadBalancer
```