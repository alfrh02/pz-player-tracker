require "ISUI/ISCollapsableWindow"

TransponderWindow = ISCollapsableWindow:derive("TransponderWindow")
TransponderWindow.instances = {};
TransponderWindow.modules = {};

function TransponderWindow.activate(player, device)
    local playerNum = player:getPlayerNum();
    
    player:setVariable("ExerciseStarted", false);
    player:setVariable("ExerciseEnded", true);

    TransponderWindow.player = player;
    TransponderWindow.device = device;
    TransponderWindow.deviceType = "InventoryItem";

    local window;
    local instances = TransponderWindow.instances;
    if instances[playerNum] then 
        window = instances[playerNum];
    else
        window = TransponderWindow:new(100, 100, 250, 25, player, device, device:getDisplayName());

        window:initialise();     
        window:instantiate();    

        -- if playerNum == 0 then 
        --     ISLayoutManager.RegisterWindow('transponderwindow', ISCollapsableWindow, window);
        -- end

        instances[playerNum] = window;
    end

    window:addToUIManager();
    window:setVisible(true);

    return window;
end

function TransponderWindow:addModule(modulePanel, moduleName)
    local module = {};
    module.element = RWMElement:new(0, 0, self.width, 0, modulePanel, moduleName, self)
    table.insert(self.modules, module);
    self:addChild(module.element);
end

function TransponderWindow:createChildren()
    ISCollapsableWindow.createChildren(self);
   
    self:addModule(TWMPower:new(0, 0, self.width, 0, self.device), getText("IGUI_RadioPower"));
    TWMPower:readFromObject(self.player, self.device, nil, "InventoryItem");
    self:addModule(TWMTracker:new(0, 0, self.width, 0), "Tracker");
    self:addModule(TWMDirector:new(0, 0, self.width, 0), "Director");
    self:addModule(TWMSignal:new(0, 0, self.width, 0), getText("IGUI_RadioSignal"));
end

function TransponderWindow:update()
    ISCollapsableWindow.update(self);

    if (getPlayer():getInventory():contains(self.device)) then
        return;
    end
    
    if (Transponder.enabled == true) then
        Transponder:ToggleOnOff(self.player, self.device);
    end

    self:close();
end

function TransponderWindow:prerender()
    ISCollapsableWindow.prerender(self);

    local y = self:titleBarHeight() + 1;
    for i = 1, #self.modules do
        self.modules[i].element:setY(y);
        y = y + self.modules[i].element:getHeight() + 1;
    end
    self:setHeight(y);
end

function TransponderWindow:new(x, y, width, height, player, device, title)
    local o = {};

    o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self);
    self.__index = self;
    o.x = x;
    o.y = y;
    o.player = player;
    o.device = device;

    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.backgroundColor = {r=0, g=0, b=0, a=0.8};

    o.width = width;
    o.height = height;
    o.anchorLeft = true;
    o.anchorRight = false;
    o.anchorTop = true;
    o.anchorBottom = false;

    o.pin = true;
    o.isCollapsed = false;
    o.collapseCounter = 0;
    o.title = title; --"Transponder Window";
    o.resizable = false;
    o.drawFrame = true;

    return o;
end 

function TransponderWindow.onEquip(_player, _item)
    if (_player == getPlayer()) and (_item ~= nil) then
        if (_item:getModID() == "player-tracker") then
            TransponderWindow.activate(_player, _item)
        end 
    end
end

Events.OnEquipPrimary.Add(TransponderWindow.onEquip);
Events.OnEquipSecondary.Add(TransponderWindow.onEquip);