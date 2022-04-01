require "TimedActions/ISBaseTimedAction"

local console = ESYB.functions
local EMUF = EggonsMU.functions

local whetstones = ESYB.Dict.whetstones

local handInjuryGlovesModifiers = {
    ["Base.Gloves_LeatherGloves"] = 0,
    ["Base.Gloves_LeatherGlovesBlack"] = 0,
    ["Base.Gloves_LongWomenGloves"] = 0.5,
    ["Base.Gloves_WhiteTINT"] = 0.5,
    ["Base.Gloves_FingerlessGloves"] = 0.75,
    ["Base.Gloves_Surgical"] = 1 -- no bonus
}
local headInjuryGogglesModifiers = {
    ["Base.Glasses_SafetyGoggles"] = 0,
    ["Base.Glasses_SkiGoggles"] = 0,
    ["Base.Glasses_SwimmingGoggles"] = 0,
    ["Base.Glasses_Shooting"] = 0.25,
    ["Base.Glasses_Reading"] = 0.5,
    ["Base.Glasses_Normal"] = 0.5,
    ["Base.Glasses_Aviators"] = 0.7,
    ["Base.Glasses"] = 0.7,
    ["Base.Glasses_Sun"] = 0.7
}

local SharpenTimedAction = ISBaseTimedAction:derive("SharpenTimedAction")
ESYB.SharpenTimedAction = SharpenTimedAction

function ESYB.SharpenTimedAction:applyWound(bodyPart, severity)
    local actualBodyPart = self.player:getBodyDamage():getBodyPart(bodyPart)
    if severity == "wound" then
        actualBodyPart:generateDeepWound()
    elseif severity == "cut" then
        actualBodyPart:setCut(true)
    else
        actualBodyPart:setScratched(true, true)
    end
end

local function assignSeverity(rollResult)
    if rollResult < 0.3333 then
        return "scratched"
    elseif rollResult < 0.6667 then
        return "cut"
    else
        return "deepWound"
    end
end

function ESYB.SharpenTimedAction:calculateAbrasion()
    -- console.log("CalculateAbrasion")
    local maxAbrasion = ESYB.Options.maxAbrasion()
    local abrasion, baseAbrasion, damageAbrasion = 1, 1, 0
    baseAbrasion = 6 - (self.maintenaceLevel * 0.5)
    if not self.wasSuccess then
        damageAbrasion = math.max(5, baseAbrasion * 2)
    end
    abrasion = math.max(1, math.min(maxAbrasion, baseAbrasion + damageAbrasion))
    -- console.log("Calculated sharpening abrasion: ", abrasion, true)
    return abrasion
end

function ESYB.SharpenTimedAction:calculateAndApplyInjury()
    -- console.log("CalculateAndApplyInjury")
    local baseInjuryChance = 0.01
    local failureModifier = 1
    if not self.wasSuccess then
        failureModifier = 2
    end

    local incompetenceLevel = 10 - self.maintenaceLevel
    local headInjuryModifier = 0.5
    local maintenaceLevelInjuryChance = incompetenceLevel * 0.015

    local wornGloves = self.player:getClothingItem_Hands()

    local glovesModifier = handInjuryGlovesModifiers[wornGloves] or 1
    local severity, message

    local handInjuryChance = (baseInjuryChance + maintenaceLevelInjuryChance) * glovesModifier * failureModifier
    local injuredHand = EggonsMU.functions.rollSuccess(handInjuryChance)

    -- console.log("injuredHand: ", injuredHand)
    if injuredHand.success then
        severity = assignSeverity(injuredHand.successLevel - glovesModifier)
        local leftOrRight = ZombRand(2)
        local hand
        if leftOrRight == 0 then
            hand = BodyPartType.Hand_L
        else
            hand = BodyPartType.Hand_R
        end
        self:applyWound(hand, severity)
        if glovesModifier < 1 then
            message = "@#!@%! I cut myself! I need to find some better gloves!"
        else
            message = "Dammit! I cut myself! I knew it was risky to work without hand protection!"
        end
        ESYB.dialogue(message)
    end

    if self.contextAction == "machineSharpen" then
        local headInjuryChance = 0 -- only for mechanical
        local wornGlasses = self.player:getWornItem("Eyes")
        -- print("Glasses found: ", wornGlasses)
        -- tu musi być machine chance
        local gogglesModifier = headInjuryGogglesModifiers[wornGlasses] or 1
        headInjuryChance =
            (baseInjuryChance + maintenaceLevelInjuryChance) * headInjuryModifier * gogglesModifier * failureModifier
        local injuredHead = EggonsMU.functions.rollSuccess(headInjuryChance)
        if injuredHead.success then
            severity = assignSeverity(injuredHead.successLevel - gogglesModifier)
        end
        self:applyWound(BodyPartType.Head, severity)
        if gogglesModifier < 1 then
            message = "My eye! I need to find some better eyes protection!"
        else
            message = "My eye! Next time I need to find some eyes protection!"
        end
        ESYB.dialogue(message)
    end
