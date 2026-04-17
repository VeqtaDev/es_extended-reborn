Adjustments = {}

local frameAdjustments = {
    started = false,
    disableDisplayAmmo = false,
    disableVehicleRewards = false,
    useMultipliers = false,
    applyPedDensity = false,
    applyScenarioDensity = false,
    applyAmbientVehicleRange = false,
    applyParkedVehicleDensity = false,
    applyRandomVehicleDensity = false,
    applyVehicleDensity = false,
    pedDensity = 1.0,
    scenarioPedDensityInterior = 1.0,
    scenarioPedDensityExterior = 1.0,
    ambientVehicleRange = 1.0,
    parkedVehicleDensity = 1.0,
    randomVehicleDensity = 1.0,
    vehicleDensity = 1.0,
}

local function StartFrameAdjustmentsThread()
    if frameAdjustments.started then
        return
    end

    frameAdjustments.started = true

    CreateThread(function()
        while true do
            if ESX.PlayerLoaded and ESX.PlayerData.ped and DoesEntityExist(ESX.PlayerData.ped) then
                local ped = ESX.PlayerData.ped

                if frameAdjustments.disableDisplayAmmo then
                    DisplayAmmoThisFrame(false)
                end

                if frameAdjustments.disableVehicleRewards then
                    if IsPedInAnyVehicle(ped, false) then
                        DisablePlayerVehicleRewards(ESX.playerId)
                    end
                end

                if frameAdjustments.useMultipliers then
                    if frameAdjustments.applyPedDensity then
                        SetPedDensityMultiplierThisFrame(frameAdjustments.pedDensity)
                    end

                    if frameAdjustments.applyScenarioDensity then
                        SetScenarioPedDensityMultiplierThisFrame(frameAdjustments.scenarioPedDensityInterior, frameAdjustments.scenarioPedDensityExterior)
                    end

                    if frameAdjustments.applyAmbientVehicleRange then
                        SetAmbientVehicleRangeMultiplierThisFrame(frameAdjustments.ambientVehicleRange)
                    end

                    if frameAdjustments.applyParkedVehicleDensity then
                        SetParkedVehicleDensityMultiplierThisFrame(frameAdjustments.parkedVehicleDensity)
                    end

                    if frameAdjustments.applyRandomVehicleDensity then
                        SetRandomVehicleDensityMultiplierThisFrame(frameAdjustments.randomVehicleDensity)
                    end

                    if frameAdjustments.applyVehicleDensity then
                        SetVehicleDensityMultiplierThisFrame(frameAdjustments.vehicleDensity)
                    end
                end

                Wait(0)
            else
                Wait(500)
            end
        end
    end)
end

function Adjustments:RemoveHudComponents()
    for i = 1, #Config.RemoveHudComponents do
        if Config.RemoveHudComponents[i] then
            SetHudComponentSize(i, 0.0, 0.0)
            SetHudComponentPosition(i, 900.0, 900.0)
        end
    end
end

function Adjustments:DisableAimAssist()
    if Config.DisableAimAssist then
        SetPlayerTargetingMode(3)
    end
end

function Adjustments:DisableNPCDrops()
    if Config.DisableNPCDrops then
        local weaponPickups = { `PICKUP_WEAPON_CARBINERIFLE`, `PICKUP_WEAPON_PISTOL`, `PICKUP_WEAPON_PUMPSHOTGUN` }
        for i = 1, #weaponPickups do
            ToggleUsePickupsForPlayer(ESX.playerId, weaponPickups[i], false)
        end
    end
end

function Adjustments:SeatShuffle()
    if Config.DisableVehicleSeatShuff then
        AddEventHandler("esx:enteredVehicle", function(vehicle, _, seat)
            if seat > -1 then
                SetPedIntoVehicle(ESX.PlayerData.ped, vehicle, seat)
                SetPedConfigFlag(ESX.PlayerData.ped, 184, true)
            end
        end)
    end
end

function Adjustments:HealthRegeneration()
    if Config.DisableHealthRegeneration then
        SetPlayerHealthRechargeMultiplier(ESX.playerId, 0.0)
    end
end

function Adjustments:AmmoAndVehicleRewards()
    if not Config.DisableDisplayAmmo and not Config.DisableVehicleRewards then
        return
    end

    frameAdjustments.disableDisplayAmmo = Config.DisableDisplayAmmo
    frameAdjustments.disableVehicleRewards = Config.DisableVehicleRewards
    StartFrameAdjustmentsThread()
