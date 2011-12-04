--#############################################################
--########################################### MISC FUNCTIONS
--#############################################################

function MeowMix_CancelForm()
    if MeowMix_IsBuffActive("".. BINDING_NAME_MEOWMIX_BEAR) then CastShapeshiftForm(1) end
    if MeowMix_IsBuffActive("".. MeowMix_DireName) then CastShapeshiftForm(1) end
    if MeowMix_IsBuffActive("".. BINDING_NAME_MEOWMIX_AQUA) then CastShapeshiftForm(2) end
    if MeowMix_IsBuffActive("".. BINDING_NAME_MEOWMIX_CAT) then CastShapeshiftForm(3) end
    if MeowMix_IsBuffActive("".. BINDING_NAME_MEOWMIX_TRAVEL) then CastShapeshiftForm(4) end
    if MeowMix_IsBuffActive("".. MeowMix_MoonkinName) then CastShapeshiftForm(5) end
end

function MeowMix_CastForm(formName)
    if MeowMix_Shapeshifted() then
        if (MeowMix_VAR["PreserveForms"] == 1) then return end
    end
    if (formName == "bear") then CastShapeshiftForm(1)
        elseif (formName == "aqua") then CastShapeshiftForm(2)
        elseif (formName == "cat") then CastShapeshiftForm(3)
        elseif (formName == "travel") then CastShapeshiftForm(4)
        elseif (formName == "moonkin") then CastShapeshiftForm(5)
    end
end

function MeowMix_DruidCheck()
    local playerClass, englishClass = UnitClass("player")
    if (englishClass == "DRUID") then
        return true
    else
        return false
    end
end

function MeowMix_Innervate()
    if (not UnitIsFriend("player","target") or (UnitManaMax("target")<200 and not MeowMix_DruidCheck())) then TargetUnit("player") end
    CastSpellByName("".. MeowMix_InnervateName)
    SendChatMessage("".. MeowMix_InnervateMsg, "WHISPER", lang, UnitName("target"))
end

function MeowMix_Prowl()
    if not MeowMix_IsBuffActive("".. MeowMix_ProwlName) then
        CastSpellByName("".. MeowMix_ProwlName)
    end
end

function MeowMix_Rez()
    for i = 1, 40 do
        local playerClass, englishClass = UnitClass("raid"..i)
        if (UnitIsDead("raid"..i) and englishClass == "PRIEST") then
            TargetUnit("raid"..i)
            CastSpellByName("".. MeowMix_Rebirth)
            break
        end
    end
end

function MeowMix_Buff()
    if UnitInRaid("player") then
        PlayerZone = GetZoneText()
        for i = 1, 40 do
            name, rank, subgroup, level, class, fileName, zone, online = GetRaidRosterInfo(i)
            if (not MeowMix_IsBuffActive(""..MeowMix_MarkName, "raid"..i) and not MeowMix_IsBuffActive(""..MeowMix_GiftName, "raid"..i) and CheckInteractDistance("raid"..i,4) and not UnitIsDead("raid"..i)) then
                TargetUnit("raid"..i)
                CastSpellByName("".. MeowMix_MarkName)
                break
            end
        end
    end
end

function MeowMix_SpellRanks(spell)
    if (spell == "regrowth") then
        l={12,18,24,30,36,42,48,54,60}
        count = 9
    end
    if (spell == "rejuv") then
        l={4,10,16,22,28,34,40,46,52,58}
        count = 10
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

function MeowMix_Rejuv()
    if not UnitIsFriend("player","target") then TargetUnit("player") end
    for i = MeowMix_SpellRanks("rejuv"),1,-1 do
        if (UnitLevel("target") >= l[i]-10) then
            CastSpellByName("".. MeowMix_RejuvName .."(".. MeowMix_RankWord .. " "..i..")")
            break
        end
    end
end

function MeowMix_Regrowth()
    if not UnitIsFriend("player","target") then TargetUnit("player") end
    for i = MeowMix_SpellRanks("regrowth"),1,-1 do
        if (UnitLevel("target") >= l[i]-10) then
            CastSpellByName("".. MeowMix_RegrowName .."(".. MeowMix_RankWord .." "..i..")")
            break
        end
    end
end

function MeowMix_MoTW()
    if not UnitIsFriend("player","target") then TargetUnit("player") end
    for i = MeowMix_SpellRanks("motw"),1,-1 do
        if (UnitLevel("target") >= l[i]-10) then
            CastSpellByName("".. MeowMix_MarkName .."(".. MeowMix_RankWord .." "..i..")")
            break
        end
    end 
end

function MeowMix_Thorns()
    if not UnitIsFriend("player","target") then TargetUnit("player") end
    for i = MeowMix_SpellRanks("thorns"),1,-1 do
        if (UnitLevel("target") >= l[i]-10) then
            CastSpellByName("".. MeowMix_ThornsName .."("..MeowMix_RankWord .." "..i..")")
            break
        end
    end 
end

