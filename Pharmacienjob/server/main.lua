ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


TriggerEvent('esx_phone:registerNumber', 'pharmacien', _U('alert_pharmacien'), true, true)
TriggerEvent('esx_society:registerSociety', 'pharmacien', 'pharmacien', 'society_pharmacien', 'society_pharmacien', 'society_pharmacien', {type = 'private'})

RegisterNetEvent('Pharmacienjob:getStockItem')
AddEventHandler('Pharmacienjob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pharmacien', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				xPlayer.showNotification(_U('have_withdrawn', count, inventoryItem.label))
			else
				xPlayer.showNotification(_U('quantity_invalid'))
			end
		else
			xPlayer.showNotification(_U('quantity_invalid'))
		end
	end)
end)


RegisterServerEvent('Pharmacienjob:putStockItems')
AddEventHandler('Pharmacienjob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pharmacien', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, inventoryItem.label))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('Pharmacienjob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pharmacien', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('Pharmacienjob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)

AddEventHandler('playerDropped', function()
	-- Save the source in case we lose it (which happens a lot)
	local _source = source

	-- Did the player ever join?
	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)

		-- Is it worth telling all clients to refresh?
		if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'pharmacien' then
			Citizen.Wait(5000)
			TriggerClientEvent('Pharmacienjob:updateBlip', -1)
		end
	end
end)

RegisterServerEvent('Pharmacienjob:spawned')
AddEventHandler('Pharmacienjob:spawned', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'pharmacien' then
		Citizen.Wait(5000)
		TriggerClientEvent('Pharmacienjob:updateBlip', -1)
	end
end)

RegisterServerEvent('Pharmacienjob:forceBlip')
AddEventHandler('Pharmacienjob:forceBlip', function()
	TriggerClientEvent('Pharmacienjob:updateBlip', -1)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('Pharmacienjob:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'pharmacien')
	end
end)

RegisterServerEvent('Pharmacienjob:message')
AddEventHandler('Pharmacienjob:message', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)


RegisterNetEvent('giveord')
AddEventHandler('giveord', function()
    local item = "ordennance1"
    local limiteitem = 100
    local xPlayer = ESX.GetPlayerFromId(source)
    local nbitemdansinventaire = xPlayer.getInventoryItem(item).count
    

    if nbitemdansinventaire >= limiteitem then
        TriggerClientEvent('esx:showNotification', source, "~r~Vous ne pouvez pas en faire plus!")
    else
        xPlayer.addInventoryItem(item, 1)
        TriggerClientEvent('esx:showNotification', source, "Vous remplissez l'~b~ordennance")
    end
end)

RegisterNetEvent('giveord2')
AddEventHandler('giveord2', function()
    local item = "ordennance2"
    local limiteitem = 100
    local xPlayer = ESX.GetPlayerFromId(source)
    local nbitemdansinventaire = xPlayer.getInventoryItem(item).count
    

    if nbitemdansinventaire >= limiteitem then
        TriggerClientEvent('esx:showNotification', source, "~r~Vous ne pouvez pas en faire plus!")
    else
        xPlayer.addInventoryItem(item, 1)
        TriggerClientEvent('esx:showNotification', source, "Vous remplissez l'~b~ordennance")
    end
end)