fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'MaxOrak'
description 'Informator'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {'config.lua', '@qb-core/shared/locale.lua', 'locales/en.lua', 'locales/*.lua'}

client_script {'@PolyZone/client.lua', '@PolyZone/BoxZone.lua', '@PolyZone/EntityZone.lua', '@PolyZone/CircleZone.lua',
               '@PolyZone/ComboZone.lua', 'client/main.lua'}
server_script {'server/*.lua'}

files {'html/*.html', 'html/*.js', 'html/sounds/*.ogg'}