function MeowMix_HealthCheck()
    return ((UnitHealth("player") / UnitHealthMax("player"))*100)
end

function MeowMix_Shapeshifted()
    if MeowMix_IsBuffActive("".. BINDING_NAME_MEOWMIX_BEAR) or MeowMix_IsBuffActive("".. BINDING_NAME_MEOWMIX_AQUA) or
        MeowMix_IsBuffActive("".. BINDING_NAME_MEOWMIX_CAT) or MeowMix_IsBuffActive("".. BINDING_NAME_MEOWMIX_TRAVEL) or
        MeowMix_IsBuffActive("".. MeowMix_DireName) then
        return true
    end
end

function MeowMix_NSHeal()
    CastSpellByName("".. MeowMix_NS, 1)
    SpellStopCasting()
    CastSpellByName("".. MeowMix_HT, 1)
end

function MeowMix_Totem()
    if (UnitName("target") ~=nil) and (string.find(UnitName("target"), MeowMix_TotemWord)) ~= nil then
        CastSpellByName("".. MeowMix_Moonfire1)
    else
        CastSpellByName("".. MeowMix_Moonfire10)
    end 
end

function MeowMix_healToT()
    if not MeowMix_Shapeshifted() and not UnitIsFriend("player", "target") then
        CastSpellByName("".. MeowMix_healToTSpell)
        SpellTargetUnit("targettarget")
    end
end


function MeowMix_Claw()
    if ((not MeowMix_IsBuffActive("".. MeowMix_FaerieName, "target")) and MeowMix_VAR["ClawFF"] == 1 and UnitMana("player") < 35) then
        CastSpellByName("".. MeowMix_Faerie .."()")
        return
    end
    if (GetComboPoints() == 5 and MeowMix_VAR["FBToggle"] == 1) then
        if (MeowMix_VAR["Finisher"] == 1) then
            CastSpellByName("".. MeowMix_FerociousName)
        else
            CastSpellByName("".. MeowMix_RipName)
        end
    else
        CastSpellByName("".. MeowMix_ClawName)
    end
end

function MeowMix_Back()
    if  MeowMix_IsBuffActive("".. MeowMix_ProwlName) then
        CastSpellByName("".. MeowMix_RavageName)
    elseif (GetComboPoints() == 5) then
        CastSpellByName("".. MeowMix_FerociousName)
    else
        CastSpellByName("".. MeowMix_ShredName)
    end
end