end

function Adjustments:EnablePvP()
    if Config.EnablePVP then
        SetCanAttackFriendly(ESX.PlayerData.ped, true, false)
        NetworkSetFriendlyFireOption(true)
    end
end

function Adjustments:DispatchServices()
    if Config.DisableDispatchServices then
        for i = 1, 15 do
            EnableDispatchService(i, false)
        end
        SetAudioFlag('PoliceScannerDisabled', true)
    end
end

function Adjustments:NPCScenarios()
    if Config.DisableScenarios then
        local scenarios = {
            "WORLD_VEHICLE_ATTRACTOR",
            "WORLD_VEHICLE_AMBULANCE",
            "WORLD_VEHICLE_BICYCLE_BMX",
            "WORLD_VEHICLE_BICYCLE_BMX_BALLAS",
            "WORLD_VEHICLE_BICYCLE_BMX_FAMILY",
            "WORLD_VEHICLE_BICYCLE_BMX_HARMONY",
            "WORLD_VEHICLE_BICYCLE_BMX_VAGOS",
            "WORLD_VEHICLE_BICYCLE_MOUNTAIN",
            "WORLD_VEHICLE_BICYCLE_ROAD",
            "WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",
            "WORLD_VEHICLE_BIKER",
            "WORLD_VEHICLE_BOAT_IDLE",
            "WORLD_VEHICLE_BOAT_IDLE_ALAMO",
            "WORLD_VEHICLE_BOAT_IDLE_MARQUIS",
            "WORLD_VEHICLE_BROKEN_DOWN",
            "WORLD_VEHICLE_BUSINESSMEN",
            "WORLD_VEHICLE_HELI_LIFEGUARD",
            "WORLD_VEHICLE_CLUCKIN_BELL_TRAILER",
            "WORLD_VEHICLE_CONSTRUCTION_SOLO",
            "WORLD_VEHICLE_CONSTRUCTION_PASSENGERS",
            "WORLD_VEHICLE_DRIVE_PASSENGERS",
            "WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED",
            "WORLD_VEHICLE_DRIVE_SOLO",
            "WORLD_VEHICLE_FIRE_TRUCK",
            "WORLD_VEHICLE_EMPTY",
            "WORLD_VEHICLE_MARIACHI",
            "WORLD_VEHICLE_MECHANIC",
            "WORLD_VEHICLE_MILITARY_PLANES_BIG",
            "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
            "WORLD_VEHICLE_PARK_PARALLEL",
            "WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN",
            "WORLD_VEHICLE_PASSENGER_EXIT",
            "WORLD_VEHICLE_POLICE_BIKE",
            "WORLD_VEHICLE_POLICE_CAR",
            "WORLD_VEHICLE_POLICE",
            "WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
            "WORLD_VEHICLE_QUARRY",
            "WORLD_VEHICLE_SALTON",
            "WORLD_VEHICLE_SALTON_DIRT_BIKE",
            "WORLD_VEHICLE_SECURITY_CAR",
            "WORLD_VEHICLE_STREETRACE",
            "WORLD_VEHICLE_TOURBUS",
            "WORLD_VEHICLE_TOURIST",
            "WORLD_VEHICLE_TANDL",
            "WORLD_VEHICLE_TRACTOR",
            "WORLD_VEHICLE_TRACTOR_BEACH",
            "WORLD_VEHICLE_TRUCK_LOGS",
            "WORLD_VEHICLE_TRUCKS_TRAILERS",
            "WORLD_VEHICLE_DISTANT_EMPTY_GROUND",
            "WORLD_HUMAN_PAPARAZZI",
        }

        for i=1, #scenarios do
            SetScenarioTypeEnabled(scenarios[i], false)
        end
    end
end

function Adjustments:LicensePlates()
    SetDefaultVehicleNumberPlateTextPattern(-1, Config.CustomAIPlates)
end

local placeHolders = {
    server_name = function()
        return GetConvar("sv_projectName", "ESX-Framework")
    end,
    server_endpoint = function()
        return GetCurrentServerEndpoint() or "localhost:30120"
    end,
    server_players = function()
        return GlobalState.playerCount or 0
    end,
    server_maxplayers = function()
        return GetConvarInt("sv_maxClients", 48)
    end,
    player_name = function()
        return GetPlayerName(ESX.playerId)
    end,
    player_rp_name = function()
        return ESX.PlayerData.name or "John Doe"
    end,
    player_id = function()
        return ESX.serverId
    end,
    player_street = function()
        if not ESX.PlayerData.ped then return "Unknown" end

        local playerCoords = GetEntityCoords(ESX.PlayerData.ped)
        local streetHash = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)

        return GetStreetNameFromHashKey(streetHash) or "Unknown"
    end,
}

