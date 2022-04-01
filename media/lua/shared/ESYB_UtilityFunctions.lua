ESYB.functions = ESYB.functions or {}
local EMUF = EggonsMU.functions

ESYB.functions.log = function(message, item)
end

function ESYB.dialogue(message)
    if ESYB.Options.playerDialogues then
        getPlayer():Say(message)
    end
end

function ESYB.getWeaponConfig(weapon)
    local fullType = weapon:getFullType()
    local output = ESYB.Dict.weapons[fullType] or ModData.getOrCreate("ESYB").weaponConfigs[fullType]
    return output
end

function ESYB.getWMD(item)
    local MD = item:getModData()
    if not MD.ESYB then
        MD.ESYB = {}
    end
    return MD.ESYB
end

function ESYB.isFeaturedCategory(item)
    local output = false
    for category, value in pairs(ESYB.Dict.featuredWeaponCategories) do
        if value then
            if instanceof(item, "Item") then
                output = item:getCategories():contains(category)
            else
                output = item:getScriptItem():getCategories():contains(category)
            end
            if output then
                break
            end
        end
    end
    return output
end

function ESYB.isValidESYBItem(item, _fullType)
    local fullType = _fullType or item:getFullType()
    local WMD = item:getModData()

    if (ESYB.Options.excludeWeirdItems and ESYB.Dict.excludedItems[fullType]) then
        if WMD.ESYB then
            WMD.ESYB = nil
        end
        return false
    elseif WMD.Melee then -- excluding Arsenal mod
        return false
    end

    local output = ESYB.Dict.weapons[fullType]
    -- print("is valid ESYB item? ", fullType)
    if output then
        -- print("Is a valid ESYB item, has PRIMARY dictionary, " .. fullType)
        -- EggonsMU.printFuckingNormalObject(output, "CFG from Dictionary")
        -- EggonsMU.printFuckingNormalObject(output.levels, "CFG from Dictionary")
        -- EggonsMU.printFuckingNormalObject(ESYB.Dict.weapons, " Dictionary")
        return output
    end
    -- print("NOT IN PRIMARY dictionary, " .. fullType)

    if ESYB.isFeaturedCategory(item) then
        output = ESYB.BladesConversion.generateWeaponConfig(item, fullType)

        -- EggonsMU.printFuckingNormalObject(output, "Generated weaponCfg")
        -- print("cfg output ", output)
        return output
    else
        return false
    end
end

function ESYB.functions.printWeaponStats(weapon)
    local isModded = not (not weapon:getModData().ESYB)
    local fullType = weapon:getFullType()
    local cfg = ESYB.Dict.weapons[fullType]
    print("*** APPLIED COMBAT STATS ***")
    print("*** IS MODDED: " .. tostring(isModded))
    print("***")
    print(
        "Condition: " .. tostring(weapon:getCondition()) .. " / Max Condition: " .. tostring(weapon:getConditionMax())
    )
    if isModded then
        print("Saved condition: ", EMUF.round(weapon:getModData().ESYB.savedCondition, 4))
        print("Sharpness: ", EMUF.round(weapon:getModData().ESYB.sharpness, 4))
    end
    print("***")
    print(
        "MinDamage: " ..
            tostring(EMUF.round(weapon:getMinDamage(), 2)) ..
                "    ***   MaxDamage: " .. tostring(EMUF.round(weapon:getMaxDamage(), 2))
    )
    print(
        "CriticalChance: " ..
            tostring(EMUF.round(weapon:getCriticalChance(), 2)) ..
                "     ***   CritDmgMultiplier: " .. tostring(EMUF.round(weapon:getCritDmgMultiplier(), 2))
    )
    print(
        "DoorDamage: " ..
            tostring(EMUF.round(weapon:getDoorDamage(), 2)) ..
                "     ***   TreeDamage: " .. tostring(EMUF.round(weapon:getTreeDamage(), 2))
    )
    print("LowerChanceIn: " .. tostring(EMUF.round(weapon:getConditionLowerChance(), 2)))
    print("Blade durability: " .. tostring(EMUF.round(cfg.bladeDurability, 2)))
    print("Blade hardness: " .. tostring(EMUF.round(cfg.bladeHardness, 2)))
    print("*** END OF COMBAT STATS ***")
end
