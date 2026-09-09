// Ningyo no Rakuin
// #ID = 18248

// --------------------------------------------------------
// MARK: HELPERS
// 
// --------------------------------------------------------
function has_increased(addr) => addr > prev(addr)
function has_decreased(addr) => addr < prev(addr)
function has_changed(addr) => addr != prev(addr)
function hasnt_changed(addr) => addr == prev(addr)
function if_else(p, t, f) { if (p) { return t } else return f }
function is_even(v) => v % 2 == 0


// Pointer mask for custom memory map
RA_MASK = 0x7FFFFFFF

acc_addr = (v) => v // Dummy accessor for ptr for if the pointed-to address is desired
function ptr(base, offsets, accessor = dword)
{
    val = base
	val = val & RA_MASK
    
    for i in range(0, length(offsets) - 1)
    {
        addr = val + offsets[i]
        if (i == length(offsets) - 1)
        {
            val = accessor(addr)
        }
        else
        {
            val = dword(addr)
			val = val & RA_MASK
        }
    }
    
    return val
}

OVERLAY_DEBUG = 0
OVERLAY_BATTLE = 1
OVERLAY_TITLE = 2
OVERLAY_SCENARIO = 3
OVERLAY_CREDITS = 4
function overlay() => word(0x044f5e)

function inBattle() => overlay() == OVERLAY_BATTLE && dword(0x0c000c) == 0x310a0005 && dword(0x0c022c) == 0x0004000f
function goodBattleState() => battleState() != BATTLE_STATE_SAVE && battleState() > 4

function scenario() => word(0x03bc00)
function scenarioNumber() => word(0x03bc02) + 1

function battleState() => dword(0x0ca6d4)
BATTLE_STATE_START = 0x04
BATTLE_STATE_DONE = 0x18
BATTLE_STATE_RESULTS = 0x19
BATTLE_STATE_GAMEOVER = 0x1a
BATTLE_STATE_RESTART = 0x1c
BATTLE_STATE_SAVE = 0x24

ITEM_COLT_M1911 = 0
ITEM_BERETTA_M93R = 1
ITEM_WALTHER_PPK = 2
ITEM_DESERT_EAGLE = 3
ITEM_STUN_GUN = 4
ITEM_ELECTRIC_BATON = 5
ITEM_STUN_MASTER = 6
ITEM_TASER = 7
ITEM_M16 = 8
ITEM_HOWA_TYPE_64 = 9
ITEM_M3_MACHINE_GUN = 10
ITEM_STEYR_SPP = 11
ITEM_LEATHER_GLOVES = 12
ITEM_MERRITT_GLOVES = 13
ITEM_KNUCKLE_DUSTER = 14
ITEM_DYLATH_LEEN_FIST = 15
ITEM_STONE_SWORD = 16
ITEM_CHOKUTO = 17
ITEM_HOKUTO = 18
ITEM_YATSUKA_TSURUGI = 19
ITEM_AXE = 20
ITEM_BATTLE_AXE = 21
ITEM_MOONLIGHT_AXE = 22
ITEM_CLOISONNE_AXE = 23
ITEM_SHORT_BOW = 24
ITEM_POISON_FANG_BOW = 25
ITEM_LONGBOW = 26
ITEM_MAHOROBA_BOW = 27
ITEM_SHELL_ROSARY = 28
ITEM_CULTIST_ROSARY = 29
ITEM_SCALE_ROSARY = 30
ITEM_SILVER_ROSARY = 31
ITEM_CIMMERIAN_BLADE = 32
ITEM_IRON_SWORD = 33
ITEM_EXECUTION_BLADE = 34
ITEM_STONE_NAGINATA = 35
ITEM_WOODEN_SHIELD = 36
ITEM_TORTOISE_SHIELD = 37
ITEM_STEEL_SHIELD = 38
ITEM_ICHTHYIC_SHIELD = 39
ITEM_LEATHER_ARMOUR = 40
ITEM_LACQUER_ARMOUR = 41
ITEM_CHAIN_MAIL = 42
ITEM_ICHTHYIC_ARMOUR = 43
ITEM_CLOTHES = 44
ITEM_GODDESS_ROBE = 45
ITEM_HUNTING_CLOTHES = 46
ITEM_HORNET_HIREI = 47
ITEM_RING = 48
ITEM_SILVER_RING = 49
ITEM_BLACK_PEARL_RING = 50
ITEM_OGAERITO_STONE = 51
ITEM_BRACELET = 52
ITEM_CORAL_BRACELET = 53
ITEM_GNORRI_BANGLE = 54
ITEM_ARATAMA_BRACELET = 55
ITEM_CLOTH_SHOES = 56
ITEM_WOLFSKIN_SANDALS = 57
ITEM_ANKLE_CHAIN = 58
ITEM_ICHTHYIC_BOOTS = 59
ITEM_SOTHOTH_TALISMAN = 60
ITEM_SONIAS_TALISMAN = 61
ITEM_CARTERS_STONE = 62
ITEM_OLNEYS_STONE = 63
ITEM_SANITY_STONE = 64
ITEM_REANIMATOR_ORB = 65
ITEM_YASAKANI_ORB = 66
ITEM_MENTIS_OCULI_ORB = 67
ITEM_BLASTING_POWDER = 68
ITEM_BOMB = 69
ITEM_DYNAMITE = 70
ITEM_ANTIDOTE = 71
ITEM_PAINKILLER = 72
ITEM_HOLY_WATER = 73
ITEM_SEDATIVE = 74
ITEM_ANTI_PHEROMONE = 75
ITEM_STIMULANT = 76
ITEM_RELAXANTS = 77
ITEM_EYE_DROPS = 78
ITEM_SMELLING_SALTS = 79
ITEM_PANACEA = 80
ITEM_OBLIVION_GRASS = 81
ITEM_SEALING_INCENSE = 82
ITEM_MEDICINAL_HERB = 83
ITEM_WOUND_OINTMENT = 84
ITEM_MIRACLE_ELIXIR = 85
ITEM_APHRODISIAC = 86
ITEM_ENERGY_TONIC = 87
ITEM_SACRED_INCENSE = 88
ITEM_AR_ECHBEI_STONE = 89
ITEM_VAN_BUREN_COFFEE = 90
ITEM_JOSHIS_WINE = 91
ITEM_MAK_MORN_ALE = 92
ITEM_WANDREI_WINE = 93
ITEM_NIGGURATH_WINE = 94
ITEM_BYAKHEE_WINE = 95
ITEM_ERIKOS_BRACELET = 96
ITEM_ODUS_BRACELET = 97
ITEM_NOSTRUM = 98
ITEM_YITHIAN_CYLINDER = 99
ITEM_MERFOLK_CLAWS = 100
ITEM_MARTENSE_STAFF = 101
ITEM_SHANTAK_CANNON = 102
ITEM_SHOGGOTH_STEEL = 103
ITEM_AZATHOTHS_FIST = 104
ITEM_GIBBOUS_BLADE = 105
ITEM_FTHAGGUAS_FLAME = 106
ITEM_SOHEBI_ROSARY = 107
ITEM_YELLOW_CROWN = 108
ITEM_ELDRITCH_STONE = 109
ITEM_MASONS_GRIMOIRE = 110
ITEM_SHINIGAMI_ROBE = 111
ITEM_SOLOMONS_RING = 112
function itemAmt(item_id) => byte(0x03bb70 + item_id)

