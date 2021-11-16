---------------------------------------------------------- GROUND PLAYER BY HQLY DEVELOPMENT ---------------------------------------------
Citizen.CreateThread(function()
	Citizen.Wait(1000)
	
	while true do
		-- get the details
		_ped = PlayerPedId()
		_target = _ped
		-- check if player is dead or not existing
		if IsEntityDead(_ped) or not DoesEntityExist(_ped) then
			Citizen.Wait(1000) -- delay it a bit to optimize a little bit
			goto m_next
		end
		
		flag_prompt = false
		veh = GetVehiclePedIsIn(_ped, false)
		if veh ~= 0 then -- get the entity coordinates of the vehicle instead
			_target = veh
		end

		_coords = GetEntityCoords(_target)
		_, z = GetGroundZFor_3dCoord(_coords.x, _coords.y, 150.0, 0) -- starting at 150.0 at Z since it works up-down, but not down-up	
		-- is ped lower than the z co-ordinate we want to look at
		if _coords.z < config.z_check then
			
			-- ignore players which are swimming
			-- TODO: possibly add another Z level check for swimming peds
			if IsPedSwimming(_ped) or IsPedSwimmingUnderWater(_ped) or (not IsPedFalling(_ped) and veh == 0) then
				goto m_next
			end
			-- trigger prompt if the ped is falling
			if IsPedFalling(_ped) then
				flag_prompt = true
			end
			-- check if player is in vehicle and if its falling, trigger prompt
			if veh ~= 0 and IsEntityInAir(veh) then
				flag_prompt = true
			end

			-- display the prompt for trigger
			if flag_prompt then
				drawTxt(config.displayText, 0, 1, 0.5, 0.8, 0.4, 128, 128, 128, 255)
			end
			if IsControlJustReleased(0, config.key) and flag_prompt then
				ClearPedTasksImmediately(_ped)
				-- whether to teleport the player to the ground or predefined location
				if config.preset then
					SetEntityCoordsNoOffset(_target, config.coords.x, config.coords.y, config.coords.z, true, false, false)
				else
					SetEntityCoordsNoOffset(_target, _coords.x, _coords.y, z, true, false, false) 
				end
				-- teleport the player into the vehicle (for some reason it only teleports the vehicle entity)
				if veh ~= 0 then
					SetPedIntoVehicle(_ped, veh, -1)
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