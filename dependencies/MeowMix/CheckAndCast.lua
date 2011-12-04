function MeowMix_Check()
	local MoTWfound,OmenFound,ThornsFound,mounted,retarget = false,false,false,false,false

	-- ###### BUFFS CHECK
    if MeowMix_IsBuffActive("".. MeowMix_OmenName) then OmenFound = true end
    if MeowMix_IsBuffActive("".. MeowMix_MarkName) or MeowMix_IsBuffActive("".. MeowMix_GiftName) then MoTWfound = true end
    if MeowMix_IsBuffActive("".. MeowMix_ThornsName) then ThornsFound = true end
	for i=1,40 do
		buff = UnitBuff("player",i);
		if buff and string.find(buff,"Mount_") then mounted = true; end
	end

	-- ###### AUTO NS HEAL
	if MeowMix_VAR["NSHeal"] == 1 and MeowMix_DruidCheck() and not SpellIsTargeting() and not UnitOnTaxi("player") and not MeowMix_Shapeshifted()
		and not mounted and not IsCasting and (MeowMix_HealthCheck() < tonumber(MeowMix_VAR["NSHealValue"]) and MeowMix_HealthCheck() >= 1) then
			CastSpellByName("".. MeowMix_NS)
            SpellStopCasting()
            if (UnitName("target") ~= UnitName("player")) then
                ClearTarget()
                retarget = true
            end
            CastSpellByName("".. MeowMix_HT, 1)
            if SpellIsTargeting() then SpellTargetUnit("player") end
            if retarget then TargetLastTarget() end
            return
	end
    -- ###### Decursive
    if (MeowMix_VAR["DebuffToggle"] == 1) and UnitDebuff("player", 1, 1) and not SpellIsTargeting() and not UnitOnTaxi("player") and not MeowMix_Shapeshifted() and not mounted then
        Dcr_Clean()
    end
	-- ###### MoTW CAST
	if MeowMix_VAR["MoTWToggle"] == 1 and MeowMix_DruidCheck() and not SpellIsTargeting() and not UnitOnTaxi("player") and not MeowMix_Shapeshifted()
		and not MoTWfound and not mounted then
            if (UnitName("target") ~= UnitName("player")) then
                ClearTarget()
                retarget = true
            end
            CastSpellByName("".. MeowMix_MarkName, 1)
            if SpellIsTargeting() then SpellTargetUnit("player") end
            if retarget then TargetLastTarget() end
            return
	end
    	-- ###### Omen CAST
	if MeowMix_VAR["OmenToggle"] == 1 and MeowMix_DruidCheck() and not SpellIsTargeting() and not UnitOnTaxi("player") and not MeowMix_Shapeshifted()
		and not OmenFound and not mounted then
			CastSpellByName("".. MeowMix_OmenName)
            return
	end
    	-- ###### Thorns CAST
	if MeowMix_VAR["ThornsToggle"] == 1 and MeowMix_DruidCheck() and not SpellIsTargeting() and not UnitOnTaxi("player") and not MeowMix_Shapeshifted()
		and not ThornsFound and not mounted then
            if (UnitName("target") ~= UnitName("player")) then
                ClearTarget()
                retarget = true
            end
            CastSpellByName("".. MeowMix_ThornsName, 1)
            if SpellIsTargeting() then SpellTargetUnit("player") end
            if retarget then TargetLastTarget() end
            return
	end
end

function MeowMix_Debug(arg1)
	local MoTWfound,OmenFound,ThornsFound,mounted = false,false,false,false

	-- ###### BUFFS CHECK
    if MeowMix_IsBuffActive("".. MeowMix_OmenName) then OmenFound = true end
    if MeowMix_IsBuffActive("".. MeowMix_MarkName) or MeowMix_IsBuffActive("".. MeowMix_GiftName) then MoTWfound = true end
    if MeowMix_IsBuffActive("".. MeowMix_ThornsName) then ThornsFound = true end
	for i=1,40 do
		buff = UnitBuff("player",i);
		if buff and string.find(buff,"Mount_") then mounted = true; end
	end

	-- ##### SPAM
    if MeowMix_VAR["MoTWToggle"] == 1 then MeowMix_ChatMsg("Buff MoTW is enabled") else MeowMix_ChatMsg("Buff MoTW is disabled") end
    if MeowMix_VAR["OmenToggle"] == 1 then MeowMix_ChatMsg("Buff Omen is enabled") else MeowMix_ChatMsg("Buff Omen is disabled") end
    if MeowMix_VAR["ThornsToggle"] == 1 then MeowMix_ChatMsg("Buff Thorns is enabled") else MeowMix_ChatMsg("Buff Thorns is disabled") end
    MeowMix_ChatMsg("------")
	if not SpellIsTargeting() then MeowMix_ChatMsg("No spells awaiting target") else MeowMix_ChatMsg("A spell is currently awaiting target") end
	if not MoTWfound then MeowMix_ChatMsg("MoTW not found") else MeowMix_ChatMsg("MoTW found") end
	if not OmenFound then MeowMix_ChatMsg("Omen not found") else MeowMix_ChatMsg("Omen found") end
	if not ThornsFound then MeowMix_ChatMsg("Thorns not found") else MeowMix_ChatMsg("Thorns found") end
	if not mounted then MeowMix_ChatMsg("Not Mounted") else MeowMix_ChatMsg("Is mounted") end
	if not MeowMix_Shapeshifted() then MeowMix_ChatMsg("Not shapeshifted") else MeowMix_ChatMsg("Is shapeshifted") end
	if not UnitOnTaxi("player") then MeowMix_ChatMsg("Not on taxi") else MeowMix_ChatMsg("Is on taxi") end
end