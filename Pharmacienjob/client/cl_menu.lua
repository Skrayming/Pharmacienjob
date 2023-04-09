local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, IsHandcuffed, hasAlreadyJoined, playerInService, isInShopMenu = false, false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false
blip = nil

local attente = 0

function OpenBillingMenu()

	ESX.UI.Menu.Open(
	  'dialog', GetCurrentResourceName(), 'billing',
	  {
		title = "Facture"
	  },
	  function(data, menu)
	  
		local amount = tonumber(data.value)
		local player, distance = ESX.Game.GetClosestPlayer()
  
		if player ~= -1 and distance <= 3.0 then
  
		  menu.close()
		  if amount == nil then
			  ESX.ShowNotification("~r~Problèmes~s~: Montant invalide")
		  else
			local playerPed        = GetPlayerPed(-1)
			TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
			Citizen.Wait(5000)
			  TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_pharmacien', ('pharmacien'), amount)
			  Citizen.Wait(100)
			  ESX.ShowNotification("~r~Vous avez bien envoyer la facture")
		  end
  
		else
		  ESX.ShowNotification("~r~Problèmes~s~: Aucun joueur à proximitée")
		end
  
	  end,
	  function(data, menu)
		  menu.close()
	  end
	)
  end


  ESX = nil

  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local PlayerData = {}
local ped = PlayerPedId()
local vehicle = GetVehiclePedIsIn( ped, false )
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)


RMenu.Add('pharmacien', 'main', RageUI.CreateMenu("~b~Pharmacie", "~b~Menu Pharmacien"))
RMenu.Add('pharmacien', 'inter', RageUI.CreateMenu("~b~Pharmacie", "~b~Menu Pharmacien"))
RMenu.Add('pharmacien', 'listing', RageUI.CreateSubMenu(RMenu:Get('pharmacien', 'main'), "~b~Pharmacie", "~b~Liste des INGREDIENTS"))
RMenu.Add('pharmacien', 'annonce', RageUI.CreateSubMenu(RMenu:Get('pharmacien', 'main'), "~p~Annonce", "~p~Menu Annonce"))
RMenu.Add('pharmacien', 'ordennance', RageUI.CreateSubMenu(RMenu:Get('pharmacien', 'main'), "~b~Ordenance", "~b~Menu ordennance"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('pharmacien', 'main'), true, true, true, function()

			RageUI.Button("~o~Listing Ingredients", nil, {RightLabel = "→→"},true, function ()
            end, RMenu:Get('pharmacien', 'listing'))

			RageUI.Button("~g~Annonce~s~", nil, {RightLabel = "→→"},true, function ()
            end, RMenu:Get('pharmacien', 'annonce'))

			RageUI.Button("~b~Ordennance~s~", nil, {RightLabel = "→→"},true, function ()
            end, RMenu:Get('pharmacien', 'ordennance'))


			RageUI.Button("~r~Faire une facture",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
			if Selected then
					RageUI.CloseAll()        
					OpenBillingMenu() 
				end
			end)

		end, function()
        end)


		RageUI.IsVisible(RMenu:Get('pharmacien', 'annonce'), true, true, true, function()
			RageUI.Button("~p~Annonces ~g~Ouverture",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
				if Selected then      
					TriggerServerEvent('AnnonceOuvertP')
				end
			end)

			RageUI.Button("~p~Annonces ~r~Fermeture",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
				if Selected then      
					TriggerServerEvent('AnnonceFermerP')
				end
			end)

			RageUI.Button("~p~Annonces ~o~Stand By",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
				if Selected then      
					TriggerServerEvent('AnnonceST')
				end
			end)

		end, function()
        end)

		RageUI.IsVisible(RMenu:Get('pharmacien', 'listing'), true, true, true, function()
			RageUI.Button("~o~Liste ingerdient décontractant ~r~Morphine",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
				if Selected then  
					ESX.ShowNotification("~b~Liste base Morphine~w~ : 5 Morphine")
					Citizen.Wait(1000)
					ESX.ShowNotification("~r~Resultat~w~ : 1 Décontractant ") 
				end
			end)

			RageUI.Button("~o~Liste ingerdient décontractant ~b~Paracetamol",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
				if Selected then     
					ESX.ShowNotification("~b~Liste base Paracetamol~w~ : 1 Morphine ")
					Citizen.Wait(1000)
					ESX.ShowNotification("~b~Liste base Paracetamol~w~ : 3 Paracetamol ")
					Citizen.Wait(1000)
					ESX.ShowNotification("~r~Resultat~w~ : 1 Patch ")
				end
			end)

			RageUI.Button("~o~Liste des objets pour ~g~Bandage",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
				if Selected then     
					ESX.ShowNotification("~b~Liste base Bandage~w~ : 2 tissue  ")
					Citizen.Wait(1000)
					ESX.ShowNotification("~g~Resultat~w~ : Bandage X1 ")
				end
			end)

		end, function()
		end)

		RageUI.IsVisible(RMenu:Get('pharmacien', 'ordennance'), true, true, true, function()
			--RageUI.Button("Ordennance ~g~Niveau 1 ",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
			RageUI.Button("Ordennance ~g~Niveau 1 ", "~o~Donne droit a la consomation de ~b~paracetamol", {RightLabel = "→→"},true, function(Hovered, Active, Selected)
				if Selected then 
					ExecuteCommand('e notepad2')				
					ESX.ShowNotification("vous faite une ordennance de ~g~niveau 1")
					ESX.ShowNotification("Cette ordonnance donne droit a la consomation de ~b~paracetamol.")
					Citizen.Wait(5000)
					TriggerServerEvent('giveord')
				end
			end)

			RageUI.Button("Ordennance ~r~Niveau 2 ", "~o~Donne droit a la consomation de ~r~morphine", {RightLabel = "→→"},true, function(Hovered, Active, Selected)
				if Selected then 
					ExecuteCommand('e notepad2')
					ESX.ShowNotification("vous faite une ordennance de ~r~niveau 2")
					ESX.ShowNotification("Cette ordonnance donne le droit a la consomation de ~r~morphine.")
					Citizen.Wait(5000)
					TriggerServerEvent('giveord2')
				end
			end)

		end, function()
		end)

	RageUI.IsVisible(RMenu:Get('pharmacien', 'inter'), true, true, true, function()

end, function()
end)

Citizen.Wait(0)
end
end)

    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(100)
        end
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'pharmacien' then 
            if IsControlJustReleased(0 ,167) then
                RageUI.Visible(RMenu:Get('pharmacien', 'main'), not RageUI.Visible(RMenu:Get('pharmacien', 'main')))
            end
        end
        end
    end)

   
