local console = ESYB.functions

ISHotbar.ESYB_store_render = ISHotbar.render

local equippedIconCover = getTexture("media/ui/equippedIconCover.png")
local equippedItemIcon = getTexture("media/ui/icon.png")
local errorIcon = getTexture("media/ui/error.png")

function ISHotbar:render()
    self:ESYB_store_render()
    if ESYB.Options.displaySharpnessIndicator then
        local slotX = self.margins
        for i, slot in ipairs(self.availableSlot) do
            -- EggonsMU.printFuckingNormalObject(self, "self")
            -- EggonsMU.printFuckingNormalObject(self.attachedItems, "self.attachedItems")
            local item = self.attachedItems[i]
            if item then
                local WMD = item:getModData().ESYB
                -- local icon = WMD.sharpnessIcon
                if WMD then
                    local icon = WMD.sharpnessIcon or ESYB.BladesUse.sharpnessIcon(WMD.sharpness) or errorIcon
                    if item:isEquipped() then
                        local xEq, yEq, xCo, yCo
                        yEq = self.height - self.margins - 19
                        xCo = slotX + self.slotWidth - 11
                        yCo = self.height - self.margins - 10

                        if WMD.equippedIconLeft then
                            xEq = slotX + 2
                        else
                            xEq = slotX + self.slotWidth - equippedItemIcon:getWidth() - 5
                        end
                        self:drawTexture(equippedIconCover, xCo, yCo, 1, 1, 1, 1)
                        self:drawTexture(equippedItemIcon, xEq, yEq, 1, 1, 1, 1)
                    end
                    self:drawTexture(icon, slotX + 4, self.slotHeight - icon:getHeight() + 2, 1, 1, 1, 1)
                end
            end
            slotX = slotX + self.slotWidth + self.slotPad
        end
    end
end
