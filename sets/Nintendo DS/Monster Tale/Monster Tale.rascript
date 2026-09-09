// Monster Tale
// #ID = 5708

// --------------------------------------------------------
// MARK: HELPERS
// 
// --------------------------------------------------------
function ptr(x) => tbyte(x)
function has_increased(addr) => addr > prev(addr)
function has_decreased(addr) => addr < prev(addr)
function has_changed(addr) => addr != prev(addr)
function hasnt_changed(addr) => addr == prev(addr)
function if_else(p, t, f) { if (p) { return t } else return f }
function is_even(v) => v % 2 == 0

// EVENT FLAGS
UPGRADE_BAND_BLASTER = 0 // 0x00120cf4
EVENT_ENCOUNTER_CHOMP = 1 // 0x00120CF8
EVENT_CHOMP_FOLLOW = 2 // 0x00120CFC
EVENT_CHOMP_INTERACT_TUTORIAL = 3 // 0x00120D00
EVENT_CHOMP_FOOD_TUTORIAL = 4 // 0x00120D04
EVENT_SAVE_TUTORIAL = 5 // 0x00120D08
EVENT_MAP_TUTORIAL = 6 // 0x00120D0C
EVENT_CHOMP_LEVELUP_TUTORIAL = 7 // 0x00120D10
EVENT_8 = 8 // 0x00120D14
EVENT_9 = 9 // 0x00120D18
EVENT_10 = 10 // 0x00120D1C
EVENT_CHOMP_SKILL_TUTORIAL = 11 // 0x00120D20 
EVENT_CHOMP_LEARNS_SKILL = 12 // 0x00120D24 // Purple Dragon Defeated
EVENT_CHOMP_TORNADO_TUTORIAL = 13 // 0x00120D28
EVENT_CHOMP_TRAIT_TUTORIAL = 14 // 0x00120D2C
EVENT_15 = 15 // 0x00120D30 //right before trait tutorial
CHOMP_VERTICAL_SPIKE_EQUIPPED = 16 // 0x00120D34
CHOMP_SKILL_VERTICAL_SPIKE = 17 // 0x00120D38
CHOMP_VERTICAL_SPIKE_TUTORIAL = 18 // 0x00120D3C
UPGRADE_MELEE_STRIKE = 19 // 0x00120D40
EVENT_20 = 20 // 0x00120D44
EVENT_TUTORIAL_ELEMENT = 21 // 0x00120D48
EVENT_PRISCILLA_CUTSCENE_CAVERN_ENTER = 22 // 0x00120D4C
UPGRADE_SUPER_BAND_BLASTER = 23 // 0x00120D50
UPGRADE_ROLL_ABILITY = 24 // 0x00120D54
EVENT_MET_JINX = 25 // 0x00120D58
UPGRADE_MELEE_STRING = 26 // 0x00120D5C // Melee String?
EVENT_PRISCILLA_CUTSCENE_CAVERN12_MIDWAY = 27 // 0x00120D60
EVENT_28 = 28 // 0x00120D64 // after tall door near jinx
EVENT_29 = 29 // 0x00120D68
UPGRADE_LAUNCHER_ATTACK = 30 // 0x00120D6C
EVENT_31 = 31 // 0x00120D70 // priscilla encounter cavern
EVENT_32 = 32 // 0x00120D74
EVENT_33 = 33 // 0x00120D78
EVENT_34 = 34 // 0x00120D7C
EVENT_35 = 35 // 0x00120D80
MEADE_DEFEATED = 36 // 0x00120D84
MEADE_KEY_USED = 37 // 0x00120D88
EVENT_38 = 38 // 0x00120D8C
EVENT_39 = 39 // 0x00120D90
EVENT_40 = 40 // 0x00120D94
EVENT_41 = 41 // 0x00120D98
BEACH_LEVER = 42 // 0x00120D9C
BEACH_LEVER_DOOR = 43 // 0x00120DA0
BEACH_BLUE_LEVER_1 = 44 // 0x00120DA4
BEACH_BLUE_LEVER_DOOR_1 = 45 // 0x00120DA8
BEACH_BLUE_LEVER_2 = 46 // 0x00120DAC
BEACH_BLUE_LEVER_DOOR_2 = 47 // 0x00120DB0
BEACH_BLUE_LEVER_3 = 48 // 0x00120DB4
BEACH_BLUE_LEVER_DOOR_3 = 49 // 0x00120DB8
UPGRADE_BURST_CANCEL = 50 // 0x00120DBC
UPGRADE_SUPER_WAVE = 51 // 0x00120DC0
EVENT_PRISCILLA_CUTSCENE_CAVERN_MEADE = 52 // 0x00120DC4
UPGRADE_WALL_JUMP = 53 // 0x00120DC8
EVENT_DEANU_CUTSCENE_BEACH = 54 // 0x00120DCC
UPGRADE_DOWN_SMASH = 55 // 0x00120DD0
EVENT_56 = 56 // 0x00120DD4
EVENT_57 = 57 // 0x00120DD8
DEANU_DEFEATED = 58 // 0x00120DDC // water key obtained?
EVENT_59 = 59 // 0x00120DE0
EVENT_60 = 60 // 0x00120DE4
EVENT_61 = 61 // 0x00120DE8
EVENT_62 = 62 // 0x00120DEC
EVENT_PRISCILLA_CUTSCENE_ZOETOPIA = 63 // 0x00120DF0
UPGRADE_DASH = 64 // 0x00120DF4
ZOETOPIA_MEADUE_HELPS = 65 // 0x00120DF8
UPGRADE_AIR_SUPER_WAVE = 66 // 0x00120DFC
EVENT_67 = 67 // 0x00120E00
EVENT_68 = 68 // 0x00120E04
EVENT_69 = 69 // 0x00120E08
EVENT_70 = 70 // 0x00120E0C
EVENT_71 = 71 // 0x00120E10
EVENT_72 = 72 // 0x00120E14
ZOE_DEFEATED = 73 // 0x00120E18
EVENT_74 = 74 // 0x00120E1C
BUNNY_KEY_USED = 75 // 0x00120E20
EVENT_76 = 76 // 0x00120E24
EVENT_77 = 77 // 0x00120E28
UPGRADE_CHARGE_SHOT = 78 // 0x00120E2C
UPGRADE_MIGHTY_LUNGS = 79 // 0x00120E30
UPGRADE_AIR_BURST_CANCEL = 80 // 0x00120E34
PURCHASED_AVALANCHE_CLEARED = 81 // 0x00120E38
CUTSCENE_AVALANCHE_CLEARED = 82 // 0x00120E3C
EVENT_83 = 83 // 0x00120E40
EVENT_84 = 84 // 0x00120E44
NATHAN_DEFEATED = 85 // 0x00120E48
EVENT_86 = 86 // 0x00120E4C
ROBOT_KEY_USED = 87 // 0x00120E50
EVENT_PRISCILLA_CUTSCENE_LEAVING_SNOW = 88 // 0x00120E54
EVENT_89 = 89 // 0x00120E58
EVENT_90 = 90 // 0x00120E5C
EVENT_91 = 91 // 0x00120E60
EVENT_92 = 92 // 0x00120E64
EVENT_93 = 93 // 0x00120E68
PRISSINGHAM_DOOR_EXAMINED = 94 // 0x00120E6C
EVENT_95 = 95 // 0x00120E70
EVENT_96 = 96 // 0x00120E74
EVENT_97 = 97 // 0x00120E78
EVENT_98 = 98 // 0x00120E7C
UPGRADE_ULTIMATE_CHARGE_SHOT = 99 // 0x00120E80
EVENT_100 = 100 // 0x00120E84
EVENT_101 = 101 // 0x00120E88
EVENT_102 = 102 // 0x00120E8C
EVENT_103 = 103 // 0x00120E90
EVENT_104 = 104 // 0x00120E94
EVENT_105 = 105 // 0x00120E98
EVENT_106 = 106 // 0x00120E9C
EVENT_107 = 107 // 0x00120EA0
EVENT_108 = 108 // 0x00120EA4
PRISCILLA_DEFEATED = 109 // 0x00120EA8
SHOP_HEALTH_EXTENSION_I = 110 // 0x00120EAC //shop - health extension I?
SHOP_HEALTH_EXTENSION_II = 111 // 0x00120EB0 //shop - health extension II?
SHOP_HEALTH_EXTENSION_III = 112 // 0x00120EB4 //shop - health extension III?
SHOP_MELEE_DAMAGE_I = 113 // 0x00120EB8 //shop - melee damage I?
SHOP_MELEE_DAMAGE_II = 114 // 0x00120EBC //shop - melee damage II?
SHOP_MELEE_DAMAGE_III = 115 // 0x00120EC0 //shop - melee damage III?
SHOP_SPECIAL_DAMAGE_I = 116 // 0x00120EC4
SHOP_SPECIAL_DAMAGE_II = 117 // 0x00120EC8
SHOP_SPECIAL_DAMAGE_III = 118 // 0x00120ECC
SHOP_BLASTER_DAMAGE_I = 119 // 0x00120ED0 //shop - blaster damage I?
SHOP_BLASTER_DAMAGE_II = 120 // 0x00120ED4 //shop - blaster damage II?
SHOP_BLASTER_DAMAGE_III = 121 // 0x00120ED8 //shop - blaster damage III?
SHOP_BLASTER_EFFICIENCY_I = 122 // 0x00120EDC //shop - blaster efficiency I?
SHOP_BLASTER_EFFICIENCY_II = 123 // 0x00120EE0 //shop - blaster efficiency II?
SHOP_BLASTER_EFFICIENCY_III = 124 // 0x00120EE4 //shop - blaster efficiency III?
SHOP_ENERGY_GAIN_I = 125 // 0x00120EE8 //shop - energy gain I?
SHOP_ENERGY_GAIN_II = 126 // 0x00120EEC //shop - energy gain II?
SHOP_ENERGY_GAIN_III = 127 // 0x00120EF0 //shop - energy gain III?
SHOP_TREASURE_HUNTING_I = 128 // 0x00120EF4 //shop - treasure hunting I?
SHOP_TREASURE_HUNTING_II = 129 // 0x00120EF8 //shop - treasure hunting II?
SHOP_TREASURE_HUNTING_III = 130 // 0x00120EFC //shop - treasure hunting III?
EVENT_131 = 131 // 0x00120F00
HEART_DUNGEON = 132 // 0x00120F04 //Dungeon Heart?
HEART_ZOETOPIA = 133 // 0x00120F08
HEART_DEMONSHUTTLE = 134 // 0x00120F0C
TRAIT_SLOT_RUINS = 135 // 0x00120F10
TRAIT_SLOT_BEACH = 136 // 0x00120F14
TRAIT_SLOT_PLAINS = 137 // 0x00120F18
TRAIT_SLOT_SNOW = 138 // 0x00120F1C
EVENT_139 = 139 // 0x00120F20
EVENT_140 = 140 // 0x00120F24
EVENT_141 = 141 // 0x00120F28
EVENT_142 = 142 // 0x00120F2C
EVENT_143 = 143 // 0x00120F30
EVENT_144 = 144 // 0x00120F34
EVENT_145 = 145 // 0x00120F38
EVENT_146 = 146 // 0x00120F3C
EVENT_147 = 147 // 0x00120F40
EVENT_148 = 148 // 0x00120F44
EVENT_149 = 149 // 0x00120F48
EVENT_150 = 150 // 0x00120F4C
EVENT_151 = 151 // 0x00120F50
EVENT_152 = 152 // 0x00120F54
EVENT_153 = 153 // 0x00120F58
EVENT_154 = 154 // 0x00120F5C
EVENT_155 = 155 // 0x00120F60
EVENT_156 = 156 // 0x00120F64
EVENT_157 = 157 // 0x00120F68
EVENT_158 = 158 // 0x00120F6C
EVENT_159 = 159 // 0x00120F70
EVENT_160 = 160 // 0x00120F74
EVENT_161 = 161 // 0x00120F78
EVENT_162 = 162 // 0x00120F7C
EVENT_163 = 163 // 0x00120F80
EVENT_164 = 164 // 0x00120F84
EVENT_165 = 165 // 0x00120F88
EVENT_166 = 166 // 0x00120F8C
EVENT_167 = 167 // 0x00120F90
EVENT_168 = 168 // 0x00120F94
EVENT_169 = 169 // 0x00120F98
EVENT_170 = 170 // 0x00120F9C
EVENT_171 = 171 // 0x00120FA0
EVENT_172 = 172 // 0x00120FA4
EVENT_173 = 173 // 0x00120FA8
EVENT_174 = 174 // 0x00120FAC
EVENT_175 = 175 // 0x00120FB0
EVENT_176 = 176 // 0x00120FB4
EVENT_177 = 177 // 0x00120FB8
EVENT_178 = 178 // 0x00120FBC
EVENT_179 = 179 // 0x00120FC0
EVENT_180 = 180 // 0x00120FC4
EVENT_181 = 181 // 0x00120FC8

