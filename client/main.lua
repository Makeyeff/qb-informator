local QBCore = exports['qb-core']:GetCoreObject()
local Config = Config
local blip
local entityZone
local entPed

local function deletePedInformator()
    if not blip and not entityZone and not entPed then
        return
    end

    QBCore.Functions.TriggerCallback("qb-informator:server:deletePedInformator", function()
        if blip then
            RemoveBlip(blip)
            blip = nil
        end
        entPed = nil
        if entityZone then
            entityZone:destroy()
            entityZone = nil
        end
    end)
    Wait(1000)
end

local function createBlip()
    if blip then
        -- if blip created
        return
    end

    local PlayerData = QBCore.Functions.GetPlayerData()

    if PlayerData and PlayerData.job and 'leo' == PlayerData.job.type then
        -- if cops
        return
    end

    blip = AddBlipForEntity(entPed)
    SetBlipSprite(blip, 480)
    SetBlipDisplay(blip, 6)
    SetBlipScale(blip, 0.65)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 28)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Lang:t("informator.blip"))
    EndTextCommandSetBlipName(blip)
    Wait(1000)
end

local function pointInsideMenu()
    QBCore.Functions.Notify(Lang:t('informator.inZone'), 'success')
end

local function createBoxZone()
    if entityZone then
        return
    end

    local coords = GetEntityCoords(entPed)
    entityZone = BoxZone:Create(coords, 0.5, 1.5, {
        name = "box_zone",
        offset = {1, 0.0, 0.0, 0.0, 0.0, 0.0},
        debugPoly = true,
        minz = coords.z,
        maxZ = coords.z + 1
    })
    if (entityZone) then
        entityZone:onPlayerInOut(function(isPointInside, point, zone)
            if isPointInside then
                pointInsideMenu()
            end
        end)
    end
    Wait(1000)
end

local function createPedInformator()
    if entPed then
        return
    end
    QBCore.Functions.TriggerCallback("qb-informator:server:createPedInformator", function(netId, isCreate)
        if not entPed then
            entPed = NetToEnt(netId)
            SetEntityInvincible(entPed, true)
            SetBlockingOfNonTemporaryEvents(entPed, true)
            FreezeEntityPosition(entPed, true)
            Wait(1000)

        end
        if not blip then
            createBlip()
        end
        if not entityZone then
            createBoxZone()

        end
    end)
end

CreateThread(function()
    local PlayerData = QBCore.Functions.GetPlayerData()

    while not PlayerData do
        PlayerData = QBCore.Functions.GetPlayerData()
        Wait(1000)
    end
    while not PlayerData.job do
        PlayerData = QBCore.Functions.GetPlayerData()
        Wait(1000)
    end

    Wait(5000)

    while (not HasModelLoaded(GetHashKey(Config.model))) do
        RequestModel(GetHashKey(Config.model))
        Wait(100)
    end

    local deletePedTime = Config.deletePedTime
    local createPedTime = Config.createPedTime

    while true do
        local hours = GetClockHours()
        if hours >= deletePedTime and hours < createPedTime then
            deletePedInformator()
        else
            createPedInformator()
        end
        Wait(Config.update)
    end
end)
