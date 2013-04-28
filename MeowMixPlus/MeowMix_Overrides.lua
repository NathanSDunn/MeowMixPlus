function MeowMix_Buff()
   --buff self first
   if (MeowMix_Buff_On) then
      return
   end
   MeowMix_Buff_On=true
   local MoTWstart, MoTWduration = GetSpellCooldown(MeowMix_MarkID, BOOKTYPE_SPELL)
   if (MoTWduration>0) then
      MeowMix_Buff_On = false
      return
   end
   
   if (UnitMana("player") < 445) and not isPlayerBuffUp("Drink") then
      UseByName_Execute(FagMeld_DrinkMe)
   end
-- if sitting stand

   if (not MeowMix_IsBuffActive(""..MeowMix_MarkName, "player") and not MeowMix_IsBuffActive(""..MeowMix_GiftName, "player")) then
      TargetUnit("player")
      CastSpellByName("".. MeowMix_MarkName)
      MeowMix_Buff_OOR = false
      MeowMix_Buff_On = false
      return true
   end
   --buff party second
   if UnitInParty("player") then
      for i = 1, 4 do
         name, rank, subgroup, level, class, fileName, zone, online = GetRaidRosterInfo(i)
         if (not MeowMix_IsBuffActive(""..MeowMix_MarkName, "party"..i) and not MeowMix_IsBuffActive(""..MeowMix_GiftName, "party"..i) and CheckInteractDistance("party"..i,4) and not UnitIsDead("party"..i) and UnitIsConnected("party"..i)) then
           TargetUnit("party"..i)
           CastSpellByName("".. MeowMix_MarkName)
           MeowMix_Buff_OOR = false
           MeowMix_Buff_On = false
           return true
         end
      end
   end

   if UnitInRaid("player") then
      PlayerZone = GetZoneText()
      for i = 1, 40 do
         name, rank, subgroup, level, class, fileName, zone, online = GetRaidRosterInfo(i)
         if (not MeowMix_IsBuffActive(""..MeowMix_MarkName, "raid"..i) and not MeowMix_IsBuffActive(""..MeowMix_GiftName, "raid"..i) and not UnitIsDead("raid"..i) and online) then
            if CheckInteractDistance("raid"..i,4) then
              TargetUnit("raid"..i)
              CastSpellByName("".. MeowMix_MarkName)
              MeowMix_Buff_OOR = false
              MeowMix_Buff_On = false
              return true
            else 
               if UnitName("raid"..i) then
                 if MeowMix_Buff_OOR then
                     --print (UnitName("raid"..i))
                    MeowMix_Buff_OOR =MeowMix_Buff_OOR..UnitName("raid"..i)..", "
                  else
                     MeowMix_Buff_OOR =UnitName("raid"..i)..", "
                  end
               end
            end
         end
      end
   end
   
   if (MeowMix_Buff_OOR) then
      printError(MeowMix_Buff_OOR.."need MoTW and are OOR!")
   else
      printError(MeowMix_Buff_DoneMsg);
   end

   MeowMix_Buff_OOR = false
   MeowMix_Buff_On = false
   return false;
end

--updated with rank 11 Rejuv
function MeowMix_SpellRanks(spell)
    if (spell == "regrowth") then
        l={12,18,24,30,36,42,48,54,60}
        count = 9
    end
    if (spell == "rejuv") then
        l={4,10,16,22,28,34,40,46,52,58,60}
        count = 11
    end
    if (spell == "motw") then
        l={1,10,20,30,40,50,60}
        count = 7
    end
    if (spell == "thorns") then
        l={6,14,24,34,44,54}
        count = 6
    end
    for i = count,1,-1 do
        if (UnitLevel("player") >= l[i]) then return i end
    end
end

--updated to work with 11 and some targeting optimisations
function MeowMix_Rejuv()
    id=MeowMixPlus_Friend();
    for i = MeowMix_SpellRanks("rejuv"),1,-1 do
        if (UnitLevel(id) >= l[i]-11) then
            CastSpellByName("".. MeowMix_RejuvName .."(".. MeowMix_RankWord .. " "..i..")")
            MeowMixPlus_SelfCast()
            break
        end
    end
end

-- Wanted to notify on bash successful cast
function MeowMix_OnUpdate(elapsed)
    local time = GetTime()
    local SoundTimeTemp = GetTime()
    if (MeowMix_VAR["Tunafish"] == 1 and MeowMix_DruidCheck() and not UnitOnTaxi("player") and not UnitIsDeadOrGhost("player")) then
        if (not this.TimeOfNextUpdate or (time > this.TimeOfNextUpdate)) then
             -- ############################ NS Heal
            if (MeowMix_HealthCheck() <= tonumber(MeowMix_VAR["NSHealValue"]) and MeowMix_HealthCheck() >= 1) and MeowMix_VAR["NSHeal"] == 1 then
                MeowMix_FrameMsg("".. MeowMix_NSNOW)
                if ((not this.TimeOfSoundNextUpdate or (SoundTimeTemp > this.TimeOfSoundNextUpdate)) and MeowMix_VAR["SoundToggle"] == 1) then
                    if (MeowMix_VAR["PlaySound"] == 1) then PlaySound("igQuestFailed") else MeowMix_SillySounds() end
                end
            end
            -- ############################ Curable Buffs
            if (MeowMix_VAR["DebuffToggle"] == 1) and UnitDebuff("player", 1, 1) then
                MeowMix_FrameMsg("".. MeowMix_DebuffMsg)
                if ((not this.TimeOfSoundNextUpdate or (SoundTimeTemp > this.TimeOfSoundNextUpdate)) and MeowMix_VAR["SoundToggle"] == 1) then
                    if (MeowMix_VAR["PlaySound"] == 1) then PlaySound("igQuestFailed") else MeowMix_SillySounds() end
                end
            end
            
           -- ############################ Thorns
            if (MeowMix_VAR["ThornsToggle"] == 1 and not MeowMix_IsBuffActive("".. MeowMix_ThornsName)) then
                MeowMix_FrameMsg("".. MeowMix_ThornsNOW)
            end
           -- ############################ Bash
            if (isUnitDebuffUp("target","Bash")) then
                MeowMix_FrameMsg(""..UnitName("target").. MeowMix_BashNOW)
            end
          -- ############################ OOC
            if (MeowMix_VAR["OmenToggle"] == 1) and not MeowMix_IsBuffActive("".. MeowMix_OmenName) then
                MeowMix_FrameMsg("".. MeowMix_OmenNow)
            end
          -- ############################ MoTW
            if (MeowMix_VAR["MoTWToggle"] == 1) and not MeowMix_IsBuffActive("".. MeowMix_MarkName) and not MeowMix_IsBuffActive("".. MeowMix_GiftName) then
                MeowMix_FrameMsg("".. MeowMix_MoTWNOW)
            end
          -- ############################ Updates
            this.TimeOfSoundNextUpdate = SoundTimeTemp + MeowMix_SoundInterval
            this.TimeOfNextUpdate = time + MeowMix_UpdateInterval
        end
    end
end