MAP_ANCIENTRUINS = 0
MAP_ANCIENTRUINS2 = 1
MAP_ANCIENTRUINS3 = 2
MAP_CAVERNS = 3
MAP_DUNGEON = 4
MAP_THESCRATCHPIT = 5
MAP_SCRATCHPITARENA = 6
MAP_BEACH = 7
MAP_AQUEDUCTS = 8
MAP_TUBEWORQS = 9
MAP_THEAQUARIUM = 10
MAP_WINDLEMILLPLAINS = 11
MAP_AUTUMNTHICKET = 12
MAP_TREEHOUSEGROTTO = 13
MAP_SPOOKHOUSELOOKOUT = 14
MAP_FRIGIDCLIFFS = 15
MAP_DEMONSHUTTLE = 16
MAP_FACTORYFORTRESS = 17
MAP_GEARGARAGE = 18
MAP_PRIMHEDGE = 19

FORM_SENTINEL = 0
FORM_SEEKER = 1
FORM_CYCLOPS = 2
FORM_WARLOCK = 3
FORM_BRUISER = 4
FORM_JUGGERNAUT = 5
FORM_GILGAMESH = 6
FORM_TALLBAIN = 7
FORM_REBEL = 8
FORM_SASQUATCH = 9
FORM_FOUNDLING = 10
FORM_ACROBAT = 11
FORM_STALWART = 12
FORM_REPELLER = 13
FORM_SCOURGE = 14
FORM_PIXIE = 15
FORM_RAVENOUS = 16
FORM_HURLER = 17
FORM_WINGEDAVENGER = 18
FORM_ZIPPY = 19
FORM_BALLISTA = 20
FORM_SPITTER = 21
FORM_PALADIN = 22
FORM_WRECKER = 23
FORM_GLIDER = 24
FORM_MIMIC = 25
FORM_PETDOZER = 26
FORM_ICARUS = 27
FORM_PRICKETT = 28
FORM_ELITEGUARD = 29

