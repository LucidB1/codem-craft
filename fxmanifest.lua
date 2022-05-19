fx_version 'cerulean'
game 'gta5'
author 'Aiakos#8317'
description 'Codem-Craft'
ui_page {
	'html/index.html',
}
files {
	'html/*.css',
	'html/*.js',
	'html/*.html',
	'html/*.ogg',
	'html/images/*.png',
	'html/images/*.svg',
	'html/itemimages/*.png',

}

shared_script{
	'config.lua',
}

dependencies { 
	'/server:5104',
	'/gameBuild:1868',
	'/onesync',
}

client_scripts {
	'GetFrameworkObject.lua',
	'client/*.lua',
}
server_scripts {
	--'@async/async.lua', -- MYSQL ASYNC
	--'@mysql-async/lib/MySQL.lua',  -- MYSQL ASYNC
	'@oxmysql/lib/MySQL.lua', -- OXMYSQL
	'server/*.lua',
	'GetFrameworkObject.lua',
}

lua54 'yes'