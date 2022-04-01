ESYB.Dict.functions = {}
local console = ESYB.functions

local weapons = ESYB.Dict.weapons

function ESYB.Dict.functions.findBottomSharpnessConfig(weaponOrType, sharpness)
    if typeof(weaponOrType) ~= "string" then
        weaponOrType = weaponOrType:getFullType()
    end
    local WMD = weaponOrType:getModData().ESYB
end

ESYB.Dict.functions.findWeaponsSharpnessLevelByFullType = function(fullType)
    local weaponCfg = weapons[fullType].levels
    -- for
end
ESYB.Dict.functions.findWeaponsSharpnessLevelByInstance = function(weapon)
    return ESYB.Dict.functions.findWeaponsSharpnessLevelByFullType(weapon:getFullType())
end
ESYB.Dict.functions.findWeaponsSharpnessConfigByFullType = function(fullType)
    local weaponCfg = weapons[fullType]
end
ESYB.Dict.functions.findWeaponsSharpnessConfigByWeapon = function(weapon)
    return ESYB.Dict.functions.findWeaponsSharpnessConfigByFullType(weapon:getFullType())
end
ESYB.Dict.functions.findBottomSharpnessConfigLevel = function(weaponCfg, sharpness)
    local output
    -- EggonsMU.printFuckingNormalObject(weaponCfg, "weaponCfg")
    -- EggonsMU.printFuckingNormalObject(weaponCfg.levels, "weaponCfg.levels")
    for i, cfg in pairs(weaponCfg.levels) do
        if i == 0 and cfg.maxSharpness > sharpness then
            output = cfg
            output.index = i
            break
        elseif cfg.maxSharpness < sharpness then -- found lower
            output = cfg
            output.index = i
        elseif cfg.maxSharpness >= sharpness and output then -- znaleziony pierwszy większy
            break
        end
    end
    return output
end
ESYB.Dict.functions.findUpperSharpnessConfigLevel = function(weaponCfg, sharpness)
    local output
    -- EggonsMU.printFuckingNormalObject(weaponCfg, "weaponCfg for find upper")
    -- EggonsMU.printFuckingNormalObject(weaponCfg.levels, "weaponCfg levels for find upper")
    -- console.log("Sharpness for find upper", sharpness)

    for i, cfg in pairs(weaponCfg.levels) do
        if cfg.maxSharpness >= sharpness then
            output = cfg
            output.index = i
            break
        end
    end
    -- EggonsMU.printFuckingNormalObject(output, "UPPER CONFIG FOUND")
    return output
end
ESYB.Dict.functions.getWeaponDurability = function(weapon)
    return ESYB.Dict.weapons[weapon:getFullType()].bladeDurability
end
ESYB.Dict.functions.getWeaponHardness = function(weapon)
    return ESYB.Dict.weapons[weapon:getFullType()].bladeHardness
end