GROUP_SHOP = [
    SHOP_HEALTH_EXTENSION_I,
    SHOP_HEALTH_EXTENSION_II,
    SHOP_HEALTH_EXTENSION_III,
    SHOP_MELEE_DAMAGE_I,
    SHOP_MELEE_DAMAGE_II,
    SHOP_MELEE_DAMAGE_III,
    SHOP_SPECIAL_DAMAGE_I,
    SHOP_SPECIAL_DAMAGE_II,
    SHOP_SPECIAL_DAMAGE_III,
    SHOP_BLASTER_DAMAGE_I,
    SHOP_BLASTER_DAMAGE_II,
    SHOP_BLASTER_DAMAGE_III,
    SHOP_BLASTER_EFFICIENCY_I,
    SHOP_BLASTER_EFFICIENCY_II,
    SHOP_BLASTER_EFFICIENCY_III,
    SHOP_ENERGY_GAIN_I,
    SHOP_ENERGY_GAIN_II,
    SHOP_ENERGY_GAIN_III,
    SHOP_TREASURE_HUNTING_I,
    SHOP_TREASURE_HUNTING_II,
    SHOP_TREASURE_HUNTING_III
]

ingame_ptr_addr = 0x00066968
ingame_ptr = ptr(ingame_ptr_addr)

function onTitle() => ptr(ingame_ptr_addr) != 0 && dword(ingame_ptr + 0x00) == 0
function inGame() => ptr(ingame_ptr_addr) != 0 && dword(ingame_ptr + 0x00) == 1 && hasnt_changed(dword(ingame_ptr + 0x00)) && ptr(player_ptr + 0x10) != 0

player_ptr_addr = 0x00053dd0
player_ptr = ptr(player_ptr_addr)
player_status_ptr = ptr(ptr(player_ptr + 0x10) + 0x38)

function playerHP() => word(player_status_ptr + 0xf2)
function currentMoney() => dword(player_status_ptr + 0xfc)

function currentChompForm() => byte(savedata_ptr + 0x1534)
function currentChompLevel() => chompFormLevel(currentChompForm())

function chompFormLevel(id) => byte(savedata_ptr + 0x1562 + (0x54 * id))
function chompFormEXP(id) => dword(savedata_ptr + 0x1564 + (0x54 * id))
function chompFormUnlockProgress(id) => byte(savedata_ptr + 0x1593 + (0x54 * id))

function total_playtime() => dword(ptr(0x000b38cc) + 0x08)

function currentState() => dword(ptr(ptr(0x00079e94)) + 0x0c)
STATE_INGAME = 0x0a

combo_ptr_addr = 0x00052be0

function currentComboTimer() => dword(ptr(ptr(ptr(ptr(combo_ptr_addr) + 0) + 8) + 8) + 0x10)
function currentComboCount() => dword(ptr(ptr(ptr(ptr(combo_ptr_addr) + 0) + 8) + 8) + 0x240)
function comboPtrCheck() => ptr(ptr(combo_ptr_addr) + 0) != 0 &&
                            ptr(ptr(ptr(combo_ptr_addr) + 0) + 8) != 0 &&
                            ptr(ptr(ptr(ptr(combo_ptr_addr) + 0) + 8) + 8) != 0

MAX_COMBO = 99

function achComboReached(target) => inGame() && 
                                    comboPtrCheck() &&
                                    currentComboCount() >= target &&
                                    has_increased(currentComboCount()) &&
                                    currentComboCount() <= MAX_COMBO &&
                                    currentComboTimer() <= 0x3c
                             

cheat_ptr_addr = 0x00079e94

function cheatPtrCheck() => ptr(cheat_ptr_addr) + 0 != 0 &&
                            ptr(ptr(cheat_ptr_addr) + 0) + 8 != 0 &&
                            ptr(ptr(ptr(cheat_ptr_addr) + 0) + 8) + 0 != 0 &&
                            hasnt_changed(ptr(cheat_ptr_addr) + 0) &&
                            hasnt_changed(ptr(ptr(cheat_ptr_addr) + 0) + 8) &&
                            hasnt_changed(ptr(ptr(ptr(cheat_ptr_addr) + 0) + 8) + 0)

function cheatActive() => dword(ptr(ptr(ptr(ptr(cheat_ptr_addr) + 0) + 8) + 0) + 0x0c)
function cheatCanInput() => dword(ptr(ptr(ptr(ptr(cheat_ptr_addr) + 0) + 8) + 0) + 0x08)

function achCheatActivated() => onTitle() && cheatPtrCheck() && has_increased(cheatActive())

savedata_ptr_addr = 0x0001c5a4
savedata_ptr = ptr(ptr(savedata_ptr_addr) + 0)
function currentAreaScreenX() => dword(savedata_ptr + 0x40)
function currentAreaScreenY() => dword(savedata_ptr + 0x44)
function currentArea() => dword(savedata_ptr + 0x320)
eventflags_start_addr = savedata_ptr + 0x48

WORLD_TILES_TO_CHECK = [
    [199, 200, 232, 233, 234, 235, 236, 237, 269, 301, 302, 303, 304, 305, 306, 307, 330, 331, 332, 333, 339, 344, 345, 346, 357, 358, 359, 360, 361, 362, 363, 364, 365, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 399, 431, 432, 433, 434, 435, 436, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469, 498, 499, 531, 532, 533, 560, 561, 562, 563, 564, 565, 593, 594, 595, 625, 626],
    [135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 164, 165, 166, 167, 168, 169, 171, 172, 173, 174, 175, 176, 177, 199, 200, 201, 202, 203, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 231, 232, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 292, 293, 294, 295, 296, 302, 303, 304, 305, 306, 310, 328, 331, 332, 333, 336, 337, 338, 339, 340, 341, 342, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 395, 396, 397, 398, 399, 400, 401, 402, 436, 437, 438, 439, 467, 468, 469, 470, 471, 472],
    [178, 179, 180, 181, 182, 201, 202, 203, 204, 213, 214, 215, 216, 217, 218, 232, 233, 236, 237, 238, 239, 240, 241, 242, 243, 265, 266, 267, 268, 269, 270, 271, 272, 273, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 388, 389, 390, 398, 399, 400, 402, 403, 404, 405, 406, 421, 422, 423, 424, 425, 426, 427, 430, 431, 432, 433, 434, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 486, 487, 488, 489, 490, 494, 495, 496],
    [196, 197, 198, 199, 200, 201, 202, 203, 204, 231, 232, 233, 234, 235, 285, 296, 297, 298, 305, 306, 307, 314, 315, 316, 317, 324, 325, 326, 327, 328, 329, 336, 337, 338, 341, 342, 343, 344, 346, 347, 357, 358, 359, 360, 361, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 390, 391, 392, 393, 394, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 440, 441, 442, 443, 444, 454, 455, 456, 457, 464, 465, 466, 467, 468, 486, 487, 488, 489, 490, 496, 497, 526, 527, 528, 529, 560, 561, 562, 563, 588, 589, 590, 591, 592, 593, 594],
    [361, 362, 363, 364, 365, 366, 367, 368, 370, 371, 372, 373, 374, 375, 376, 377, 378, 393, 394, 395, 396, 397, 398, 399, 400, 403, 404, 405, 406, 407, 408, 409, 410, 425, 426, 427, 428, 429, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 519, 520, 521, 522, 523, 524, 525, 526, 527, 616, 617, 618, 619, 649, 650, 651, 652, 653, 654, 655],
    [201, 202, 203, 204, 235, 236, 268, 269, 270, 271, 272, 273, 274, 276, 277, 278, 279, 280, 299, 303, 304, 305, 306, 307, 308, 309, 331, 332, 336, 359, 360, 361, 363, 364, 365, 366, 368, 369, 370, 371, 392, 393, 394, 395, 396, 397, 398, 399, 400, 429, 430, 431, 432, 433, 434, 460, 461, 465, 466, 467, 468, 469, 493, 494, 495, 496, 497, 498]
]

maptiles_start_addr = savedata_ptr + 0x324
function maptileseen(world,index) => byte(maptiles_start_addr + (world * 0x300) + index)
function sumworldmaptiles(world) => sum_of(WORLD_TILES_TO_CHECK[world], i => maptileseen(world,i))
function sumworldmaptilesTest(world) => sum_of(range(0,767), i => maptileseen(world,i))

