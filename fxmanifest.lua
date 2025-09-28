fx_version 'cerulean'
game 'gta5'

author 'Amitae'
description 'Discord Verification System'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/main.lua',
    'server/discordLog.lua'
}

ui_page 'ui.html'

files {
    'ui.html'
}

dependencies {
    'ox_lib',
    'oxmysql'
}