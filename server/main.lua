local verifiedPlayers = {}
local pendingVerifications = {}

lib.callback.register('am_discordVerify:checkStatus', function(source)
    local license = GetPlayerIdentifierByType(source, 'license')
    local discordId = GetPlayerIdentifierByType(source, 'discord')
    
    if not discordId then
        print('No dc id')
        return
    end
    local verified, message = CheckVerification(license, discordId, source)

    if verified.status == "verified" then
        return 'verified'
    elseif verified.status == "mismatch" then
        return 'mismatch'
    else
        local code = GenerateVerificationCode(source)
        return code
    end
end)

function CheckVerification(license, discordId, source)
    local result = MySQL.query.await('SELECT * FROM discord_verifications WHERE fivem_identifier = ? OR discord_id = ?', {license, discordId})
    if result and #result > 0 then
        local record = result[1]
        if record.fivem_identifier and record.discord_id then
            if record.fivem_identifier == license and "discord:" .. record.discord_id == discordId then 
                DiscordLog("User Verified", string.format("User %s successfully verified!", GetPlayerName(source)), Config.Log.discordLog.successfull)
                if Config.Log.logInConsole then 
                    lib.print.info(string.format("User %s successfully verified!", GetPlayerName(source)))
                end
                return {status = "verified"}
            elseif record.fivem_identifier ~= license or "discord:" .. record.discord_id ~= discordId and record.verified_at then 
                DiscordLog("Mismatch in user identifiers", string.format("Discord Verification Mismatch!\n\nSaved Data:\nIdentifier: %s\nDiscord: %s\n\nCurrent Data:\nIdentifier: %s\nDiscord: %s\n\nVerified at: %s", record.fivem_identifier, "discord:" .. record.discord_id, license, discordId, os.date("%Y-%m-%d %H:%M:%S", math.floor(record.verified_at / 1000))), Config.Log.discordLog.mismatch)
                if Config.Log.logInConsole then 
                    lib.print.error(string.format("Discord Verification Mismatch!\n\nSaved Data:\n**Identifier:** %s\n**Discord:** %s\n\nCurrent Data:\n**Identifier:** %s\n**Discord:** %s\n\nVerified at: %s", record.fivem_identifier, "discord:" .. record.discord_id, license, discordId, os.date("%Y-%m-%d %H:%M:%S", math.floor(record.verified_at / 1000))))
                end
                return {status = "mismatch"}
            end
        end
    end
    
    return {status = "not_verified"}
end

function GenerateVerificationCode(source, forceNew)
    local license = GetPlayerIdentifierByType(source, 'license')
    
    if not forceNew then
        local existingCode = MySQL.scalar.await('SELECT verify_code FROM discord_verifications WHERE fivem_identifier = ?', {license})
        if existingCode then
            DiscordLog("New User", string.format("User %s have to be verified! Existing code retrieved and passed", GetPlayerName(source)), Config.Log.discordLog.new)
            if Config.Log.logInConsole then 
                lib.print.info(string.format("User %s have to be verified! Existing code retrieved and passed", GetPlayerName(source)))
            end
            return existingCode
        end
    end
    
    DiscordLog("New User", string.format("User %s have to be verified! Code generated, awaiting for verification", GetPlayerName(source)), Config.Log.discordLog.new)
    if Config.Log.logInConsole then 
        lib.print.info(string.format("User %s have to be verified! Code generated, awaiting for verification", GetPlayerName(source)))
    end
    local code = lib.string.random('..........', 10)
    MySQL.insert.await('INSERT INTO discord_verifications (fivem_identifier, verify_code) VALUES (?, ?) ON DUPLICATE KEY UPDATE verify_code = ?', {
        license, code, code
    })

    return code
end

-- Function to get verification status (export)
function GetVerificationStatus(license, discordId)
    return CheckVerification(license, discordId)
end

-- Export function
exports('GetVerificationStatus', GetVerificationStatus)