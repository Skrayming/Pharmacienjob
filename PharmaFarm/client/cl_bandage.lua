ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

--marker
Configtissue            = {}
Configtissue.DrawDistance = 25
Configtissue.Size         = {x = 0.5, y = 0.5, z = 0.5}
Configtissue.Color        = {r = 0, g = 0, b = 180}
Configtissue.Type         = 22

local position = {
    {x = 1697.68, y = 4822.31,  z = 42.06},--recolte vieux tissue  
    {x = 3558.48, y = 3669.10,  z = 28.12}
}  

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords, letSleep = GetEntityCoords(PlayerPedId()), true

        for k in pairs(position) do
            if (Configtissue.Type ~= -1 and GetDistanceBetweenCoords(coords, position[k].x, position[k].y, position[k].z, true) < Configtissue.DrawDistance) then
                DrawMarker(Configtissue.Type, position[k].x, position[k].y, position[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Configtissue.Size.x, Configtissue.Size.y, Configtissue.Size.z, Configtissue.Color.r, Configtissue.Color.g, Configtissue.Color.b, 100, false, true, 2, false, false, false, false)
                letSleep = false
            end
        end

        if letSleep then
            Citizen.Wait(500)
        end
    end
end)
--marker

RMenu.Add('tissue', 'recolte', RageUI.CreateMenu("~b~tissue", "Récolte"))
RMenu.Add('tissue', 'traitement', RageUI.CreateMenu("~b~tissue", "Confection"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('tissue', 'recolte'), true, true, true, function()

                RageUI.Button("Récolter du ~b~vieux tissue", " ", {}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        ExecuteCommand("e mechanic")
                        ESX.ShowNotification("~b~1ere Récolte en cours... ~g~(6sec)")
                        ESX.ShowNotification("~b~Récolte suivante  ~g~(3sec)")   
                        Citizen.Wait(3000)
                        recoltetissue()
                        RageUI.CloseAll()
                    end
                end)
            end, function()
            end)

                RageUI.IsVisible(RMenu:Get('tissue', 'traitement'), true, true, true, function()

                    RageUI.Button("Pour traiter le ~b~tissue", " ", {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            ExecuteCommand("e parkingmeter")
                            ESX.ShowNotification("~b~1er traitement en cours... ~g~(6sec)")
                            ESX.ShowNotification("~b~Traitement suivante  ~g~(3sec)")   
                            Citizen.Wait(3000)
                            traitementtissue()
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.Button("Pour faire des ~g~bandes medical", " ", {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            ExecuteCommand("e parkingmeter")
                            ESX.ShowNotification("~b~1ere fabrication en cours... ~g~(6sec)")
                            ESX.ShowNotification("~b~Fabrication suivante  ~g~(3sec)")   
                            Citizen.Wait(3000)
                            traitementbandes()
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

    local recoltetissuepossible = false
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        while true do
            Wait(0)
    
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                if IsEntityAtCoord(PlayerPedId(), 1697.68, 4822.31, 42.06, 1.5, 1.5, 1.5, 0, 1, 0) then 
                    
                          RageUI.Text({
                            message = "[~b~E~w~] Récolter du ~b~vieux tissue",
                            time_display = 1
                        })
                            if IsControlJustPressed(1, 51) then
                                RageUI.Visible(RMenu:Get('tissue', 'recolte'), not RageUI.Visible(RMenu:Get('tissue', 'recolte')))
                            end
                        else
                            recoltetissuepossible = false
                           end
                   end    
           end)

           local traitementtissuepossible = false
           local traitementbandespossible = false
            Citizen.CreateThread(function()
                local playerPed = PlayerPedId()
                while true do
                    Wait(0)
            
                        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                        if IsEntityAtCoord(PlayerPedId(), 3558.52, 3669.08, 28.12, 1.5, 1.5, 1.5, 0, 1, 0) then 

                                   RageUI.Text({
                                    message = "[~b~E~w~] Traitement du tissue",
                                    time_display = 1
                                })
                                    if IsControlJustPressed(1, 51) then
                                        RageUI.Visible(RMenu:Get('tissue', 'traitement'), not RageUI.Visible(RMenu:Get('tissue', 'traitement')))
                                    end
                                else
                                    traitementtissuepossible = false
                                    traitementbandespossible = false
                                end
                            end    
                    end)
    

function notify(text)
   SetNotificationTextEntry('STRING')
   AddTextComponentString(text)
   DrawNotification(false, false)
end

function recoltetissue()
    if not recoltetissuepossible then
        recoltetissuepossible = true
    while recoltetissuepossible do
            ExecuteCommand('e mechanic')
            Citizen.Wait(3000)
            TriggerServerEvent('rtissue')
    end
    else
        recoltetissuepossible = false
    end
end

function traitementtissue()
    if not traitementtissuepossible then
        traitementtissuepossible = true
    while traitementtissuepossible do
            ExecuteCommand('e parkingmeter')
            Citizen.Wait(6000)
            TriggerServerEvent('ttissue')
    end
    else
        traitementtissuepossible = false
    end
end

function traitementbandes()
    if not traitementbandespossible then
        traitementbandespossible = true
    while traitementbandespossible do
            ExecuteCommand('e parkingmeter')
            Citizen.Wait(6000)
            TriggerServerEvent('tbandes')
    end
    else
        traitementbandespossible = false
    end
end


