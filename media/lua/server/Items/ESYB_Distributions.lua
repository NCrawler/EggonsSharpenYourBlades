-- local configTemplate = {
--     {item, room, container, chance, rolls, min, max, procedureWeight}
-- }

local distributionData = {
    -- vanilla Kitchen
    {"ESYB.Whetstone", "kitchen", "counter", 8, 3, 0, 1, 100},
    {"ESYB.Whetstone", "kitchen", "shelves", 8, 3, 0, 1, 100},
    {"ESYB.Whetstone", "kitchen", "overhead", 8, 3, 0, 1, 100},
    -- BAR KITCHEN
    {"ESYB.Whetstone", "barkitchen", "counter", 8, 3, 0, 1, 100},
    {"ESYB.Whetstone", "barkitchen", "shelves", 8, 3, 0, 1, 100},
    {"ESYB.Whetstone", "barkitchen", "crate", 8, 3, 0, 1, 100},
    {"ESYB.Whetstone", "barstorage", "counter", 8, 3, 0, 1, 100},
    {"ESYB.Whetstone", "barstorage", "shelves", 8, 3, 0, 1, 100},
    {"ESYB.Whetstone", "barstorage", "crate", 8, 3, 0, 3, 100},
    {"ESYB.Whetstone", "barstorage", "metal_shelves", 8, 3, 0, 1, 100},
    -- BURGER KITCHEN
    {"ESYB.Whetstone", "burgerkitchen", "counter", 8, 3, 0, 1, 100},
    {"ESYB.Whetstone", "burgerkitchen", "shelves", 8, 3, 0, 1, 100},
    {"ESYB.Whetstone", "burgerkitchen", "crate", 8, 3, 0, 3, 100},
    {"ESYB.Whetstone", "burgerstorage", "crate", 8, 3, 0, 3, 100},
    {"ESYB.Whetstone", "burgerstorage", "metal_shelves", 8, 3, 0, 1, 100},
    -- DINER KITCHEN
    {"ESYB.Whetstone", "dinerkitchen", "counter", 8, 3, 0, 1, 100},
    {"ESYB.Whetstone", "dinerkitchen", "shelves", 8, 3, 0, 1, 100},
    {"ESYB.Whetstone", "dinerkitchen", "crate", 8, 3, 0, 3, 100},
    -- PIZZA KITCHEN
    {"ESYB.Whetstone", "pizzakitchen", "counter", 8, 3, 0, 1, 100},
    {"ESYB.Whetstone", "pizzakitchen", "metal_shelves", 8, 3, 0, 1, 100},
    -- RESTAURANT KITCHEN
    {"ESYB.Whetstone", "restaurantkitchen", "counter", 8, 3, 0, 1, 100},
    {"ESYB.Whetstone", "restaurantkitchen", "shelves", 8, 3, 0, 1, 100},
    -- SPIFFOS KITCHEN
    {"ESYB.Whetstone", "spiffoskitchen", "counter", 8, 3, 0, 1, 100},
    {"ESYB.Whetstone", "spiffoskitchen", "shelves", 8, 3, 0, 1, 100},
    {"ESYB.Whetstone", "spiffosstorage", "metal_shelves", 8, 3, 0, 1, 100},
    {"ESYB.Whetstone", "spiffosstorage", "crate", 8, 3, 0, 3, 100},
    --
    {"ESYB.MagazineAllAboutBladeBevels", "gunstore", "shelvesmag", 17, 2, 0, 2, 100},
    {"ESYB.MagazineJapaneseMastersSpecialEdition", "gunstore", "shelvesmag", 17, 2, 0, 2, 100},
    {"ESYB.MagazineTypicalSharpeningMistakes", "gunstore", "shelvesmag", 17, 2, 0, 2, 100},
    {"ESYB.MagazineHomemadeGrindingTools", "gunstore", "shelvesmag", 17, 2, 0, 2, 100},
}

local bladeMagazinesSkip = {
    procedural = {
        ElectronicStoreMagazines = true,
        ToolStoreBooks = true
    },
    skipAllVehicles = true
}
local whetstoneSkipScrewdriver = {
    procedural = {
        MechanicShelfElectric = true
    },
    standard = {
        Bag_InmateEscapedBag = true,
        Bag_JanitorToolbox = true,
        JanitorTools = true,
        Electrician = true
    },
    skipAllVehicles = true
}

-- {mimicedItem, mimicingItem, modifier, skipCFG}
local mimicCFG = {
    {"ElectronicsMag4", "ESYB.MagazineAllAboutBladeBevels", 1, bladeMagazinesSkip},
    {"ElectronicsMag4", "ESYB.MagazineJapaneseMastersSpecialEdition", 1, bladeMagazinesSkip},
    {"ElectronicsMag4", "ESYB.MagazineTypicalSharpeningMistakes", 1, bladeMagazinesSkip},
    {"ElectronicsMag4", "ESYB.MagazineHomemadeGrindingTools", 1, bladeMagazinesSkip},
    {"Screwdriver", "ESYB.Whetstone", 0.8, whetstoneSkipScrewdriver}
    -- {"ElectronicsMag4", "ESYB.MagazineTableGrinderUserManual", 1},
}

EggonsMU.mimicDistribution(mimicCFG)
EggonsMU.registerDistributions(distributionData)

-- local whetstoneSkipPipeWrench = {
--     procedural = {
--         BathroomCounter = true
--     },
--     standard = {
--         Bag_JanitorToolbox = true,
--         JanitorTools = true
--     },
--     skipAllVehicles = true
-- }
