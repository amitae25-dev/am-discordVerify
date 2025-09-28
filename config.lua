--[[
    File: Config;
    Server side
]]

Config = {}

Config.OnMisMatch = {
    freezePlayer = false,
    kickPlayer = false
}

Config.Log = {
    logInConsole = true,
    discordLog = {
        successfull = 'YOUR_DISCORD_WEBHOOK',
        new = 'YOUR_DISCORD_WEBHOOK',
        mismatch = 'YOUR_DISCORD_WEBHOOK'
    }
}