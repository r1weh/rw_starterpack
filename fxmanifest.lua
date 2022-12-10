fx_version 'adamant'
lua54 'yes'
game 'gta5'

client_script {
    'config.lua',
    'client/cl_start.lua'
}

server_script {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/sv_start.lua',
    'server/sv_modul.lua'
}