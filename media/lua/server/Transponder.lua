require "ISBaseObject"

Transponder = ISBaseObject:derive("Transponder");

local targetX = 150;
local targetY = 150;
Transponder.enabled = false;
function Transponder:ToggleOnOff(player, device)
    
    Transponder.owner = player;
    Transponder.device = device;
    Transponder.target = nil;
    Transponder.distance = 100;
   
    if (Transponder.enabled) then
        Transponder.enabled = false;
       
        Transponder.owner:getEmitter():stopSoundByName(Transponder.sound);
        
        Events.EveryOneMinute.Remove(EventFunction);
        Events.OnPlayerUpdate.Remove(updateDirection);
    else
        Transponder.enabled = true
       
        Transponder.sound = ""; -- for if statement at the bottom of EventFunction()
        Transponder.direction = "Empty"; -- for UI element in TransponderWindow
        
        Events.EveryOneMinute.Add(EventFunction);
        Events.OnPlayerUpdate.Add(updateDirection);
    end
end

function Transponder:changeTarget(targetNum, target, targetCharname, targetUsername)
    if (getOnlinePlayers() ~= nil) then
        local targetNumTarget = getOnlinePlayers():get(targetNum);
        if (targetNumTarget == target and targetNumTarget:getDisplayName() == targetCharname and targetNumTarget:getUsername()) then
            Transponder.target = targetNumTarget;
        end
    else
        Transponder.target = getPlayer();
    end
end

function Transponder:getIsTurnedOn()
    return Transponder.enabled;
end

function updateDirection()
    if (Transponder.distance > 10) then
        local rotation = math.deg( math.atan2( Transponder.owner:getY() - targetY, Transponder.owner:getX() - targetX ) ); 
        -- add 180 to bring the range from -180-180 to 0-360, minus 22.5 to make the directions make more sense
        -- add 360 to avoid negative numbers (for indexing)
        rotation = rotation - 22.5 + 540;
        Transponder.direction = directions[math.floor(((rotation % 360) / 360) * 8) + 1];
    else
        local rand = ZombRandFloat(0,1)
        if (rand > 0.7) then
            Transponder.direction = directions[ZombRandBetween(1, 8)]
        elseif (rand > 0.35) then
            Transponder.direction = "Full";
        else
            Transponder.direction = "Empty";
        end
    end
end

-- The Transponder will have multiple "bands". Each band has its own frequency of beeping. For instance, 0-10m is the first band, and has the fastest amount of beeping.
-- When the target is in the next band (10-50m) the beeping will change to a slower frequency.

-- When the Transponder moves to a different band, TransponderChangeBand will play to signal this to the player (maybe remove this?).

directions = {
    "SouthEast", "South", "SouthWest", "West", "NorthWest", "North", "NorthEast", "East", 
}

bands = {
    10, 50, 100, 200, 500, 1000
}

function EventFunction()
    if (Transponder.device == nil) then
        print("ok")
    end
    if (Transponder.target ~= nil) then
        targetX = Transponder.target:getX();
        targetY = Transponder.target:getY();
    end

    Transponder.distance = Transponder.owner:getRelevantAndDistance(targetX, targetY, 1000);

    print("DIRECTION: ", Transponder.direction);
    print("DISTANCE: ", Transponder.distance);

    local sound;
    if (Transponder.distance <= bands[1]) then
        sound = "TransponderBeep1";
    elseif (Transponder.distance <= bands[2]) then
        sound = "TransponderBeep2";
    elseif (Transponder.distance <= bands[3]) then
        sound = "TransponderBeep3";
    elseif (Transponder.distance <= bands[4]) then
        sound = "TransponderBeep4";
    elseif (Transponder.distance <= bands[5]) then
        sound = "TransponderBeep5";
    elseif (Transponder.distance <= bands[6]) then
        sound = "TransponderBeep6";
    end
    
    if (sound ~= Transponder.sound) then
        Transponder.owner:getEmitter():stopSoundByName(Transponder.sound);
        Transponder.owner:getEmitter():playSound("TransponderChangeBand");
        Transponder.owner:getEmitter():playSound(sound);
        Transponder.sound = sound
    end
end