ESYB = ESYB or {}
ESYB.Dict = ESYB.Dict or {weapons = {}}
ESYB.functions = ESYB.functions or {}

ESYB.Const = {
    criticalDamageModifier = 1,
    criticalChanceModifier = 1,
    damageModifier = 1,
    maxCondition = 100,
    minCondition = 3,
    sharpnessLossMultiplier = 0.9 -- multiplier to balance bluntening rate
}

function ESYB.getPlayerMemory(player)
    local playerModData = player:getModData()
    if not playerModData.ESYB then
        playerModData.ESYB = {}
    end
    return playerModData.ESYB
end

-- local function OnGameStart()
--     ESYB.Player = getPlayer()
--     ESYB.Memory = ESYB.getPlayerMemory(ESYB.Player)
-- end
-- Events.OnGameStart.Add(OnGameStart)

local function tweakWeaponsOnLoad()
    local weapon
    for fullType, weaponCfg in pairs(ESYB.Dict.weapons) do
        -- print("Tweaking: ", fullType)
        weapon = ScriptManager.instance:getItem(fullType)
        weaponCfg.vanillaCMax = weapon:getConditionMax()
        weapon:setConditionMax(ESYB.Const.maxCondition)
        weapon:setConditionLowerChance(-1000)
    end
    local Katana = ScriptManager.instance:getItem("Base.Katana")
    Katana:setMaxHitCount(3)
end
Events.OnGameBoot.Add(tweakWeaponsOnLoad)
-- Events.OnPreMapLoad.Add(tweakWeaponsOnLoad)

-- TECHNICAL
