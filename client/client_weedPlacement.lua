QBFrame = nil
CreateThread(function()
    while QBFrame == nil do
        TriggerEvent('QBFrame:GetObject', function(obj) QBFrame = obj end)
        Wait(0)
    end
end)

local WeedPlants = {}
local ActivePlants = {}

local inZone = 0
local setDeleteAll = false
local isPlacing = false
local hasShownMessage = false

CreateThread(function()
    local weed = { `bkr_prop_weed_01_small_01c`, `bkr_prop_weed_01_small_01b`, `bkr_prop_weed_01_small_01a`, `bkr_prop_weed_med_01a`, `bkr_prop_weed_med_01b`, `bkr_prop_weed_lrg_01a`, `bkr_prop_weed_lrg_01b` }        
    exports["qb-eye"]:AddTargetModel(weed, {
        options = {
            {
                event = "ex_weed:checkPlant",
                icon = "fas fa-cannabis",
                label = "Опции",
            },
        },
        job = {"all"},
        distance = 4
    })
end)

Citizen.CreateThread(function()
    while true do
        local plyCoords = GetEntityCoords(PlayerPedId())
        if WeedPlants == nil then WeedPlants = {} end
        for idx,plant in ipairs(WeedPlants) do
            if idx % 100 == 0 then
                Wait(0) 
            end
            local plantcoords = json.encode(plant.coords)
            if not setDeleteAll then
                local plantGrowth = getPlantGrowthPercent(plant)
                local curStage = getStageFromPercent(plantGrowth)
                local isChanged = (ActivePlants[plant.id] and ActivePlants[plant.id].stage ~= curStage)

                if isChanged then
                    removeWeed(plant.id)
                end

                if not ActivePlants[plant.id] or isChanged then
                    local weedPlant = createWeedStageAtCoords(curStage, plant.coords)
                    ActivePlants[plant.id] = {
                        object = weedPlant,
                        stage = curStage
                    }
                end
            else
                removeWeed(plant.id)
            end
        end
        if setDeleteAll then
            WeedPlants = {}
            setDeleteAll = false
        end
        Wait(inZone > 0 and 500 or 1000)
    end
end)

Citizen.CreateThread(function()
    for id,zone in ipairs(WeedZones) do
        exports["ex_polyzone"]:AddCircleZone("ex_weed:weed_zone", zone[1], zone[2])
    end
end)

RegisterNetEvent('ex_weed:client:useitem')
AddEventHandler('ex_weed:client:useitem', function()
    if inZone > 0 then
        TriggerEvent('ex_weed:createProp')
    else
        notify('error', "ТРЯБВА ДА НАМЕРИШ ПО-ДОБРО МЯСТО, ЗА ДА ЗАСАДИШ ТОВА!")
    end
end)