function achGetItem(item_id,s) => inBattle() && scenario() == s && has_increased(itemAmt(item_id)) && battleState() != 7

function secondPlaythrough() => bit(0,0x03bbfc)
function isFirstPlaythrough() => secondPlaythrough() == 0

function achScenarioComplete(s) => inBattle() && __ornext(battleState() == BATTLE_STATE_RESULTS || battleState() == BATTLE_STATE_SAVE) && prev(scenario()) == s && scenario() > s
function achScenarioCompleteProg(s) => inBattle() && __ornext(battleState() == BATTLE_STATE_RESULTS || battleState() == BATTLE_STATE_SAVE) && prev(scenario()) == s && scenario() > s && isFirstPlaythrough()
function achFinalScenarioComplete() => inBattle() && __ornext(battleState() == BATTLE_STATE_RESULTS || battleState() == BATTLE_STATE_SAVE || battleState() == 0x21) && 
			__ornext(prev(scenario()) == 0x15 || prev(scenario()) == 0x16) && 
			scenario() == 0x17 &&
			isFirstPlaythrough()

function achMizukiCured() => inBattle() && __ornext(battleState() == BATTLE_STATE_RESULTS || battleState() == BATTLE_STATE_SAVE) && 
			prev(scenario()) == 0x14 && 
			scenario() == 0x15

function canOpenNostrumChests() => bit(3,0x03bbfd) == 1

function achNostrumObtainedStacy() => inBattle() && scenario() == 0x14 && has_increased(itemAmt(ITEM_NOSTRUM)) && !canOpenNostrumChests()

CHARACTER_KEISUKE = 0
CHARACTER_MIZUKI = 1
CHARACTER_HOWARD = 2
CHARACTER_REIJI = 3
CHARACTER_STACY = 4
CHARACTER_TAKERU = 5
CHARACTER_KIRIU = 6
CHARACTER_CROW = 7

function currentBattlerPtr() => dword(0x0ca6fc)
function currentBattlerChar() => ptr(currentBattlerPtr(), [0x24], byte)
function currentBattlerLevel() => ptr(currentBattlerPtr(), [0x04], word)

function loadoutPtr(i) => dword(0x0cdfa4 + (i*4))
function allLoadoutPtrsZero() => all_of(range(0,5), i => loadoutPtr(i) == 0)
function loadoutChar(i) => ptr(loadoutPtr(i), [0x1c+4], byte) + (loadoutPtr(i)/loadoutPtr(i))
function loadoutCharIs(i, character) => loadoutChar(i) == character + 1
function loadoutLevel(i) => ptr(loadoutPtr(i), [0x00], word)

function achLevelReached(character,level) => inBattle() && (
	any_of(range(0,5), i =>
		loadoutPtr(i) != 0 && 
		loadoutCharIs(i,character) && 
		loadoutLevel(i) >= level && 
		prev(loadoutLevel(i)) < level
	)
	|| 
	(currentBattlerPtr() != 0 && currentBattlerChar() == character && currentBattlerLevel() >= level && prev(currentBattlerLevel()) < level)
)

