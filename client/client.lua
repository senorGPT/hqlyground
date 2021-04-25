---------------------------------------------------------- GROUND PLAYER BY HQLY DEVELOPMENT ---------------------------------------------
Citizen.CreateThread(function()
	Citizen.Wait(1000)
	
	while true do
		local _ped = PlayerPedId()
		local _coords = GetEntityCoords(_ped)
		
		if _coords.z < config.z_check then
			drawTxt(config.displayText, 0, 1, 0.5, 0.8, 0.4, 128, 128, 128, 255)
			
			if IsControlJustReleased(0, config.key) then
				gotcords, place = GetGroundZFor_3dCoord(_coords.x, _coords.y, 150.0, 0)
	
				ClearPedTasksImmediately(_ped)
				if config.preset then
					SetEntityCoords(_ped, config.coords.x, config.coords.y, config.coords.z, true, false, false, false)
				else
					SetEntityCoords(_ped, _coords.x, _coords.y, place + 1.0, true, false, false, false)
				end
				
				if config.freeze then
					Citizen.CreateThread(function()
						FreezeEntityPosition(_ped, true)
						
						local timer = config.freeze_time
						while timer > 0 do
							timer = timer - 1
							Citizen.Wait(1000)
						end
						
						FreezeEntityPosition(_ped, false)
					end)
				end
			end
		end
		Citizen.Wait(5)
	end
end)

function drawTxt(text, font, centre, x, y, scale, r, g, b, a)
	SetTextFont(font)
	SetTextProportional(1)
	SetTextScale(0.0, 0.3)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end
