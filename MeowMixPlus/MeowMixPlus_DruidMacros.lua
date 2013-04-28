--[[
FagMeld()
MeowMixPlus_Swiftmend()
MeowMixPlus_NSHeal()
MeowMixPlus_Hots()
MeowMixPlus_BarkskinTranquility()
MeowMixPlus_BarkskinHurricane()
MeowMixPlus_Brez()
MeowMixPlus_nervate()
]]--

-------------------------------------------------------------------------------------------------
--                                  Targeting Stuff
-------------------------------------------------------------------------------------------------

function FagMeld()
   if isPlayerBuffUp("Ability_Ambush") then
      --fag already melded
      return false
   end

   manaPC = (UnitMana("player")/ UnitManaMax("player"))*100
   if ((manaPC < FagMeld_manaPC) and not isPlayerBuffUp("player","Drink")) then
      UseByName_Execute(FagMeld_DrinkMe)
   end
   --hpPC = (UnitHealth("player")/ UnitHealthMax("player"))*100
   --if (hpPC < FagMeld_hpPC and not isUnitBuffUp("Fork&Knife")) then
      --UseByName_Execute(FagMeld_EatMe)
   --end
	CastSpellByName("Shadowmeld")
end

function MeowMixPlus_SelfCast()
	if (SpellIsTargeting() and SpellCanTargetUnit("player")) then
		SpellTargetUnit("player")
		return true
	end
	return false
end

--Returns targetname if it is friendly else returns selfname
function MeowMixPlus_Friend()
	if (UnitIsFriend("player", "target") ) then
		return "target";
	else
		return "player";
	end
end


-------------------------------------------------------------------------------------------------
--                                   Healing Stuff
-------------------------------------------------------------------------------------------------

function MeowMixPlus_NSHeal()
   local id=MeowMixPlus_Friend()
   if (UnitIsDead(id)) then
      return false
   end

   local SMstart, SMduration = GetSpellCooldown(MeowMix_SwiftmendID, BOOKTYPE_SPELL)
   local NSstart, NSduration = GetSpellCooldown(MeowMix_NSID, BOOKTYPE_SPELL)
   
  local swiftmendNeeded = false
  local NSNeeded = false

  local hp = UnitHealth(id)
  local hpPercent= (hp / UnitHealthMax(id)) *100
  local hpDeficit = UnitHealthMax(id)-UnitHealth(id)


      if (hpPercent < MeowMix_Swiftmend_PC) then 
         swiftmendNeeded = true
      end
      if (hpPercent > MeowMix_NS_PC) then 
         NSNeeded = true
      end

  if not (UnitHealthMax(id)==100) then
      --target probably in party
      if (hpDeficit > MeowMix_SwiftmendAmount) then
         swiftmendNeeded = true
      end
      if (hpDeficit > MeowMix_NSAmount) then
         NSNeeded = true
      end
  end

   -- if NS is casted
	if (NSduration==0.001) then
      SpellStopCasting();
		CastSpellByName(MeowMix_HT)
	else
      if (NSduration>0) then
      --NS on cd
         if (SMduration>0) then
            --SM on CD
            CastSpellByName(""..MeowMix_RegrowName)
         else
            --SM up!
            MeowMixPlus_Swiftmend()
         end

      else
         --NS up!
         if (SMduration>0) then
            --SM on CD
            if (NSNeeded) then
              SpellStopCasting()
              CastSpellByName("".. MeowMix_NS, 1)
              SpellStopCasting()
              CastSpellByName("".. MeowMix_HT)
              CastSpellByName("".. MeowMix_HT)
            else
               printError(UnitName(id).." Does not need NS Heal")
            end
         else
            --SM up!
            if isUnitBuffUp(id,"Spell_Nature_Rejuvenation") then
               --rejuv up
              SpellStopCasting()
              CastSpellByName(""..MeowMix_SwiftmendName)
            elseif (NSNeeded) then
              SpellStopCasting()
              CastSpellByName("".. MeowMix_NS, 1)
              SpellStopCasting()
              CastSpellByName("".. MeowMix_HT)
              CastSpellByName("".. MeowMix_HT)
            else
              CastSpellByName(""..MeowMix_RejuvName)
            end
         end
      end
	end
	return
	MeowMixPlus_SelfCast();
