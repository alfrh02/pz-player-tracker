require "RadioCom/RadioWindowModules/RWMPanel"

TWMDirector = RWMPanel:derive("TWMDirector")

function TWMDirector:initialise()
    ISPanel.initialise(self);
end

function TWMDirector:createChildren()
    self:setHeight(210)
    
    -- width and height are from image dimensions
    self.director = UIDirector:new(self.width*0.1, 5, 200, 200);
    self.director:initialise();
    self:addChild(self.director);
end

function TWMDirector:new(x, y, width, height)
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
    o.achorLeft = true;
    o.anchorRight = false;
    o.anchorTop = true;
    o.anchorBottom = false;
    o.fontheight = getTextManager():MeasureStringY(UIFont.Small, "AbdfghijklpqtyZ")+2;
    return o;
end