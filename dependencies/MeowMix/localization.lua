--[[
Localization for Meow Mix
English Client

Instructions: Change the below text in QUOTES to reflect what the 
english words mean in your language. Pretty simple!
|cffffd200 and |cffffff00 are color codes, ignore those. Change the words only.
]]

-- command line (all must be lowercase)
MeowMix_ClawCom = "claw"
MeowMix_BackCom = "back"
MeowMix_BuffCom = "buff"
MeowMix_RezCom = "rez"
MeowMix_healtotCom = "healtot"
MeowMix_TotemCom = "totem"
MeowMix_NSHealCom = "nsheal"
MeowMix_MoTWCom = "motw"
MeowMix_ThornsCom = "thorns"
MeowMix_RegrowthCom = "regrowth"
MeowMix_RejuvCom = "rejuv"
MeowMix_ProwlCom = "prowl"
MeowMix_InnervateCom = "innervate"
MeowMix_CastCom = "cast"
MeowMix_MacrosCom = "macros"
MeowMix_HelpCom = "help"
MeowMix_ResetCom = "reset"
MeowMix_DebugCom = "debug"
MeowMix_CancelFormWord = "cancelform"

-- Misc
BINDING_HEADER_MEOWMIX = "Meow Mix Actions"
BINDING_NAME_MEOWMIX_BUFF = "Buff/NS/Omen Casting key:"
BINDING_NAME_MEOWMIX_BEAR = "Bear Form"
BINDING_NAME_MEOWMIX_AQUA = "Aquatic Form"
BINDING_NAME_MEOWMIX_CAT = "Cat Form"
BINDING_NAME_MEOWMIX_TRAVEL = "Travel Form"
BINDING_NAME_MEOWMIX_MOONKIN = "Moonkin Form"
BINDING_NAME_MEOWMIX_CANCEL = "Cancel current form"

MeowMix_TotemWord = "Totem"
MeowMix_RankWord = "Rank"
MeowMix_ResetCom2 = "All variables reset to default on first run state"

-- Spells
MeowMix_ThornsName = "Thorns"
MeowMix_MountName = "Mount"
MeowMix_DireName = "Dire Bear Form"
MeowMix_OmenName = "Omen of Clarity"
MeowMix_NS = "Nature's Swiftness"
MeowMix_HT = "Healing Touch"
MeowMix_MarkName = "Mark of the Wild"
MeowMix_GiftName = "Gift of the Wild"
MeowMix_Rebirth = "Rebirth"
MeowMix_Moonfire1 = "Moonfire(Rank 1)"
MeowMix_Moonfire10 = "Moonfire(Rank 10)"
MeowMix_RejuvName = "Rejuvenation"
MeowMix_RegrowName = "Regrowth"
MeowMix_InnervateName = "Innervate"
MeowMix_InnervateMsg = "You have just been Innervated!! Equip A spirit heavy weapon to regen faster!"
MeowMix_Abolish = "Abolish Poison"
MeowMix_MoonkinName = "Moonkin Form"

-- Abilities
MeowMix_ClawName = "Claw"
MeowMix_healToTSpell = "Regrowth"
MeowMix_FerociousName = "Ferocious Bite"
MeowMix_RavageName = "Ravage"
MeowMix_ShredName = "Shred"
MeowMix_ProwlName = "Prowl"
MeowMix_Faerie = "Faerie Fire (Feral)"
MeowMix_FaerieName = "Faerie Fire"
MeowMix_RipName = "Rip"

-- Messages
MeowMix_Invalid = "Invalid Command!"
MeowMix_NSNOW = "Nature's Swiftness Heal NOW!"
MeowMix_MoTWNOW = "MoTW faded"
MeowMix_ThornsNOW = "Thorns faded"
MeowMix_OmenNow = "Omen of Clarity faded"
MeowMix_DebuffMsg = "CUREABLE DEBUFF DETECTED!!!"

MeowMix_Version = ".3"    -- Do not touch this line
MeowMix_Welcome = "|cffffd200 Meow Mix v|cffffff00" .. MeowMix_Version .. "|cffffd200 by kneeki loaded - usage: |cffffff00 /meowmix"
MeowMix_Help1 = "Meow Mix v|cffffd200".. MeowMix_Version .."|cffffff00 HELP!"
MeowMix_Help2 = "/meowmix |cffffd200- launch config"
MeowMix_Help3 = "/meowmix reset |cffffd200- break something? use this to reset all values"
MeowMix_Help4 = "/meowmix debug |cffffd200- spams your main window with all the current flags"
MeowMix_Help4 = "/meowmix macros |cffffd200- lists all the MeowMix built in macros"
MeowMix_Help5 = "/meowmix help |cffffd200- this help menu"

MeowMix_Macro1 = "Meow Mix v|cffffd200".. MeowMix_Version .."|cffffff00 Macro Usage:"
MeowMix_Macro2 = "Simply type /macro in your main chat to bring up the macro interface (You can also use /mm)"
MeowMix_Macro3 = "Feral Stuff:"
MeowMix_Macro4 = "/meowmix claw - |cffffd200will cast claw and on 5 combo points casts FB"
MeowMix_Macro5 = "meowmix back - |cffffd200if prowling will cast Ravage, otherwise will Shred"
MeowMix_Macro6 = "/meowmix prowl - |cffffd200casts prowl if not active, if it is, will not cancel the buff"
MeowMix_Macro7 = "/meowmix cancelform - |cffffd200cancels your current shapeshift form"
MeowMix_Macro8 = "Heal Bitch Stuff:"
MeowMix_Macro9 = "/meowmix regrowth - |cffffd200casts the highest rank Regrowth on your target"
MeowMix_Macro10 = "/meowmix rejuv - |cffffd200casts the highest rank Rejuv on your target"
MeowMix_Macro11 = "/meowmix nsheal - |cffffd200will instantly cast Nature's Swiftness + Big heal"
MeowMix_Macro12 = "/meowmix healtot - |cffffd200heals your targets target. Only works on hostile targets"
MeowMix_Macro13 = "/meowmix rez - |cffffd200casts Rebirth on a random dead priest"
MeowMix_Macro14 = "Buffing and the like:"
MeowMix_Macro15 = "/meowmix buff - |cffffd200scans your raid and searches for targets to buff with MoTW"
MeowMix_Macro16 = "/meowmix motw - |cffffd200casts the highest rank MoTW on your target"
MeowMix_Macro17 = "/meowmix thorns - |cffffd200casts the highest rank thorns on your target"
MeowMix_Macro18 = "/meowmix innervate - |cffffd200casts innervate on your target if they have a mana bar or yourself"
MeowMix_Macro19 = "Misc Stuff:"
MeowMix_Macro20 = "/meowmix cast - |cffffd200if you dont want to use the keybinding feature, you can use this to cast self buffs"
MeowMix_Macro21 = "/meowmix totem - |cffffd200casts rank 1 moonfire if your target is a totem else casts rank 10"
MeowMix_Macro22 = "SCROLL UP!!!!"
