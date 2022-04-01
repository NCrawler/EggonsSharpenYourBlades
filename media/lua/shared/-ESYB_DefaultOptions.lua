ESYB.Options = {
    -- fed from own tables
    chanceToFindCondition = 3,
    chanceToFindSharp = 3,
    maxSingleAbrasion = 4,
    -- fed from optionValuesForModifiers
    abrasionChanceOnHit = 10, -- general modifier of abrasion probability
    bladesSharpnessLossRate = 10, -- how quickly will the sharpness deteriorate
    XPModifier = 10,
    displaySharpnessIndicator = true,
    playerDialogues = true,
    includeSpears = false,
    excludeWeirdItems = true
}

function ESYB.Options.valueOf(optionName)
    -- print("optionName: ", optionName)
    -- print("ESYB.Dict[optionName]: ", ESYB.Dict[optionName])
    -- print("[ESYB.Options[optionName]: ", ESYB.Options[optionName])
    return ESYB.Dict[optionName][ESYB.Options[optionName]].value
end

function ESYB.Options.nameOf(optionName)
    -- print("optionName", optionName)
    return ESYB.Dict[optionName][ESYB.Options[optionName]].name or ""
end

function ESYB.Options.maxAbrasion()
    return ESYB.Options.valueOf("maxSingleAbrasion") * ESYB.Const.maxCondition
end
