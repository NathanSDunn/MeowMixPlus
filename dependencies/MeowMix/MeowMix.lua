--[[
Meow Mix
By: kneeki - geekbocks@yahoo.com
Compatable with patch: 1.10

Use a single keybind to in this order:
•Cast Nature's Swiftness and Big heal
•Cast Decursive if you are debuffed w/ a poison/curse (requires Decursive)
•Cast Mark of the Wild
•Cast Omen of Clarity
•Cast Thorns

Misc Features:
•Display a message for ... Nature's Swiftness Heal/MoTW/Thorns/Omen
•Display a message also for cureable debuffs on the player
•Extensive built in macro list

Macro list:
(Create a macro with the following texts (You can also use /mm))
•Feral Stuff:
/meowmix claw - will cast claw in catform and upon 5 combo points casts ferocious bite
/meowmix back - will check for prowl, if found will cast Ravage, otherwise will shred)
/meowmix cancelform - will cancel your current shapeshift form
/meowmix prowl - will cast prowl if not active, if it is, will not cancel the buff

•Heal Bitch Stuff:
/meowmix NSheal - an easy way to NS heal yourself
/meowmix healToT - Heal your targets target will only work if your target is an enemy
/meowmix rez - target the nearest dead priest and cast Rebirth on them
/meowmix regrowth - will cast the highest rank of regrowth on your target
/meowmix rejuv - will cast the highest rank of rejuv on your target
/meowmix innervate - will cast innervate on your target if they have a mana bar or yourself

•Buffing and the like:
/meowmix buff - cycles through your raid/party and search for any players w/o MoTW on them. Casts if needed
/meowmix motw - will cast the highest rank of motw on your target or yourself
/meowmix thorns - will cast the highest rank of thorns on your target or yourself

•Misc Stuff:
/meowmix totem - if your target is a totem, it will destroy it with rank 1 Moonfire else cast rank 10
/meowmix cast - if you dont want to use the keybinding feature, you can use this to cast self buffs

COMMAND LIST:
(You can also use /mm)
/meowmix - launch config
/meowmix reset - break something? use this to reset all values
/meowmix debug - spams your main window with all the current casting flags
/meowmix macros - lists all of the current MeowMix built in macros
/meowmix help - this help menu
    
---- version .3 ----
•Fixed the issue w/ /meowmix macros not working for anyone not level 60.
•Due to other mod authors not passing functions correctly when hooking CastSpellByName(), I wrote a workaround. Should be working correctly now when self buffing.
]]

MeowMix_VAR = {}
MeowMix_UpdateInterval = 1.0
MeowMix_SoundInterval = 10.0

--#############################################################
--########################################### ON_***
--#############################################################

function MeowMix_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED")

	if MeowMix_VAR["NSHeal"] == nil then MeowMix_VAR["NSHeal"] = 0 end
	if MeowMix_VAR["NSHealValue"] == nil then MeowMix_VAR["NSHealValue"] = 35 end
    if MeowMix_VAR["MoTWToggle"] == nil then MeowMix_VAR["MoTWToggle"] = 1 end
    if MeowMix_VAR["ThornsToggle"] == nil then MeowMix_VAR["ThornsToggle"] = 1 end
    if MeowMix_VAR["OmenToggle"] == nil then MeowMix_VAR["OmenToggle"] = 0 end
    if MeowMix_VAR["SillySounds"] == nil then MeowMix_VAR["SillySounds"] = 1 end
    if MeowMix_VAR["Tunafish"] == nil then MeowMix_VAR["Tunafish"] = 1 end
    if MeowMix_VAR["ClawFF"] == nil then MeowMix_VAR["ClawFF"] = 0 end
    if MeowMix_VAR["DebuffToggle"] == nil then MeowMix_VAR["DebuffToggle"] = 1 end
    if MeowMix_VAR["SoundToggle"] == nil then MeowMix_VAR["SoundToggle"] = 1 end
    if MeowMix_VAR["MCR"] == nil then MeowMix_VAR["MCR"] = 1.0 end
    if MeowMix_VAR["MCG"] == nil then MeowMix_VAR["MCG"] = 0.0 end
    if MeowMix_VAR["MCB"] == nil then MeowMix_VAR["MCB"] = 0.0 end
    if MeowMix_VAR["FBToggle"] == nil then MeowMix_VAR["FBToggle"] = 1 end
    if MeowMix_VAR["Finisher"] == nil then MeowMix_VAR["Finisher"] = 1 end
    if MeowMix_VAR["PreserveForms"] == nil then MeowMix_VAR["PreserveForms"] = 0 end

	SlashCmdList["MEOWMIX"] = MeowMix_ChatCommandHandler
	SLASH_MEOWMIX1 = "/meowmix"
	SLASH_MEOWMIX2 = "/mm"

	MeowMix_ChatMsg("".. MeowMix_Welcome);
