--MeowMixPlus Function Library!!!!

function MeowMixPlus_Functions_OnLoad()
	 DEFAULT_CHAT_FRAME:AddMessage("MeowMixPlus_s Function Library Version 1.0");
    SlashCmdList["SHOWBUFFS"] = showBuffs
	 SLASH_SHOWBUFFS1 = "/showbuffs"
	 SLASH_SHOWBUFFS2 = "/sb"
end


ScriptErrors.Show = function()
  print(ScriptErrors_Message:GetText())
end

function sayGroup(s)
      if GetNumRaidMembers() > 0 then 
         chan="RAID"; 
      else 
         chan="PARTY" ;
      end 
      
      if (s) then 
         SendChatMessage(s,chan);
         return true;
      end
      return false;
end

-- booktype = BOOKTYPE_SPELL or BOOKTYPE_PET
function getSpellID(sSpellName)
      local i = 1
      while true do
         local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL)
         if not spellName then
            return false
         end
         -- use spellName and spellRank here
         --DEFAULT_CHAT_FRAME:AddMessage(.. spellName .. '(' .. spellRank .. ')' )
         if (spellName == sSpellName) then
            return i;
         end
         i = i + 1
      end
end

function getSpellInfo()
local i = 1
while true do
   local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL)
   if not spellName then
      do break end
   end
   
   -- use spellName and spellRank here
   DEFAULT_CHAT_FRAME:AddMessage(i.." = "..spellName .. '(' .. spellRank .. ')' )
   
   i = i + 1
end
end

--Loops through active buffs looking for a string match
--Origin Zorlen's hunter functions  
--buffs
function isUnitBuffUp(sUnitname, sBuffname) 
  local iIterator = 1
  while (UnitBuff(sUnitname, iIterator)) do
    if (string.find(UnitBuff(sUnitname, iIterator), sBuffname)) then
       return true
    end
    iIterator = iIterator + 1
  end
  return false
end

function isPlayerBuffUp(sBuffname)
  return isUnitBuffUp("player", sBuffname) 
end;

function showAllUnitBuffs(sUnitname) 
  local iIterator = 1
  DEFAULT_CHAT_FRAME:AddMessage(format("[%s] Buffs", sUnitname))
  while (UnitBuff(sUnitname, iIterator)) do
    DEFAULT_CHAT_FRAME:AddMessage(UnitBuff(sUnitname, iIterator), 1, 1, 0)    
    iIterator = iIterator + 1
  end
  DEFAULT_CHAT_FRAME:AddMessage("---", 1, 1, 0)    
end
--debuffs

function isUnitDebuffUp(sUnitname, sBuffname) 
  local iIterator = 1
  while (UnitDebuff(sUnitname, iIterator)) do
    if (string.find(UnitDebuff(sUnitname, iIterator), sBuffname)) then
       return true
    end
    iIterator = iIterator + 1
  end
  return false
end

function isPlayerDebuffUp(sBuffname)
  return isUnitDebuffUp("player", sBuffname);
end;

function showBuffs()
	if (UnitIsFriend("player", "target")) then
		showAllUnitBuffs("target")
		showAllUnitDebuffs("target")
	else
		showAllUnitDebuffs("target")
	end
end

function showAllUnitDebuffs(sUnitname) 
  local iIterator = 1
  DEFAULT_CHAT_FRAME:AddMessage(format("[%s] Debuffs", sUnitname))
  while (UnitDebuff(sUnitname, iIterator)) do
    DEFAULT_CHAT_FRAME:AddMessage(UnitDebuff(sUnitname, iIterator), 1, 1, 0)    
    iIterator = iIterator + 1
  end
  DEFAULT_CHAT_FRAME:AddMessage("---", 1, 1, 0)    
end
----------------------------------------- End Zorlen's hunter functions 
   

function print(s)
   if(s) then DEFAULT_CHAT_FRAME:AddMessage(s);end;
end;

function printError(s)
   if(s) then UIErrorsFrame:AddMessage(s,1,0,0,1,3);end;
end;
function MeowMixPlus_Functions_printError(s)
   if(s) then UIErrorsFrame:AddMessage(s,1,0,0,1,3);end;
end;

function printTable(t)
   table.foreach(t, function(k,v) DEFAULT_CHAT_FRAME:AddMessage(k.."="..v)  end)
end;

--=============================================================================
--
-- Boolean tableContainsUnit(TableToSearch,Unit)
--   returns true if unit found
--   returns false if unit not found
--
--=============================================================================
function tableContainsUnit(t,u)
   for i=1, table.getn(t), 1 do
      if (t[i] and u and string.find(t[i],u)) then 
         return true;
      end;
   end;
   return false;
end;



-- Check if the totem is in range of our action.  If so, blast it.  If not, look for another totem.
function TryAnAction(TheActionID,TheTarget)
      -- is the totem within range of our action (ie. moonfire?)
      if (IsActionInRange(TheActionID)) then
         --Totem found and in range - perform our action on it then return true
         UseAction(TheActionID, 0);
         return true;
      else
         return false;
      end
end






function MeowMixPlus_Bashix()
   --is in Ability_Racial_Bearform
   if (isPlayerBuffUp("Ability_Racial_BearForm")) then
      --In Bear Form
      -- debuff on target
      if (isUnitDebuffUp("target","Ability_Druid_Bash")) then
         print("Bash Detected");
         SwiftShift('Humanoid');
         return "Transforming to Caster";
      else
         print(".")
         CastSpellByName("Bash(Rank 3)");
         return "Bashing Target";
      end
   else
      --Not in bearform (Hopefully in caster)
      
      -- if regrowth buffed Spell_Nature_ResistNature
      if (isPlayerBuffUp("Spell_Nature_ResistNature")) then

         --regrowth is up, cast rejuv
         if (isPlayerBuffUp("Spell_Nature_Rejuvenation")) then
            --rejuv casted already!
            return "Finished!";
         else
            TargetByName(UnitName("player"));
            CastSpellByName("Rejuvenation(Rank 10)");
            return "Selfcasting Rejuv";
         end
      else
         --cast regrowth
         TargetByName(UnitName("player"));
         CastSpellByName("Regrowth(Rank 9)");
         return "Selfcasting Regrowth";
      end
      
   --else
      --print("Error: Neither in Caster nor Bear form");
   end
end
--Run OnLoad
MeowMixPlus_Functions_OnLoad();
