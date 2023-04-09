ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--paracetamol---
RegisterNetEvent('rparacetamol')
AddEventHandler('rparacetamol', function()
    local item = "paracetamol"
    local limiteitem = 100
    local xPlayer = ESX.GetPlayerFromId(source)
    local nbitemdansinventaire = xPlayer.getInventoryItem(item).count
    

    if nbitemdansinventaire >= limiteitem then
        TriggerClientEvent('esx:showNotification', source, "~r~Tu n'as pas assez de place dans ton inventaire !")
    else
        xPlayer.addInventoryItem(item, 1)
        TriggerClientEvent('esx:showNotification', source, "~y~Récolte de ~b~Paracetamol ~y~en cours...")
    end
end)


RegisterNetEvent('tdoliprane')
AddEventHandler('tdoliprane', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local doliprane = xPlayer.getInventoryItem('doliprane').count
    local paracetamol = xPlayer.getInventoryItem('paracetamol').count

    if doliprane > 50 then
        TriggerClientEvent('esx:showNotification', source, '~r~Il semble que tu ne puisses plus porter de sachet de ~b~Doliprane .')
    elseif paracetamol < 3 then
        TriggerClientEvent('esx:showNotification', source, '~r~Pas assez de ~g~Paracetamol~r~ pour continuer !')
    else
        xPlayer.removeInventoryItem('paracetamol', 2)
        xPlayer.addInventoryItem('doliprane', 1)    
    end
end)

RegisterNetEvent('rmorphine')
AddEventHandler('rmorphine', function()
    local item = "morphine"
    local limiteitem = 100
    local xPlayer = ESX.GetPlayerFromId(source)
    local nbitemdansinventaire = xPlayer.getInventoryItem(item).count
    

    if nbitemdansinventaire >= limiteitem then
        TriggerClientEvent('esx:showNotification', source, "Ta pas assez de place dans ton inventaire !")
    else
        xPlayer.addInventoryItem(item, 1)
        TriggerClientEvent('esx:showNotification', source, "~o~Récupération en cours...")
    end
end)


RegisterNetEvent('tmorphine')
AddEventHandler('tmorphine', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local morphine = xPlayer.getInventoryItem('morphine').count
    local shoot_pooch = xPlayer.getInventoryItem('shoot_pooch').count

    if shoot_pooch > 20 then
        TriggerClientEvent('esx:showNotification', source, '~r~Il semble que tu ne puisses plus porter de ~r~Mophine')
    elseif morphine < 4 then
        TriggerClientEvent('esx:showNotification', source, '~r~Il te manque des ingredients')
    else
        xPlayer.removeInventoryItem('morphine', 5)
        xPlayer.addInventoryItem('shoot_pooch', 1)    
    end
end)


RegisterNetEvent('tdpara')
AddEventHandler('tdpara', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local paracetamol = xPlayer.getInventoryItem('paracetamol').count
    local morphine = xPlayer.getInventoryItem('morphine').count
    local gdecontractant = xPlayer.getInventoryItem('gdecontractant').count

    if gdecontractant > 20 then
        TriggerClientEvent('esx:showNotification', source, '~r~Il semble que tu ne puisses plus porter de sachets de ~b~Géllule décontractante')
    elseif paracetamol < 3 then
        TriggerClientEvent('esx:showNotification', source, '~r~il te manque des ingredients')
    elseif morphine < 1 then
        TriggerClientEvent('esx:showNotification', source, '~r~il te manque des ingredients')
    else
        xPlayer.removeInventoryItem('morphine', 1)
        xPlayer.removeInventoryItem('paracetamol', 3)
        xPlayer.addInventoryItem('gdecontractant', 1)    
    end
end)

