ESYB = ESYB or {}
local console = ESYB.functions

ESYB.BladesConversion = {}
local BC = ESYB.BladesConversion
local Dict = ESYB.Dict
local ISBladesConversion = {} -- TEMP
local checkedInventoryContainers = {}

-- 1. CONVERT WEAPON FROM VANILLA
ESYB.BladesConversion.convertVanillaWeapon = function(weapon, weaponConfig)
    local MD = weapon:getModData()
    weapon:setConditionMax(100)
    weapon:setConditionLowerChance(-1000)
    if not MD.ESYB then
        -- Czy apply stats tutaj, czy przy attach?
        -- print("Initial condition: ", weapon:getCondition())
        -- print("Initial sharpness: ", WMD.sharpness)
        MD.ESYB = {}
        local WMD = MD.ESYB
        BC.assignInitialSharpness(weapon, weaponConfig)
        BC.assignInitialCondition(weapon)
        WMD.equippedIconLeft = weaponConfig.equippedIconLeft
    else -- assign stored condition?
        ESYB.BladesUse.applyCombatStats(weapon, weaponConfig)
    end
end

ESYB.BladesConversion.rollInitialValue = function(chancesConfig)
    local luckRoll = ZombRand(100) + 1
    if luckRoll <= chancesConfig[1] then
        -- Range <3, 20>
        sharpnessRoll = {17, 3}
    elseif luckRoll <= chancesConfig[2] then
        -- Range < 21, 40 >
        sharpnessRoll = {20, 20}
    elseif luckRoll <= chancesConfig[3] then
        -- Range < 41, 60 >
        sharpnessRoll = {20, 40}
    elseif luckRoll <= chancesConfig[4] then
        -- Range < 61, 80 >
        sharpnessRoll = {20, 60}
    else
        -- Range < 81, 100 >
        sharpnessRoll = {20, 80}
    end
    luckRoll = ZombRand(sharpnessRoll[1]) + sharpnessRoll[2] + 1
    return luckRoll
end

ESYB.BladesConversion.assignInitialSharpness = function(weapon, weaponConfig)
    local chancesConfig = Dict.chanceToFindSharp[ESYB.Options.chanceToFindSharp]
    local sharpnessRoll = BC.rollInitialValue(chancesConfig)
    ESYB.BladesUse.applySharpness(weapon, sharpnessRoll, nil, weaponConfig)
end

ESYB.BladesConversion.assignInitialCondition = function(weapon)
    local chancesConfig = Dict.chanceToFindCondition[ESYB.Options.chanceToFindCondition]
    local conditionRoll = BC.rollInitialValue(chancesConfig)
    ESYB.BladesUse.applyCondition(weapon, conditionRoll)
end
ESYB.BladesConversion.convertWeaponIfRequired = function(item)
    local itemCfg = ESYB.isValidESYBItem(item)
    if itemCfg then
        ESYB.BladesConversion.convertVanillaWeapon(item, itemCfg)
    end
end
ESYB.BladesConversion.checkForWeaponsToConvert = function(container)
    -- console.log("displayed container: ", container:getType())
    -- print("Starting check for weapons to convert")
    local inventory = getPlayer():getInventory()
    local itemsInContainer = container:getItems()
    local itemsCount = itemsInContainer:size()
    local fullType
    if itemsCount > 0 then
        for i = 0, itemsCount - 1 do
            local item = itemsInContainer:get(i)
            BC.convertWeaponIfRequired(item)
        end
    end
end
-- reduces invenotry lookups to not yet checked containers
ESYB.BladesConversion.checkForWeaponsToConvertIfRequired = function(container)
    if not checkedInventoryContainers[container] then
        BC.checkForWeaponsToConvert(container)
        checkedInventoryContainers[container] = true
    end
end
ESYB.BladesConversion.convertWeaponOnAttach = function(eventData)
    -- console.log("Item Attached: ", eventData.item:getType())
    BC.convertWeaponIfRequired(eventData.item)
end
ESYB.BladesConversion.convertWeaponOnTransferOrEquip = function(player, item)
    if item then
        BC.convertWeaponIfRequired(item)
    end
end
ESYB.BladesConversion.convertCarriedWeaponsOnStart = function()
    local containers = EggonsMU.functions.getCarriedContainers()
    for i, container in ipairs(containers) do
        BC.checkForWeaponsToConvertIfRequired(container)
    end
end

ESYB.BladesConversion.generateWeaponConfig = function(weapon, _fullType)
    local fullType = _fullType or weapon:getFullType()
    if ESYB.Dict[fullType] then
        return ESYB.Dict[fullType]
    end
    local ConditionLowerChanceOneIn = weapon:getConditionLowerChance()
    local ConditionMax = weapon:getConditionMax()
    local noOfVanillaUses = ConditionLowerChanceOneIn * ConditionMax
    local relativeWeaponStrength = noOfVanillaUses / 150
    local durabilityAndHardness = (math.min(1, relativeWeaponStrength) * 0.8) + 0.2
    local MinDamage = weapon:getMinDamage()
    local MaxDamage = weapon:getMaxDamage()
    local CriticalChance = weapon:getCriticalChance()
    local CritDmgMultiplier = weapon:getCritDmgMultiplier()
    local TreeDamage = weapon:getTreeDamage()
    local DoorDamage = weapon:getDoorDamage()
    local modData = ESYB.getModData()

    modData[fullType] = {
        vanillaCMax = ConditionMax,
        bladeDurability = durabilityAndHardness,
        bladeHardness = durabilityAndHardness,
        equippedIconLeft = false,
        levels = {}
    }
    for l = 0, 5 do
        local levelMultiplier = 0.2 * (1 + l)
        modData[fullType].levels[l] = {}
        local level = modData[fullType].levels[l]
        level.maxSharpness = math.floor(20 * l + 0.5)
        level.MinDamage = math.max(0.1, MinDamage * levelMultiplier)
        level.MaxDamage = math.max(0.1, MaxDamage * levelMultiplier)
        level.CriticalChance = math.floor(CriticalChance * levelMultiplier + 0.5)
        level.CritDmgMultiplier = math.max(1, math.floor(CritDmgMultiplier * levelMultiplier + 0.5))
        level.TreeDamage = math.max(1, TreeDamage * levelMultiplier)
        level.DoorDamage = math.max(1, DoorDamage * levelMultiplier)
        -- EggonsMU.printFuckingNormalObject(level, "Level " .. tostring(l) .. " for: " .. fullType )
    end
    ESYB.Dict.weapons[fullType] = modData[fullType]
    -- EggonsMU.printFuckingNormalObject(modData[fullType], "newConfig")
    -- EggonsMU.printFuckingNormalObject(ESYB.Dict.weapons[fullType], "ESYB.Dict[fullType]")
    return ESYB.Dict.weapons[fullType]
end

Events.OnDisplayLootContainerContents.Add(BC.checkForWeaponsToConvert)
Events.OnDisplayInventoryContainerContents.Add(BC.checkForWeaponsToConvertIfRequired)

Events.OnHotbarItemAttached.Add(BC.convertWeaponOnAttach)
Events.OnAfterItemTransfer.Add(BC.convertWeaponOnTransferOrEquip)
Events.OnEquipPrimary.Add(BC.convertWeaponOnTransferOrEquip)
Events.OnGameStart.Add(BC.convertCarriedWeaponsOnStart)
-- Events.OnConnected.Add(BC.convertCarriedWeaponsOnStart)