end

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

function MeowMix_OnEvent()
    if (event=="PLAYER_LEAVING_WORLD") then
        MeowMix_VAR["Tunafish"] = 0
        return
    end
    if (event=="PLAYER_ENTERING_WORLD") then
        MeowMix_VAR["Tunafish"] = 1
        return
    end
end

--#############################################################
--########################################### COMMAND MISC
--#############################################################

function MeowMix_ChatCommandHandler(msg)
	argv = {};
	for arg in string.gfind(string.lower(msg), '[%a%d%-%.]+') do
		table.insert(argv, arg);
	end
	if (argv[1] == nil) then
		MeowMix_FrameToggle();
	elseif (argv[1] == MeowMix_HelpCom) then MeowMix_Help();
	elseif (argv[1] == MeowMix_ResetCom) then MeowMix_Reset()
	elseif (argv[1] == MeowMix_DebugCom) then MeowMix_Debug()
	elseif (argv[1] == MeowMix_ClawCom) then MeowMix_Claw()
	elseif (argv[1] == MeowMix_BackCom) then MeowMix_Back()
	elseif (argv[1] == MeowMix_BuffCom) then MeowMix_Buff()
	elseif (argv[1] == MeowMix_RezCom) then MeowMix_Rez()
	elseif (argv[1] == MeowMix_healtotCom) then MeowMix_healToT()
	elseif (argv[1] == MeowMix_TotemCom) then MeowMix_Totem()
	elseif (argv[1] == MeowMix_NSHealCom) then MeowMix_NSHeal()
	elseif (argv[1] == MeowMix_MoTWCom) then MeowMix_MoTW()
	elseif (argv[1] == MeowMix_ThornsCom) then MeowMix_Thorns()
	elseif (argv[1] == MeowMix_RegrowthCom) then MeowMix_Regrowth()
	elseif (argv[1] == MeowMix_RejuvCom) then MeowMix_Rejuv()
	elseif (argv[1] == MeowMix_ProwlCom) then MeowMix_Prowl()
	elseif (argv[1] == MeowMix_InnervateCom) then MeowMix_Innervate()
	elseif (argv[1] == MeowMix_CastCom) then MeowMix_Check()
	elseif (argv[1] == MeowMix_MacrosCom) then MeowMix_Macros()
	elseif (argv[1] == MeowMix_CancelFormWord) then MeowMix_CancelForm()
	else
        MeowMix_ChatMsg("".. MeowMix_Invalid .." |cffffff00".. argv[1])
	end
end

function MeowMix_Reset()
	MeowMix_VAR["NSHeal"] = 0
	MeowMix_VAR["NSHealValue"] = 25
    MeowMix_VAR["PlaySound"] = 1
    MeowMix_VAR["MoTWToggle"] = 1
    MeowMix_VAR["ThornsToggle"] = 1
    MeowMix_VAR["OmenToggle"] = 0
    MeowMix_VAR["SillySounds"] = 0
    MeowMix_VAR["ClawFF"] = 0
    MeowMix_VAR["DebuffToggle"] = 1
    MeowMix_VAR["SoundToggle"] = 1
    MeowMix_VAR["MCR"] = 1.0
    MeowMix_VAR["MCG"] = 0.0
    MeowMix_VAR["MCB"] = 0.0
    MeowMix_VAR["FBToggle"] = 1
    MeowMix_VAR["Finisher"] = 1
    MeowMix_VAR["PreserveForms"] = 0
	MeowMix_ChatMsg("".. MeowMix_ResetCom2)
end

function MeowMix_Help()
	MeowMix_ChatMsg("".. MeowMix_Help1)
    MeowMix_ChatMsg("".. MeowMix_Help2)
    MeowMix_ChatMsg("".. MeowMix_Help3)
    MeowMix_ChatMsg("".. MeowMix_Help4)
    MeowMix_ChatMsg("".. MeowMix_Help5)
end

