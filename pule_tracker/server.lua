ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('car_tracker', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('car_tracker', 1)
    TriggerClientEvent('pule_cartracker:useTracker', source)
end)

RegisterServerEvent('pule_cartracker:trackVehicle')
AddEventHandler('pule_cartracker:trackVehicle', function(netId, vehiclePlate)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('pule_cartracker:setBlip', source, vehiclePlate, netId)
    xPlayer.removeInventoryItem('car_tracker', 1)
end)

RegisterServerEvent('pule_cartracker:untrackVehicle')
AddEventHandler('pule_cartracker:untrackVehicle', function(vehiclePlate)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('pule_cartracker:removeBlip', source, vehiclePlate)
    xPlayer.addInventoryItem('car_tracker', 1)
end)
