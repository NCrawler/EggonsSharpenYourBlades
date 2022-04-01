if EggonsMU then
    EggonsMU.config.enableEvent("OnAfterItemTransfer")
    EggonsMU.config.enableEvent("OnBeforeFirstInventoryTooltipDisplay")
    EggonsMU.enableEvent.OnDisplayLootContainerContents()
    EggonsMU.enableEvent.OnDisplayInventoryContainerContents()
    EggonsMU.config.enableEvent("OnHotbarItemAttached")
end

-- INSPIRED BY ITEM TWEAKER API
local Katana = ScriptManager.instance:getItem("Base.Katana")
if Katana ~= nil then
    Katana:DoParam("AttachmentType = Knife")
end
