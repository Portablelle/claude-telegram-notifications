---
description: Configure Telegram notifications interactively
allowed-tools: AskUserQuestion, Bash, Write, Read
---

# Telegram Notifications Setup

Guide the user through configuring Telegram notifications for Claude Code. Follow these steps exactly:

## Step 1: Get Bot Token

Ask the user for their Telegram bot token using AskUserQuestion:
- Question: "Enter your Telegram bot token from @BotFather"
- Provide a text input option
- If they don't have a bot yet, explain they need to:
  1. Open Telegram and search for @BotFather
  2. Send `/newbot` and follow the prompts
  3. Copy the token provided

## Step 2: Auto-detect Chat ID

Once you have the token:

1. Ask the user to send any message to their bot on Telegram, then confirm they did it

2. After confirmation, run this command to get the chat_id:
```bash
curl -s "https://api.telegram.org/bot<TOKEN>/getUpdates" | jq -r '.result[-1].message.chat.id // empty'
```

3. If empty or null, tell the user no messages were found and ask them to:
   - Make sure they sent a message to the correct bot
   - Try again

4. If a chat_id is found, show it to the user for confirmation

## Step 3: Validate Configuration

Send a test message to verify everything works:
```bash
curl -s -X POST "https://api.telegram.org/bot<TOKEN>/sendMessage" \
  -d "chat_id=<CHAT_ID>" \
  -d "text=✅ Claude Code notifications configured successfully!"
```

If the request fails, show the error and help troubleshoot.

## Step 4: Choose Config Location

Ask the user where to save the configuration:

**Option 1: Global** (`~/.telegram-config`)
- Used for all projects
- Format:
```bash
TELEGRAM_BOT_TOKEN="<token>"
TELEGRAM_CHAT_ID="<chat_id>"
```

**Option 2: Project** (`.claude/telegram-notifications.local.md`)
- Only for current project
- Format:
```markdown
---
enabled: true
bot_token: "<token>"
chat_id: "<chat_id>"
---
```

## Step 5: Save Configuration

Write the config file in the chosen location with the correct format.

## Step 6: Confirm Success

Tell the user:
- Configuration saved successfully
- They should have received a test notification on Telegram
- Notifications will now be sent when Claude needs attention or completes tasks
