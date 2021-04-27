---------------------------------------------------------- GROUND PLAYER BY HQLY DEVELOPMENT ---------------------------------------------
Citizen.CreateThread(function()
	Citizen.Wait(1000)
	
	while true do
		-- get the details
		_ped = PlayerPedId()
		-- check if player is dead or not existing
		if IsEntityDead(_ped) or not DoesEntityExist(_ped) then
			Citizen.Wait(1000) -- delay it a bit to optimize a little bit
			goto m_next
		end
		
		_coords = GetEntityCoords(_ped)
		_, z = GetGroundZFor_3dCoord(_coords.x, _coords.y, 150.0, 0) -- starting at 150.0 at Z since it works up-down, but not down-up	
		-- is ped lower than the z co-ordinate we want to look at
		if _coords.z < config.z_check then
			-- flag checking per config file for: ped is swimming/falling/inside
			local flag_swimming, flag_falling, flag_inside = true, true, true
			if config.check_swimming and (IsPedSwimming(_ped) or IsPedSwimmingUnderWater(_ped)) then
				flag_swimming = false
			end
			if config.check_falling and not IsPedFalling(_ped) then
				flag_falling = false
			end
			if config.check_inside and not IsPedFalling(_ped) and z > _coords.z then 
				flag_inside = false
			end
			
			-- display the prompt for trigger
			if flag_falling and flag_swimming and flag_inside then
				drawTxt(config.displayText, 0, 1, 0.5, 0.8, 0.4, 128, 128, 128, 255)
			end
			if IsControlJustReleased(0, config.key) and (flag_falling and flag_swimming and flag_inside) then
				ClearPedTasksImmediately(_ped)
				-- whether to teleport the player to the ground or predefined location
				if config.preset then
					SetEntityCoords(_ped, config.coords.x, config.coords.y, config.coords.z, true, false, false, false)
				else
					SetEntityCoords(_ped, _coords.x, _coords.y, z + 1.0, true, false, false, false) -- +1.0 on Z to compensate for _ped height
				end
				-- freeze the player for x seconds per config file
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
		
		::m_next::
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