RegisterNetEvent('rtissue')
AddEventHandler('rtissue', function()
    local item = "vtissue"
    local limiteitem = 100
    local xPlayer = ESX.GetPlayerFromId(source)
    local nbitemdansinventaire = xPlayer.getInventoryItem(item).count
    

    if nbitemdansinventaire >= limiteitem then
        TriggerClientEvent('esx:showNotification', source, "~r~Tu n'as pas assez de place dans ton inventaire !")
    else
        xPlayer.addInventoryItem(item, 1)
        TriggerClientEvent('esx:showNotification', source, "~y~Récolte de ~b~vieux tissue ~y~en cours...")
    end
end)


RegisterNetEvent('ttissue')
AddEventHandler('ttissue', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local vtissue = xPlayer.getInventoryItem('vtissue').count
    local tissue = xPlayer.getInventoryItem('tissue').count

    if tissue > 50 then
        TriggerClientEvent('esx:showNotification', source, '~r~Il semble que tu ne puisses plus porter de ~b~tissue .')
    elseif vtissue < 3 then
        TriggerClientEvent('esx:showNotification', source, '~r~Pas assez de ~g~vieux tissue~r~ pour continuer !')
    else
        xPlayer.removeInventoryItem('vtissue', 2)
        xPlayer.addInventoryItem('tissue', 1)    
    end
end)


RegisterNetEvent('tbandes')
AddEventHandler('tbandes', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local bandage = xPlayer.getInventoryItem('bandage').count
    local tissue = xPlayer.getInventoryItem('tissue').count

    if bandage > 50 then
        TriggerClientEvent('esx:showNotification', source, '~r~Il semble que tu ne puisses plus porter de ~b~bandes .')
    elseif tissue < 3 then
        TriggerClientEvent('esx:showNotification', source, '~r~Pas assez de ~g~tissue~r~ pour continuer !')
    else
        xPlayer.removeInventoryItem('tissue', 2)
        xPlayer.addInventoryItem('bandage', 1)    
    end
end)
-------------------------------------------------------- Vente

RegisterServerEvent('sellgellule')
AddEventHandler('sellgellule', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local widow_pooch = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "gdecontractant" then
			gdecontractant = item.count
		end
	end
    
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_pharmacien', function(account)
        societyAccount = account
    end)
    
    if gdecontractant > 0 then
        xPlayer.removeInventoryItem('gdecontractant', 1)
        xPlayer.addMoney(20)
        societyAccount.addMoney(50)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez gagner ~b~20$~w~ pour chaque vente de ~b~Géllule décontractante Paracétamol")
        TriggerClientEvent('esx:showNotification', xPlayer.source, "La société gagne ~b~50$~w~ pour chaque vente de ~b~Géllule décontractante Paracétamol")
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'avez plus rien à vendre")
    end
end)

RegisterServerEvent('sellmorphine')
AddEventHandler('sellmorphine', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local shoot_pooch = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "shoot_pooch" then
			shoot_pooch = item.count
		end
	end

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_pharmacien', function(account)
        societyAccount = account
    end)
    
    if shoot_pooch > 0 then
        xPlayer.removeInventoryItem('shoot_pooch', 1)
        xPlayer.addMoney(20)
        societyAccount.addMoney(50)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez gagner ~b~20$~w~ pour chaque vente de ~r~Décontractant Morphine")
        TriggerClientEvent('esx:showNotification', xPlayer.source, "La société gagne ~b~50$~w~ pour chaque vente de ~r~Décontractant Morphine")
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'avez plus rien à vendre")
    end
end)

RegisterServerEvent('selldoliprane')
AddEventHandler('selldoliprane', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local sachetpooch = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "doliprane" then
			doliprane = item.count
		end
	end
    
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_pharmacien', function(account)
        societyAccount = account
    end)
    
    if doliprane > 0 then
        xPlayer.removeInventoryItem('doliprane', 1)
        xPlayer.addMoney(15)
        societyAccount.addMoney(40)
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez gagner ~b~15$~w~ pour chaque vente de ~b~Doliprane")
        TriggerClientEvent('esx:showNotification', xPlayer.source, "La société gagne ~b~40$~w~ pour chaque vente de ~b~Doliprane") 
    else 
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'avez plus rien à vendre")
    end
end)