function achWorldTilesMeasuredTest(world) => measured(
    sumworldmaptiles(world) == 767
)

function achWorldTilesAllDiscovered(world) => inGame() &&
                                         savePtrCheck() &&
                                         sumworldmaptiles(world) == length(WORLD_TILES_TO_CHECK[world]) &&
                                         prev(sumworldmaptiles(world)) == (length(WORLD_TILES_TO_CHECK[world]) - 1)


function savePtrCheck() => ptr(savedata_ptr_addr) + 0 != 0

function eventFlag(i) => dword(eventflags_start_addr + (i * 4))
function sumEventFlagGroup(g) => sum_of(g, i => eventFlag(i))

function skillStatus(i) => savedata_ptr + 0x1f34 + i
function skillLearned(i) => (byte(skillStatus(i)) / byte(skillStatus(i)))
function skillMastered(i) => bit(1,skillStatus(i))

function sumSkillsLearned() => sum_of(range(0,30), f => skillLearned(f))
function sumSkillsMastered() => sum_of(range(0,30), f => skillMastered(f))


function achAllSkillsLearned() => inGame() && savePtrCheck() && sumSkillsLearned() == 31 && prev(sumSkillsLearned()) == 30
function achAllSkillsMastered() => inGame() && savePtrCheck() && sumSkillsMastered() == 31 && prev(sumSkillsMastered()) == 30


function achEventFlag(i) => inGame() &&
                            savePtrCheck() &&
                            prev(eventFlag(i)) == 0 &&
                            eventFlag(i) == 1

function achEventFlagGroupSum(g) => inGame() &&
                            savePtrCheck() &&
                            prev(sumEventFlagGroup(g)) == length(g) - 1 &&
                            sumEventFlagGroup(g) == length(g)

function achEventFlagGroupMeasuredSum(g) => prev(sumEventFlagGroup(g)) == length(g) - 1 &&
                            measured(sumEventFlagGroup(g) == length(g), when=inGame() && savePtrCheck())

function achUnlockChompForm(id) => inGame() && savePtrCheck() && chompFormUnlockProgress(id) == 100 && prev(chompFormUnlockProgress(id)) < 100

function achFinalBossFormOnly(form) => never(!inGame()) && 
                                       never(!savePtrCheck()) && 
                                       prev(eventFlag(PRISCILLA_DEFEATED)) == 0 && 
                                       trigger_when(eventFlag(PRISCILLA_DEFEATED) == 1) &&
                                       never(currentArea() != MAP_PRIMHEDGE) &&
                                       never(currentAreaScreenX() != 8) &&
                                       never(currentAreaScreenY() != 10) &&
                                       // Don't reset if in menu - doesn't really matter but prefer not failing while switching in menu
                                       never(currentState() == STATE_INGAME && currentChompForm() != form) &&
                                       // Checkpoint hit when entering boss map - could use currentState but don't like that 0x0b is shared between item get and boss intro
                                       once(
                                           currentArea() == MAP_PRIMHEDGE &&
                                           prev(currentAreaScreenX()) == 9 && 
                                           currentAreaScreenX() == 8
                                       )

// [Map] Chomp: [Form] Lv [Level] [Money]

AreaLookup = {
    MAP_ANCIENTRUINS: "Ancient Ruins",
    MAP_ANCIENTRUINS2: "Ancient Ruins",
    MAP_ANCIENTRUINS3: "Ancient Ruins",
    MAP_CAVERNS: "Caverns",
    MAP_DUNGEON: "Dungeon",
    MAP_THESCRATCHPIT: "The Scratch Pit",
    MAP_SCRATCHPITARENA: "Scratch Pit Arena",
    MAP_BEACH: "Beach",
    MAP_AQUEDUCTS: "Aqueducts",
    MAP_TUBEWORQS: "Tubeworqs",
    MAP_THEAQUARIUM: "The Aquarium",
    MAP_WINDLEMILLPLAINS: "Windlemill Plains",
    MAP_AUTUMNTHICKET: "Autumn Thicket",
    MAP_TREEHOUSEGROTTO: "Treehouse Grotto",
    MAP_SPOOKHOUSELOOKOUT: "Spookhouse Lookout",
    MAP_FRIGIDCLIFFS: "Frigid Cliffs",
    MAP_DEMONSHUTTLE: "Demon Shuttle",
    MAP_FACTORYFORTRESS: "Factory Fortress",
    MAP_GEARGARAGE: "Gear Garage",
    MAP_PRIMHEDGE: "Primhedge Palace"
}

ChompFormLookup = {
    FORM_SENTINEL: "🔥Sentinel",
    FORM_SEEKER: "💧Seeker",
    FORM_CYCLOPS: "🔥Cyclops",
    FORM_WARLOCK: "🍂Warlock",
    FORM_BRUISER: "🔥Bruiser",
    FORM_JUGGERNAUT: "🍂Juggernaut",
    FORM_GILGAMESH: "🍂Gilgamesh",
    FORM_TALLBAIN: "🍂Tall Bain",
    FORM_REBEL: "💧Rebel",
    FORM_SASQUATCH: "✨Sasquatch",
    FORM_FOUNDLING: "🔥Foundling",
    FORM_ACROBAT: "🔥Acrobat",
    FORM_STALWART: "💧Stalwart",
    FORM_REPELLER: "🔥Repeller",
    FORM_SCOURGE: "🔥Scourge",
    FORM_PIXIE: "💧Pixie",
    FORM_RAVENOUS: "🍂Ravenous",
    FORM_HURLER: "🍂Hurler",
    FORM_WINGEDAVENGER: "🔥Winged Avenger",
    FORM_ZIPPY: "✨Zippy",
    FORM_BALLISTA: "🔥Ballista",
    FORM_SPITTER: "💧Spitter",
    FORM_PALADIN: "🔥Paladin",
    FORM_WRECKER: "🔥Wrecker",
    FORM_GLIDER: "🍂Glider",
    FORM_MIMIC: "🍂Mimic",
    FORM_PETDOZER: "💧Petdozer",
    FORM_ICARUS: "🔥Icarus",
    FORM_PRICKETT: "💧Prickett",
    FORM_ELITEGUARD: "🌙Elite Guard",
}

rich_presence_conditional_display(onTitle(),"Title Screen") 

rich_presence_conditional_display(inGame() && eventFlag(EVENT_CHOMP_FOLLOW) == 1,"🗺️{0} {2} Lv {3} 💰{1}",
    rich_presence_lookup("Map", currentArea(), AreaLookup),
    rich_presence_value("Number", currentMoney()),
    rich_presence_lookup("Chomp", currentChompForm(), ChompFormLookup),
    rich_presence_value("Number", currentChompLevel())
)


rich_presence_conditional_display(inGame(),"🗺️{0} 💰{1}",
    rich_presence_lookup("Map", currentArea(), AreaLookup),
    rich_presence_value("Number", currentMoney()),
    rich_presence_lookup("Chomp", currentChompForm(), ChompFormLookup),
    rich_presence_value("Number", currentChompLevel())
)

rich_presence_display("Loading...")



function ach(ach, t) {
    achievement(
        title = ach[0],
        points = ach[2],
        description = ach[1],
        trigger = ach[3],
        type=t
    )
}

