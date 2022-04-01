function ISChopTreeAction:animEvent(event, parameter)
    if event == "ChopTree" then
        self.tree:WeaponHit(self.character, self.axe)
        self:useEndurance()
        if ESYB.isValidESYBItem(self.axe) then
            self.axe:setCondition(self.axe:getCondition() - 1)
            ESYB.BladesUse.blunten(self.character, self.axe, 0.25, "chopTree")
            ISWorldObjectContextMenu.checkWeapon(self.character)
        else
            if ZombRand(self.axe:getConditionLowerChance() * 2 + self.character:getMaintenanceMod() * 2) == 0 then
                self.axe:setCondition(self.axe:getCondition() - 1)
                ISWorldObjectContextMenu.checkWeapon(self.character)
            else
                self.character:getXp():AddXP(Perks.Maintenance, 1)
            end
        end
        if self.tree:getObjectIndex() == -1 then
            self:forceComplete()
        end
    end
end