RegisterNetEvent('ex_weed:trigger_zone')
AddEventHandler("ex_weed:trigger_zone", function (type, pData)
    if type == 1 then
        for _,plant in ipairs(WeedPlants) do
            local keep = false
            for _,newPlant in ipairs(pData) do
                if plant.id == newPlant.id then
                    keep = true
                    break
                end
            end

            if not keep then
                removeWeed(plant.id)
            end
        end
        WeedPlants = pData
    end

    if type == 2 then
        WeedPlants[#WeedPlants+1] = pData
    end

    if type == 3 then
        for idx,plant in ipairs(WeedPlants) do
            if plant.id == pData.id then
                WeedPlants[idx] = pData
                break
            end
        end
    end

    if type == 4 then
        for idx,plant in ipairs(WeedPlants) do
            if plant.id == pData then
                table.remove(WeedPlants, idx)
                removeWeed(plant.id)
                break
            end
        end
    end
end)


AddEventHandler("ex_weed:checkPlant", function(test)
    local pedCoords = GetEntityCoords(PlayerPedId())
    local object = nil
    local x1,y1,z1 = table.unpack(GetEntityCoords(PlayerPedId()))
    for k,v in ipairs(PlantConfig.GrowthObjects) do
        local closestObject = GetClosestObjectOfType(x1, y1, z1, 2.0, v, false, false, false)
        if closestObject ~= nil and closestObject ~= 0 then
            object = closestObject
            break
        end
    end
    local plantId = getPlantId(object)

    if not plantId then return end
    showPlantMenu(plantId)
end)

AddEventHandler('ex_weed:addWater', function(data)
    QBFrame.Functions.TriggerCallback('ex_weed:addWater', function(success)
        notify('success', "РАСТЕНИЕТО Е ПОЛЯТО") 
        if not success then
            notify('error', "СВЪРЖИ СЕ С АДМИН!")
        end
    end, data)
end)

AddEventHandler('ex_weed:removePlant', function(data)
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
    QBFrame.Functions.Progressbar("premahni-trewata", "Премахване на растението", 10000, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(PlayerPedId())
        QBFrame.Functions.TriggerCallback('ex_weed:removePlant', function(success) 
            if success then
                removeWeed(data)
            end
        end, data)
    end, function()
        ClearPedTasks(PlayerPedId())
        QBFrame.Functions.Notify("Отказано..", "error")
    end)
end)

AddEventHandler("ex_weed:pickPlant", function()
    local pedCoords = GetEntityCoords(PlayerPedId())
    local object = nil
    local x1,y1,z1 = table.unpack(GetEntityCoords(PlayerPedId()))
    for k,v in ipairs(PlantConfig.GrowthObjects) do
        local closestObject = GetClosestObjectOfType(x1, y1, z1, 30.0, v, false, false, false)
        if closestObject ~= nil and closestObject ~= 0 then
            object = closestObject
            break
        end
    end
    local plantId = getPlantId(object)
    if not plantId then return end
    local plant = getPlantById(plantId)
    local growth = getPlantGrowthPercent(plant)
    if getPlantGrowthPercent(plant) < PlantConfig.HarvestPercent then
         notify("error","ТОВА РАСТЕНИЕ НЕ Е ГОТОВО ЗА ОБИРАНЕ")
        return
    end
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
    QBFrame.Functions.Progressbar("обери-trewata", "Обиране на канабис...", 10000, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(PlayerPedId())
        QBFrame.Functions.TriggerCallback('ex_weed:harvestPlant', function(cb)
            if not cb then
            end
        end, plantId)
    end, function()
        ClearPedTasks(PlayerPedId())
        QBFrame.Functions.Notify("Отказано..", "error")
    end)
end)

AddEventHandler("ex_polyzone:enter", function(zone, data)
    if zone == "ex_weed:weed_zone" then
        inZone = inZone + 1
        if inZone == 1 then
            QBFrame.Functions.TriggerCallback('ex_weed:getPlants', function(cb)
                WeedPlants = cb
            end)
        end
    end
end)

AddEventHandler("ex_polyzone:exit", function(zone, data)
    if zone == "ex_weed:weed_zone" then
        inZone = inZone - 1
        if inZone < 0 then inZone = 0 end
        if inZone == 0 then
            setDeleteAll = true
        end
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for idx,plant in pairs(ActivePlants) do
        DeleteObject(plant.object)
    end
end)

function createWeedStageAtCoords(pStage, pCoords)
    local model = PlantConfig.GrowthObjects[pStage]
    local zOffset = 0
    if pStage <= 3 then
        zOffset = 0
    else 
        zOffset = -2.5
    end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    coords = json.decode(pCoords)
    local plantObject = CreateObject(model, coords.x, coords.y, coords.z + zOffset, false, false, false)   
    FreezeEntityPosition(plantObject, true)
    SetEntityHeading(plantObject, math.random(0, 360) + 0.0)
    return plantObject
end

function removeWeed(pPlantId)
    if ActivePlants[pPlantId] then
        DeleteObject(ActivePlants[pPlantId].object)
        ActivePlants[pPlantId] = nil
    end
end

function getStageFromPercent(pPercent)
    local divider = 95.0 / #PlantConfig.GrowthObjects
    local targetStage = math.max(1,math.floor(pPercent / divider))
    return targetStage
end

function getPlantGrowthPercent(pPlant)
    local timeDiff = (GetCloudTimeAsInt() - pPlant.timestamp) / 60
    local genderFactor = (pPlant.plantgender == 1 and PlantConfig.MaleFactor or 1)
    local fertilizerFactor = pPlant.fertilizer >= 50 and PlantConfig.FertilizerFactor or 1.0
    local growthFactors = (PlantConfig.GrowthTime * genderFactor * fertilizerFactor)
    local growth = math.min((timeDiff / growthFactors) * 100, 100.0)
    return growth
end

function getPlantId(pEntity)
    for plantId,plant in pairs(ActivePlants) do
        if plant.object == pEntity then
            return plantId
        end
    end
end

function getPlantById(pPlantId)
    for _,plant in pairs(WeedPlants) do
        if plant.id == pPlantId then
            return plant
        end
    end
end

function showPlantMenu(pPlantId)
    local plant = getPlantById(pPlantId)
    local growth = getPlantGrowthPercent(plant)
    local water = math.min(plant.water, 100)
    local needwater = true
    if water <= 95 then
        needwater = true
    elseif water > 95 then
        needwater = false
    end
    SetNuiFocus(true, true)
    FreezeEntityPosition(PlayerPedId(), true)
    SendNUIMessage({
        action = "update",
        isWaitingForWater = needwater,
        progress = string.format("%.2f", growth),
    })
    SendNUIMessage({
        action = "open",
        isWaitingForWater = needwater,
        progress = string.format("%.2f", growth),
    })
end

RegisterNetEvent('ex_weed:closeWeedPotUI')
AddEventHandler('ex_weed:closeWeedPotUI', function()
    FreezeEntityPosition(PlayerPedId(), false)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "close"
    })