function MeowMix_FunnyText()
    num = math.random(1, 89)
    if num == 1 then return "Any pull that can go wrong, will go wrong"
    elseif num == 2 then return "Only gear meant for a class you didnt group with will drop"
    elseif num == 3 then return "Gear meant for your class never drops"
    elseif num == 4 then return "He who lags last, lags most"
    elseif num == 5 then return "If WoW becomes n00b proof; someone will become a better n00b"
    elseif num == 6 then return "The group will always move on when you are out of mana"
    elseif num == 7 then return "Its always the healers fault"
    elseif num == 8 then return "The server will crash when the boss is at 10% life"
    elseif num == 9 then return "PvPers: The server will crash 10 hours into AV"
    elseif num == 10 then return "You will always lag into the lava"
    elseif num == 11 then return "If you didnt lag into the lava, its because you got Mind Controlled..."
    elseif num == 12 then return "If everything seems to be going well, you are surrounded by rogues"
    elseif num == 13 then return "Smile, the next pull will be worse"
    elseif num == 14 then return "The group will always run away from your totems"
    elseif num == 15 then return "The debuff you cast will be dropped first"
    elseif num == 16 then return "Yes, you just got 1-shotted"
    elseif num == 17 then return "Never PUG with anyone stupider than you"
    elseif num == 18 then return "Never PvP with anyone crazier than you"
    elseif num == 19 then return "If you dont remember, the Freezing Trap was laid by the other team"
    elseif num == 20 then return "Someone will always have better gear than you"
    elseif num == 21 then return "Someone always hits the Sheep"
    elseif num == 22 then return "Your quest is bugged"
    elseif num == 23 then return "All the bugs will be fixed in the next patch"
    elseif num == 24 then return "Working as Intended"
    elseif num == 25 then return "The queue will always be highest when you try to log on"
    elseif num == 26 then return "You will not get healed while casting Hellfire"
    elseif num == 27 then return "Your class always gets the nerf"
    elseif num == 28 then return "You just buffed someone who was flagged. Prepare to get ganked"
    elseif num == 29 then return "No one understands RPers"
    elseif num == 30 then return "The mobs have already respawned"
    elseif num == 31 then return "1 in 5 people are ninjas"
    elseif num == 32 then return "There is one best talent build; and it isnt yours"
    elseif num == 33 then return "Dont pull someone is /afk"
    elseif num == 34 then return "To err is human; to forgive is not guild policy"
    elseif num == 35 then return "Its still 50dkp minus"
    elseif num == 36 then return "Repair costs always go up"
    elseif num == 37 then return "The Soulstone just ended"
    elseif num == 38 then return "The one ability you need to use is on cooldown"
    elseif num == 39 then return "Wisps are the new Alliance race"
    elseif num == 40 then return "All your addons will need to be redone next patch"
    elseif num == 41 then return "Your corpse is being camped"
    elseif num == 42 then return "All things are possible except finding a competent PUG"
    elseif num == 43 then return "The bosss level is always higher than yours"
    elseif num == 44 then return "You will always need to raid one more time"
    elseif num == 45 then return "You just killed a Civilian"
    elseif num == 46 then return "Your fishing pole is still equipped"
    elseif num == 47 then return "He who has the gold, owns the AH"
    elseif num == 48 then return "Your words will be quoted and trolled against you"
    elseif num == 49 then return "Goblin jumper cables never work when you need them"
    elseif num == 50 then return "Your target dummies never come with fused wiring"
    elseif num == 51 then return "Every other profession except yours got buffed"
    elseif num == 52 then return "Where is Mankirk's wife?"
    elseif num == 53 then return "You just blinked through the world"
    elseif num == 54 then return "It's always the tank's fault."
    elseif num == 55 then return "Resist/miss/parry/dodge/evade"
    elseif num == 56 then return "Hunter item"
    elseif num == 57 then return "The priest always heals the other warrior in pvp"
    elseif num == 58 then return "No one heals in pvp"
    elseif num == 59 then return "Realm transfers don't apply to your server"
    elseif num == 60 then return "Everyone is on the same quest as you, and they got there first"
    elseif num == 61 then return "If the quest involves a party, no one has it"
    elseif num == 62 then return "No one wants to run the same instance as you"
    elseif num == 63 then return "The other factions racials are overpowered"
    elseif num == 64 then return "Epics are for other people"
    elseif num == 65 then return "The harder you work for something, the more it will be nerfed"
    elseif num == 66 then return "Shadow priests will melt faces in pvp"
    elseif num == 67 then return "Out of range"
    elseif num == 68 then return "Interrupted"
    elseif num == 69 then return "No path available"
    elseif num == 70 then return "Target not in line of sight"
    elseif num == 71 then return "Today is Tuesday"
    elseif num == 72 then return "Authenticating"
    elseif num == 73 then return "You will fail to notice the 2 story devilsaur sneaking up behind you"
    elseif num == 74 then return "Items that vendors own are useless"
    elseif num == 75 then return "People still put grey items up for Auction"
    elseif num == 76 then return "The gear that drops is best used v.s. the mob or boss who dropped it"
    elseif num == 77 then return "Bosses are still immune to the best spells"
    elseif num == 78 then return "Yes, the quest you just accepted told you to talk to the quest giver"
    elseif num == 79 then return "Your trinkets won't stack next patch"
    elseif num == 80 then return "Your PvP trinket is always on cooldown"
    elseif num == 81 then return "Disarm was parried. (What?!)"
    elseif num == 82 then return "Your healing spells generate 100% more hate in instances"
    elseif num == 83 then return "Rogues are immune to faerie fire, moonfire, and entangling roots"
    elseif num == 84 then return "CC effects are always resisted, dodged, or parried by fleeing enemies"
    elseif num == 85 then return "Enemies always flee into groups of 4 or more"
    elseif num == 86 then return "Fear always causes targets to run to the nearest group of enemies"
    elseif num == 87 then return "Even if the mob is out of your casting range, you are not out of its"
    elseif num == 88 then return "Mobs can climb anything...you cannot"
    elseif num == 89 then return "Whatever it takes to get you to keep paying $15/month"
    end
end

function MeowMix_SillySounds()
    num = math.random(1, 9)
    if (num == 1) then
        PlaySoundFile("Sound\\Character\\PlayerRoars\\CharacterRoarsGnomeMale.wav")
    elseif (num == 2) then
        PlaySoundFile("Sound\\Creature\\Chicken\\ChickenDeathA.wav")
    elseif (num == 3) then
        PlaySoundFile("Sound\\Creature\\Dryad\\DryadDeathA.wav")
    elseif (num == 4) then
        PlaySoundFile("Sound\\Creature\\Ogre\\mOgreAggro1.wav")
    elseif (num == 5) then
        PlaySoundFile("Sound\\Character\\PlayerRoars\\CharacterRoarsGnomeFemale.wav")
    elseif (num == 6) then
        PlaySoundFile("Sound\\Character\\PlayerRoars\\CharacterRoarsHumanFemale.wav")
    elseif (num == 7) then
        PlaySoundFile("Sound\\Character\\PlayerRoars\\CharacterRoarsUndeadFemale.wav")
    elseif (num == 8) then
        PlaySoundFile("Sound\\Character\\PlayerRoars\\CharacterRoarsNightelfFemale.wav")
    elseif (num == 9) then
        PlaySoundFile("Sound\\Character\\PlayerRoars\\CharacterRoarsUndeadMale.wav")
    end
end