end

function ESYB.SharpenTimedAction:calculateAndApplyXPGain()
    -- console.log("CalculateANdApplyXPGains")
    local XPGain = 0
    local recipeModifier = 2
    local flatMinimum = 1.5
    local successModifier = 1
    local maintenanceBookModEnabled = false
    local maintenaceLevelModifier = 1
    local XPModifier = ESYB.Options.valueOf("XPModifier")

    if self.wasSuccess then
        successModifier = 2
    else
        ESYB.dialogue("That didn't go so well. Need to practice more...")
    end

    local randomXP = (ZombRand(3) + 1) * 2
    local recipesBonus = 0

    if not maintenanceBookModEnabled then
        local numberOfBonusRecipes = ESYB.Dict.getNumberOfKnownRecipesFor("XPBonus")
        recipesBonus = numberOfBonusRecipes * recipeModifier
        maintenaceLevelModifier = math.max(1, self.maintenaceLevel * 1.5)
    end

    XPGain = (flatMinimum + randomXP + recipesBonus) * successModifier * maintenaceLevelModifier * XPModifier
    -- console.log("flatMinimum: ", flatMinimum)
    -- console.log("randomXP: ", randomXP)
    -- console.log("recipesBonus: ", recipesBonus)
    -- console.log("successModifier: ", successModifier)
    -- console.log("maintenaceLevelModifier: ", maintenaceLevelModifier)
    -- console.log("XPModifier: ", XPModifier)
    -- add XP
    self.player:getXp():AddXP(Perks.Maintenance, XPGain)
    -- console.log("Calculated XP from sharpenig: ", XPGain, true)
end
function ESYB.SharpenTimedAction:drainSharpeningItem()
    self.sharpeningTool:Use()
end

function ESYB.SharpenTimedAction:isValid()
    return true
end

-- function ESYB.SharpenTimedAction:waitToStart()
--     -- log("waitToStart")
--     return false
-- end

function ESYB.SharpenTimedAction:update()
    self.player:setMetabolicTarget(self.metabolics)
end

function ESYB.SharpenTimedAction:stop()
    self.player:getEmitter():stopSound(self.playedSound)
    -- log("start")
end
function ESYB.SharpenTimedAction:start()
    self.playedSound = self.player:getEmitter():playSound("SharpenWhetstone")
    -- log("start")
end

function ESYB.SharpenTimedAction:calculatePerfectFinish()
    -- console.log("Calculate perfect finish")

    self.wasSuccessPerfectFinish = EggonsMU.functions.rollSuccess(self.perfectFinishChance).success

    self.newSharpness = self.targetSharpnessLevel * 20
    if not self.wasSuccessPerfectFinish then
        self.newSharpness = self.newSharpness - 10
    end
end

function ESYB.SharpenTimedAction:perform()
    -- console.log("SHarpenAction:perform")
    -- calculate if success or failure
    -- console.log("self.successChance", self.successChance)
    self.wasSuccess = EggonsMU.functions.rollSuccess(self.successChance).success
    if self.wasSuccess then
        -- calculate if perfect finish
        self:calculatePerfectFinish()
        -- apply new sharpness (and combat stats)
        -- console.log("Ready to apply sharpness")
        ESYB.BladesUse.applySharpness(self.weapon, self.newSharpness, nil, nil)
    end

    self:calculateAndApplyInjury()
    -- abrade weapon and apply condition
    -- console.log("Ready to abrade weapon")
    ESYB.BladesUse.abradeWeapon(self.player, self.weapon, self:calculateAbrasion(), 1, self.contextAction)

    -- use one charge of the sharpening item
    self:drainSharpeningItem()

    self:calculateAndApplyXPGain()

    self.player:getEmitter():stopSound(self.playedSound)

    -- Remove Timed Action from stack
    ISBaseTimedAction.perform(self)
end

function ESYB.SharpenTimedAction:new(player, weapon, chanceConfig, targetSharpnessLevel, sharpeningTool)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.stopOnWalk = true
    o.stopOnRun = true
    o.weapon = weapon
    o.targetSharpnessLevel = targetSharpnessLevel
    o.sharpeningTool = sharpeningTool
    o.successChance = chanceConfig.sharpening
    o.perfectFinishChance = chanceConfig.perfectFinish
    o.chanceConfig = chanceConfig
    o.player = player
    o.character = player
    o.maintenaceLevel = player:getPerkLevel(Perks.Maintenance)
    local fullType = sharpeningTool:getFullType()
    if whetstones[fullType] then
        o.maxTime = 200
        o.metabolics = Metabolics.MediumWork
        o.contextAction = "manualSharpen"
    else
        o.metabolics = Metabolics.LightWork
        o.maxTime = 70
        o.contextAction = "machineSharpen"
    end
    return o
end
