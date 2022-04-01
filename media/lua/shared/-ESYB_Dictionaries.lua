require "weapons/ESYB_Axe.lua"
require "weapons/ESYB_HandAxe.lua"
require "weapons/ESYB_HuntingKnife.lua"
require "weapons/ESYB_Katana.lua"
require "weapons/ESYB_Machete.lua"
require "weapons/ESYB_MeatCleaver.lua"
require "weapons/ESYB_WoodAxe.lua"

ESYB.Dict.excludedItems = {
    ["Base.Screwdriver"] = true,
    ["Base.HandFork"] = true,
    ["Base.SmashedBottle"] = true,
    ["Base.SpearHandFork"] = true,
    ["Base.SpearScrewdriver"] = true
}

ESYB.Dict.OptionLevels = {
    [1] = "Very Low",
    [2] = "Low",
    [3] = "Normal",
    [4] = "High",
    [5] = "Very High"
}

ESYB.Dict.optionValuesForModifiers = {
    [1] = {
        name = "-90%",
        value = 0.1
    },
    [2] = {
        name = "-80%",
        value = 0.2
    },
    [3] = {
        name = "-70%",
        value = 0.3
    },
    [4] = {
        name = "-60%",
        value = 0.4
    },
    [5] = {
        name = "-50%",
        value = 0.5
    },
    [6] = {
        name = "-40%",
        value = 0.6
    },
    [7] = {
        name = "-30%",
        value = 0.3
    },
    [8] = {
        name = "-20%",
        value = 0.8
    },
    [9] = {
        name = "-10%",
        value = 0.9
    },
    [10] = {
        name = "Default",
        value = 1
    },
    [11] = {
        name = "+10%",
        value = 1.1
    },
    [12] = {
        name = "+20%",
        value = 1.2
    },
    [13] = {
        name = "+30%",
        value = 1.3
    },
    [14] = {
        name = "+40%",
        value = 1.4
    },
    [15] = {
        name = "+50%",
        value = 1.5
    },
    [16] = {
        name = "+75%",
        value = 1.75
    },
    [17] = {
        name = "+100%",
        value = 2
    },
    [18] = {
        name = "+125%",
        value = 2.25
    },
    [19] = {
        name = "+150%",
        value = 2.5
    },
    [20] = {
        name = "+200%",
        value = 3
    },
    [21] = {
        name = "+250%",
        value = 3.5
    },
    [22] = {
        name = "+300%",
        value = 4
    }
}

ESYB.Dict.abrasionChanceOnHit = ESYB.Dict.optionValuesForModifiers
ESYB.Dict.XPModifier = ESYB.Dict.optionValuesForModifiers
ESYB.Dict.bladesSharpnessLossRate = ESYB.Dict.optionValuesForModifiers

ESYB.Dict.chanceToFindCondition = {
    [1] = {
        [1] = 30, -- Almost destroyed
        [2] = 30, -- Poor
        [3] = 25, -- Average
        [4] = 10, -- Good
        [5] = 5 -- Excellent
    },
    [2] = {
        [1] = 20, -- Almost destroyed
        [2] = 30, -- Poor
        [3] = 30, -- Average
        [4] = 10, -- Good
        [5] = 10 -- Excellent
    },
    [3] = {
        [1] = 10, -- Almost destroyed
        [2] = 25, -- Poor
        [3] = 25, -- Average
        [4] = 25, -- Good
        [5] = 15 -- Excellent
    },
    [4] = {
        [1] = 5, --  Almost destroyed
        [2] = 10, -- Poor
        [3] = 25, -- Average
        [4] = 30, -- Good
        [5] = 30 -- Excellent
    },
    [5] = {
        [1] = 5, -- Almost destroyed
        [2] = 10, -- Poor
        [3] = 15, -- Average
        [4] = 30, -- Good
        [5] = 40 -- Excellent
    }
}
ESYB.Dict.chanceToFindSharp = {
    [1] = {
        [1] = 30, -- Blunt
        [2] = 30, -- Bluntish
        [3] = 25, -- Barely Sharp
        [4] = 10, -- Sharp
        [5] = 5 -- Razor sharp
    },
    [2] = {
        [1] = 20, -- Blunt
        [2] = 30, -- Bluntish
        [3] = 30, -- Barely Sharp
        [4] = 10, -- Sharp
        [5] = 10 -- Razor sharp
    },
    [3] = {
        [1] = 10, -- Blunt
        [2] = 25, -- Bluntish
        [3] = 25, -- Barely Sharp
        [4] = 25, -- Sharp
        [5] = 15 -- Razor sharp
    },
    [4] = {
        [1] = 5, -- Blunt
        [2] = 10, -- Bluntish
        [3] = 25, -- Barely Sharp
        [4] = 30, -- Sharp
        [5] = 30 -- Razor sharp
    },
    [5] = {
        [1] = 5, -- Blunt
        [2] = 10, -- Bluntish
        [3] = 15, -- Barely Sharp
        [4] = 30, -- Sharp
        [5] = 40 -- Razor sharp
    }
}

