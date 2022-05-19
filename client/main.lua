frameworkObject = nil

Citizen.CreateThread(function()
    frameworkObject = GetFrameworkObject() 
      
    if Config.frameworkObject == 'esx' then 
	while frameworkObject.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
    PlayerData = frameworkObject.GetPlayerData()
    end
	
end)




Citizen.CreateThread(function()
    for _,v in pairs(Config.Craft) do    
     
         RequestModel(v.npcHash)
         while not HasModelLoaded(v.npcHash) do
        
           Wait(1)
         end

 
         ped =  CreatePed(4,v.npcHash, v.coords.x,v.coords.y,v.coords.z-1, 3374176, false, true)
         SetEntityHeading(ped,v.npcHeading)
         FreezeEntityPosition(ped, true)
         SetEntityInvincible(ped, true)

         SetBlockingOfNonTemporaryEvents(ped, true)
   end

end)


Citizen.CreateThread(function()
    if Config.frameworkObject == 'esx' then 
        while true do
            local sleep = 2000
            local ped = PlayerPedId()
            for k,v in pairs(Config.Craft) do
                local Distance = #(GetEntityCoords(ped)- v.coords) 
                if Distance <= 3.0 then
                    sleep  = 0 
                    DrawText3D(v.coords.x,v.coords.y,v.coords.z + 0.98,"[E] CRAFT")
                    if IsControlJustReleased(0, 38) then
                        PlayerData = frameworkObject.GetPlayerData()   
                        frameworkObject.TriggerServerCallback('codem-craft:getxP', function(xp,time)
                            openUI(xp,time,PlayerData)
                        end)
                    end

                end
            end
            Citizen.Wait(sleep)
        end
    else 
        while true do
            local sleep = 2000
            local ped = PlayerPedId()
            for k,v in pairs(Config.Craft) do
                local Distance = #(GetEntityCoords(ped)- v.coords) 
                if Distance <= 3.0 then
                    sleep  = 0 
                    DrawText3D(v.coords.x,v.coords.y,v.coords.z + 0.98,"[E] CRAFT")
                    if IsControlJustReleased(0, 38) then
                        frameworkObject.Functions.TriggerCallback("codem-craft:items", function(data)
                            frameworkObject.Functions.TriggerCallback('codem-craft:getxP', function(xp,time)
                                openUI2(xp,time,data)
                            end)
                        end)
                    end

                end
            end
            Citizen.Wait(sleep)
        end
    end
end)


function openUI(xp,time,PlayerData)
    SetNuiFocus(true,true)
    SendNUIMessage({
        type = "SET_DATA",
        data = Config.CraftItem,
        categories = Config.Categories,
        xp = xp,
        sunucusaati = time,
        playerinventory = PlayerData.inventory,
        framework = 'esx'
    })
end

function openUI2(xp,time,PlayerData)

    SetNuiFocus(true,true)
    SendNUIMessage({
        type = "SET_DATA",
        data = Config.CraftItem,
        categories = Config.Categories,
        xp = xp,
        sunucusaati = time,
        playerinventory = PlayerData,
        framework = 'qb'

    })
end

RegisterNUICallback('sendItem', function(data)
    local item =  data.weaponName
    local itemtime = tonumber(data.weaponMinute)
    local itemlabel = data.weaponLabel
    local gerekliitem = data.itemName
    local image = data.imagesbig
    local xp = tonumber(data.xpweapon)
    TriggerServerEvent('codem-craft:sendItem',item,itemtime,itemlabel,gerekliitem,image,xp)
end)
RegisterNUICallback('escape', function(data)
    SetNuiFocus(false, false)
end)
RegisterNUICallback('claimitem', function(data)
    local item =  data.claimitem
    local itemid = tonumber(data.claimid)
    TriggerServerEvent('codem-craft:addItem',item,itemid)
end)


RegisterNUICallback('getAwating', function(data,cb)
  
    if Config.frameworkObject == 'esx' then 
        getData()
    else 
        getData2()
    end
end)    

function getData()
    frameworkObject.TriggerServerCallback('codem-craft:getData', function(data)
            
        SendNUIMessage({
            type = "AWAITING_DATA",
            sqldata = data
        })
    end)
end

function getData2()
    frameworkObject.Functions.TriggerCallback('codem-craft:getData', function(data)
       
        SendNUIMessage({
            type = "AWAITING_DATA",
            sqldata = data
        })
    end)
end
RegisterNetEvent('codem-craft:refreshPageAwating')
AddEventHandler('codem-craft:refreshPageAwating', function()
    if Config.frameworkObject == 'esx' then 
    getData()
    else 

        getData2()
    end
end)



RegisterNetEvent("codem-cyberhud:Notify123")
AddEventHandler("codem-cyberhud:Notify123", function(message, type, time)
    SendNUIMessage({
        type = "send_notification",
        message = message,
        notifytype = type,
        time = time,
    })
end)