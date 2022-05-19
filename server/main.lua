frameworkObject = nil

function ExecuteSql(query)
    local IsBusy = true
    local result = nil
    if Config.Mysql == "oxmysql" then
        if MySQL == nil then
            exports.oxmysql:execute(query, function(data)
                result = data
                IsBusy = false
            end)
        else
            MySQL.query(query, {}, function(data)
                result = data
                IsBusy = false
            end)
        end
    elseif Config.Mysql == "mysql-async" then
        MySQL.Async.fetchAll(query, {}, function(data)
            result = data
            IsBusy = false
        end)
    end
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end

RegisterServerEvent('codem-craft:sendItem')
AddEventHandler('codem-craft:sendItem', function(a, b, c, d, e, f)
    if Config.frameworkObject == 'esx' then
        local src = source
        frameworkObject = GetFrameworkObject()
        local xPlayer = frameworkObject.GetPlayerFromId(src)
        local identifier = xPlayer.identifier
        local time = os.time()
        local deneme = json.decode(d)
        local success = true
        local itemtest

        for k, v in pairs(deneme) do
            local items = xPlayer.getInventoryItem(v.name)
            if items ~= nil and tonumber(items.count) >= tonumber(v.amount) then
                xPlayer.removeInventoryItem(v.name, tonumber(v.amount))
            else
                success = false
            end
        end

        if success then
            TriggerClientEvent("codem-cyberhud:Notify123", src, Config.Notifications["success"]["message"],
                Config.Notifications["success"]["type"], Config.Notifications["success"]["time"])
            local data = ExecuteSql(
                "INSERT INTO `codem_craft` (`identifier`,`weaponname`,`weapontime`,`weaponlabel`,`itemTime`,`images`) VALUES ('" ..
                    identifier .. "','" .. a .. "','" .. b .. "','" .. c .. "','" .. time .. "','" .. e .. "')")

            local item = ExecuteSql("SELECT * FROM users WHERE identifier = '" .. identifier .. "'")
            if item[1] then
                ExecuteSql("UPDATE  `users` SET `craftxp` = '" .. item[1].craftxp + f .. "' WHERE `identifier` = '" ..
                               identifier .. "'")

            end

        else
            TriggerClientEvent("codem-cyberhud:Notify123", src, Config.Notifications["error"]["message"],
                Config.Notifications["error"]["type"], Config.Notifications["error"]["time"])
        end

    else
        local src = source
        frameworkObject = GetFrameworkObject()
        local xPlayer = frameworkObject.Functions.GetPlayer(src)
        local identifier = xPlayer.PlayerData.citizenid
        local time = os.time()
        local deneme = json.decode(d)
        local success = true

        local devam = true
        for k, v in pairs(deneme) do

            local slots = frameworkObject.Player.GetSlotsByItem(xPlayer.PlayerData.items, v.name)
            if slots then
                for _, slot in pairs(slots) do
                    if xPlayer.PlayerData.items[slot].amount > tonumber(v.amount) then

                    else
                        devam = false
                    end
                end
                if devam then
                    xPlayer.Functions.RemoveItem(v.name, tonumber(v.amount), false)
                end
            end
        end
        if devam then
            TriggerClientEvent("codem-cyberhud:Notify123", src, Config.Notifications["success"]["message"],
                Config.Notifications["success"]["type"], Config.Notifications["success"]["time"])
            local data = ExecuteSql(
                "INSERT INTO `codem_craft` (`identifier`,`weaponname`,`weapontime`,`weaponlabel`,`itemTime`,`images`) VALUES ('" ..
                    identifier .. "','" .. a .. "','" .. b .. "','" .. c .. "','" .. time .. "','" .. e .. "')")

            local item = ExecuteSql("SELECT * FROM players WHERE citizenid = '" .. identifier .. "'")
            if item[1] then
                ExecuteSql("UPDATE  `players` SET `craftxp` = '" .. item[1].craftxp + f .. "' WHERE `citizenid` = '" ..
                               identifier .. "'")

            end
        else
            TriggerClientEvent("codem-cyberhud:Notify", src, Config.Notifications["error"]["message"],
                Config.Notifications["error"]["type"], Config.Notifications["error"]["time"])
        end

    end
end)
RegisterServerEvent('codem-craft:addItem')
AddEventHandler('codem-craft:addItem', function(a, b)
    if Config.frameworkObject == 'esx' then
        local src = source
        frameworkObject = GetFrameworkObject()
        local xPlayer = frameworkObject.GetPlayerFromId(src)
        local identifier = xPlayer.identifier

        xPlayer.addInventoryItem(a, 1)

        ExecuteSql("DELETE FROM `codem_craft` WHERE `id` = '" .. b .. "'")
        TriggerClientEvent('codem-craft:refreshPageAwating', src)
    elseif Config.frameworkObject == 'infinity' then
        local src = source
        frameworkObject = GetFrameworkObject()
        local xPlayer = frameworkObject.GetPlayerFromId(src)
        local identifier = xPlayer.identifier

        xPlayer.addItem(a, 1)

        ExecuteSql("DELETE FROM `codem_craft` WHERE `id` = '" .. b .. "'")
        TriggerClientEvent('codem-craft:refreshPageAwating', src)
    else
        local src = source
        frameworkObject = GetFrameworkObject()
        local xPlayer = frameworkObject.Functions.GetPlayer(src)

        xPlayer.Functions.AddItem(a, 1)

        ExecuteSql("DELETE FROM `codem_craft` WHERE `id` = '" .. b .. "'")
        TriggerClientEvent('codem-craft:refreshPageAwating', src)

    end

end)

