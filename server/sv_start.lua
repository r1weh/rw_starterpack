ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 

ESX.RegisterServerCallback('rw_starterpack:check', function(source,cb) 
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
    local _riweh = ESX.GetPlayerFromId(_rw)
    _riweh.addInventoryItem('box', 1)
    TriggerClientEvent("rri-notify:Icon",_riweh._rw,"Selamat Anda Mendapatkan Hadiah ^^","top-right",2500,"blue-10","white",true,"mdi-bank")
    updateUser(_rw, function(result)
        if result then
        end
    end)
end)

ESX.RegisterUsableItem('box', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    for k,v in pairs(Config.items) do
      xPlayer.addInventoryItem(v, 15)
      xPlayer.addInventoryItem('phone', 1)
	  xPlayer.removeInventoryItem("box", 1)
    end
end)

RegisterServerEvent("antirpquestion:success")
AddEventHandler("antirpquestion:success", function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local model = Config.vehicleModel
    
    MySQL.Async.execute("UPDATE users SET riweh_rp='made' WHERE identifier = @username", {
        ['@username'] = xPlayer.identifier
    }, function()
    end)

    MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
        ['@owner']   = xPlayer.identifier,
        ['@plate']   = plate,
        ['@vehicle'] = json.encode({model = GetHashKey(model), plate = plate})
    }, function(rowsChanged)
        TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Kamu memiliki kendaraan "..plate.." sekarang!","top-right",2500,"blue-10","white",true,"mdi-alert-box")
        --TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Kamu memiliki kendaraan '..plate..' sekarang!'})
    end)

    xPlayer.addAccountMoney('money', 200000)
    TriggerClientEvent("rri-notify:Icon",xPlayer.source,"Kamu Mendapatkan Rp 200.000","top-right",2500,"blue-10","white",true,"mdi-bank")
end)