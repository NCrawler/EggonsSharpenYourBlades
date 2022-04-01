ESYB.BladesUse = {}
local BU = ESYB.BladesUse
local Dict = ESYB.Dict
local DF = Dict.functions
local console = ESYB.functions
local EMUF = EggonsMU.functions

local copiedPropertiesDictionary = {
    "MinDamage",
    "MaxDamage",
    "DoorDamage",
    "CriticalChance",
    "CritDmgMultiplier",
    "TreeDamage"
}

local contextActionMessages = {
    onHit = "With a blade this blunt I'll kill the weapon rather than a zombie!",
    penalty = "Repairing is not allowed!",
    chopTree = "I'll quickly destroy this weapon if I keep using it so blunt!"
}

ESYB.BladesUse.sharpnessIcon = function(sharpness)
    local suffix = Math.ceil(math.max(sharpness, 1) / 10) * 10 -- /10 - ceil - * 10
    local iconName = "media/ui/Sharpness" .. suffix .. ".png"
    -- console.log("iconName", iconName)
    local icon = getTexture(iconName)
    return icon
end

-- DONE
ESYB.BladesUse.weaponSharpnessPercentage = function(weapon, sharpness, bottomConfig, upperConfig)
    sharpness = sharpness or weapon:getModData().ESYB.sharpness
    if not bottomConfig then
        local weaponCfg = Dict.weapons[weapon:getFullType()]
        bottomConfig = DF.findBottomSharpnessConfigLevel(weaponCfg, sharpness)
        upperConfig = DF.findUpperSharpnessConfigLevel(weaponCfg, sharpness)
    end
    local uppperLimit = upperConfig.maxSharpness
    local bottomLimit = bottomConfig.maxSharpness
    return (sharpness - bottomLimit) / (uppperLimit - bottomLimit)
end

ESYB.BladesUse.applyCombatStats = function(weapon, weaponCfg)
    local WMD = weapon:getModData().ESYB
    local fullType = weapon:getFullType()
    local weaponConfig = weaponCfg or Dict.weapons[fullType]
    local sharpness = WMD.sharpness
    local bottomConfig = DF.findBottomSharpnessConfigLevel(weaponConfig, WMD.sharpness)
    local upperConfig = DF.findUpperSharpnessConfigLevel(weaponConfig, WMD.sharpness)
    if not bottomConfig or not upperConfig then
        print("ESYB ERROR! Sharpness config not found!")
        print("Item: ", fullType)
        print("Sharpness: ", sharpness)
        print("Bottom: ", bottomConfig)
        print("Upper: ", upperConfig)
        return {}
    end

    local sharpnessPercentageModifier = BU.weaponSharpnessPercentage(weapon, sharpness, bottomConfig, upperConfig)

    for i, property in ipairs(copiedPropertiesDictionary) do
        local setter = "set" .. property
        local newValue =
            bottomConfig[property] + ((upperConfig[property] - bottomConfig[property]) * sharpnessPercentageModifier)
        if property == "MinDamage" or property == "MaxDamage" then
            newValue = newValue * ESYB.Const.damageModifier
        elseif property == "CriticalChance" then
            newValue = newValue * ESYB.Const.criticalChanceModifier
        elseif property == "CritDmgMultiplier" then
            newValue = newValue * ESYB.Const.criticalDamageModifier
        else
            newValue = math.ceil(newValue)
        end

        weapon[setter](weapon, newValue)
    end
    weapon:setTooltip("Sharpness: " .. tostring(EMUF.round(WMD.sharpness, 4)) .. "%")
    WMD.sharpnessIcon = BU.sharpnessIcon(sharpness)

    -- print("*** APPLIED COMBAT STATS ***")
    -- print("Sharpness: ", EMUF.round(weapon:getModData().ESYB.sharpness, 4))
    -- print("MinDamage: ", EMUF.round(weapon:getMinDamage(), 4))
    -- print("MaxDamage: ", EMUF.round(weapon:getMaxDamage(), 4))
    -- print("CriticalChance: ", EMUF.round(weapon:getCriticalChance(), 4))
    -- print("CritDmgMultiplier: ", EMUF.round(weapon:getCritDmgMultiplier(), 4))
    -- print("DoorDamage: ", EMUF.round(weapon:getDoorDamage(), 2))
    -- print("TreeDamage: ", EMUF.round(weapon:getTreeDamage(), 2))
    -- print("Condition: ", EMUF.round(weapon:getCondition(), 2))
    -- print("Condition Max: ", EMUF.round(weapon:getConditionMax(), 2))
    -- print("*** END OF COMBAT STATS ***")
    return upperConfig
