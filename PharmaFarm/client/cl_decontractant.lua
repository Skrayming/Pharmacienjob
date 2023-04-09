ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

--marker
Configmorphine            = {}
Configmorphine .DrawDistance = 25
Configmorphine .Size         = {x = 0.5, y = 0.5, z = 0.5}
Configmorphine .Color        = {r = 180, g = 0, b = 0}
Configmorphine .Type         = 22

local position = {
    {x = 3608.30, y = 3727.91,  z = 29.68},--morphine   
    {x = 3535.56, y = 3662.79,  z = 28.12}--confection decontractant 
}  

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords, letSleep = GetEntityCoords(PlayerPedId()), true

        for k in pairs(position) do
            if (Configmorphine.Type ~= -1 and GetDistanceBetweenCoords(coords, position[k].x, position[k].y, position[k].z, true) < Configmorphine.DrawDistance) then
                DrawMarker(Configmorphine.Type, position[k].x, position[k].y, position[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Configmorphine.Size.x, Configmorphine.Size.y, Configmorphine.Size.z, Configmorphine.Color.r, Configmorphine.Color.g, Configmorphine.Color.b, 100, false, true, 2, false, false, false, false)
                letSleep = false
            end
        end

        if letSleep then
            Citizen.Wait(500)
        end
    end
end)
--marker

RMenu.Add('morphine', 'recolte', RageUI.CreateMenu("~r~Morphine", "Récolte"))
RMenu.Add('decontractant', 'traitement', RageUI.CreateMenu("~r~Decontractant", "Confection"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('morphine', 'recolte'), true, true, true, function()

                RageUI.Button("Récupérer de la ~r~Morphine", " ", {}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        ExecuteCommand("e mechanic")
                        ESX.ShowNotification("~r~1ere Récolte en cours... ~g~(6sec)")
                        ESX.ShowNotification("~r~Récolte suivante  ~g~(3sec)")   
                        Citizen.Wait(3000)
                        recoltemorphine()
                        RageUI.CloseAll()
                    end
                end)
            end, function()
            end)

                RageUI.IsVisible(RMenu:Get('decontractant', 'traitement'), true, true, true, function()

                    RageUI.Button("Décontractant a base de ~r~Morphine", " ", {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            ExecuteCommand("e parkingmeter")
                            ESX.ShowNotification("~r~1ere confection  ~g~(10sec)")
                            ESX.ShowNotification("~r~Confection suivants  ~g~(5sec)")   
                            Citizen.Wait(5000)
                            traitementdecontractantM()
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.Button("Décontractant a base de ~b~Paracétamol", " ", {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            ExecuteCommand("e parkingmeter")
                            ESX.ShowNotification("~b~1er Sachet remplis en  ~g~(10sec)")
                            ESX.ShowNotification("~b~Sachet suivants  ~g~(5sec)")   
                            Citizen.Wait(5000)
                            traitementdecontractantP()
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

    local recoltemorphinepossible = false
    Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            while true do
                Wait(0)
    
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                if IsEntityAtCoord(PlayerPedId(), 3608.30, 3727.91, 29.68, 1.5, 1.5, 1.5, 0, 1, 0) then 
                    
                          RageUI.Text({
                            message = "[~r~E~w~] Récupérer de la ~r~Morphine",
                            time_display = 1
                        })
                            if IsControlJustPressed(1, 51) then
                                RageUI.Visible(RMenu:Get('morphine', 'recolte'), not RageUI.Visible(RMenu:Get('morphine', 'recolte')))
                            end
                        else
                            recoltemorphinepossible = false
                           end
                   end    
           end)

           local traitementdecontractantMpossible = false
           local traitementdecontractantPpossible = false
            Citizen.CreateThread(function()
                local playerPed = PlayerPedId()
                while true do
                    Wait(0)
            
                        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                        if IsEntityAtCoord(PlayerPedId(), 3535.56, 3662.79, 28.12, 1.5, 1.5, 1.5, 0, 1, 0) then 

                                   RageUI.Text({
                                    message = "[~r~E~w~] Confectionner des ~r~Décontractant",
                                    time_display = 1
                                })
                                    if IsControlJustPressed(1, 51) then
                                        RageUI.Visible(RMenu:Get('decontractant', 'traitement'), not RageUI.Visible(RMenu:Get('decontractant', 'traitement')))
                                    end
                                else
                                    traitementdecontractantMpossible = false
                                    traitementdecontractantPpossible = false
                                end
                            end    
                    end)


function notify(text)
   SetNotificationTextEntry('STRING')
   AddTextComponentString(text)
   DrawNotification(false, false)
end

function recoltemorphine()
    if not recoltemorphinepossible then
        recoltemorphinepossible = true
    while recoltemorphinepossible do
            Citizen.Wait(5000)
            TriggerServerEvent('rmorphine')
    end
    else
        recoltemorphinepossible = false
    end
end

function traitementdecontractantM()
    if not traitementdecontractantMpossible then
        traitementdecontractantMpossible = true
    while traitementdecontractantMpossible do
            Citizen.Wait(5000)
            TriggerServerEvent('tmorphine')
    end
    else
        traitementdecontractantMpossible = false
    end
end

function traitementdecontractantP()
    if not traitementdecontractantPpossible then
        traitementdecontractantPpossible = true
    while traitementdecontractantPpossible do
            Citizen.Wait(5000)
            TriggerServerEvent('tdpara')
    end
    else
        traitementdecontractantPpossible = false
    end
end
