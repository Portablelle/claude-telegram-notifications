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

# Detect hook type
hook_event=$(echo "$input" | jq -r '.hook_event_name // ""')
tool_name=$(echo "$input" | jq -r '.tool_name // ""')
notification_type=$(echo "$input" | jq -r '.notification_type // ""')

# Handle different hook types
if [[ "$hook_event" == "PreToolUse" && "$tool_name" == "AskUserQuestion" ]]; then
  # PreToolUse for AskUserQuestion - extract and send the question
  message=$(echo "$input" | jq -r '.tool_input.questions[0].question // "Claude Code has a question for you"')
  label="question"
elif [[ "$hook_event" == "Notification" && "$notification_type" == "permission_prompt" ]]; then
  # Skip permission_prompt - PreToolUse already handles AskUserQuestion
  exit 0
elif [[ "$hook_event" == "Notification" ]]; then
  # Other notifications (idle_prompt, etc.)
  message=$(echo "$input" | jq -r '.message // "Claude Code needs your attention"')
  label="$notification_type"
else
  # Unknown hook type - send generic message
  message=$(echo "$input" | jq -r '.message // "Claude Code needs your attention"')
  label="notification"
fi

# Send Telegram notification
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
  -d "chat_id=$TELEGRAM_CHAT_ID" \
  -d "text=🔔 Claude Code ($label)
$message" > /dev/null

exit 0
