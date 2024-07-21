ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        if Config.framework == "esx" then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
        elseif Config.framework == "NewESX" then
            ESX = exports["es_extended"]:getSharedObject()
        end
    end
end)

local tracking = {}

exports.ox_target:addGlobalVehicle({
    {
        items = Config.trackeritem,
        label = Config.labels["place tracker"],
        icon = "fas fa-car",
        iconColor = "lime",
        distance = 2.0,
        canInteract = function(entity)
            local vehiclePlate = GetVehicleNumberPlateText(entity)
            return not tracking[vehiclePlate]
        end,
        onSelect = function(data)
            TriggerEvent("pule_cartracker:useTracker", data.entity)
        end
    },
    {
        items = Config.tracker_remove_item,
        label = Config.labels["remove tracker"],
        icon = "fas fa-car",
        iconColor = "yellow",
        distance = 2.0,
        canInteract = function(entity)
            local vehiclePlate = GetVehicleNumberPlateText(entity)
            return tracking[vehiclePlate]
        end,
        onSelect = function(data)
            TriggerEvent("pule_cartracker:removeTracker", data.entity)
        end
    }
})

RegisterNetEvent('pule_cartracker:useTracker')
AddEventHandler('pule_cartracker:useTracker', function(vehicle)
    local playerPed = PlayerPedId()
    if vehicle == nil then
        local coords = GetEntityCoords(playerPed)
        vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
    end

    if DoesEntityExist(vehicle) then
        local vehiclePlate = GetVehicleNumberPlateText(vehicle)
        if tracking[vehiclePlate] then
            if Config.debug then
                print("already tracking: ".. tracking[vehiclePlate])
                end
            lib.notify({
                title = "PMRP",
                style = {
                    color = "cyan"
                },
                description = Config.labels["tracker already exists"],
                icon = "car"
            })
        else
            local netId = NetworkGetNetworkIdFromEntity(vehicle)
            if netId then
                if Config.debug then
                    print("Tracker was placed to vehicle: " .. vehiclePlate)
                    end
                TriggerServerEvent('pule_cartracker:trackVehicle', netId, vehiclePlate)
                lib.notify({
                    title = "PMRP",
                    style = {
                        color = "cyan"
                    },
                    description = Config.labels["tracker placed"]
                })
            else
                if Config.debug then
                print("Failed getting the NetworkID from the vehicle")
                end
            end
        end
    else
        lib.notify({
            title = "PMRP",
            style = {
                color = "cyan"
            },
            description = Config.labels["no vehicles nearby"]
        })
    end
end)

RegisterNetEvent('pule_cartracker:removeTracker')
AddEventHandler('pule_cartracker:removeTracker', function(vehicle)
    local playerPed = PlayerPedId()
    if vehicle == nil then
        local coords = GetEntityCoords(playerPed)
        vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
    end

    if DoesEntityExist(vehicle) then
        local vehiclePlate = GetVehicleNumberPlateText(vehicle)
        if tracking[vehiclePlate] then
            TriggerServerEvent('pule_cartracker:untrackVehicle', vehiclePlate)
            lib.notify({
                title = "PMRP",
                style = {
                    color = "cyan"
                },
                description = Config.labels["tracker removed"],
                icon = "car"
            })
        else
            lib.notify({
                title = "PMRP",
                style = {
                    color = "cyan"
                },
                description = Config.labels["no attached trackers"],
                icon = "car"
            })
        end
    else
        lib.notify({
            title = "PMRP",
            style = {
                color = "cyan"
            },
            description = Config.labels["no vehicles to remove"]
        })
    end
end)

RegisterNetEvent('pule_cartracker:setBlip')
AddEventHandler('pule_cartracker:setBlip', function(vehiclePlate, netId)
    local vehicle = NetToVeh(netId)
    if DoesEntityExist(vehicle) then
        local blip = AddBlipForEntity(vehicle)
        SetBlipSprite(blip, 225) -- Tracker blip icon
        SetBlipColour(blip, 1)   -- Red color
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Asettamasi jäljitin')
        EndTextCommandSetBlipName(blip)
        tracking[vehiclePlate] = blip
    end
end)

RegisterNetEvent('pule_cartracker:removeBlip')
AddEventHandler('pule_cartracker:removeBlip', function(vehiclePlate)
    local blip = tracking[vehiclePlate]
    if blip then
        RemoveBlip(blip)
        tracking[vehiclePlate] = nil
    end
end)
