function DiscordLog(header, message, webhook)
    if not webhook then 
        print("^2[am_discordVerify]^7 Couldn\'t send discord log, because the webhook is invalid!")
    end
    PerformHttpRequest("https://discord.com/api/webhooks/1419614553515364393/pFvVhVYTev2t37sx-WcMfLKrKeMX3dd8CJgBY6iUf7Kvgmg3IbjZbq1HYZTVQfV-X6C-", function(err, text, headers) end, 'POST', json.encode({
        username = 'Verification System',
        avatar_url = "https://i.imgur.com/PdV59tQ.png",
        embeds = { {
          title = header,
          description = message,
          color = 65280,
          footer = {
              text = string.format("Amitae Scripts - %s", os.date("%c"))
          }
        }
    }
    }), { ['Content-Type'] = 'application/json' })

end