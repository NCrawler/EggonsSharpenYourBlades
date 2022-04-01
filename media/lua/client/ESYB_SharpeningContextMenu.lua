ESYB.BladesSharpening = {}
local BS = ESYB.BladesSharpening
local console = ESYB.functions

local SharpeningFailureProbabilityTable = {
    [4] = {
        [0] = 1.25,
        [1] = 1.00,
        [2] = 0.75,
        [3] = 0.50,
        [4] = 0.25,
        [5] = 0,
        [6] = 0,
        [7] = 0,
        [8] = 0,
        [9] = 0,
        [10] = 0
    },
    [5] = {
        [0] = 1.75,
        [1] = 1.50,
        [2] = 1.25,
        [3] = 1.00,
        [4] = 0.75,
        [5] = 0.50,
        [6] = 0.25,
        [7] = 0,
        [8] = 0,
        [9] = 0,
        [10] = 0
    }
}

local ImperfectFinishProbabilityTable = {
    [4] = {
        [0] = 1.60,
        [1] = 1.40,
        [2] = 1.20,
        [3] = 1.00,
        [4] = 0.80,
        [5] = 0.60,
        [6] = 0.40,
        [7] = 0.20,
        [8] = 0,
        [9] = 0,
        [10] = 0
    },
    [5] = {
        [0] = 2.00,
        [1] = 1.80,
        [2] = 1.60,
        [3] = 1.40,
        [4] = 1.20,
        [5] = 1.00,
        [6] = 0.80,
        [7] = 0.60,
        [8] = 0.40,
        [9] = 0.20,
        [10] = 0
    }
}

local attemptOptionNameForLevel = {
    [4] = "Attempt sharpening to sharp",
    [5] = "Attempt sharpening to razor sharp"
}
local successOptionNameForLevel = {
    [4] = "Sharpen to sharp",
    [5] = "Sharpen to razor sharp"
}

ESYB.BladesSharpening.successChance = function(weapon, sharpeningTool, targetLevel)
    local player = getPlayer()
    local toolModifier = 1
    if sharpeningTool == "TableGrinder" and not player:getKnownRecipes():contains("TableGrinderUserManua") then
        toolModifier = 0.8
    end

    local maintenanceLevel = player:getPerkLevel(Perks.Maintenance)
    local sharpeningFailureProbability, ImperfectSharpeningProbability
    local sharpeningFailureConfig = SharpeningFailureProbabilityTable[targetLevel] or {}
    local imperfectFinishConfig = ImperfectFinishProbabilityTable[targetLevel] or {}
    local sharpeningFailureProbability = sharpeningFailureConfig[maintenanceLevel] or 0
    local imperfectFinishProbability = imperfectFinishConfig[maintenanceLevel] or 0
    local successBonus = 0
    local perfectionBonus = 0
    local sharpeningBonusRecipesCount = ESYB.Dict.getNumberOfKnownRecipesFor("sharpeningBonus", player)
    local perfectionBonusRecipesCount = ESYB.Dict.getNumberOfKnownRecipesFor("perfectionBonus", player)

    successBonus = sharpeningBonusRecipesCount * 0.25
    perfectionBonus = perfectionBonusRecipesCount * 0.2

    -- console.log("sharpeningFailureProbability core: ", sharpeningFailureProbability)
    -- console.log("successBonus: ", successBonus)
    -- console.log("toolModifier: ", toolModifier)
    -- console.log("imperfectFinishProbability core: ", imperfectFinishProbability)
    -- console.log("perfectionBonus: ", perfectionBonus)

    sharpeningFailureProbability = (sharpeningFailureProbability - successBonus) / toolModifier
    imperfectFinishProbability = imperfectFinishProbability - perfectionBonus

    local success = {
        sharpening = math.max(0, math.min(1 - sharpeningFailureProbability)),
        perfectFinish = math.max(0, math.min(1 - imperfectFinishProbability))
    }
    -- console.log("Succes to sharpen pre round:  ", success.sharpening)
    -- success.sharpening = EggonsMU.functions.round(success.sharpening, 2)
    -- success.perfectFinish = EggonsMU.functions.round(success.perfectFinish, 2)
    -- console.log("Succes to sharpen: ", success.sharpening, true)
    -- console.log("Succes to perfectFinish: ", success.perfectFinish, true)
    return success
