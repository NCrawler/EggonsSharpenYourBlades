require "Foraging/forageSystem"

local sandstone = {
    type = "ESYB.Sandstone",
    minCount = 1,
    maxCount = 2,
    skill = 0,
    recipes = {"Make Homemade Whetstone"},
    categories = {"Stones"},
    zones = {
        DeepForest = 7,
        Forest = 10,
        Vegitation = 15,
        FarmLand = 20,
        Farm = 20,
        TrailerPark = 7,
        TownZone = 0,
        Nav = 5
    }
    -- altWorldTexture = getTexture("media/textures/Item_Sandstone.png")
}

-- local ESYB_Sandstone = {
--     chance = 25,
--     name = "ESYB_Sandstone",
--     typeCategory = "Materials",
--     showOptionPerk = "PlantScavenging",
--     -- showCategoryLevel = 1,
--     validFloors = {"ANY"},
--     zoneChance = {
--         DeepForest = 5,
--         Forest = 10,
--         Vegitation = 10,
--         FarmLand = 20,
--         Farm = 20,
--         TrailerPark = 15,
--         TownZone = 0,
--         Nav = 60
--     }
-- }

local function initForaging()
    forageSystem.addItemDef(sandstone)
end

Events.onAddForageDefs.Add(initForaging)