achs_reg = [
// --- UPGRADES ---
    ["Super Bracelet","Obtain the Band Blaster upgrade",1,achEventFlag(UPGRADE_BAND_BLASTER)],
    ["Striking Blows","Obtain the Melee Strike upgrade",3,achEventFlag(UPGRADE_MELEE_STRIKE)],
    ["It's a Long Shot","Obtain the Super Band Blaster upgrade",5,achEventFlag(UPGRADE_SUPER_BAND_BLASTER)],
    ["Armadillo Ball","Obtain the Roll upgrade",5,achEventFlag(UPGRADE_ROLL_ABILITY)],
    ["Hand-to-Hand Combat","Obtain the Melee String upgrade",5,achEventFlag(UPGRADE_MELEE_STRING)],
    ["Blow to the Air","Obtain the Launcher Attack upgrade",5,achEventFlag(UPGRADE_LAUNCHER_ATTACK)],
    ["Capcom Rages","Obtain the Wall Jump upgrade",5,achEventFlag(UPGRADE_WALL_JUMP)],
    ["Plasma Cannon","Obtain the Burst Cancel upgrade",5,achEventFlag(UPGRADE_BURST_CANCEL)],
    ["1.5 Seconds","Obtain the Super Wave upgrade",5,achEventFlag(UPGRADE_SUPER_WAVE)],
    ["Back Down","Obtain the Down Smash upgrade",5,achEventFlag(UPGRADE_DOWN_SMASH)],
    ["Did You Get the Reference?","Obtain the Dash upgrade",5,achEventFlag(UPGRADE_DASH)],
    ["You Didn't See It Coming","Obtain the Air Super Wave upgrade",5,achEventFlag(UPGRADE_AIR_SUPER_WAVE)],
    ["Eye Shots","Obtain the Charge Shot upgrade",5,achEventFlag(UPGRADE_CHARGE_SHOT)],
    ["Smoke-Free","Obtain the Mighty Lungs upgrade",5,achEventFlag(UPGRADE_MIGHTY_LUNGS)],
    ["When Your Efforts Are Worthwhile","Obtain the Air Burst Cancel upgrade",5,achEventFlag(UPGRADE_AIR_BURST_CANCEL)],
    ["This Is an X-Buster, Yes!","Obtain the Ultimate Charge Shot upgrade",5,achEventFlag(UPGRADE_ULTIMATE_CHARGE_SHOT)],

// --- EXTRA HEARTS ---
    ["Temple Heart","Collect the extra heart in the Dungeons",10,achEventFlag(HEART_DUNGEON)],
    ["Lost Swamp Heart","Collect the extra heart in Autumn Thicket",10,achEventFlag(HEART_ZOETOPIA)],
    ["Cold Heart","Collect the extra heart in Demon Shuttle",10,achEventFlag(HEART_DEMONSHUTTLE)],
    ["Love Collector","Collect every extra heart",25,achEventFlagGroupSum([HEART_DUNGEON, HEART_ZOETOPIA, HEART_DEMONSHUTTLE])],

// --- TRAITS ---
    ["Lost Beach Collectible","Collect the trait slot on the Beach",10,achEventFlag(TRAIT_SLOT_BEACH)],
    ["Did You Defeat the Giant Crabs for That?","Collect the trait slot in Windlemill Plains",10,achEventFlag(TRAIT_SLOT_PLAINS)],
    ["Chomp's Guarded Treasure","Collect the trait slot in Ancient Ruins",10,achEventFlag(TRAIT_SLOT_RUINS)],
    ["Sliding Under the Thorns","Collect the trait slot in Frigid Cliffs",10,achEventFlag(TRAIT_SLOT_SNOW)],
    ["Fully Equipped","Collect every trait slot",25,achEventFlagGroupSum([TRAIT_SLOT_BEACH, TRAIT_SLOT_PLAINS, TRAIT_SLOT_RUINS, TRAIT_SLOT_SNOW])],

// -- MAP EXPLORATION ---
    ["Studied Ruins","Explore every tile of the Ancient Ruins",10,achWorldTilesAllDiscovered(0)],
    ["Dungeon Excavator","Explore every tile of Meadeland",10,achWorldTilesAllDiscovered(1)],
    ["Beach Exploration","Explore every tile of Deanuford",10,achWorldTilesAllDiscovered(2)],
    ["Searching the Plains","Explore every tile of Zoetopia",10,achWorldTilesAllDiscovered(3)],
    ["A Cold Look","Explore every tile of Ethanica",10,achWorldTilesAllDiscovered(4)],
    ["Prissingham Tour","Explore every tile of Prissingham",10,achWorldTilesAllDiscovered(5)],

// --- OTHER ---
    ["Beating with Style","Perform a 40-hit combo",10,achComboReached(40)],
    ["New Friends","Input a code to unlock Ellie's alternate color palette",1,achCheatActivated()],
    ["Chomp vs Snout","Defeat Priscilla & Snout while only using Chomp's Foundling form",10,achFinalBossFormOnly(FORM_FOUNDLING)],
    ["Frequent Shopper","Purchase every upgrade for Ellie in Jinx's shop",25,achEventFlagGroupMeasuredSum(GROUP_SHOP)],
]

achs_missable = [
// --- EVOLUTIONS ---
    ["Water Bug","Evolve Chomp to Stalwart form",10,achUnlockChompForm(FORM_STALWART)],
    ["Spikes from Both Sides","Evolve Chomp to Scourge form",10,achUnlockChompForm(FORM_SCOURGE)],
    ["Evading Maneuver","Evolve Chomp to Pixie form",10,achUnlockChompForm(FORM_PIXIE)],
    ["Angry Puppy","Evolve Chomp to Winged Avenger form",10,achUnlockChompForm(FORM_WINGEDAVENGER)],
    ["Fairly Protected","Evolve Chomp to Zippy form",25,achUnlockChompForm(FORM_ZIPPY)],

    ["Attachment Issues","Evolve Chomp to Glider form",10,achUnlockChompForm(FORM_GLIDER)],
    ["Winged Flames","Evolve Chomp to Icarus form",10,achUnlockChompForm(FORM_ICARUS)],
    ["Wet Thorns","Evolve Chomp to Prickett form",10,achUnlockChompForm(FORM_PRICKETT)],
    ["Mysterious Power","Evolve Chomp to Elite Guard form",25,achUnlockChompForm(FORM_ELITEGUARD)],

    ["Rollin' Around","Evolve Chomp to Juggernaut form",10,achUnlockChompForm(FORM_JUGGERNAUT)],
    ["The Monster of the Seas","Evolve Chomp to Rebel form",10,achUnlockChompForm(FORM_REBEL)],
    ["One Eye and One Wing","Evolve Chomp to Gilgamesh form",10,achUnlockChompForm(FORM_GILGAMESH)],
    ["Mystical Giant","Evolve Chomp to Sasquatch form",25,achUnlockChompForm(FORM_SASQUATCH)],

    
// --- CHOMP SKILLS ---
    ["Skilled Pet","Have Chomp learn every skill",10,achAllSkillsLearned()],
    ["Mastered Beast","Have Chomp master every skill",25,achAllSkillsMastered()],





    // ADDENDUM REMOVAL
        //["Green Elf","Evolve Chomp to Ravenous form",10,achUnlockChompForm(FORM_RAVENOUS)],
        //["Imitating Enemies","Evolve Chomp to Mimic form",10,achUnlockChompForm(FORM_MIMIC)],
        //["Very Hot Punch","Evolve Chomp to Bruiser form",10,achUnlockChompForm(FORM_BRUISER)],
        //["acrobat","",0,achUnlockChompForm(FORM_ACROBAT)],
        //["cyclops","",0,achUnlockChompForm(FORM_CYCLOPS)],

        //["","",0,achUnlockChompForm(FORM_REPELLER)],
        //["","",0,achUnlockChompForm(FORM_HURLER)],
        //["","",0,achUnlockChompForm(FORM_SPITTER)],
        //["","",0,achUnlockChompForm(FORM_PALADIN)],
        //["","",0,achUnlockChompForm(FORM_WRECKER)],
        //["","",0,achUnlockChompForm(FORM_PETDOZER)],
        //["","",0,achUnlockChompForm(FORM_SEEKER)],
        //["","",0,achUnlockChompForm(FORM_WARLOCK)],
        //["","",0,achUnlockChompForm(FORM_TALLBAIN)],
]

