require "TimedActions/ISBaseTimedAction"

TransponderAction = ISBaseTimedAction:derive("TransponderAction")

function TransponderAction:isValid()
    if self.character and self.device and self.mode then
        if self["isValid"..self.mode] then
            return self["isValid"..self.mode](self);
        end
    end
end

function TransponderAction:perform()
    if self.character and self.mode then
        if self["perform"..self.mode] then
            self["perform"..self.mode](self);
        end
    end

    ISBaseTimedAction.perform(self)
end

function TransponderAction:isValidToggleOnOff()
    return true;
end

function TransponderAction:performToggleOnOff()
    if TransponderAction:isValidToggleOnOff() then
        self.character:playSound("TelevisionOn");
        Transponder:ToggleOnOff(self.character, self.device);
    end
end

function TransponderAction:new(mode, character, device) 
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.mode = mode;
    o.character = character;
    o.device = device;

    o.stopOnWalk = false;
    o.stopOnRun = true;
    o.maxTime = 30;

    return o;
end