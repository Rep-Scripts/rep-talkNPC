fx_version 'cerulean'
game 'gta5'

name "Rep Dev - Talk with NPC"
author "Q4D#1905 x HWANJR#0928"
version "1.1.0"

client_scripts {
	'client/*.lua'
}

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/*.css',
	'ui/*.js',
	'ui/imgs/*.png',
    'ui/imgs/app/*.png',
	'ui/sounds/*.ogg'
}

shared_script 'config.lua'
lua54 'yes'
