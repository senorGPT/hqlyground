---------------------------------------------------------- GROUND PLAYER BY HQLY DEVELOPMENT ---------------------------------------------
config = {
	['displayText'] = '~y~Press ~g~E~s~ ~y~to teleport to ground!', -- message which will be displayed
	['key'] = 38, 													-- key which activates the teleport
	['preset'] = false,												-- false: place ped at current location on ground | true: place ped at preset location in config
	['coords'] = { x=0.0, y=0.0, z=0.0 },									-- coordinates for preset location
	['z_check'] = 0.0,												-- z co-ordinate to prompt the player at, found 0.0 to be the best
	['freeze'] = true,												-- whether or not to freeze the player for specified amount after teleporting
	['freeze_time'] = 2												-- number of seconds to freeze player
}
