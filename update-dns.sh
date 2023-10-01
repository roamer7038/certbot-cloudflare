#!/bin/bash

# Cloudflareの設定
source config.cfg

# 現在のグローバルIPアドレスを取得
CURRENT_IP=$(curl -s http://inet-ip.info)

# Cloudflareから現在のDNSレコードのIPアドレスを取得
CF_IP=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
	-H "Authorization: Bearer $API_KEY" \
	-H "Content-Type: application/json" | jq -r '.result.content')

# IPアドレスが変更された場合、DNSレコードを更新
if [ "$CURRENT_IP" != "$CF_IP" ]; then
	curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
		-H "Authorization: Bearer $API_KEY" \
		-H "Content-Type: application/json" \
		--data '{"type":"A","name":"'$DOMAIN'","content":"'$CURRENT_IP'","ttl":120,"proxied":false}' > /dev/null
fi
