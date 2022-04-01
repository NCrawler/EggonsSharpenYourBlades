if Recipe and Recipe.OnCreate then
    local oldCreateSpear = Recipe.OnCreate.CreateSpear
    function Recipe.OnCreate.CreateSpear(items, result, player, selectedItem, ...)
        oldCreateSpear(items, result, player, selectedItem, ...)
        for i = 0, items:size() - 1 do
            local item = items:get(i)
            if
                instanceof(item, "HandWeapon") and item:getCategories():contains("SmallBlade") and
                    ESYB.isValidESYBItem(item)
             then
                local WMD = ESYB.getWMD(item)
                local condition = item:getCondition()
                if WMD and WMD.savedCondition > condition then
                    item:setCondition(WMD.savedCondition - 2)
                    ESYB.BladesUse.blunten(player, item, 1, "Crafting")
                    break
                end
            end
        end
    end
end
