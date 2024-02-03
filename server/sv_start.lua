CoreName= nil

if Config.Framework == 'Esx-old' then
Citizen.CreateThread(function()
    while CoreName == nil do
        TriggerEvent('esx:getSharedObject', function(obj) CoreName = obj end)
        Citizen.Wait(0)
    end 
    CoreName.PlayerData = CoreName.GetPlayerData()
end)
elseif Config.Framework == 'QbCore' then
    CoreName = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'ESX-New' then
    CoreName = exports['es_extended']:getSharedObject()
end

CoreName.Functions.CreateCallback('rw_starterpack:check', function(source,cb) 
    local _rw = source
    checkIfUsed(_rw, function(result)
        if result then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent("rw:starterpack:ambil")
AddEventHandler("rw:starterpack:ambil", function()
    local _rw = source
    local _riweh = CoreName.Functions.GetPlayer(_rw)
    _riweh.addInventoryItem('box', 1)
    updateUser(_rw, function(result)
        if result then
        end
    end)
end)

ESX.RegisterUsableItem('box', function(source)
    local xPlayer = CoreName.Functions.GetPlayer(source)
    for k,v in pairs(Config.items) do
      xPlayer.addInventoryItem(v, 15)
      xPlayer.addInventoryItem('phone', 1)
      xPlayer.removeInventoryItem("box", 1)
    end
end)

RegisterServerEvent("antirpquestion:success")
AddEventHandler("antirpquestion:success", function(plate)
    local xPlayer = CoreName.Functions.GetPlayer(source)
    local model = Config.vehicleModel
    
    MySQL.Async.execute("UPDATE users SET riweh_rp='made' WHERE identifier = @username", {
        ['@username'] = xPlayer.PlayerData.charinfo
    }, function()
    end)

    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
        ['@owner']   = xPlayer.PlayerData.charinfo,
        ['@plate']   = plate,
        ['@vehicle'] = json.encode({model = GetHashKey(model), plate = plate})
    }, function(rowsChanged)
        TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Kamu memiliki kendaraan "..plate.." sekarang!","top-right",2500,"blue-10","white",true,"mdi-alert-box")
        --TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Kamu memiliki kendaraan '..plate..' sekarang!'})
    end)

    xPlayer.addAccountMoney('money', 200000)
    TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Kamu Mendapatkan Rp 200.000","top-right",2500,"blue-10","white",true,"mdi-bank")
end)