end

function MeowMixPlus_Swiftmend()
      local id=MeowMixPlus_Friend()

      if (isUnitBuffUp(id,"Spell_Nature_Rejuvenation")) then
        --Rejuv is up
        local swiftmendNeeded = true
        if (UnitHealthMax(id)==100) then
            --target probably not in party
            hpPercent= (UnitHealth(id) / UnitHealthMax(id)) *100
            if (hpPercent > MeowMix_SwiftmendUngroupedPC) then 
               swiftmendNeeded = false
            end
        else
            --target probably in party
            hpDeficit = UnitHealthMax(id)-UnitHealth(id)
            if (hpDeficit < MeowMix_SwiftmendAmount) then
               swiftmendNeeded = false
            end
        end

	     if (swiftmendNeeded) then
           SpellStopCasting();
           CastSpellByName(""..MeowMix_SwiftmendName);
           MeowMixPlus_SelfCast();
           --return "SwiftmenT!";
	     else
           printError(UnitName(id).." Has Rejuvenation up and does not need Swiftmend!")
           --return "Target has Rejuv, No need for Swiftmend";
        end
     else
           SpellStopCasting()
           CastSpellByName(""..MeowMix_RejuvName);
           MeowMixPlus_SelfCast();
          --return "Rejuvenating";
     end
end


function MeowMixPlus_Hots()
      local id=MeowMixPlus_Friend()

      -- if regrowth buffed Spell_Nature_ResistNature
      if (isUnitBuffUp(id,"Spell_Nature_ResistNature")) then

         --regrowth is up, cast rejuv
         if (isUnitBuffUp(id,"Spell_Nature_Rejuvenation")) then
            --rejuv casted already!
            CastSpellByName(""..MeowMix_HT);
         else
            CastSpellByName(""..MeowMix_RejuvName);
         end
      else
         --cast regrowth
         CastSpellByName(""..MeowMix_RegrowName);
      end
      MeowMixPlus_SelfCast();
end

-------------------------------------------------------------------------------------------------
--                                  Spell Stuff
-------------------------------------------------------------------------------------------------
--
function MeowMixPlus_MoreDots()
   if (UnitExists("target")) then
      if (isUnitDebuffUp("target","Spell_InsectSwarm") ) then
         CastSpellByName(""..MeowMix_Moonfire10)
      else
         CastSpellByName(""..MeowMix_InsectName)
      end
   end
end

-------------------------------------------------------------------------------------------------
--                                  Bear Stuff
-------------------------------------------------------------------------------------------------

--ALPHA - REQUIRES COMPLETE DRUID
function MeowMixPlus_Bash()
   --is in Ability_Racial_Bearform
   if (isPlayerBuffUp("Ability_Racial_BearForm")) then
      --In Bear Form
      -- debuff on target
      if (isUnitDebuffUp("target","Ability_Druid_Bash")) then
         CompleteDruid_Shift("HUMANOID");
         print("Bash Detected");
         return "Transforming to Caster";
      else
         CastSpellByName(""..MeowMix_BashName);
         return "Bashing Target";
      end
   else
      --Not in bearform (Hopefully in caster)
      MeowMixPlus_Hots()
      
   --else
      --print("Error: Neither in Caster nor Bear form");
   end
end


-------------------------------------------------------------------------------------------------
--                                   Barkskin Stuff
-------------------------------------------------------------------------------------------------