Citizen.CreateThread(function()
    frameworkObject = GetFrameworkObject()
    if Config.frameworkObject == 'esx' then
        frameworkObject.RegisterServerCallback('codem-craft:getData', function(source, cb)
            local xPlayer = frameworkObject.GetPlayerFromId(source)

            local item = ExecuteSql("SELECT * FROM codem_craft WHERE identifier = '" .. xPlayer.identifier .. "'")
            if item then
                cb(item)
            end
        end)
    elseif Config.frameworkObject == 'infinity' then
        frameworkObject.OnRequest('codem-craft:getData', function(source, cb)
            local xPlayer = frameworkObject.GetPlayerFromId(source)

            local item = ExecuteSql("SELECT * FROM codem_craft WHERE identifier = '" .. xPlayer.identifier .. "'")
            if item then
            cb(item)
            end
        end)
    else

        frameworkObject.Functions.CreateCallback('codem-craft:getData', function(source, cb)
            local xPlayer = frameworkObject.Functions.GetPlayer(source)
            local identifier = xPlayer.PlayerData.citizenid

            local item = ExecuteSql("SELECT * FROM codem_craft WHERE identifier = '" .. identifier .. "'")
            if item then
                cb(item)
            end
        end)
    end

end)

Citizen.CreateThread(function()
    frameworkObject = GetFrameworkObject()
    if Config.frameworkObject == 'esx' then
        frameworkObject.RegisterServerCallback('codem-craft:getxP', function(source, cb)
            local xPlayer = frameworkObject.GetPlayerFromId(source)
            local time = os.time()
            local item = ExecuteSql("SELECT * FROM users WHERE identifier = '" .. xPlayer.identifier .. "'")
            if item[1] then

                cb(item[1].craftxp, time)
            end
        end)
    elseif Config.frameworkObject == 'infinity' then
        frameworkObject.OnRequest('codem-craft:getxP', function(source, cb)
            local xPlayer = frameworkObject.GetPlayerFromId(source)
            local time = os.time()
            local item = ExecuteSql("SELECT * FROM users WHERE identifier = '" .. xPlayer.identifier .. "'")
            if item[1] then
                cb(item[1].craftxp, time)
            end
        end)
    else
        frameworkObject.Functions.CreateCallback('codem-craft:getxP', function(source, cb)
            local xPlayer = frameworkObject.Functions.GetPlayer(source)
            local identifier = xPlayer.PlayerData.citizenid
            local time = os.time()
            local item = ExecuteSql("SELECT * FROM players WHERE `citizenid` = '" .. identifier .. "'")
            if item[1] then

                cb(item[1].craftxp, time)
            end
        end)
    end

end)

Citizen.CreateThread(function()
    if Config.frameworkObject ~= 'esx' and Config.frameworkObject ~= 'infinity' then
        frameworkObject = GetFrameworkObject()
        frameworkObject.Functions.CreateCallback('codem-craft:items', function(source, cb)
            local src = source
            local xPlayer = frameworkObject.Functions.GetPlayer(src)

            local item = xPlayer.PlayerData.items

            cb(item)
        end)
    end
end)