end)

RegisterNUICallback("DeleteSelectedWeedPot", function(data, cb)
    local pedCoords = GetEntityCoords(PlayerPedId())
    local object = nil
    local x1,y1,z1 = table.unpack(GetEntityCoords(PlayerPedId()))
    for k,v in ipairs(PlantConfig.GrowthObjects) do
        local closestObject = GetClosestObjectOfType(x1, y1, z1, 2.0, v, false, false, false)
        if closestObject ~= nil and closestObject ~= 0 then
            object = closestObject
            break
        end
    end
    local plantId = getPlantId(object)

    if not plantId then return end
    TriggerEvent('ex_weed:removePlant', plantId)
    TriggerEvent('ex_weed:closeWeedPotUI')
end)

RegisterNUICallback("GiveWaterToSelectedWeedPot", function(data, cb)
    local pedCoords = GetEntityCoords(PlayerPedId())
    local object = nil
    local x1,y1,z1 = table.unpack(GetEntityCoords(PlayerPedId()))
    for k,v in ipairs(PlantConfig.GrowthObjects) do
        local closestObject = GetClosestObjectOfType(x1, y1, z1, 2.0, v, false, false, false)
        if closestObject ~= nil and closestObject ~= 0 then
            object = closestObject
            break
        end
    end
    local plantId = getPlantId(object)

    if not plantId then return end
    QBFrame.Functions.TriggerCallback('ex_weed:HasWater', function(item)
        if item then
            TriggerEvent('ex_weed:addWater', plantId)
        else
            notify('error', 'НЯМАШ ВОДА! КАК ЩЕ ПОЛЕЕШ?')
        end
    end)
    TriggerEvent('ex_weed:closeWeedPotUI')
end)

RegisterNUICallback("GetCannabisFromSelectedPot", function(data, cb)
    TriggerEvent('ex_weed:pickPlant')
    TriggerEvent('ex_weed:closeWeedPotUI')
end)

RegisterNUICallback("CloseUI", function(data, cb)
    TriggerEvent('ex_weed:closeWeedPotUI')
end)


notify = function(color, text)
    QBFrame.Functions.Notify(text, color)
end