end

ESYB.BladesSharpening.sharpenBlade = function(player, weapon, chancesConfig, targetLevel, sharpeningTool)
    -- schedule TimedAction
    local sharpenAction = ESYB.SharpenTimedAction:new(player, weapon, chancesConfig, targetLevel, sharpeningTool)
    ISTimedActionQueue.add(sharpenAction)
end

local function sharpenBladeWrapper(player, chancesConfig, sharpnessLevel, tool)
    return function(weapon)
        ESYB.BladesSharpening.sharpenBlade(player, weapon, chancesConfig, sharpnessLevel, tool)
    end
end

local function formatOption(option, chancesConfig, sharpnessLevel)
    if chancesConfig.sharpening <= 0 then
        option.notAvailable = true
        option.name = attemptOptionNameForLevel[sharpnessLevel] .. " (0% success)"
    elseif chancesConfig.sharpening < 1 then
        option.name =
            attemptOptionNameForLevel[sharpnessLevel] ..
            " (" .. tostring(EggonsMU.functions.round(chancesConfig.sharpening * 100, 1)) .. "% success)"
    else
        option.name = successOptionNameForLevel[sharpnessLevel] .. " (100% success)"
    end
end

local function addSharpeningOptions(playerNum, context, items)
    local player = getSpecificPlayer(playerNum)
    local item
    if items[1].items then
        item = items[1].items[1]
    else -- if right-clicked in hotbar
        item = items[1]
    end

    if ESYB.isValidESYBItem(item) then
        local repairText = "^" .. getText("ContextMenu_Repair")

        -- REMOVE REPAIR OPTION FROM CONTEXT MENU
        for i, option in ipairs(context.options) do
            local foundOption = false
            if option.name:find(repairText) then
                foundOption = true
                -- print("Removing ", option.name)
                table.remove(context.options, i)
                context.numOptions = context.numOptions - 1
                context:calcHeight()
            end
            if foundOption then
                option.id = i
            end
        end

        local fullType = item:getFullType()
        local WMD = item:getModData().ESYB
        if WMD and WMD.sharpness <= 80 then
            local inv = player:getInventory()
            for whetstoneType, _ in pairs(ESYB.Dict.whetstones) do
                local whetstone = inv:getFirstTypeRecurse(whetstoneType)
                if whetstone then
                    local sharpenOption =
                        context:addOption(
                        "Sharpen with " .. string.lower(whetstone:getDisplayName()),
                        whetstone,
                        subOptions
                    )
                    local sharpenSubMenu = ISContextMenu:getNew(context)
                    context:addSubMenu(sharpenOption, sharpenSubMenu)

                    local success5 = ESYB.BladesSharpening.successChance(item, "whetstone", 5)
                    local optionRazorSharp =
                        sharpenSubMenu:addOption("", item, sharpenBladeWrapper(player, success5, 5, whetstone))
                    formatOption(optionRazorSharp, success5, 5)

                    if success5.sharpening < 1 then
                        local success4 = ESYB.BladesSharpening.successChance(item, "whetstone", 4)
                        local optionSharp =
                            sharpenSubMenu:addOption("", item, sharpenBladeWrapper(player, success4, 4, whetstone))
                        formatOption(optionSharp, success4, 4)
                        -- print("Success sharpening 4: ", success4.sharpening)
                        if success4.sharpening < 1 then
                            local optionBarelySharp =
                                sharpenSubMenu:addOption(
                                "Sharpen to barely sharp (100% success).",
                                item,
                                sharpenBladeWrapper(player, {sharpening = 1, perfectFinish = 1}, 3, whetstone)
                            )
                        end
                    end
                end
            end
        end
    end
end
Events.OnFillInventoryObjectContextMenu.Add(addSharpeningOptions)