TREASURES = [
	[ // Scenario 1 - Escape
	[5,0], // Silver Ring - Treasure
	[7,5], // Holy Water - Hidden
	[13,7], // Van Buren Coffee - Hidden
	//[6,9], // Shantak Cannon - Hidden (2nd)
	//[8,9], // Azathoth's Fist - Hidden (2nd)
	],
	[ // Scenario 2 - Hill of Crucifixion
	[10,0], // Blasting Powder - Treasure
	[4,13], // Wooden Shield - Treasure
	[0,7], // Miracle Elixir - Hidden
	[13,6], // Coral Bracelet - Hidden
	//[12,11], // Shoggoth Steel - Hidden (2nd)
	],
	[ // Scenario 3 - Determination
	[2,1], // Goddess Robe - Treasure
	[8,5], // Carter's Stone - Treasure
	[0,10], // Wolfskin Sandals - Hidden
	[11,13], // Joshi's Wine - Hidden
	//[2,12], // Yithian Cylinder - Hidden (2nd)
	],
	[ // Scenario 4 - Shipwreck of the Cursed Sea
	[12,2], // Chokutō - Treasure
	[3,8], // Bomb - Hidden
	[8,8], // Mak Morn Ale - Hidden
	[5,13], // Sacred Incense - Hidden
	],
	[ // Scenario 5 - Swamp of Reminiscence
	[11,4], // Relaxants - Treasure
	[0,11], // Tortoise Shield - Treasure
	[4,4], // Mentis Oculi Orb - Hidden
	[8,9], // Wandrei Wine - Hidden
	],
	[ // Scenario 5 - The Earth Conceals Its Fangs
	[7,2], // Energy Tonic - Hidden
	[9,8], // Chain Mail - Hidden
	[1,5], // Oblivion Grass - Hidden
	[2,13], // Yasakani Orb - Hidden
	],
	[ // Scenario 6 - Stone Precipice Between Life and Death
	[3,4], // Poison Fang Bow - Treasure
	[13,6], // Electric Baton - Treasure
	[0,10], // Niggurath Wine - Hidden
	[2,14], // Smelling Salts - Hidden
	//[7,6], // Merfolk Claws - Hidden (2nd)
	//[6,7], // Martense Staff - Hidden (2nd)
	//[8,7], // Gibbous Blade - Hidden (2nd)
	//[7,8], // Fthaggua's Flame - Hidden (2nd)
	],
	[ // Scenario 7 - Abnormal Blood
	[0,5], // Energy Tonic - Treasure
	[3,12], // Battle Axe - Treasure
	[10,0], // Olney's Stone - Hidden
	[9,6], // Panacea - Hidden
	],
	[ // Scenario 8 - Return
	[12,6], // Walther PPK - Treasure
	[11,1], // Steel Shield - Hidden
	[1,4], // Byakhee Wine - Hidden
	[7,9], // Sanity Stone - Hidden
	],
	[ // Scenario 9 - The Fateful Day
	[4,0], // Dynamite - Hidden
	[9,4], // Sealing Incense - Hidden
	[3,8], // Knuckle Duster - Hidden
	[15,8], // M3 Machine Gun - Hidden
	],
	[ // Scenario 10 - The Curse of Ogaerito
	[5,5], // Stun Master - Hidden
	[1,7], // Sothoth Talisman - Hidden
	[12,13], // Black Pearl Ring - Hidden
	],
	[ // Scenario 11 - The Small Assassins
	[15,1], // Gnorri Bangle - Treasure
	[0,15], // Ichthyic Shield - Treasure
	[4,2], // Eye drops - Hidden
	[4,10], // Longbow - Hidden
	[12,13], // Hokuto - Hidden
	],
	[ // Scenario 12 - Girl Who Cries Death
	[3,7], // Hunting Clothes - Treasure
	[3,8], // Ankle Chain - Treasure
	[3,9], // Steel Shield - Treasure
	[8,7], // Ar-E'chBei Stone - Treasure
	[8,8], // Joshi's Wine - Treasure
	[8,9], // Miracle Elixir - Treasure
	],
	[ // Scenario 13 - The Bridge of Hope
	[7,8], // Ichthyic Armour - Treasure
	[12,0], // Mak Morn Ale - Hidden
	[1,2], // Sonia's Talisman - Hidden
	[4,8], // Moonlight Axe - Hidden
	],
	[ // Scenario 14 - The Ruined Land
	[5,1], // Panacea - Treasure
	[15,5], // Van Buren Coffee - Treasure
	[1,10], // Mahoroba Bow - Treasure
	[14,12], // Hornet Hirei - Treasure
	[0,0], // Byakhee Wine - Hidden
	[9,1], // Holy Water - Hidden
	[8,7], // Ichthyic Boots - Hidden
	[0,9], // Wound Ointment - Hidden
	[14,9], // Medicinal Herb - Hidden
	],
	[ // Scenario 15 - The Heretical Scholar
	[8,5], // Taser - Treasure
	[14,5], // Desert Eagle - Treasure
	[1,5], // Wandrei Wine - Hidden
	[2,11], // Energy Tonic - Hidden
	],
	[ // Scenario 16 - Headstone of Lamentation
	[5,3], // Steyr SPP - Treasure
	[11,13], // Ar-E'chBei Stone - Treasure
	[2,6], // Ogaeritō Stone - Hidden
	[8,8], // Panacea - Hidden
	],
	[ // Scenario 17 - Jungle of Lurking Spectres
	[0,0], // Panacea - Treasure
	[8,1], // Dylath-Leen Fist - Treasure
	[3,8], // Sacred Incense - Treasure
	[7,7], // Aratama Bracelet - Hidden
	[0,9], // Energy Tonic - Hidden
	[12,13], // Wound Ointment - Hidden
	],
	[ // Scenario 16 - The Eternal Guardian
	[11,1], // Yatsuka Tsurugi - Treasure
	[3,7], // Cloisonne Axe - Treasure
	[9,8], // Niggurath Wine - Hidden
	[2,14], // Ar-E'chBei Stone - Hidden
	],
	[ // Scenario 17 - The Cult of Death
	[6,3], // Reanimator Orb - Treasure
	[9,3], // Ar-E'chBei Stone - Treasure
	],
	[ // Scenario 18 - Elixir of Exorcism
	[11,1], // Solomon's Ring - Treasure
	[12,1], // Solomon's Ring - Treasure
	[9,2], // Solomon's Ring - Treasure
	[9,3], // Solomon's Ring - Treasure
	[9,4], // Solomon's Ring - Treasure
	[9,5], // Solomon's Ring - Treasure
	[14,2], // Solomon's Ring - Treasure
	[14,3], // Solomon's Ring - Treasure
	[14,4], // Solomon's Ring - Treasure
	[14,5], // Solomon's Ring - Treasure
	[11,5], // Solomon's Ring - Treasure
	[12,5], // Solomon's Ring - Treasure
	]
]

