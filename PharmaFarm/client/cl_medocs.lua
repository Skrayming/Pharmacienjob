ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

--marker
Configmedocs            = {}
Configmedocs.DrawDistance = 25
Configmedocs.Size         = {x = 0.5, y = 0.5, z = 0.5}
Configmedocs.Color        = {r = 0, g = 180, b = 0}
Configmedocs.Type         = 22

local position = {
    {x = 3623.40, y = 3732.74,  z = 28.69},--recolte paracetamol   
    {x = 3559.97, y = 3674.43,  z = 28.12}
}  

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords, letSleep = GetEntityCoords(PlayerPedId()), true

        for k in pairs(position) do
            if (Configmedocs.Type ~= -1 and GetDistanceBetweenCoords(coords, position[k].x, position[k].y, position[k].z, true) < Configmedocs.DrawDistance) then
                DrawMarker(Configmedocs.Type, position[k].x, position[k].y, position[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Configmedocs.Size.x, Configmedocs.Size.y, Configmedocs.Size.z, Configmedocs.Color.r, Configmedocs.Color.g, Configmedocs.Color.b, 100, false, true, 2, false, false, false, false)
                letSleep = false
            end
        end

        if letSleep then
            Citizen.Wait(500)
        end
    end
end)
--marker

RMenu.Add('paracetamol', 'recolte', RageUI.CreateMenu("~b~Paracetamol", "Récolte"))
RMenu.Add('doliprane', 'traitement', RageUI.CreateMenu("~b~Doliprane", "Confection"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('paracetamol', 'recolte'), true, true, true, function()

                RageUI.Button("Récolter du ~b~Paracetamol", " ", {}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        ExecuteCommand("e mechanic")
                        ESX.ShowNotification("~b~1ere Récolte en cours... ~g~(6sec)")
                        ESX.ShowNotification("~b~Récolte suivante  ~g~(3sec)")   
                        Citizen.Wait(3000)
                        recolteparacetamol()
                        RageUI.CloseAll()
                    end
                end)
            end, function()
            end)

                RageUI.IsVisible(RMenu:Get('doliprane', 'traitement'), true, true, true, function()

                    RageUI.Button("Pour fabriquer du ~b~doliprane", " ", {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            ExecuteCommand("e parkingmeter")
                            ESX.ShowNotification("~b~1ere Récolte en cours... ~g~(6sec)")
                            ESX.ShowNotification("~b~Récolte suivante  ~g~(3sec)")   
                            Citizen.Wait(3000)
                            traitementdoliprane()
                            RageUI.CloseAll()
                        end
                    end)
                        
            end, function()
                ---Panels
            end, 1)
    
            Citizen.Wait(0)
        end
    end)



    ---------------------------------------- Position du Menu --------------------------------------------

    local recolteparacetamolpossible = false
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        while true do
            Wait(0)
    
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                if IsEntityAtCoord(PlayerPedId(), 3623.40, 3732.74, 28.69, 1.5, 1.5, 1.5, 0, 1, 0) then 
                    
                          RageUI.Text({
                            message = "[~b~E~w~] Récolter du ~b~Paracetamol",
                            time_display = 1
                        })
                            if IsControlJustPressed(1, 51) then
                                RageUI.Visible(RMenu:Get('paracetamol', 'recolte'), not RageUI.Visible(RMenu:Get('paracetamol', 'recolte')))
                            end
                        else
                            recolteparacetamolpossible = false
                           end
                   end    
           end)

           local traitementdolipranepossible = false
            Citizen.CreateThread(function()
                local playerPed = PlayerPedId()
                while true do
                    Wait(0)
            
                        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                        if IsEntityAtCoord(PlayerPedId(), 3559.92, 3674.47, 28.12, 1.5, 1.5, 1.5, 0, 1, 0) then 

                                   RageUI.Text({
                                    message = "[~b~E~w~] Récolter du ~b~Doliprane",
                                    time_display = 1
                                })
                                    if IsControlJustPressed(1, 51) then
                                        RageUI.Visible(RMenu:Get('doliprane', 'traitement'), not RageUI.Visible(RMenu:Get('doliprane', 'traitement')))
                                    end
                                else
                                    traitementdolipranepossible = false
                                end
                            end    
                    end)
    

function notify(text)
   SetNotificationTextEntry('STRING')
   AddTextComponentString(text)
   DrawNotification(false, false)
end

function recolteparacetamol()
    if not recolteparacetamolpossible then
        recolteparacetamolpossible = true
    while recolteparacetamolpossible do
            ExecuteCommand('e mechanic')
            Citizen.Wait(3000)
            TriggerServerEvent('rparacetamol')
    end
    else
        recolteparacetamolpossible = false
    end
end

function traitementdoliprane()
    if not traitementdolipranepossible then
        traitementdolipranepossible = true
    while traitementdolipranepossible do
            ExecuteCommand('e parkingmeter')
            Citizen.Wait(6000)
            TriggerServerEvent('tdoliprane')
    end
    else
        traitementdolipranepossible = false
    end
end