achs_prog = [
    ["Dragon Without Fire","Defeat the Purple Dragon",5,achEventFlag(EVENT_CHOMP_LEARNS_SKILL)],
    ["Sound Battle","Defeat Meade",10,achEventFlag(MEADE_DEFEATED)],
    ["The Mermaid Man","Defeat Deanu",10,achEventFlag(DEANU_DEFEATED)],
    ["Alice from the Country of Madness","Defeat Zoe",10,achEventFlag(ZOE_DEFEATED)],
    ["Robot Expert","Defeat Nathan",10,achEventFlag(NATHAN_DEFEATED)],
]

achs_win = [
    ["The Dragon Princess","Defeat Priscilla & Snout",10,achEventFlag(PRISCILLA_DEFEATED)],
]

for a in achs_reg ach(a,"")
for a in achs_missable ach(a,"missable")
for a in achs_prog ach(a,"progression")
for a in achs_win ach(a,"win_condition")

/*
achievement(
    title = "Super Bracelet", points = 5,
    description = "Get the Band Blaster upgrade [no new palette Ellie]",
    id = 101990, badge = "110891", published = "3/7/2020 12:55:30 AM", modified = "3/11/2020 5:28:38 AM",
    trigger = byte(0x0CE819) == 49 && byte(0x11E278) == 116 && byte(0x0EC616) == 1 && unless(byte(0x11C43C) == 1) &&
              byte(0x3121AD) > 98
)

achievement(
    title = "Beat Up", points = 5,
    description = "Get the Backhand skill [no new palette Ellie]",
    id = 101991, badge = "110894", published = "3/7/2020 12:55:39 AM", modified = "3/19/2020 4:39:07 AM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 56 && byte(0x11E278) == 8 && byte(0x11EC8C) == 9 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Long-Shoot", points = 5,
    description = "Get the Super Band Blaster upgrade [no new palette Ellie]",
    id = 101992, badge = "110895", published = "3/7/2020 12:55:46 AM", modified = "3/12/2020 1:48:50 PM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 54 && byte(0x11E278) == 88 && byte(0x2EC203) == 2 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Armadillo Ball", points = 5,
    description = "Get the Roll ability [no new palette Ellie]",
    id = 101993, badge = "110917", published = "3/7/2020 12:55:52 AM", modified = "3/19/2020 4:39:11 AM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 57 && byte(0x11E278) == 100 && byte(0x11EC8C) == 21 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Hand-To-Hand Combat", points = 5,
    description = "Learn the Chainsaw Hands skill [no new palette Ellie]",
    id = 101994, badge = "110919", published = "3/7/2020 12:55:58 AM", modified = "3/19/2020 4:39:15 AM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 56 && byte(0x11E278) == 136 && byte(0x11EC8C) == 4 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Blow to the Air", points = 5,
    description = "Seriously guys, learn Launcher Attack [no new palette Ellie]",
    id = 101995, badge = "110920", published = "3/7/2020 12:56:03 AM", modified = "3/19/2020 4:39:19 AM",
    trigger = byte(0x0D1674) == 1 && byte(0x11E278) == 4 && byte(0x0CE819) == 56 && byte(0x11EC8C) == 12 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Capcom Rages", points = 5,
    description = "Learn Gravity Weeps (that blue guy...) [no new palette Ellie]",
    id = 101996, badge = "110928", published = "3/7/2020 12:56:11 AM", modified = "3/19/2020 4:39:23 AM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 56 && byte(0x11E278) == 76 && byte(0x11EC8C) == 14 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Plasma Cannon", points = 5,
    description = "Get Bust Cancel upgrade [no new palette Ellie]",
    id = 101997, badge = "110944", published = "3/7/2020 12:56:18 AM", modified = "3/19/2020 4:39:27 AM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 49 && byte(0x11E278) == 16 && byte(0x11EC8C) == 20 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "1.5 Seconds", points = 5,
    description = "Have the Ripple upgrade [no new palette Ellie]",
    id = 101998, badge = "110949", published = "3/7/2020 12:56:23 AM", modified = "3/19/2020 4:39:31 AM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 48 && byte(0x11E278) == 176 && byte(0x11EC8C) == 7 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Back Down", points = 5,
    description = "Get Down Smash upgrade [no new palette Ellie]",
    id = 101999, badge = "110953", published = "3/7/2020 12:56:28 AM", modified = "3/16/2020 2:53:18 PM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 54 && byte(0x11E278) == 0 && byte(0x11E638) == 164 &&
              byte(0x11EC8C) == 17 && unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Did You Get the Reference?", points = 5,
    description = "Learn the Dash skill [no new palette Ellie]",
    id = 102000, badge = "110958", published = "3/7/2020 12:56:36 AM", modified = "3/16/2020 2:53:19 PM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 56 && byte(0x11E278) == 156 && byte(0x11EC8C) == 18 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "You Didn't See It Coming", points = 5,
    description = "Learn the Super Wave skill [no new palette Ellie]",
    id = 102001, badge = "110960", published = "3/7/2020 12:56:41 AM", modified = "3/16/2020 2:53:21 PM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 57 && byte(0x11E278) == 224 && byte(0x11EC8C) == 16 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Eye Shots", points = 5,
    description = "Get the Charge Shot upgrade [no new palette Ellie]",
    id = 102002, badge = "110970", published = "3/7/2020 12:56:48 AM", modified = "3/8/2023 4:05:20 PM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 52 && byte(0x11E278) == 60 && byte(0x11EC8C) == 7 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Smoke-Free", points = 5,
    description = "Get the Might Lungs ability [no new palette Ellie]",
    id = 102003, badge = "110972", published = "3/7/2020 12:56:55 AM", modified = "3/12/2020 1:48:52 PM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 49 && byte(0x11E278) == 12 && byte(0x11EC8C) == 25 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "When Your Efforts Are Worthwhile", points = 5,
    description = "Air Bust Cancel learned! [no new palette Ellie]",
    id = 102004, badge = "111094", published = "3/7/2020 12:57:02 AM", modified = "3/19/2020 4:39:03 AM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 49 && byte(0x11E278) == 176 && byte(0x11EC8C) == 9 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "This Is an X-Buster, Yes!", points = 5,
    description = "Ultimate Charge Shot learned! [no new palette Ellie]",
    id = 102005, badge = "111098", published = "3/7/2020 12:57:08 AM", modified = "3/16/2020 2:53:24 PM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 53 && byte(0x11E278) == 196 && byte(0x11EC8C) == 18 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Dragon Without Fire", points = 10, type="progression",
    description = "Defeat the Purple Dragon [no new palette Ellie]",
    id = 102006, badge = "110892", published = "3/7/2020 12:57:40 AM", modified = "3/11/2020 5:28:43 AM",
    trigger = byte(0x31B66E) < 2 && byte(0x0CE819) == 57 && byte(0x11E638) == 40 && unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Sound Battle", points = 10, type="progression",
    description = "Collect the Dragonkey [no new palette Ellie]",
    id = 102007, badge = "110925", published = "3/7/2020 12:57:46 AM", modified = "3/19/2020 4:39:36 AM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 57 && byte(0x11E278) == 116 && byte(0x11EC8C) == 22 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "The Mermaid Man", points = 10, type="progression",
    description = "Collect the Water Key [no new palette Ellie]",
    id = 102008, badge = "110956", published = "3/7/2020 12:57:52 AM", modified = "3/15/2020 3:59:59 PM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 52 && byte(0x11E278) == 116 && byte(0x11EC8C) == 16 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Alice From the Country of Madness", points = 10, type="progression",
    description = "Collect the Rabbit Key [no new palette Ellie]",
    id = 102009, badge = "110963", published = "3/7/2020 12:58:00 AM", modified = "3/15/2020 4:00:02 PM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 56 && byte(0x11E278) == 116 && byte(0x11EC8C) == 29 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Robot Expert", points = 10, type="progression",
    description = "Collect the Machine Key [no new palette Ellie]",
    id = 102010, badge = "111095", published = "3/7/2020 12:58:06 AM", modified = "3/12/2020 1:48:55 PM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 55 && byte(0x11E278) == 116 && byte(0x11EC8C) == 15 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "The Dragon Princess", points = 10, type="win_condition",
    description = "Defeat Priscilla & Snout [no new palette Ellie]",
    id = 102011, badge = "111232", published = "3/7/2020 12:58:15 AM", modified = "3/11/2020 5:28:54 AM",
    trigger = byte(0x0CE819) == 51 && byte(0x12F7B4) <= 3 && byte(0x11E278) == 76 && byte(0x11EC8C) == 10 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Fairy", points = 25,
    description = "Evolve Chomp to Zippy form [select from the menu, no new color palette Ellie]",
    id = 102014, badge = "111261", published = "3/7/2020 12:58:52 AM", modified = "3/11/2020 5:28:58 AM",
    trigger = byte(0x1221E0) == 19 && byte(0x0E4BB8) == 4 && unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Mystical Giant", points = 25,
    description = "Evolve Chomp to Sasquatch form [select from the menu, no new color palette Ellie]",
    id = 102015, badge = "111282", published = "3/7/2020 12:58:59 AM", modified = "3/11/2020 5:29:00 AM",
    trigger = byte(0x1221E0) == 9 && byte(0x0E4BB8) == 4 && unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Mysterious Power", points = 25,
    description = "Evolve Chomp to Elite Guard form [select from the menu, no new color palette Ellie]",
    id = 102016, badge = "111284", published = "3/7/2020 12:59:03 AM", modified = "3/11/2020 5:29:02 AM",
    trigger = byte(0x1221E0) == 29 && byte(0x0E4BB8) == 4 && unless(byte(0x11C43C) == 1)
)
achievement(
    title = "Temple Heart", points = 10,
    description = "Collect the Extra Heart in the Dungeons [no new palette Ellie]",
    id = 102017, badge = "110918", published = "3/7/2020 12:59:21 AM", modified = "3/15/2020 4:00:05 PM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 51 && byte(0x11E278) == 116 && byte(0x11EC8C) == 7 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Lost Swamp Heart", points = 10,
    description = "Collect the Extra Heart in Autumn Thicket [no new palette Ellie]",
    id = 102018, badge = "110959", published = "3/7/2020 12:59:29 AM", modified = "3/12/2020 1:50:15 PM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 54 && byte(0x11E278) == 92 && byte(0x11EC8C) == 10 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Cold Heart", points = 10,
    description = "Collect the Extra Heart in Demon Shuttle [no new palette Ellie]",
    id = 102019, badge = "110971", published = "3/7/2020 12:59:35 AM", modified = "3/12/2020 1:48:45 PM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 51 && byte(0x11E278) == 212 && byte(0x11EC8C) == 26 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Lost Beach Collectible", points = 10,
    description = "Get the Trait Slot on the Beach [no new palette Ellie]",
    id = 102020, badge = "110935", published = "3/7/2020 12:59:49 AM", modified = "3/12/2020 1:48:47 PM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 50 && byte(0x11E278) == 212 && byte(0x11EC8C) == 18 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Chomp's Guarded Treasure", points = 10,
    description = "Get the Trait Slot on Ancient Ruins [no new palette Ellie]",
    id = 102021, badge = "110941", published = "3/7/2020 12:59:53 AM", modified = "3/17/2020 12:17:41 AM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 51 && byte(0x11E278) == 208 && byte(0x11EC8C) == 7 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Did You Defeat the Giant Crabs for That?", points = 10,
    description = "Get the Trait Slot on Windlemill Plains [no new palette Ellie]",
    id = 102022, badge = "110957", published = "3/7/2020 12:59:59 AM", modified = "3/19/2020 4:38:59 AM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 55 && byte(0x11E278) == 68 && byte(0x11EC8C) == 20 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Sliding Under the Thorns", points = 10,
    description = "Get the Trait Slot on Frigid Cliffs [no new palette Ellie]",
    id = 102023, badge = "110969", published = "3/7/2020 1:00:05 AM", modified = "3/17/2020 12:19:42 AM",
    trigger = byte(0x0D1674) == 1 && byte(0x0CE819) == 57 && byte(0x11E278) == 8 && byte(0x11EC8C) == 9 &&
              unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Puppy Reaching Its Peak", points = 25,
    description = "Reach level 30 with Foundling form Chomp [no new palette Ellie]",
    id = 102024, badge = "111248", published = "3/7/2020 1:00:40 AM", modified = "3/11/2020 5:27:15 AM",
    trigger = byte(0x122556) == 30 && prev(byte(0x122556)) == 29 && byte(0x1221E0) == 10 && unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Super Strong Young", points = 25,
    description = "Reach level 30 with the Ballista form of Chomp [no new palette Ellie]",
    id = 102025, badge = "111108", published = "3/7/2020 1:00:45 AM", modified = "3/11/2020 5:27:17 AM",
    trigger = byte(0x12289E) == 30 && prev(byte(0x12289E)) == 29 && byte(0x1221E0) == 20 && unless(byte(0x11C43C) == 1)
)

achievement(
    title = "An Adult With Full Strength", points = 25,
    description = "Reach level 30 with the Sentinel form of Chomph [no new palette Ellie]",
    id = 102026, badge = "111135", published = "3/7/2020 1:00:52 AM", modified = "3/11/2020 5:27:19 AM",
    trigger = byte(0x12220E) == 30 && prev(byte(0x12220E)) == 29 && byte(0x1221E0) == 0 && unless(byte(0x11C43C) == 1)
)*/