-- needs cd check
function MeowMixPlus_BarkskinHurricane()
   local BSstart, BSduration = GetSpellCooldown(MeowMix_BarkskinID, BOOKTYPE_SPELL)
   --local HCstart, HCduration = GetSpellCooldown(MeowMix_HurricaneID, BOOKTYPE_SPELL)

	if (BSduration>0) then
      --Barkskin on Cooldown
      SpellStopCasting();
		CastSpellByName(MeowMix_HurricaneName)
	else
      --Cast Barkskin
      SpellStopCasting();
		CastSpellByName(MeowMix_BarkskinName)
   end
end
-------------------------------------------------------------------------------------------------
function MeowMixPlus_BarkskinTranquility()
   local BSstart, BSduration = GetSpellCooldown(MeowMix_BarkskinID, BOOKTYPE_SPELL)
   --local HCstart, HCduration = GetSpellCooldown(MeowMix_HurricaneID, BOOKTYPE_SPELL)

	if (BSduration>0) then
      --Barkskin on Cooldown
      SpellStopCasting();
		CastSpellByName(MeowMix_TranquilityName)
	else
      --Cast Barkskin
      SpellStopCasting();
		CastSpellByName(MeowMix_BarkskinName)
   end
end
-------------------------------------------------------------------------------------------------
--                                   Script Stuff
-------------------------------------------------------------------------------------------------

  function MeowMixPlus_DruidMacros_LoadSpellIDs()
      MeowMix_SwiftmendID = getSpellID(""..MeowMix_SwiftmendName)
      MeowMix_NSID =             getSpellID(""..MeowMix_NS)
      MeowMix_BarkskinID =    getSpellID(""..MeowMix_BarkskinName)
      MeowMix_InnervateID =  getSpellID(""..MeowMix_InnervateName)
      MeowMix_RebirthID =       getSpellID(""..MeowMix_Rebirth)
      MeowMix_BashID =          getSpellID(""..MeowMix_Bash)
      MeowMix_MarkID =          getSpellID(""..MeowMix_MarkName)
      MeowMix_SpellIDsLoaded = true
      --print("Druid SpellIDs Detected")
  end

-------------------------------------------------------------------------------------------------
--                                   MeowMixPlus_Brez
-------------------------------------------------------------------------------------------------

function MeowMixPlus_Brez(safetyOn,channel,quiet)
      local IFTW_msglang;
      if (UnitFactionGroup("player") == "Alliance") then
         IFTW_msglang = "Common";
      else 
         IFTW_msglang = "Orcish";
      end;

    if (not UnitPlayerControlled("target")) then
       --NPC
       UIErrorsFrame:AddMessage(UnitName("target")..MeowMix_ErrIsNPC,1,0,0,1,3);

    elseif (not UnitIsDead("target")) then
       --target is alive
       UIErrorsFrame:AddMessage(UnitName("target")..MeowMix_ErrIsAlive,1,0,0,1,3);

    elseif (safetyOn and not(UnitClass("target")==MeowMix_DRUID or UnitClass("target")==MeowMix_Priest) ) then
       -- Unit broken or notplayer
        --ScrollingMessageFrame:AddMessage(text, red, green, blue, alpha, holdTime); 
        UIErrorsFrame:AddMessage(MeowMix_ErrSafety,1,0,0,1,3);

    elseif (not CheckInteractDistance("target",4)) then
       --OOR
       UIErrorsFrame:AddMessage(UnitName("target")..MeowMix_ErrOOR,1,0,0,1,3);
         if (not quiet) then
            SendChatMessage(""..MeowMix_Rebirth..MeowMix_PingMsg,"WHISPER",IFTW_msglang,UnitName("target"));
         end;

    else
         CastSpellByName(""..MeowMix_Rebirth);
         if (channel) then
            SendChatMessage("XxXxX Battle-Rezzing %t XxXxX","CHANNEL","Common",GetChannelName(channel));
         end
         if (not quiet) then
            SendChatMessage(MeowMix_RebirthMsg,"WHISPER",IFTW_msglang,UnitName("target"));
         end;
         return 1;
    end;

    return 0;