end

-- DONE
ESYB.BladesUse.applyCondition = function(weapon, newCondition)
    -- print("newCondition", newCondition)
    weapon:setCondition(math.floor(newCondition))
    weapon:getModData().ESYB.savedCondition = newCondition
end

-- DONE
ESYB.BladesUse.applySharpness = function(weapon, newSharpness, sharpnessDelta, weaponConfig)
    -- apply sharpness
    local WMD = weapon:getModData().ESYB
    sharpnessDelta = sharpnessDelta or 0
    if newSharpness then
        -- console.log("Changed sharpness to: ", EMUF.round(newSharpness, 4), true)
        WMD.sharpness = newSharpness
    else
        -- console.log(
        --     "Changed sharpness by: " .. tostring(EMUF.round(sharpnessDelta, 4)) .. " to " .. tostring(WMD.sharpness),
        --     "",
        --     true
        -- )
        WMD.sharpness = WMD.sharpness - sharpnessDelta
    end
    WMD.sharpness = math.max(WMD.sharpness, 0)
    -- weapon:setTooltip("Sharpness: " .. tostring(EMUF.round(WMD.sharpness, 4)) .. "%")
    return ESYB.BladesUse.applyCombatStats(weapon, weaponConfig)
end

function ESYB.BladesUse.destroyWeapon(weapon, player)
    local inv = player:getInventory()
    local fullType = weapon:getFullType()
    -- local weaponConfig = ESYB.Dict.weapons[fullType]
    local scrapItemFullType
    if ESYB.Dict.weapons[fullType] then
        scrapItemFullType = ESYB.Dict.weapons[fullType].scrap or ESYB.Dict.scrapTable[fullType] or "Base.ScrapMetal"
    else
        scrapItemFullType = ESYB.Dict.scrapTable[fullType] or "Base.ScrapMetal"
    end
    local scrap = inv:AddItem(scrapItemFullType)
    local doubleHanded = player:isItemInBothHands(weapon)
    local hotbar = getPlayerHotbar(player:getPlayerNum())

    if hotbar:isInHotbar(weapon) then
        player:removeAttachedItem(weapon)
    end
    player:playSound(weapon:getBreakSound())
    -- delete old weapon
    inv:DoRemoveItem(weapon)
    player:setPrimaryHandItem(scrap)
    if doubleHanded then
        player:setSecondaryHandItem(nil)
    end
    ESYB.dialogue("And this is the end of this weapon...")
end

ESYB.BladesUse.abradeWeapon = function(player, weapon, abrasionValue, abrasionModifier, contextAction)
    if abrasionValue > 0 then
        local WMD = ESYB.getWMD(weapon)
        -- print("WMD.savedCondition", WMD.savedCondition)
        -- print("abrasionValue", abrasionValue)
        local newCondition = WMD.savedCondition - abrasionValue

        -- console.log(
        --     "Abrasion value: " .. EMUF.round(abrasionValue, 4),
        --     " Condition from: " .. EMUF.round(weapon:getCondition(), 4) .. " to: " .. EMUF.round(newCondition, 4),
        --     true
        -- )
        if newCondition < ESYB.Const.minCondition then -- destroy weapon
            BU.destroyWeapon(weapon, player)
        else -- decrease condition
            BU.applyCondition(weapon, newCondition)
            if abrasionModifier == 1 then
                local message = contextActionMessages[contextAction]
                if message then
                    ESYB.dialogue(message)
                end
            end
        end
    end
end