tile_treasure_start_addr = 0x0cae28

function getTreasureTile(x,y) => byte(tile_treasure_start_addr + x + (y * 16))

function achGetTreasure(x,y,s) => inBattle() && goodBattleState() && scenario() == s && getTreasureTile(x,y) == 0 && prev(getTreasureTile(x,y)) > 0

function achAllTreasures(scenario) => measured(length(TREASURES[scenario])-sum_of(TREASURES[scenario], t => (getTreasureTile(t[0],t[1]) / getTreasureTile(t[0],t[1]))) == length(TREASURES[scenario]), 
										when=scenario() == scenario) &&
									  prev(length(TREASURES[scenario])-sum_of(TREASURES[scenario], t => (getTreasureTile(t[0],t[1]) / getTreasureTile(t[0],t[1]))) == length(TREASURES[scenario]) - 1) &&
									  unless(!goodBattleState()) && unless(!inBattle())

function scenarioFlag(i) => bit(i, 0x0cba14)
function achReijiGrave() => inBattle() && scenario() == 0x10 && has_increased(scenarioFlag(2))
function achHowardShinra() => inBattle() && scenario() == 0x11 && has_increased(scenarioFlag(3))

ScenarioLookup = {
    0: "Escape",
    1: "Hill of Crucifixion",
    2: "Determination",
    3: "Shipwreck of the Cursed Sea",
    4: "Swamp of Reminiscence",
    5: "The Earth Conceals Its Fangs",
    6: "Stone Precipice Between Life and Death",
    7: "Abnormal Blood",
    8: "Return",
    9: "The Fateful Day",
    0xa: "The Curse of Ogaerito",
    0xb: "The Small Assassins",
    0xc: "Girl Who Carries Death",
    0xd: "The Bridge of Hope",
    0xe: "The Ruined Land",
    0xf: "The Heretical Scholar",
    0x10: "Headstone of Lamentation",
    0x11: "Jungle of Lurking Spectres",
    0x12: "The Eternal Guardian",
    0x13: "The Cult of Death",
    0x14: "Elixir of Exorcism",
    0x15: "Devil Reef - R'lyieer",
    0x16: "Devil Reef - R'lyieer" 
}

PlaythroughLookup = {
	1: " [2nd Playthrough]"
}

CharLookup = {
	1: " Keisuke",
	2: " Mizuki",
	3: " Howard",
	4: " Reiji",
	5: " Stacy",
	6: " Takeru",
	7: " Kiriu",
	8: " Crow"
}

CharFirstLookup = {
	1: "Keisuke",
	2: "Mizuki",
	3: "Howard",
	4: "Reiji",
	5: "Stacy",
	6: "Takeru",
	7: "Kiriu",
	8: "Crow"
}

rich_presence_conditional_display(overlay() == OVERLAY_DEBUG, "Loading...")

rich_presence_conditional_display(overlay() == OVERLAY_BATTLE && allLoadoutPtrsZero(), "Scenario {0}: {1}{2}",
    rich_presence_value("Number", scenarioNumber()),
    rich_presence_lookup("Scenario", scenario(), ScenarioLookup),
	rich_presence_lookup("Playthrough",secondPlaythrough(),PlaythroughLookup)
)

rich_presence_conditional_display(overlay() == OVERLAY_BATTLE && loadoutPtr(0) != 0, "Scenario {0}: {1} [{3}{4}{5}{6}{7}{8}]{2}",
    rich_presence_value("Number", scenarioNumber()),
    rich_presence_lookup("Scenario", scenario(), ScenarioLookup),
	rich_presence_lookup("Playthrough",secondPlaythrough(),PlaythroughLookup),
	rich_presence_lookup("CharFirst",loadoutChar(0),CharFirstLookup),
	rich_presence_lookup("Char",loadoutChar(1),CharLookup),
	rich_presence_lookup("Char",loadoutChar(2),CharLookup),
	rich_presence_lookup("Char",loadoutChar(3),CharLookup),
	rich_presence_lookup("Char",loadoutChar(4),CharLookup),
	rich_presence_lookup("Char",loadoutChar(5),CharLookup)
)

