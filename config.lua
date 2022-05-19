Config = {}


Config.frameworkObject = "infinity" -- newqb, oldqb, esx, infinity
Config.Mysql = "oxmysql" -- mysql-async -- oxmysql
Config.SetCraftXpCommand = 'setxp' -- example = setxp id xp  = setxp 2 5
Config.AdminPerm = 'admin' --- admin rank
Config.Craft = {
    {npcHash = 's_m_m_ammucountry' ,coords = vector3(2306.89, 4881.82, 41.8082) , npcHeading = 31.91}
}



Config.Categories = {
    {
        name = "weapon",
        label = "Weapon",
    },
    {
        name = "ammo",
        label = "Ammo",
    },
    {
        name = "tools",
        label = "Tools",
    },
  
}

Config.CraftItem = {
    {
        itemName = 'weapon_assaultrifle_mk2',
        itemLabel = 'Assault Rifle',
        minute = 20 ,
        level = 0,
        xp = 100,
        category = 'weapon',
        required = {
            { label = 'Scrab', name = "tosti", amount = 10},
            { label = 'Aluminum', name = "tosti", amount =10},
            { label = 'Iron', name = "tosti", amount =10},
            
        },
        imagesname = 'Assault-Rifle-MK-II-Big' ,  ---- for mid image
   
    },
    {
        itemName = 'rifle_ammo',
        itemLabel = 'Rifle Ammo',
        minute = 10 ,
        level = 0,
        xp = 100,
        category = 'ammo',
        required = {
        
            { label = 'Aluminum', name = "tosti", amount =10},
            { label = 'Iron', name = "tosti", amount =10},
        },
        imagesname = 'rifle_ammo' ,  ---- for mid image
      
    },
   
 
}


function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.3, 0.3)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end


Config.Notifications = { -- Notifications
    ["success"] = {
        message = 'İtem craft başlatıldı.',
        type = "succes",
        time = 2500,
    },
  
    ["error"] = {
        message = 'İtem yok.',
        type = "error",
        time = 2500,
    },

}