ESYB.BladesUse.blunten = function(player, weapon, contextSharpnessLossModifier, contextAction)
    -- print("weapon ", weapon)
    if not weapon then
        return
    end
    local weaponConfig = ESYB.Dict.weapons[weapon:getFullType()]
    -- print("weapon config", weaponConfig)
    if not weaponConfig then
        return
    end
    contextSharpnessLossModifier = contextSharpnessLossModifier or 1
    contextAction = contextAction or "onHit"
    local WMD = weapon:getModData().ESYB
    if not WMD then
        print("ESYB ERROR! WMD not found! Item: ", weapon:getFullType())
        print("WMD: ", WMD)
        return
    end
    local truePreviousCondition = WMD.savedCondition or ESYB.Const.maxCondition
    local roundedPreviousCondition = math.floor(truePreviousCondition)
    local currentCondition = weapon:getCondition()
    local conditionDiff = math.min(1.5, roundedPreviousCondition - currentCondition)
    local maxAbrasion = ESYB.Options.maxAbrasion()
    -- console.log(
    --     "PreviousCondition: " .. tostring(roundedPreviousCondition),
    --     " (" .. tostring(EMUF.round(truePreviousCondition, 4)) .. ")",
    --     false
    -- )
    -- console.log("currentCondition: ", currentCondition, true)
    -- console.log("conditionDiff: ", conditionDiff, true)

    if currentCondition < roundedPreviousCondition then
        BU.applyCondition(weapon, truePreviousCondition)
        local sharpnessDelta =
            conditionDiff * ESYB.Options.valueOf("bladesSharpnessLossRate") *
            (1 / ESYB.Dict.functions.getWeaponHardness(weapon)) *
            ESYB.Const.sharpnessLossMultiplier *
            contextSharpnessLossModifier

        -- console.log("Sharpness delta: ", sharpnessDelta)
        -- console.log("bladesSharpnessLossRate: ", ESYB.Options.valueOf("bladesSharpnessLossRate"))
        -- console.log("Hardness modifier: ", (1 / ESYB.Dict.functions.getWeaponHardness(weapon)))
        -- console.log("ESYB.Const.sharpnessLossMultiplier: ", ESYB.Const.sharpnessLossMultiplier)
        -- console.log("contextSharpnessLossModifier: ", contextSharpnessLossModifier)

        local upperCfg = ESYB.BladesUse.applySharpness(weapon, nil, sharpnessDelta, weaponConfig)
        -- console.log("upperCFG", upperCfg)

        local sharpnessLevel = upperCfg.index
        local abrasionModifier

        if WMD.sharpness <= 0 then -- obligatorily abrade weapon
            abrasionModifier = 1
        else -- or ekseif
            abrasionModifier = BU.rollAbrasionModifierOnHit(weapon, sharpnessLevel)
        end
        local abrasionValue = maxAbrasion * abrasionModifier

        -- console.log("Abrasion modifier: ", abrasionModifier)
        -- console.log("Abrasion value: ", abrasionValue)

        BU.abradeWeapon(player, weapon, abrasionValue, abrasionModifier, contextAction)
    elseif currentCondition > roundedPreviousCondition then
        BU.applyCondition(weapon, currentCondition)
    -- REMOVED PENALTY FOR REPAIRING, AS REPAIRING BLOCKED IN OTHER WAY
    -- PENALTY INTERFERED WITH REFURBISH MOD
    -- BU.applyCondition(weapon, truePreviousCondition)
    -- BU.abradeWeapon(player, weapon, maxAbrasion, 1, "penalty")
    -- player cheating
    end
end

ESYB.BladesUse.rollAbrasionModifierOnHit = function(weapon, sharpnessLevel)
    local maxLevel = 5
    -- console.log("SHARPNESS LEVEL", sharpnessLevel)
    local minAbrasionChance = ESYB.Dict.abrasionChancePerLevel[math.min(sharpnessLevel, maxLevel)]
    if minAbrasionChance == 0 then
        return 0
    end
    local maxAbrasionChance = ESYB.Dict.abrasionChancePerLevel[math.min(sharpnessLevel + 1, maxLevel)]
    local sharpnessPercentageOfBlunt = BU.weaponSharpnessPercentage(weapon)
    local randomizeNumber = ESYB.Const.maxCondition * 10
    local modifiedAbrasionChance =
        (minAbrasionChance + ((maxAbrasionChance - minAbrasionChance) * sharpnessPercentageOfBlunt)) *
        ESYB.Options.valueOf("abrasionChanceOnHit") *
        (1 / DF.getWeaponDurability(weapon))
    local abrasionRollTreshold = modifiedAbrasionChance * randomizeNumber
    local roll = ZombRand(randomizeNumber) + 1
    if roll <= abrasionRollTreshold then
        return roll / abrasionRollTreshold
    else
        return 0
    end
end

Events.OnPlayerAttackFinished.Add(ESYB.BladesUse.blunten)
