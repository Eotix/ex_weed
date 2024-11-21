QBFrame = nil
TriggerEvent('QBFrame:GetObject', function(obj) QBFrame = obj end)

QBFrame.Functions.CreateUseableItem('weedpot', function(source, item)
	local Player = QBFrame.Functions.GetPlayer(source)
	if not Player.Functions.GetItemByName(item.name) then return end
    TriggerClientEvent('ex_weed:client:useitem', source)
end)

RegisterServerEvent('ex_weed:plantSeed')
AddEventHandler('ex_weed:plantSeed', function(coords)
    local timestamp = os.time()
    local xPlayer = QBFrame.Functions.GetPlayer(source)
    xPlayer.Functions.RemoveItem('weedpot', 1)
    TriggerClientEvent('qb-inventory:client:ItemBox', source, QBFrame.Shared.Items['weedpot'], "remove")
    exports['ghmattimysql']:execute('INSERT INTO plants (coords, timestamp, plantgender, water, fertilizer) VALUES (@coords, @state, @pg, @water, @fertilizer)', {
        ['@coords'] = json.encode(coords),
        ['@state'] = timestamp,
        ['@pg'] = 0,
        ['@water'] = 0,
        ['@fertilizer'] = 50,
    }, function(response)
        exports['ghmattimysql']:execute('SELECT * FROM plants WHERE id = @id', {["@id"] = response.insertId}, function(plant)
            TriggerClientEvent('ex_weed:trigger_zone', -1, 2, plant[1])
        end)
    end)
end)

QBFrame.Functions.CreateCallback('ex_weed:getPlants', function(source, cb)
    exports['ghmattimysql']:execute('SELECT * FROM plants', {}, function(plants)
        cb(plants)
    end)
end)

QBFrame.Functions.CreateCallback('ex_weed:removePlant', function(source, cb, pId)
    TriggerClientEvent('ex_weed:trigger_zone', -1, 4, pId)
    exports['ghmattimysql']:execute('DELETE FROM plants WHERE id = @id', {["@id"] = pId})
    cb(true)
end)

QBFrame.Functions.CreateCallback('ex_weed:harvestPlant', function(source, cb, pId)
    local xPlayer = QBFrame.Functions.GetPlayer(source)
    local plant = getPlantById(pId)
    local qua = 100 - tonumber(plant.water / 20) - tonumber(plant.fertilizer / 10)
    xPlayer.Functions.AddItem(PlantConfig.FemaleSeedItem, math.random(PlantConfig.SeedsFromMale[1], PlantConfig.SeedsFromMale[2])) 
    xPlayer.Functions.AddItem(PlantConfig.GiveDopeItem, math.random(PlantConfig.DopeFromFemale[1], PlantConfig.DopeFromFemale[2]), nil, {quality = qua})
    TriggerClientEvent('qb-inventory:client:ItemBox', source, QBFrame.Shared.Items[PlantConfig.SeedsFromMale[1]], "add")
    TriggerClientEvent('qb-inventory:client:ItemBox', source, QBFrame.Shared.Items[PlantConfig.DopeFromFemale[1]], "add")
    TriggerClientEvent('ex_weed:trigger_zone', -1, 4, pId)
    exports['ghmattimysql']:execute('DELETE FROM plants WHERE id = @id', {["@id"] = pId})
    cb(true) 
end)

QBFrame.Functions.CreateCallback('ex_weed:addWater', function(source, cb, key)
    local xPlayer = QBFrame.Functions.GetPlayer(source)
    xPlayer.Functions.RemoveItem('water', 1)
    TriggerClientEvent('qb-inventory:client:ItemBox', source, QBFrame.Shared.Items['water'], "remove")
    exports['ghmattimysql']:execute('UPDATE plants SET water = (water + @water) WHERE id = @id', {["@id"] = key, ['@water'] = 100}, function(rowschanged)
        exports['ghmattimysql']:execute('SELECT * FROM plants WHERE id = @id', {["@id"] = key}, function(plant)
            TriggerClientEvent('ex_weed:trigger_zone', -1, 3, plant[1])
            cb(true)
        end)
    end)
end)

QBFrame.Functions.CreateCallback('ex_weed:HasWater', function(source, cb)
    local Player = QBFrame.Functions.GetPlayer(source)
    if Player ~= nil then
        local HasPhone = Player.Functions.GetItemByName("water")
        local retval = false
        if HasPhone ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)

getPlantById = function(plantId)
    local result = exports['ghmattimysql']:executeSync('SELECT * FROM plants WHERE id = @id', {["@id"] = plantId})
    return result[1]
end
