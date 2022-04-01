ESYB = ESYB or {}

local optionsSources = {
    abrasionChanceOnHit = {
        source = ESYB.Dict.abrasionChanceOnHit,
        complexSource = true
    },
    bladesSharpnessLossRate = {
        source = ESYB.Dict.bladesSharpnessLossRate,
        complexSource = true
    },
    chanceToFindCondition = {
        source = ESYB.Dict.OptionLevels,
        complexSource = false
    },
    chanceToFindSharp = {
        source = ESYB.Dict.OptionLevels,
        complexSource = false
    },
    maxSingleAbrasion = {
        source = ESYB.Dict.maxSingleAbrasion,
        complexSource = true
    },
    XPModifier = {
        source = ESYB.Dict.XPModifier,
        complexSource = true
    }
}

if ModOptions and ModOptions.getInstance then
    local function applyModOptions(updateData)
        local newValues = updateData.settings.options
        ESYB.Options.abrasionChanceOnHit = newValues.abrasionChanceOnHit
        ESYB.Options.bladesSharpnessLossRate = newValues.bladesSharpnessLossRate
        ESYB.Options.chanceToFindCondition = newValues.chanceToFindCondition
        ESYB.Options.chanceToFindSharp = newValues.chanceToFindSharp
        ESYB.Options.maxSingleAbrasion = newValues.maxSingleAbrasion
        ESYB.Options.XPModifier = newValues.XPModifier
        ESYB.Options.displaySharpnessIndicator = newValues.displaySharpnessIndicator
        ESYB.Options.playerDialogues = newValues.playerDialogues
        ESYB.Options.excludeWeirdItems = newValues.excludeWeirdItems
        ESYB.Dict.featuredWeaponCategories.Spear = newValues.includeSpears
    end
    local SETTINGS = {
        options_data = {
            abrasionChanceOnHit = {
                default = 10,
                name = "Chance to damage weapon on impact",
                OnApplyMainMenu = applyModOptions,
                OnApplyInGame = applyModOptions
            },
            bladesSharpnessLossRate = {
                default = 10,
                name = "Blades' sharpness loss rate",
                OnApplyMainMenu = applyModOptions,
                OnApplyInGame = applyModOptions
            },
            chanceToFindCondition = {
                default = 3,
                name = "Chance to find weapons in good condition",
                OnApplyMainMenu = applyModOptions,
                OnApplyInGame = applyModOptions
            },
            chanceToFindSharp = {
                default = 3,
                name = "Chance to find sharp weapons",
                OnApplyMainMenu = applyModOptions,
                OnApplyInGame = applyModOptions
            },
            maxSingleAbrasion = {
                default = 4,
                name = "Max blade damage in a single event",
                OnApplyMainMenu = applyModOptions,
                OnApplyInGame = applyModOptions
            },
            XPModifier = {
                default = 10,
                name = "XP gain modifier",
                OnApplyMainMenu = applyModOptions,
                OnApplyInGame = applyModOptions
            },
            displaySharpnessIndicator = {
                default = true,
                name = "Display sharpness indicator",
                OnApplyMainMenu = applyModOptions,
                OnApplyInGame = applyModOptions
            },
            playerDialogues = {
                default = true,
                name = "Player dialogues",
                OnApplyMainMenu = applyModOptions,
                OnApplyInGame = applyModOptions
            },
            includeSpears = {
                default = false,
                name = "Include spears (experimental)",
                OnApplyMainMenu = applyModOptions,
                OnApplyInGame = applyModOptions
            },
            excludeWeirdItems = {
                default = true,
                name = "Exclude weird items (screwdriver, broken bottle, etc.)",
                OnApplyMainMenu = applyModOptions,
                OnApplyInGame = applyModOptions
            }
        },
        mod_id = "eggonsSharpenYourBlades",
        mod_shortname = "ESYB",
        mod_fullname = "Eggon's Sharpen Your Blades!"
    }
    for optionName, cfg in pairs(optionsSources) do
        for i, valueOrCfg in ipairs(cfg.source) do
            local appliedValue
            if cfg.complexSource then
                appliedValue = valueOrCfg.name
            else
                appliedValue = valueOrCfg
            end
            SETTINGS.options_data[optionName][i] = appliedValue
        end
    end
    local optionsInstance = ModOptions:getInstance(SETTINGS)
    ModOptions:loadFile()
    Events.OnGameStart.Add(
        function()
            applyModOptions({settings = SETTINGS})
        end
    )
end