-----garage

RMenu.Add('garagePharmacie', 'main', RageUI.CreateMenu("~o~Garage", "~g~INTERACTION VEHICULE."))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('garagePharmacie', 'main'), true, true, true, function() 
            RageUI.Button("~r~Ranger les Vehicules", "~g~Pour ranger les vehicules.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
            if dist4 < 4 then
                ESX.ShowAdvancedNotification("Garde Pharmacie", "Vehicule ranger !", "", "CHAR_MP_MORS_MUTUAL", 1)
                DeleteEntity(veh)
            end 
            end
            end)
			RageUI.Button("~o~Sortir~w~ le 4X4 ", "~o~Pour sortir le 4X4", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
				if (Selected) then
				ESX.ShowAdvancedNotification("Garde Pharmacie", "Le vehicule arrive !", "", "CHAR_MP_MORS_MUTUAL", 1) 
				Citizen.Wait(2000)   
				spawnuniCar("rover")
				ESX.ShowAdvancedNotification("Garde Pharmacie", "Abimez pas le véhicule !", "", "CHAR_MP_MORS_MUTUAL", 1) 
				end
			end)  
			
			RageUI.Button("~o~Sortir~w~ une camionette", "~o~Pour sortir la Camionette", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
				if (Selected) then
				ESX.ShowAdvancedNotification("Garde Pharmacie", "Le vehicule arrive !", "", "CHAR_MP_MORS_MUTUAL", 1) 
				Citizen.Wait(2000)   
				spawnuniCar2("speedo")
				ESX.ShowAdvancedNotification("Garde Pharmacie", "Abimez pas le véhicule !", "", "CHAR_MP_MORS_MUTUAL", 1) 
				end
			end) 
            

            
        end, function()
        end)
		
            Citizen.Wait(0)
        end
    end)

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
    

    
                local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
                local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Config.pos.garage.position.x, Config.pos.garage.position.y, Config.pos.garage.position.z)
            if dist3 <= 4.0 then
				DrawMarker(20, 311.12, -1073.77, 28.41+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 0, 255, 0, 1, 2, 0, nil, nil, 0)
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'pharmacien' then    
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au ~o~garage")
                    if IsControlJustPressed(1,51) then           
                        RageUI.Visible(RMenu:Get('garagePharmacie', 'main'), not RageUI.Visible(RMenu:Get('garagePharmacie', 'main')))
                    end   
                end
               end 
        end
end)

function spawnuniCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, Config.pos.spawnvoiture.position.x, Config.pos.spawnvoiture.position.y, Config.pos.spawnvoiture.position.z, Config.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "pharma"
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1) 
end

function spawnuniCar2(car2)
    local car2 = GetHashKey(car2)

    RequestModel(car2)
    while not HasModelLoaded(car2) do
        RequestModel(car2)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle2 = CreateVehicle(car2, Config.pos.spawnvoiture.position.x, Config.pos.spawnvoiture.position.y, Config.pos.spawnvoiture.position.z, Config.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle2, true, true)
    local plaque = "pharma2"
    SetVehicleNumberPlateText(vehicle2, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle2,-1) 
end

---------------------------------------------------------------------------------------
-- misc functions --
---------------------------------------------------------------------------------------

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

function Breaking(text)
		SetTextColour(255, 255, 255, 255)
		SetTextFont(8)
		SetTextScale(1.2, 1.2)
		SetTextWrap(0.0, 1.0)
		SetTextCentre(false)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 205)
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(0.2, 0.85)
end

function Notification(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0, 1)
end

function DisplayNotification(string)
	SetTextComponentFormat("STRING")
	AddTextComponentString(string)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function traitementlsd()
    if not traitementlsd then
        traitementlsd = true
    while traitementlsd do
            Citizen.Wait(3000)
            TriggerServerEvent('clsd')
    end
    else
        traitementlsdpossible = false
    end
end

function roulerlsd()
    if not roulerlsd then
        roulerlsd = true
    while roulerlsd do
            Citizen.Wait(2000)
            ExecuteCommand('e nervous')
            TriggerServerEvent('clsd')
    end
    else
        traitementpossible = false
    end
end