rich_presence_conditional_display(overlay() == OVERLAY_BATTLE && loadoutPtr(1) != 0, "Scenario {0}: {1} [{4}{5}{6}{7}{8}]{2}",
    rich_presence_value("Number", scenarioNumber()),
    rich_presence_lookup("Scenario", scenario(), ScenarioLookup),
	rich_presence_lookup("Playthrough",secondPlaythrough(),PlaythroughLookup),
	rich_presence_lookup("Char",loadoutChar(0),CharLookup),
	rich_presence_lookup("CharFirst",loadoutChar(1),CharFirstLookup),
	rich_presence_lookup("Char",loadoutChar(2),CharLookup),
	rich_presence_lookup("Char",loadoutChar(3),CharLookup),
	rich_presence_lookup("Char",loadoutChar(4),CharLookup),
	rich_presence_lookup("Char",loadoutChar(5),CharLookup)
)

rich_presence_conditional_display(overlay() == OVERLAY_BATTLE && loadoutPtr(2) != 0, "Scenario {0}: {1} [{5}{6}{7}{8}]{2}",
    rich_presence_value("Number", scenarioNumber()),
    rich_presence_lookup("Scenario", scenario(), ScenarioLookup),
	rich_presence_lookup("Playthrough",secondPlaythrough(),PlaythroughLookup),
	rich_presence_lookup("Char",loadoutChar(0),CharLookup),
	rich_presence_lookup("Char",loadoutChar(1),CharLookup),
	rich_presence_lookup("CharFirst",loadoutChar(2),CharFirstLookup),
	rich_presence_lookup("Char",loadoutChar(3),CharLookup),
	rich_presence_lookup("Char",loadoutChar(4),CharLookup),
	rich_presence_lookup("Char",loadoutChar(5),CharLookup)
)

rich_presence_conditional_display(overlay() == OVERLAY_BATTLE && loadoutPtr(3) != 0, "Scenario {0}: {1} [{6}{7}{8}]{2}",
    rich_presence_value("Number", scenarioNumber()),
    rich_presence_lookup("Scenario", scenario(), ScenarioLookup),
	rich_presence_lookup("Playthrough",secondPlaythrough(),PlaythroughLookup),
	rich_presence_lookup("Char",loadoutChar(0),CharLookup),
	rich_presence_lookup("Char",loadoutChar(1),CharLookup),
	rich_presence_lookup("Char",loadoutChar(2),CharLookup),
	rich_presence_lookup("CharFirst",loadoutChar(3),CharFirstLookup),
	rich_presence_lookup("Char",loadoutChar(4),CharLookup),
	rich_presence_lookup("Char",loadoutChar(5),CharLookup)
)

rich_presence_conditional_display(overlay() == OVERLAY_BATTLE && loadoutPtr(4) != 0, "Scenario {0}: {1} [{7}{8}]{2}",
    rich_presence_value("Number", scenarioNumber()),
    rich_presence_lookup("Scenario", scenario(), ScenarioLookup),
	rich_presence_lookup("Playthrough",secondPlaythrough(),PlaythroughLookup),
	rich_presence_lookup("Char",loadoutChar(0),CharLookup),
	rich_presence_lookup("Char",loadoutChar(1),CharLookup),
	rich_presence_lookup("Char",loadoutChar(2),CharLookup),
	rich_presence_lookup("Char",loadoutChar(3),CharLookup),
	rich_presence_lookup("CharFirst",loadoutChar(4),CharFirstLookup),
	rich_presence_lookup("Char",loadoutChar(5),CharLookup)
)

rich_presence_conditional_display(overlay() == OVERLAY_BATTLE, "Scenario {0}: {1} [{8}]{2}",
    rich_presence_value("Number", scenarioNumber()),
    rich_presence_lookup("Scenario", scenario(), ScenarioLookup),
	rich_presence_lookup("Playthrough",secondPlaythrough(),PlaythroughLookup),
	rich_presence_lookup("Char",loadoutChar(0),CharLookup),
	rich_presence_lookup("Char",loadoutChar(1),CharLookup),
	rich_presence_lookup("Char",loadoutChar(2),CharLookup),
	rich_presence_lookup("Char",loadoutChar(3),CharLookup),
	rich_presence_lookup("Char",loadoutChar(4),CharLookup),
	rich_presence_lookup("CharFirst",loadoutChar(5),CharFirstLookup)
)

rich_presence_conditional_display(overlay() == OVERLAY_TITLE, "Title Screen")
rich_presence_conditional_display(overlay() == OVERLAY_SCENARIO, "Scenario {0}: {1}{2}",
	rich_presence_value("Number", scenarioNumber()),
    rich_presence_lookup("Scenario", scenario(), ScenarioLookup),
	rich_presence_lookup("Playthrough",secondPlaythrough(),PlaythroughLookup)
)
rich_presence_conditional_display(overlay() == OVERLAY_CREDITS, "Viewing Credits{0}",
	rich_presence_lookup("Playthrough",secondPlaythrough(),PlaythroughLookup)
)
rich_presence_display("Loading...")

