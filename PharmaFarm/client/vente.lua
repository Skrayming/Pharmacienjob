ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

ConfigVentePharma              = {}
ConfigVentePharma.DrawDistance = 50
ConfigVentePharma.Size         = {x = 0.6, y = 0.6, z = 0.6}
ConfigVentePharma.Color        = {r = 0, g = 0, b = 180}
ConfigVentePharma.Type         = 22

local position = {
    {x = 81.61, y = -1614.88,  z = 29.78}        
}  

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords, letSleep = GetEntityCoords(PlayerPedId()), true

        for k in pairs(position) do
            if (ConfigVentePharma.Type ~= -1 and GetDistanceBetweenCoords(coords, position[k].x, position[k].y, position[k].z, true) < ConfigVentePharma.DrawDistance) then
                DrawMarker(ConfigVentePharma.Type, position[k].x, position[k].y, position[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ConfigVentePharma.Size.x, ConfigVentePharma.Size.y, ConfigVentePharma.Size.z, ConfigVentePharma.Color.r, ConfigVentePharma.Color.g, ConfigVentePharma.Color.b, 100, false, true, 2, false, false, false, false)
                letSleep = false
            end
        end

        if letSleep then
            Citizen.Wait(500)
        end
    end
end)

RMenu.Add('ventepharma', 'main', RageUI.CreateMenu("~b~Vente Médical", "Vente"))


Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('ventepharma', 'main'), true, true, true, function()

            RageUI.Button("Vendre ~b~Géllule décontractante Paracétamol", nil, {RightLabel = "~b~>>"},true, function(Hovered, Active, Selected)
                if (Selected) then   
                    TriggerServerEvent('sellgellule')
                end
            end)


            RageUI.Button("Vendre ~r~décontractant Morphine", nil, {RightLabel = "~r~>>"},true, function(Hovered, Active, Selected)
                if (Selected) then   
                    TriggerServerEvent('sellmorphine')
                end
            end)

            RageUI.Button("Vendre ~b~Doliprane", nil, {RightLabel = "~b~>>"},true, function(Hovered, Active, Selected)
                if (Selected) then   
                    TriggerServerEvent('selldoliprane')
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
    
            for k in pairs(position) do
    
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)
    
                if dist <= 1.0 then
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder à la vente  ~b~Medical")
                    if IsControlJustPressed(1,51) then
                        RageUI.Visible(RMenu:Get('ventepharma', 'main'), not RageUI.Visible(RMenu:Get('ventepharma', 'main')))
                    end   
                end
            end
        end
    end)
