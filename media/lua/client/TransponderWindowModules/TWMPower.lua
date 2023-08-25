require "RadioCom/RadioWindowModules/RWMPanel"

TWMPower = RWMPanel:derive("TWMPower");

function TWMPower:initialise()
    ISPanel.initialise(self);
end

function TWMPower:createChildren()
    self:setHeight(32);

    local xoff = 0;

    self.led = ISLedLight:new(10, (self.height-10)/2, 10, 10);
    self.led:initialise();
    self.led:setLedColor(1,0,1,0);
    self.led:setLedColorOff(1,0,0.3,0);
    self:addChild(self.led);

    xoff = self.led:getX() + self.led:getWidth();

    local buttonW = getTextManager():MeasureStringX(UIFont.Small, getText("ContextMenu_Turn_Off"))+10;
    self.toggleOnOffButton = ISButton:new(xoff+10, 4, buttonW, self.height-8, getText("ContextMenu_Turn_On"), self, TWMPower.toggleOnOff)
    self.toggleOnOffButton:initialise();
    self.toggleOnOffButton.backgroundColor = {r=0, g=0, b=0, a=0.0};
    self.toggleOnOffButton.backgroundColorMouseOver = {r=1.0, g=1.0, b=1.0, a=0.1};
    self.toggleOnOffButton.borderColor = {r=1.0, g=1.0, b=1.0, a=0.3};
    self:addChild(self.toggleOnOffButton);

    xoff = xoff + (self.toggleOnOffButton:getX() - xoff) + self.toggleOnOffButton:getWidth();
end

function TWMPower:toggleOnOff()
    ISTimedActionQueue.add(TransponderAction:new("ToggleOnOff", self.player, self.device));
end

function TWMPower:update()
    ISPanel.update(self);
   
    if self.player then  
        local isOn = Transponder:getIsTurnedOn()   
        self.led:setLedIsOn(isOn);
        if (isOn == true) then
            self.toggleOnOffButton:setTitle(getText("ContextMenu_Turn_Off"));
        else
            self.toggleOnOffButton:setTitle(getText("ContextMenu_Turn_On"));
        end
    end
end

function TWMPower:readFromObject(player, deviceObject, deviceData, deviceType)
    self.player = player;
    return RWMPanel.readFromObject(self, player, deviceObject, deviceData, deviceType)
end

function TWMPower:new(x, y, width, height, device)
    local o = RWMPanel:new(x, y, width, height);
    setmetatable(o, self);
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
    -- o.batteryTex = getTexture("Item_Battery");
    o.device = device;
    return o
end