require "ISUI/ISPanel"

UIDirector = ISPanel:derive("UIDirector");

function UIDirector:initialise()
    ISPanel.initialise(self);
end

-- my attempt to fix the director briefly being empty while the game fetches the right texture
-- maybe if i load all of the textures briefly beforehand itll be stored in memory? i have no idea
function UIDirector:createChildren()
    local textures = { "SouthEast", "South", "SouthWest", "West", "NorthWest", "North", "NorthEast", "East", "Full", "Empty" }

    for i = 1, #textures do
        self.texture = getTexture("media/textures/ui"..textures[i]..".png");
        self:drawTextureScaled(self.texture, 0, 0, self:getWidth(), self:getHeight(), 1.0, 1.0, 1.0, 1.0);
    end
end

function UIDirector:prerender()
    ISPanel.prerender(self);
end

function UIDirector:render()
    ISPanel.render(self);

    local texture = "Empty";
    if (Transponder.direction ~= nil and Transponder.enabled == true) then
        texture = Transponder.direction;
    end

    self.texture = getTexture("media/textures/ui/"..texture..".png");
    self:drawTextureScaled(self.texture, 0, 0, self:getWidth(), self:getHeight(), 1.0, 1.0, 1.0, 1.0);
end

function UIDirector:new(x, y, width, height)
    local o = ISPanel:new(x, y, width, height);
    setmetatable(o, self);
    o.x = x;
    o.y = y;
    o.background = false;
    o.backgroundColor = {r=1, g=0, b=0, a=1};
    o.borderColor = {r=0, g=0, b=0, a=0};
    o.width = width;
    o.height = height;
    o.anchorLeft = true;
    o.anchorRight = false;
    o.anchorTop = true;
    o.anchorBottom = false;
    return o;
end