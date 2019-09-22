ESX = nil

-- ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('kuana:givereward')
AddEventHandler('kuana:givereward', function()

	local items = {[1] = "bread", [2] = "water"}
	local quantidade = math.random(1, 5)
	local randomitem = math.random(1, 2)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addInventoryItem(items[randomitem], quantidade)
end)

RegisterServerEvent('kuana:giverewardmoney')
AddEventHandler('kuana:giverewardmoney', function()
	local quantidade = math.random(100, 500)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addMoney(quantidade)
	TriggerClientEvent("esx:showNotification", source, "[~g~Dinheiro da caixa~w~]~n~Retiraste "..quantidade.."$")
end)

RegisterServerEvent('kuana:callcops')
AddEventHandler('kuana:callcops', function()
	TriggerClientEvent("kuana:checkcallcops", -1)
end)