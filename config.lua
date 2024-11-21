PlantConfig = {
    --Script automatically splits this into %'s
    -- GrowthObjects = {
    --     {hash = `bkr_prop_weed_01_small_01c`},
    --     {hash = `bkr_prop_weed_01_small_01b`},
    --     {hash = `bkr_prop_weed_01_small_01a`},
    --     {hash = `bkr_prop_weed_med_01a`},
    --     {hash = `bkr_prop_weed_med_01b`},
    --     {hash = `bkr_prop_weed_lrg_01a`},
    --     {hash = `bkr_prop_weed_lrg_01b`},
    -- },
    GrowthObjects = {
        [1] = "bkr_prop_weed_01_small_01c",
        [2] = "bkr_prop_weed_01_small_01b",
        [3] = "bkr_prop_weed_01_small_01a",
        [4] = "bkr_prop_weed_med_01a",
        [5] = "bkr_prop_weed_med_01b",
        [6] = "bkr_prop_weed_lrg_01a",
        [7] = "bkr_prop_weed_lrg_01b",
    },

    -- Plant Growing time in minutes
    GrowthTime = 30, -- Original
    -- GrowthTime = 2,
    -- How much longer should a male plant take to grow less is faster
    MaleFactor = 1.0,
    -- How many seeds should come from a male plant (range)
    SeedsFromMale = {5, 8},
    -- How many dopes should come from a female plant (range)
    DopeFromFemale = {3, 6},
    -- Percent at which the plant becomes harvestable
    HarvestPercent = 100,
    -- Time between plant harvests (minutes)
    TimeBetweenHarvest = 400,
    -- How much should 1 water bottle add, if you want to give 20, set {20, 20}
    -- WaterAdd = {16, 20},
    -- FertilizerItem = 'fertilizer',
    -- WaterItem = 'water_weed',
    -- MaleSeedItem = 'maleseed',
    FemaleSeedItem = 'weedseeds',
    GiveDopeItem = 'wetbud',
    -- less is faster growth but less quality
    FertilizerFactor = 1.0,
    -- Affects how much each nutrient contributes to the final quality
    -- NWeight = 25,
    -- PWeight = 50,
    -- KWeight = 75,
}


WeedZones = {
    {vector3(-1586.36, 4153.03, 50.0), 2087.36},
    {vector3(2292.42, 4577.27, 50.0), 681.29},
    {vector3(2218.18, 5568.18, 50.0), 78.20},
    {vector3(928.79, 4540.91, 50.0), 750.88},
    {vector3(1709.03, 2592.45, 59.88), 200.0},
    {vector3(1452.94, 1105.35, 114.33), 200.0},
    {vector3(3283.27, 5183.88, 18.42), 100.0},
    {vector3(1800.77, 6523.15, 70.33), 200.0},
}

-- notify = function(typee, msg)
--     -- ESX.ShowNotification(msg)

--     -- exports['mythic_notify']:SendAlert('inform', msg)
--     TriggerEvent('Eotix:Alert', typee, msg)
-- end
