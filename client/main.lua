local QBCore = exports['qb-core']:GetCoreObject()
local Config = Config
local blip
local entityZone
local entPed

local function deletePedInformator()
    QBCore.Functions.TriggerCallback("qb-informator:server:deletePedInformator", function()
        if blip then
            RemoveBlip(blip)
            blip = nil
            entPed = nil
            entityZone = nil
        end
    end)
end

local function createBlip()
    if blip then
        -- if blip created
        return
    end

    local PlayerData = QBCore.Functions.GetPlayerData()

    if 'leo' == PlayerData.job.type then
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

    entityZone = EntityZone:Create(entPed, {
        name = "entityZone",
        debugPoly = false
    })
    if (entityZone) then
        entityZone:onPlayerInOut(function(isPointInside, point, zone)
            print("combo: isPointInside is", isPointInside, " for point", point)
            if isPointInside then
                QBCore.Functions.Notify(Lang:t('informator.inZone'), 'success')
            end
        end)
    end

end

local function createPedInformator()
    QBCore.Functions.TriggerCallback("qb-informator:server:createPedInformator", function(netId, isCreate)
        if not entPed then
            entPed = NetToEnt(netId)
            SetEntityInvincible(entPed, true)
            SetBlockingOfNonTemporaryEvents(entPed, true)
            FreezeEntityPosition(entPed, true)
            createBlip()
        end
    end)
end

CreateThread(function()
    while (not HasModelLoaded(GetHashKey(Config.model))) do
        RequestModel(GetHashKey(Config.model))
        Wait(100)
    end

    while true do
        local hours = GetClockHours()
        if hours >= Config.deletePedTime and hours < Config.createPedTime then
            deletePedInformator()
        else
            createPedInformator()
        end
        Wait(1000)
    end
end)
