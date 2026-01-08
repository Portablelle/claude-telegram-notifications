# Telegram Notifications for Claude Code

Get Telegram notifications when Claude Code needs your attention or completes a task.

## Installation

1. Add the marketplace:
   ```
   /plugin marketplace add Portablelle/claude-telegram-notifications
   ```

2. Install the plugin:
   ```
   /plugin install telegram-notifications@portablelle-plugins
   ```

3. Configure your credentials in `.claude/telegram-notifications.local.md`:
   ```markdown
   ---
   enabled: true
   bot_token: "YOUR_BOT_TOKEN"
   chat_id: "YOUR_CHAT_ID"
   ---
   ```

## Getting your Telegram credentials

1. Talk to [@BotFather](https://t.me/BotFather) and create a bot
2. Send a message to your bot
3. Get your chat_id from `https://api.telegram.org/bot<TOKEN>/getUpdates`

## Alternative: Global configuration

You can also create a global config file at `~/.telegram-config`:

```bash
TELEGRAM_BOT_TOKEN="your_token_here"
TELEGRAM_CHAT_ID="your_chat_id_here"
```

This will be used as a fallback if no project-level config is found.

## Requirements

- `jq` command (install with `brew install jq` on macOS)
- `curl` (pre-installed on most systems)

## License

MIT