end
-------------------------------------------------------------------------------------------------
--                                   MeowMixPlus_nervate
-------------------------------------------------------------------------------------------------

--MeowMixPlus_nervate, Based on Ulti's InnervateFTW(http://www.curse-gaming.com/mod.php?addid=2634)
--Prevents innervation of:
--  Invalid Targets
--  NPC's
--  Non Casters
--  Players that are already Innervated
--  Players with a higher than specified % of mana
--  People who are out of combat and should be drinking!
--Has the option to announce Innervation to a channel and/or send a tell to the player
function MeowMixPlus_nervate(IFTW_percentage, channel,quiet)

      local IVstart, IVduration = GetSpellCooldown(MeowMix_InnervateID, BOOKTYPE_SPELL)
      local IFTW_msglang;
      if (UnitFactionGroup("player") == "Alliance") then
         IFTW_msglang = "Common";
      else 
         IFTW_msglang = "Orcish";
      end;

    if (not IFTW_percentage) then 
         IFTW_percentage = 50; 
    end; --defaulting to 50% if none is specified

    IFTW_percentage = tonumber(IFTW_percentage)/100;

    if (IVduration>0) then    -- Unit broken or notplayer
        --ScrollingMessageFrame:AddMessage(text, red, green, blue, alpha, holdTime); 
        UIErrorsFrame:AddMessage(MeowMix_ErrCD,1,0,0,1,3);

    elseif (not UnitExists("target")) then
       -- Unit broken or notplayer
        --ScrollingMessageFrame:AddMessage(text, red, green, blue, alpha, holdTime); 
        UIErrorsFrame:AddMessage(SPELL_FAILED_BAD_TARGETS,1,0,0,1,3);

    elseif (not UnitPlayerControlled("target")) then
       --NPC
       UIErrorsFrame:AddMessage(UnitName("target")..MeowMix_ErrIsNPC,1,0,0,1,3);

    elseif (not (UnitPowerType("target") == 0) or (not UnitClass("target")==MeowMix_DRUID)) then
        --Is not a Caster
        UIErrorsFrame:AddMessage(UnitName("target")..MeowMix_ErrIsNotCaster,1,0,0,1,3);

    elseif (UnitMana("target")/UnitManaMax("target") > IFTW_percentage) then
       --Too Much Mana 
       UIErrorsFrame:AddMessage(UnitName("target")..MeowMix_ErrMoreThan..(IFTW_percentage*100)..MeowMix_ErrMana,1,0,0,1,3);

    elseif (not UnitAffectingCombat("target")) then
    --    Is out of combat
         UIErrorsFrame:AddMessage(UnitName("target").." is out of combat! Let "..UnitSex("target").." Drink!",1,0,0,1,1);
         SendChatMessage(""..MeowMix_ErrDrinkUp,"WHISPER",IFTW_msglang,UnitName("target"));


    elseif (isUnitBuffUp("target","Nature_Lightning")) then
       --Already Buffed or Too Much Mana 
       UIErrorsFrame:AddMessage(UnitName("target")..MeowMix_ErrInnervateUP,1,0,0,1,3);


    elseif (not CheckInteractDistance("target",4)) then
       --Too Much Mana 
       UIErrorsFrame:AddMessage(UnitName("target")..MeowMix_ErrOOR,1,0,0,1,3);
         if (not quiet) then
            SendChatMessage(""..MeowMix_InnervateName..MeowMix_PingMsg,"WHISPER",IFTW_msglang,UnitName("target"));
         end;

    else
         CastSpellByName(""..MeowMix_InnervateName);
         CastSpellByName(""..MeowMix_InnervateName);
         if (channel) then
            SendChatMessage("Innervating --> %t <--","CHANNEL","Common",GetChannelName(channel));
         end
         if (not quiet) then
            SendChatMessage(MeowMix_InnervateMsg,"WHISPER",IFTW_msglang,UnitName("target"));
         end;
         return 1;
    end;

    return 0;
end