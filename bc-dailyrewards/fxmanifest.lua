fx_version 'cerulean'
game 'gta5'

author 'Daily Rewards Script'
description 'A daily rewards system with streak tracking'
version '1.0.0'

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_main.lua',
}

client_scripts {
    'client/cl_main.lua',
}

lua54 'yes'