function ach(ach, t) {
    achievement(
        title = ach[0],
        points = ach[2],
        description = ach[1],
        trigger = ach[3],
        //id = ach[4],
        type=t
    )
}

achs_reg = [
["Deeper than It Looks","Complete Swamp of Reminiscence",3,achScenarioComplete(4)],
["Nature is Always Deadly","Complete The Earth Conceals Its Fangs",3,achScenarioComplete(5)],
["Echoes of the Dead","Complete Headstone of Lamentation",5,achScenarioComplete(16)],
["The Lurking Abyss","Complete Jungle of Lurking Spectres",5,achScenarioComplete(17)],

["Hidden Valuables","Obtain every treasure and hidden item in Escape",3,achAllTreasures(0)],
["Bountiful Catch","Obtain every treasure and hidden item in Hill of Crucifixion",3,achAllTreasures(1)],
["Trapped Loot","Obtain every treasure and hidden item in Determination",3,achAllTreasures(2)],
["Smuggled Goods","Obtain every treasure and hidden item in Shipwreck of the Cursed Sea",3,achAllTreasures(3)],
["Under the Water","Obtain every treasure and hidden item in Swamp of Reminiscence",3,achAllTreasures(4)],
["Concealed Wealth","Obtain every treasure and hidden item in The Earth Conceals Its Fangs",3,achAllTreasures(5)],
["Forbidden Truths","Obtain every treasure and hidden item in Stone Precipice Between Life and Death",3,achAllTreasures(6)],
["Spiraling Path","Obtain every treasure and hidden item in Abnormal Blood",3,achAllTreasures(7)],
["Return Reserve","Obtain every treasure and hidden item in Return",3,achAllTreasures(8)],
["Fated Findings","Obtain every treasure and hidden item in The Fateful Day",3,achAllTreasures(9)],
["Cursed Cache","Obtain every treasure and hidden item in The Curse of Ogaerito",3,achAllTreasures(10)],
["Small Prizes","Obtain every treasure and hidden item in The Small Assassins",3,achAllTreasures(11)],
["Perilous Plunder","Obtain every treasure and hidden item in The Bridge of Hope",3,achAllTreasures(13)],
["Riches In Ruin","Obtain every treasure and hidden item in The Ruined Land",3,achAllTreasures(14)],
["Treacherous Treasures","Obtain every treasure and hidden item in The Heretical Scholar",3,achAllTreasures(15)],
["Grave Digging for Gold","Obtain every treasure and hidden item in Headstone of Lamentation",3,achAllTreasures(16)],
["Treasure in the Trees","Obtain every treasure and hidden item in Jungle of Lurking Spectres",3,achAllTreasures(17)],
["Hallowed Soil","Obtain every treasure and hidden item in The Eternal Guardian",3,achAllTreasures(18)],
["Cult's Hoard","Obtain every treasure in The Cult of Death",3,achAllTreasures(19)],

["Sharp Shooter","Reach Level 20 as Keisuke",3,achLevelReached(CHARACTER_KEISUKE,20)],
["Slow Specialist","Reach Level 18 as Stacey",3,achLevelReached(CHARACTER_STACY,18)],
["Stunning Sacrifice","Reach Level 18 as Mizuki",3,achLevelReached(CHARACTER_MIZUKI,18)],
["Baharna's Warrior","Reach Level 20 as Takeru",3,achLevelReached(CHARACTER_TAKERU,20)],
["Skilled Doctor","Reach Level 18 as Howard",3,achLevelReached(CHARACTER_HOWARD,18)],
["Ranged Sorceress","Reach Level 18 as Kiriu",3,achLevelReached(CHARACTER_KIRIU,18)],
["Melee Man","Reach Level 20 as Crow",3,achLevelReached(CHARACTER_CROW,20)],
["Arms Dealer","Reach Level 20 as Reiji",3,achLevelReached(CHARACTER_REIJI,20)],

["Reiji's Raging Dragon","Find the hidden Shantak Cannon during a second playthrough in Escape",3,achGetTreasure(6,9,0)],
["Howard's Emperor Fist","Find the hidden Azathoth's Fist during a second playthrough in Escape",3,achGetTreasure(8,9,0)],
["Takeru's Slaying Steel","Find the hidden Shoggoth Steel during a second playthrough in Hill of Crucifixion",3,achGetTreasure(12,11,1)],
["Keisuke's Thunderous Firearm","Find the hidden Yithian Cylinder during a second playthrough in Determination",3,achGetTreasure(2,12,2)],
["Mizuki's Merfolk Claws","Find the hidden Merfolk Claws during a second playthrough in Stone Precipice Between Life and Death",3,achGetTreasure(7,6,5)],
["Stacy's Lightning Staff","Find the hidden Martense Staff during a second playthrough in Stone Precipice Between Life and Death",3,achGetTreasure(6,7,5)],
["Crow's Crescent Moon","Find the hidden Gibbous Blade during a second playthrough in Stone Precipice Between Life and Death",3,achGetTreasure(8,7,5)],
["Kiriu's Divine Fire","Find the hidden Fthaggua's Flame during a second playthrough in Stone Precipice Between Life and Death",3,achGetTreasure(7,8,5)],
]