/*
achievement(
    title = "Beating With Style", points = 10,
    description = "Make 40 hit combos [no new palette Ellie]",
    id = 102027, badge = "110921", published = "3/7/2020 1:01:06 AM", modified = "3/11/2020 5:27:21 AM",
    trigger = byte(0x12BBD8) >= 40 && prev(byte(0x12BBD8)) < 40 && byte(0x11C43C) == 0 && unless(byte(0x12BBD8) == 15) &&
              unless(byte(0x12BBD8) == 255) && word(0x120CE4) != 0
)

achievement(
    title = "Fully Equipped", points = 25,
    description = "Complete all Traits Slots [no new palette Ellie]",
    id = 102028, badge = "111276", published = "3/7/2020 1:01:18 AM", modified = "3/11/2020 5:27:24 AM",
    trigger = byte(0x122205) == 12 && prev(byte(0x122205)) == 11 && unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Love Collector", points = 25,
    description = "Get all the Extra Hearts [no new palette Ellie]",
    id = 102029, badge = "111101", published = "3/7/2020 1:01:23 AM", modified = "3/11/2020 5:27:26 AM",
    trigger = byte(0x12AE94) == 10 && unless(byte(0x11C43C) == 1) &&
              ((prev(byte(0x12AE94)) == 7) ||
               (prev(byte(0x12AE94)) == 8) ||
               (prev(byte(0x12AE94)) == 9))
)

achievement(
    title = "Chomp vs Snout", points = 10,
    description = "Defeat Priscilla & Snout using the original form of Chomp [no new palette Ellie]",
    id = 102031, badge = "111230", published = "3/7/2020 1:01:41 AM", modified = "3/17/2020 12:24:58 AM",
    trigger = byte(0x0CE819) == 51 && byte(0x12F7B4) <= 3 && byte(0x11E278) == 76 && byte(0x11EC8C) == 10 &&
              unless(byte(0x1221E0) != 10) && unless(byte(0x11C43C) == 1)
)

achievement(
    title = "New Friends", points = 5,
    description = "Discover Chomp with Ellie's new color palette",
    id = 102032, badge = "111233", published = "3/7/2020 1:01:49 AM", modified = "3/11/2020 5:27:34 AM",
    trigger = byte(0x11C43C) == 1 && byte(0x0CE819) == 52 && byte(0x11E278) == 240 && byte(0x0D09B8) == 44
)

achievement(
    title = "Good Day is a Bath Day", points = 1,
    description = "Welcome to the Beach!",
    id = 102033, badge = "111240", published = "3/7/2020 1:01:53 AM", modified = "3/11/2020 5:26:53 AM",
    trigger = byte(0x11EC8C) == 26 && byte(0x0CE819) == 49 && byte(0x11E278) == 116
)

achievement(
    title = "Eternal Rain in the Fields", points = 2,
    description = "A place to fear the Plains",
    id = 102034, badge = "111241", published = "3/7/2020 1:01:58 AM", modified = "3/11/2020 5:27:38 AM",
    trigger = byte(0x11EC8C) == 12 && byte(0x0CE819) == 49 && byte(0x11E278) == 116
)

achievement(
    title = "Welcome to the Cave", points = 1,
    description = "Have you picked up your shovel yet?",
    id = 102035, badge = "111243", published = "3/7/2020 1:02:01 AM", modified = "3/11/2020 5:27:41 AM",
    trigger = byte(0x11E278) == 116 && byte(0x11EC8C) == 4 && byte(0x0CE819) == 49
)

achievement(
    title = "Glaciers in Ethanica", points = 2,
    description = "Get ready for the cold!",
    id = 102036, badge = "111244", published = "3/7/2020 1:02:05 AM", modified = "3/11/2020 5:27:44 AM",
    trigger = byte(0x11EC8C) == 17 && byte(0x0CE819) == 49 && byte(0x11E278) == 116
)

achievement(
    title = "Place Where the Villain is the Princess", points = 2,
    description = "Get in Primhedge Palace",
    id = 102037, badge = "111278", published = "3/7/2020 1:02:09 AM", modified = "3/11/2020 5:27:46 AM",
    trigger = byte(0x11EC8C) == 12 && byte(0x0CE819) == 50 && byte(0x11E278) == 68
)

achievement(
    title = "Angry Puppy", points = 10,
    description = "Evolve Chomp to Winged Avenger form [select from the menu, no new color palette Ellie]",
    id = 102187, badge = "111535", published = "3/8/2020 10:33:12 PM", modified = "3/11/2020 5:27:49 AM",
    trigger = byte(0x1221E0) == 18 && byte(0x0E4BB8) == 4 && unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Water Bug", points = 10,
    description = "Evolve Chomp to Stalwart form [select from the menu, no new color palette Ellie]",
    id = 102188, badge = "111536", published = "3/8/2020 10:33:19 PM", modified = "3/11/2020 5:27:51 AM",
    trigger = byte(0x1221E0) == 12 && byte(0x0E4BB8) == 4 && unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Green Elf", points = 10,
    description = "Evolve Chomp to Ravenous form [select from the menu, no new color palette Ellie]",
    id = 102189, badge = "111537", published = "3/8/2020 10:33:24 PM", modified = "3/11/2020 5:27:53 AM",
    trigger = byte(0x1221E0) == 16 && byte(0x0E4BB8) == 4 && unless(byte(0x11C43C) == 1)
)

achievement(
    title = "Imitating Enemies", points = 10,
    description = "Evolve Chomp to Mimic form [select from the menu, no new color palette Ellie]",
    id = 102190, badge = "111539", published = "3/8/2020 10:33:30 PM", modified = "3/11/2020 5:27:55 AM",
    trigger = unless(byte(0x11C43C) == 1) && byte(0x1221E0) == 25 && byte(0x0E4BB8) == 4
)

achievement(
    title = "Winged Flames", points = 10,
    description = "Evolve Chomp to Icarus form [select from the menu, no new color palette Ellie]",
    id = 102191, badge = "111540", published = "3/8/2020 10:33:35 PM", modified = "3/11/2020 5:27:58 AM",
    trigger = unless(byte(0x11C43C) == 1) && byte(0x0E4BB8) == 4 && byte(0x1221E0) == 27
)

achievement(
    title = "Wet Thorns", points = 10,
    description = "Evolve Chomp to Prickett form [select from the menu, no new color palette Ellie]",
    id = 102192, badge = "111541", published = "3/8/2020 10:33:41 PM", modified = "3/11/2020 5:28:00 AM",
    trigger = unless(byte(0x11C43C) == 1) && byte(0x1221E0) == 28 && byte(0x0E4BB8) == 4
)

achievement(
    title = "One Eye and One Wing", points = 10,
    description = "Evolve Chomp to Gilgamesh form [select from the menu, no new color palette Ellie]",
    id = 102193, badge = "111543", published = "3/8/2020 10:33:46 PM", modified = "3/11/2020 5:28:02 AM",
    trigger = unless(byte(0x11C43C) == 1) && byte(0x1221E0) == 6 && byte(0x0E4BB8) == 4
)

achievement(
    title = "The Monster of the Seas", points = 10,
    description = "Evolve Chomp to Rebel form [select from the menu, no new color palette Ellie]",
    id = 102194, badge = "111544", published = "3/8/2020 10:33:53 PM", modified = "3/11/2020 5:28:04 AM",
    trigger = unless(byte(0x11C43C) == 1) && byte(0x1221E0) == 8 && byte(0x0E4BB8) == 4
)

achievement(
    title = "Very Hot Punch", points = 10,
    description = "Evolve Chomp to Bruiser form [select from the menu, no new color palette Ellie]",
    id = 102195, badge = "111545", published = "3/8/2020 10:33:58 PM", modified = "3/11/2020 5:28:06 AM",
    trigger = unless(byte(0x11C43C) == 1) && byte(0x1221E0) == 4 && byte(0x0E4BB8) == 4
)

achievement(
    title = "Becoming a Teenager", points = 1,
    description = "Chomp evolves to...",
    id = 102012, badge = "111554", published = "3/7/2020 12:58:32 AM", modified = "3/8/2020 10:31:13 PM",
    trigger = byte(0x1221E0) == 20
)

achievement(
    title = "Adult Is Serious", points = 1,
    description = "Super Mega Chomp evolves to...",
    id = 102013, badge = "111555", published = "3/7/2020 12:58:38 AM", modified = "3/8/2020 10:31:32 PM",
    trigger = byte(0x1221E0) == 0
)

achievement(
    title = "DEMOTED AS UNWELCOME CONCEPT - Lots and Lots of Coins", points = 10,
    description = "Collect a total of 10,000 coins [no new palette Ellie]",
    id = 102030, badge = "111138", published = "3/7/2020 1:01:30 AM", modified = "8/7/2025 11:54:33 PM",
    trigger = unless(byte(0x11C43C) == 1) && word(0x120CE4) >= 10000 && prev(word(0x120CE4)) < 10000 &&
              unless(byte(0x12AE94) == 255) &&
              disable_when(prev(byte(0x12AE94)) == 255 && byte(0x12AE94) <= 10 && word(0x120CE4) >= 10000) &&
              (always_false() || (never((prev(byte(0x12AE94)) != 255 && byte(0x12AE94) == 255))))
)
*/