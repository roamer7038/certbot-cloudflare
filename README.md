# Cloudflare DDNS with Let's Encrypt Wildcard Certificate

このドキュメントでは、Cloudflareを使用してDDNSを設定し、Let's Encryptのワイルドカード証明書を取得する手順を説明します。

## 1. Cloudflareの設定

### API_KEY, ZONE_ID, RECORD_IDの取得

1. Cloudflareにログインし、右上のアイコンをクリックして「Profile」を選択します。
2. 「API Tokens」タブをクリックし、「Create Token」ボタンをクリックします。
3. 必要な権限を設定し、APIトークンを生成します。
4. ダッシュボードの右下にある「Zone ID」をコピーして、`ZONE_ID`として保存します。
5. `curl`を使用して、ドメインのDNSレコードをリストアップし、`RECORD_ID`を取得します。

```
curl -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
	-H "Authorization: Bearer $API_KEY" \
	-H "Content-Type: application/json"
```

## 2. スクリプトの設定

### update-dns.sh

1. `update-dns.sh`スクリプトを作成し、CloudflareのAPIを使用してDNSレコードを更新するようにします。
2. `config.cfg`という名前の設定ファイルを作成し、`API_KEY`, `ZONE_ID`, および`RECORD_ID`を保存します。

### config.cfg

```ini
API_KEY=YOUR_CLOUDFLARE_API_KEY
ZONE_ID=YOUR_CLOUDFLARE_ZONE_ID
RECORD_ID=YOUR_CLOUDFLARE_DNS_RECORD_ID
DOMAIN=yourdomain.com
```

3. systemdの設定
サービスユニットの作成
/etc/systemd/system/update-dns.serviceという名前でサービスユニットファイルを作成します。
タイマーユニットの作成
/etc/systemd/system/update-dns.timerという名前でタイマーユニットファイルを作成します。
タイマーを有効にし、起動します。
4. Let's Encryptの証明書の取得
certbotとCloudflareのDNSプラグインをインストールします。

```
sudo apt-get install python3-certbot-dns-cloudflare
```

cloudflare.iniという名前の設定ファイルを作成し、APIキーを保存します。

```
# Cloudflare API credentials used by Certbot
# /etc/letsencrypt/cloudflare.ini
dns_cloudflare_email = your_email@example.com
dns_cloudflare_api_key = YOUR_CLOUDFLARE_GLOBAL_API_KEY
```

certbotを使用してワイルドカード証明書を取得します。

```
sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini -d "*.yourdomain.com"
```