achs_missable = [
["Malevolence Unleashed","Complete Girl Who Cries Death",5,achScenarioComplete(12)],
["Grandfather's Gift","Have Stacy find the Nostrum",10,achNostrumObtainedStacy()],
["Cure of the Mermaid","Cure Mizuki with the Nostrum",10,achMizukiCured()],
["Shining Bright","Obtain Odu's Bracelet in The Earth Conceals Its Fangs",5,achGetItem(ITEM_ODUS_BRACELET,5)],
["Memories of Eriko","Approach the grave first as Reiji in Headstone of Determination",5,achReijiGrave()],
["Atonement of Sins","Approach the hanged body first as Howard in Jungle of Lurking Spectres",5,achHowardShinra()],
["King of the Hill","Obtain every treasure in Girl Who Cries Death",3,achAllTreasures(12)],
]

achs_prog = [
["Escape with You","Complete Escape",3,achScenarioCompleteProg(0)],
["Crash Landing","Complete Hill of Crucifixion",3,achScenarioCompleteProg(1)],
["Give and Take","Complete Determination",3,achScenarioCompleteProg(2)],
["The Saint Ellie","Complete Shipwreck of the Cursed Sea",3,achScenarioCompleteProg(3)],
	
["Ancient Silence","Complete Stone Precipice Between Life and Death",3,achScenarioCompleteProg(6)],
["Hill of Rituals","Complete Abnormal Blood",3,achScenarioCompleteProg(7)],
["Where It Began","Complete Return",3,achScenarioCompleteProg(8)],
["Day of Destiny","Complete The Fateful Day",3,achScenarioCompleteProg(9)],
["Mermaid's Mark","Complete The Curse of Ogaerito",3,achScenarioCompleteProg(10)],
["An Evil Presence","Complete The Small Assassins",5,achScenarioCompleteProg(11)],
	
["Narrow Reprieve","Complete The Bridge of Hope",5,achScenarioCompleteProg(13)],
["Insidious Tensions","Complete The Ruined Land",5,achScenarioCompleteProg(14)],
["Tortured Souls","Complete The Heretical Scholar",5,achScenarioCompleteProg(15)],
	
["Consequences Beyond Imagination","Complete The Eternal Guardian",5,achScenarioCompleteProg(18)],
["End of Heresy","Complete The Cult of Death",5,achScenarioCompleteProg(19)],
["This Nightmare Is Over","Complete Elixir of Exorcism",5,achScenarioCompleteProg(20)],
]

achs_win = [
["Temple of God","Complete Devil Reef - R'lyieer",10,achFinalScenarioComplete()],
]

for a in achs_reg ach(a,"")
for a in achs_missable ach(a,"missable")
for a in achs_prog ach(a,"progression")
for a in achs_win ach(a,"win_condition")

