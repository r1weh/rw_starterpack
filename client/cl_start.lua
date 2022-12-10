ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end 
    ESX.PlayerData = ESX.GetPlayerData()
end)

--=======================--
--======= Ped NPC =======--
--=======================--
local npcped = {
    {-1032.27, -2736.34, 19.17,"",103.57,1567728751,"s_f_y_airhostess_01"} --Ped StarterPack
}

Citizen.CreateThread(function()

    for _,v in pairs(npcped) do
      RequestModel(GetHashKey(v[7]))
      while not HasModelLoaded(GetHashKey(v[7])) do
        Wait(1)
      end
  
      ped =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
      SetEntityHeading(ped, v[5])
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
    end
end)

--=======================--
--======= qTarget =======--
--=======================--
local pedambilnya = {
    1567728751
}

exports.qtarget:AddTargetModel(pedambilnya, {
    options = {
        {
            event = "rw:ambilstarter",
            icon = "far fas fa-laptop-medical",
            label = "Ambil StarterPack",
        },
    },
    job = {"all"},
    distance = 2.5
})
--=======================--
--======= qTarget =======--
--=======================--

RegisterNetEvent('rw:ambilstarter')
AddEventHandler('rw:ambilstarter', function()
    ESX.TriggerServerCallback('rw_starterpack:check', function(hasChecked)
        if hasChecked then
            TriggerEvent("rri-notify:Icon","Kamu Sudah ambil ya!,sebelumnya!","top-right",2500,"red-10","white",true,"mdi-alert-box")
        else
            TriggerServerEvent('rw:starterpack:ambil')
            TriggerEvent('masriweh:giveRewards')
        end
    end)
end)

RegisterNetEvent('masriweh:giveRewards')
AddEventHandler('masriweh:giveRewards', function()
  local generatedPlate = GeneratePlate()
  local playerPed = PlayerPedId()

  TriggerServerEvent('antirpquestion:success', generatedPlate)

    ESX.Game.SpawnVehicle(Config.vehicleModel, Config.Zones.CarSpawn.Pos, Config.Zones.CarSpawn.Heading, function(vehicle)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    SetVehicleNumberPlateText(vehicle, generatedPlate)

    FreezeEntityPosition(playerPed, false)
    SetEntityVisible(playerPed, true)
  end)
end)

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		if Config.PlateUseSpace then
			generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. ' ' .. GetRandomNumber(Config.PlateNumbers) .. ' ' .. GetRandomLetter(Config.PlateLetters2))
		else
			generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers))
		end

		ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function(isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end

function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Citizen.Wait(0)
	end

	return callback
end

function GetRandomNumber(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end