function MeowMix_Macros()
	MeowMix_ChatMsg("".. MeowMix_Macro1)
    MeowMix_ChatMsg("".. MeowMix_Macro2)
    MeowMix_ChatMsg("".. MeowMix_Macro3)
    MeowMix_ChatMsg("".. MeowMix_Macro4)
    MeowMix_ChatMsg("".. MeowMix_Macro5)
    MeowMix_ChatMsg("".. MeowMix_Macro6)
    MeowMix_ChatMsg("".. MeowMix_Macro7)
    MeowMix_ChatMsg("".. MeowMix_Macro8)
    MeowMix_ChatMsg("".. MeowMix_Macro9)
    MeowMix_ChatMsg("".. MeowMix_Macro10)
    MeowMix_ChatMsg("".. MeowMix_Macro11)
    MeowMix_ChatMsg("".. MeowMix_Macro12)
    MeowMix_ChatMsg("".. MeowMix_Macro13)
    MeowMix_ChatMsg("".. MeowMix_Macro14)
    MeowMix_ChatMsg("".. MeowMix_Macro15)
    MeowMix_ChatMsg("".. MeowMix_Macro16)
    MeowMix_ChatMsg("".. MeowMix_Macro17)
    MeowMix_ChatMsg("".. MeowMix_Macro18)
    MeowMix_ChatMsg("".. MeowMix_Macro19)
    MeowMix_ChatMsg("".. MeowMix_Macro20)
    MeowMix_ChatMsg("".. MeowMix_Macro21)
    MeowMix_ChatMsg("".. MeowMix_Macro22)
end

--#############################################################
--########################################### Messages
--#############################################################

function MeowMix_ChatMsg(msg)
	if(DEFAULT_CHAT_FRAME) then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffd200MM:|cffffff00 " .. msg );
	end
end

function MeowMix_FrameMsg(msg)
	if MeowMix_MessageFrame then
		MeowMix_MessageFrame:AddMessage("" ..  msg, MeowMix_VAR["MCR"], MeowMix_VAR["MCG"], MeowMix_VAR["MCB"], 1, 1)
	end
end

--#############################################################
--########################################### XML
--#############################################################

function MeowMix_ChangeColor()
	local r,g,b = ColorPickerFrame:GetColorRGB()
	MeowMix_BG1_ColorArea:SetTexture(r, g, b)
    MeowMix_VAR["MCR"] = r
    MeowMix_VAR["MCG"] = g
    MeowMix_VAR["MCB"] = b
end

function MeowMix_ColorSet()
    r = MeowMix_VAR["MCR"]
    g = MeowMix_VAR["MCG"]
    b = MeowMix_VAR["MCB"]
	MeowMix_BG1_ColorArea:SetTexture(r, g, b)
end

function MeowMix_InitSlider(slider)
    local sl = getglobal(slider)
	sl.tooltipText = "This is a percentage"
	getglobal(slider .. "Low"):SetText("1%")
	getglobal(slider .. "High"):SetText("100%")
	getglobal(slider .. "Text"):SetText("Player Health")
end

function MeowMix_SliderValue(value)
    MeowMix_VAR["NSHealValue"] = value
end

function MeowMix_FrameToggle()
	local frame = getglobal("MeowMix_BG1")
    if (frame) then
        if frame:IsVisible() then
            frame:Hide();
        else
            frame:Show();
        end
    end
end

function MeowMix_HideAll()
	local frame = getglobal("MeowMix_BG1")
	if (frame) then
		MeowMix_BG1_Text01:Hide()
		MeowMix_BG1_Text02:Hide()
		MeowMix_BG1_Text1:Hide()
		MeowMix_BG1_Text20:Hide()
		MeowMix_BG1_Slider1:Hide()
		MeowMix_BG1_ColorArea:Hide()
		MeowMix_BG1_CheckButton1:Hide()
		MeowMix_BG1_CheckButton2:Hide()
		MeowMix_BG1_CheckButton3:Hide()
        MeowMix_BG1_CheckButton4:Hide()
        MeowMix_BG1_CheckButton5:Hide()
        MeowMix_BG1_CheckButton6:Hide()
		MeowMix_BG1_RadioButton1:Hide()
		MeowMix_BG1_RadioButton2:Hide()
		MeowMix_BG1_RadioButton20:Hide()
		MeowMix_BG1_RadioButton21:Hide()
		MeowMix_BG1_CheckButton21:Hide()
		MeowMix_BG1_CheckButton22:Hide()
		MeowMix_BG1_CheckButton23:Hide()
		MeowMix_BG1_CheckButton24:Hide()
	end
end

function MeowMix_CheckBoxCheck1()
	if MeowMix_VAR["MoTWToggle"]==0 then MeowMix_VAR["MoTWToggle"] = 1
	else MeowMix_VAR["MoTWToggle"] = 0 end
end

function MeowMix_CheckBoxCheck2()
	if MeowMix_VAR["ThornsToggle"]==0 then MeowMix_VAR["ThornsToggle"] = 1
	else  MeowMix_VAR["ThornsToggle"] = 0 end
end

