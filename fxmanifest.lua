
fx_version 'adamant'
games { 'gta5' }


ui_page {
    'html/index.html',
}

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/pics/*.png',
    'html/pics/*.jpg',
}


server_scripts { 
    'config.lua',
    'server/server_weedPlacement.lua',
}

client_scripts {
    'config.lua',
    'client/client_weedPlacement.lua',
    'client/client_util.lua'
}
