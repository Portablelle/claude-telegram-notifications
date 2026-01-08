#!/bin/bash
# Telegram Notifications for Claude Code
# Sends a notification when Claude needs user attention

# Read settings from project config (YAML frontmatter)
CONFIG_FILE="${CLAUDE_PROJECT_DIR}/.claude/telegram-notifications.local.md"
if [[ -f "$CONFIG_FILE" ]]; then
  TELEGRAM_BOT_TOKEN=$(sed -n 's/^bot_token:[[:space:]]*"\{0,1\}\([^"]*\)"\{0,1\}$/\1/p' "$CONFIG_FILE")
  TELEGRAM_CHAT_ID=$(sed -n 's/^chat_id:[[:space:]]*"\{0,1\}\([^"]*\)"\{0,1\}$/\1/p' "$CONFIG_FILE")
fi

# Fallback to global config
if [[ -z "$TELEGRAM_BOT_TOKEN" ]] && [[ -f ~/.telegram-config ]]; then
  source ~/.telegram-config
fi

# Exit silently if not configured
[[ -z "$TELEGRAM_BOT_TOKEN" || -z "$TELEGRAM_CHAT_ID" ]] && exit 0

# Read hook input from stdin
input=$(cat)
message=$(echo "$input" | jq -r '.message // "Claude Code needs your attention"')
notification_type=$(echo "$input" | jq -r '.notification_type // "unknown"')

# Send Telegram notification
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
  -d "chat_id=$TELEGRAM_CHAT_ID" \
  -d "text=🔔 Claude Code ($notification_type)
$message" > /dev/null

exit 0
