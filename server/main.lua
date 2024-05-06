QBCore = exports['qb-core']:GetCoreObject()
local Config = Config

local ped

QBCore.Functions.CreateCallback('qb-informator:server:deletePedInformator', function(source, cb)
    if ped then
        DeleteEntity(ped)
        ped = nil
    end
    cb()
end)

QBCore.Functions.CreateCallback('qb-informator:server:createPedInformator', function(source, cb)
    if not ped then
        local randomPed = math.random(0, #(Config.coords))
        local getRandomPed = Config.coords[randomPed].coord
        ped = CreatePed(1, Config.hash, getRandomPed.x, getRandomPed.y, getRandomPed.z, getRandomPed.w, true, true)
        Wait(1000)
        cb(NetworkGetNetworkIdFromEntity(ped, true))
    else
        cb(NetworkGetNetworkIdFromEntity(ped, false))
    end
end)
