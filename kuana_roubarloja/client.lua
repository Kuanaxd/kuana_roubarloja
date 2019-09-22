ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

local prateleiras = {
	{ x = -50.3, y = -1753.13, z = 28.42, h = 7.68, ax = -50.3, ay = -1753.37 },
	{ x = -48.79, y = -1753.89, z = 28.42, h = 180.5, ax = -48.89, ay = -1753.63 },
	{ x = -48.68, y = -1755.28, z = 28.42, h = 2.76, ax = -48.63, ay = -1755.56 }
}

local caixas = {
	{ x = -46.68, y = -1757.93, z = 28.42, h = 50.47, ax = -46.53, ay = -1757.98 },
	{ x = -47.78, y = -1759.54, z = 28.42, h = 50.47, ax = -47.75, ay = -1759.55 }
}

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(ped))
		for _,v in pairs(prateleiras) do
			local distance = GetDistanceBetweenCoords(v.x, v.y, v.z, x, y, z, 1)
			if distance <= 2 then
				Drawing.draw3DText(v.x, v.y, v.z, "[~g~E~w~] ~r~Roubar~w~ Prateleira", 4, 0.1, 0.05, 255, 255, 255, 255)
				DrawMarker(27, v.x, v.y, v.z + 0.2, 0, 0, 0, 0, 0, 0, 0.3,0.3,0.3, 0, 232, 255, 155, 0, 0, 0, 0, 0, 0, 0)
				if distance < 1.1 and (IsControlJustReleased(1, 51)) then
					SetEntityCoords(ped, v.ax, v.ay, v.z)
					SetEntityHeading(ped, v.h)
					roubarprat()
				end
			end
		end
	end
end)

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(ped))
		for _,v in pairs(caixas) do
			local distance = GetDistanceBetweenCoords(v.x, v.y, v.z, x, y, z, 1)
			if distance <= 2 then
				Drawing.draw3DText(v.x, v.y, v.z, "[~g~E~w~] ~r~Roubar~w~ caixa", 4, 0.1, 0.05, 255, 255, 255, 255)
				DrawMarker(27, v.x, v.y, v.z + 0.2, 0, 0, 0, 0, 0, 0, 0.3,0.3,0.3, 0, 232, 255, 155, 0, 0, 0, 0, 0, 0, 0)
				if distance < 1.1 and (IsControlJustReleased(1, 51)) then
					SetEntityCoords(ped, v.ax, v.ay, v.z)
					SetEntityHeading(ped, v.h)
					roubarcaixa()
				end
			end
		end
	end
end)

function roubarprat()

	local anims = {[1] = "stand_cash_in_bag_loop", [2] = "put_cash_into_bag_loop"}
	local randomanim = math.random(1, 2)

	ESX.Streaming.RequestAnimDict("mp_missheist_ornatebank", function()
		TaskPlayAnim(PlayerPedId(), "mp_missheist_ornatebank", anims[randomanim], 8.0, -8.0, -1, 0, 0, false, false, false)
		Citizen.Wait(1400)
		TaskPlayAnim(PlayerPedId(), "mp_missheist_ornatebank", anims[randomanim], 8.0, -8.0, -1, 0, 0, false, false, false)
		Citizen.Wait(1400)
		TaskPlayAnim(PlayerPedId(), "mp_missheist_ornatebank", anims[randomanim], 8.0, -8.0, -1, 0, 0, false, false, false)
		Citizen.Wait(1400)
		TaskPlayAnim(PlayerPedId(), "mp_take_money_mg", anims[randomanim], 8.0, -8.0, -1, 0, 0, false, false, false)	
		Citizen.Wait(1400)	
	end)
	TriggerServerEvent("kuana:givereward")
	TriggerServerEvent("kuana:callcops")
end

function roubarcaixa()
	ESX.Streaming.RequestAnimDict("mp_missheist_ornatebank", function()
		TaskPlayAnim(PlayerPedId(), "mp_missheist_ornatebank", "stand_cash_in_bag_loop", 8.0, -8.0, -1, 0, 0, false, false, false)
		Citizen.Wait(1400)
		TaskPlayAnim(PlayerPedId(), "mp_missheist_ornatebank", "stand_cash_in_bag_loop", 8.0, -8.0, -1, 0, 0, false, false, false)
		Citizen.Wait(1400)
		TaskPlayAnim(PlayerPedId(), "mp_missheist_ornatebank", "stand_cash_in_bag_loop", 8.0, -8.0, -1, 0, 0, false, false, false)
		Citizen.Wait(1400)
		TaskPlayAnim(PlayerPedId(), "mp_take_money_mg", "stand_cash_in_bag_loop", 8.0, -8.0, -1, 0, 0, false, false, false)	
		Citizen.Wait(1400)	
	end)
	TriggerServerEvent("kuana:giverewardmoney")
	TriggerServerEvent("kuana:callcops")
end

RegisterNetEvent('kuana:checkcallcops')
AddEventHandler('kuana:checkcallcops', function()
	if ESX.PlayerData.job.name == "police" then
		ESX.ShowNotification("[~y~Alarme de loja~w~] ~n~ Alguem esta a ~r~roubar~w~ uma loja!")
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

Drawing = setmetatable({}, Drawing)
Drawing.__index = Drawing

function Drawing.draw3DText(x,y,z,textInput,fontId,scaleX,scaleY,r, g, b, a)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*14
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+1, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end