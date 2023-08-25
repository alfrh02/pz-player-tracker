require "RadioCom/RadioWindowModules/RWMPanel"

TWMTracker = RWMPanel:derive("TWMTracker");

local FONT_SMALL = getTextManager():getFontHeight(UIFont.Small);

local players, isOnline, target, targetUsername, targetCharname;
function TWMTracker:initialise()
    ISPanel.initialise(self)
end

function TWMTracker:createChildren()
    local y = 0;

    self.dropdownBox = ISComboBox:new(10, 5, self.width-20, FONT_SMALL + 2 * 2, self, TWMTracker.dropdownBoxChange)
    self.dropdownBox:initialise();
    self:addChild(self.dropdownBox);

    self.dropdownBox.options = {};

    isOnline = getOnlinePlayers() ~= nil;
    TWMTracker:updateDropdownOptions(self.dropdownBox);

    y = self.dropdownBox:getY() + self.dropdownBox:getHeight();

    self.trackButton = ISButton:new(10, y+5, self.width-20, FONT_SMALL + 1 * 2, "Track", self, TWMTracker.doTrackButton);
    self.trackButton:initialise();

    self.trackButton.backgroundColor = {r=0, g=0, b=0, a=0.0};
    self.trackButton.backgroundColorMouseOver = {r=1.0, g=1.0, b=1.0, a=0.1};
    self.trackButton.borderColor = {r=1.0, g=1.0, b=1.0, a=0.3};
    self:addChild(self.trackButton);
    
    y = self.trackButton:getY() + self.trackButton:getHeight() + 5;

    self:setHeight(y);
end 

function TWMTracker:updateDropdownOptions(dropdown)
    players = getOnlinePlayers();
    if isOnline then
        for i = 0, players:size()-1 do
            table.insert(dropdown.options, players:get(i):getUsername());
        end
    else
        dropdown.options = { getPlayer():getUsername() };
    end
end

function TWMTracker:dropdownBoxChange(selected)
    if isOnline then
        target = getOnlinePlayers():get(self.dropdownBox.selected-1);
    else
        target = getPlayer();
    end
    targetCharname = target:getDisplayName();
    targetUsername = target:getUsername();
end

function TWMTracker:doTrackButton()
    Transponder:changeTarget(self.dropdownBox.selected-1, target, targetCharname, targetUsername)
end

function TWMTracker:readFromObject(player, deviceObject, deviceData, deviceType)
    return RWMPanel.readFromObject(self, player, deviceObject, deviceData, deviceType)
end

function TWMTracker:new(x, y, width, height)
    local o = RWMPanel:new(x, y, width, height);
    setmetatable(o, self);
    self.__index = self;
    o.x = x;
    o.y = y;
    o.background = true;
    o.backgroundColor = {r=0, g=0, b=0, a=0.0};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.width = width;
    o.height = height;
    o.anchorLeft = true;
    o.anchorRight = false;
    o.anchorTop = true;
    o.anchorBottom = false;
    o.fontheight = getTextManager():MeasureStringY(UIFont.Small, "AbdfghijklpqtyZ")+2;
    o.parent = nil;
    o.lastModeExpanded = false;
    return o;
end