/*
Complete Scenario 1
[Complete Scenario 1 without any deaths? low level?]
Complete Scenario 2
Complete Scenario 3
Complete Scenario 4
Complete Scenario 5 (Marsh)
Complete Scenario 5 (Earth)
Complete Scenario 6
Complete Scenario 7
Complete Scenario 8
Complete Scenario 9
Complete Scenario 10
Complete Scenario 11
Complete Scenario 12
Complete Scenario 13
Complete Scenario 14
Complete Scenario 15
Complete Scenario 16 (Jungle)
Complete Scenario 16 (Graveyard)
Complete Scenario 17
Complete Scenario 18
Complete Scenario 19
Complete Scenario 20
[Scenario 5 - Odu's Bracelet]
[Scenario 16 event - Jungle]
[Scenario 16 event - Graveyard]
[Good Ending]
Reach Level 20 as Keisuke (last skill)
Reach Level 18 as Stacey
Reach Level 18 as Mizuki
Reach Level 20 as Takeru
Reach Level 18 as Howard
Reach Level 18 as Kiriu 
Reach Level 20 as Crow
Reach Level 20 as Reiji
Find the hidden Shantak Cannon during a second playthrough in Scenario 1: Escape
Find the hidden Azathoth's Fist during a second playthrough in Scenario 1: Escape
Find the hidden Shoggoth Steel during a second playthrough in Scenario 2: Hill of Crucifixion
Find the hidden Yithian Cylinder during a second playthrough in Scenario 3: Determination
Find the hidden Merfolk Claws during a second playthrough in Scenario 6: Stone Precipice Between Life and Death
Find the hidden Martense Staff during a second playthrough in Scenario 6: Stone Precipice Between Life and Death
Find the hidden Gibbous Blade during a second playthrough in Scenario 6: Stone Precipice Between Life and Death
Find the hidden Fthaggua's Flame during a second playthrough in Scenario 6: Stone Precipice Between Life and Death
Open every treasure chest and find every hidden item in Scenario #: ----------






SCENARIO1 Escape
	Treasure Chest: Silver Ring
	(2nd) Dragon Cannon
	(2nd) Emperor's Fist
	
SCENARIO2 Hill of Crosses	Lv5
	Treasure Chest: Wooden Shield
	Treasure Chest: Explosives
	(2nd) God-killing Steel
	
SCENARIO3 Determination		Lv7
	Treasure Chest: Maiden's Feather Robe
	Treasure Chest: Good Luck Stone
	(2nd) Narukami no Tsutsumi
	
SCENARIO4 Shipwreck in the Cursed Sea [Reach Armory, or defeat all enemies]		Lv9
-ROUND 1
	Treasure Chest: Straight Sword
	Hidden: Bomb
-ROUND 2
	Hidden: divine drink of strength

Bomb			caeab 3 8 0
Sacred Incense	caefd 5 13 0
Mak Morn Ale	caeb0 8 8 0
Chokuto			cae54 12 2 0 (chest)
	
SCENARIO5 Memories of the Marshland		Lv11
	Treasure Chest: Relaxant
	Treasure Chest: Tortoise Shell Shield
	
SCENARIO5 The Earth that Hides Its Fangs	Lv11
	Hidden: Yasaka's Ball
	Hidden: Forget-me-not
	Odu's Bracelet (can only be collected by Stacey) "There is a glowing terrain in the middle of the game, and if you wait there with Stacey, a hidden event will occur.
Be careful, because if another character enters first, you won't be able to see it."

SCENARIO6 The cliff that separates life and death	Lv12
	Treasure Chest: Electric Baton
	Treasure Chest: Poison Fang Bow
	(2nd) Divine Fire Point
	(2nd) Mermaid Claw
	(2nd) Lightning Staff
	(2nd) Crescent Moon Divine Iron
	
SCENARIO7 Abnormal Blood	Lv13
-ROUND 1
	Treasure Chest: Tonic
	Treasure Chest: Battle Axe
-ROUND 2
	-

SCENARIO8 Return	Lv14
	Treasure Chest: Walther PPK
	Hidden: Philosopher's Stone of the Mind
	
SCENARIO9 Fateful Day	Lv15
	-

SCENARIO10 Mermaid's Brand	Lv16
	-
	
SCENARIO11 The Little Assassin	Lv17
	Treasure Chest: Fish Scale Shield
	Treasure Chest: Platinum Bracelet
	Hidden: Eye drops
	"Defeat at least one child ⇒ SCENARIO13, Don't kill the child, just defeat the cursed statue ⇒ SCENARIO 12"

SCENARIO12 ???	Lv18
-ROUND 2
	Treasure Chest: Hunting Clothes
	Treasure Chest: Philosopher's Stone
	Treasure Chest: Anklet
	Treasure Chest: Spiritual Liquor
	Treasure Chest: Steel Shield
	Treasure Chest: Miracle Medicine 
	
SCENARIO13 A Bridge of Hope		Lv20
	[TODO: reinforcements?]
	Treasure Chest: Fish Scale Battle Armor
	Hidden: Moonlight Axe

SCENARIO14 Land of Destruction	Lv22
	Treasure Chest: Bee Gift
	Treasure Chest: Mahorobo Bow
	Treasure Chest: Scared Wine of Stamina
	Treasure Chest: Panacea
	Hidden: Fish Phosophorus Armor
	Hidden: Poison Trout
	Hidden: Wound Medicine

SCENARIO15 The Heretical Scholar	Lv23
	Treasure Chest: Desert Eagle
	Treasure Chest: Air Tizer
	
	
SCENARIO16 "The jungle where ghosts lurk"	Lv25
	Treasure Chest: Incense
	Treasure Chest: Panacea
	Treasure Chest: Getsuga Iron Fist
	Hidden: Tonic Medicine
	Hidden: Wild Spirit Bracelet
	[TODO: Howard Event]
	

SCENARIO16 "Gravestone of Lamentation"	Lv25
	Treasure Chest: Philosopher's Stone
	Treasure Chest: SPP
	[TODO: Reiji Event]

SCENARIO17 The eternal guardian		Lv28 (?)
	Treasure Chest: Shippo Axe
	Treasure Chest: Eight-Handed Sword 
	Hidden: Sacred Sake of Skill

SCENARIO18 The End of the Cult
	Treasure Chest: Philosopher's Stone
	Treasure Chest: Death Return Jewel
-ROUND 2
	"After defeating the Hydra, there are three possible scenarios, each of which differs slightly."
	"Reiji	SCENARIO16: Reiji's event has already occurred at the Gravestone of Sorrow
	Howard	SCENARIO16: Howard's event has already occurred in the jungle where ghosts lurk .
	Takeru	If you do not meet the above two conditions"

SCENARIO19 Elixir of Curse
	"If the conditions are not met, Stacey will be forced to die."
		At the branch of SCENARIO5, select the monolith SCENARIO5 Earth hiding the fangs
		In SCENARIO 5, have Stacey wait on a glowing square in the stage and discover Odu's Bracelet.
		Before the start of SCENARIO19, equip Stacey with Odu's bracelet.
	"Either way, you will need to find the "elixir" from the treasure chest at the back, but if Stacey survives, she will automatically find the elixir. However, if Stacey dies, Keisuke will have to open the treasure chest himself to find it.
Only the main character can unlock the treasure chest."
	
	
SCENARIO20 The Devil's Reef, Le Lier
	"The ending will differ slightly depending on how you have played so far."
		Stacey survives and gives the elixir to Mitsuki
		Stacey dies and gives the elixir to Mitsuki
		Regardless of Stacey, defeat Mitsuki without giving her the elixir.
	"If you defeat her without giving the elixir to Mitsuki, the ending will be the same, although there will be some changes depending on whether Stacey survives or not."
*/