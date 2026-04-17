ESX.Players = {}
ESX.Jobs = {}
ESX.Items = {}
Core = {}
local BRANDING_PREFIX = "esx reborn by Veqta 1.1.0"

do
    local rawPrint = print

    ---@diagnostic disable-next-line: duplicate-set-field
    print = function(...)
        local args = { ... }
        if #args == 0 then
            return rawPrint(BRANDING_PREFIX)
        end

        if type(args[1]) == "string" then
            args[1] = ("%s | %s"):format(BRANDING_PREFIX, args[1])
        else
            table.insert(args, 1, ("%s |"):format(BRANDING_PREFIX))
        end

        return rawPrint(table.unpack(args))
    end
end

Core.JobsPlayerCount = {}
Core.UsableItemsCallbacks = {}
Core.RegisteredCommands = {}
Core.Pickups = {}
Core.PickupId = 0
Core.PlayerFunctionOverrides = {}
Core.DatabaseConnected = false
Core.playersByIdentifier = {}
Core.playersByUniqueId = {}
Core.JobsLoaded = false

---@type table<string, CVehicleData>
Core.vehicles = {}
Core.vehicleTypesByModel = {}

RegisterNetEvent("esx:onPlayerSpawn", function()
    ESX.Players[source].spawned = true
end)

if Config.CustomInventory then
    SetConvarReplicated("inventory:framework", "esx")
    SetConvarReplicated("inventory:weight", tostring(Config.MaxWeight * 1000))
end

local function StartDBSync()
    CreateThread(function()
        local interval <const> = 10 * 60 * 1000
        while true do
            Wait(interval)
            Core.SavePlayers()
        end
    end)
end

MySQL.ready(function()
    Core.DatabaseConnected = true

    if not Config.CustomInventory then
        ESX.RefreshItems()
    end

    ESX.RefreshJobs()

    print(("[^2INFO^7] ESX ^5Legacy %s^0 initialized!"):format(GetResourceMetadata(GetCurrentResourceName(), "version", 0)))

    StartDBSync()
    if Config.EnablePaycheck then
        StartPayCheck()
    end
end)

RegisterNetEvent("esx:clientLog", function(msg)
    if Config.EnableDebug then
        print(("[^2TRACE^7] %s^7"):format(msg))
    end
end)

RegisterNetEvent("esx:ReturnVehicleType", function(Type, Request)
    if Core.ClientCallbacks[Request] then
        Core.ClientCallbacks[Request](Type)
        Core.ClientCallbacks[Request] = nil
    end
end)

GlobalState.playerCount = 0
