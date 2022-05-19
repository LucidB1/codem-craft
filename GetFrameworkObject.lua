function GetFrameworkObject()
    local object = nil
    if Config.frameworkObject == "esx" then
        while object == nil do
            TriggerEvent('esx:getSharedObject', function(obj) object = obj end)
            Citizen.Wait(0)
        end
    end

    if Config.frameworkObject == "infinity" then
        object = exports["esx_infinity"]:GetObject()
    end

    if Config.frameworkObject == "newqb" then
        object = exports["qb-core"]:GetCoreObject()
    end
    if Config.frameworkObject == "oldqb" then
        while object == nil do
            TriggerEvent('QBCore:GetObject', function(obj) object = obj end)
            Citizen.Wait(200)
        end
    end
    return object
end