function MeowMix_CheckBoxCheck3()
	if MeowMix_VAR["OmenToggle"]==0 then MeowMix_VAR["OmenToggle"] = 1
	else  MeowMix_VAR["OmenToggle"] = 0 end
end

function MeowMix_CheckBoxCheck4()
	if MeowMix_VAR["ClawFF"]==0 then MeowMix_VAR["ClawFF"] = 1
	else  MeowMix_VAR["ClawFF"] = 0 end
end

function MeowMix_CheckBoxCheck5()
	if MeowMix_VAR["FBToggle"]==0 then MeowMix_VAR["FBToggle"] = 1
	else  MeowMix_VAR["FBToggle"] = 0 end
end

function MeowMix_CheckBoxCheck6()
	if MeowMix_VAR["PreserveForms"]==0 then MeowMix_VAR["PreserveForms"] = 1
	else  MeowMix_VAR["PreserveForms"] = 0 end
end

function MeowMix_RadioCheck()
	if (MeowMix_BG1_RadioButton20:GetChecked()) then
		MeowMix_VAR["PlaySound"] = 1
        MeowMix_VAR["SillySounds"] = 0
	elseif (MeowMix_BG1_RadioButton21:GetChecked()) then
		MeowMix_VAR["PlaySound"] = 0
        MeowMix_VAR["SillySounds"] = 1
	end
end

function MeowMix_RadioCheck2()
	if (MeowMix_BG1_RadioButton1:GetChecked()) then
		MeowMix_VAR["Finisher"] = 1
	elseif (MeowMix_BG1_RadioButton2:GetChecked()) then
		MeowMix_VAR["Finisher"] = 2
	end
end

function MeowMix_CheckBoxCheck21()
	if MeowMix_VAR["NSHeal"]==0 then MeowMix_VAR["NSHeal"] = 1
	else MeowMix_VAR["NSHeal"] = 0 end
end

function MeowMix_CheckBoxCheck22()
	if MeowMix_VAR["DebuffToggle"]==0 then MeowMix_VAR["DebuffToggle"] = 1
	else MeowMix_VAR["DebuffToggle"] = 0 end
end

function MeowMix_CheckBoxCheck23()
	if MeowMix_VAR["SoundToggle"]==0 then MeowMix_VAR["SoundToggle"] = 1
	else MeowMix_VAR["SoundToggle"] = 0 end
end

--#############################################################
--########################################### The below code is credit to Tyndral [root@brokengod.net] for the mod IsBuffActive
--########################################### All I did was rename IsBuffActiveTooltip to MeowMix_IsBuffActiveTooltip to reduce confict errors.
--#############################################################

function MeowMix_IsBuffActive(buffname, unit)
	MeowMix_IsBuffActiveTooltip:SetOwner(UIParent, "ANCHOR_NONE");
	if (not buffname) then
		return;
	end;
	if (not unit) then
		unit="player";
	end;
	if string.lower(unit) == "mainhand" then
		MeowMix_IsBuffActiveTooltip:ClearLines();
		MeowMix_IsBuffActiveTooltip:SetInventoryItem("player",GetInventorySlotInfo("MainHandSlot"));
		for i = 1,MeowMix_IsBuffActiveTooltip:NumLines() do
			if string.find((getglobal("MeowMix_IsBuffActiveTooltipTextLeft"..i):GetText() or ""),buffname) then
				return true
			end;
		end
		return false
	end
	if string.lower(unit) == "offhand" then
		MeowMix_IsBuffActiveTooltip:ClearLines();
		MeowMix_IsBuffActiveTooltip:SetInventoryItem("player",GetInventorySlotInfo("SecondaryHandSlot"));
		for i=1,MeowMix_IsBuffActiveTooltip:NumLines() do
			if string.find((getglobal("MeowMix_IsBuffActiveTooltipTextLeft"..i):GetText() or ""),buffname) then
				return true
			end;
		end
		return false
	end
  local i = 1;
  while UnitBuff(unit, i) do 
		MeowMix_IsBuffActiveTooltip:ClearLines();
		MeowMix_IsBuffActiveTooltip:SetUnitBuff(unit,i);
    if string.find(MeowMix_IsBuffActiveTooltipTextLeft1:GetText() or "", buffname) then
      return true, i
    end;
    i = i + 1;
  end;
  local i = 1;
  while UnitDebuff(unit, i) do 
		MeowMix_IsBuffActiveTooltip:ClearLines();
		MeowMix_IsBuffActiveTooltip:SetUnitDebuff(unit,i);
    if string.find(MeowMix_IsBuffActiveTooltipTextLeft1:GetText() or "", buffname) then
      return true, i
    end;
    i = i + 1;
  end;
end