function Adjustments:ReplacePlaceholders(text)
    for placeholder, cb in pairs(placeHolders) do
        local success, result = pcall(cb)

        if not success then
            error(("Failed to execute placeholder: ^5%s^7\n%s"):format(placeholder, result))
            result = "Unknown"
        end

        text = text:gsub(("{%s}"):format(placeholder), tostring(result))
    end
    return text
end

function Adjustments:DiscordPresence()
    if Config.DiscordActivity.appId ~= 0 then
        CreateThread(function()
            while true do
                SetDiscordAppId(Config.DiscordActivity.appId)
                SetRichPresence(self:ReplacePlaceholders(Config.DiscordActivity.presence))
                SetDiscordRichPresenceAsset(Config.DiscordActivity.assetName)
                SetDiscordRichPresenceAssetText(self:ReplacePlaceholders(Config.DiscordActivity.assetText))

                for i = 1, #Config.DiscordActivity.buttons do
                    local button = Config.DiscordActivity.buttons[i]
                    local buttonUrl = self:ReplacePlaceholders(button.url)
                    SetDiscordRichPresenceAction(i - 1, button.label, buttonUrl)
                end

                Wait(Config.DiscordActivity.refresh)
            end
        end)
    end
end

function Adjustments:WantedLevel()
    if not Config.EnableWantedLevel then
        ClearPlayerWantedLevel(ESX.playerId)
        SetMaxWantedLevel(0)
    end
end

function Adjustments:DisableRadio()
    if Config.RemoveHudComponents[16] then
        AddEventHandler("esx:enteredVehicle", function(vehicle, plate, seat, displayName, netId)
            SetVehRadioStation(vehicle,"OFF")
            SetUserRadioControlEnabled(false)
        end)
    end
end

function Adjustments:Multipliers()
    local multipliers = Config.Multipliers
    frameAdjustments.applyPedDensity = multipliers.pedDensity ~= 1.0
    frameAdjustments.applyScenarioDensity = multipliers.scenarioPedDensityInterior ~= 1.0 or multipliers.scenarioPedDensityExterior ~= 1.0
    frameAdjustments.applyAmbientVehicleRange = multipliers.ambientVehicleRange ~= 1.0
    frameAdjustments.applyParkedVehicleDensity = multipliers.parkedVehicleDensity ~= 1.0
    frameAdjustments.applyRandomVehicleDensity = multipliers.randomVehicleDensity ~= 1.0
    frameAdjustments.applyVehicleDensity = multipliers.vehicleDensity ~= 1.0
    local hasCustomMultipliers = frameAdjustments.applyPedDensity
        or frameAdjustments.applyScenarioDensity
        or frameAdjustments.applyAmbientVehicleRange
        or frameAdjustments.applyParkedVehicleDensity
        or frameAdjustments.applyRandomVehicleDensity
        or frameAdjustments.applyVehicleDensity

    if not hasCustomMultipliers then
        return
    end

    frameAdjustments.useMultipliers = true
    frameAdjustments.pedDensity = multipliers.pedDensity
    frameAdjustments.scenarioPedDensityInterior = multipliers.scenarioPedDensityInterior
    frameAdjustments.scenarioPedDensityExterior = multipliers.scenarioPedDensityExterior
    frameAdjustments.ambientVehicleRange = multipliers.ambientVehicleRange
    frameAdjustments.parkedVehicleDensity = multipliers.parkedVehicleDensity
    frameAdjustments.randomVehicleDensity = multipliers.randomVehicleDensity
    frameAdjustments.vehicleDensity = multipliers.vehicleDensity
    StartFrameAdjustmentsThread()
end

function Adjustments:Load()
    self:RemoveHudComponents()
    self:DisableAimAssist()
    self:DisableNPCDrops()
    self:SeatShuffle()
    self:HealthRegeneration()
    self:AmmoAndVehicleRewards()
    self:EnablePvP()
    self:DispatchServices()
    self:NPCScenarios()
    self:LicensePlates()
    self:DiscordPresence()
    self:WantedLevel()
    self:DisableRadio()
    self:Multipliers()
end
