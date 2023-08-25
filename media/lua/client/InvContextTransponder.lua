ISInventoryMenuElements = ISInventoryMenuElements or {};

function ISInventoryMenuElements.ContextTransponder()
    local self = ISMenuElement.new();
    self.invMenu = ISContextManager.getInstance().getInventoryMenu();

    function self.init()
    end

    function self.createMenu(_item)
        if (_item:getModID() == "player-tracker" and _item:getContainer():getType() ~= "floor") then
            self.invMenu.context:addOption(getText("IGUI_DeviceOptions"), self.invMenu, self.ActivateUI, _item);
        end
    end

    function self.ActivateUI(_p, _item)
        TransponderWindow.activate(_p.player, _item);
    end

    return self
end