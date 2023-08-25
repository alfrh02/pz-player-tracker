require "RadioCom/RadioWindowModules/RWMSignal"

TWMSignal = RWMSignal:derive("TWMSignal");

function TWMSignal:update()
    ISPanel.update(self);
    self.sineWaveDisplay:toggleOn(Transponder:getIsTurnedOn());
end