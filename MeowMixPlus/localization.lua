--Vars

-- If HP deficit is less than this amount, an error message will be shown
-- and/or another spell casted depending on the request.
-- This was designed to save your mana and cooldowns. you remove this check
-- set  MeowMix_SwiftmendAmount = 0 (for swiftmend)
-- and/or MeowMix_NSAmount = 0 (for NS heal)
--
-- **Note: this check will be skipped if the target is not in your group
-- and instead the percentage check will be done
MeowMix_SwiftmendAmount = 1200
MeowMix_NSAmount = 2400


-- If HP % is less than this amount, an error message will be shown
-- and/or another spell casted depending on the request.
-- This was designed to save your mana and cooldowns. you remove this check
-- set  MeowMix_Swiftmend_PC = 100 (for swiftmend)
-- and/or MeowMix_NS_PC = 100 (for NS heal)
--
MeowMix_Swiftmend_PC = 70
MeowMix_NS_PC = 50

FagMeld_manaPC = 80
FagMeld_hpPC = 80
FagMeld_DrinkMe = "Conjured Crystal Water"
FagMeld_EatMe = "Enriched Mana Biscuit"


-- Spells
MeowMix_Moonfire       = "Moonfire"; 
MeowMix_MoonfireName       = "Moonfire"; 
MeowMix_TranquilityName = "Tranquility"
MeowMix_HurricaneName = "Hurricane"
MeowMix_SwiftmendName = "Swiftmend"
MeowMix_InsectName = "Insect Swarm"
MeowMix_BarkskinName= "Barkskin"
MeowMix_Bash= "Bash"
MeowMix_BashName= "Bash"


-- Classes
MeowMix_PRIEST               = "Priest";
MeowMix_DRUID                = "Druid";

-- Errors
MeowMix_ErrIsNPC = " is an NPC!"
MeowMix_ErrIsNotCaster = " is not a caster!"
MeowMix_ErrCD = "Spell is not ready yet."
MeowMix_ErrInnervateUP = " is already Innervated!"
MeowMix_ErrMana = "% Mana"
MeowMix_ErrMoreThan = " has more than "
MeowMix_ErrDrinkUp = "You are out of combat! drink up!"
MeowMix_ErrOOR = " is out of range!";
MeowMix_ErrIsAlive = " is ALIVE";
MeowMix_PingMsg = " OOR! -PING- Your location on minimap please!"
MeowMix_Buff_DoneMsg = "Everyone in zone has MoTW/GoTW"

-- Messages
MeowMix_InnervateMsg = "You have just been Innervated!! Equip A spirit heavy weapon to regen faster!"
MeowMix_RebirthMsg = "Battle Rezzed! Drink/Eat when you come up or try to OOC Rez someone!"
MeowMix_BashNOW = " is BASHED RAWR!"



 
if (GetLocale() == "deDE") then
-- German Translation
    MeowMix_PRIEST     = "Priester";
    MeowMix_DRUID      = "Druide";
end

if (GetLocale() == "frFR") then
-- Frence Translation
    MeowMix_PRIEST     = "Pr\195\170tre";
    MeowMix_DRUID      = "Druide";
end