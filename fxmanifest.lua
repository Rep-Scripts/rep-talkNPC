fx_version 'cerulean'
game 'gta5'

name "Rep Dev - Talk with NPC"
author "Q4D#1905 x HWANJR#0928"
version "1.0.0"

client_scripts {'client/*.lua'}
ui_page 'Ui/ui.html'
files {
	'Ui/ui.html',
	'Ui/*.css',
	'Ui/*.js',
	'Ui/imgs/*.png',
    'Ui/imgs/app/*.png',
	'Ui/sounds/*.ogg'
}

shared_script 'config.lua'
lua54 'yes'
