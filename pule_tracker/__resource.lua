resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Car Tracker'
lua54 "yes"
version '1.0.0'

client_scripts {
    '@es_extended/locale.lua',
    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'server.lua'
}

shared_scripts {
    "@ox_lib/init.lua",
    "config.lua"
}

dependencies {
    'es_extended'
}
