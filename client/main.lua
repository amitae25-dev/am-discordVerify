local isUIVisible = false
local verificationAttempts = 0
local lastAttemptTime = 0

function ShowVerification(code)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'show',
        code = code,
        discordInvite = discordInvite
    })
    isUIVisible = true
end

function ShowMismatch(message)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'showIdMismatch',
        message = message
    })
    isUIVisible = true
end

RegisterNUICallback('joinDiscord', function(data, cb)
    SendNUIMessage({
        type = 'openUrl',
        url = data.url or Config.UI.DiscordInvite
    })
    cb('ok')
end)

RegisterNUICallback('confirmCode', function(data, cb)
    lib.callback('am_discordVerify:checkStatus', false, function(result)
        Wait(1000)
        if result == 'verified' then 
            SendNUIMessage({
                type = 'verificationSuccess'
            })
            Wait(3000)
            SetNuiFocus(false, false)
        else 
            SendNUIMessage({
                type = 'verificationFailed'
            })
        end
    end)
end)

RegisterNUICallback('closeUI', function(data, cb)
    SetNuiFocus(false, false)
    isUIVisible = false
    cb('ok')
end)

-- ASD
local firstSpawn = true
AddEventHandler('playerSpawned', function()
   if firstSpawn then
        lib.callback('am_discordVerify:checkStatus', false, function(result)
            if result == 'verified' then 
                -- Nothing to do
            elseif result == 'mismatch' then 
                ShowMismatch()
            else 
                ShowVerification(result)
            end
        end)
       firstSpawn = false
   end
end)