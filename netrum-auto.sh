#!/bin/bash

# Load .env
set -a
source .env
set +a

send_telegram() {
  local message="$1"
  curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
    -d chat_id="$CHAT_ID" \
    -d text="$message" \
    -d parse_mode="Markdown"
}

while true; do
  start_time=$(date '+%Y-%m-%d %H:%M:%S')
  NPT_BALANCE=$(node get-npt-balance.js 2>/dev/null)

  send_telegram "🚀 *Mining Netrum dimulai...* ⛏️
🕒 *Jam mulai*: $start_time
💰 *Saldo NPT (Base)*: ${NPT_BALANCE} NPT"

  netrum-mining &
  mining_pid=$!

  sleep 24h

  send_telegram "⏳ *24 jam selesai. Klaim reward...* 🪙"
  echo "y" | netrum-claim
  kill $mining_pid

  send_telegram "✅ *Claim selesai! Mining dimulai ulang...* 🔁"
done