ESYB.Dict.abrasionChancePerLevel = {
    [1] = 0.17,
    [2] = 0.07,
    [3] = 0.03,
    [4] = 0,
    [5] = 0
}

ESYB.Dict.maxSingleAbrasion = {
    [1] = {
        name = "4%",
        value = 0.04
    },
    [2] = {
        name = "6%",
        value = 0.06
    },
    [3] = {
        name = "8%",
        value = 0.08
    },
    [4] = {
        name = "10%",
        value = 0.1
    },
    [5] = {
        name = "15%",
        value = 0.15
    },
    [6] = {
        name = "20%",
        value = 0.2
    },
    [7] = {
        name = "25%",
        value = 0.25
    }
}

ESYB.Dict.featuredWeaponCategories = {
    Axe = true,
    LongBlade = true,
    SmallBlade = true,
    Spear = false
}

ESYB.Dict.scrapTable = {
    ["Base.AxeStone"] = "Base.Stone",
    ["Base.Stake"] = "Base.UnusableWood"
}

ESYB.Dict.whetstones = {
    ["ESYB.Whetstone"] = true,
    ["ESYB.WetWhetstone"] = true,
    ["ESYB.HomemadeWhetstone"] = true
}

function ESYB.getModDataTest()
    local output = ModData.getOrCreate("ESYB_Test")
    -- EggonsMU.printFuckingNormalObject(output, "Test mod data got ")
    -- EggonsMU.printFuckingNormalObject(output.subTable, "Test mod data got ")
    return output
end
function ESYB.getModData(returnCombined)
    local weaponConfigs = ModData.getOrCreate("ESYB_WeaponConfigs")
    return weaponConfigs
end

function ESYB.Dict.addWeaponsToDictionary(config)
    local weapons = ESYB.Dict.weapons
    for weaponFullType, weaponConfig in pairs(config) do
        if weapons[weaponFullType] then
            -- EggonsMU.printFuckingNormalObject(weapons[weaponFullType], "Config in dictionary")
            -- EggonsMU.printFuckingNormalObject(weapons[weaponFullType].levels, "Config.levels in dictionary")
            print("ESYB duplicate entry do dictionary. Skipping: " .. weaponFullType .. " is already in dictionary")
        else
            print("ESYB Injecting dictionary: ", weaponFullType)
            weapons[weaponFullType] = weaponConfig
        end
    end
end

local weaponsDictionaries = {
    Axe = true,
    HandAxe = true,
    HuntingKnife = true,
    Katana = true,
    Machete = true,
    MeatCleaver = true,
    WoodAxe = true
}

ESYB.Dict.buildWeaponsDictionary = function()
    print("ESYB: Filling weapons dictionary")
    for dictionaryName, _ in pairs(weaponsDictionaries) do
        ESYB.Dict.addWeaponsToDictionary(ESYB.Dict[dictionaryName])
    end

    local modData = ESYB.getModData()
    -- EggonsMU.printFuckingNormalObject(modData, "modData in build dict")
    -- EggonsMU.printFuckingNormalObject(modData["Base.AxeStone"], "modData for AxeStone")
    combinedData = ESYB.Dict.addWeaponsToDictionary(modData)

    print("ESYB: Weapons dictionary filled")
end

Events.OnInitGlobalModData.Add(ESYB.Dict.buildWeaponsDictionary)

ESYB.Dict.Recipes = {
    AllAboutBladeBevels = {
        sharpeningBonus = true,
        perfectionBonus = true,
        XPBonus = true
    },
    JapaneseMastersSpecialEdition = {
        sharpeningBonus = true,
        perfectionBonus = true,
        XPBonus = true
    },
    TypicalSharpeningMistakes = {
        sharpeningBonus = true,
        perfectionBonus = true,
        XPBonus = true
    },
    TableGrinderUserManual = {
        sharpeningBonus = false,
        perfectionBonus = false,
        XPBonus = false
    }
}

ESYB.Dict.getNumberOfKnownRecipesFor = function(bonusName, player)
    local player = player or getPlayer()
    local knownRecipes = player:getKnownRecipes()
    local output = 0
    for recipeName, cfg in pairs(ESYB.Dict.Recipes) do
        if cfg[bonusName] and knownRecipes:contains(recipeName) then
            output = output + 1
        end
    end
    return output
end
