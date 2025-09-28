# Discord Verification System

**Desription:**

Players have to verify their discord account with a code. After the register, players need to verify their discord by copying a code (from the ingame UI) into a specific discord channel. With the discord bot running it will automatically conenct the player's discord ID with the player's Fivem identifier and save these informations in the database. On every join the script will check if the player is with the same identifiers if any of the identifiers is different the script will show an error UI and wont let the player play on the server. In this case the admins have to check the player.


## Features

- Custom In-game UI
- Script contains a discord bot (made by: [Aron-tech](https://github.com/Aron-tech))
- Fully open source
- Cross framework

![App Screenshot](https://i.imgur.com/VZQtjiP.png)
# Installation

**Basic Installation:**
1. Download the latest release from github.
2. Unzip and install the script between your server scripts.
3. Make sure to ensure the script in your `server.cfg`.
4. Ensure the SQL from `insert.sql`.
5. Restart your server.
6. Configure the discord bot:
- Open the `config.json` file.
- Edit the following: `discord_token`, `watch_channel_id`, `guild_id`
- `discord_token` you can generate one on the discord developer portal
- `watch_channel_id` the channel ID where you accept the codes
- `guild_id` your server ID
- The following commands must be run where the `bot.js` is located
- Make sure to run the command: `npm install`
- Run the bot with the command: `node bot.js`
7. Ensure the script and enjoy it!
    
## Requirements

1. [ox_lib](https://github.com/communityox/ox_lib/releases)

## Customization
You can find the customizations in the `shared/main.lua`.
Make sure to paste your discord server invite.
You can edit the UI's language by altering the `ui.html` file.
## Authors
**Discord Bot:**
- [Aron-tech](https://github.com/Aron-tech)
- Discord: roka2003

**Lua script:**
- [Amitae](https://github.com/amitae25-dev)
- Discord: amitae_

