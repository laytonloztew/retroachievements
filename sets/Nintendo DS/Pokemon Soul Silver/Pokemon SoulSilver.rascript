// Pokémon SoulSilver Version
// #ID = 39076

function has_increased(addr) => addr > prev(addr)
function has_decreased(addr) => addr < prev(addr)
function has_changed(addr) => addr != prev(addr)
function hasnt_changed(addr) => addr == prev(addr)
function if_else(p, t, f) { if (p) { return t } else return f }
function is_even(v) => v % 2 == 0

// Pointer mask for custom memory map
RA_MASK = 0x00FFFFFF

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

REGION_PTR_ADDR = 0x00000ba8
function r(offset) => ptr(REGION_PTR_ADDR,[0x00,offset],acc_addr)
function s(offset) => ptr(REGION_PTR_ADDR,[0x00,0xC09C8,offset],acc_addr)
function save_ptr() => ptr(REGION_PTR_ADDR,[0x00,0xC09C8],dword)

johtoBadges_addr = s(0x8e)
kantoBadges_addr = s(0x93)

function johtoBadgeObtained(f) => bit(f%8, johtoBadges_addr + f/8)
function kantoBadgeObtained(f) => bit((f-8)%8, kantoBadges_addr + (f-8)/8)

function sumJBadges() => sum_of(range(0,8), f => johtoBadgeObtained(f))
function sumKBadges() => sum_of(range(8,16), f => kantoBadgeObtained(f))
function sumBadges() => sumJBadges() + sumKBadges()

function igtHours() => word(s(0x96))
function igtMin() => byte(s(0x98))
function igtSec() => byte(s(0x99))

function igtTotalSecs() => (igtHours() * 3600) + (igtMin() * 60) + igtSec()

pkmnCaught_addr = s(0x12CC)
pkmnSeen_addr = s(0x130C)
NUM_PKMN = 493
function pkmnCaught(f) => bit(f%8, pkmnCaught_addr + f/8)
function pkmnSeen(f) => bit(f%8, pkmnSeen_addr + f/8)
function sumPkmnCaught() => sum_of(range(0,NUM_PKMN-1), p => pkmnCaught(p))
function sumPkmnSeen() => sum_of(range(0,NUM_PKMN-1), p => pkmnSeen(p))

function currentOverlayID(index) => dword(r(0xBF590 + (index * 8)))
function isActiveOverlay(index) => dword(r(0xBF594 + (index * 8))) == 1

function gSystem() => dword(r(0xBF8AC))

function inGame() => gSystem() != 0 && /*isActiveOverlay(0) &&*/ currentOverlayID(0) != OV_INTRO_TITLE && currentOverlayID(0) != OV_MAINMENU
function inBattle() => inGame() && currentOverlayID(0) == OV_BATTLE

OV_WIFISETTINGS = 0
OV_FIELD = 1
OV_BATTLE = 12
OV_PC_BOX = 14
OV_BAG = 15
OV_BERRYPOTS = 16
OV_POKEDEX = 18
OV_VSRECORDER = 40
OV_PALPAD = 43
OV_TRAINERCARD = 50
OV_OAKSSPEECH = 53
OV_OPTIONS = 54
OV_CAPSULES = 57
OV_APRICORNBOX = 58
OV_INTRO_TITLE = 60
OV_CHOOSE_STARTER = 61
OV_HALLOFFAME = 64
OV_MAINMENU = 74
OV_WIIMESSAGE = 75
OV_POKEGEAR = 100
OV_MAP = 101 //FLY
OV_MAILBOX = 103
OV_SAFARICUSTOMIZER = 108
OV_PHOTOALBUM = 109
OV_POKEWALKER = 112
OV_UNOWN_REPORT = 113

function var(f) => word(s(0xdf4 + ((f - 0x4000) * 2)))
function flag(f) => bit(f%8, s(0x10d4) + f/8)
function trainer_flag(f) => flag(f + 0x550)//bit(f%8, s(0x10d4) + TRAINER_FLAG_BASE + f/8)

function currMapID() => dword(s(0x1244))

function achFlagInMap(flag_id, map_id) => achFlagAnyMap(flag_id) && currMapID() == map_id
function achFlagAnyMap(flag_id) => inGame() && has_increased(flag(flag_id))

function achFlagGroup(g) => inGame() && 
                            measured(sum_of(g, f => flag(f)) == length(g)) &&
                            sum_of(g, f => prev(flag(f))) == length(g) - 1

function achVarChange(v,f,t) => inGame() && var(v) == t && prev(var(v)) == f

function achJohtoBadgeObtained(i) => inGame() && has_increased(johtoBadgeObtained(i))
function achKantoBadgeObtained(i) => inGame() && has_increased(kantoBadgeObtained(i))

function heapIndex(heap_id) => ptr(dword(r(0xbfd34)),[heap_id],byte)
function heapStartAddr() => ptr(dword(r(0xbfd24)),[0x00],acc_addr)
function heap(heap_id) => ptr(dword(heapStartAddr() + (heapIndex(heap_id) * 4)),[0x18,0x00],acc_addr)

function battleTrainer() => word(heap(5) + 0xc2)
function battleContextPtr() => dword(heap(5) + 0x50)

BATTLE_IN_PROGRESS = 0
BATTLE_RESULT_WIN = 1
BATTLE_RESULT_LOSE = 2
BATTLE_RESULT_DRAW = 3
BATTLE_RESULT_CAPTURED_MON = 4
BATTLE_RESULT_PLAYER_FLED = 5
BATTLE_RESULT_ENEMY_FLED = 6
function battleOutcome() => byte(heap(5) + 0x2440)
function battleWon() => battleOutcome() == BATTLE_RESULT_WIN && prev(battleOutcome()) == BATTLE_IN_PROGRESS


function battleTypeAddr() => heap(5) + 0x4C
function isTrainerBattle() => bit(0,battleTypeAddr()) == 1
function isDoubleBattle() => bit(1,battleTypeAddr()) == 1

function battleMonAddr(i) => ptr(battleContextPtr(), [0x2d40 + (i * 0xc0)],acc_addr)
function battleMonSpecies(i) => word(battleMonAddr(i) + 0x00)
function battleMonLevel(i) => byte(battleMonAddr(i) + 0x34)
function battleMonGender(i) => low4(battleMonAddr(i) + 0x7e)

function achTrainerDefeated(trainer_ids) => inBattle() && isTrainerBattle() && battleWon() && any_of(trainer_ids, t => 
            battleTrainer() == t
        )

function ach(ach, t) {
    achievement(
        title = ach[0],
        points = ach[2],
        description = ach[1],
        trigger = ach[3],
        type=t
    )
}

AreaLookup = {
    0: "Mystery Zone",
    1: "Mystery Zone",
    2: "Mystery Zone",
    3: "Mystery Zone",
    4: "Mystery Zone",
    5: "Mystery Zone",
    6: "Bellchime Trail",
    7: "Burned Tower",
    8: "Ruins of Alph",
    9: "Route 1",
    10: "Route 2",
    11: "Route 3",
    12: "Route 4",
    13: "Route 5",
    14: "Route 6",
    15: "Route 7",
    16: "Route 8",
    17: "Route 9",
    18: "Route 10",
    19: "Route 11",
    20: "Route 12",
    21: "Route 13",
    22: "Route 14",
    23: "Route 15",
    24: "Route 16",
    25: "Route 17",
    26: "Route 18",
    27: "Route 22",
    28: "Route 24",
    29: "Route 25",
    30: "Route 26",
    31: "Route 27",
    32: "Route 28",
    33: "Route 29",
    34: "Route 30",
    35: "Route 31",
    36: "Route 32",
    37: "Route 33",
    38: "Route 34",
    39: "Route 35",
    40: "Route 36",
    41: "Route 37",
    42: "Route 38",
    43: "Route 39",
    44: "Route 42",
    45: "Route 43",
    46: "Route 44",
    47: "Route 45",
    48: "Route 46",
    49: "Pallet Town",
    50: "Viridian City",
    51: "Pewter City",
    52: "Cerulean City",
    53: "Lavender Town",
    54: "Vermilion City",
    55: "Celadon City",
    56: "Fuchsia City",
    57: "Cinnabar Island",
    58: "Indigo Plateau",
    59: "Saffron City",
    60: "New Bark Town",
    61: "New Bark Town",
    62: "New Bark Town",
    63: "New Bark Town",
    64: "New Bark Town",
    65: "New Bark Town",
    66: "New Bark Town",
    67: "Cherrygrove City",
    68: "Cherrygrove City",
    69: "Cherrygrove City",
    70: "Cherrygrove City",
    71: "Cherrygrove City",
    72: "Cherrygrove City",
    73: "Violet City",
    74: "Azalea Town",
    75: "Cianwood City",
    76: "Goldenrod City",
    77: "Olivine City",
    78: "Ecruteak City",
    79: "Ecruteak City",
    80: "Ecruteak City",
    81: "Ecruteak City",
    82: "Jubilife City",
    83: "Ecruteak City",
    84: "Ecruteak City",
    85: "Ecruteak City",
    86: "Ecruteak City",
    87: "Mahogany Town",
    88: "Lake of Rage",
    89: "Blackthorn City",
    90: "Mt. Silver",
    91: "Route 19",
    92: "Route 20",
    93: "Route 21",
    94: "Route 40",
    95: "Route 41",
    96: "National Park",
    97: "Route 31",
    98: "Route 32",
    99: "Union Cave",
    100: "Azalea Town",
    101: "Route 35",
    102: "Route 35",
    103: "Route 36",
    104: "Route 36",
    105: "Jubilife City",
    106: "DIGLETT's Cave",
    107: "Mt. Moon",
    108: "Rock Tunnel",
    109: "Pal Park",
    110: "Sprout Tower",
    111: "Bell Tower",
    112: "Radio Tower",
    113: "Ruins of Alph",
    114: "SLOWPOKE Well",
    115: "Lighthouse",
    116: "Mahogany Town",
    117: "Ilex Forest",
    118: "Goldenrod Tunnel",
    119: "Mt. Mortar",
    120: "Ice Path",
    121: "Whirl Islands",
    122: "Mt. Silver Cave",
    123: "Dark Cave",
    124: "Victory Road",
    125: "Dragon's Den",
    126: "Tohjo Falls",
    127: "Route 30",
    128: "Ecruteak City",
    129: "Ecruteak City",
    130: "Ecruteak City",
    131: "Ecruteak City",
    132: "Route 42",
    133: "Mahogany Town",
    134: "Route 29",
    135: "Violet City",
    136: "Azalea Town",
    137: "Goldenrod City",
    138: "Olivine City",
    139: "Cianwood City",
    140: "Mahogany Town",
    141: "Blackthorn City",
    142: "Route 43",
    143: "Route 30",
    144: "Cherrygrove City",
    145: "Cerulean Cave",
    146: "Seafoam Islands",
    147: "Viridian Forest",
    148: "Power Plant",
    149: "Route 36",
    150: "Pokeathlon Dome",
    151: "Route 47",
    152: "Route 48",
    153: "Union Cave",
    154: "Union Cave",
    155: "Sprout Tower",
    156: "Sprout Tower",
    157: "Violet City",
    158: "Violet City",
    159: "Violet City",
    160: "Violet City",
    161: "Jubilife City",
    162: "Violet City",
    163: "Azalea Town",
    164: "Azalea Town",
    165: "Azalea Town",
    166: "Azalea Town",
    167: "Violet City",
    168: "Azalea Town",
    169: "Route 32",
    170: "Route 32",
    171: "Route 34",
    172: "Route 38",
    173: "Safari Zone Gate",
    174: "Safari Zone Gate",
    175: "Jubilife City",
    176: "Dark Cave",
    177: "SLOWPOKE Well",
    178: "Victory Road",
    179: "Victory Road",
    180: "Azalea Town",
    181: "SLOWPOKE Well",
    182: "Goldenrod City",
    183: "Goldenrod City",
    184: "Goldenrod City",
    185: "Goldenrod City",
    186: "Radio Tower",
    187: "Radio Tower",
    188: "Radio Tower",
    189: "Radio Tower",
    190: "Radio Tower",
    191: "Goldenrod City",
    192: "Goldenrod City",
    193: "Goldenrod City",
    194: "Goldenrod City",
    195: "Goldenrod City",
    196: "Goldenrod City",
    197: "Goldenrod City",
    198: "Goldenrod City",
    199: "Goldenrod Tunnel",
    200: "Goldenrod City",
    201: "Goldenrod City",
    202: "Goldenrod City",
    203: "Goldenrod City",
    204: "Goldenrod City",
    205: "Goldenrod City",
    206: "Goldenrod City",
    207: "Global Terminal",
    208: "Goldenrod City",
    209: "Goldenrod City",
    210: "Goldenrod City",
    211: "Goldenrod City",
    212: "Goldenrod City",
    213: "Goldenrod City",
    214: "Route 39",
    215: "Route 39",
    216: "Ecruteak City",
    217: "Burned Tower",
    218: "Ruins of Alph",
    219: "Goldenrod City",
    220: "Lighthouse",
    221: "Lighthouse",
    222: "Lighthouse",
    223: "Lighthouse",
    224: "Lighthouse",
    225: "Lighthouse",
    226: "Olivine City",
    227: "Olivine City",
    228: "Olivine City",
    229: "Olivine City",
    230: "Olivine City",
    231: "Olivine City",
    232: "Cianwood City",
    233: "Cianwood City",
    234: "Cianwood City",
    235: "Cianwood City",
    236: "Cianwood City",
    237: "Ice Path",
    238: "Ice Path",
    239: "Ice Path",
    240: "Olivine City",
    241: "Cianwood City",
    242: "Whirl Islands",
    243: "Whirl Islands",
    244: "Whirl Islands",
    245: "Route 43",
    246: "Mahogany Town",
    247: "Team Rocket HQ",
    248: "Team Rocket HQ",
    249: "Team Rocket HQ",
    250: "Mt. Mortar",
    251: "Mt. Mortar",
    252: "Mt. Mortar",
    253: "Dragon's Den",
    254: "Fight Area",
    255: "Fight Area",
    256: "Fight Area",
    257: "Fight Area",
    258: "Fight Area",
    259: "Fight Area",
    260: "Fight Area",
    261: "Fight Area",
    262: "Fight Area",
    263: "Battle Park",
    264: "Battle Park",
    265: "Battle Tower",
    266: "Battle Tower",
    267: "Battle Tower",
    268: "Battle Tower",
    269: "Battle Tower",
    270: "Battle Tower",
    271: "Battle Tower",
    272: "Battle Frontier",
    273: "Battle Frontier",
    274: "Battle Tower",
    275: "Battle Factory",
    276: "Battle Hall",
    277: "Battle Castle",
    278: "Battle Arcade",
    279: "Cliff Edge Gate",
    280: "Pokeathlon Dome",
    281: "Pokeathlon Dome",
    282: "Pokeathlon Dome",
    283: "Pokeathlon Dome",
    284: "Pokeathlon Dome",
    285: "Pokeathlon Dome",
    286: "Pokeathlon Dome",
    287: "Pokeathlon Dome",
    288: "Dragon's Den",
    289: "Blackthorn City",
    290: "Blackthorn City",
    291: "Blackthorn City",
    292: "Blackthorn City",
    293: "Blackthorn City",
    294: "Lake of Rage",
    295: "Lake of Rage",
    296: "Route 26",
    297: "Route 26",
    298: "Tohjo Falls",
    299: "Route 26",
    300: "Pokemon League",
    301: "Pokemon League",
    302: "Pokemon League",
    303: "Pokemon League",
    304: "Pokemon League",
    305: "Pokemon League",
    306: "Pokemon League",
    307: "S.S. Aqua",
    308: "S.S. Aqua",
    309: "S.S. Aqua",
    310: "S.S. Aqua",
    311: "S.S. Aqua",
    312: "Ruins of Alph",
    313: "Ruins of Alph",
    314: "Ruins of Alph",
    315: "Ruins of Alph",
    316: "Ruins of Alph",
    317: "Ruins of Alph",
    318: "Ruins of Alph",
    319: "Ruins of Alph",
    320: "Ruins of Alph",
    321: "Ruins of Alph",
    322: "Route 27",
    323: "Ruins of Alph",
    324: "Ruins of Alph",
    325: "Ruins of Alph",
    326: "Ruins of Alph",
    327: "Ruins of Alph",
    328: "S.S. Aqua",
    329: "S.S. Aqua",
    330: "Olivine City",
    331: "Route 34",
    332: "Bell Tower",
    333: "Bell Tower",
    334: "Bell Tower",
    335: "Bell Tower",
    336: "Bell Tower",
    337: "Bell Tower",
    338: "Bell Tower",
    339: "Bell Tower",
    340: "Bell Tower",
    341: "Bell Tower",
    342: "Cliff Cave",
    343: "Safari Zone",
    344: "Safari Zone",
    345: "Safari Zone",
    346: "Safari Zone",
    347: "Safari Zone",
    348: "Safari Zone",
    349: "Safari Zone",
    350: "Safari Zone",
    351: "Safari Zone",
    352: "Safari Zone",
    353: "Safari Zone",
    354: "Safari Zone",
    355: "Safari Zone",
    356: "Safari Zone",
    357: "Safari Zone",
    358: "Vermilion City",
    359: "Vermilion City",
    360: "Vermilion City",
    361: "Vermilion City",
    362: "Vermilion City",
    363: "Vermilion City",
    364: "Vermilion City",
    365: "Vermilion City",
    366: "Route 40",
    367: "Olivine City",
    368: "Mahogany Town",
    369: "Blackthorn City",
    370: "Celadon City",
    371: "Celadon City",
    372: "Celadon City",
    373: "Celadon City",
    374: "Celadon City",
    375: "Celadon City",
    376: "Celadon City",
    377: "Celadon City",
    378: "Celadon City",
    379: "Celadon City",
    380: "Celadon City",
    381: "Celadon City",
    382: "Celadon City",
    383: "Celadon City",
    384: "New Bark Town",
    385: "Cianwood City",
    386: "Vermilion City",
    387: "Vermilion City",
    388: "Route 10",
    389: "Route 6",
    390: "Route 8",
    391: "Route 5",
    392: "Route 15",
    393: "Celadon City",
    394: "Celadon City",
    395: "Celadon City",
    396: "Mahogany Town",
    397: "Mahogany Town",
    398: "Saffron City",
    399: "Saffron City",
    400: "Saffron City",
    401: "Saffron City",
    402: "Saffron City",
    403: "ROTOM's Room",
    404: "Saffron City",
    405: "Saffron City",
    406: "Saffron City",
    407: "Saffron City",
    408: "Saffron City",
    409: "Saffron City",
    410: "Saffron City",
    411: "Frontier Access",
    412: "Global Terminal",
    413: "Global Terminal",
    414: "Route 2",
    415: "Route 16",
    416: "Route 20",
    417: "Route 2",
    418: "Route 2",
    419: "Route 2",
    420: "Route 2",
    421: "Route 16",
    422: "Route 16",
    423: "Route 18",
    424: "Route 19",
    425: "Route 11",
    426: "Cerulean City",
    427: "Cerulean City",
    428: "Cerulean City",
    429: "Cerulean City",
    430: "Cerulean City",
    431: "Cerulean City",
    432: "Cerulean City",
    433: "Lavender Town",
    434: "Lavender Town",
    435: "Lavender Town",
    436: "Lavender Town",
    437: "Lavender Town",
    438: "Lavender Town",
    439: "Lavender Town",
    440: "Route 25",
    441: "Goldenrod City",
    442: "Celadon City",
    443: "Celadon City",
    444: "Celadon City",
    445: "Saffron City",
    446: "Lighthouse",
    447: "Radio Tower",
    448: "Mt. Moon",
    449: "Mt. Moon",
    450: "Cerulean Cave",
    451: "Cerulean Cave",
    452: "Rock Tunnel",
    453: "Seafoam Islands",
    454: "Seafoam Islands",
    455: "Seafoam Islands",
    456: "Seafoam Islands",
    457: "Seafoam Islands",
    458: "Seafoam Islands",
    459: "Mt. Silver Cave",
    460: "Mt. Silver Cave",
    461: "Mt. Silver Cave",
    462: "Mt. Silver Cave",
    463: "Mt. Silver Cave",
    464: "Mt. Silver Cave",
    465: "Mt. Silver Cave",
    466: "Route 10",
    467: "Power Plant",
    468: "Route 5",
    469: "Route 5",
    470: "Route 6",
    471: "Pewter City",
    472: "Pewter City",
    473: "Pewter City",
    474: "Pewter City",
    475: "Pewter City",
    476: "Pewter City",
    477: "Pewter City",
    478: "Fuchsia City",
    479: "Pal Park",
    480: "Fuchsia City",
    481: "Fuchsia City",
    482: "Fuchsia City",
    483: "Fuchsia City",
    484: "Route 10",
    485: "Fuchsia City",
    486: "Whirl Islands",
    487: "National Park",
    488: "National Park",
    489: "Power Plant",
    490: "Ruins of Alph",
    491: "Ruins of Alph",
    492: "Ruins of Alph",
    493: "Route 7",
    494: "Lavender Town",
    495: "Cerulean City",
    496: "Viridian City",
    497: "Viridian City",
    498: "Viridian City",
    499: "Viridian City",
    500: "Viridian City",
    501: "Viridian City",
    502: "Viridian City",
    503: "Pallet Town",
    504: "Pallet Town",
    505: "Pallet Town",
    506: "Pallet Town",
    507: "Pallet Town",
    508: "Cinnabar Island",
    509: "Cinnabar Island",
    510: "Route 28",
    511: "Route 3",
    512: "Route 3",
    513: "Mt. Moon",
    514: "Mt. Silver",
    515: "Mt. Silver",
    516: "Wifi Plaza",
    517: "Route 5",
    518: "Mt. Moon",
    519: "Goldenrod City",
    520: "Saffron City",
    521: "Sinjoh Ruins",
    522: "Sinjoh Ruins",
    523: "Sinjoh Ruins",
    524: "Embedded Tower",
    525: "Embedded Tower",
    526: "Embedded Tower",
    527: "Route 1",
    528: "Frontier Access",
    529: "Frontier Access",
    530: "Frontier Access",
    531: "Frontier Access",
    532: "Route 5",
    533: "Route 12",
    534: "Safari Zone",
    535: "Safari Zone",
    536: "Goldenrod Game Corner",
    537: "Celadon Game Corner",
    538: "Unused",
    539: "Pokemon League",
}
//*=in a Mystery Zone

PkmnLookup = {
1: "Bulbasaur",
2: "Ivysaur",
3: "Venusaur",
4: "Charmander",
5: "Charmeleon",
6: "Charizard",
7: "Squirtle",
8: "Wartortle",
9: "Blastoise",
10: "Caterpie",
11: "Metapod",
12: "Butterfree",
13: "Weedle",
14: "Kakuna",
15: "Beedrill",
16: "Pidgey",
17: "Pidgeotto",
18: "Pidgeot",
19: "Rattata",
20: "Raticate",
21: "Spearow",
22: "Fearow",
23: "Ekans",
24: "Arbok",
25: "Pikachu",
26: "Raichu",
27: "Sandshrew",
28: "Sandslash",
29: "Nidoran",
30: "Nidorina",
31: "Nidoqueen",
32: "Nidoran",
33: "Nidorino",
34: "Nidoking",
35: "Clefairy",
36: "Clefable",
37: "Vulpix",
38: "Ninetales",
39: "Jigglypuff",
40: "Wigglytuff",
41: "Zubat",
42: "Golbat",
43: "Oddish",
44: "Gloom",
45: "Vileplume",
46: "Paras",
47: "Parasect",
48: "Venonat",
49: "Venomoth",
50: "Diglett",
51: "Dugtrio",
52: "Meowth",
53: "Persian",
54: "Psyduck",
55: "Golduck",
56: "Mankey",
57: "Primeape",
58: "Growlithe",
59: "Arcanine",
60: "Poliwag",
61: "Poliwhirl",
62: "Poliwrath",
63: "Abra",
64: "Kadabra",
65: "Alakazam",
66: "Machop",
67: "Machoke",
68: "Machamp",
69: "Bellsprout",
70: "Weepinbell",
71: "Victreebel",
72: "Tentacool",
73: "Tentacruel",
74: "Geodude",
75: "Graveler",
76: "Golem",
77: "Ponyta",
78: "Rapidash",
79: "Slowpoke",
80: "Slowbro",
81: "Magnemite",
82: "Magneton",
83: "Farfetchd",
84: "Doduo",
85: "Dodrio",
86: "Seel",
87: "Dewgong",
88: "Grimer",
89: "Muk",
90: "Shellder",
91: "Cloyster",
92: "Gastly",
93: "Haunter",
94: "Gengar",
95: "Onix",
96: "Drowzee",
97: "Hypno",
98: "Krabby",
99: "Kingler",
100: "Voltorb",
101: "Electrode",
102: "Exeggcute",
103: "Exeggutor",
104: "Cubone",
105: "Marowak",
106: "Hitmonlee",
107: "Hitmonchan",
108: "Lickitung",
109: "Koffing",
110: "Weezing",
111: "Rhyhorn",
112: "Rhydon",
113: "Chansey",
114: "Tangela",
115: "Kangaskhan",
116: "Horsea",
117: "Seadra",
118: "Goldeen",
119: "Seaking",
120: "Staryu",
121: "Starmie",
122: "Mr Mime",
123: "Scyther",
124: "Jynx",
125: "Electabuzz",
126: "Magmar",
127: "Pinsir",
128: "Tauros",
129: "Magikarp",
130: "Gyarados",
131: "Lapras",
132: "Ditto",
133: "Eevee",
134: "Vaporeon",
135: "Jolteon",
136: "Flareon",
137: "Porygon",
138: "Omanyte",
139: "Omastar",
140: "Kabuto",
141: "Kabutops",
142: "Aerodactyl",
143: "Snorlax",
144: "Articuno",
145: "Zapdos",
146: "Moltres",
147: "Dratini",
148: "Dragonair",
149: "Dragonite",
150: "Mewtwo",
151: "Mew",
152: "Chikorita",
153: "Bayleef",
154: "Meganium",
155: "Cyndaquil",
156: "Quilava",
157: "Typhlosion",
158: "Totodile",
159: "Croconaw",
160: "Feraligatr",
161: "Sentret",
162: "Furret",
163: "Hoothoot",
164: "Noctowl",
165: "Ledyba",
166: "Ledian",
167: "Spinarak",
168: "Ariados",
169: "Crobat",
170: "Chinchou",
171: "Lanturn",
172: "Pichu",
173: "Cleffa",
174: "Igglybuff",
175: "Togepi",
176: "Togetic",
177: "Natu",
178: "Xatu",
179: "Mareep",
180: "Flaaffy",
181: "Ampharos",
182: "Bellossom",
183: "Marill",
184: "Azumarill",
185: "Sudowoodo",
186: "Politoed",
187: "Hoppip",
188: "Skiploom",
189: "Jumpluff",
190: "Aipom",
191: "Sunkern",
192: "Sunflora",
193: "Yanma",
194: "Wooper",
195: "Quagsire",
196: "Espeon",
197: "Umbreon",
198: "Murkrow",
199: "Slowking",
200: "Misdreavus",
201: "Unown",
202: "Wobbuffet",
203: "Girafarig",
204: "Pineco",
205: "Forretress",
206: "Dunsparce",
207: "Gligar",
208: "Steelix",
209: "Snubbull",
210: "Granbull",
211: "Qwilfish",
212: "Scizor",
213: "Shuckle",
214: "Heracross",
215: "Sneasel",
216: "Teddiursa",
217: "Ursaring",
218: "Slugma",
219: "Magcargo",
220: "Swinub",
221: "Piloswine",
222: "Corsola",
223: "Remoraid",
224: "Octillery",
225: "Delibird",
226: "Mantine",
227: "Skarmory",
228: "Houndour",
229: "Houndoom",
230: "Kingdra",
231: "Phanpy",
232: "Donphan",
233: "Porygon2",
234: "Stantler",
235: "Smeargle",
236: "Tyrogue",
237: "Hitmontop",
238: "Smoochum",
239: "Elekid",
240: "Magby",
241: "Miltank",
242: "Blissey",
243: "Raikou",
244: "Entei",
245: "Suicune",
246: "Larvitar",
247: "Pupitar",
248: "Tyranitar",
249: "Lugia",
250: "Ho Oh",
251: "Celebi",
252: "Treecko",
253: "Grovyle",
254: "Sceptile",
255: "Torchic",
256: "Combusken",
257: "Blaziken",
258: "Mudkip",
259: "Marshtomp",
260: "Swampert",
261: "Poochyena",
262: "Mightyena",
263: "Zigzagoon",
264: "Linoone",
265: "Wurmple",
266: "Silcoon",
267: "Beautifly",
268: "Cascoon",
269: "Dustox",
270: "Lotad",
271: "Lombre",
272: "Ludicolo",
273: "Seedot",
274: "Nuzleaf",
275: "Shiftry",
276: "Taillow",
277: "Swellow",
278: "Wingull",
279: "Pelipper",
280: "Ralts",
281: "Kirlia",
282: "Gardevoir",
283: "Surskit",
284: "Masquerain",
285: "Shroomish",
286: "Breloom",
287: "Slakoth",
288: "Vigoroth",
289: "Slaking",
290: "Nincada",
291: "Ninjask",
292: "Shedinja",
293: "Whismur",
294: "Loudred",
295: "Exploud",
296: "Makuhita",
297: "Hariyama",
298: "Azurill",
299: "Nosepass",
300: "Skitty",
301: "Delcatty",
302: "Sableye",
303: "Mawile",
304: "Aron",
305: "Lairon",
306: "Aggron",
307: "Meditite",
308: "Medicham",
309: "Electrike",
310: "Manectric",
311: "Plusle",
312: "Minun",
313: "Volbeat",
314: "Illumise",
315: "Roselia",
316: "Gulpin",
317: "Swalot",
318: "Carvanha",
319: "Sharpedo",
320: "Wailmer",
321: "Wailord",
322: "Numel",
323: "Camerupt",
324: "Torkoal",
325: "Spoink",
326: "Grumpig",
327: "Spinda",
328: "Trapinch",
329: "Vibrava",
330: "Flygon",
331: "Cacnea",
332: "Cacturne",
333: "Swablu",
334: "Altaria",
335: "Zangoose",
336: "Seviper",
337: "Lunatone",
338: "Solrock",
339: "Barboach",
340: "Whiscash",
341: "Corphish",
342: "Crawdaunt",
343: "Baltoy",
344: "Claydol",
345: "Lileep",
346: "Cradily",
347: "Anorith",
348: "Armaldo",
349: "Feebas",
350: "Milotic",
351: "Castform",
352: "Kecleon",
353: "Shuppet",
354: "Banette",
355: "Duskull",
356: "Dusclops",
357: "Tropius",
358: "Chimecho",
359: "Absol",
360: "Wynaut",
361: "Snorunt",
362: "Glalie",
363: "Spheal",
364: "Sealeo",
365: "Walrein",
366: "Clamperl",
367: "Huntail",
368: "Gorebyss",
369: "Relicanth",
370: "Luvdisc",
371: "Bagon",
372: "Shelgon",
373: "Salamence",
374: "Beldum",
375: "Metang",
376: "Metagross",
377: "Regirock",
378: "Regice",
379: "Registeel",
380: "Latias",
381: "Latios",
382: "Kyogre",
383: "Groudon",
384: "Rayquaza",
385: "Jirachi",
386: "Deoxys",
387: "Turtwig",
388: "Grotle",
389: "Torterra",
390: "Chimchar",
391: "Monferno",
392: "Infernape",
393: "Piplup",
394: "Prinplup",
395: "Empoleon",
396: "Starly",
397: "Staravia",
398: "Staraptor",
399: "Bidoof",
400: "Bibarel",
401: "Kricketot",
402: "Kricketune",
403: "Shinx",
404: "Luxio",
405: "Luxray",
406: "Budew",
407: "Roserade",
408: "Cranidos",
409: "Rampardos",
410: "Shieldon",
411: "Bastiodon",
412: "Burmy",
413: "Wormadam",
414: "Mothim",
415: "Combee",
416: "Vespiquen",
417: "Pachirisu",
418: "Buizel",
419: "Floatzel",
420: "Cherubi",
421: "Cherrim",
422: "Shellos",
423: "Gastrodon",
424: "Ambipom",
425: "Drifloon",
426: "Drifblim",
427: "Buneary",
428: "Lopunny",
429: "Mismagius",
430: "Honchkrow",
431: "Glameow",
432: "Purugly",
433: "Chingling",
434: "Stunky",
435: "Skuntank",
436: "Bronzor",
437: "Bronzong",
438: "Bonsly",
439: "Mime Jr",
440: "Happiny",
441: "Chatot",
442: "Spiritomb",
443: "Gible",
444: "Gabite",
445: "Garchomp",
446: "Munchlax",
447: "Riolu",
448: "Lucario",
449: "Hippopotas",
450: "Hippowdon",
451: "Skorupi",
452: "Drapion",
453: "Croagunk",
454: "Toxicroak",
455: "Carnivine",
456: "Finneon",
457: "Lumineon",
458: "Mantyke",
459: "Snover",
460: "Abomasnow",
461: "Weavile",
462: "Magnezone",
463: "Lickilicky",
464: "Rhyperior",
465: "Tangrowth",
466: "Electivire",
467: "Magmortar",
468: "Togekiss",
469: "Yanmega",
470: "Leafeon",
471: "Glaceon",
472: "Gliscor",
473: "Mamoswine",
474: "Porygon Z",
475: "Gallade",
476: "Probopass",
477: "Dusknoir",
478: "Froslass",
479: "Rotom",
480: "Uxie",
481: "Mesprit",
482: "Azelf",
483: "Dialga",
484: "Palkia",
485: "Heatran",
486: "Regigigas",
487: "Giratina",
488: "Cresselia",
489: "Phione",
490: "Manaphy",
491: "Darkrai",
492: "Shaymin",
493: "Arceus"
}

TrainerLookupS = {
    15: "",
    116: "",
    217: "",
    301: "",
    310: "",
    312: "",
    468: "",
    539: "",
    552: "",
    568: "",
    586: "",
    698: ""
}

TrainerLookup = {
    0: "---",
	1: "Rival Silver",
	2: "Rival Silver",
	3: "Rival Silver",
	4: "Bug Catcher Wade",
	5: "Beauty Victoria",
	6: "Policeman Keith",
	7: "Juggler Irwin",
	8: "Youngster Joey",
	9: "Swimmer Elaine",
	10: "Twins Amy & Mimi",
	11: "Kimono Girl Mickey",
	12: "Team Rocket Grunt",
	13: "Team Rocket Grunt",
	14: "Burglar Duncan",
	15: "Firebreather Otis",
	16: "Swimmer Simon",
	17: "Black Belt Kenji",
	18: "Fisherman Justin",
	19: "Biker Mickey",
	20: "Leader Falkner",
	21: "Leader Bugsy",
	22: "Lass Carrie",
	23: "Poké Maniac Larry",
	24: "School Kid Alan",
	25: "Hiker Russel",
	26: "Camper Roland",
	27: "Picknicker Liz",
	28: "Ace Trainer Jake",
	29: "Bird Keeper Rod",
	30: "Leader Whitney",
	31: "Leader Morty",
	32: "Leader Pryce",
	33: "Leader Jasmine",
	34: "Leader Chuck",
	35: "Leader Clair",
	36: "Ace Trainer Joyce",
	37: "Gentleman Preston",
	38: "Teacher Colette",
	39: "Sailor Eugene",
	40: "Super Nerd Mickey",
	41: "Guitarist Clyde",
	42: "Psychic Nathan",
	43: "Sage Chow",
	44: "Pokéfan Derek",
	45: "Pokéfan Ruth",
	46: "Medium Martha",
	47: "Youngster Mikey",
	48: "Bug Catcher Rob",
	49: "Youngster Albert",
	50: "Bird Keeper Abe",
	51: "Sage Nico",
	52: "Sage Edmond",
	53: "Sage Jin",
	54: "Sage Troy",
	55: "Sage Neal",
	56: "Youngster Gordon",
	57: "Fisherman Ralph",
	58: "Fisherman Arnold",
	59: "Fisherman Kyle",
	60: "Fisherman Henry",
	61: "Hiker Anthony",
	62: "Youngster Samuel",
	63: "Team Rocket Mickey",
	64: "Youngster Ian",
	65: "Picknicker Gina",
	66: "Camper Todd",
	67: "Bug Catcher Benny",
	68: "Bug Catcher Al",
	69: "Bug Catcher Josh",
	70: "Beauty Samantha",
	71: "Lass Cathy",
	72: "Bird Keeper Bryan",
	73: "Bird Keeper Theo",
	74: "Camper Ivan",
	75: "Camper Elliot",
	76: "Picknicker Brooke",
	77: "Picknicker Kim",
	78: "Bug Catcher Arnie",
	79: "Bug Catcher Ken",
	80: "Policeman Dirk",
	81: "Twins Tori & Til",
	82: "Bird Keeper Toby",
	83: "Picknicker Cindy",
	84: "Camper Barry",
	85: "Swimmer Paula",
	86: "Swimmer Randall",
	87: "Sage Mickey",
	88: "Sage Mickey",
	89: "Medium Grace",
	90: "Swimmer Kaylee",
	91: "Swimmer Susie",
	92: "Swimmer Denise",
	93: "Swimmer Kara",
	94: "Swimmer Wendy",
	95: "Swimmer Charlie",
	96: "Swimmer George",
	97: "Swimmer Berke",
	98: "Swimmer Ronald",
	99: "Swimmer Matthew",
	100: "Hiker Anthony",
	101: "Team Rocket Grunt",
	102: "Ace Trainer Gaven",
	103: "Ace Trainer Blake",
	104: "Ace Trainer Brian",
	105: "Ace Trainer Mickey",
	106: "Ace Trainer Mickey",
	107: "Ace Trainer Mickey",
	108: "Ace Trainer Ryan",
	109: "Ace Trainer Alton",
	110: "Ace Trainer Paulo",
	111: "Ace Trainer Mike",
	112: "Ace Trainer Cody",
	113: "Ace Trainer Jamie",
	114: "Ace Trainer Reena",
	115: "Ace Trainer Megan",
	116: "Ace Trainer Lois",
	117: "Ace Trainer Lola",
	118: "Ace Trainer Kate",
	119: "Ace Trainer Fran",
	120: "Ace Trainer Irene",
	121: "Ace Trainer Kelly",
	122: "Fisherman Marvin",
	123: "Fisherman Tully",
	124: "Fisherman Wilton",
	125: "Fisherman Edgar",
	126: "Fisherman Andre",
	127: "Fisherman Raymond",
	128: "Fisherman Jonah",
	129: "Poké Maniac Shane",
	130: "Poké Maniac Beckett",
	131: "Poké Maniac Brent",
	132: "Poké Maniac Ron",
	133: "Poké Maniac Morgan",
	134: "Hiker Benjamin",
	135: "School Kid Johnny",
	136: "Lass Linda",
	137: "Bird Keeper Vance",
	138: "Camper Mickey",
	139: "Picknicker Debra",
	140: "Bug Catcher Doug",
	141: "Camper Mickey",
	142: "Picknicker Gina",
	143: "Hiker Erik",
	144: "Hiker Michael",
	145: "Hiker Parry",
	146: "Hiker Timothy",
	147: "Camper Ted",
	148: "Camper Lloyd",
	149: "Camper Dean",
	150: "Camper Sid",
	151: "Picknicker Erin",
	152: "Picknicker Hope",
	153: "Picknicker Sharon",
	154: "Hiker Bailey",
	155: "Hiker Anthony",
	156: "Black Belt Yoshi",
	157: "Black Belt Lao",
	158: "Black Belt Kiyo",
	159: "Black Belt Lung",
	160: "Kimono Girl Naoko",
	161: "Kimono Girl Sayo",
	162: "Kimono Girl Zuki",
	163: "Kimono Girl Kuni",
	164: "Kimono Girl Miki",
	165: "Swimmer Mickey",
	166: "Swimmer Mickey",
	167: "Swimmer Mickey",
	168: "Swimmer Mickey",
	169: "Swimmer Mickey",
	170: "Swimmer Mickey",
	171: "Swimmer Mickey",
	172: "Poké Maniac Brent",
	173: "Poké Maniac Brent",
	174: "Biker Mickey",
	175: "Medium Bethany",
	176: "Medium Margaret",
	177: "Medium Ethel",
	178: "School Kid Jack",
	179: "School Kid Kipp",
	180: "Beauty Mickey",
	181: "Pokéfan William",
	182: "Pokéfan Beverly",
	183: "Lass Alice",
	184: "Lass Krise",
	185: "Team Rocket Grunt",
	186: "Team Rocket Grunt",
	187: "Team Rocket Grunt",
	188: "Team Rocket Grunt",
	189: "Team Rocket Grunt",
	190: "Team Rocket Grunt",
	191: "Team Rocket Grunt",
	192: "Team Rocket Grunt",
	193: "Team Rocket Grunt",
	194: "Team Rocket Mickey",
	195: "Team Rocket Grunt",
	196: "Team Rocket Grunt",
	197: "Team Rocket Grunt",
	198: "Team Rocket Grunt",
	199: "Team Rocket Grunt",
	200: "Team Rocket Grunt",
	201: "Poké Maniac Andrew",
	202: "Poké Maniac Calvin",
	203: "Hiker Phillip",
	204: "Hiker Leonard",
	205: "Ace Trainer Nick",
	206: "Ace Trainer Gwen",
	207: "Beauty Mickey",
	208: "Beauty Mickey",
	209: "Beauty Cassie",
	210: "Beauty Caroline",
	211: "Sailor Huey",
	212: "Sailor Terrell",
	213: "Sailor Kent",
	214: "Sailor Roberto",
	215: "Lass Connie",
	216: "Team Rocket Grunt",
	217: "Bird Keeper Denis",
	218: "Team Rocket Grunt",
	219: "Team Rocket Grunt",
	220: "Team Rocket Grunt",
	221: "Team Rocket Mickey",
	222: "Team Rocket Grunt",
	223: "Team Rocket Grunt",
	224: "Team Rocket Grunt",
	225: "Team Rocket Mickey",
	226: "Team Rocket Mickey",
	227: "Team Rocket Grunt",
	228: "Team Rocket Grunt",
	229: "Team Rocket Mickey",
	230: "Psychic Franklin",
	231: "Gentleman Edward",
	232: "Guitarist Vincent",
	233: "Super Nerd Eric",
	234: "Hiker Eoin",
	235: "Hiker Noland",
	236: "Ace Trainer Shaye",
	237: "Ace Trainer Carol",
	238: "Sailor Stanly",
	239: "Sailor Jeff",
	240: "Sailor Garrett",
	241: "Sailor Kenneth",
	242: "Juggler Fritz",
	243: "Swimmer Katie",
	244: "Champion Lance",
	245: "Elite Four Will",
	246: "Elite Four Karen",
	247: "Elite Four Koga",
	248: "Bug Catcher Ed",
	249: "Bug Catcher Don",
	250: "Black Belt Kenji",
	251: "Black Belt Nob",
	252: "Swimmer Harold",
	253: "Leader Brock",
	254: "Leader Misty",
	255: "Leader Lt. Surge",
	256: "Leader Erika",
	257: "Leader Janine",
	258: "Leader Sabrina",
	259: "Leader Blaine",
	260: "Trainer Red",
	261: "Leader Blue",
	262: "Team Rocket Mickey",
	263: "Rival Silver",
	264: "Rival Silver",
	265: "Rival Silver",
	266: "Rival Silver",
	267: "Rival Silver",
	268: "Rival Silver",
	269: "Rival Silver",
	270: "Rival Silver",
	271: "Rival Silver",
	272: "Rival Silver",
	273: "Swimmer Mickey",
	274: "Camper Todd",
	275: "Camper Todd",
	276: "Picknicker Liz",
	277: "Picknicker Liz",
	278: "Black Belt Kenji",
	279: "Youngster Joey",
	280: "Youngster Joey",
	281: "Firebreather Richard",
	282: "Firebreather Ned",
	283: "Burglar Orson",
	284: "Burglar Corey",
	285: "Rival Silver",
	286: "Rival Silver",
	287: "Rival Silver",
	288: "Rival Silver",
	289: "Rival Silver",
	290: "Elder Li",
	291: "Swimmer Debbie",
	292: "Swimmer Mickey",
	293: "Swimmer Nicole",
	294: "Swimmer Lori",
	295: "Swimmer Mickey",
	296: "Swimmer Nikki",
	297: "Swimmer Diana",
	298: "Swimmer Briana",
	299: "Bird Keeper Hank",
	300: "Bird Keeper Roy",
	301: "Bird Keeper Boris",
	302: "Bird Keeper Bob",
	303: "Bird Keeper Jose",
	304: "Camper Mickey",
	305: "Camper Mickey",
	306: "Camper Mickey",
	307: "Camper Mickey",
	308: "Camper Jerry",
	309: "Biker Dwayne",
	310: "Biker Harris",
	311: "Biker Zeke",
	312: "Biker Charles",
	313: "Biker Reese",
	314: "Biker Joel",
	315: "Biker Glenn",
	316: "Psychic Herman",
	317: "Psychic Fidel",
	318: "Firebreather Burt",
	319: "Firebreather Bill",
	320: "Fisherman Martin",
	321: "Fisherman Stephen",
	322: "Fisherman Barney",
	323: "Fisherman Tully",
	324: "Fisherman Tully",
	325: "Fisherman Wilton",
	326: "Twins Jo & Zoe",
	327: "School Kid Danny",
	328: "School Kid Tommy",
	329: "School Kid Dudley",
	330: "School Kid Joe",
	331: "School Kid Billy",
	332: "Picknicker Heidi",
	333: "Picknicker Edna",
	334: "Picknicker Gina",
	335: "Picknicker Erin",
	336: "Picknicker Tanya",
	337: "Gentleman Gregory",
	338: "Gentleman Mickey",
	339: "Black Belt Wai",
	340: "Beauty Mickey",
	341: "Beauty Mickey",
	342: "Beauty Mickey",
	343: "Beauty Mickey",
	344: "Beauty Mickey",
	345: "Beauty Mickey",
	346: "Beauty Julia",
	347: "Beauty Mickey",
	348: "Pokéfan Robert",
	349: "Pokéfan Joshua",
	350: "Pokéfan Carter",
	351: "Pokéfan Trevor",
	352: "Pokéfan Georgia",
	353: "Team Rocket Grunt",
	354: "Lass Laura",
	355: "Lass Shannon",
	356: "Lass Michelle",
	357: "Hiker Clarke",
	358: "Hiker Kenny",
	359: "Hiker Jim",
	360: "Bug Catcher Arnie",
	361: "Ace Trainer Kevin",
	362: "Ace Trainer Quinn",
	363: "Ace Trainer Emma",
	364: "Super Nerd Sam",
	365: "Super Nerd Tyrone",
	366: "Super Nerd Pat",
	367: "Super Nerd Shawn",
	368: "Medium Rebecca",
	369: "Medium Darcy",
	370: "Swimmer Jerome",
	371: "Swimmer Tucker",
	372: "Swimmer Mickey",
	373: "Swimmer Frankie",
	374: "Swimmer Tyson",
	375: "Swimmer Mickey",
	376: "Swimmer Mickey",
	377: "Swimmer Parker",
	378: "Youngster Warren",
	379: "Youngster Jimmy",
	380: "Youngster Owen",
	381: "Youngster Jason",
	382: "Teacher Hillary",
	383: "Bird Keeper Peter",
	384: "Hiker Daniel",
	385: "Twins Dara & Dia",
	386: "Psychic Greg",
	387: "Twins Amy & Mimi",
	388: "Firebreather Walt",
	389: "Psychic Nelson",
	390: "Firebreather Ray",
	391: "Poké Maniac Issac",
	392: "Poké Maniac Donald",
	393: "Super Nerd Teru",
	394: "Ace Trainer Mickey",
	395: "Psychic Mark",
	396: "Juggler Horton",
	397: "School Kid Chad",
	398: "Beauty Valerie",
	399: "Firebreather Lyle",
	400: "Lass Dana",
	401: "Gentleman Alfred",
	402: "Picknicker Tiffany",
	403: "Camper Spencer",
	404: "Team Rocket Grunt",
	405: "Psychic Phil",
	406: "Poké Maniac Zach",
	407: "Ace Trainer Allen",
	408: "Ace Trainer Cybil",
	409: "Pokéfan Brandon",
	410: "Sailor Harry",
	411: "Psychic Vernon",
	412: "Psychic Eli",
	413: "Fisherman Scott",
	414: "Bird Keeper Jose",
	415: "Psychic Jared",
	416: "Twins Jo & Zoe",
	417: "Ace Trainer Jenn",
	418: "Elite Four Bruno",
	419: "Lass Ellen",
	420: "Bird Keeper Perry",
	421: "Bird Keeper Bret",
	422: "Psychic Rodney",
	423: "Pokéfan Jeremy",
	424: "Pokéfan Colin",
	425: "Twins Meg & Peg",
	426: "Twins Meg & Peg",
	427: "Teacher Shirley",
	428: "School Kid Nate",
	429: "School Kid Ricky",
	430: "School Kid Jack",
	431: "School Kid Jack",
	432: "School Kid Alan",
	433: "School Kid Alan",
	434: "School Kid Chad",
	435: "School Kid Chad",
	436: "Pokéfan Beverly",
	437: "Pokéfan Beverly",
	438: "Pokéfan Derek",
	439: "Pokéfan Derek",
	440: "Sailor Huey",
	441: "Sailor Huey",
	442: "Lass Mickey",
	443: "Lass Mickey",
	444: "Ace Trainer Reena",
	445: "Ace Trainer Reena",
	446: "Bird Keeper Jose",
	447: "Bird Keeper Vance",
	448: "Bird Keeper Vance",
	449: "Bug Catcher Arnie",
	450: "Fisherman Wilton",
	451: "Hiker Parry",
	452: "Hiker Parry",
	453: "Picknicker Erin",
	454: "Juggler Irwin",
	455: "Juggler Irwin",
	456: "Ace Trainer Gaven",
	457: "Ace Trainer Gaven",
	458: "Ace Trainer Jamie",
	459: "Ace Trainer Jamie",
	460: "Bug Catcher Wade",
	461: "Bug Catcher Wade",
	462: "Fisherman Ralph",
	463: "Fisherman Ralph",
	464: "Lass Dana",
	465: "Lass Dana",
	466: "Picknicker Tiffany",
	467: "Picknicker Tiffany",
	468: "Scientist Ross",
	469: "Scientist Mitch",
	470: "Scientist Gregg",
	471: "Scientist Garett",
	472: "Scientist Trenton",
	473: "Super Nerd Mickey",
	474: "Super Nerd Mickey",
	475: "Super Nerd Mickey",
	476: "Super Nerd Mickey",
	477: "Super Nerd Mickey",
	478: "Executive Ariana",
	479: "Executive Ariana",
	480: "Skier Diana",
	481: "Skier Jill",
	482: "Boarder Deandre",
	483: "Boarder Patton",
	484: "Boarder Gerardo",
	485: "Executive Archer",
	486: "Executive Proton",
	487: "Executive Petrel",
	488: "Executive Petrel",
	489: "Rival Silver",
	490: "Rival Silver",
	491: "Rival Silver",
	492: "Pokéfan Alex",
	493: "Medium Edith",
	494: "Medium Georgina",
	495: "Passerby Boy",
	496: "Passerby Boy",
	497: "Passerby Boy",
	498: "Mystery Man Eusine",
	499: "Team Rocket Grunt",
	500: "Ace Trainer Kobe",
	501: "Ace Trainer Piper",
	502: "Twins Clea & Gil",
	503: "School Kid Jack",
	504: "School Kid Mickey",
	505: "School Kid Alan",
	506: "School Kid Mickey",
	507: "School Kid Chad",
	508: "School Kid Mickey",
	509: "Sailor Huey",
	510: "Youngster Joey",
	511: "Youngster Mickey",
	512: "Bug Catcher Wade",
	513: "Bug Catcher Arnie",
	514: "Bug Catcher Mickey",
	515: "Fisherman Ralph",
	516: "Fisherman Mickey",
	517: "Fisherman Tully",
	518: "Picknicker Liz",
	519: "Picknicker Mickey",
	520: "Picknicker Gina",
	521: "Picknicker Mickey",
	522: "Picknicker Tiffany",
	523: "Hiker Anthony",
	524: "Hiker Mickey",
	525: "Camper Todd",
	526: "Camper Mickey",
	527: "Juggler Irwin",
	528: "Lass Dana",
	529: "Lass Mickey",
	530: "Poké Maniac Brent",
	531: "Twins Mickey",
	532: "Bug Catcher Mickey",
	533: "Bug Catcher Wayne",
	534: "Beauty Kimberly",
	535: "Pokéfan Marigold",
	536: "Camper Bertrand",
	537: "Poké Maniac Harrison",
	538: "Super Nerd Hugh",
	539: "Super Nerd Markus",
	540: "Pokéfan Rex",
	541: "Pokéfan Andy",
	542: "Sage Mickey",
	543: "Sage Mickey",
	544: "Sage Mickey",
	545: "Ace Trainer French",
	546: "School Kid Sherman",
	547: "Hiker Bruce",
	548: "Black Belt Manford",
	549: "Double Team Zac & Jen",
	550: "Black Belt Ander",
	551: "Hiker Dwight",
	552: "Youngster Regis",
	553: "Young Couple Moe & Lulu",
	554: "Gentleman Milton",
	555: "Bird Keeper Justin",
	556: "Bird Keeper Gail",
	557: "Young Couple Vic & Tara",
	558: "Fisherman Kyler",
	559: "Young Couple Tim & Sue",
	560: "Camper Clark",
	561: "Camper Tanner",
	562: "Picknicker Piper",
	563: "Picknicker Ginger",
	564: "Teacher Clarice",
	565: "Bird Keeper Josh",
	566: "School Kid Connor",
	567: "School Kid Torin",
	568: "School Kid Travis",
	569: "Twins Kay & Tia",
	570: "Pokéfan Boone",
	571: "Pokéfan Eleanor",
	572: "Biker Dale",
	573: "Biker Jacob",
	574: "Biker Aiden",
	575: "Biker Dan",
	576: "Biker Theron",
	577: "Biker Markey",
	578: "Biker Teddy",
	579: "Biker Ernest",
	580: "Camper Pedro",
	581: "Picknicker Adrian",
	582: "Picknicker Cheyenne",
	583: "Bird Keeper Bert",
	584: "Bird Keeper Ernie",
	585: "Swimmer Elmo",
	586: "Swimmer Luis",
	587: "Swimmer Leona",
	588: "Swimmer Mina",
	589: "Fisherman Murphy",
	590: "Fisherman Liam",
	591: "Fisherman Gideon",
	592: "Swimmer Chelan",
	593: "Swimmer Kendra",
	594: "Swimmer Esteban",
	595: "Swimmer Duane",
	596: "Bird Keeper Kinsley",
	597: "Bird Keeper Easton",
	598: "Twins Day & Dani",
	599: "Camper Virgil",
	600: "Picknicker Selina",
	601: "Team Rocket Grunt",
	602: "Bird Keeper Jose",
	603: "Picknicker Erin",
	604: "Ace Trainer Gaven",
	605: "Black Belt Kenji",
	606: "Hiker Parry",
	607: "Ace Trainer Reena",
	608: "Fisherman Wilton",
	609: "Ace Trainer Jamie",
	610: "Pokéfan Derek",
	611: "Pokéfan Beverly",
	612: "Bird Keeper Vance",
	613: "Lass Krise",
	614: "Lass Krise",
	615: "Lass Krise",
	616: "Youngster Ian",
	617: "Youngster Ian",
	618: "Youngster Ian",
	619: "Firebreather Walt",
	620: "Firebreather Walt",
	621: "Firebreather Walt",
	622: "Bug Catcher Doug",
	623: "Bug Catcher Doug",
	624: "Bug Catcher Doug",
	625: "Bug Catcher Rob",
	626: "Bug Catcher Rob",
	627: "Bug Catcher Rob",
	628: "Biker Reese",
	629: "Biker Reese",
	630: "Biker Reese",
	631: "Biker Aiden",
	632: "Biker Aiden",
	633: "Biker Aiden",
	634: "Biker Ernest",
	635: "Biker Ernest",
	636: "Biker Ernest",
	637: "Teacher Hillary",
	638: "Teacher Hillary",
	639: "Teacher Hillary",
	640: "School Kid Billy",
	641: "School Kid Billy",
	642: "School Kid Billy",
	643: "Twins Kay & Tia",
	644: "Twins Kay & Tia",
	645: "Twins Kay & Tia",
	646: "Bird Keeper Josh",
	647: "Bird Keeper Josh",
	648: "Bird Keeper Josh",
	649: "School Kid Torin",
	650: "School Kid Torin",
	651: "School Kid Torin",
	652: "Young Couple Tim & Sue",
	653: "Young Couple Tim & Sue",
	654: "Young Couple Tim & Sue",
	655: "Hiker Kenny",
	656: "Hiker Kenny",
	657: "Hiker Kenny",
	658: "Camper Tanner",
	659: "Camper Tanner",
	660: "Camper Tanner",
	661: "Fisherman Kyle",
	662: "Fisherman Kyle",
	663: "Fisherman Kyle",
	664: "Fisherman Kyler",
	665: "Fisherman Kyler",
	666: "Fisherman Kyler",
	667: "Trainer Cheryl",
	668: "Trainer Marley",
	669: "Trainer Mira",
	670: "Trainer Riley",
	671: "Trainer Buck",
	672: "Gentleman Alfred",
	673: "Gentleman Alfred",
	674: "Gentleman Alfred",
	675: "Trainer Lance",
	676: "Sailor Parker",
	677: "Sailor Eddie",
	678: "Swimmer Joy",
	679: "Beauty Callie",
	680: "Beauty Kassandra",
	681: "Ace Trainer Arabella",
	682: "Ace Trainer Bonita",
	683: "Ace Trainer Salma",
	684: "Double Team Elan & Ida",
	685: "Hiker Edwin",
	686: "Boarder Bryce",
	687: "Boarder Shaun",
	688: "Skier Cady",
	689: "Super Nerd Cary",
	690: "Super Nerd Waldo",
	691: "Super Nerd Merle",
	692: "Scientist Lowell",
	693: "Scientist Linden",
	694: "Scientist Daniel",
	695: "Bug Catcher Dane",
	696: "Bug Catcher Dion",
	697: "Bug Catcher Stacey",
	698: "Bug Catcher Ellis",
	699: "Bug Catcher Abner",
	700: "Rocket Boss Giovanni",
	701: "Champion Lance",
	702: "Elite Four Will",
	703: "Elite Four Koga",
	704: "Elite Four Bruno",
	705: "Elite Four Karen",
	706: "Executive Proton",
	707: "Tower Tycoon Palmer",
	708: "Hall Matron Argenta",
	709: "Factory Head Thorton",
	710: "Arcade Star Dahlia",
	711: "Castle Valet Darach",
	712: "Leader Falkner",
	713: "Leader Bugsy",
	714: "Leader Whitney",
	715: "Leader Morty",
	716: "Leader Pryce",
	717: "Leader Jasmine",
	718: "Leader Chuck",
	719: "Leader Clair",
	720: "Leader Brock",
	721: "Leader Misty",
	722: "Leader Lt. Surge",
	723: "Leader Erika",
	724: "Leader Janine",
	725: "Leader Sabrina",
	726: "Leader Blaine",
	727: "Leader Blue",
	728: "Beauty Charlotte",
	729: "Young Couple Duff & Eda",
	730: "Double Team Thom & Kae",
	731: "Hiker Devin",
	732: "Camper Grant",
	733: "Champion Lance",
	734: "Leader Clair",
	735: "Rival Silver",
	736: "Rival Silver",
	737: "Rival Silver"
}

VAR_TEMP_x4000 = 0x4000
    VAR_TEMP_x4001 = 0x4001
    VAR_TEMP_x4002 = 0x4002
    VAR_TEMP_x4003 = 0x4003
    VAR_TEMP_x4004 = 0x4004
    VAR_TEMP_x4005 = 0x4005
    VAR_TEMP_x4006 = 0x4006
    VAR_TEMP_x4007 = 0x4007
    VAR_TEMP_x4008 = 0x4008
    VAR_TEMP_x4009 = 0x4009
    VAR_TEMP_x400A = 0x400A
    VAR_TEMP_x400B = 0x400B
    VAR_TEMP_x400C = 0x400C
    VAR_TEMP_x400D = 0x400D
    VAR_TEMP_x400E = 0x400E
    VAR_TEMP_x400F = 0x400F
    VAR_TEMP_x4010 = 0x4010
    VAR_TEMP_x4011 = 0x4011
    VAR_TEMP_x4012 = 0x4012
    VAR_BATTLE_RESULT = 0x4013
    VAR_TEMP_x4014 = 0x4014
    VAR_TEMP_x4015 = 0x4015
    VAR_TEMP_x4016 = 0x4016
    VAR_TEMP_x4017 = 0x4017
    VAR_TEMP_x4018 = 0x4018
    VAR_TEMP_x4019 = 0x4019
    VAR_TEMP_x401A = 0x401A
    VAR_TEMP_x401B = 0x401B
    VAR_TEMP_x401C = 0x401C
    VAR_TEMP_x401D = 0x401D
    VAR_TEMP_x401E = 0x401E
    VAR_TEMP_x401F = 0x401F
    VAR_OBJ_0 = 0x4020
    VAR_OBJ_1 = 0x4021
    VAR_OBJ_2 = 0x4022
    VAR_OBJ_3 = 0x4023
    VAR_OBJ_4 = 0x4024
    VAR_OBJ_5 = 0x4025
    VAR_OBJ_6 = 0x4026
    VAR_OBJ_7 = 0x4027
    VAR_OBJ_8 = 0x4028
    VAR_OBJ_9 = 0x4029
    VAR_OBJ_10 = 0x402A
    VAR_OBJ_11 = 0x402B
    VAR_OBJ_12 = 0x402C
    VAR_OBJ_13 = 0x402D
    VAR_OBJ_14 = 0x402E
    VAR_OBJ_15 = 0x402F
    VAR_PLAYER_STARTER = 0x4030
    VAR_UNK_4031 = 0x4031
    VAR_UNK_4032 = 0x4032
    VAR_BUENAS_PASSWORD_SET = 0x4033
    VAR_UNK_4034 = 0x4034
    VAR_MAGIKARP_SIZE_RECORD = 0x4035
    VAR_UNK_4036 = 0x4036
    VAR_UNK_4037 = 0x4037
    VAR_UNK_4038 = 0x4038
    VAR_UNK_4039 = 0x4039
    VAR_UNK_403A = 0x403A
    VAR_UNK_403B = 0x403B
    VAR_LOTO_NUMBER_LO = 0x403C
    VAR_LOTO_NUMBER_HI = 0x403D
    VAR_UNOWN_REPORT_LEVEL = 0x403E
    VAR_FOLLOWER_TRAINER_NUM = 0x403F
    VAR_UNK_4040 = 0x4040
    VAR_UNK_4041 = 0x4041
    VAR_UNK_4042 = 0x4042
    VAR_UNK_4043 = 0x4043
    VAR_UNK_4044 = 0x4044
    VAR_ROAMER_RAIKOU_STATUS = 0x4045
    VAR_ROAMER_ENTEI_STATUS = 0x4046
    VAR_ROAMER_LATIAS_STATUS = 0x4047
    VAR_ROAMER_LATIOS_STATUS = 0x4048
    VAR_UNK_4049 = 0x4049
    VAR_UNK_404A = 0x404A
    VAR_UNK_404B = 0x404B
    VAR_UNK_404C = 0x404C
    VAR_BATTLE_TOWER_PRINT_PROGRESS = 0x404D
    VAR_BATTLE_FACTORY_PRINT_PROGRESS = 0x404E
    VAR_BATTLE_HALL_PRINT_PROGRESS = 0x404F
    VAR_BATTLE_CASTLE_PRINT_PROGRESS = 0x4050
    VAR_BATTLE_ARCADE_PRINT_PROGRESS = 0x4051
    VAR_UNK_4052 = 0x4052
    VAR_UNK_4053 = 0x4053
    VAR_BATTLE_HALL_WIN_STREAK_LEVEL = 0x4054
    VAR_UNK_4055 = 0x4055
    VAR_UNK_4056 = 0x4056
    VAR_UNK_4057 = 0x4057
    VAR_BUG_CONTEST_HELD_PRIZE = 0x4058
    VAR_UNK_4059 = 0x4059
    VAR_UNK_405A = 0x405A
    VAR_UNK_405B = 0x405B
    VAR_UNK_405C = 0x405C
    VAR_UNK_405D = 0x405D
    VAR_UNK_405E = 0x405E
    VAR_UNK_405F = 0x405F
    VAR_UNK_4060 = 0x4060
    VAR_UNK_4061 = 0x4061
    VAR_UNK_4062 = 0x4062
    VAR_UNK_4063 = 0x4063
    VAR_UNK_4064 = 0x4064
    VAR_UNK_4065 = 0x4065
    VAR_UNK_4066 = 0x4066
    VAR_UNK_4067 = 0x4067
    VAR_UNK_4068 = 0x4068
    VAR_UNK_4069 = 0x4069
    VAR_UNK_406A = 0x406A
    VAR_UNK_406B = 0x406B
    VAR_UNK_406C = 0x406C
    VAR_UNK_406D = 0x406D
    VAR_UNK_406E = 0x406E
    VAR_UNK_406F = 0x406F
    VAR_UNK_4070 = 0x4070
    VAR_UNK_4071 = 0x4071
    VAR_SCENE_NEW_BARK_TOWN_OW = 0x4072
    VAR_SCENE_CHERRYGROVE_CITY_OW = 0x4073
    VAR_SCENE_VIOLET_CITY_OW = 0x4074
    VAR_UNK_4075 = 0x4075
    VAR_UNK_4076 = 0x4076
    VAR_SCENE_ROCKET_TAKEOVER = 0x4077
    VAR_UNK_4078 = 0x4078
    VAR_UNK_4079 = 0x4079
    VAR_UNK_407A = 0x407A
    VAR_UNK_407B = 0x407B
    VAR_UNK_407C = 0x407C
    VAR_UNK_407D = 0x407D
    VAR_SCENE_NEW_BARK_WEST_EXIT = 0x407E
    VAR_UNK_407F = 0x407F
    VAR_UNK_4080 = 0x4080
    VAR_SCENE_NEW_BARK_EAST_EXIT = 0x4081
    VAR_UNK_4082 = 0x4082
    VAR_UNK_4083 = 0x4083
    VAR_UNK_4084 = 0x4084
    VAR_UNK_4085 = 0x4085
    VAR_UNK_4086 = 0x4086
    VAR_SCENE_ROUTE_24_ROCKET = 0x4087
    VAR_UNK_4088 = 0x4088
    VAR_SCENE_ROUTE_25 = 0x4089
    VAR_UNK_408A = 0x408A
    VAR_UNK_408B = 0x408B
    VAR_SCENE_ROUTE_30_OW = 0x408C
    VAR_UNK_408D = 0x408D
    VAR_UNK_408E = 0x408E
    VAR_UNK_408F = 0x408F
    VAR_UNK_4090 = 0x4090
    VAR_UNK_4091 = 0x4091
    VAR_UNK_4092 = 0x4092
    VAR_UNK_4093 = 0x4093
    VAR_NUM_MET_WEEKDAY_SIBLINGS = 0x4094
    VAR_SCENE_ROUTE_30_PHONE_CALL = 0x4095
    VAR_UNK_4096 = 0x4096
    VAR_UNK_4097 = 0x4097
    VAR_UNK_4098 = 0x4098
    VAR_FARFETCHD1_STICKS1 = 0x4099
    VAR_FARFETCHD2_STICKS1 = 0x409A
    VAR_FARFETCHD1_STICKS2 = 0x409B
    VAR_FARFETCHD2_STICKS2 = 0x409C
    VAR_FARFETCHD2_STICKS3 = 0x409D
    VAR_FARFETCHD2_STICKS4 = 0x409E
    VAR_UNK_409F = 0x409F
    VAR_UNK_40A0 = 0x40A0
    VAR_UNK_40A1 = 0x40A1
    VAR_UNK_40A2 = 0x40A2
    VAR_UNK_40A3 = 0x40A3
    VAR_UNK_40A4 = 0x40A4
    VAR_SCENE_LIGHTHOUSE_JASMINE = 0x40A5
    VAR_UNK_40A6 = 0x40A6
    VAR_UNK_40A7 = 0x40A7
    VAR_UNK_40A8 = 0x40A8
    VAR_UNK_40A9 = 0x40A9
    VAR_UNK_40AA = 0x40AA
    VAR_UNK_40AB = 0x40AB
    VAR_UNK_40AC = 0x40AC
    VAR_UNK_40AD = 0x40AD
    VAR_UNK_40AE = 0x40AE
    VAR_UNK_40AF = 0x40AF
    VAR_UNK_40B0 = 0x40B0
    VAR_UNK_40B1 = 0x40B1
    VAR_ROCKET_TRAP_KOFFING_1 = 0x40B2
    VAR_ROCKET_TRAP_VOLTORB_1 = 0x40B3
    VAR_ROCKET_TRAP_GEODUDE_1 = 0x40B4
    VAR_ROCKET_TRAP_VOLTORB_2 = 0x40B5
    VAR_ROCKET_TRAP_GEODUDE_2 = 0x40B6
    VAR_ROCKET_TRAP_VOLTORB_3 = 0x40B7
    VAR_ROCKET_TRAP_VOLTORB_4 = 0x40B8
    VAR_ROCKET_TRAP_KOFFING_2 = 0x40B9
    VAR_ROCKET_TRAP_KOFFING_3 = 0x40BA
    VAR_ROCKET_TRAP_GEODUDE_3 = 0x40BB
    VAR_ROCKET_TRAP_GEODUDE_4 = 0x40BC
    VAR_ROCKET_TRAP_KOFFING_4 = 0x40BD
    VAR_ROCKET_TRAP_VOLTORB_5 = 0x40BE
    VAR_ROCKET_TRAP_VOLTORB_6 = 0x40BF
    VAR_ROCKET_TRAP_KOFFING_5 = 0x40C0
    VAR_ROCKET_TRAP_GEODUDE_5 = 0x40C1
    VAR_UNK_40C2 = 0x40C2
    VAR_UNK_40C3 = 0x40C3
    VAR_UNK_40C4 = 0x40C4
    VAR_UNK_40C5 = 0x40C5
    VAR_UNK_40C6 = 0x40C6
    VAR_UNK_40C7 = 0x40C7
    VAR_UNK_40C8 = 0x40C8
    VAR_UNK_40C9 = 0x40C9
    VAR_UNK_40CA = 0x40CA
    VAR_UNK_40CB = 0x40CB
    VAR_UNK_40CC = 0x40CC
    VAR_UNK_40CD = 0x40CD
    VAR_UNK_40CE = 0x40CE
    VAR_UNK_40CF = 0x40CF
    VAR_UNK_40D0 = 0x40D0
    VAR_UNK_40D1 = 0x40D1
    VAR_UNK_40D2 = 0x40D2
    VAR_UNK_40D3 = 0x40D3
    VAR_UNK_40D4 = 0x40D4
    VAR_UNK_40D5 = 0x40D5
    VAR_UNK_40D6 = 0x40D6
    VAR_UNK_40D7 = 0x40D7
    VAR_UNK_40D8 = 0x40D8
    VAR_UNK_40D9 = 0x40D9
    VAR_UNK_40DA = 0x40DA
    VAR_UNK_40DB = 0x40DB
    VAR_UNK_40DC = 0x40DC
    VAR_UNK_40DD = 0x40DD
    VAR_UNK_40DE = 0x40DE
    VAR_UNK_40DF = 0x40DF
    VAR_UNK_40E0 = 0x40E0
    VAR_BOAT_DIRECTION = 0x40E1
    VAR_UNK_40E2 = 0x40E2
    VAR_SCENE_SAFARI_ZONE_ENTRANCE = 0x40E3
    VAR_UNK_40E4 = 0x40E4
    VAR_UNK_40E5 = 0x40E5
    VAR_UNK_40E6 = 0x40E6
    VAR_UNK_40E7 = 0x40E7
    VAR_UNK_40E8 = 0x40E8
    VAR_UNK_40E9 = 0x40E9
    VAR_UNK_40EA = 0x40EA
    VAR_UNK_40EB = 0x40EB
    VAR_UNK_40EC = 0x40EC
    VAR_UNK_40ED = 0x40ED
    VAR_UNK_40EE = 0x40EE
    VAR_UNK_40EF = 0x40EF
    VAR_UNK_40F0 = 0x40F0
    VAR_UNK_40F1 = 0x40F1
    VAR_UNK_40F2 = 0x40F2
    VAR_UNK_40F3 = 0x40F3
    VAR_UNK_40F4 = 0x40F4
    VAR_UNK_40F5 = 0x40F5
    VAR_UNK_40F6 = 0x40F6
    VAR_UNK_40F7 = 0x40F7
    VAR_UNK_40F8 = 0x40F8
    VAR_SCENE_EMBEDDED_TOWER = 0x40F9
    VAR_UNK_40FA = 0x40FA
    VAR_SCENE_SINJOH_MYSTRI_ROOM = 0x40FB
    VAR_UNK_40FC = 0x40FC
    VAR_UNK_40FD = 0x40FD
    VAR_UNK_40FE = 0x40FE
    VAR_UNK_40FF = 0x40FF
    VAR_UNK_4100 = 0x4100
    VAR_UNK_4101 = 0x4101
    VAR_UNK_4102 = 0x4102
    VAR_UNK_4103 = 0x4103
    VAR_UNK_4104 = 0x4104
    VAR_UNK_4105 = 0x4105
    VAR_SCENE_PLAYERS_HOUSE_1F = 0x4106
    VAR_SCENE_MR_POKEMONS_HOUSE = 0x4107
    VAR_SCENE_ELMS_LAB = 0x4108
    VAR_UNK_4109 = 0x4109
    VAR_UNK_410A = 0x410A
    VAR_UNK_410B = 0x410B
    VAR_UNK_410C = 0x410C
    VAR_UNK_410D = 0x410D
    VAR_UNK_410E = 0x410E
    VAR_UNK_410F = 0x410F
    VAR_UNK_4110 = 0x4110
    VAR_UNK_4111 = 0x4111
    VAR_UNK_4112 = 0x4112
    VAR_ELEVATOR_LAST_FLOOR = 0x4113
    VAR_LOAN_SPEAROW = 0x4114
    VAR_NUM_TIMES_GIVEN_BLUE_CARD = 0x4115
    VAR_UNK_4116 = 0x4116
    VAR_SCENE_POKECENTER_WIFI_BASEMENT = 0x4117
    VAR_UNK_4118 = 0x4118
    VAR_UNK_4119 = 0x4119
    VAR_UNK_411A = 0x411A
    VAR_SCENE_ROUTE_10_POWER_PLANT = 0x411B
    VAR_UNK_411C = 0x411C
    VAR_UNK_411D = 0x411D
    VAR_UNK_411E = 0x411E
    VAR_UNK_411F = 0x411F
    VAR_UNK_4120 = 0x4120
    VAR_UNK_4121 = 0x4121
    VAR_UNK_4122 = 0x4122
    VAR_PAL_PARK_HIGH_SCORE = 0x4123
    VAR_UNK_4124 = 0x4124
    VAR_UNK_4125 = 0x4125
    VAR_UNK_4126 = 0x4126
    VAR_UNK_4127 = 0x4127
    VAR_UNK_4128 = 0x4128
    VAR_UNK_4129 = 0x4129
    VAR_UNK_412A = 0x412A
    VAR_UNK_412B = 0x412B
    VAR_UNK_412C = 0x412C
    VAR_UNK_412D = 0x412D
    VAR_UNK_412E = 0x412E
    VAR_UNK_412F = 0x412F
    VAR_UNK_4130 = 0x4130
    VAR_UNK_4131 = 0x4131
    VAR_UNK_4132 = 0x4132
    VAR_UNK_4133 = 0x4133
    VAR_MIDGAME_BADGES = 0x4134
    VAR_UNK_4135 = 0x4135
    VAR_UNK_4136 = 0x4136
    VAR_UNK_4137 = 0x4137
    VAR_MYSTERY_GIFT_CHECK = 0x4138
    VAR_UNK_4139 = 0x4139
    VAR_BLUE_CARD_POINTS = 0x413A
    VAR_UNK_413B = 0x413B // Related to kurt apricorn making?
    VAR_UNK_413C = 0x413C
    VAR_UNK_413D = 0x413D
    VAR_UNK_413E = 0x413E
    VAR_UNK_413F = 0x413F
    VAR_UNK_4140 = 0x4140
    VAR_UNK_4141 = 0x4141
    VAR_UNK_4142 = 0x4142
    VAR_UNK_4143 = 0x4143
    VAR_UNK_4144 = 0x4144
    VAR_UNK_4145 = 0x4145
    VAR_UNK_4146 = 0x4146
    VAR_UNK_4147 = 0x4147
    VAR_UNK_4148 = 0x4148
    VAR_UNK_4149 = 0x4149
    VAR_UNK_414A = 0x414A
    VAR_UNK_414B = 0x414B
    VAR_UNK_414C = 0x414C
    VAR_UNK_414D = 0x414D
    VAR_UNK_414E = 0x414E
    VAR_UNK_414F = 0x414F
    VAR_UNK_4150 = 0x4150
    VAR_UNK_4151 = 0x4151
    VAR_UNK_4152 = 0x4152
    VAR_UNK_4153 = 0x4153
    VAR_UNK_4154 = 0x4154
    VAR_UNK_4155 = 0x4155
    VAR_UNK_4156 = 0x4156
    VAR_UNK_4157 = 0x4157
    VAR_UNK_4158 = 0x4158
    VAR_UNK_4159 = 0x4159
    VAR_UNK_415A = 0x415A
    VAR_UNK_415B = 0x415B
    VAR_UNK_415C = 0x415C
    VAR_UNK_415D = 0x415D
    VAR_UNK_415E = 0x415E
    VAR_UNK_415F = 0x415F
    VAR_UNK_4160 = 0x4160
    VAR_UNK_4161 = 0x4161
    VAR_UNK_4162 = 0x4162
    VAR_UNK_4163 = 0x4163
    VAR_UNK_4164 = 0x4164
    VAR_UNK_4165 = 0x4165
    VAR_UNK_4166 = 0x4166
    VAR_UNK_4167 = 0x4167
    VAR_UNK_4168 = 0x4168
    VAR_UNK_4169 = 0x4169
    VAR_UNK_416A = 0x416A
    VAR_UNK_416B = 0x416B
    VAR_UNK_416C = 0x416C
    VAR_UNK_416D = 0x416D
    VAR_UNK_416E = 0x416E
    VAR_UNK_416F = 0x416F
    VAR_SPECIAL_x8000 = 0x8000
    VAR_SPECIAL_x8001 = 0x8001
    VAR_SPECIAL_x8002 = 0x8002
    VAR_SPECIAL_x8003 = 0x8003
    VAR_SPECIAL_x8004 = 0x8004
    VAR_SPECIAL_x8005 = 0x8005
    VAR_SPECIAL_x8006 = 0x8006
    VAR_SPECIAL_x8007 = 0x8007
    VAR_SPECIAL_x8008 = 0x8008
    VAR_SPECIAL_x8009 = 0x8009
    VAR_SPECIAL_x800A = 0x800A
    VAR_SPECIAL_x800B = 0x800B
    VAR_SPECIAL_RESULT = 0x800C
    VAR_SPECIAL_LAST_TALKED = 0x800D

FLAG_MAPTEMP_001 = 0x1
    FLAG_MAPTEMP_002 = 0x2
    FLAG_MAPTEMP_003 = 0x3
    FLAG_MAPTEMP_004 = 0x4
    FLAG_MAPTEMP_005 = 0x5
    FLAG_MAPTEMP_006 = 0x6
    FLAG_MAPTEMP_007 = 0x7
    FLAG_MAPTEMP_008 = 0x8
    FLAG_MAPTEMP_009 = 0x9
    FLAG_MAPTEMP_00A = 0xA
    FLAG_MAPTEMP_00B = 0xB
    FLAG_MAPTEMP_00C = 0xC
    FLAG_MAPTEMP_00D = 0xD
    FLAG_MAPTEMP_00E = 0xE
    FLAG_MAPTEMP_00F = 0xF
    FLAG_MAPTEMP_010 = 0x10
    FLAG_MAPTEMP_011 = 0x11
    FLAG_MAPTEMP_012 = 0x12
    FLAG_MAPTEMP_013 = 0x13
    FLAG_MAPTEMP_014 = 0x14
    FLAG_MAPTEMP_015 = 0x15
    FLAG_MAPTEMP_016 = 0x16
    FLAG_MAPTEMP_017 = 0x17
    FLAG_MAPTEMP_018 = 0x18
    FLAG_MAPTEMP_019 = 0x19
    FLAG_MAPTEMP_01A = 0x1A
    FLAG_MAPTEMP_01B = 0x1B
    FLAG_MAPTEMP_01C = 0x1C
    FLAG_MAPTEMP_01D = 0x1D
    FLAG_MAPTEMP_01E = 0x1E
    FLAG_MAPTEMP_01F = 0x1F
    FLAG_MAPTEMP_020 = 0x20
    FLAG_MAPTEMP_021 = 0x21
    FLAG_MAPTEMP_022 = 0x22
    FLAG_MAPTEMP_023 = 0x23
    FLAG_MAPTEMP_024 = 0x24
    FLAG_MAPTEMP_025 = 0x25
    FLAG_MAPTEMP_026 = 0x26
    FLAG_MAPTEMP_027 = 0x27
    FLAG_MAPTEMP_028 = 0x28
    FLAG_MAPTEMP_029 = 0x29
    FLAG_MAPTEMP_02A = 0x2A
    FLAG_MAPTEMP_02B = 0x2B
    FLAG_MAPTEMP_02C = 0x2C
    FLAG_MAPTEMP_02D = 0x2D
    FLAG_MAPTEMP_02E = 0x2E
    FLAG_MAPTEMP_02F = 0x2F
    FLAG_MAPTEMP_030 = 0x30
    FLAG_MAPTEMP_031 = 0x31
    FLAG_MAPTEMP_032 = 0x32
    FLAG_MAPTEMP_033 = 0x33
    FLAG_MAPTEMP_034 = 0x34
    FLAG_MAPTEMP_035 = 0x35
    FLAG_MAPTEMP_036 = 0x36
    FLAG_MAPTEMP_037 = 0x37
    FLAG_MAPTEMP_038 = 0x38
    FLAG_MAPTEMP_039 = 0x39
    FLAG_MAPTEMP_03A = 0x3A
    FLAG_MAPTEMP_03B = 0x3B
    FLAG_MAPTEMP_03C = 0x3C
    FLAG_MAPTEMP_03D = 0x3D
    FLAG_MAPTEMP_03E = 0x3E
    FLAG_MAPTEMP_03F = 0x3F
    FLAG_UNK_040 = 0x40
    FLAG_UNK_041 = 0x41
    FLAG_UNK_042 = 0x42
    FLAG_UNK_043 = 0x43
    FLAG_UNK_044 = 0x44
    FLAG_UNK_045 = 0x45
    FLAG_UNK_046 = 0x46
    FLAG_UNK_047 = 0x47
    FLAG_UNK_048 = 0x48
    FLAG_UNK_049 = 0x49
    FLAG_UNK_04A = 0x4A
    FLAG_UNK_04B = 0x4B
    FLAG_UNK_04C = 0x4C
    FLAG_UNK_04D = 0x4D
    FLAG_UNK_04E = 0x4E
    FLAG_UNK_04F = 0x4F
    FLAG_UNK_050 = 0x50
    FLAG_UNK_051 = 0x51
    FLAG_UNK_052 = 0x52
    FLAG_UNK_053 = 0x53
    FLAG_UNK_054 = 0x54
    FLAG_UNK_055 = 0x55
    FLAG_UNK_056 = 0x56
    FLAG_UNK_057 = 0x57
    FLAG_UNK_058 = 0x58
    FLAG_UNK_059 = 0x59
    FLAG_UNK_05A = 0x5A
    FLAG_UNK_05B = 0x5B
    FLAG_UNK_05C = 0x5C
    FLAG_UNK_05D = 0x5D
    FLAG_UNK_05E = 0x5E
    FLAG_UNK_05F = 0x5F
    FLAG_UNK_060 = 0x60
    FLAG_UNK_061 = 0x61
    FLAG_UNK_062 = 0x62
    FLAG_UNK_063 = 0x63
    FLAG_NURSE_NOTICED_CARD = 0x64
    FLAG_WAS_TOLD_ABOUT_POKERUS = 0x65
    FLAG_UNK_066 = 0x66
    FLAG_UNK_067 = 0x67
    FLAG_UNK_068 = 0x68
    FLAG_UNK_069 = 0x69
    FLAG_GOT_STARTER = 0x6A
    FLAG_GOT_POKEDEX = 0x6B
    FLAG_EXCHANGED_RED_SCALE = 0x6C
    FLAG_GOT_APRICORN_BOX = 0x6D
    FLAG_GOT_TM05_FROM_ROUTE_32_MAN = 0x6E
    FLAG_UNK_06F = 0x6F
    FLAG_GOT_EGG_FROM_ELMS_ASSISTANT = 0x70
    FLAG_TRADE_VIOLET_CITY_BELLSPROUT_ONIX = 0x71
    FLAG_UNK_072 = 0x72
    FLAG_GOT_TM51_FROM_FALKNER = 0x73
    FLAG_UNK_074 = 0x74
    FLAG_GOT_OLD_ROD = 0x75
    FLAG_UNK_076 = 0x76
    FLAG_UNK_077 = 0x77
    FLAG_UNK_078 = 0x78
    FLAG_GAVE_RIVAL_NAME_TO_OFFICER = 0x79
    FLAG_GOT_KINGS_ROCK_FROM_SLOWPOKE_WELL_MAN = 0x7A
    FLAG_BEAT_AZALEA_ROCKETS = 0x7B
    FLAG_UNK_07C = 0x7C
    FLAG_FOUND_FIRST_FARFETCHD = 0x7D
    FLAG_FOUND_SECOND_FARFETCHD = 0x7E
    FLAG_GOT_TM89_FROM_BUGSY = 0x7F
    FLAG_GOT_HM01 = 0x80
    FLAG_GOT_CHARCOAL_FROM_AZALEA_TOWN_MAN = 0x81
    FLAG_UNK_082 = 0x82
    FLAG_GOT_TM12_FROM_ILEX_FOREST_GATE_WOMAN = 0x83
    FLAG_UNK_084 = 0x84
    FLAG_GOT_TM45_FROM_WHITNEY = 0x85
    FLAG_UNK_086 = 0x86
    FLAG_UNK_087 = 0x87
    FLAG_UNK_088 = 0x88
    FLAG_UNK_089 = 0x89
    FLAG_GOT_RADIO_CARD = 0x8A
    FLAG_UNK_08B = 0x8B
    FLAG_UNK_08C = 0x8C
    FLAG_TRADE_GOLDENROD_CITY_DROWZEE_MACHOP = 0x8D
    FLAG_UNK_08E = 0x8E
    FLAG_GOT_TM11_FROM_RADIO_TOWER_WOMAN = 0x8F
    FLAG_UNK_090 = 0x90
    FLAG_GOT_BRIGHTPOWDER_FROM_MARY = 0x91
    FLAG_UNK_092 = 0x92
    FLAG_UNK_093 = 0x93
    FLAG_UNK_094 = 0x94
    FLAG_GOT_EEVEE_FROM_BILL = 0x95
    FLAG_UNK_096 = 0x96
    FLAG_UNK_097 = 0x97
    FLAG_UNK_098 = 0x98
    FLAG_MET_PASSERBY_BOY = 0x99
    FLAG_UNK_09A = 0x9A
    FLAG_OPENED_GOLDENROD_PURPLE_GATE = 0x9B
    FLAG_GOT_POKEGEAR = 0x9C
    FLAG_UNK_09D = 0x9D
    FLAG_UNK_09E = 0x9E
    FLAG_GOT_PICK_UP_EGG_CALL_FROM_ELM = 0x9F
    FLAG_UNK_0A0 = 0xA0
    FLAG_UNK_0A1 = 0xA1
    FLAG_GOT_HM03 = 0xA2
    FLAG_GOT_DOWSING_MACHINE = 0xA3
    FLAG_ENGAGING_STATIC_POKEMON = 0xA4
    FLAG_GOT_MAGNET_FROM_SUNNY = 0xA5
    FLAG_GOT_TM30_FROM_MORTY = 0xA6
    FLAG_TALKED_TO_MOM_AFTER_NAMING_RIVAL = 0xA7
    FLAG_UNK_0A8 = 0xA8
    FLAG_UNK_0A9 = 0xA9
    FLAG_UNK_0AA = 0xAA
    FLAG_GOT_TM83_FROM_MOOMOO_FARM_WOMAN = 0xAB
    FLAG_UNK_0AC = 0xAC
    FLAG_UNK_0AD = 0xAD
    FLAG_UNK_0AE = 0xAE
    FLAG_UNK_0AF = 0xAF
    FLAG_UNK_0B0 = 0xB0
    FLAG_GOT_HARD_STONE_FROM_ARTHUR = 0xB1
    FLAG_UNK_0B2 = 0xB2
    FLAG_UNK_0B3 = 0xB3
    FLAG_UNK_0B4 = 0xB4
    FLAG_UNK_0B5 = 0xB5
    FLAG_UNK_0B6 = 0xB6
    FLAG_UNK_0B7 = 0xB7
    FLAG_UNK_0B8 = 0xB8
    FLAG_GOT_SECRETPOTION = 0xB9
    FLAG_GOT_TM01_FROM_CHUCK = 0xBA
    FLAG_GOT_HM02 = 0xBB
    FLAG_UNK_0BC = 0xBC
    FLAG_GOT_GOOD_ROD = 0xBD
    FLAG_TRADE_OLIVINE_CITY_KRABBY_VOLTORB = 0xBE
    FLAG_GOT_LOAN_SHUCKLE = 0xBF
    FLAG_UNK_0C0 = 0xC0
    FLAG_RETURNED_OR_INHERITED_LOAN_SHUCKLE = 0xC1
    FLAG_GOT_TM23_FROM_JASMINE = 0xC2
    FLAG_UNK_0C3 = 0xC3
    FLAG_UNK_0C4 = 0xC4
    FLAG_UNK_0C5 = 0xC5
    FLAG_BEAT_RADIO_TOWER_ROCKETS = 0xC6
    FLAG_GOT_TM10_FROM_LAKE_OF_RAGE_MAN = 0xC7
    FLAG_UNK_0C8 = 0xC8
    FLAG_GOT_RED_SCALE = 0xC9
    FLAG_RED_GYARADOS_MEET = 0xCA
    FLAG_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_1 = 0xCB
    FLAG_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_2 = 0xCC
    FLAG_REMOVED_ROCKET_HIDEOUT_B3F_ELECTRODE_3 = 0xCD
    FLAG_GOT_TM36_FROM_ROUTE_43_GUARD = 0xCE
    FLAG_UNK_0CF = 0xCF
    FLAG_TRADE_BLACKTHORN_CITY_DRAGONAIR_DODRIO = 0xD0
    FLAG_UNK_0D1 = 0xD1
    FLAG_GOT_TM07_FROM_PRYCE = 0xD2
    FLAG_UNK_0D3 = 0xD3
    FLAG_GOT_SOFT_SAND_FROM_SANTOS = 0xD4
    FLAG_GOT_BLACK_BELT_FROM_WESLEY = 0xD5
    FLAG_UNK_0D6 = 0xD6
    FLAG_GOT_SHARP_BEAK_FROM_MONICA = 0xD7
    FLAG_GOT_TWISTEDSPOON_FROM_TUSCANY = 0xD8
    FLAG_GOT_POISON_BARB_FROM_FRIEDA = 0xD9
    FLAG_GOT_TM59_FROM_CLAIR = 0xDA
    FLAG_FAILED_DRAGONS_DEN_QUIZ = 0xDB
    FLAG_GOT_DRATINI_FROM_MASTER_JUST_NOW = 0xDC
    FLAG_GOT_DRATINI_FROM_MASTER_LONG_AGO = 0xDD
    FLAG_UNK_0DE = 0xDE
    FLAG_GOT_BLACKGLASSES_FROM_DARK_CAVE_MAN = 0xDF
    FLAG_UNK_0E0 = 0xE0
    FLAG_UNK_0E1 = 0xE1
    FLAG_UNK_0E2 = 0xE2
    FLAG_UNK_0E3 = 0xE3
    FLAG_DEFEATED_WILL = 0xE4
    FLAG_DEFEATED_KOGA = 0xE5
    FLAG_DEFEATED_BRUNO = 0xE6
    FLAG_DEFEATED_KAREN = 0xE7
    FLAG_UNK_0E8 = 0xE8
    FLAG_GOT_TM37_FROM_ROUTE_27_WOMAN = 0xE9
    FLAG_UNK_0EA = 0xEA
    FLAG_BOAT_ARRIVED = 0xEB
    FLAG_UNK_0EC = 0xEC
    FLAG_UNK_0ED = 0xED
    FLAG_GOT_ELMS_PANIC_CALL = 0xEE
    FLAG_UNK_0EF = 0xEF
    FLAG_UNK_0F0 = 0xF0
    FLAG_UNK_0F1 = 0xF1
    FLAG_GOT_SS_TICKET_FROM_ELM = 0xF2
    FLAG_GOT_MYSTIC_WATER_FROM_CHERRYGROVE_CITY_MAN = 0xF3
    FLAG_UNK_0F4 = 0xF4
    FLAG_UNK_0F5 = 0xF5
    FLAG_UNK_0F6 = 0xF6
    FLAG_GOT_PP_MAX_FROM_VERMILLION_CITY_MAN = 0xF7
    FLAG_GOT_RARE_CANDY_FROM_FAN_CLUB_CHAIRMAN = 0xF8
    FLAG_SNORLAX_MEET = 0xF9
    FLAG_UNK_0FA = 0xFA
    FLAG_UNK_0FB = 0xFB
    FLAG_UNK_0FC = 0xFC
    FLAG_GOT_ALL_FOUR_FRONTIER_PRINTS = 0xFD
    FLAG_MET_HALL_STREAK_TRACKER_DUDE = 0xFE
    FLAG_GOT_SCRATCH_CARD_INFO = 0xFF
    FLAG_UNK_100 = 0x100
    FLAG_UNK_101 = 0x101
    FLAG_UNK_102 = 0x102
    FLAG_UNK_103 = 0x103
    FLAG_UNK_104 = 0x104
    FLAG_UNK_105 = 0x105
    FLAG_UNK_106 = 0x106
    FLAG_UNK_107 = 0x107
    FLAG_UNK_108 = 0x108
    FLAG_UNK_109 = 0x109
    FLAG_UNK_10A = 0x10A
    FLAG_UNK_10B = 0x10B
    FLAG_GOT_TYROGUE_FROM_KARATE_KING = 0x10C
    FLAG_BEAT_KARATE_KING = 0x10D
    FLAG_GOT_QUICK_CLAW_FROM_NATIONAL_PARK_WOMAN = 0x10E
    FLAG_UNK_10F = 0x10F
    FLAG_GOT_UNOWN_REPORT = 0x110
    FLAG_UNK_111 = 0x111
    FLAG_UNK_112 = 0x112
    FLAG_UNK_113 = 0x113
    FLAG_UNK_114 = 0x114
    FLAG_UNK_115 = 0x115
    FLAG_CAUGHT_HO_OH = 0x116
    FLAG_CAUGHT_LUGIA = 0x117
    FLAG_RESTORED_POWER = 0x118
    FLAG_UNK_119 = 0x119
    FLAG_GOT_EVERSTONE_FROM_ELM = 0x11A
    FLAG_GOT_BAG = 0x11B
    FLAG_GOT_TRAINER_CARD = 0x11C
    FLAG_GOT_SAVE_BUTTON = 0x11D
    FLAG_GOT_OPTIONS_BUTTON = 0x11E
    FLAG_GOT_EXPN_CARD = 0x11F
    FLAG_GOT_POWER_PLANT_MANAGERS_STORY = 0x120
    FLAG_TRADE_POWER_PLANT_DUGTRIO_MAGNETON = 0x121
    FLAG_GOT_NUGGET_FROM_ACE_TRAINER_M_KEVIN = 0x122
    FLAG_UNK_123 = 0x123
    FLAG_GOT_TM19_FROM_ERIKA = 0x124
    FLAG_FARFETCHD_NOTICED_YOU = 0x125
    FLAG_UNK_126 = 0x126
    FLAG_UNK_127 = 0x127
    FLAG_UNK_128 = 0x128
    FLAG_UNK_129 = 0x129
    FLAG_UNK_12A = 0x12A
    FLAG_UNLOCKED_MT_SILVER = 0x12B
    FLAG_UNLOCKED_WEST_KANTO = 0x12C
    FLAG_GOT_TM84_FROM_JANINE = 0x12D
    FLAG_GOT_TM85_FROM_VIRIDIAN_CITY_MAN = 0x12E
    FLAG_GOT_TM29_FROM_MR_PSYCHIC = 0x12F
    FLAG_GOT_UPGRADE_FROM_SAFFRON_CITY_GUARD = 0x130
    FLAG_GOT_CLEANSE_TAG_FROM_ROUTE_5_GRANDMA = 0x131
    FLAG_UNK_132 = 0x132
    FLAG_TRADE_PEWTER_CITY_HAUNTER_XATU = 0x133
    FLAG_GOT_NUGGET_FROM_ROUTE_2_MAN = 0x134
    FLAG_GOT_SACRED_ASH_FROM_ROUTE_2_LAB_AIDE = 0x135
    FLAG_UNK_136 = 0x136
    FLAG_GOT_TM47_FROM_ROUTE_28_CELEBRITY = 0x137
    FLAG_UNK_138 = 0x138
    FLAG_UNK_139 = 0x139
    FLAG_UNK_13A = 0x13A
    FLAG_UNK_13B = 0x13B
    FLAG_UNK_13C = 0x13C
    FLAG_UNK_13D = 0x13D
    FLAG_UNK_13E = 0x13E
    FLAG_UNK_13F = 0x13F
    FLAG_UNK_140 = 0x140
    FLAG_WON_THIS_BUG_CONTEST = 0x141
    FLAG_UNK_142 = 0x142
    FLAG_SAW_JOHTO_DEX_CERTIFICATE = 0x143
    FLAG_SAW_NATIONAL_DEX_CERTIFICATE = 0x144
    FLAG_UNK_145 = 0x145
    FLAG_UNK_146 = 0x146
    FLAG_UNK_147 = 0x147
    FLAG_UNK_148 = 0x148
    FLAG_UNK_149 = 0x149
    FLAG_CAUGHT_ZAPDOS = 0x14A
    FLAG_UNK_14B = 0x14B
    FLAG_UNK_14C = 0x14C
    FLAG_UNK_14D = 0x14D
    FLAG_UNK_14E = 0x14E
    FLAG_GOT_JUDGE_EXPLANATION = 0x14F
    FLAG_UNK_150 = 0x150
    FLAG_MET_ROUTE_47_EMBEDDED_TOWER_HIKER = 0x151
    FLAG_UNK_152 = 0x152
    FLAG_UNK_153 = 0x153
    FLAG_UNK_154 = 0x154
    FLAG_UNK_155 = 0x155
    FLAG_UNK_156 = 0x156
    FLAG_UNK_157 = 0x157
    FLAG_GOT_SPELL_TAG_FROM_CELADON_CITY_MAN = 0x158
    FLAG_GOT_MAREEP_EGG_FROM_PRIMO = 0x159
    FLAG_GOT_WOOPER_EGG_FROM_PRIMO = 0x15A
    FLAG_GOT_SLUGMA_EGG_FROM_PRIMO = 0x15B
    FLAG_GOT_LUCKY_PUNCH_FROM_ROUTE_14_WOMAN = 0x15C
    FLAG_UNK_15D = 0x15D
    FLAG_MET_MOVE_MANIAC = 0x15E
    FLAG_BUG_CONTEST_OTHER_POKES_HELD = 0x15F
    FLAG_ELMS_LAB_PREVENT_PLAYER_ESCAPE = 0x160
    FLAG_SHOWED_FRIEND_A_SHINY_LEAF = 0x161
    FLAG_TRADE_LT_SURGE_PIKACHU = 0x162
    FLAG_GOT_RAGECANDYBAR = 0x163
    FLAG_UNK_164 = 0x164
    FLAG_TRADE_BROCK_BONSLY_RHYHORN = 0x165
    FLAG_TRADE_JASMINE_STEELIX = 0x166
    FLAG_TRADE_STEVEN_FORRETRESS_BELDUM = 0x167
    FLAG_UNK_168 = 0x168
    FLAG_CAUGHT_SUDOWOODO = 0x169
    FLAG_CAUGHT_RED_GYARADOS = 0x16A
    FLAG_CAUGHT_MEWTWO = 0x16B
    FLAG_CAUGHT_ARTICUNO = 0x16C
    FLAG_CAUGHT_MOLTRES = 0x16D
    FLAG_UNK_16E = 0x16E
    FLAG_SPECIAL_MART_PHARMACY = 0x16F
    FLAG_SPECIAL_MART_BITTER = 0x170
    FLAG_SPECIAL_MART_MAHOGANY_GOOD = 0x171
    FLAG_UNK_172 = 0x172
    FLAG_CAUGHT_SNORLAX = 0x173
    FLAG_GOT_LURE_BALL_FROM_ROUTE_32_KURT_FAN = 0x174
    FLAG_CAUGHT_SUICUNE = 0x175
    FLAG_UNK_176 = 0x176
    FLAG_GOT_HOENN_STARTER_FROM_STEVEN = 0x177
    FLAG_UNK_178 = 0x178
    FLAG_CAUGHT_GROUDON = 0x179
    FLAG_CAUGHT_KYOGRE = 0x17A
    FLAG_CAUGHT_RAYQUAZA = 0x17B
    FLAG_UNK_17C = 0x17C
    FLAG_GOT_TM50_FROM_BLAINE = 0x17D
    FLAG_GOT_TM92_FROM_BLUE = 0x17E
    FLAG_GOT_TM80_FROM_BROCK = 0x17F
    FLAG_GOT_TM03_FROM_MISTY = 0x180
    FLAG_GOT_TM34_FROM_LT_SURGE = 0x181
    FLAG_GOT_TM48_FROM_SABRINA = 0x182
    FLAG_UNK_183 = 0x183
    FLAG_UNK_184 = 0x184
    FLAG_GOT_HM08 = 0x185
    FLAG_UNK_186 = 0x186
    FLAG_UNK_187 = 0x187
    FLAG_UNK_188 = 0x188
    FLAG_UNK_189 = 0x189
    FLAG_SPECIAL_MART_MT_MOON = 0x18A
    FLAG_BEAT_OR_ESCAPED_FROM_GROUDON_OR_KYOGRE = 0x18B
    FLAG_UNK_18C = 0x18C
    FLAG_UNK_18D = 0x18D
    FLAG_UNK_18E = 0x18E
    FLAG_UNK_18F = 0x18F
    FLAG_HIDE_NEW_BARK_RIVAL = 0x190
    FLAG_HIDE_ELMS_LAB_ELM = 0x191
    FLAG_UNK_192 = 0x192
    FLAG_HIDE_WIFI_CLUB_CLOSED_LADY = 0x193
    FLAG_HIDE_CHERRYGROVE_MART_SPECIAL_CLERK = 0x194
    FLAG_HIDE_MR_POKEMONS_HOUSE_OAK = 0x195
    FLAG_HIDE_ROUTE_30_BATTLERS = 0x196
    FLAG_HIDE_VIOLET_SHOP_LAB_AIDE = 0x197
    FLAG_HIDE_CHERRYGROVE_GUIDE_GENT = 0x198
    FLAG_HIDE_ROUTE_30_YOUNGSTER_JOEY = 0x199
    FLAG_UNK_19A = 0x19A
    FLAG_HIDE_EARL_IN_SCHOOL = 0x19B
    FLAG_HIDE_CHERRYGROVE_RIVAL = 0x19C
    FLAG_HIDE_ELMS_LAB_OFFICER = 0x19D
    FLAG_UNK_19E = 0x19E
    FLAG_UNK_19F = 0x19F
    FLAG_UNK_1A0 = 0x1A0
    FLAG_HIDE_NEW_BARK_MARILL = 0x1A1
    FLAG_HIDE_NEW_BARK_FRIEND = 0x1A2
    FLAG_UNK_1A3 = 0x1A3
    FLAG_HIDE_ROUTE_29_FRIEND = 0x1A4
    FLAG_HIDE_ROUTE_29_MARILL = 0x1A5
    FLAG_HIDE_ELMS_LAB_FRIEND = 0x1A6
    FLAG_HIDE_FARFETCHD_1_LOST = 0x1A7
    FLAG_HIDE_FARFETCHD_2_LOST = 0x1A8
    FLAG_UNK_1A9 = 0x1A9
    FLAG_UNK_1AA = 0x1AA
    FLAG_HIDE_AZALEA_SLOWPOKES = 0x1AB
    FLAG_UNK_1AC = 0x1AC
    FLAG_HIDE_ILEX_APPRENTICE = 0x1AD
    FLAG_UNK_1AE = 0x1AE
    FLAG_HIDE_ILEX_CUT_MASTER = 0x1AF
    FLAG_UNK_1B0 = 0x1B0
    FLAG_UNK_1B1 = 0x1B1
    FLAG_UNK_1B2 = 0x1B2
    FLAG_UNK_1B3 = 0x1B3
    FLAG_UNK_1B4 = 0x1B4
    FLAG_UNK_1B5 = 0x1B5
    FLAG_UNK_1B6 = 0x1B6
    FLAG_HIDE_ROCKET_TAKEOVER_1 = 0x1B7
    FLAG_HIDE_ROCKET_TAKEOVER_2 = 0x1B8
    FLAG_HIDE_ROCKET_TAKEOVER_3 = 0x1B9
    FLAG_HIDE_ROCKET_TAKEOVER_4 = 0x1BA
    FLAG_HIDE_ROCKET_TAKEOVER_5 = 0x1BB
    FLAG_HIDE_ROCKET_TAKEOVER_6 = 0x1BC
    FLAG_HIDE_RADIO_TOWER_RIVAL = 0x1BD
    FLAG_HIDE_GOLDENROD_DEPT_STORE_5F_RETURN_FRUSTRATION_LADY = 0x1BE
    FLAG_UNK_1BF = 0x1BF
    FLAG_UNK_1C0 = 0x1C0
    FLAG_UNK_1C1 = 0x1C1
    FLAG_HIDE_ROUTE_36_SUDOWOODO = 0x1C2
    FLAG_UNK_1C3 = 0x1C3
    FLAG_UNK_1C4 = 0x1C4
    FLAG_UNK_1C5 = 0x1C5
    FLAG_HIDE_BURNED_TOWER_1F_RIVAL = 0x1C6
    FLAG_HIDE_BURNED_TOWER_1F_EUSINE = 0x1C7
    FLAG_HIDE_BURNED_TOWER_B1F_EUSINE = 0x1C8
    FLAG_HIDE_BURNED_TOWER_B1F_RAIKOU = 0x1C9
    FLAG_HIDE_BURNED_TOWER_B1F_ENTEI = 0x1CA
    FLAG_HIDE_BURNED_TOWER_B1F_SUICUNE = 0x1CB
    FLAG_HIDE_BURNED_TOWER_1F_MORTY = 0x1CC
    FLAG_UNK_1CD = 0x1CD
    FLAG_UNK_1CE = 0x1CE
    FLAG_HIDE_ROUTE_36_FLOWERSHOP_GIRL = 0x1CF
    FLAG_HIDE_GOLDENROD_FLOWERSHOP_GIRL = 0x1D0
    FLAG_UNK_1D1 = 0x1D1
    FLAG_UNK_1D2 = 0x1D2
    FLAG_HIDE_FARFETCHD_1_FOUND = 0x1D3
    FLAG_HIDE_FARFETCHD_2_FOUND = 0x1D4
    FLAG_UNK_1D5 = 0x1D5
    FLAG_HIDE_OLIVINE_RIVAL = 0x1D6
    FLAG_UNK_1D7 = 0x1D7
    FLAG_UNK_1D8 = 0x1D8
    FLAG_HIDE_JASMINE_IN_GYM = 0x1D9
    FLAG_UNK_1DA = 0x1DA
    FLAG_UNK_1DB = 0x1DB
    FLAG_HIDE_OLIVINE_GYM_GENTLEMAN = 0x1DC
    FLAG_HIDE_OLIVINE_GYM_GIRL = 0x1DD
    FLAG_HIDE_BURNED_TOWER_1F_RAIKOU = 0x1DE
    FLAG_HIDE_BURNED_TOWER_1F_ENTEI = 0x1DF
    FLAG_HIDE_BURNED_TOWER_1F_SUICUNE = 0x1E0
    FLAG_HIDE_CIANWOOD_SUICUNE = 0x1E1
    FLAG_HIDE_CIANWOOD_EUSINE = 0x1E2
    FLAG_HIDE_LAKE_OF_RAGE_RED_GYARADOS = 0x1E3
    FLAG_HIDE_LAKE_OF_RAGE_LANCE = 0x1E4
    FLAG_UNK_1E5 = 0x1E5
    FLAG_HIDE_ROCKET_HIDEOUT_B3F_LANCE = 0x1E6
    FLAG_HIDE_MAHOGANY_SHOP_SALESWOMAN = 0x1E7
    FLAG_UNK_1E8 = 0x1E8
    FLAG_UNK_1E9 = 0x1E9
    FLAG_HIDE_ICE_PATH_BOULDER_1_INIT = 0x1EA
    FLAG_HIDE_ICE_PATH_BOULDER_2_INIT = 0x1EB
    FLAG_HIDE_ICE_PATH_BOULDER_3_INIT = 0x1EC
    FLAG_HIDE_ICE_PATH_BOULDER_4_INIT = 0x1ED
    FLAG_HIDE_ICE_PATH_BOULDER_1_FALLEN = 0x1EE
    FLAG_HIDE_ICE_PATH_BOULDER_2_FALLEN = 0x1EF
    FLAG_HIDE_ICE_PATH_BOULDER_3_FALLEN = 0x1F0
    FLAG_HIDE_ICE_PATH_BOULDER_4_FALLEN = 0x1F1
    FLAG_HIDE_MAHOGANY_SHOP_SHADY_SALESMAN = 0x1F2
    FLAG_HIDE_ROCKET_HIDEOUT_B2F_ARIANA = 0x1F3
    FLAG_HIDE_ROCKET_HIDEOUT_B3F_PETREL = 0x1F4
    FLAG_HIDE_ROCKET_HIDEOUT_B3F_ELECTRODE_1_AND_4 = 0x1F5
    FLAG_HIDE_ROCKET_HIDEOUT_B3F_ELECTRODE_2_AND_5 = 0x1F6
    FLAG_HIDE_ROCKET_HIDEOUT_B3F_ELECTRODE_3_AND_6 = 0x1F7
    FLAG_HIDE_MAHOGANY_SHOP_LANCE = 0x1F8
    FLAG_UNK_1F9 = 0x1F9
    FLAG_HIDE_ROUTE_43_GATE_ROCKETS = 0x1FA
    FLAG_HIDE_ROUTE_43_GATE_GUARD = 0x1FB
    FLAG_UNK_1FC = 0x1FC
    FLAG_HIDE_ROCKET_HIDEOUT_B3F_RIVAL = 0x1FD
    FLAG_UNK_1FE = 0x1FE
    FLAG_HIDE_LAKE_OF_RAGE_FISHERMEN = 0x1FF
    FLAG_HIDE_BLACKTHORN_GYM_GUARD_INFRONT = 0x200
    FLAG_HIDE_BLACKTHORN_GYM_GUARD_ASIDE = 0x201
    FLAG_HIDE_BLACKTHORN_DEN_GUARD_INFRONT = 0x202
    FLAG_HIDE_BLACKTHRON_DEN_GUARD_ASIDE = 0x203
    FLAG_UNK_204 = 0x204
    FLAG_UNK_205 = 0x205
    FLAG_UNK_206 = 0x206
    FLAG_UNK_207 = 0x207
    FLAG_UNK_208 = 0x208
    FLAG_HIDE_VICTORY_ROAD_CLAIR = 0x209
    FLAG_HIDE_VICTORY_ROAD_RIVAL = 0x20A
    FLAG_HIDE_WILLS_ROOM_RETREAT = 0x20B
    FLAG_HIDE_KOGAS_ROOM_RETREAT = 0x20C
    FLAG_HIDE_BRUNOS_ROOM_RETREAT = 0x20D
    FLAG_HIDE_KARENS_ROOM_RETREAT = 0x20E
    FLAG_HIDE_CHAMPIONS_ROOM_RETREAT = 0x20F
    FLAG_UNK_210 = 0x210
    FLAG_HIDE_WILLS_ROOM_EXIT = 0x211
    FLAG_HIDE_KOGAS_ROOM_EXIT = 0x212
    FLAG_HIDE_BRUNOS_ROOM_EXIT = 0x213
    FLAG_HIDE_KARENS_ROOM_EXIT = 0x214
    FLAG_UNK_215 = 0x215
    FLAG_UNK_216 = 0x216
    FLAG_UNK_217 = 0x217
    FLAG_UNK_218 = 0x218
    FLAG_UNK_219 = 0x219
    FLAG_UNK_21A = 0x21A
    FLAG_OPENED_ALPH_ESCAPE_ROPE_SECRET_ROOM = 0x21B
    FLAG_UNK_21C = 0x21C
    FLAG_OPENED_ALPH_FLASH_SECRET_ROOM = 0x21D
    FLAG_UNK_21E = 0x21E
    FLAG_OPENED_ALPH_WATER_STONE_SECRET_ROOM = 0x21F
    FLAG_UNK_220 = 0x220
    FLAG_OPENED_ALPH_HO_OH_SECRET_ROOM = 0x221
    FLAG_UNK_222 = 0x222
    FLAG_HIDE_PARK_SOUTH_GATE_POKEATHLON_ENTHUSIASTS_UNLOCKED = 0x223
    FLAG_HIDE_PARK_SOUTH_GATE_POKEATHLON_ENTHUSIASTS_LOCKED = 0x224
    FLAG_UNK_225 = 0x225
    FLAG_UNK_226 = 0x226
    FLAG_HIDE_POKEATHLON_RECEPTION_WHITNEY = 0x227
    FLAG_UNK_228 = 0x228
    FLAG_UNK_229 = 0x229
    FLAG_UNK_22A = 0x22A
    FLAG_UNK_22B = 0x22B
    FLAG_UNK_22C = 0x22C
    FLAG_UNK_22D = 0x22D
    FLAG_UNK_22E = 0x22E
    FLAG_HIDE_BATTLE_TOWER_RECEPTIONIST = 0x22F
    FLAG_UNK_230 = 0x230
    FLAG_UNK_231 = 0x231
    FLAG_UNK_232 = 0x232
    FLAG_UNK_233 = 0x233
    FLAG_UNK_234 = 0x234
    FLAG_HIDE_RUINS_OF_ALPH_ASSISTANTS = 0x235
    FLAG_HIDE_RUINS_OF_ALPH_TOURISTS = 0x236
    FLAG_HIDE_UNDERGROUND_KIMONO_GIRL = 0x237
    FLAG_HIDE_VIOLET_KIMONO_GIRL = 0x238
    FLAG_UNK_239 = 0x239
    FLAG_UNK_23A = 0x23A
    FLAG_UNK_23B = 0x23B
    FLAG_HIDE_DANCE_STUDIO_KIMONO_GIRLS = 0x23C
    FLAG_UNK_23D = 0x23D
    FLAG_HIDE_GOLDENROD_BILL = 0x23E
    FLAG_HIDE_ECRUTEAK_RIVAL = 0x23F
    FLAG_HIDE_DANCE_STUDIO_LITTLE_GIRL = 0x240
    FLAG_UNK_241 = 0x241
    FLAG_HIDE_BELL_TOWER_HO_OH = 0x242
    FLAG_HIDE_WHIRL_ISLAND_LUGIA = 0x243
    FLAG_HIDE_BELL_TOWER_SUMMIT_KIMONO_GIRLS = 0x244
    FLAG_HIDE_WHIRL_ISLANDS_BOTTOM_KIMONO_GIRLS = 0x245
    FLAG_HIDE_ELMS_LAB_AIDE = 0x246
    FLAG_UNK_247 = 0x247
    FLAG_HIDE_ECRUTEAK_OLD_MAN = 0x248
    FLAG_UNK_249 = 0x249
    FLAG_HIDE_ROCKET_HIDEOUT_B3F_MURKROW_1 = 0x24A
    FLAG_HIDE_ROCKET_HIDEOUT_B2F_MURKROW_1 = 0x24B
    FLAG_HIDE_ROCKET_HIDEOUT_B3F_MURKROW_2 = 0x24C
    FLAG_HIDE_ROCKET_HIDEOUT_B2F_MURKROW_2 = 0x24D
    FLAG_UNK_24E = 0x24E
    FLAG_HIDE_ROUTE_30_APRICORN_MAN = 0x24F
    FLAG_HIDE_INDIGO_PLATEAU_RIVAL = 0x250
    FLAG_HIDE_OLIVINE_PORT_OAK = 0x251
    FLAG_HIDE_ROCKET_HIDEOUT_B2F_MURKROW_3 = 0x252
    FLAG_HIDE_CERULEAN_GYM_POPULATION = 0x253
    FLAG_HIDE_CERULEAN_GYM_ROCKET = 0x254
    FLAG_HIDE_ROUTE_24_ROCKET = 0x255
    FLAG_HIDE_ROUTE_25_MISTY = 0x256
    FLAG_HIDE_CERULEAN_GYM_MACHINE_PART = 0x257
    FLAG_UNK_258 = 0x258
    FLAG_HIDE_LAVENDER_RADIO_TOWER_DIRECTOR = 0x259
    FLAG_UNK_25A = 0x25A
    FLAG_UNK_25B = 0x25B
    FLAG_UNK_25C = 0x25C
    FLAG_UNK_25D = 0x25D
    FLAG_UNK_25E = 0x25E
    FLAG_UNK_25F = 0x25F
    FLAG_UNK_260 = 0x260
    FLAG_HIDE_ROUTE_11_SNORLAX = 0x261
    FLAG_UNK_262 = 0x262
    FLAG_UNK_263 = 0x263
    FLAG_HIDE_ROUTE_10_LT_SURGE = 0x264
    FLAG_UNK_265 = 0x265
    FLAG_HIDE_FUCHSIA_GYM_LASS_LINDA_REVEALED = 0x266
    FLAG_HIDE_FUCHSIA_GYM_CAMPER_BARRY_REVEALED = 0x267
    FLAG_HIDE_FUCHSIA_GYM_LASS_ALICE_REVEALED = 0x268
    FLAG_HIDE_FUCHSIA_GYM_PICNICKER_CINDY_REVEALED = 0x269
    FLAG_HIDE_FUCHSIA_GYM_LASS_LINDA_DISGUISED = 0x26A
    FLAG_HIDE_FUCHSIA_GYM_CAMPER_BARRY_DISGUISED = 0x26B
    FLAG_HIDE_FUCHSIA_GYM_LASS_ALICE_DISGUISED = 0x26C
    FLAG_HIDE_FUCHSIA_GYM_PICNICKER_CINDY_DISGUISED = 0x26D
    FLAG_UNK_26E = 0x26E
    FLAG_UNK_26F = 0x26F
    FLAG_UNK_270 = 0x270
    FLAG_AZALEA_ROCKET_HARASSING_CIVILIAN = 0x271
    FLAG_AZALEA_HARASSED_CIVILIAN = 0x272
    FLAG_HIDE_BUG_CONTESTANT_BUG_CATCHER_DON = 0x273
    FLAG_HIDE_BUG_CONTESTANT_BUG_CATCHER_ED = 0x274
    FLAG_HIDE_BUG_CONTESTANT_ACE_TRAINER_ABBY = 0x275
    FLAG_HIDE_BUG_CONTESTANT_POKEFAN_WILLIAM = 0x276
    FLAG_HIDE_BUG_CONTESTANT_BUG_CATCHER_BENNY = 0x277
    FLAG_HIDE_BUG_CONTESTANT_CAMPER_BARRY = 0x278
    FLAG_HIDE_BUG_CONTESTANT_PICNICKER_CINDY = 0x279
    FLAG_HIDE_BUG_CONTESTANT_BUG_CATCHER_JOSH = 0x27A
    FLAG_HIDE_BUG_CONTESTANT_YOUNGSTER_SAMUEL = 0x27B
    FLAG_HIDE_BUG_CONTESTANT_SCHOOL_KID_KIPP = 0x27C
    FLAG_UNK_27D = 0x27D
    FLAG_HIDE_CAMERON = 0x27E
    FLAG_UNK_27F = 0x27F
    FLAG_HIDE_ROCKET_HIDEOUT_B3F_GIOVANNI = 0x280
    FLAG_UNK_281 = 0x281
    FLAG_UNK_282 = 0x282
    FLAG_HIDE_SILPH_ROTOM_HEAT = 0x283
    FLAG_HIDE_SILPH_ROTOM_WASH = 0x284
    FLAG_HIDE_SILPH_ROTOM_FROST = 0x285
    FLAG_HIDE_SILPH_ROTOM_FAN = 0x286
    FLAG_HIDE_SILPH_ROTOM_MOW = 0x287
    FLAG_UNK_288 = 0x288
    FLAG_UNK_289 = 0x289
    FLAG_HIDE_LAKE_OF_RAGE_ACE_TRAINER_LOIS = 0x28A
    FLAG_UNK_28B = 0x28B
    FLAG_UNK_28C = 0x28C
    FLAG_HIDE_TRAINER_HOUSE_CAL_0 = 0x28D
    FLAG_HIDE_TRAINER_HOUSE_CAL_1 = 0x28E
    FLAG_HIDE_TRAINER_HOUSE_CAL_2 = 0x28F
    FLAG_HIDE_TRAINER_HOUSE_CAL_3 = 0x290
    FLAG_HIDE_TRAINER_HOUSE_CAL_4 = 0x291
    FLAG_HIDE_TRAINER_HOUSE_CAL_5 = 0x292
    FLAG_HIDE_TRAINER_HOUSE_CAL_6 = 0x293
    FLAG_HIDE_TRAINER_HOUSE_CAL_7 = 0x294
    FLAG_HIDE_TRAINER_HOUSE_CAL_8 = 0x295
    FLAG_HIDE_TRAINER_HOUSE_CAL_9 = 0x296
    FLAG_HIDE_ROUTE_10_ZAPDOS = 0x297
    FLAG_UNK_298 = 0x298
    FLAG_HIDE_ROUTE_19_WORKMEN_CLOSED = 0x299
    FLAG_HIDE_ROUTE_19_WORKMEN_OPEN = 0x29A
    FLAG_HIDE_ILEX_FOREST_SPIKY_EAR_PICHU = 0x29B
    FLAG_HIDE_ILEX_FOREST_OLD_MAN = 0x29C
    FLAG_HIDE_ROUTE_42_HIKER = 0x29D
    FLAG_HIDE_ROUTE_42_SUICUNE = 0x29E
    FLAG_HIDE_VERMILION_SUICUNE = 0x29F
    FLAG_HIDE_ROUTE_14_SUICUNE = 0x2A0
    FLAG_HIDE_ROUTE_25_SUICUNE = 0x2A1
    FLAG_HIDE_ROUTE_25_EUSINE = 0x2A2
    FLAG_HIDE_ROUTE_42_EUSINE = 0x2A3
    FLAG_HIDE_VERMILION_EUSINE = 0x2A4
    FLAG_HIDE_ROUTE_14_EUSINE = 0x2A5
    FLAG_HIDE_NEW_BARK_MOM = 0x2A6
    FLAG_HIDE_MYSTERY_GIFT_DELIVERYMAN = 0x2A7
    FLAG_HIDE_MOM_GIFT_DELIVERYMAN = 0x2A8
    FLAG_HIDE_PLAYERS_ROOM_BRONZE_TROPHY = 0x2A9
    FLAG_HIDE_PLAYERS_ROOM_SILVER_TROPHY = 0x2AA
    FLAG_HIDE_PLAYERS_ROOM_GOLD_TROPHY = 0x2AB
    FLAG_HIDE_ROUTE_14_EUSINE_2 = 0x2AC
    FLAG_UNK_2AD = 0x2AD
    FLAG_UNK_2AE = 0x2AE
    FLAG_UNK_2AF = 0x2AF
    FLAG_UNK_2B0 = 0x2B0
    FLAG_UNK_2B1 = 0x2B1
    FLAG_HIDE_ROUTE_25_EUSINE_2 = 0x2B2
    FLAG_HIDE_POKEATHLON_SUPREME_CUP_RECEPTIONIST = 0x2B3
    FLAG_HIDE_VERMILION_EUSINE_2 = 0x2B4
    FLAG_UNK_2B5 = 0x2B5
    FLAG_UNK_2B6 = 0x2B6
    FLAG_UNK_2B7 = 0x2B7
    FLAG_UNK_2B8 = 0x2B8
    FLAG_UNK_2B9 = 0x2B9
    FLAG_UNK_2BA = 0x2BA
    FLAG_UNK_2BB = 0x2BB
    FLAG_UNK_2BC = 0x2BC
    FLAG_UNK_2BD = 0x2BD
    FLAG_UNK_2BE = 0x2BE
    FLAG_UNK_2BF = 0x2BF
    FLAG_UNK_2C0 = 0x2C0
    FLAG_UNK_2C1 = 0x2C1
    FLAG_UNK_2C2 = 0x2C2
    FLAG_UNK_2C3 = 0x2C3
    FLAG_UNK_2C4 = 0x2C4
    FLAG_UNK_2C5 = 0x2C5
    FLAG_HIDE_RADIO_TOWER_5F_OFFICE_DIRECTOR = 0x2C6
    FLAG_HIDE_RADIO_TOWER_5F_PETREL_REVEALED = 0x2C7
    FLAG_HIDE_GOLDENROD_UNDERGROUND_FRIEND = 0x2C8
    FLAG_UNK_2C9 = 0x2C9
    FLAG_UNK_2CA = 0x2CA
    FLAG_UNK_2CB = 0x2CB
    FLAG_HIDE_LAKE_OF_RAGE_PRYCE = 0x2CC
    FLAG_UNK_2CD = 0x2CD
    FLAG_HIDE_CLIFFS_EDGE_GATE_CHUCK = 0x2CE
    FLAG_HIDE_ROUTE_47_EMBEDDED_TOWER_HIKER = 0x2CF
    FLAG_HIDE_EMBEDDED_TOWER_GROUDON = 0x2D0
    FLAG_HIDE_EMBEDDED_TOWER_KYOGRE = 0x2D1
    FLAG_HIDE_EMBEDDED_TOWER_RAYQUAZA = 0x2D2
    FLAG_HIDE_EMBEDDED_TOWER_GROUDON_HIKER = 0x2D3
    FLAG_HIDE_EMBEDDED_TOWER_KYOGRE_HIKER = 0x2D4
    FLAG_HIDE_POKEATHLON_SHOES_SIGN = 0x2D5
    FLAG_HIDE_POKEATHLON_CLOTHES_SIGN = 0x2D6
    FLAG_HIDE_POKEATHLON_FLAG_SIGN = 0x2D7
    FLAG_HIDE_POKEATHLON_POKEGEAR_SIGN = 0x2D8
    FLAG_HIDE_POKEATHLON_BALL_SIGN = 0x2D9
    FLAG_UNK_2DA = 0x2DA
    FLAG_UNK_2DB = 0x2DB
    FLAG_HIDE_SINJOH_MYSTRI_SHRINE_CYNTHIA = 0x2DC
    FLAG_UNK_2DD = 0x2DD
    FLAG_UNK_2DE = 0x2DE
    FLAG_HIDE_ROUTE_47_CRASHER_WAKE = 0x2DF
    FLAG_HIDE_DRAGONS_DEN_RIVAL = 0x2E0
    FLAG_UNK_2E1 = 0x2E1
    FLAG_UNK_2E2 = 0x2E2
    FLAG_HIDE_VIOLET_GYM_GYM_GUY_AFTER_SPROUT = 0x2E3
    FLAG_HIDE_VIOLET_GYM_GYM_GUY_BEFORE_SPROUT = 0x2E4
    FLAG_HIDE_NEW_BARK_FRIENDS_ROOM_FRIEND = 0x2E5
    FLAG_HIDE_ALPH_OUTSIDE_ARCEUS_EVENT_SUIT = 0x2E6
    FLAG_HIDE_ALPH_MAIN_CHAMBER_ARCEUS_EVENT_PEOPLE = 0x2E7
    FLAG_HIDE_NEW_BARK_FRIEND_2 = 0x2E8
    FLAG_HIDE_VIOLET_GYM_FALKNER = 0x2E9
    FLAG_HIDE_AZALEA_GYM_BUGSY = 0x2EA
    FLAG_HIDE_CIANWOOD_GYM_CHUCK = 0x2EB
    FLAG_HIDE_GOLDENROD_GYM_WHITNEY = 0x2EC
    FLAG_HIDE_ECRUTEAK_GYM_MORTY = 0x2ED
    FLAG_HIDE_MAHOGANY_GYM_PRYCE = 0x2EE
    FLAG_HIDE_BLACKTHORN_GYM_CLAIR = 0x2EF
    FLAG_HIDE_VERMILION_GYM_LT_SURGE = 0x2F0
    FLAG_HIDE_SAFFRON_GYM_SABRINA = 0x2F1
    FLAG_HIDE_CELADON_GYM_ERIKA = 0x2F2
    FLAG_HIDE_FUCHSIA_GYM_JANINE = 0x2F3
    FLAG_HIDE_PEWTER_GYM_BROCK = 0x2F4
    FLAG_HIDE_SEAFOAM_GYM_BLAINE = 0x2F5
    FLAG_HIDE_VIRIDIAN_GYM_BLUE = 0x2F6
    FLAG_HIDE_SAFFRON_TRAIN_STATION_LT_SURGE = 0x2F7
    FLAG_HIDE_VIRIDIAN_CITY_OLD_MAN_OUTSIDE_GYM_LOCKED = 0x2F8
    FLAG_HIDE_VIRIDIAN_CITY_OLD_MAN_OUTSIDE_GYM_UNLOCKED = 0x2F9
    FLAG_HIDE_SAFFRON_CITY_STEVEN = 0x2FA
    FLAG_HIDE_SAFFRON_CITY_COPYCAT_HOUSE_CLEFAIRY_DOLL = 0x2FB
    FLAG_HIDE_VERMILION_FAN_CLUB_LOST_ITEM = 0x2FC
    FLAG_HIDE_VERMILION_CITY_STEVEN = 0x2FD
    FLAG_HIDE_OAKS_LAB_BULBASAUR_BALL = 0x2FE
    FLAG_HIDE_OAKS_LAB_SQUIRTLE_BALL = 0x2FF
    FLAG_HIDE_OAKS_LAB_CHARMANDER_BALL = 0x300
    FLAG_HIDE_ROUTE_22_GIOVANNI_RIVAL = 0x301
    FLAG_HIDE_ROUTE_22_FRIEND = 0x302
    FLAG_HIDE_TOHJO_FALLS_GIOVANNI = 0x303
    FLAG_HIDE_ROUTE_47_CHUCK = 0x304
    FLAG_HIDE_CERULEAN_CAVE_MEWTWO = 0x305
    FLAG_HIDE_SEAFOAM_ISLAND_ARTICUNO = 0x306
    FLAG_HIDE_MT_SILVER_CAVE_MOLTRES = 0x307
    FLAG_HIDE_STEVEN_IN_HOUSE_BEFORE_LATIS = 0x308
    FLAG_HIDE_ROUTE_25_MISTYS_BOYFRIEND = 0x309
    FLAG_HIDE_UNION_CAVE_LAPRAS = 0x30A
    FLAG_UNK_30B = 0x30B
    FLAG_HIDE_PEWTER_CITY_STEVEN = 0x30C
    FLAG_HIDE_PEWTER_CITY_LATIOS = 0x30D
    FLAG_HIDE_BURNED_TOWER_STATIC_SUICUNE = 0x30E
    FLAG_HIDE_CERULEAN_CITY_MAN_OUTSIDE_CAVE = 0x30F
    FLAG_HIDE_ILEX_FOREST_FRIEND = 0x310
    FLAG_HIDE_TOHJO_FALLS_FRIEND = 0x311
    FLAG_HIDE_PEWTER_CITY_LATIAS = 0x312
    FLAG_HIDE_CELADON_DEPT_STORE_2F_CRASHER_WAKE = 0x313
    FLAG_HIDE_ROUTE_39_LT_SURGE = 0x314
    FLAG_HIDE_COMM_CLUB_RECEPTIONISTS = 0x315
    FLAG_HIDE_COMM_CLUB_CLOSED_LADIES = 0x316
    FLAG_HIDE_STEVEN_IN_HOUSE_AFTER_LATIS = 0x317
    FLAG_UNK_318 = 0x318
    FLAG_HIDE_SAFARI_ZONE_WORKERS = 0x319
    FLAG_HIDE_VERMILION_GYM_STOPS = 0x31A
    FLAG_HIDE_ROUTE_12_SNORLAX = 0x31B
    FLAG_UNK_31C = 0x31C
    FLAG_UNK_31D = 0x31D
    FLAG_UNK_31E = 0x31E
    FLAG_UNK_31F = 0x31F
    HIDDEN_ITEMS_FLAG_BASE = 800
    FLAG_HIDDENITEM_T20_POTION = 0x320
    FLAG_HIDDENITEM_R29_R30_T21_NUGGET = 0x321
    FLAG_HIDDENITEM_R30_POTION = 0x322
    FLAG_HIDDENITEM_T22_HYPER_POTION = 0x323
    FLAG_HIDDENITEM_R32_HEART_SCALE = 0x324
    FLAG_HIDDENITEM_R32_GREAT_BALL = 0x325
    FLAG_HIDDENITEM_T23_FULL_HEAL = 0x326
    FLAG_HIDDENITEM_R34_RARE_CANDY = 0x327
    FLAG_HIDDENITEM_R34_SUPER_POTION = 0x328
    FLAG_HIDDENITEM_R34_T25_SUPER_POTION = 0x329
    FLAG_HIDDENITEM_R35_NUGGET = 0x32A
    FLAG_HIDDENITEM_R36_AWAKENING = 0x32B
    FLAG_HIDDENITEM_T27_HYPER_POTION = 0x32C
    FLAG_HIDDENITEM_T27_ETHER = 0x32D
    FLAG_HIDDENITEM_D42R0102_POKE_BALL = 0x32E
    FLAG_HIDDENITEM_D42R0102_MAX_ETHER = 0x32F
    FLAG_HIDDENITEM_D42R0101_MAX_REVIVE = 0x330
    FLAG_HIDDENITEM_D42R0101_HYPER_POTION = 0x331
    FLAG_HIDDENITEM_D42R0101_ELIXIR = 0x332
    FLAG_HIDDENITEM_D18R0101_ETHER = 0x333
    FLAG_HIDDENITEM_D18R0101_ULTRA_BALL = 0x334
    FLAG_HIDDENITEM_D18R0102_REVIVE = 0x335
    FLAG_HIDDENITEM_R38_HP_UP = 0x336
    FLAG_HIDDENITEM_T26_RARE_CANDY = 0x337
    FLAG_HIDDENITEM_W40_HYPER_POTION = 0x338
    FLAG_HIDDENITEM_T24_REVIVE = 0x339
    FLAG_HIDDENITEM_T24_STARDUST = 0x33A
    FLAG_HIDDENITEM_D26R0101_GREAT_BALL = 0x33B
    FLAG_HIDDENITEM_D26R0102_SUPER_POTION = 0x33C
    FLAG_HIDDENITEM_D26R0102_FULL_HEAL = 0x33D
    FLAG_HIDDENITEM_D36R0101_ANTIDOTE = 0x33E
    FLAG_HIDDENITEM_D36R0101_SUPER_POTION = 0x33F
    FLAG_HIDDENITEM_D36R0101_FULL_HEAL = 0x340
    FLAG_HIDDENITEM_D36R0101_ETHER = 0x341
    FLAG_HIDDENITEM_D22R0101_D22R0102_FULL_HEAL = 0x342
    FLAG_HIDDENITEM_D22R0101_D22R0102_FULL_HEAL_2 = 0x343
    FLAG_HIDDENITEM_T29_FULL_RESTORE = 0x344
    FLAG_HIDDENITEM_T29_RARE_CANDY = 0x345
    FLAG_HIDDENITEM_W20_DEEPSEATOOTH = 0x346
    FLAG_HIDDENITEM_R47_STARDUST = 0x347
    FLAG_HIDDENITEM_R47_PEARL = 0x348
    FLAG_HIDDENITEM_D47_TINYMUSHROOM = 0x349
    FLAG_HIDDENITEM_R42_MAX_POTION = 0x34A
    FLAG_HIDDENITEM_D38R0101_HYPER_POTION = 0x34B
    FLAG_HIDDENITEM_D38R0101_REVIVE = 0x34C
    FLAG_HIDDENITEM_D38R0102_MAX_REPEL = 0x34D
    FLAG_HIDDENITEM_D38R0102_ETHER = 0x34E
    FLAG_HIDDENITEM_D38R0103_FULL_RESTORE = 0x34F
    FLAG_HIDDENITEM_D38R0103_HP_UP = 0x350
    FLAG_HIDDENITEM_D38R0104_MAX_REVIVE = 0x351
    FLAG_HIDDENITEM_D38R0104_ULTRA_BALL = 0x352
    FLAG_HIDDENITEM_D35R0102_REVIVE = 0x353
    FLAG_HIDDENITEM_D37R0103_PARLYZ_HEAL = 0x354
    FLAG_HIDDENITEM_D37R0103_SUPER_POTION = 0x355
    FLAG_HIDDENITEM_D35R0103_FULL_HEAL = 0x356
    FLAG_HIDDENITEM_D35R0103_X_SP__DEF = 0x357
    FLAG_HIDDENITEM_D01R0101_MAX_REVIVE = 0x358
    FLAG_HIDDENITEM_R05R0202_FULL_RESTORE = 0x359
    FLAG_HIDDENITEM_R05R0202_X_SPECIAL = 0x35A
    FLAG_HIDDENITEM_D05R0101_X_ACCURACY = 0x35B
    FLAG_HIDDENITEM_D05R0101_X_DEFENSE = 0x35C
    FLAG_HIDDENITEM_D05R0102_MAX_POTION = 0x35D
    FLAG_HIDDENITEM_D17R0103_MAX_POTION = 0x35E
    FLAG_HIDDENITEM_D17R0105_FULL_RESTORE = 0x35F
    FLAG_HIDDENITEM_D17R0108_CARBOS = 0x360
    FLAG_HIDDENITEM_D18R0102_ANTIDOTE = 0x361
    FLAG_HIDDENITEM_D27R0104_HYPER_POTION = 0x362
    FLAG_HIDDENITEM_D37R0103_ANTIDOTE = 0x363
    FLAG_HIDDENITEM_D37R0105_MAX_POTION = 0x364
    FLAG_HIDDENITEM_D37R0105_REVIVE = 0x365
    FLAG_HIDDENITEM_D39R0101_MAX_POTION = 0x366
    FLAG_HIDDENITEM_D39R0103_CARBOS = 0x367
    FLAG_HIDDENITEM_D39R0101_ICE_HEAL = 0x368
    FLAG_HIDDENITEM_D40R0101_RARE_CANDY = 0x369
    FLAG_HIDDENITEM_D40R0102_ULTRA_BALL = 0x36A
    FLAG_HIDDENITEM_D40R0104_FULL_RESTORE = 0x36B
    FLAG_HIDDENITEM_D41R0101_DIRE_HIT = 0x36C
    FLAG_HIDDENITEM_D41R0101_ULTRA_BALL = 0x36D
    FLAG_HIDDENITEM_D41R0106_MAX_POTION = 0x36E
    FLAG_HIDDENITEM_D43R0101_MAX_POTION = 0x36F
    FLAG_HIDDENITEM_D43R0101_FULL_HEAL = 0x370
    FLAG_HIDDENITEM_D44R0102_REVIVE = 0x371
    FLAG_HIDDENITEM_D44R0102_MAX_POTION = 0x372
    FLAG_HIDDENITEM_D44R0102_MAX_ELIXIR = 0x373
    FLAG_HIDDENITEM_P01R0104_IRON = 0x374
    FLAG_HIDDENITEM_D46R0101_MAX_ETHER = 0x375
    FLAG_HIDDENITEM_P01R0102_PROTEIN = 0x376
    FLAG_HIDDENITEM_D46R0101_FULL_RESTORE = 0x377
    FLAG_HIDDENITEM_D11R0101_ESCAPE_ROPE = 0x378
    FLAG_HIDDENITEM_D11R0102_ICE_HEAL = 0x379
    FLAG_HIDDENITEM_D11R0103_PEARL = 0x37A
    FLAG_HIDDENITEM_D11R0103_PEARL_2 = 0x37B
    FLAG_HIDDENITEM_D11R0104_MAX_REVIVE = 0x37C
    FLAG_HIDDENITEM_D03R0101_HYPER_POTION = 0x37D
    FLAG_HIDDENITEM_D03R0101_RARE_CANDY = 0x37E
    FLAG_HIDDENITEM_D03R0101_REVIVE = 0x37F
    FLAG_HIDDENITEM_D03R0102_ULTRA_BALL = 0x380
    FLAG_HIDDENITEM_R32_SUPER_POTION = 0x381
    FLAG_HIDDENITEM_R39_NUGGET = 0x382
    FLAG_HIDDENITEM_W41_MAX_ETHER = 0x383
    FLAG_HIDDENITEM_R44_ELIXIR = 0x384
    FLAG_HIDDENITEM_R45_PP_UP = 0x385
    FLAG_HIDDENITEM_T29_MAX_POTION = 0x386
    FLAG_HIDDENITEM_T06_FULL_HEAL = 0x387
    FLAG_HIDDENITEM_R11_REVIVE = 0x388
    FLAG_HIDDENITEM_R09_ETHER = 0x389
    FLAG_HIDDENITEM_T04_NUGGET = 0x38A
    FLAG_HIDDENITEM_R25_REVIVE = 0x38B
    FLAG_HIDDENITEM_T22_POKE_BALL = 0x38C
    FLAG_HIDDENITEM_R17_MAX_ETHER = 0x38D
    FLAG_HIDDENITEM_R17_MAX_ELIXIR = 0x38E
    FLAG_HIDDENITEM_R13_CALCIUM = 0x38F
    FLAG_HIDDENITEM_R12_ELIXIR = 0x390
    FLAG_HIDDENITEM_R04_ULTRA_BALL = 0x391
    FLAG_HIDDENITEM_T09_W21_RARE_CANDY = 0x392
    FLAG_HIDDENITEM_R28_RARE_CANDY = 0x393
    FLAG_HIDDENITEM_T31_FULL_RESTORE = 0x394
    FLAG_HIDDENITEM_D03R0102_PP_UP = 0x395
    FLAG_HIDDENITEM_D03R0102_BIG_PEARL = 0x396
    FLAG_HIDDENITEM_D03R0102_ZINC = 0x397
    FLAG_HIDDENITEM_D03R0102_FULL_HEAL = 0x398
    FLAG_HIDDENITEM_D03R0103_MAX_REVIVE = 0x399
    FLAG_HIDDENITEM_T07_PP_UP = 0x39A
    FLAG_HIDDENITEM_D03R0103_ULTRA_BALL = 0x39B
    FLAG_HIDDENITEM_D03R0103_NUGGET = 0x39C
    FLAG_HIDDENITEM_D17R1101_TINYMUSHROOM = 0x39D
    FLAG_HIDDENITEM_D17R1101_BIG_MUSHROOM = 0x39E
    FLAG_HIDDENITEM_D17R1101_BIG_MUSHROOM_2 = 0x39F
    FLAG_HIDDENITEM_D17R1101_TINYMUSHROOM_2 = 0x3A0
    FLAG_HIDDENITEM_D17R1101_TINYMUSHROOM_3 = 0x3A1
    FLAG_HIDDENITEM_D47_TINYMUSHROOM_2 = 0x3A2
    FLAG_HIDDENITEM_D47_TINYMUSHROOM_3 = 0x3A3
    FLAG_HIDDENITEM_T27_RARE_CANDY = 0x3A4
    FLAG_HIDDENITEM_T27_ULTRA_BALL = 0x3A5
    FLAG_HIDDENITEM_T08_NUGGET = 0x3A6
    FLAG_HIDDENITEM_R39_PP_UP = 0x3A7
    FLAG_HIDDENITEM_R39_X_ATTACK = 0x3A8
    FLAG_HIDDENITEM_R39_T26_FULL_HEAL = 0x3A9
    FLAG_HIDDENITEM_R03_STAR_PIECE = 0x3AA
    FLAG_HIDDENITEM_R03_HYPER_POTION = 0x3AB
    FLAG_HIDDENITEM_D38R0102_RARE_CANDY = 0x3AC
    FLAG_HIDDENITEM_D38R0102_ULTRA_BALL = 0x3AD
    FLAG_HIDDENITEM_D38R0102_NUGGET = 0x3AE
    FLAG_HIDDENITEM_D38R0103_HYPER_POTION = 0x3AF
    FLAG_HIDDENITEM_D38R0103_FULL_HEAL = 0x3B0
    FLAG_HIDDENITEM_R03_STAR_PIECE_2 = 0x3B1
    FLAG_HIDDENITEM_D24R0101_GREAT_BALL = 0x3B2
    FLAG_HIDDENITEM_D24R0101_BIG_MUSHROOM = 0x3B3
    FLAG_HIDDENITEM_D24R0101_TINYMUSHROOM = 0x3B4
    FLAG_HIDDENITEM_D24R0101_RARE_CANDY = 0x3B5
    FLAG_HIDDENITEM_D24R0101_NUGGET = 0x3B6
    FLAG_HIDDENITEM_D25R0101_GREAT_BALL = 0x3B7
    FLAG_HIDDENITEM_D25R0101_PARLYZ_HEAL = 0x3B8
    FLAG_HIDDENITEM_D25R0102_X_SPEED = 0x3B9
    FLAG_HIDDENITEM_D25R0101_BIG_PEARL = 0x3BA
    FLAG_HIDDENITEM_D25R0102_REVIVE = 0x3BB
    FLAG_HIDDENITEM_D25R0103_ULTRA_BALL = 0x3BC
    FLAG_HIDDENITEM_D25R0103_CALCIUM = 0x3BD
    FLAG_HIDDENITEM_P01R0102_PEARL = 0x3BE
    FLAG_HIDDENITEM_D49_PP_UP = 0x3BF
    FLAG_HIDDENITEM_D49_PROTEIN = 0x3C0
    FLAG_HIDDENITEM_D32R0102_RARE_CANDY = 0x3C1
    FLAG_HIDDENITEM_T06_PEARL = 0x3C2
    FLAG_HIDDENITEM_T06_PEARL_2 = 0x3C3
    FLAG_HIDDENITEM_T06_BIG_PEARL = 0x3C4
    FLAG_HIDDENITEM_D41R0102_RARE_CANDY = 0x3C5
    FLAG_HIDDENITEM_T09_IRON = 0x3C6
    FLAG_HIDDENITEM_T09_STAR_PIECE = 0x3C7
    FLAG_HIDDENITEM_T06_HEART_SCALE = 0x3C8
    FLAG_HIDDENITEM_D05R0102_HP_UP = 0x3C9
    FLAG_HIDDENITEM_W41_STARDUST = 0x3CA
    FLAG_HIDDENITEM_W41_STARDUST_2 = 0x3CB
    FLAG_HIDDENITEM_W41_STARDUST_3 = 0x3CC
    FLAG_HIDDENITEM_W41_STARDUST_4 = 0x3CD
    FLAG_HIDDENITEM_W20_STARDUST = 0x3CE
    FLAG_HIDDENITEM_W21_STARDUST = 0x3CF
    FLAG_HIDDENITEM_W21_STARDUST_2 = 0x3D0
    FLAG_HIDDENITEM_W21_STARDUST_3 = 0x3D1
    FLAG_HIDDENITEM_W19_PEARL = 0x3D2
    FLAG_HIDDENITEM_W19_PEARL_2 = 0x3D3
    FLAG_HIDDENITEM_W19_BIG_PEARL = 0x3D4
    FLAG_HIDDENITEM_R27_REVIVE = 0x3D5
    FLAG_HIDDENITEM_R27_BIG_MUSHROOM = 0x3D6
    FLAG_HIDDENITEM_R26_R27_NUGGET = 0x3D7
    FLAG_HIDDENITEM_R26_TINYMUSHROOM = 0x3D8
    FLAG_HIDDENITEM_D43R0102_MAX_REVIVE = 0x3D9
    FLAG_HIDDENITEM_D43R0102_PP_UP = 0x3DA
    FLAG_HIDDENITEM_D43R0103_HYPER_POTION = 0x3DB
    FLAG_HIDDENITEM_D43R0103_ZINC = 0x3DC
    FLAG_HIDDENITEM_D43R0102_ULTRA_BALL = 0x3DD
    FLAG_HIDDENITEM_T10_RARE_CANDY = 0x3DE
    FLAG_HIDDENITEM_D40R0102_SUPER_REPEL = 0x3DF
    FLAG_HIDDENITEM_D40R0102_PEARL = 0x3E0
    FLAG_HIDDENITEM_D40R0102_REVIVE = 0x3E1
    FLAG_HIDDENITEM_R04_BIG_MUSHROOM = 0x3E2
    FLAG_HIDDENITEM_D02R0101_REVIVE = 0x3E3
    FLAG_HIDDENITEM_D02R0103_MAX_REVIVE = 0x3E4
    FLAG_HIDDENITEM_R10_CARBOS = 0x3E5
    FLAG_HIDDENITEM_T03_PP_UP = 0x3E6
    FLAG_HIDDENITEM_T03_GUARD_SPEC_ = 0x3E7
    FLAG_HIDDENITEM_T02_NUGGET = 0x3E8
    FLAG_HIDDENITEM_D41R0101_REVIVE = 0x3E9
    FLAG_HIDDENITEM_D41R0105_ULTRA_BALL = 0x3EA
    FLAG_HIDDENITEM_D41R0105_HYPER_POTION = 0x3EB
    FLAG_HIDDENITEM_D41R0102_MAX_ETHER = 0x3EC
    FLAG_HIDDENITEM_D41R0102_HYPER_POTION = 0x3ED
    FLAG_HIDDENITEM_D41R0107_MAX_REVIVE = 0x3EE
    FLAG_HIDDENITEM_W19_REVIVE = 0x3EF
    FLAG_HIDDENITEM_W19_MAX_ELIXIR = 0x3F0
    FLAG_HIDDENITEM_D48R0101_BIG_PEARL = 0x3F1
    FLAG_HIDDENITEM_D11R0104_RARE_CANDY = 0x3F2
    FLAG_HIDDENITEM_D36R0101_TINYMUSHROOM = 0x3F3
    FLAG_HIDDENITEM_D36R0101_REPEL = 0x3F4
    FLAG_HIDDENITEM_D36R0101_BIG_MUSHROOM = 0x3F5
    FLAG_HIDDENITEM_D36R0101_TINYMUSHROOM_2 = 0x3F6
    FLAG_HIDDENITEM_D36R0101_TINYMUSHROOM_3 = 0x3F7
    FLAG_HIDDENITEM_D46R0101_BIG_MUSHROOM = 0x3F8
    FLAG_HIDDENITEM_D46R0101_BIG_MUSHROOM_2 = 0x3F9
    FLAG_HIDDENITEM_D46R0101_TINYMUSHROOM = 0x3FA
    FLAG_HIDDENITEM_D46R0101_TINYMUSHROOM_2 = 0x3FB
    FLAG_HIDDENITEM_D46R0101_TINYMUSHROOM_3 = 0x3FC
    FLAG_HIDDENITEM_D03R0102_PROTEIN = 0x3FD
    FLAG_HIDDENITEM_D41R0106_IRON = 0x3FE
    FLAG_HIDDENITEM_D11R0105_ZINC = 0x3FF
    FLAG_HIDDENITEM_D01R0101_CALCIUM = 0x400
    FLAG_HIDDENITEM_T21_NUGGET = 0x401
    FLAG_HIDDENITEM_D50R0101_ULTRA_BALL = 0x402
    FLAG_HIDDENITEM_T03_MAX_REVIVE = 0x403
    FLAG_HIDDENITEM_D39R0102_REVIVE = 0x404
    FLAG_HIDDENITEM_W20_DEEPSEASCALE = 0x405
    FLAG_HIDDENITEM_R45_R46_PP_MAX = 0x406
    FLAG_UNK_407 = 0x407
    FLAG_UNK_408 = 0x408
    FLAG_UNK_409 = 0x409
    FLAG_UNK_40A = 0x40A
    FLAG_UNK_40B = 0x40B
    FLAG_UNK_40C = 0x40C
    FLAG_UNK_40D = 0x40D
    FLAG_UNK_40E = 0x40E
    FLAG_UNK_40F = 0x40F
    FLAG_UNK_410 = 0x410
    FLAG_UNK_411 = 0x411
    FLAG_UNK_412 = 0x412
    FLAG_UNK_413 = 0x413
    FLAG_UNK_414 = 0x414
    FLAG_UNK_415 = 0x415
    FLAG_UNK_416 = 0x416
    FLAG_UNK_417 = 0x417
    FLAG_UNK_418 = 0x418
    FLAG_UNK_419 = 0x419
    FLAG_UNK_41A = 0x41A
    FLAG_UNK_41B = 0x41B
    FLAG_UNK_41C = 0x41C
    FLAG_UNK_41D = 0x41D
    FLAG_UNK_41E = 0x41E
    FLAG_UNK_41F = 0x41F
    FLAG_HIDE_ITEMBALL_R30_ANTIDOTE = 0x420
    FLAG_HIDE_ITEMBALL_R31_POTION = 0x421
    FLAG_HIDE_ITEMBALL_R31_POKE_BALL = 0x422
    FLAG_HIDE_ITEMBALL_T22_RARE_CANDY = 0x423
    FLAG_HIDE_ITEMBALL_T22_PP_UP = 0x424
    FLAG_HIDE_ITEMBALL_D15R0101_PARLYZ_HEAL = 0x425
    FLAG_HIDE_ITEMBALL_D15R0102_X_ACCURACY = 0x426
    FLAG_HIDE_ITEMBALL_D15R0103_POTION = 0x427
    FLAG_HIDE_ITEMBALL_D15R0103_ESCAPE_ROPE = 0x428
    FLAG_HIDE_ITEMBALL_R32_REPEL = 0x429
    FLAG_HIDE_ITEMBALL_R32_GREAT_BALL = 0x42A
    FLAG_HIDE_ITEMBALL_D25R0101_X_ATTACK = 0x42B
    FLAG_HIDE_ITEMBALL_D25R0101_GREAT_BALL = 0x42C
    FLAG_HIDE_ITEMBALL_D25R0101_POTION = 0x42D
    FLAG_HIDE_ITEMBALL_D25R0101_AWAKENING = 0x42E
    FLAG_HIDE_ITEMBALL_D25R0102_X_DEFENSE = 0x42F
    FLAG_HIDE_ITEMBALL_D25R0102_TM39 = 0x430
    FLAG_HIDE_ITEMBALL_D18R0101_HP_UP = 0x431
    FLAG_HIDE_ITEMBALL_D18R0102_TM12 = 0x432
    FLAG_HIDE_ITEMBALL_D26R0102_SUPER_POTION = 0x433
    FLAG_HIDE_ITEMBALL_D26R0103_TM18 = 0x434
    FLAG_HIDE_ITEMBALL_D36R0101_REVIVE = 0x435
    FLAG_HIDE_ITEMBALL_D37R0105_TM82 = 0x436
    FLAG_HIDE_ITEMBALL_D37R0105_MAX_ETHER = 0x437
    FLAG_UNK_438 = 0x438
    FLAG_HIDE_ITEMBALL_R29_POTION = 0x439
    FLAG_HIDE_ITEMBALL_D25R0103_ELIXIR = 0x43A
    FLAG_HIDE_ITEMBALL_D25R0103_HYPER_POTION = 0x43B
    FLAG_HIDE_ITEMBALL_D36R0101_X_ATTACK = 0x43C
    FLAG_HIDE_ITEMBALL_D36R0101_ANTIDOTE = 0x43D
    FLAG_HIDE_ITEMBALL_D36R0101_ETHER = 0x43E
    FLAG_HIDE_ITEMBALL_R34_NUGGET = 0x43F
    FLAG_HIDE_ITEMBALL_R30_POTION = 0x440
    FLAG_HIDE_ITEMBALL_D23R0104_ULTRA_BALL = 0x441
    FLAG_HIDE_ITEMBALL_D37R0103_BURN_HEAL = 0x442
    FLAG_HIDE_ITEMBALL_D37R0103_AMULET_COIN = 0x443
    FLAG_HIDE_ITEMBALL_D37R0103_ETHER = 0x444
    FLAG_HIDE_ITEMBALL_D37R0103_ULTRA_BALL = 0x445
    FLAG_HIDE_ITEMBALL_D37R0105_ULTRA_BALL = 0x446
    FLAG_HIDE_ITEMBALL_D37R0104_FULL_HEAL = 0x447
    FLAG_HIDE_ITEMBALL_D37R0104_SMOKE_BALL = 0x448
    FLAG_HIDE_ITEMBALL_R35_TM66 = 0x449
    FLAG_HIDE_ITEMBALL_D27R0104_ETHER = 0x44A
    FLAG_HIDE_ITEMBALL_D27R0105_TM87 = 0x44B
    FLAG_HIDE_ITEMBALL_D27R0106_SUPER_REPEL = 0x44C
    FLAG_HIDE_ITEMBALL_D27R0107_SUPER_POTION = 0x44D
    FLAG_HIDE_ITEMBALL_D35R0102_HYPER_POTION = 0x44E
    FLAG_HIDE_ITEMBALL_D35R0102_GUARD_SPEC_ = 0x44F
    FLAG_HIDE_ITEMBALL_D35R0102_NUGGET = 0x450
    FLAG_HIDE_ITEMBALL_D35R0103_TM46 = 0x451
    FLAG_HIDE_ITEMBALL_D35R0104_TM49 = 0x452
    FLAG_HIDE_ITEMBALL_D35R0104_FULL_HEAL = 0x453
    FLAG_HIDE_ITEMBALL_D35R0104_PROTEIN = 0x454
    FLAG_HIDE_ITEMBALL_D35R0104_X_SPECIAL = 0x455
    FLAG_HIDE_ITEMBALL_D39R0103_TM72 = 0x456
    FLAG_HIDE_ITEMBALL_D39R0101_HM07 = 0x457
    FLAG_HIDE_ITEMBALL_D44R0102_DRAGON_FANG = 0x458
    FLAG_HIDE_ITEMBALL_D42R0101_TM54 = 0x459
    FLAG_HIDE_ITEMBALL_D42R0101_REVIVE = 0x45A
    FLAG_HIDE_ITEMBALL_R26_MAX_ELIXIR = 0x45B
    FLAG_HIDE_ITEMBALL_D45R0101_MOON_STONE = 0x45C
    FLAG_HIDE_ITEMBALL_R27_RARE_CANDY = 0x45D
    FLAG_HIDE_ITEMBALL_R27_TM02 = 0x45E
    FLAG_HIDE_ITEMBALL_D43R0101_MAX_REVIVE = 0x45F
    FLAG_HIDE_ITEMBALL_D43R0101_FULL_HEAL = 0x460
    FLAG_HIDE_ITEMBALL_D43R0101_POTION = 0x461
    FLAG_HIDE_ITEMBALL_D43R0102_TM26 = 0x462
    FLAG_HIDE_ITEMBALL_D43R0102_HP_UP = 0x463
    FLAG_HIDE_ITEMBALL_D43R0102_FULL_RESTORE = 0x464
    FLAG_HIDE_ITEMBALL_D43R0103_ULTRA_BALL = 0x465
    FLAG_HIDE_ITEMBALL_D43R0103_TM79 = 0x466
    FLAG_HIDE_ITEMBALL_D43R0103_RARE_CANDY = 0x467
    FLAG_HIDE_ITEMBALL_D24R0212_HEAL_POWDER = 0x468
    FLAG_HIDE_ITEMBALL_D24R0212_ENERGYPOWDER = 0x469
    FLAG_HIDE_ITEMBALL_D24R0212_ORAN_BERRY = 0x46A
    FLAG_HIDE_ITEMBALL_D24R0212_PECHA_BERRY = 0x46B
    FLAG_HIDE_ITEMBALL_D24R0213_HEAL_POWDER = 0x46C
    FLAG_HIDE_ITEMBALL_D24R0213_ENERGY_ROOT = 0x46D
    FLAG_HIDE_ITEMBALL_D24R0213_SITRUS_BERRY = 0x46E
    FLAG_HIDE_ITEMBALL_D24R0213_MOON_STONE = 0x46F
    FLAG_HIDE_ITEMBALL_D24R0215_STARDUST = 0x470
    FLAG_HIDE_ITEMBALL_D24R0215_STAR_PIECE = 0x471
    FLAG_HIDE_ITEMBALL_D24R0215_LEPPA_BERRY = 0x472
    FLAG_HIDE_ITEMBALL_D24R0215_MYSTIC_WATER = 0x473
    FLAG_HIDE_ITEMBALL_D24R0214_REVIVAL_HERB = 0x474
    FLAG_HIDE_ITEMBALL_D24R0214_CHARCOAL = 0x475
    FLAG_HIDE_ITEMBALL_D24R0214_LIFE_ORB = 0x476
    FLAG_HIDE_ITEMBALL_D24R0214_LEPPA_BERRY = 0x477
    FLAG_HIDE_ITEMBALL_D22R0101_SOOTHE_BELL = 0x478
    FLAG_HIDE_ITEMBALL_D22R0101_TM28 = 0x479
    FLAG_HIDE_ITEMBALL_D24R0101_POTION = 0x47A
    FLAG_HIDE_ITEMBALL_D24R0101_HYPER_POTION = 0x47B
    FLAG_HIDE_ITEMBALL_D17R0103_FULL_HEAL = 0x47C
    FLAG_HIDE_ITEMBALL_D17R0104_ESCAPE_ROPE = 0x47D
    FLAG_HIDE_ITEMBALL_D17R0104_ULTRA_BALL = 0x47E
    FLAG_HIDE_ITEMBALL_D17R0104_PP_UP = 0x47F
    FLAG_HIDE_ITEMBALL_D17R0105_RARE_CANDY = 0x480
    FLAG_HIDE_ITEMBALL_D17R0106_MAX_POTION = 0x481
    FLAG_HIDE_ITEMBALL_D17R0106_FULL_HEAL = 0x482
    FLAG_HIDE_ITEMBALL_D17R0107_MAX_REVIVE = 0x483
    FLAG_HIDE_ITEMBALL_D17R0108_FULL_RESTORE = 0x484
    FLAG_HIDE_ITEMBALL_D17R0108_MAX_ELIXIR = 0x485
    FLAG_HIDE_ITEMBALL_D17R0108_NUGGET = 0x486
    FLAG_HIDE_ITEMBALL_D17R0109_HP_UP = 0x487
    FLAG_HIDE_ITEMBALL_D27R0103_RARE_CANDY = 0x488
    FLAG_HIDE_ITEMBALL_D40R0101_ULTRA_BALL = 0x489
    FLAG_HIDE_ITEMBALL_D40R0101_ULTRA_BALL_2 = 0x48A
    FLAG_HIDE_ITEMBALL_D40R0102_ESCAPE_ROPE = 0x48B
    FLAG_HIDE_ITEMBALL_D40R0102_CARBOS = 0x48C
    FLAG_HIDE_ITEMBALL_D40R0102_FULL_RESTORE = 0x48D
    FLAG_HIDE_ITEMBALL_D40R0102_NUGGET = 0x48E
    FLAG_HIDE_ITEMBALL_D40R0102_CALCIUM = 0x48F
    FLAG_HIDE_ITEMBALL_D40R0104_MAX_REVIVE = 0x490
    FLAG_HIDE_ITEMBALL_D40R0104_FULL_RESTORE = 0x491
    FLAG_HIDE_ITEMBALL_D40R0104_MAX_ELIXIR = 0x492
    FLAG_HIDE_ITEMBALL_D40R0106_RARE_CANDY = 0x493
    FLAG_HIDE_ITEMBALL_R42_SUPER_POTION = 0x494
    FLAG_HIDE_ITEMBALL_D38R0101_ETHER = 0x495
    FLAG_HIDE_ITEMBALL_D38R0101_REVIVE = 0x496
    FLAG_HIDE_ITEMBALL_D38R0102_ESCAPE_ROPE = 0x497
    FLAG_HIDE_ITEMBALL_D38R0102_NUGGET = 0x498
    FLAG_HIDE_ITEMBALL_D38R0102_IRON_BALL = 0x499
    FLAG_HIDE_ITEMBALL_D38R0102_MAX_POTION = 0x49A
    FLAG_HIDE_ITEMBALL_D38R0102_IRON = 0x49B
    FLAG_HIDE_ITEMBALL_D38R0102_MAX_REVIVE = 0x49C
    FLAG_HIDE_ITEMBALL_D38R0102_ULTRA_BALL = 0x49D
    FLAG_HIDE_ITEMBALL_D38R0103_RARE_CANDY = 0x49E
    FLAG_HIDE_ITEMBALL_D38R0103_MAX_POTION = 0x49F
    FLAG_HIDE_ITEMBALL_D38R0103_TM40 = 0x4A0
    FLAG_HIDE_ITEMBALL_D38R0103_ELIXIR = 0x4A1
    FLAG_HIDE_ITEMBALL_D38R0103_DRAGON_SCALE = 0x4A2
    FLAG_HIDE_ITEMBALL_D38R0103_ESCAPE_ROPE = 0x4A3
    FLAG_HIDE_ITEMBALL_D38R0104_CARBOS = 0x4A4
    FLAG_HIDE_ITEMBALL_D38R0104_PP_UP = 0x4A5
    FLAG_HIDE_ITEMBALL_D38R0104_FULL_RESTORE = 0x4A6
    FLAG_HIDE_ITEMBALL_D38R0104_MAX_ETHER = 0x4A7
    FLAG_HIDE_ITEMBALL_D38R0104_HYPER_POTION = 0x4A8
    FLAG_HIDE_ITEMBALL_R42_DUBIOUS_DISC = 0x4A9
    FLAG_HIDE_ITEMBALL_D38R0102_FULL_INCENSE = 0x4AA
    FLAG_HIDE_ITEMBALL_D38R0102_PROTECTOR = 0x4AB
    FLAG_HIDE_ITEMBALL_D35R0104_ULTRA_BALL = 0x4AC
    FLAG_HIDE_ITEMBALL_R07_MENTAL_HERB = 0x4AD
    FLAG_HIDE_ITEMBALL_R43_MAX_ETHER = 0x4AE
    FLAG_HIDE_ITEMBALL_W19_TM55 = 0x4AF
    FLAG_HIDE_ITEMBALL_T25R1101_TM78 = 0x4B0
    FLAG_HIDE_ITEMBALL_R44_MAX_REPEL = 0x4B1
    FLAG_HIDE_ITEMBALL_R44_MAX_REVIVE = 0x4B2
    FLAG_HIDE_ITEMBALL_R44_ULTRA_BALL = 0x4B3
    FLAG_HIDE_ITEMBALL_D39R0101_PROTEIN = 0x4B4
    FLAG_HIDE_ITEMBALL_D39R0101_PP_UP = 0x4B5
    FLAG_HIDE_ITEMBALL_D39R0103_FULL_HEAL = 0x4B6
    FLAG_HIDE_ITEMBALL_D39R0103_MAX_POTION = 0x4B7
    FLAG_HIDE_ITEMBALL_D39R0104_NEVERMELTICE = 0x4B8
    FLAG_HIDE_ITEMBALL_D39R0102_IRON = 0x4B9
    FLAG_HIDE_ITEMBALL_D44R0102_CALCIUM = 0x4BA
    FLAG_HIDE_ITEMBALL_D44R0102_MAX_ELIXIR = 0x4BB
    FLAG_HIDE_ITEMBALL_R45_ELIXIR = 0x4BC
    FLAG_HIDE_ITEMBALL_R45_MAX_POTION = 0x4BD
    FLAG_HIDE_ITEMBALL_R45_FULL_HEAL = 0x4BE
    FLAG_HIDE_ITEMBALL_R45_NUGGET = 0x4BF
    FLAG_HIDE_ITEMBALL_R45_REVIVE = 0x4C0
    FLAG_HIDE_ITEMBALL_R46_X_SPEED = 0x4C1
    FLAG_HIDE_ITEMBALL_D42R0102_POTION = 0x4C2
    FLAG_HIDE_ITEMBALL_D42R0102_HYPER_POTION = 0x4C3
    FLAG_HIDE_ITEMBALL_D42R0102_FULL_HEAL = 0x4C4
    FLAG_HIDE_ITEMBALL_D42R0102_DIRE_HIT = 0x4C5
    FLAG_HIDE_ITEMBALL_D05R0101_ELIXIR = 0x4C6
    FLAG_HIDE_ITEMBALL_D05R0101_TM56 = 0x4C7
    FLAG_HIDE_ITEMBALL_D05R0102_IRON = 0x4C8
    FLAG_HIDE_ITEMBALL_D05R0102_PP_UP = 0x4C9
    FLAG_HIDE_ITEMBALL_D05R0102_REVIVE = 0x4CA
    FLAG_HIDE_ITEMBALL_R25_PROTEIN = 0x4CB
    FLAG_HIDE_ITEMBALL_R12_CALCIUM = 0x4CC
    FLAG_HIDE_ITEMBALL_R12_YELLOW_FLUTE = 0x4CD
    FLAG_HIDE_ITEMBALL_R15_PP_UP = 0x4CE
    FLAG_HIDE_ITEMBALL_T31_REAPER_CLOTH = 0x4CF
    FLAG_HIDE_ITEMBALL_R02R0101_CARBOS = 0x4D0
    FLAG_HIDE_ITEMBALL_R02_ELIXIR = 0x4D1
    FLAG_HIDE_ITEMBALL_D46R0101_DIRE_HIT = 0x4D2
    FLAG_HIDE_ITEMBALL_D46R0101_BLUE_FLUTE = 0x4D3
    FLAG_HIDE_ITEMBALL_T09_MAGMARIZER = 0x4D4
    FLAG_HIDE_ITEMBALL_D46R0101_LEAF_STONE = 0x4D5
    FLAG_HIDE_ITEMBALL_D46R0101_TM77 = 0x4D6
    FLAG_HIDE_ITEMBALL_R32_SHELL_BELL = 0x4D7
    FLAG_HIDE_ITEMBALL_R04_HP_UP = 0x4D8
    FLAG_HIDE_ITEMBALL_D41R0101_FULL_RESTORE = 0x4D9
    FLAG_HIDE_ITEMBALL_D41R0102_PURE_INCENSE = 0x4DA
    FLAG_HIDE_ITEMBALL_D41R0102_DAWN_STONE = 0x4DB
    FLAG_HIDE_ITEMBALL_D41R0103_ESCAPE_ROPE = 0x4DC
    FLAG_HIDE_ITEMBALL_D41R0103_TM76 = 0x4DD
    FLAG_HIDE_ITEMBALL_D41R0104_EXPERT_BELT = 0x4DE
    FLAG_HIDE_ITEMBALL_D41R0106_MAX_ELIXIR = 0x4DF
    FLAG_HIDE_ITEMBALL_D41R0106_CALCIUM = 0x4E0
    FLAG_HIDE_ITEMBALL_D41R0106_PROTEIN = 0x4E1
    FLAG_HIDE_ITEMBALL_D41R0106_MAX_REVIVE = 0x4E2
    FLAG_HIDE_ITEMBALL_D11R0102_ICE_HEAL = 0x4E3
    FLAG_HIDE_ITEMBALL_D11R0103_WATER_STONE = 0x4E4
    FLAG_HIDE_ITEMBALL_D11R0104_REVIVE = 0x4E5
    FLAG_HIDE_ITEMBALL_D11R0104_BIG_PEARL = 0x4E6
    FLAG_HIDE_ITEMBALL_D11R0105_ULTRA_BALL = 0x4E7
    FLAG_HIDE_ITEMBALL_D11R0102_GRIP_CLAW = 0x4E8
    FLAG_HIDE_ITEMBALL_D03R0101_MAX_ELIXIR = 0x4E9
    FLAG_HIDE_ITEMBALL_D11R0105_TM13 = 0x4EA
    FLAG_HIDE_ITEMBALL_D03R0101_FULL_RESTORE = 0x4EB
    FLAG_HIDE_ITEMBALL_D03R0101_NUGGET = 0x4EC
    FLAG_HIDE_ITEMBALL_D03R0101_SEA_INCENSE = 0x4ED
    FLAG_HIDE_ITEMBALL_D03R0102_PP_UP = 0x4EE
    FLAG_HIDE_ITEMBALL_D03R0102_ULTRA_BALL = 0x4EF
    FLAG_HIDE_ITEMBALL_D03R0102_TM24 = 0x4F0
    FLAG_HIDE_ITEMBALL_D03R0102_ODD_INCENSE = 0x4F1
    FLAG_HIDE_ITEMBALL_W40_TM88 = 0x4F2
    FLAG_HIDE_ITEMBALL_R47_REVIVE = 0x4F3
    FLAG_HIDE_ITEMBALL_D03R0103_MAX_REVIVE = 0x4F4
    FLAG_HIDE_ITEMBALL_D03R0103_ULTRA_BALL = 0x4F5
    FLAG_HIDE_ITEMBALL_D03R0103_DUSK_STONE = 0x4F6
    FLAG_HIDE_ITEMBALL_D03R0103_ELECTIRIZER = 0x4F7
    FLAG_HIDE_ITEMBALL_D03R0103_BLACK_SLUDGE = 0x4F8
    FLAG_HIDE_ITEMBALL_R32_TM09 = 0x4F9
    FLAG_HIDE_ITEMBALL_R34_TM63 = 0x4FA
    FLAG_HIDE_ITEMBALL_R35_PARLYZ_HEAL = 0x4FB
    FLAG_HIDE_ITEMBALL_R36_HYPER_POTION = 0x4FC
    FLAG_HIDE_ITEMBALL_R38_MAX_POTION = 0x4FD
    FLAG_HIDE_ITEMBALL_R38_LAX_INCENSE = 0x4FE
    FLAG_HIDE_ITEMBALL_R39_TM60 = 0x4FF
    FLAG_HIDE_ITEMBALL_R28_TM35 = 0x500
    FLAG_HIDE_ITEMBALL_R47_LAGGING_TAIL = 0x501
    FLAG_HIDE_ITEMBALL_R47_WAVE_INCENSE = 0x502
    FLAG_HIDE_ITEMBALL_R47_WHITE_FLUTE = 0x503
    FLAG_HIDE_ITEMBALL_R48_NUGGET = 0x504
    FLAG_HIDE_ITEMBALL_R42_TM65 = 0x505
    FLAG_HIDE_ITEMBALL_D22R0101_SHINY_STONE = 0x506
    FLAG_HIDE_ITEMBALL_R08_TM41 = 0x507
    FLAG_HIDE_ITEMBALL_T29_TM43 = 0x508
    FLAG_HIDE_ITEMBALL_T29_CHOICE_SPECS = 0x509
    FLAG_HIDE_ITEMBALL_T29_RED_FLUTE = 0x50A
    FLAG_HIDE_ITEMBALL_D18R0101_ANTIDOTE = 0x50B
    FLAG_HIDE_ITEMBALL_D42R0102_BLACK_FLUTE = 0x50C
    FLAG_HIDE_ITEMBALL_R27_DESTINY_KNOT = 0x50D
    FLAG_HIDE_ITEMBALL_T06_LUCK_INCENSE = 0x50E
    FLAG_HIDE_ITEMBALL_T06_STICKY_BARB = 0x50F
    FLAG_HIDE_ITEMBALL_D05R0102_OVAL_STONE = 0x510
    FLAG_HIDE_ITEMBALL_D01R0101_PP_MAX = 0x511
    FLAG_HIDE_ITEMBALL_D01R0101_ROCK_INCENSE = 0x512
    FLAG_HIDE_ITEMBALL_R06_TM62 = 0x513
    FLAG_HIDE_ITEMBALL_R10R0101_TM69 = 0x514
    FLAG_HIDE_ITEMBALL_R09_TM91 = 0x515
    FLAG_HIDE_ITEMBALL_R09_FULL_RESTORE = 0x516
    FLAG_HIDE_ITEMBALL_R09_LIGHT_CLAY = 0x517
    FLAG_HIDE_ITEMBALL_R09_MAX_POTION = 0x518
    FLAG_HIDE_ITEMBALL_T07_TM67 = 0x519
    FLAG_HIDE_ITEMBALL_R15_ROSE_INCENSE = 0x51A
    FLAG_HIDE_ITEMBALL_R11_TM86 = 0x51B
    FLAG_HIDE_ITEMBALL_T03_WISE_GLASSES = 0x51C
    FLAG_HIDE_ITEMBALL_R03_BIG_ROOT = 0x51D
    FLAG_HIDE_ITEMBALL_T26_TM57 = 0x51E
    FLAG_UNK_51F = 0x51F
    FLAG_UNK_520 = 0x520
    FLAG_UNK_521 = 0x521
    FLAG_UNK_522 = 0x522
    FLAG_UNK_523 = 0x523
    FLAG_UNK_524 = 0x524
    FLAG_UNK_525 = 0x525
    FLAG_UNK_526 = 0x526
    FLAG_UNK_527 = 0x527
    FLAG_UNK_528 = 0x528
    FLAG_UNK_529 = 0x529
    FLAG_UNK_52A = 0x52A
    FLAG_UNK_52B = 0x52B
    FLAG_UNK_52C = 0x52C
    FLAG_UNK_52D = 0x52D
    FLAG_UNK_52E = 0x52E
    FLAG_UNK_52F = 0x52F
    FLAG_UNK_530 = 0x530
    FLAG_UNK_531 = 0x531
    FLAG_UNK_532 = 0x532
    FLAG_UNK_533 = 0x533
    FLAG_UNK_534 = 0x534
    FLAG_UNK_535 = 0x535
    FLAG_UNK_536 = 0x536
    FLAG_UNK_537 = 0x537
    FLAG_UNK_538 = 0x538
    FLAG_UNK_539 = 0x539
    FLAG_UNK_53A = 0x53A
    FLAG_UNK_53B = 0x53B
    FLAG_UNK_53C = 0x53C
    FLAG_UNK_53D = 0x53D
    FLAG_UNK_53E = 0x53E
    FLAG_UNK_53F = 0x53F
    FLAG_UNK_540 = 0x540
    FLAG_UNK_541 = 0x541
    FLAG_UNK_542 = 0x542
    FLAG_UNK_543 = 0x543
    FLAG_UNK_544 = 0x544
    FLAG_UNK_545 = 0x545
    FLAG_UNK_546 = 0x546
    FLAG_UNK_547 = 0x547
    FLAG_UNK_548 = 0x548
    FLAG_UNK_549 = 0x549
    FLAG_UNK_54A = 0x54A
    FLAG_UNK_54B = 0x54B
    FLAG_UNK_54C = 0x54C
    FLAG_UNK_54D = 0x54D
    FLAG_UNK_54E = 0x54E
    FLAG_UNK_54F = 0x54F
    TRAINER_FLAG_BASE = 0x550 //FLAG_TRAINER(tr) = (TRAINER_FLAG_BASE = + = (tr))
    FLAG_UNK_82E = 0x82E
    FLAG_UNK_82F = 0x82F
    FLAG_UNK_830 = 0x830
    FLAG_UNK_831 = 0x831
    FLAG_UNK_832 = 0x832
    FLAG_UNK_833 = 0x833
    FLAG_UNK_834 = 0x834
    FLAG_UNK_835 = 0x835
    FLAG_UNK_836 = 0x836
    FLAG_UNK_837 = 0x837
    FLAG_UNK_838 = 0x838
    FLAG_UNK_839 = 0x839
    FLAG_UNK_83A = 0x83A
    FLAG_UNK_83B = 0x83B
    FLAG_UNK_83C = 0x83C
    FLAG_UNK_83D = 0x83D
    FLAG_UNK_83E = 0x83E
    FLAG_UNK_83F = 0x83F
    FLAG_UNK_840 = 0x840
    FLAG_UNK_841 = 0x841
    FLAG_UNK_842 = 0x842
    FLAG_UNK_843 = 0x843
    FLAG_UNK_844 = 0x844
    FLAG_UNK_845 = 0x845
    FLAG_UNK_846 = 0x846
    FLAG_UNK_847 = 0x847
    FLAG_UNK_848 = 0x848
    FLAG_UNK_849 = 0x849
    FLAG_UNK_84A = 0x84A
    FLAG_UNK_84B = 0x84B
    FLAG_UNK_84C = 0x84C
    FLAG_UNK_84D = 0x84D
    FLAG_UNK_84E = 0x84E
    FLAG_UNK_84F = 0x84F
    FLAG_UNK_850 = 0x850
    FLAG_UNK_851 = 0x851
    FLAG_UNK_852 = 0x852
    FLAG_UNK_853 = 0x853
    FLAG_UNK_854 = 0x854
    FLAG_UNK_855 = 0x855
    FLAG_UNK_856 = 0x856
    FLAG_UNK_857 = 0x857
    FLAG_UNK_858 = 0x858
    FLAG_UNK_859 = 0x859
    FLAG_UNK_85A = 0x85A
    FLAG_UNK_85B = 0x85B
    FLAG_UNK_85C = 0x85C
    FLAG_UNK_85D = 0x85D
    FLAG_UNK_85E = 0x85E
    FLAG_UNK_85F = 0x85F
    FLAG_UNK_860 = 0x860
    FLAG_UNK_861 = 0x861
    FLAG_UNK_862 = 0x862
    FLAG_UNK_863 = 0x863
    FLAG_UNK_864 = 0x864
    FLAG_UNK_865 = 0x865
    FLAG_UNK_866 = 0x866
    FLAG_UNK_867 = 0x867
    FLAG_UNK_868 = 0x868
    FLAG_UNK_869 = 0x869
    FLAG_UNK_86A = 0x86A
    FLAG_UNK_86B = 0x86B
    FLAG_UNK_86C = 0x86C
    FLAG_UNK_86D = 0x86D
    FLAG_UNK_86E = 0x86E
    FLAG_UNK_86F = 0x86F
    FLAG_UNK_870 = 0x870
    FLAG_UNK_871 = 0x871
    FLAG_UNK_872 = 0x872
    FLAG_UNK_873 = 0x873
    FLAG_UNK_874 = 0x874
    FLAG_UNK_875 = 0x875
    FLAG_UNK_876 = 0x876
    FLAG_UNK_877 = 0x877
    FLAG_UNK_878 = 0x878
    FLAG_UNK_879 = 0x879
    FLAG_UNK_87A = 0x87A
    FLAG_UNK_87B = 0x87B
    FLAG_UNK_87C = 0x87C
    FLAG_UNK_87D = 0x87D
    FLAG_UNK_87E = 0x87E
    FLAG_UNK_87F = 0x87F
    FLAG_UNK_880 = 0x880
    FLAG_UNK_881 = 0x881
    FLAG_UNK_882 = 0x882
    FLAG_UNK_883 = 0x883
    FLAG_UNK_884 = 0x884
    FLAG_UNK_885 = 0x885
    FLAG_UNK_886 = 0x886
    FLAG_UNK_887 = 0x887
    FLAG_UNK_888 = 0x888
    FLAG_UNK_889 = 0x889
    FLAG_UNK_88A = 0x88A
    FLAG_UNK_88B = 0x88B
    FLAG_UNK_88C = 0x88C
    FLAG_UNK_88D = 0x88D
    FLAG_UNK_88E = 0x88E
    FLAG_UNK_88F = 0x88F
    FLAG_UNK_890 = 0x890
    FLAG_UNK_891 = 0x891
    FLAG_UNK_892 = 0x892
    FLAG_UNK_893 = 0x893
    FLAG_UNK_894 = 0x894
    FLAG_UNK_895 = 0x895
    FLAG_UNK_896 = 0x896
    FLAG_UNK_897 = 0x897
    FLAG_UNK_898 = 0x898
    FLAG_UNK_899 = 0x899
    FLAG_UNK_89A = 0x89A
    FLAG_UNK_89B = 0x89B
    FLAG_UNK_89C = 0x89C
    FLAG_UNK_89D = 0x89D
    FLAG_UNK_89E = 0x89E
    FLAG_UNK_89F = 0x89F
    FLAG_UNK_8A0 = 0x8A0
    FLAG_UNK_8A1 = 0x8A1
    FLAG_UNK_8A2 = 0x8A2
    FLAG_UNK_8A3 = 0x8A3
    FLAG_UNK_8A4 = 0x8A4
    FLAG_UNK_8A5 = 0x8A5
    FLAG_UNK_8A6 = 0x8A6
    FLAG_UNK_8A7 = 0x8A7
    FLAG_UNK_8A8 = 0x8A8
    FLAG_UNK_8A9 = 0x8A9
    FLAG_UNK_8AA = 0x8AA
    FLAG_UNK_8AB = 0x8AB
    FLAG_UNK_8AC = 0x8AC
    FLAG_UNK_8AD = 0x8AD
    FLAG_UNK_8AE = 0x8AE
    FLAG_UNK_8AF = 0x8AF
    FLAG_UNK_8B0 = 0x8B0
    FLAG_UNK_8B1 = 0x8B1
    FLAG_UNK_8B2 = 0x8B2
    FLAG_UNK_8B3 = 0x8B3
    FLAG_UNK_8B4 = 0x8B4
    FLAG_UNK_8B5 = 0x8B5
    FLAG_UNK_8B6 = 0x8B6
    FLAG_UNK_8B7 = 0x8B7
    FLAG_UNK_8B8 = 0x8B8
    FLAG_UNK_8B9 = 0x8B9
    FLAG_UNK_8BA = 0x8BA
    FLAG_UNK_8BB = 0x8BB
    FLAG_UNK_8BC = 0x8BC
    FLAG_UNK_8BD = 0x8BD
    FLAG_UNK_8BE = 0x8BE
    FLAG_UNK_8BF = 0x8BF
    FLAG_UNK_8C0 = 0x8C0
    FLAG_UNK_8C1 = 0x8C1
    FLAG_UNK_8C2 = 0x8C2
    FLAG_UNK_8C3 = 0x8C3
    FLAG_UNK_8C4 = 0x8C4
    FLAG_UNK_8C5 = 0x8C5
    FLAG_UNK_8C6 = 0x8C6
    FLAG_UNK_8C7 = 0x8C7
    FLAG_UNK_8C8 = 0x8C8
    FLAG_UNK_8C9 = 0x8C9
    FLAG_UNK_8CA = 0x8CA
    FLAG_UNK_8CB = 0x8CB
    FLAG_UNK_8CC = 0x8CC
    FLAG_UNK_8CD = 0x8CD
    FLAG_UNK_8CE = 0x8CE
    FLAG_UNK_8CF = 0x8CF
    FLAG_UNK_8D0 = 0x8D0
    FLAG_UNK_8D1 = 0x8D1
    FLAG_UNK_8D2 = 0x8D2
    FLAG_UNK_8D3 = 0x8D3
    FLAG_UNK_8D4 = 0x8D4
    FLAG_UNK_8D5 = 0x8D5
    FLAG_UNK_8D6 = 0x8D6
    FLAG_UNK_8D7 = 0x8D7
    FLAG_UNK_8D8 = 0x8D8
    FLAG_UNK_8D9 = 0x8D9
    FLAG_UNK_8DA = 0x8DA
    FLAG_UNK_8DB = 0x8DB
    FLAG_UNK_8DC = 0x8DC
    FLAG_UNK_8DD = 0x8DD
    FLAG_UNK_8DE = 0x8DE
    FLAG_UNK_8DF = 0x8DF
    FLAG_UNK_8E0 = 0x8E0
    FLAG_UNK_8E1 = 0x8E1
    FLAG_UNK_8E2 = 0x8E2
    FLAG_UNK_8E3 = 0x8E3
    FLAG_UNK_8E4 = 0x8E4
    FLAG_UNK_8E5 = 0x8E5
    FLAG_UNK_8E6 = 0x8E6
    FLAG_UNK_8E7 = 0x8E7
    FLAG_UNK_8E8 = 0x8E8
    FLAG_UNK_8E9 = 0x8E9
    FLAG_UNK_8EA = 0x8EA
    FLAG_UNK_8EB = 0x8EB
    FLAG_UNK_8EC = 0x8EC
    FLAG_UNK_8ED = 0x8ED
    FLAG_UNK_8EE = 0x8EE
    FLAG_UNK_8EF = 0x8EF
    FLAG_UNK_8F0 = 0x8F0
    FLAG_UNK_8F1 = 0x8F1
    FLAG_UNK_8F2 = 0x8F2
    FLAG_UNK_8F3 = 0x8F3
    FLAG_UNK_8F4 = 0x8F4
    FLAG_UNK_8F5 = 0x8F5
    FLAG_UNK_8F6 = 0x8F6
    FLAG_UNK_8F7 = 0x8F7
    FLAG_UNK_8F8 = 0x8F8
    FLAG_UNK_8F9 = 0x8F9
    FLAG_UNK_8FA = 0x8FA
    FLAG_UNK_8FB = 0x8FB
    FLAG_UNK_8FC = 0x8FC
    FLAG_UNK_8FD = 0x8FD
    FLAG_UNK_8FE = 0x8FE
    FLAG_UNK_8FF = 0x8FF
    FLAG_UNK_900 = 0x900
    FLAG_UNK_901 = 0x901
    FLAG_UNK_902 = 0x902
    FLAG_UNK_903 = 0x903
    FLAG_UNK_904 = 0x904
    FLAG_UNK_905 = 0x905
    FLAG_UNK_906 = 0x906
    FLAG_UNK_907 = 0x907
    FLAG_UNK_908 = 0x908
    FLAG_UNK_909 = 0x909
    FLAG_UNK_90A = 0x90A
    FLAG_UNK_90B = 0x90B
    FLAG_UNK_90C = 0x90C
    FLAG_UNK_90D = 0x90D
    FLAG_UNK_90E = 0x90E
    FLAG_UNK_90F = 0x90F
    FLAG_UNK_910 = 0x910
    FLAG_UNK_911 = 0x911
    FLAG_UNK_912 = 0x912
    FLAG_UNK_913 = 0x913
    FLAG_UNK_914 = 0x914
    FLAG_UNK_915 = 0x915
    FLAG_UNK_916 = 0x916
    FLAG_UNK_917 = 0x917
    FLAG_UNK_918 = 0x918
    FLAG_UNK_919 = 0x919
    FLAG_UNK_91A = 0x91A
    FLAG_UNK_91B = 0x91B
    FLAG_UNK_91C = 0x91C
    FLAG_UNK_91D = 0x91D
    FLAG_UNK_91E = 0x91E
    FLAG_UNK_91F = 0x91F
    FLAG_UNK_920 = 0x920
    FLAG_UNK_921 = 0x921
    FLAG_UNK_922 = 0x922
    FLAG_UNK_923 = 0x923
    FLAG_UNK_924 = 0x924
    FLAG_UNK_925 = 0x925
    FLAG_UNK_926 = 0x926
    FLAG_UNK_927 = 0x927
    FLAG_UNK_928 = 0x928
    FLAG_UNK_929 = 0x929
    FLAG_UNK_92A = 0x92A
    FLAG_UNK_92B = 0x92B
    FLAG_UNK_92C = 0x92C
    FLAG_UNK_92D = 0x92D
    FLAG_UNK_92E = 0x92E
    FLAG_UNK_92F = 0x92F
    FLAG_UNK_930 = 0x930
    FLAG_UNK_931 = 0x931
    FLAG_UNK_932 = 0x932
    FLAG_UNK_933 = 0x933
    FLAG_UNK_934 = 0x934
    FLAG_UNK_935 = 0x935
    FLAG_UNK_936 = 0x936
    FLAG_UNK_937 = 0x937
    FLAG_UNK_938 = 0x938
    FLAG_UNK_939 = 0x939
    FLAG_UNK_93A = 0x93A
    FLAG_UNK_93B = 0x93B
    FLAG_UNK_93C = 0x93C
    FLAG_UNK_93D = 0x93D
    FLAG_UNK_93E = 0x93E
    FLAG_UNK_93F = 0x93F
    FLAG_UNK_940 = 0x940
    FLAG_UNK_941 = 0x941
    FLAG_UNK_942 = 0x942
    FLAG_UNK_943 = 0x943
    FLAG_UNK_944 = 0x944
    FLAG_UNK_945 = 0x945
    FLAG_UNK_946 = 0x946
    FLAG_UNK_947 = 0x947
    FLAG_UNK_948 = 0x948
    FLAG_UNK_949 = 0x949
    FLAG_UNK_94A = 0x94A
    FLAG_UNK_94B = 0x94B
    FLAG_UNK_94C = 0x94C
    FLAG_UNK_94D = 0x94D
    FLAG_UNK_94E = 0x94E
    FLAG_UNK_94F = 0x94F
    FLAG_UNK_950 = 0x950
    FLAG_UNK_951 = 0x951
    FLAG_UNK_952 = 0x952
    FLAG_UNK_953 = 0x953
    FLAG_UNK_954 = 0x954
    FLAG_UNK_955 = 0x955
    FLAG_UNK_956 = 0x956
    FLAG_UNK_957 = 0x957
    FLAG_UNK_958 = 0x958
    FLAG_UNK_959 = 0x959
    FLAG_UNK_95A = 0x95A
    FLAG_UNK_95B = 0x95B
    FLAG_UNK_95C = 0x95C
    FLAG_UNK_95D = 0x95D
    FLAG_UNK_95E = 0x95E
    FLAG_UNK_95F = 0x95F
    FLAG_UNK_960 = 0x960
    FLAG_HAVE_FOLLOWER = 0x961
    FLAG_STRENGTH_ACTIVE = 0x962
    FLAG_UNK_963 = 0x963
    FLAG_GAME_CLEAR = 0x964
    FLAG_UNK_965 = 0x965
    FLAG_UNK_966 = 0x966
    FLAG_SYS_SAFARI = 0x967
    FLAG_UNK_968 = 0x968
    FLAG_SYS_ROCKET_COSTUME = 0x969
    FLAG_UNK_96A = 0x96A
    FLAG_UNK_96B = 0x96B
    FLAG_UNK_96C = 0x96C
    FLAG_UNK_96D = 0x96D
    FLAG_UNK_96E = 0x96E
    FLAG_UNK_96F = 0x96F
    FLAG_UNK_970 = 0x970
    FLAG_SYS_PAL_PARK = 0x971
    FLAG_UNK_972 = 0x972
    FLAG_SYS_FLASH = 0x973
    FLAG_SYS_DEFOG = 0x974
    FLAG_UNK_975 = 0x975
    FLAG_SYS_MET_BILL = 0x976
    FLAG_SYS_ALPH_PUZZLE_KABUTO = 0x977
    FLAG_SYS_ALPH_PUZZLE_AERODACTYL = 0x978
    FLAG_SYS_ALPH_PUZZLE_OMANYTE = 0x979
    FLAG_SYS_ALPH_PUZZLE_HO_OH = 0x97A
    FLAG_UNK_97B = 0x97B
    FLAG_UNK_97C = 0x97C
    FLAG_UNK_97D = 0x97D
    FLAG_UNK_97E = 0x97E
    FLAG_UNK_97F = 0x97F
    FLAG_UNK_980 = 0x980
    FLAG_SYS_CIANWOOD_WATERFALL_DISABLE = 0x981
    FLAG_UNK_982 = 0x982
    FLAG_SYS_HATCHED_TOGEPI_EGG = 0x983
    FLAG_SYS_GOT_BIKE_SHOP_CALL = 0x984
    FLAG_SYS_GOT_BILL_PC_FULL_CALL = 0x985
    FLAG_SYS_MOMS_SAVINGS = 0x986
    FLAG_SYS_OAK_ACKNOWLEDGED_JOHTO_DEX_COMPLETION = 0x987
    FLAG_SYS_OAK_ACKNOWLEDGED_NATIONAL_DEX_COMPLETION = 0x988
    FLAG_UNK_989 = 0x989
    FLAG_UNK_98A = 0x98A
    FLAG_UNK_98B = 0x98B
    FLAG_UNK_98C = 0x98C
    FLAG_UNK_98D = 0x98D
    FLAG_UNK_98E = 0x98E
    FLAG_UNK_98F = 0x98F
    FLAG_UNK_990 = 0x990
    FLAG_UNK_991 = 0x991
    FLAG_SYS_TRIGGER_EGG_CALL = 0x992
    FLAG_BUG_CONTEST_ACTIVE = 0x993
    FLAG_UNK_994 = 0x994
    FLAG_UNK_995 = 0x995
    FLAG_UNK_996 = 0x996
    FLAG_UNK_997 = 0x997
    FLAG_UNK_998 = 0x998
    FLAG_UNK_999 = 0x999
    FLAG_UNK_99A = 0x99A
    FLAG_ROCKET_TAKEOVER_ACTIVE = 0x99B
    FLAG_UNK_99C = 0x99C
    FLAG_UNK_99D = 0x99D
    FLAG_SYS_SUBSCRIBED_TO_EGG_CALLS = 0x99E
    FLAG_UNK_99F = 0x99F
    FLAG_UNK_9A0 = 0x9A0
    FLAG_UNK_9A1 = 0x9A1
    FLAG_UNK_9A2 = 0x9A2
    FLAG_UNK_9A3 = 0x9A3
    FLAG_UNK_9A4 = 0x9A4
    FLAG_UNK_9A5 = 0x9A5
    FLAG_SYS_SOLVED_LT_SURGE_GYM = 0x9A6
    FLAG_UNK_9A7 = 0x9A7
    FLAG_UNK_9A8 = 0x9A8
    FLAG_UNK_9A9 = 0x9A9
    FLAG_UNK_9AA = 0x9AA
    FLAG_UNK_9AB = 0x9AB
    FLAG_UNK_9AC = 0x9AC
    FLAG_UNK_9AD = 0x9AD
    FLAG_UNK_9AE = 0x9AE
    FLAG_UNK_9AF = 0x9AF
    FLAG_SYS_FLYPOINT_PALLET = 0x9B0
    FLAG_SYS_FLYPOINT_VIRIDIAN = 0x9B1
    FLAG_SYS_FLYPOINT_PEWTER = 0x9B2
    FLAG_SYS_FLYPOINT_CERULEAN = 0x9B3
    FLAG_SYS_FLYPOINT_LAVENDER = 0x9B4
    FLAG_SYS_FLYPOINT_VERMILION = 0x9B5
    FLAG_SYS_FLYPOINT_CELADON = 0x9B6
    FLAG_SYS_FLYPOINT_FUCHSIA = 0x9B7
    FLAG_SYS_FLYPOINT_CINNABAR = 0x9B8
    FLAG_SYS_FLYPOINT_INDIGO = 0x9B9
    FLAG_SYS_FLYPOINT_SAFFRON = 0x9BA
    FLAG_SYS_FLYPOINT_NEW_BARK = 0x9BB
    FLAG_SYS_FLYPOINT_CHERRYGROVE = 0x9BC
    FLAG_SYS_FLYPOINT_VIOLET = 0x9BD
    FLAG_SYS_FLYPOINT_AZALEA = 0x9BE
    FLAG_SYS_FLYPOINT_GOLDENROD = 0x9BF
    FLAG_SYS_FLYPOINT_ECRUTEAK = 0x9C0
    FLAG_SYS_FLYPOINT_OLIVINE = 0x9C1
    FLAG_SYS_FLYPOINT_CIANWOOD = 0x9C2
    FLAG_SYS_FLYPOINT_MAHOGANY = 0x9C3
    FLAG_SYS_FLYPOINT_LAKE_OF_RAGE = 0x9C4
    FLAG_SYS_FLYPOINT_BLACKTHORN = 0x9C5
    FLAG_SYS_FLYPOINT_MT_SILVER = 0x9C6
    FLAG_UNK_9C7 = 0x9C7
    FLAG_UNK_9C8 = 0x9C8
    FLAG_UNK_9C9 = 0x9C9
    FLAG_UNK_9CA = 0x9CA
    FLAG_SYS_FLYPOINT_UNION_CAVE = 0x9CB
    FLAG_UNK_9CC = 0x9CC
    FLAG_UNK_9CD = 0x9CD
    FLAG_SYS_FLYPOINT_SAFARI = 0x9CE
    FLAG_SYS_FLYPOINT_FRONTIER = 0x9CF
    FLAG_UNK_9D0 = 0x9D0
    FLAG_SYS_FLYPOINT_VICTORY_ROAD = 0x9D1
    FLAG_UNK_9D2 = 0x9D2
    FLAG_SYS_FLYPOINT_POKEATHLON = 0x9D3
    FLAG_SYS_FLYPOINT_MT_MOON = 0x9D4
    FLAG_SYS_FLYPOINT_ROCK_TUNNEL = 0x9D5
    FLAG_UNK_9D6 = 0x9D6
    FLAG_UNK_9D7 = 0x9D7
    FLAG_UNK_9D8 = 0x9D8
    FLAG_UNK_9D9 = 0x9D9
    FLAG_UNK_9DA = 0x9DA
    FLAG_UNK_9DB = 0x9DB
    FLAG_UNK_9DC = 0x9DC
    FLAG_UNK_9DD = 0x9DD
    FLAG_UNK_9DE = 0x9DE
    FLAG_UNK_9DF = 0x9DF
    FLAG_UNK_9E0 = 0x9E0
    FLAG_UNK_9E1 = 0x9E1
    FLAG_UNK_9E2 = 0x9E2
    FLAG_UNK_9E3 = 0x9E3
    FLAG_UNK_9E4 = 0x9E4
    FLAG_UNK_9E5 = 0x9E5
    FLAG_UNK_9E6 = 0x9E6
    FLAG_UNK_9E7 = 0x9E7
    FLAG_UNK_9E8 = 0x9E8
    FLAG_UNK_9E9 = 0x9E9
    FLAG_UNK_9EA = 0x9EA
    FLAG_UNK_9EB = 0x9EB
    FLAG_UNK_9EC = 0x9EC
    FLAG_UNK_9ED = 0x9ED
    FLAG_UNK_9EE = 0x9EE
    FLAG_UNK_9EF = 0x9EF
    FLAG_UNK_9F0 = 0x9F0
    FLAG_UNK_9F1 = 0x9F1
    FLAG_UNK_9F2 = 0x9F2
    FLAG_UNK_9F3 = 0x9F3
    FLAG_UNK_9F4 = 0x9F4
    FLAG_UNK_9F5 = 0x9F5
    FLAG_UNK_9F6 = 0x9F6
    FLAG_UNK_9F7 = 0x9F7
    FLAG_UNK_9F8 = 0x9F8
    FLAG_UNK_9F9 = 0x9F9
    FLAG_UNK_9FA = 0x9FA
    FLAG_UNK_9FB = 0x9FB
    FLAG_UNK_9FC = 0x9FC
    FLAG_UNK_9FD = 0x9FD
    FLAG_UNK_9FE = 0x9FE
    FLAG_UNK_9FF = 0x9FF
    FLAG_UNK_A00 = 0xA00
    FLAG_UNK_A01 = 0xA01
    FLAG_UNK_A02 = 0xA02
    FLAG_UNK_A03 = 0xA03
    FLAG_UNK_A04 = 0xA04
    FLAG_UNK_A05 = 0xA05
    FLAG_UNK_A06 = 0xA06
    FLAG_UNK_A07 = 0xA07
    FLAG_UNK_A08 = 0xA08
    FLAG_UNK_A09 = 0xA09
    FLAG_UNK_A0A = 0xA0A
    FLAG_UNK_A0B = 0xA0B
    FLAG_UNK_A0C = 0xA0C
    FLAG_UNK_A0D = 0xA0D
    FLAG_UNK_A0E = 0xA0E
    FLAG_UNK_A0F = 0xA0F
    FLAG_UNK_A10 = 0xA10
    FLAG_UNK_A11 = 0xA11
    FLAG_UNK_A12 = 0xA12
    FLAG_UNK_A13 = 0xA13
    FLAG_UNK_A14 = 0xA14
    FLAG_UNK_A15 = 0xA15
    FLAG_UNK_A16 = 0xA16
    FLAG_UNK_A17 = 0xA17
    FLAG_UNK_A18 = 0xA18
    FLAG_UNK_A19 = 0xA19
    FLAG_UNK_A1A = 0xA1A
    FLAG_UNK_A1B = 0xA1B
    FLAG_UNK_A1C = 0xA1C
    FLAG_UNK_A1D = 0xA1D
    FLAG_UNK_A1E = 0xA1E
    FLAG_UNK_A1F = 0xA1F
    FLAG_UNK_A20 = 0xA20
    FLAG_UNK_A21 = 0xA21
    FLAG_UNK_A22 = 0xA22
    FLAG_UNK_A23 = 0xA23
    FLAG_UNK_A24 = 0xA24
    FLAG_UNK_A25 = 0xA25
    FLAG_UNK_A26 = 0xA26
    FLAG_UNK_A27 = 0xA27
    FLAG_UNK_A28 = 0xA28
    FLAG_UNK_A29 = 0xA29
    FLAG_UNK_A2A = 0xA2A
    FLAG_UNK_A2B = 0xA2B
    FLAG_UNK_A2C = 0xA2C
    FLAG_UNK_A2D = 0xA2D
    FLAG_UNK_A2E = 0xA2E
    FLAG_UNK_A2F = 0xA2F
    FLAG_UNK_A30 = 0xA30
    FLAG_UNK_A31 = 0xA31
    FLAG_UNK_A32 = 0xA32
    FLAG_UNK_A33 = 0xA33
    FLAG_UNK_A34 = 0xA34
    FLAG_UNK_A35 = 0xA35
    FLAG_UNK_A36 = 0xA36
    FLAG_UNK_A37 = 0xA37
    FLAG_UNK_A38 = 0xA38
    FLAG_UNK_A39 = 0xA39
    FLAG_UNK_A3A = 0xA3A
    FLAG_UNK_A3B = 0xA3B
    FLAG_UNK_A3C = 0xA3C
    FLAG_UNK_A3D = 0xA3D
    FLAG_UNK_A3E = 0xA3E
    FLAG_UNK_A3F = 0xA3F
    FLAG_UNK_A40 = 0xA40
    FLAG_UNK_A41 = 0xA41
    FLAG_UNK_A42 = 0xA42
    FLAG_UNK_A43 = 0xA43
    FLAG_UNK_A44 = 0xA44
    FLAG_UNK_A45 = 0xA45
    FLAG_UNK_A46 = 0xA46
    FLAG_UNK_A47 = 0xA47
    FLAG_UNK_A48 = 0xA48
    FLAG_UNK_A49 = 0xA49
    FLAG_UNK_A4A = 0xA4A
    FLAG_UNK_A4B = 0xA4B
    FLAG_UNK_A4C = 0xA4C
    FLAG_UNK_A4D = 0xA4D
    FLAG_UNK_A4E = 0xA4E
    FLAG_UNK_A4F = 0xA4F
    FLAG_UNK_A50 = 0xA50
    FLAG_UNK_A51 = 0xA51
    FLAG_UNK_A52 = 0xA52
    FLAG_UNK_A53 = 0xA53
    FLAG_UNK_A54 = 0xA54
    FLAG_UNK_A55 = 0xA55
    FLAG_UNK_A56 = 0xA56
    FLAG_UNK_A57 = 0xA57
    FLAG_UNK_A58 = 0xA58
    FLAG_UNK_A59 = 0xA59
    FLAG_UNK_A5A = 0xA5A
    FLAG_UNK_A5B = 0xA5B
    FLAG_UNK_A5C = 0xA5C
    FLAG_UNK_A5D = 0xA5D
    FLAG_UNK_A5E = 0xA5E
    FLAG_UNK_A5F = 0xA5F
    FLAG_UNK_A60 = 0xA60
    FLAG_UNK_A61 = 0xA61
    FLAG_UNK_A62 = 0xA62
    FLAG_UNK_A63 = 0xA63
    FLAG_UNK_A64 = 0xA64
    FLAG_UNK_A65 = 0xA65
    FLAG_UNK_A66 = 0xA66
    FLAG_UNK_A67 = 0xA67
    FLAG_UNK_A68 = 0xA68
    FLAG_UNK_A69 = 0xA69
    FLAG_UNK_A6A = 0xA6A
    FLAG_UNK_A6B = 0xA6B
    FLAG_UNK_A6C = 0xA6C
    FLAG_UNK_A6D = 0xA6D
    FLAG_UNK_A6E = 0xA6E
    FLAG_UNK_A6F = 0xA6F
    FLAG_UNK_A70 = 0xA70
    FLAG_UNK_A71 = 0xA71
    FLAG_UNK_A72 = 0xA72
    FLAG_UNK_A73 = 0xA73
    FLAG_UNK_A74 = 0xA74
    FLAG_UNK_A75 = 0xA75
    FLAG_UNK_A76 = 0xA76
    FLAG_UNK_A77 = 0xA77
    FLAG_UNK_A78 = 0xA78
    FLAG_UNK_A79 = 0xA79
    FLAG_UNK_A7A = 0xA7A
    FLAG_UNK_A7B = 0xA7B
    FLAG_UNK_A7C = 0xA7C
    FLAG_UNK_A7D = 0xA7D
    FLAG_UNK_A7E = 0xA7E
    FLAG_UNK_A7F = 0xA7F
    FLAG_UNK_A80 = 0xA80
    FLAG_UNK_A81 = 0xA81
    FLAG_UNK_A82 = 0xA82
    FLAG_UNK_A83 = 0xA83
    FLAG_UNK_A84 = 0xA84
    FLAG_UNK_A85 = 0xA85
    FLAG_UNK_A86 = 0xA86
    FLAG_UNK_A87 = 0xA87
    FLAG_UNK_A88 = 0xA88
    FLAG_UNK_A89 = 0xA89
    FLAG_UNK_A8A = 0xA8A
    FLAG_UNK_A8B = 0xA8B
    FLAG_UNK_A8C = 0xA8C
    FLAG_UNK_A8D = 0xA8D
    FLAG_UNK_A8E = 0xA8E
    FLAG_UNK_A8F = 0xA8F
    FLAG_UNK_A90 = 0xA90
    FLAG_UNK_A91 = 0xA91
    FLAG_UNK_A92 = 0xA92
    FLAG_UNK_A93 = 0xA93
    FLAG_UNK_A94 = 0xA94
    FLAG_UNK_A95 = 0xA95
    FLAG_UNK_A96 = 0xA96
    FLAG_UNK_A97 = 0xA97
    FLAG_UNK_A98 = 0xA98
    FLAG_UNK_A99 = 0xA99
    FLAG_UNK_A9A = 0xA9A
    FLAG_UNK_A9B = 0xA9B
    FLAG_UNK_A9C = 0xA9C
    FLAG_UNK_A9D = 0xA9D
    FLAG_UNK_A9E = 0xA9E
    FLAG_UNK_A9F = 0xA9F
    FLAG_DAILY_GOT_HAIRCUT = 0xAA0
    FLAG_UNK_AA1 = 0xAA1
    FLAG_DAILY_KURT_MAKING_BALLS = 0xAA2
    FLAG_DAILY_BUENAS_PASSWORD = 0xAA3
    FLAG_UNK_AA4 = 0xAA4
    FLAG_UNK_AA5 = 0xAA5
    FLAG_UNK_AA6 = 0xAA6
    FLAG_DAILY_DID_BUG_CONTEST = 0xAA7
    FLAG_UNK_AA8 = 0xAA8
    FLAG_UNK_AA9 = 0xAA9
    FLAG_DAILY_TRAINER_HOUSE_0 = 0xAAA
    FLAG_DAILY_TRAINER_HOUSE_1 = 0xAAB
    FLAG_DAILY_TRAINER_HOUSE_2 = 0xAAC
    FLAG_DAILY_TRAINER_HOUSE_3 = 0xAAD
    FLAG_DAILY_TRAINER_HOUSE_4 = 0xAAE
    FLAG_DAILY_TRAINER_HOUSE_5 = 0xAAF
    FLAG_DAILY_TRAINER_HOUSE_6 = 0xAB0
    FLAG_DAILY_TRAINER_HOUSE_7 = 0xAB1
    FLAG_DAILY_TRAINER_HOUSE_8 = 0xAB2
    FLAG_DAILY_TRAINER_HOUSE_9 = 0xAB3
    FLAG_DAILY_TRAINER_HOUSE_10 = 0xAB4
    FLAG_UNK_AB5 = 0xAB5
    FLAG_DAILY_HEARD_BUENAS_PASSWORD = 0xAB6
    FLAG_UNK_AB7 = 0xAB7
    FLAG_DAILY_CAUGHT_LAPRAS = 0xAB8
    FLAG_UNK_AB9 = 0xAB9
    FLAG_UNK_ABA = 0xABA
    FLAG_UNK_ABB = 0xABB
    FLAG_DAILY_GOT_SHOCK_RIBBON = 0xABC
    FLAG_DAILY_GOT_LOAN_SHUCKLE_TODAY = 0xABD
    FLAG_UNK_ABE = 0xABE
    FLAG_UNK_ABF = 0xABF
    FLAG_UNK_AC0 = 0xAC0
    FLAG_UNK_AC1 = 0xAC1
    FLAG_UNK_AC2 = 0xAC2
    FLAG_UNK_AC3 = 0xAC3
    FLAG_UNK_AC4 = 0xAC4
    FLAG_UNK_AC5 = 0xAC5
    FLAG_UNK_AC6 = 0xAC6
    FLAG_UNK_AC7 = 0xAC7
    FLAG_UNK_AC8 = 0xAC8
    FLAG_UNK_AC9 = 0xAC9
    FLAG_UNK_ACA = 0xACA
    FLAG_UNK_ACB = 0xACB
    FLAG_UNK_ACC = 0xACC
    FLAG_UNK_ACD = 0xACD
    FLAG_UNK_ACE = 0xACE
    FLAG_UNK_ACF = 0xACF
    FLAG_UNK_AD0 = 0xAD0
    FLAG_UNK_AD1 = 0xAD1
    FLAG_UNK_AD2 = 0xAD2
    FLAG_UNK_AD3 = 0xAD3
    FLAG_UNK_AD4 = 0xAD4
    FLAG_UNK_AD5 = 0xAD5
    FLAG_UNK_AD6 = 0xAD6
    FLAG_UNK_AD7 = 0xAD7
    FLAG_UNK_AD8 = 0xAD8
    FLAG_UNK_AD9 = 0xAD9
    FLAG_UNK_ADA = 0xADA
    FLAG_UNK_ADB = 0xADB
    FLAG_UNK_ADC = 0xADC
    FLAG_UNK_ADD = 0xADD
    FLAG_UNK_ADE = 0xADE
    FLAG_UNK_ADF = 0xADF
    FLAG_UNK_AE0 = 0xAE0
    FLAG_UNK_AE1 = 0xAE1
    FLAG_UNK_AE2 = 0xAE2
    FLAG_UNK_AE3 = 0xAE3
    FLAG_UNK_AE4 = 0xAE4
    FLAG_UNK_AE5 = 0xAE5
    FLAG_UNK_AE6 = 0xAE6
    FLAG_UNK_AE7 = 0xAE7
    FLAG_UNK_AE8 = 0xAE8
    FLAG_UNK_AE9 = 0xAE9
    FLAG_UNK_AEA = 0xAEA
    FLAG_UNK_AEB = 0xAEB
    FLAG_UNK_AEC = 0xAEC
    FLAG_UNK_AED = 0xAED
    FLAG_UNK_AEE = 0xAEE
    FLAG_UNK_AEF = 0xAEF
    FLAG_UNK_AF0 = 0xAF0
    FLAG_UNK_AF1 = 0xAF1
    FLAG_UNK_AF2 = 0xAF2
    FLAG_UNK_AF3 = 0xAF3
    FLAG_UNK_AF4 = 0xAF4
    FLAG_UNK_AF5 = 0xAF5
    FLAG_UNK_AF6 = 0xAF6
    FLAG_UNK_AF7 = 0xAF7
    FLAG_UNK_AF8 = 0xAF8
    FLAG_UNK_AF9 = 0xAF9
    FLAG_UNK_AFA = 0xAFA
    FLAG_UNK_AFB = 0xAFB
    FLAG_UNK_AFC = 0xAFC
    FLAG_UNK_AFD = 0xAFD
    FLAG_UNK_AFE = 0xAFE
    FLAG_UNK_AFF = 0xAFF
    FLAG_UNK_B00 = 0xB00
    FLAG_UNK_B01 = 0xB01
    FLAG_UNK_B02 = 0xB02
    FLAG_UNK_B03 = 0xB03
    FLAG_UNK_B04 = 0xB04
    FLAG_UNK_B05 = 0xB05
    FLAG_UNK_B06 = 0xB06
    FLAG_UNK_B07 = 0xB07
    FLAG_UNK_B08 = 0xB08
    FLAG_UNK_B09 = 0xB09
    FLAG_UNK_B0A = 0xB0A
    FLAG_UNK_B0B = 0xB0B
    FLAG_UNK_B0C = 0xB0C
    FLAG_UNK_B0D = 0xB0D
    FLAG_UNK_B0E = 0xB0E
    FLAG_UNK_B0F = 0xB0F
    FLAG_UNK_B10 = 0xB10
    FLAG_UNK_B11 = 0xB11
    FLAG_UNK_B12 = 0xB12
    FLAG_UNK_B13 = 0xB13
    FLAG_UNK_B14 = 0xB14
    FLAG_UNK_B15 = 0xB15
    FLAG_UNK_B16 = 0xB16
    FLAG_UNK_B17 = 0xB17
    FLAG_UNK_B18 = 0xB18
    FLAG_UNK_B19 = 0xB19
    FLAG_UNK_B1A = 0xB1A
    FLAG_UNK_B1B = 0xB1B
    FLAG_UNK_B1C = 0xB1C
    FLAG_UNK_B1D = 0xB1D
    FLAG_UNK_B1E = 0xB1E
    FLAG_UNK_B1F = 0xB1F
    FLAG_UNK_B20 = 0xB20
    FLAG_UNK_B21 = 0xB21
    FLAG_UNK_B22 = 0xB22
    FLAG_UNK_B23 = 0xB23
    FLAG_UNK_B24 = 0xB24
    FLAG_UNK_B25 = 0xB25
    FLAG_UNK_B26 = 0xB26
    FLAG_UNK_B27 = 0xB27
    FLAG_UNK_B28 = 0xB28
    FLAG_UNK_B29 = 0xB29
    FLAG_UNK_B2A = 0xB2A
    FLAG_UNK_B2B = 0xB2B
    FLAG_UNK_B2C = 0xB2C
    FLAG_UNK_B2D = 0xB2D
    FLAG_UNK_B2E = 0xB2E
    FLAG_UNK_B2F = 0xB2F
    FLAG_UNK_B30 = 0xB30
    FLAG_UNK_B31 = 0xB31
    FLAG_UNK_B32 = 0xB32
    FLAG_UNK_B33 = 0xB33
    FLAG_UNK_B34 = 0xB34
    FLAG_UNK_B35 = 0xB35
    FLAG_UNK_B36 = 0xB36
    FLAG_UNK_B37 = 0xB37
    FLAG_UNK_B38 = 0xB38
    FLAG_UNK_B39 = 0xB39
    FLAG_UNK_B3A = 0xB3A
    FLAG_UNK_B3B = 0xB3B
    FLAG_UNK_B3C = 0xB3C
    FLAG_UNK_B3D = 0xB3D
    FLAG_UNK_B3E = 0xB3E
    FLAG_UNK_B3F = 0xB3F
    FLAG_UNK_B40 = 0xB40
    FLAG_UNK_B41 = 0xB41
    FLAG_UNK_B42 = 0xB42
    FLAG_UNK_B43 = 0xB43
    FLAG_UNK_B44 = 0xB44
    FLAG_UNK_B45 = 0xB45
    FLAG_UNK_B46 = 0xB46
    FLAG_UNK_B47 = 0xB47
    FLAG_UNK_B48 = 0xB48
    FLAG_UNK_B49 = 0xB49
    FLAG_UNK_B4A = 0xB4A
    FLAG_UNK_B4B = 0xB4B
    FLAG_UNK_B4C = 0xB4C
    FLAG_UNK_B4D = 0xB4D
    FLAG_UNK_B4E = 0xB4E
    FLAG_UNK_B4F = 0xB4F
    FLAG_UNK_B50 = 0xB50
    FLAG_UNK_B51 = 0xB51
    FLAG_UNK_B52 = 0xB52
    FLAG_UNK_B53 = 0xB53
    FLAG_UNK_B54 = 0xB54
    FLAG_UNK_B55 = 0xB55
    FLAG_UNK_B56 = 0xB56
    FLAG_UNK_B57 = 0xB57
    FLAG_UNK_B58 = 0xB58
    FLAG_UNK_B59 = 0xB59
    FLAG_UNK_B5A = 0xB5A
    FLAG_UNK_B5B = 0xB5B
    FLAG_UNK_B5C = 0xB5C
    FLAG_UNK_B5D = 0xB5D
    FLAG_UNK_B5E = 0xB5E
    FLAG_UNK_B5F = 0xB5F
    FLAG_TEMP_x4000 = 0x4000
    FLAG_TEMP_x4001 = 0x4001
    FLAG_TEMP_x4002 = 0x4002
    FLAG_TEMP_x4003 = 0x4003
    FLAG_TEMP_x4004 = 0x4004
    FLAG_TEMP_x4005 = 0x4005
    FLAG_TEMP_x4006 = 0x4006
    FLAG_TEMP_x4007 = 0x4007
    FLAG_TEMP_x4008 = 0x4008
    FLAG_TEMP_x4009 = 0x4009
    FLAG_TEMP_x400A = 0x400A
    FLAG_TEMP_x400B = 0x400B
    FLAG_TEMP_x400C = 0x400C
    FLAG_TEMP_x400D = 0x400D
    FLAG_TEMP_x400E = 0x400E
    FLAG_TEMP_x400F = 0x400F
    FLAG_TEMP_x4010 = 0x4010
    FLAG_TEMP_x4011 = 0x4011
    FLAG_TEMP_x4012 = 0x4012
    FLAG_TEMP_x4013 = 0x4013
    FLAG_TEMP_x4014 = 0x4014
    FLAG_TEMP_x4015 = 0x4015
    FLAG_TEMP_x4016 = 0x4016
    FLAG_TEMP_x4017 = 0x4017
    FLAG_TEMP_x4018 = 0x4018
    FLAG_TEMP_x4019 = 0x4019
    FLAG_TEMP_x401A = 0x401A
    FLAG_TEMP_x401B = 0x401B
    FLAG_TEMP_x401C = 0x401C
    FLAG_TEMP_x401D = 0x401D
    FLAG_TEMP_x401E = 0x401E
    FLAG_TEMP_x401F = 0x401F
    FLAG_TEMP_x4020 = 0x4020
    FLAG_TEMP_x4021 = 0x4021
    FLAG_TEMP_x4022 = 0x4022
    FLAG_TEMP_x4023 = 0x4023
    FLAG_TEMP_x4024 = 0x4024
    FLAG_TEMP_x4025 = 0x4025
    FLAG_TEMP_x4026 = 0x4026
    FLAG_TEMP_x4027 = 0x4027
    FLAG_TEMP_x4028 = 0x4028
    FLAG_TEMP_x4029 = 0x4029
    FLAG_TEMP_x402A = 0x402A
    FLAG_TEMP_x402B = 0x402B
    FLAG_TEMP_x402C = 0x402C
    FLAG_TEMP_x402D = 0x402D
    FLAG_TEMP_x402E = 0x402E
    FLAG_TEMP_x402F = 0x402F
    FLAG_TEMP_x4030 = 0x4030
    FLAG_TEMP_x4031 = 0x4031
    FLAG_TEMP_x4032 = 0x4032
    FLAG_TEMP_x4033 = 0x4033
    FLAG_TEMP_x4034 = 0x4034
    FLAG_TEMP_x4035 = 0x4035
    FLAG_TEMP_x4036 = 0x4036
    FLAG_TEMP_x4037 = 0x4037
    FLAG_TEMP_x4038 = 0x4038
    FLAG_TEMP_x4039 = 0x4039
    FLAG_TEMP_x403A = 0x403A
    FLAG_TEMP_x403B = 0x403B
    FLAG_TEMP_x403C = 0x403C
    FLAG_TEMP_x403D = 0x403D
    FLAG_TEMP_x403E = 0x403E
    FLAG_TEMP_x403F = 0x403F

BADGE_ZEPHYR = 0
    BADGE_HIVE = 1
    BADGE_PLAIN = 2
    BADGE_FOG = 3
    BADGE_STORM = 4
    BADGE_MINERAL = 5
    BADGE_GLACIER = 6
    BADGE_RISING = 7
    BADGE_BOULDER = 8
    BADGE_CASCADE = 9
    BADGE_THUNDER = 10
    BADGE_RAINBOW = 11
    BADGE_SOUL = 12
    BADGE_MARSH = 13
    BADGE_VOLCANO = 14
    BADGE_EARTH = 15

ABILITY_NONE = 0
    ABILITY_STENCH = 1
    ABILITY_DRIZZLE = 2
    ABILITY_SPEED_BOOST = 3
    ABILITY_BATTLE_ARMOR = 4
    ABILITY_STURDY = 5
    ABILITY_DAMP = 6
    ABILITY_LIMBER = 7
    ABILITY_SAND_VEIL = 8
    ABILITY_STATIC = 9
    ABILITY_VOLT_ABSORB = 10
    ABILITY_WATER_ABSORB = 11
    ABILITY_OBLIVIOUS = 12
    ABILITY_CLOUD_NINE = 13
    ABILITY_COMPOUNDEYES = 14
    ABILITY_INSOMNIA = 15
    ABILITY_COLOR_CHANGE = 16
    ABILITY_IMMUNITY = 17
    ABILITY_FLASH_FIRE = 18
    ABILITY_SHIELD_DUST = 19
    ABILITY_OWN_TEMPO = 20
    ABILITY_SUCTION_CUPS = 21
    ABILITY_INTIMIDATE = 22
    ABILITY_SHADOW_TAG = 23
    ABILITY_ROUGH_SKIN = 24
    ABILITY_WONDER_GUARD = 25
    ABILITY_LEVITATE = 26
    ABILITY_EFFECT_SPORE = 27
    ABILITY_SYNCHRONIZE = 28
    ABILITY_CLEAR_BODY = 29
    ABILITY_NATURAL_CURE = 30
    ABILITY_LIGHTNINGROD = 31
    ABILITY_SERENE_GRACE = 32
    ABILITY_SWIFT_SWIM = 33
    ABILITY_CHLOROPHYLL = 34
    ABILITY_ILLUMINATE = 35
    ABILITY_TRACE = 36
    ABILITY_HUGE_POWER = 37
    ABILITY_POISON_POINT = 38
    ABILITY_INNER_FOCUS = 39
    ABILITY_MAGMA_ARMOR = 40
    ABILITY_WATER_VEIL = 41
    ABILITY_MAGNET_PULL = 42
    ABILITY_SOUNDPROOF = 43
    ABILITY_RAIN_DISH = 44
    ABILITY_SAND_STREAM = 45
    ABILITY_PRESSURE = 46
    ABILITY_THICK_FAT = 47
    ABILITY_EARLY_BIRD = 48
    ABILITY_FLAME_BODY = 49
    ABILITY_RUN_AWAY = 50
    ABILITY_KEEN_EYE = 51
    ABILITY_HYPER_CUTTER = 52
    ABILITY_PICKUP = 53
    ABILITY_TRUANT = 54
    ABILITY_HUSTLE = 55
    ABILITY_CUTE_CHARM = 56
    ABILITY_PLUS = 57
    ABILITY_MINUS = 58
    ABILITY_FORECAST = 59
    ABILITY_STICKY_HOLD = 60
    ABILITY_SHED_SKIN = 61
    ABILITY_GUTS = 62
    ABILITY_MARVEL_SCALE = 63
    ABILITY_LIQUID_OOZE = 64
    ABILITY_OVERGROW = 65
    ABILITY_BLAZE = 66
    ABILITY_TORRENT = 67
    ABILITY_SWARM = 68
    ABILITY_ROCK_HEAD = 69
    ABILITY_DROUGHT = 70
    ABILITY_ARENA_TRAP = 71
    ABILITY_VITAL_SPIRIT = 72
    ABILITY_WHITE_SMOKE = 73
    ABILITY_PURE_POWER = 74
    ABILITY_SHELL_ARMOR = 75
    ABILITY_AIR_LOCK = 76
    ABILITY_TANGLED_FEET = 77
    ABILITY_MOTOR_DRIVE = 78
    ABILITY_RIVALRY = 79
    ABILITY_STEADFAST = 80
    ABILITY_SNOW_CLOAK = 81
    ABILITY_GLUTTONY = 82
    ABILITY_ANGER_POINT = 83
    ABILITY_UNBURDEN = 84
    ABILITY_HEATPROOF = 85
    ABILITY_SIMPLE = 86
    ABILITY_DRY_SKIN = 87
    ABILITY_DOWNLOAD = 88
    ABILITY_IRON_FIST = 89
    ABILITY_POISON_HEAL = 90
    ABILITY_ADAPTABILITY = 91
    ABILITY_SKILL_LINK = 92
    ABILITY_HYDRATION = 93
    ABILITY_SOLAR_POWER = 94
    ABILITY_QUICK_FEET = 95
    ABILITY_NORMALIZE = 96
    ABILITY_SNIPER = 97
    ABILITY_MAGIC_GUARD = 98
    ABILITY_NO_GUARD = 99
    ABILITY_STALL = 100
    ABILITY_TECHNICIAN = 101
    ABILITY_LEAF_GUARD = 102
    ABILITY_KLUTZ = 103
    ABILITY_MOLD_BREAKER = 104
    ABILITY_SUPER_LUCK = 105
    ABILITY_AFTERMATH = 106
    ABILITY_ANTICIPATION = 107
    ABILITY_FOREWARN = 108
    ABILITY_UNAWARE = 109
    ABILITY_TINTED_LENS = 110
    ABILITY_FILTER = 111
    ABILITY_SLOW_START = 112
    ABILITY_SCRAPPY = 113
    ABILITY_STORM_DRAIN = 114
    ABILITY_ICE_BODY = 115
    ABILITY_SOLID_ROCK = 116
    ABILITY_SNOW_WARNING = 117
    ABILITY_HONEY_GATHER = 118
    ABILITY_FRISK = 119
    ABILITY_RECKLESS = 120
    ABILITY_MULTITYPE = 121
    ABILITY_FLOWER_GIFT = 122
    ABILITY_BAD_DREAMS = 123

BALL_NONE = 0
    BALL_MASTER = 1
    BALL_ULTRA = 2
    BALL_GREAT = 3
    BALL_POKE = 4
    BALL_SAFARI = 5
    BALL_NET = 6
    BALL_DIVE = 7
    BALL_NEST = 8
    BALL_REPEAT = 9
    BALL_TIMER = 10
    BALL_LUXURY = 11
    BALL_PREMIER = 12
    BALL_DUSK = 13
    BALL_HEAL = 14
    BALL_QUICK = 15
    BALL_CHERISH = 16
    BALL_FAST = 17
    BALL_LEVEL = 18
    BALL_LURE = 19
    BALL_HEAVY = 20
    BALL_LOVE = 21
    BALL_FRIEND = 22
    BALL_MOON = 23
    BALL_SPORT = 24
    BALL_PARK = 25

BSCRIPT_VAR_BATTLE_TYPE = 0
    BSCRIPT_VAR_CRITICAL_BOOSTS = 1
    BSCRIPT_VAR_SIDE_EFFECT_FLAGS_DIRECT = 2
    BSCRIPT_VAR_SIDE_EFFECT_FLAGS_INDIRECT = 3
    BSCRIPT_VAR_SIDE_EFFECT_FLAGS_ABILITY = 4
    BSCRIPT_VAR_SIDE_EFFECT_TYPE = 5
    BSCRIPT_VAR_BATTLE_STATUS = 6
    BSCRIPT_VAR_FIELD_CONDITION = 7
    BSCRIPT_VAR_POWER_MULTI = 8
    BSCRIPT_VAR_CALC_TEMP = 9
    BSCRIPT_VAR_MOVE_STATUS_FLAGS = 10
    BSCRIPT_VAR_SIDE_CONDITION_ATTACKER = 11
    BSCRIPT_VAR_SIDE_CONDITION_TARGET = 12
    BSCRIPT_VAR_SIDE_CONDITION_STAT_CHANGE = 13
    BSCRIPT_VAR_DAMAGE = 14
    BSCRIPT_VAR_BATTLER_ATTACKER = 15
    BSCRIPT_VAR_BATTLER_TARGET = 16
    BSCRIPT_VAR_BATTLER_STAT_CHANGE = 17
    BSCRIPT_VAR_BATTLER_FAINTED = 18
    BSCRIPT_VAR_BATTLER_SWITCH = 19
    BSCRIPT_VAR_MSG_BATTLER_TEMP = 20
    BSCRIPT_VAR_ATTACKER_STORED_DAMAGE = 21
    BSCRIPT_VAR_MESSAGE = 22
    BSCRIPT_VAR_PAY_DAY_COUNT = 23
    BSCRIPT_VAR_MOVE_NO_CUR = 24
    BSCRIPT_VAR_TOTAL_TURNS = 25
    BSCRIPT_VAR_MSG_ATTACKER = 26
    BSCRIPT_VAR_MSG_DEFENDER = 27
    BSCRIPT_VAR_MOVE_NO_TEMP = 28
    BSCRIPT_VAR_LAST_BATTLER_ID = 29
    BSCRIPT_VAR_MOVE_POWER = 30
    BSCRIPT_VAR_AFTER_MOVE_MESSAGE_TYPE = 31
    BSCRIPT_VAR_HP_CALC = 32
    BSCRIPT_VAR_BATTLE_OUTCOME = 33
    BSCRIPT_VAR_SIDE_EFFECT_PARAM = 34
    BSCRIPT_VAR_MSG_MOVE_TEMP = 35
    BSCRIPT_VAR_MSG_ITEM_TEMP = 36
    BSCRIPT_VAR_MSG_ABILITY_TEMP = 37
    BSCRIPT_VAR_WEATHER_TURNS = 38
    BSCRIPT_VAR_BATTLER_SPEED_TEMP = 39
    BSCRIPT_VAR_MULTI_HIT_LOOP = 40
    BSCRIPT_VAR_PHYSICAL_DAMAGE = 41
    BSCRIPT_VAR_SPECIAL_DAMAGE = 42
    BSCRIPT_VAR_TEMP_DATA = 43
    BSCRIPT_VAR_CRIT_MULTIPLIER = 44
    BSCRIPT_VAR_ATTACKER_LAST_DAMAGE_TAKEN = 45
    BSCRIPT_VAR_DEFENDER_LAST_DAMAGE_TAKEN = 46
    BSCRIPT_VAR_ATTACKER_SELF_TURN_STATUS_FLAGS = 47
    BSCRIPT_VAR_DEFENDER_SELF_TURN_STATUS_FLAGS = 48
    BSCRIPT_VAR_SIDE_EFFECT_MON_SELF_TURN_STATUS_FLAGS = 49
    BSCRIPT_VAR_FLING_DATA = 50
    BSCRIPT_VAR_FLING_SCRIPT = 51
    BSCRIPT_VAR_BATTLE_SYS_STATUS = 52
    BSCRIPT_VAR_ATTACKER_LOCKED_MOVE = 53
    BSCRIPT_VAR_HIT_DAMAGE = 54
    BSCRIPT_VAR_SAFARI_BALL_CNT = 55
    BSCRIPT_VAR_SWITCHED_MON_TEMP = 56
    BSCRIPT_VAR_MOVE_TYPE = 57
    BSCRIPT_VAR_MOVE_EFFECT_CHANCE = 58
    BSCRIPT_VAR_REGULATION_FLAG = 59
    BSCRIPT_VAR_BATTLE_STATUS_2 = 60
    BSCRIPT_VAR_TURN_ORDER_COUNTER = 61
    BSCRIPT_VAR_MAX_BATTLERS = 62
    BSCRIPT_VAR_BATTLER_ATTACKER_TEMP = 63
    BSCRIPT_VAR_BATTLER_TARGET_TEMP = 64
    BSCRIPT_VAR_PHYSICAL_DAMAGE_TAKEN = 65
    BSCRIPT_VAR_MSG_BATTLER_TEMP_ASSURANCE_DAMAGE_MASK = 66
    BSCRIPT_VAR_DEFENDER_ASSURANCE_DAMAGE_MASK = 67
    BSCRIPT_VAR_ATTACKER_SHELL_BELL_DAMAGE_DEALT = 68
    BSCRIPT_VAR_WAITING_BATTLERS = 69
    BSCRIPT_VAR_70 = 70

BATTLE_SUBSCRIPT_NONE = 0
    BATTLE_SUBSCRIPT_START_ENCOUNTER = 0
    BATTLE_SUBSCRIPT_USE_MOVE = 1
    BATTLE_SUBSCRIPT_UPDATE_HP = 2
    BATTLE_SUBSCRIPT_ESCAPE = 3
    BATTLE_SUBSCRIPT_BATTLE_WON = 4
    BATTLE_SUBSCRIPT_BATTLE_LOST = 5
    BATTLE_SUBSCRIPT_FAINT_MON = 6
    BATTLE_SUBSCRIPT_MISSED = 7
    BATTLE_SUBSCRIPT_ESCAPE_FAILED = 8
    BATTLE_SUBSCRIPT_SWITCH_POKEMON = 9
    BATTLE_SUBSCRIPT_SHOW_PARTY_LIST = 10
    BATTLE_SUBSCRIPT_THROW_POKEBALL = 11
    BATTLE_SUBSCRIPT_UPDATE_STAT_STAGE = 12
    BATTLE_SUBSCRIPT_VANISH_ON_CHARGE_TURN = 13
    BATTLE_SUBSCRIPT_FLINCH_MON = 14
    BATTLE_SUBSCRIPT_FLINCHED = 15
    BATTLE_SUBSCRIPT_CRITICAL_HIT = 16
    BATTLE_SUBSCRIPT_HIT_X_TIMES = 17
    BATTLE_SUBSCRIPT_FALL_ASLEEP = 18
    BATTLE_SUBSCRIPT_WAKE_UP = 19
    BATTLE_SUBSCRIPT_SLEEPING = 20
    BATTLE_SUBSCRIPT_MOVE_FOLLOWUP_MESSAGE = 21
    BATTLE_SUBSCRIPT_POISON = 22
    BATTLE_SUBSCRIPT_POISON_DAMAGE = 23
    BATTLE_SUBSCRIPT_DRAIN_HALF_DAMAGE_DEALT = 24
    BATTLE_SUBSCRIPT_BURN = 25
    BATTLE_SUBSCRIPT_BURN_DAMAGE = 26
    BATTLE_SUBSCRIPT_FREEZE = 27
    BATTLE_SUBSCRIPT_FROZEN = 28
    BATTLE_SUBSCRIPT_THAW_OUT = 29
    BATTLE_SUBSCRIPT_DEFROSTED_BY_MOVE = 30
    BATTLE_SUBSCRIPT_PARALYZE = 31
    BATTLE_SUBSCRIPT_FULLY_PARALYZED = 32
    BATTLE_SUBSCRIPT_DREAM_EATER = 33
    BATTLE_SUBSCRIPT_RESET_ALL_STAT_STAGES = 34
    BATTLE_SUBSCRIPT_BIDE_START = 35
    BATTLE_SUBSCRIPT_BIDE_END = 36
    BATTLE_SUBSCRIPT_CONFUSE = 37
    BATTLE_SUBSCRIPT_CONFUSED = 38
    BATTLE_SUBSCRIPT_HURT_SELF_IN_CONFUSION = 39
    BATTLE_SUBSCRIPT_SNAP_OUT_OF_CONFUSION = 40
    BATTLE_SUBSCRIPT_TRAINER_MESSAGE = 41
    BATTLE_SUBSCRIPT_NO_PP = 42
    BATTLE_SUBSCRIPT_STRUGGLE = 43
    BATTLE_SUBSCRIPT_THRASH = 44
    BATTLE_SUBSCRIPT_CONVERSION = 45
    BATTLE_SUBSCRIPT_RECOVER_HALF_MAX_HP = 46
    BATTLE_SUBSCRIPT_BADLY_POISON = 47
    BATTLE_SUBSCRIPT_PAY_DAY = 48
    BATTLE_SUBSCRIPT_LIGHT_SCREEN = 49
    BATTLE_SUBSCRIPT_MOVE_EFFECT_END = 50
    BATTLE_SUBSCRIPT_THRASH_END = 51
    BATTLE_SUBSCRIPT_REFLECT = 52
    BATTLE_SUBSCRIPT_ANIMATION_PREPARED_MESSAGE = 53
    BATTLE_SUBSCRIPT_MIST = 54
    BATTLE_SUBSCRIPT_REST = 55
    BATTLE_SUBSCRIPT_UPROAR = 56
    BATTLE_SUBSCRIPT_SHOW_PREPARED_MESSAGE = 57
    BATTLE_SUBSCRIPT_BIND_START = 58
    BATTLE_SUBSCRIPT_BIND_EFFECT = 59
    BATTLE_SUBSCRIPT_BIND_END = 60
    BATTLE_SUBSCRIPT_CRASH_ON_MISS = 61
    BATTLE_SUBSCRIPT_FOCUS_ENERGY = 62
    BATTLE_SUBSCRIPT_RECOIL_1_4 = 63
    BATTLE_SUBSCRIPT_RECHARGE_TURN = 64
    BATTLE_SUBSCRIPT_RECHARGING = 65
    BATTLE_SUBSCRIPT_SET_RAGE_FLAG = 66
    BATTLE_SUBSCRIPT_MIMIC = 67
    BATTLE_SUBSCRIPT_LEECH_SEED_START = 68
    BATTLE_SUBSCRIPT_LEECH_SEED_EFFECT = 69
    BATTLE_SUBSCRIPT_DISABLE_START = 70
    BATTLE_SUBSCRIPT_MOVE_IS_DISABLED = 71
    BATTLE_SUBSCRIPT_DISABLE_END = 72
    BATTLE_SUBSCRIPT_ENCORE_START = 73
    BATTLE_SUBSCRIPT_ENCORE_END = 74
    BATTLE_SUBSCRIPT_BUT_IT_FAILED = 75
    BATTLE_SUBSCRIPT_ATTACK_MESSAGE_AND_ANIMATION = 76
    BATTLE_SUBSCRIPT_PAIN_SPLIT = 77
    BATTLE_SUBSCRIPT_CONVERSION_2 = 78
    BATTLE_SUBSCRIPT_LOCK_ON = 79
    BATTLE_SUBSCRIPT_SKETCH = 80
    BATTLE_SUBSCRIPT_FEINT = 81
    BATTLE_SUBSCRIPT_DESTINY_BOND = 82
    BATTLE_SUBSCRIPT_FAINT_CHECK_DESTINY_BOND = 83
    BATTLE_SUBSCRIPT_REDUCE_TARGET_PP = 84
    BATTLE_SUBSCRIPT_STEAL_ITEM = 85
    BATTLE_SUBSCRIPT_MEAN_LOOK = 86
    BATTLE_SUBSCRIPT_PROTECT = 87
    BATTLE_SUBSCRIPT_HEAL_BELL = 88
    BATTLE_SUBSCRIPT_TRY_SUBSTITUTE = 89
    BATTLE_SUBSCRIPT_HIT_SUBSTITUTE = 90
    BATTLE_SUBSCRIPT_FORCE_TARGET_TO_SWITCH_OR_FLEE = 91
    BATTLE_SUBSCRIPT_TRANSFORM_INTO_TARGET = 92
    BATTLE_SUBSCRIPT_NIGHTMARE_START = 93
    BATTLE_SUBSCRIPT_NIGHTMARE_EFFECT = 94
    BATTLE_SUBSCRIPT_MINIMIZE = 95
    BATTLE_SUBSCRIPT_CURSE_NORMAL = 96
    BATTLE_SUBSCRIPT_CURSE_GHOST = 97
    BATTLE_SUBSCRIPT_CURSE_DAMAGE = 98
    BATTLE_SUBSCRIPT_HAZARDS_CHECK = 99
    BATTLE_SUBSCRIPT_FORESIGHT = 100
    BATTLE_SUBSCRIPT_PERISH_SONG_START = 101
    BATTLE_SUBSCRIPT_CONTINUE_PERISH_SONG = 102
    BATTLE_SUBSCRIPT_WEATHER_START = 103
    BATTLE_SUBSCRIPT_WEATHER_CONTINUES = 104
    BATTLE_SUBSCRIPT_SWAGGER = 105
    BATTLE_SUBSCRIPT_INFATUATE = 106
    BATTLE_SUBSCRIPT_INFATUATED = 107
    BATTLE_SUBSCRIPT_IMMOBILIZED_BY_LOVE = 108
    BATTLE_SUBSCRIPT_SAFEGUARD_START = 109
    BATTLE_SUBSCRIPT_SAFEGUARD_END = 110
    BATTLE_SUBSCRIPT_RECOVER_HP = 111
    BATTLE_SUBSCRIPT_PRESENT_HEAL = 112
    BATTLE_SUBSCRIPT_MAGNITUDE = 113
    BATTLE_SUBSCRIPT_BATON_PASS = 114
    BATTLE_SUBSCRIPT_RAPID_SPIN = 115
    BATTLE_SUBSCRIPT_BREAK_BIND_EFFECT = 116
    BATTLE_SUBSCRIPT_BLOW_AWAY_HAZARDS = 117
    BATTLE_SUBSCRIPT_GIVE_TARGET_OWN_STATUS = 118
    BATTLE_SUBSCRIPT_BOOST_ALL_STATS = 119
    BATTLE_SUBSCRIPT_BELLY_DRUM = 120
    BATTLE_SUBSCRIPT_FUTURE_SIGHT_DAMAGE = 121
    BATTLE_SUBSCRIPT_TELEPORT = 122
    BATTLE_SUBSCRIPT_FUTURE_SIGHT_START = 123
    BATTLE_SUBSCRIPT_STOCKPILE = 124
    BATTLE_SUBSCRIPT_SWALLOW = 125
    BATTLE_SUBSCRIPT_PRINT_MESSAGE_AND_PLAY_ANIMATION = 126
    BATTLE_SUBSCRIPT_TORMENT_START = 127
    BATTLE_SUBSCRIPT_FLATTER = 128
    BATTLE_SUBSCRIPT_MEMENTO = 129
    BATTLE_SUBSCRIPT_HEAL_TARGET_PARALYSIS = 130
    BATTLE_SUBSCRIPT_CHARGE = 131
    BATTLE_SUBSCRIPT_TAUNT_START = 132
    BATTLE_SUBSCRIPT_MOVE_FAIL_TAUNTED = 133
    BATTLE_SUBSCRIPT_EXCHANGE_ITEMS = 134
    BATTLE_SUBSCRIPT_COPY_ABILITY = 135
    BATTLE_SUBSCRIPT_WISH_HEAL = 136
    BATTLE_SUBSCRIPT_INGRAIN_HEAL = 137
    BATTLE_SUBSCRIPT_USER_ATK_AND_DEF_DOWN_1_STAGE = 138
    BATTLE_SUBSCRIPT_MAGIC_COAT = 139
    BATTLE_SUBSCRIPT_BREAK_SCREENS = 140
    BATTLE_SUBSCRIPT_YAWN = 141
    BATTLE_SUBSCRIPT_KNOCK_OFF = 142
    BATTLE_SUBSCRIPT_EXCHANGE_ABILITIES = 143
    BATTLE_SUBSCRIPT_MOVE_IS_IMPRISONED = 144
    BATTLE_SUBSCRIPT_RECOVER_PSN_PRZ_BRN = 145
    BATTLE_SUBSCRIPT_SNATCH = 146
    BATTLE_SUBSCRIPT_RECOIL_1_3 = 147
    BATTLE_SUBSCRIPT_TARGET_ATK_AND_DEF_DOWN_1_STAGE = 148
    BATTLE_SUBSCRIPT_USER_DEF_AND_SPDEF_UP_1_STAGE = 149
    BATTLE_SUBSCRIPT_USER_ATK_AND_DEF_UP_1_STAGE = 150
    BATTLE_SUBSCRIPT_USER_SPATK_AND_SPDEF_UP_1_STAGE = 151
    BATTLE_SUBSCRIPT_USER_ATK_AND_SPEED_UP_1_STAGE = 152
    BATTLE_SUBSCRIPT_PURSUIT = 153
    BATTLE_SUBSCRIPT_ROOST = 154
    BATTLE_SUBSCRIPT_HEAL_TARGET_SLEEP = 155
    BATTLE_SUBSCRIPT_GRAVITY_START = 156
    BATTLE_SUBSCRIPT_MOVE_FAIL_GRAVITY = 157
    BATTLE_SUBSCRIPT_MIRACLE_EYE = 158
    BATTLE_SUBSCRIPT_HEALING_WISH = 159
    BATTLE_SUBSCRIPT_TAILWIND_START = 160
    BATTLE_SUBSCRIPT_USER_DEF_AND_SPDEF_DOWN_1_STAGE = 161
    BATTLE_SUBSCRIPT_USER_SWAP_ATK_AND_DEF = 162
    BATTLE_SUBSCRIPT_SUPPRESS_TARGET_ABILITY = 163
    BATTLE_SUBSCRIPT_LUCKY_CHANT_START = 164
    BATTLE_SUBSCRIPT_EXCHANGE_ATK_AND_SPATK_STAGES = 165
    BATTLE_SUBSCRIPT_EXCHANGE_DEF_AND_SPDEF_STAGES = 166
    BATTLE_SUBSCRIPT_GIVE_TARGET_INSOMNIA = 167
    BATTLE_SUBSCRIPT_EXCHANGE_ALL_STAT_STAGES = 168
    BATTLE_SUBSCRIPT_AQUA_RING_HEAL = 169
    BATTLE_SUBSCRIPT_RECOIL_1_3_CHANCE_TO_BURN = 170
    BATTLE_SUBSCRIPT_DEFOG = 171
    BATTLE_SUBSCRIPT_DEFOG_MESSAGE = 172
    BATTLE_SUBSCRIPT_HEAL_BLOCK_START = 173
    BATTLE_SUBSCRIPT_MOVE_IS_HEAL_BLOCKED = 174
    BATTLE_SUBSCRIPT_ATTACK_THEN_SWITCH_OUT = 175
    BATTLE_SUBSCRIPT_MOVE_FAIL_MISSED = 176
    BATTLE_SUBSCRIPT_MOLD_BREAKER = 177
    BATTLE_SUBSCRIPT_ABILITY_RESTORES_HP = 178
    BATTLE_SUBSCRIPT_ABSORB_AND_BOOST_FIRE_TYPE_MOVES = 179
    BATTLE_SUBSCRIPT_LIGHTNING_ROD_REDIRECTED = 180
    BATTLE_SUBSCRIPT_BLOCKED_BY_SOUNDPROOF = 181
    BATTLE_SUBSCRIPT_ABSORB_AND_SPEED_UP_1_STAGE = 182
    BATTLE_SUBSCRIPT_DRIZZLE = 183
    BATTLE_SUBSCRIPT_SAND_STREAM = 184
    BATTLE_SUBSCRIPT_DROUGHT = 185
    BATTLE_SUBSCRIPT_INTIMIDATE = 186
    BATTLE_SUBSCRIPT_TRACE = 187
    BATTLE_SUBSCRIPT_COLOR_CHANGE = 188
    BATTLE_SUBSCRIPT_ROUGH_SKIN = 189
    BATTLE_SUBSCRIPT_ABILITY_RESTORE_STATUS = 190
    BATTLE_SUBSCRIPT_LOAFING_AROUND = 191
    BATTLE_SUBSCRIPT_ABILITY_HP_RESTORE_GRADUAL = 192
    BATTLE_SUBSCRIPT_AFTERMATH = 193
    BATTLE_SUBSCRIPT_ANTICIPATION = 194
    BATTLE_SUBSCRIPT_FOREWARN = 195
    BATTLE_SUBSCRIPT_SLOW_START = 196
    BATTLE_SUBSCRIPT_SLOW_START_END = 197
    BATTLE_SUBSCRIPT_HELD_ITEM_HP_RESTORE = 198
    BATTLE_SUBSCRIPT_HELD_ITEM_PRZ_RESTORE = 199
    BATTLE_SUBSCRIPT_HELD_ITEM_SLP_RESTORE = 200
    BATTLE_SUBSCRIPT_HELD_ITEM_PSN_RESTORE = 201
    BATTLE_SUBSCRIPT_HELD_ITEM_BRN_RESTORE = 202
    BATTLE_SUBSCRIPT_HELD_ITEM_FRZ_RESTORE = 203
    BATTLE_SUBSCRIPT_HELD_ITEM_PP_RESTORE = 204
    BATTLE_SUBSCRIPT_HELD_ITEM_CNF_RESTORE = 205
    BATTLE_SUBSCRIPT_HELD_ITEM_MULTI_RESTORE = 206
    BATTLE_SUBSCRIPT_HELD_ITEM_DISLIKE_FLAVOR = 207
    BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_STAT = 208
    BATTLE_SUBSCRIPT_HELD_ITEM_RAISE_CRIT = 209
    BATTLE_SUBSCRIPT_HELD_ITEM_SHARPLY_RAISE_STAT = 210
    BATTLE_SUBSCRIPT_HELD_ITEM_STATDOWN_RESTORE = 211
    BATTLE_SUBSCRIPT_HELD_ITEM_HEAL_INFATUATION = 212
    BATTLE_SUBSCRIPT_RESTORE_A_LITTLE_HP = 213
    BATTLE_SUBSCRIPT_LOSE_HP_FROM_ITEM = 214
    BATTLE_SUBSCRIPT_LOSE_HP_FROM_ITEM_WITH_MESSAGE = 215
    BATTLE_SUBSCRIPT_TRANSFER_STICKY_BARB = 216
    BATTLE_SUBSCRIPT_ITEM_SKIP_CHARGE_TURN = 217
    BATTLE_SUBSCRIPT_EMBARGO_START = 218
    BATTLE_SUBSCRIPT_PLUCK = 219
    BATTLE_SUBSCRIPT_FLING = 220
    BATTLE_SUBSCRIPT_ABILITY_FORBIDS_STATUS = 221
    BATTLE_SUBSCRIPT_ESCAPE_ITEM = 222
    BATTLE_SUBSCRIPT_BATTLE_ITEM = 223
    BATTLE_SUBSCRIPT_BAG_ITEM_HP_RESTORE = 224
    BATTLE_SUBSCRIPT_BAG_ITEM_PP_RESTORE = 225
    BATTLE_SUBSCRIPT_RECOIL_1_3_CHANCE_TO_PARALYZE = 226
    BATTLE_SUBSCRIPT_SAFARI_THROW_BAIT = 227
    BATTLE_SUBSCRIPT_SAFARI_THROW_ROCK = 228
    BATTLE_SUBSCRIPT_SAFARI_ESCAPE = 229
    BATTLE_SUBSCRIPT_ENEMY_ESCAPE = 230
    BATTLE_SUBSCRIPT_REPLACE_FAINTED = 231
    BATTLE_SUBSCRIPT_TIGHTEN_FOCUS = 232
    BATTLE_SUBSCRIPT_TAILWIND_END = 233
    BATTLE_SUBSCRIPT_RAINING_END = 234
    BATTLE_SUBSCRIPT_SANDSTORM_END = 235
    BATTLE_SUBSCRIPT_SUNNY_END = 236
    BATTLE_SUBSCRIPT_HAILING_END = 237
    BATTLE_SUBSCRIPT_GRAVITY_END = 238
    BATTLE_SUBSCRIPT_CANNOT_HEAL = 239
    BATTLE_SUBSCRIPT_UPROAR_CONTINUES = 240
    BATTLE_SUBSCRIPT_UPROAR_END = 241
    BATTLE_SUBSCRIPT_MAGNET_RISE_END = 242
    BATTLE_SUBSCRIPT_HEAL_BLOCK_END = 243
    BATTLE_SUBSCRIPT_EMBARGO_END = 244
    BATTLE_SUBSCRIPT_RAGE_IS_BUILDING = 245
    BATTLE_SUBSCRIPT_RECOIL_1_2 = 246
    BATTLE_SUBSCRIPT_BURN_OR_FLINCH = 247
    BATTLE_SUBSCRIPT_FREEZE_OR_FLINCH = 248
    BATTLE_SUBSCRIPT_PARALYZE_OR_FLINCH = 249
    BATTLE_SUBSCRIPT_LUCKY_CHANT_END = 250
    BATTLE_SUBSCRIPT_TRICK_ROOM_END = 251
    BATTLE_SUBSCRIPT_SNOW_WARNING = 252
    BATTLE_SUBSCRIPT_FRISK = 253
    BATTLE_SUBSCRIPT_DISOBEY_WHILE_ASLEEP = 254
    BATTLE_SUBSCRIPT_DISOBEY_DO_NOTHING = 255
    BATTLE_SUBSCRIPT_DISOBEY_ORDERS = 256
    BATTLE_SUBSCRIPT_DISOBEY_SLEEP = 257
    BATTLE_SUBSCRIPT_DISOBEY_HIT_SELF = 258
    BATTLE_SUBSCRIPT_CHARGE_MOVE_CLEANUP = 259
    BATTLE_SUBSCRIPT_CHATTER = 260
    BATTLE_SUBSCRIPT_LUNAR_DANCE = 261
    BATTLE_SUBSCRIPT_FORM_CHANGE = 262
    BATTLE_SUBSCRIPT_BAD_DREAMS = 263
    BATTLE_SUBSCRIPT_TYPE_RESIST_BERRY = 264
    BATTLE_SUBSCRIPT_HELD_ITEM_TEMP_ACC_UP = 265
    BATTLE_SUBSCRIPT_HELD_ITEM_RECOIL_WHEN_HIT = 266
    BATTLE_SUBSCRIPT_USE_POTION = 267
    BATTLE_SUBSCRIPT_USE_STATUS_RECOVERY = 268
    BATTLE_SUBSCRIPT_USE_STAT_BOOSTER = 269
    BATTLE_SUBSCRIPT_USE_GUARD_SPEC = 270
    BATTLE_SUBSCRIPT_OVERWORLD_RAIN = 271
    BATTLE_SUBSCRIPT_OVERWORLD_HAIL = 272
    BATTLE_SUBSCRIPT_OVERWORLD_SAND = 273
    BATTLE_SUBSCRIPT_OVERWORLD_FOG = 274
    BATTLE_SUBSCRIPT_THROW_SAFARI_BALL = 275
    BATTLE_SUBSCRIPT_GRANT_EXP = 276
    BATTLE_SUBSCRIPT_AFTER_SELFDESTRUCT = 277
    BATTLE_SUBSCRIPT_CHECK_QUICK_CLAW = 278
    BATTLE_SUBSCRIPT_PUSH_ATTACKER_AND_DEFENDER = 279
    BATTLE_SUBSCRIPT_POP_ATTACKER_AND_DEFENDER = 280
    BATTLE_SUBSCRIPT_NO_TARGET = 281
    BATTLE_SUBSCRIPT_BIDE_NO_TARGET = 282
    BATTLE_SUBSCRIPT_LINK_WIN_LOSE = 283
    BATTLE_SUBSCRIPT_ESCAPE_SUCCESS = 284
    BATTLE_SUBSCRIPT_PRESSURE = 285
    BATTLE_SUBSCRIPT_ENEMY_ESCAPE_FAILED = 286
    BATTLE_SUBSCRIPT_VANISH_OFF = 287
    BATTLE_SUBSCRIPT_TAUNT_END = 288
    BATTLE_SUBSCRIPT_USE_FULL_RESTORE = 289
    BATTLE_SUBSCRIPT_PLUCK_CHECK = 290
    BATTLE_SUBSCRIPT_WAIT_MOVE_ANIMATION = 291
    BATTLE_SUBSCRIPT_POWER_HERB_SKULL_BASH = 292
    BATTLE_SUBSCRIPT_CHECK_SHAYMIN_FORM = 293
    BATTLE_SUBSCRIPT_OVERWORLD_SUN = 294
    BATTLE_SUBSCRIPT_OVERWORLD_TRICK_ROOM = 295
    BATTLE_SUBSCRIPT_GIRATINA_FORM_CHANGE = 296

MOVE_SUBSCRIPT_PTR_NONE = 0
    MOVE_SUBSCRIPT_PTR_SLEEP = 1
    MOVE_SUBSCRIPT_PTR_POISON = 2
    MOVE_SUBSCRIPT_PTR_BURN = 3
    MOVE_SUBSCRIPT_PTR_FREEZE = 4
    MOVE_SUBSCRIPT_PTR_PARALYZE = 5
    MOVE_SUBSCRIPT_PTR_BADLY_POISON = 6
    MOVE_SUBSCRIPT_PTR_CONFUSE = 7
    MOVE_SUBSCRIPT_PTR_FLINCH = 8
    MOVE_SUBSCRIPT_PTR_REST = 9
    MOVE_SUBSCRIPT_PTR_UPROAR = 10
    MOVE_SUBSCRIPT_PTR_PAY_DAY = 11
    MOVE_SUBSCRIPT_PTR_VANISH_CHARGE_TURN = 12
    MOVE_SUBSCRIPT_PTR_BIND_TARGET = 13
    MOVE_SUBSCRIPT_PTR_QUARTER_RECOIL = 14
    MOVE_SUBSCRIPT_PTR_ATTACK_UP_1_STAGE = 15
    MOVE_SUBSCRIPT_PTR_DEFENSE_UP_1_STAGE = 16
    MOVE_SUBSCRIPT_PTR_SPEED_UP_1_STAGE = 17
    MOVE_SUBSCRIPT_PTR_SP_ATTACK_UP_1_STAGE = 18
    MOVE_SUBSCRIPT_PTR_SP_DEFENSE_UP_1_STAGE = 19
    MOVE_SUBSCRIPT_PTR_ACCURACY_UP_1_STAGE = 20
    MOVE_SUBSCRIPT_PTR_EVASION_UP_1_STAGE = 21
    MOVE_SUBSCRIPT_PTR_ATTACK_DOWN_1_STAGE = 22
    MOVE_SUBSCRIPT_PTR_DEFENSE_DOWN_1_STAGE = 23
    MOVE_SUBSCRIPT_PTR_SPEED_DOWN_1_STAGE = 24
    MOVE_SUBSCRIPT_PTR_SP_ATTACK_DOWN_1_STAGE = 25
    MOVE_SUBSCRIPT_PTR_SP_DEFENSE_DOWN_1_STAGE = 26
    MOVE_SUBSCRIPT_PTR_ACCURACY_DOWN_1_STAGE = 27
    MOVE_SUBSCRIPT_PTR_EVASION_DOWN_1_STAGE = 28
    MOVE_SUBSCRIPT_PTR_RECHARGE_TURN = 29
    MOVE_SUBSCRIPT_PTR_SET_RAGE_FLAG = 30
    MOVE_SUBSCRIPT_PTR_STEAL_ITEM = 31
    MOVE_SUBSCRIPT_PTR_MEAN_LOOK = 32
    MOVE_SUBSCRIPT_PTR_NIGHTMARE_START = 33
    MOVE_SUBSCRIPT_PTR_BOOST_ALL_STATS = 34
    MOVE_SUBSCRIPT_PTR_RAPID_SPIN = 35
    MOVE_SUBSCRIPT_PTR_HEAL_TARGET_PARALYSIS = 36
    MOVE_SUBSCRIPT_PTR_USER_ATK_AND_DEF_DOWN_1_STAGE = 37
    MOVE_SUBSCRIPT_PTR_RECOIL_1_3 = 38
    MOVE_SUBSCRIPT_PTR_ATTACK_UP_2_STAGES = 39
    MOVE_SUBSCRIPT_PTR_DEFENSE_UP_2_STAGES = 40
    MOVE_SUBSCRIPT_PTR_SPEED_UP_2_STAGES = 41
    MOVE_SUBSCRIPT_PTR_SP_ATTACK_UP_2_STAGES = 42
    MOVE_SUBSCRIPT_PTR_SP_DEFENSE_UP_2_STAGES = 43
    MOVE_SUBSCRIPT_PTR_ACCURACY_UP_2_STAGES = 44
    MOVE_SUBSCRIPT_PTR_EVASION_UP_2_STAGES = 45
    MOVE_SUBSCRIPT_PTR_ATTACK_DOWN_2_STAGES = 46
    MOVE_SUBSCRIPT_PTR_DEFENSE_DOWN_2_STAGES = 47
    MOVE_SUBSCRIPT_PTR_SPEED_DOWN_2_STAGES = 48
    MOVE_SUBSCRIPT_PTR_SP_ATTACK_DOWN_2_STAGES = 49
    MOVE_SUBSCRIPT_PTR_SP_DEFENSE_DOWN_2_STAGES = 50
    MOVE_SUBSCRIPT_PTR_ACCURACY_DOWN_2_STAGES = 51
    MOVE_SUBSCRIPT_PTR_EVASION_DOWN_2_STAGES = 52
    MOVE_SUBSCRIPT_PTR_THRASH = 53
    MOVE_SUBSCRIPT_PTR_KNOCK_OFF = 54
    MOVE_SUBSCRIPT_PTR_USER_DEF_AND_SPDEF_UP_1_STAGE = 55
    MOVE_SUBSCRIPT_PTR_USER_ATK_AND_DEF_UP_1_STAGE = 56
    MOVE_SUBSCRIPT_PTR_TARGET_ATK_AND_DEF_DOWN_1_STAGE = 57
    MOVE_SUBSCRIPT_PTR_USER_SPATK_AND_SPDEF_UP_1_STAGE = 58
    MOVE_SUBSCRIPT_PTR_USER_ATK_AND_SPEED_UP_1_STAGE = 59
    MOVE_SUBSCRIPT_PTR_DRAIN_HALF_DAMAGE_DEALT = 60
    MOVE_SUBSCRIPT_PTR_DREAM_EATER = 61
    MOVE_SUBSCRIPT_PTR_RESET_ALL_STAT_STAGES = 62
    MOVE_SUBSCRIPT_PTR_BIDE_START = 63
    MOVE_SUBSCRIPT_PTR_STRUGGLE = 64
    MOVE_SUBSCRIPT_PTR_CONVERSION = 65
    MOVE_SUBSCRIPT_PTR_RECOVER_HALF_MAX_HP = 66
    MOVE_SUBSCRIPT_PTR_LIGHT_SCREEN = 67
    MOVE_SUBSCRIPT_PTR_REFLECT = 68
    MOVE_SUBSCRIPT_PTR_MIST = 69
    MOVE_SUBSCRIPT_PTR_FOCUS_ENERGY = 70
    MOVE_SUBSCRIPT_PTR_MIMIC = 71
    MOVE_SUBSCRIPT_PTR_LEECH_SEED_START = 72
    MOVE_SUBSCRIPT_PTR_DISABLE_START = 73
    MOVE_SUBSCRIPT_PTR_ENCORE_START = 74
    MOVE_SUBSCRIPT_PTR_PAIN_SPLIT = 75
    MOVE_SUBSCRIPT_PTR_CONVERSION_2 = 76
    MOVE_SUBSCRIPT_PTR_LOCK_ON = 77
    MOVE_SUBSCRIPT_PTR_SKETCH = 78
    MOVE_SUBSCRIPT_PTR_FEINT = 79
    MOVE_SUBSCRIPT_PTR_DESTINY_BOND = 80
    MOVE_SUBSCRIPT_PTR_REDUCE_TARGET_PP = 81
    MOVE_SUBSCRIPT_PTR_PROTECT = 82
    MOVE_SUBSCRIPT_PTR_HEAL_BELL = 83
    MOVE_SUBSCRIPT_PTR_TRY_SUBSTITUTE = 84
    MOVE_SUBSCRIPT_PTR_FORCE_TARGET_TO_SWITCH_OR_FLEE = 85
    MOVE_SUBSCRIPT_PTR_TRANSFORM_INTO_TARGET = 86
    MOVE_SUBSCRIPT_PTR_MINIMIZE = 87
    MOVE_SUBSCRIPT_PTR_CURSE_NORMAL = 88
    MOVE_SUBSCRIPT_PTR_CURSE_GHOST = 89
    MOVE_SUBSCRIPT_PTR_PRINT_MESSAGE_AND_PLAY_ANIMATION = 90
    MOVE_SUBSCRIPT_PTR_FORESIGHT = 91
    MOVE_SUBSCRIPT_PTR_PERISH_SONG_START = 92
    MOVE_SUBSCRIPT_PTR_WEATHER_START = 93
    MOVE_SUBSCRIPT_PTR_SWAGGER = 94
    MOVE_SUBSCRIPT_PTR_INFATUATE = 95
    MOVE_SUBSCRIPT_PTR_SAFEGUARD_START = 96
    MOVE_SUBSCRIPT_PTR_PRESENT_HEAL = 97
    MOVE_SUBSCRIPT_PTR_MAGNITUDE = 98
    MOVE_SUBSCRIPT_PTR_BATON_PASS = 99
    MOVE_SUBSCRIPT_PTR_BELLY_DRUM = 100
    MOVE_SUBSCRIPT_PTR_TELEPORT = 101
    MOVE_SUBSCRIPT_PTR_FUTURE_SIGHT_START = 102
    MOVE_SUBSCRIPT_PTR_STOCKPILE = 103
    MOVE_SUBSCRIPT_PTR_SWALLOW = 104
    MOVE_SUBSCRIPT_PTR_TORMENT_START = 105
    MOVE_SUBSCRIPT_PTR_FLATTER = 106
    MOVE_SUBSCRIPT_PTR_MEMENTO = 107
    MOVE_SUBSCRIPT_PTR_CHARGE = 108
    MOVE_SUBSCRIPT_PTR_TAUNT_START = 109
    MOVE_SUBSCRIPT_PTR_EXCHANGE_ITEMS = 110
    MOVE_SUBSCRIPT_PTR_COPY_ABILITY = 111
    MOVE_SUBSCRIPT_PTR_BREAK_SCREENS = 112
    MOVE_SUBSCRIPT_PTR_YAWN = 113
    MOVE_SUBSCRIPT_PTR_EXCHANGE_ABILITIES = 114
    MOVE_SUBSCRIPT_PTR_RECOVER_PSN_PRZ_BRN = 115
    MOVE_SUBSCRIPT_PTR_ROOST = 116
    MOVE_SUBSCRIPT_PTR_HEAL_TARGET_SLEEP = 117
    MOVE_SUBSCRIPT_PTR_GRAVITY_START = 118
    MOVE_SUBSCRIPT_PTR_MIRACLE_EYE = 119
    MOVE_SUBSCRIPT_PTR_HEALING_WISH = 120
    MOVE_SUBSCRIPT_PTR_TAILWIND_START = 121
    MOVE_SUBSCRIPT_PTR_USER_DEF_AND_SPDEF_DOWN_1_STAGE = 122
    MOVE_SUBSCRIPT_PTR_USER_SWAP_ATK_AND_DEF = 123
    MOVE_SUBSCRIPT_PTR_SUPPRESS_TARGET_ABILITY = 124
    MOVE_SUBSCRIPT_PTR_LUCKY_CHANT_START = 125
    MOVE_SUBSCRIPT_PTR_EXCHANGE_ATK_AND_SPATK_STAGES = 126
    MOVE_SUBSCRIPT_PTR_EXCHANGE_DEF_AND_SPDEF_STAGES = 127
    MOVE_SUBSCRIPT_PTR_GIVE_TARGET_INSOMNIA = 128
    MOVE_SUBSCRIPT_PTR_EXCHANGE_ALL_STAT_STAGES = 129
    MOVE_SUBSCRIPT_PTR_RECOIL_1_3_CHANCE_TO_BURN = 130
    MOVE_SUBSCRIPT_PTR_DEFOG = 131
    MOVE_SUBSCRIPT_PTR_HEAL_BLOCK_START = 132
    MOVE_SUBSCRIPT_PTR_ATTACK_THEN_SWITCH_OUT = 133
    MOVE_SUBSCRIPT_PTR_EMBARGO_START = 134
    MOVE_SUBSCRIPT_PTR_PLUCK = 135
    MOVE_SUBSCRIPT_PTR_FLING = 136
    MOVE_SUBSCRIPT_PTR_RECOIL_1_3_CHANCE_TO_PARALYZE = 137
    MOVE_SUBSCRIPT_PTR_RECOIL_1_2 = 138
    MOVE_SUBSCRIPT_PTR_BURN_OR_FLINCH = 139
    MOVE_SUBSCRIPT_PTR_FREEZE_OR_FLINCH = 140
    MOVE_SUBSCRIPT_PTR_PARALYZE_OR_FLINCH = 141
    MOVE_SUBSCRIPT_PTR_CHATTER = 142
    MOVE_SUBSCRIPT_PTR_LUNAR_DANCE = 143
    MOVE_SUBSCRIPT_PTR_GIVE_TARGET_OWN_STATUS = 144

BATTLE_ANIMATION_NONE = 0
    BATTLE_ANIMATION_ASLEEP = 1
    BATTLE_ANIMATION_POISONED = 2
    BATTLE_ANIMATION_BURNED = 3
    BATTLE_ANIMATION_FROZEN = 4
    BATTLE_ANIMATION_PARALYZED = 5
    BATTLE_ANIMATION_CONFUSED = 6
    BATTLE_ANIMATION_INFATUATED = 7
    BATTLE_ANIMATION_LEVEL_UP = 8
    BATTLE_ANIMATION_BAG_ITEM = 9
    BATTLE_ANIMATION_HELD_ITEM = 10
    BATTLE_ANIMATION_SHINY = 11
    BATTLE_ANIMATION_STAT_BOOST = 12
    BATTLE_ANIMATION_STAT_DROP = 13
    BATTLE_ANIMATION_RESTORE_HP = 14
    BATTLE_ANIMATION_SUB_OUT = 15
    BATTLE_ANIMATION_SUB_IN = 16
    BATTLE_ANIMATION_ITEM_ESCAPE = 17
    BATTLE_ANIMATION_WEATHER_FOG = 18
    BATTLE_ANIMATION_WEATHER_RAIN = 19
    BATTLE_ANIMATION_WEATHER_HAIL = 20
    BATTLE_ANIMATION_WEATHER_SAND = 21
    BATTLE_ANIMATION_WEATHER_SUN = 22

BATTLE_ANIMATION_SUBSTITUTE_IN = 25
    BATTLE_ANIMATION_SUBSTITUTE_OUT = 26
    BATTLE_ANIMATION_HAPPY = 27
    BATTLE_ANIMATION_EATING = 28
    BATTLE_ANIMATION_ANGRY = 29
    BATTLE_ANIMATION_DAMAGE_CURSE = 30
    BATTLE_ANIMATION_DAMAGE_NIGHTMARE = 31
    BATTLE_ANIMATION_DAMAGE_LEECH_SEED = 32
    BATTLE_ANIMATION_DAMAGE_BIND = 33
    BATTLE_ANIMATION_DAMAGE_WRAP = 34
    BATTLE_ANIMATION_DAMAGE_FIRE_SPIN = 35
    BATTLE_ANIMATION_DAMAGE_MAGMA_STORM = 36
    BATTLE_ANIMATION_DAMAGE_CLAMP = 37
    BATTLE_ANIMATION_DAMAGE_WHIRLPOOL = 38
    BATTLE_ANIMATION_DAMAGE_SAND_TOMB = 39
    BATTLE_ANIMATION_DAMAGE_INGRAIN = 40

TRAINER_MESSAGE_LOSE = 1
    TRAINER_MESSAGE_LOSE_1 = 4
    TRAINER_MESSAGE_LOSE_2 = 8
    TRAINER_MESSAGE_20 = 20
    TRAINER_MESSAGE_WIN = 100



TURN_FLAG_STRUGGLING = 0
    TURN_FLAG_PP_DECREMENTED = 1
    TURN_FLAG_PROTECTING = 2
    TURN_FLAG_HELPING_HAND = 3
    TURN_FLAG_MAGIC_COAT = 4
    TURN_FLAG_SNATCHING = 5
    TURN_FLAG_ROOSTING = 6

GAME_THROW_POKE_BALL = 0
    GAME_THROW_SAFARI_BALL = 1
    GAME_THROW_SAFARI_ROCK = 2
    GAME_THROW_SAFARI_BAIT = 3
    GAME_THROW_PARK_BALL = 4
    GAME_THROW_SPORT_BALL = 5

BATTLER_NONE = 0xFF
    BATTLER_PLAYER = 0
    BATTLER_ENEMY = 1
    BATTLER_PLAYER2 = 2
    BATTLER_ENEMY2 = 3
    BATTLER_MAX = 4

BATTLER_TYPE_SOLO_PLAYER = 0
    BATTLER_TYPE_SOLO_ENEMY = 1
    BATTLER_TYPE_PLAYER_SIDE_SLOT_1 = 2
    BATTLER_TYPE_ENEMY_SIDE_SLOT_1 = 3
    BATTLER_TYPE_PLAYER_SIDE_SLOT_2 = 4
    BATTLER_TYPE_ENEMY_SIDE_SLOT_2 = 5

BATTLER_CATEGORY_ALL = 0
    BATTLER_CATEGORY_ATTACKER = 1
    BATTLER_CATEGORY_DEFENDER = 2
    BATTLER_CATEGORY_PLAYER = 3
    BATTLER_CATEGORY_ENEMY = 4
    BATTLER_CATEGORY_FAINTED_MON = 5
    BATTLER_CATEGORY_SWITCHED_MON = 6
    BATTLER_CATEGORY_SIDE_EFFECT_MON = 7
    BATTLER_CATEGORY_ABILITY_MON = 8
    BATTLER_CATEGORY_PLAYER_SLOT_1 = 9
    BATTLER_CATEGORY_ENEMY_SLOT_1 = 10
    BATTLER_CATEGORY_PLAYER_SLOT_2 = 11
    BATTLER_CATEGORY_ENEMY_SLOT_2 = 12
    BATTLER_CATEGORY_UNDEFINED_13 = 13
    BATTLER_CATEGORY_MSG_ATTACKER = 14
    BATTLER_CATEGORY_MSG_DEFENDER = 15
    BATTLER_CATEGORY_ATTACKER_PARTNER = 16
    BATTLER_CATEGORY_DEFENDER_PARTNER = 17
    BATTLER_CATEGORY_FORCED_OUT = 18
    BATTLER_CATEGORY_ATTACKER_ENEMY = 19
    BATTLER_CATEGORY_DEFENDER_ENEMY = 20
    BATTLER_CATEGORY_MSG_BATTLER_TEMP = 21
    BATTLER_CATEGORY_SWITCHED_MON_AFTER = 22
    BATTLER_CATEGORY_MSG_TEMP = 0xFF

DECORATION_NONE = 0
    DECORATION_DUMMY_1 = 1
    DECORATION_DUMMY_2 = 2
    DECORATION_DUMMY_3 = 3
    DECORATION_DUMMY_4 = 4
    DECORATION_DUMMY_5 = 5
    DECORATION_BIG_BOULDER = 6
    DECORATION_YELLOW_CUSHION = 7
    DECORATION_BLUE_CUSHION = 8
    DECORATION_WOODEN_CHAIR = 9
    DECORATION_BIG_TABLE = 10
    DECORATION_PLAIN_TABLE = 11
    DECORATION_SMALL_TABLE = 12
    DECORATION_LONG_TABLE = 13
    DECORATION_WIDE_TABLE = 14
    DECORATION_POKE_TABLE = 15
    DECORATION_BIG_BOOKSHELF = 16
    DECORATION_SMALL_BOOKSHELF = 17
    DECORATION_RESEARCH_SHELF = 18
    DECORATION_BIKE_RACK = 19
    DECORATION_SHOP_SHELF = 20
    DECORATION_DISPLAY_SHELF = 21
    DECORATION_CUPBOARD = 22
    DECORATION_WOOD_DRESSER = 23
    DECORATION_PINK_DRESSER = 24
    DECORATION_TV = 25
    DECORATION_REFRIGERATOR = 26
    DECORATION_PRETTY_SINK = 27
    DECORATION_FEATHERY_BED = 28
    DECORATION_TRASH_CAN = 29
    DECORATION_CARDBOARD_BOX = 30
    DECORATION_CRATE = 31
    DECORATION_CONTAINER = 32
    DECORATION_OIL_DRUM = 33
    DECORATION_BIG_OIL_DRUM = 34
    DECORATION_IRON_BEAM = 35
    DECORATION_POTTED_PLANT = 36
    DECORATION_POKE_FLOWER = 37
    DECORATION_HEALING_MACHINE = 38
    DECORATION_LAB_MACHINE = 39
    DECORATION_TEST_MACHINE = 40
    DECORATION_GAME_SYSTEM = 41
    DECORATION_VENDING_MACHINE = 42
    DECORATION_RED_BIKE = 43
    DECORATION_GREEN_BIKE = 44
    DECORATION_BINOCULARS = 45
    DECORATION_GLOBE = 46
    DECORATION_GYM_STATUE = 47
    DECORATION_RED_TENT = 48
    DECORATION_BLUE_TENT = 49
    DECORATION_CLEAR_TENT = 50
    DECORATION_MAZE_BLOCK_1 = 51
    DECORATION_MAZE_BLOCK_2 = 52
    DECORATION_MAZE_BLOCK_3 = 53
    DECORATION_MAZE_BLOCK_4 = 54
    DECORATION_MAZE_BLOCK_5 = 55
    DECORATION_HOLE_TOOL = 56
    DECORATION_PIT_TOOL = 57
    DECORATION_SMOKE_TOOL = 58
    DECORATION_BIG_SMOKE_TOOL = 59
    DECORATION_ROCK_TOOL = 60
    DECORATION_ROCKFALL_TOOL = 61
    DECORATION_FOAM_TOOL = 62
    DECORATION_BUBBLE_TOOL = 63
    DECORATION_ALERT_TOOL_1 = 64
    DECORATION_ALERT_TOOL_2 = 65
    DECORATION_ALERT_TOOL_3 = 66
    DECORATION_ALERT_TOOL_4 = 67
    DECORATION_LEAF_TOOL = 68
    DECORATION_FLOWER_TOOL = 69
    DECORATION_EMBER_TOOL = 70
    DECORATION_FIRE_TOOL = 71
    DECORATION_CUTE_CUP = 72
    DECORATION_COOL_CUP = 73
    DECORATION_BEAUTY_CUP = 74
    DECORATION_TOUGH_CUP = 75
    DECORATION_CLEVER_CUP = 76
    DECORATION_BLUE_CRYSTAL = 77
    DECORATION_PINK_CRYSTAL = 78
    DECORATION_RED_CRYSTAL = 79
    DECORATION_YELLOW_CRYSTAL = 80
    DECORATION_PRETTY_GEM = 81
    DECORATION_SHINY_GEM = 82
    DECORATION_MYSTIC_GEM = 83
    DECORATION_GLITTER_GEM = 84
    DECORATION_BRONZE_TROPHY = 85
    DECORATION_SILVER_TROPHY = 86
    DECORATION_GOLD_TROPHY = 87
    DECORATION_GREAT_TROPHY = 88
    DECORATION_BALL_ORNAMENT = 89
    DECORATION_ROUND_ORNAMENT = 90
    DECORATION_CLEAR_ORNAMENT = 91
    DECORATION_CHARMANDER_DOLL = 92
    DECORATION_BULBASAUR_DOLL = 93
    DECORATION_SQUIRTLE_DOLL = 94
    DECORATION_CYNDAQUIL_DOLL = 95
    DECORATION_CHIKORITA_DOLL = 96
    DECORATION_TOTODILE_DOLL = 97
    DECORATION_TORCHIC_DOLL = 98
    DECORATION_TREECKO_DOLL = 99
    DECORATION_MUDKIP_DOLL = 100
    DECORATION_CHIMCHAR_DOLL = 101
    DECORATION_TURTWIG_DOLL = 102
    DECORATION_PIPLUP_DOLL = 103
    DECORATION_PIKACHU_DOLL = 104
    DECORATION_PLUSLE_DOLL = 105
    DECORATION_MINUN_DOLL = 106
    DECORATION_CLEFAIRY_DOLL = 107
    DECORATION_JIGGLYPUFF_DOLL = 108
    DECORATION_WOBBUFFET_DOLL = 109
    DECORATION_MEOWTH_DOLL = 110
    DECORATION_SKITTY_DOLL = 111
    DECORATION_GLAMEOW_DOLL = 112
    DECORATION_BUNEARY_DOLL = 113
    DECORATION_WEAVILE_DOLL = 114
    DECORATION_MUNCHLAX_DOLL = 115
    DECORATION_BONSLY_DOLL = 116
    DECORATION_MIME_JR__DOLL = 117
    DECORATION_LUCARIO_DOLL = 118
    DECORATION_MANTYKE_DOLL = 119
    DECORATION_BUIZEL_DOLL = 120
    DECORATION_CHATOT_DOLL = 121
    DECORATION_MANAPHY_DOLL = 122
    DECORATION_SNORLAX_DOLL = 123
    DECORATION_WAILORD_DOLL = 124
    DECORATION_MAGNEZONE_DOLL = 125
    DECORATION_DRIFLOON_DOLL = 126
    DECORATION_HAPPINY_DOLL = 127
    DECORATION_PACHIRISU_DOLL = 128
    DECORATION_129 = 129
    DECORATION_130 = 130
    DECORATION_131 = 131
    DECORATION_132 = 132
    DECORATION_WIDE_SOFA = 133
    DECORATION_BONSAI = 134
    DECORATION_DAINTY_FLOWERS = 135
    DECORATION_LOVELY_FLOWERS = 136
    DECORATION_PRETTY_FLOWERS = 137
    DECORATION_LAVISH_FLOWERS = 138

FOLLOWER_MON_NONE = 0
    FOLLOWER_MON_BULBASAUR = 0
    FOLLOWER_MON_IVYSAUR = 1
    FOLLOWER_MON_VENUSAUR = 2
    FOLLOWER_MON_VENUSAUR_F = 3
    FOLLOWER_MON_CHARMANDER = 4
    FOLLOWER_MON_CHARMELEON = 5
    FOLLOWER_MON_CHARIZARD = 6
    FOLLOWER_MON_SQUIRTLE = 7
    FOLLOWER_MON_WARTORTLE = 8
    FOLLOWER_MON_BLASTOISE = 9
    FOLLOWER_MON_CATERPIE = 10
    FOLLOWER_MON_METAPOD = 11
    FOLLOWER_MON_BUTTERFREE = 12
    FOLLOWER_MON_WEEDLE = 13
    FOLLOWER_MON_KAKUNA = 14
    FOLLOWER_MON_BEEDRILL = 15
    FOLLOWER_MON_PIDGEY = 16
    FOLLOWER_MON_PIDGEOTTO = 17
    FOLLOWER_MON_PIDGEOT = 18
    FOLLOWER_MON_RATTATA = 19
    FOLLOWER_MON_RATICATE = 20
    FOLLOWER_MON_SPEAROW = 21
    FOLLOWER_MON_FEAROW = 22
    FOLLOWER_MON_EKANS = 23
    FOLLOWER_MON_ARBOK = 24
    FOLLOWER_MON_PIKACHU = 25
    FOLLOWER_MON_PIKACHU_F = 26
    FOLLOWER_MON_RAICHU = 27
    FOLLOWER_MON_SANDSHREW = 28
    FOLLOWER_MON_SANDSLASH = 29
    FOLLOWER_MON_NIDORAN_F = 30
    FOLLOWER_MON_NIDORINA = 31
    FOLLOWER_MON_NIDOQUEEN = 32
    FOLLOWER_MON_NIDORAN_M = 33
    FOLLOWER_MON_NIDORINO = 34
    FOLLOWER_MON_NIDOKING = 35
    FOLLOWER_MON_CLEFAIRY = 36
    FOLLOWER_MON_CLEFABLE = 37
    FOLLOWER_MON_VULPIX = 38
    FOLLOWER_MON_NINETALES = 39
    FOLLOWER_MON_JIGGLYPUFF = 40
    FOLLOWER_MON_WIGGLYTUFF = 41
    FOLLOWER_MON_ZUBAT = 42
    FOLLOWER_MON_GOLBAT = 43
    FOLLOWER_MON_ODDISH = 44
    FOLLOWER_MON_GLOOM = 45
    FOLLOWER_MON_VILEPLUME = 46
    FOLLOWER_MON_PARAS = 47
    FOLLOWER_MON_PARASECT = 48
    FOLLOWER_MON_VENONAT = 49
    FOLLOWER_MON_VENOMOTH = 50
    FOLLOWER_MON_DIGLETT = 51
    FOLLOWER_MON_DUGTRIO = 52
    FOLLOWER_MON_MEOWTH = 53
    FOLLOWER_MON_PERSIAN = 54
    FOLLOWER_MON_PSYDUCK = 55
    FOLLOWER_MON_GOLDUCK = 56
    FOLLOWER_MON_MANKEY = 57
    FOLLOWER_MON_PRIMEAPE = 58
    FOLLOWER_MON_GROWLITHE = 59
    FOLLOWER_MON_ARCANINE = 60
    FOLLOWER_MON_POLIWAG = 61
    FOLLOWER_MON_POLIWHIRL = 62
    FOLLOWER_MON_POLIWRATH = 63
    FOLLOWER_MON_ABRA = 64
    FOLLOWER_MON_KADABRA = 65
    FOLLOWER_MON_ALAKAZAM = 66
    FOLLOWER_MON_MACHOP = 67
    FOLLOWER_MON_MACHOKE = 68
    FOLLOWER_MON_MACHAMP = 69
    FOLLOWER_MON_BELLSPROUT = 70
    FOLLOWER_MON_WEEPINBELL = 71
    FOLLOWER_MON_VICTREEBEL = 72
    FOLLOWER_MON_TENTACOOL = 73
    FOLLOWER_MON_TENTACRUEL = 74
    FOLLOWER_MON_GEODUDE = 75
    FOLLOWER_MON_GRAVELER = 76
    FOLLOWER_MON_GOLEM = 77
    FOLLOWER_MON_PONYTA = 78
    FOLLOWER_MON_RAPIDASH = 79
    FOLLOWER_MON_SLOWPOKE = 80
    FOLLOWER_MON_SLOWBRO = 81
    FOLLOWER_MON_MAGNEMITE = 82
    FOLLOWER_MON_MAGNETON = 83
    FOLLOWER_MON_FARFETCHD = 84
    FOLLOWER_MON_DODUO = 85
    FOLLOWER_MON_DODRIO = 86
    FOLLOWER_MON_SEEL = 87
    FOLLOWER_MON_DEWGONG = 88
    FOLLOWER_MON_GRIMER = 89
    FOLLOWER_MON_MUK = 90
    FOLLOWER_MON_SHELLDER = 91
    FOLLOWER_MON_CLOYSTER = 92
    FOLLOWER_MON_GASTLY = 93
    FOLLOWER_MON_HAUNTER = 94
    FOLLOWER_MON_GENGAR = 95
    FOLLOWER_MON_ONIX = 96
    FOLLOWER_MON_DROWZEE = 97
    FOLLOWER_MON_HYPNO = 98
    FOLLOWER_MON_KRABBY = 99
    FOLLOWER_MON_KINGLER = 100
    FOLLOWER_MON_VOLTORB = 101
    FOLLOWER_MON_ELECTRODE = 102
    FOLLOWER_MON_EXEGGCUTE = 103
    FOLLOWER_MON_EXEGGUTOR = 104
    FOLLOWER_MON_CUBONE = 105
    FOLLOWER_MON_MAROWAK = 106
    FOLLOWER_MON_HITMONLEE = 107
    FOLLOWER_MON_HITMONCHAN = 108
    FOLLOWER_MON_LICKITUNG = 109
    FOLLOWER_MON_KOFFING = 110
    FOLLOWER_MON_WEEZING = 111
    FOLLOWER_MON_RHYHORN = 112
    FOLLOWER_MON_RHYDON = 113
    FOLLOWER_MON_CHANSEY = 114
    FOLLOWER_MON_TANGELA = 115
    FOLLOWER_MON_KANGASKHAN = 116
    FOLLOWER_MON_HORSEA = 117
    FOLLOWER_MON_SEADRA = 118
    FOLLOWER_MON_GOLDEEN = 119
    FOLLOWER_MON_SEAKING = 120
    FOLLOWER_MON_STARYU = 121
    FOLLOWER_MON_STARMIE = 122
    FOLLOWER_MON_MR_MIME = 123
    FOLLOWER_MON_SCYTHER = 124
    FOLLOWER_MON_JYNX = 125
    FOLLOWER_MON_ELECTABUZZ = 126
    FOLLOWER_MON_MAGMAR = 127
    FOLLOWER_MON_PINSIR = 128
    FOLLOWER_MON_TAUROS = 129
    FOLLOWER_MON_MAGIKARP = 130
    FOLLOWER_MON_GYARADOS = 131
    FOLLOWER_MON_LAPRAS = 132
    FOLLOWER_MON_DITTO = 133
    FOLLOWER_MON_EEVEE = 134
    FOLLOWER_MON_VAPOREON = 135
    FOLLOWER_MON_JOLTEON = 136
    FOLLOWER_MON_FLAREON = 137
    FOLLOWER_MON_PORYGON = 138
    FOLLOWER_MON_OMANYTE = 139
    FOLLOWER_MON_OMASTAR = 140
    FOLLOWER_MON_KABUTO = 141
    FOLLOWER_MON_KABUTOPS = 142
    FOLLOWER_MON_AERODACTYL = 143
    FOLLOWER_MON_SNORLAX = 144
    FOLLOWER_MON_ARTICUNO = 145
    FOLLOWER_MON_ZAPDOS = 146
    FOLLOWER_MON_MOLTRES = 147
    FOLLOWER_MON_DRATINI = 148
    FOLLOWER_MON_DRAGONAIR = 149
    FOLLOWER_MON_DRAGONITE = 150
    FOLLOWER_MON_MEWTWO = 151
    FOLLOWER_MON_MEW = 152
    FOLLOWER_MON_CHIKORITA = 153
    FOLLOWER_MON_BAYLEEF = 154
    FOLLOWER_MON_MEGANIUM = 155
    FOLLOWER_MON_MEGANIUM_F = 156
    FOLLOWER_MON_CYNDAQUIL = 157
    FOLLOWER_MON_QUILAVA = 158
    FOLLOWER_MON_TYPHLOSION = 159
    FOLLOWER_MON_TOTODILE = 160
    FOLLOWER_MON_CROCONAW = 161
    FOLLOWER_MON_FERALIGATR = 162
    FOLLOWER_MON_SENTRET = 163
    FOLLOWER_MON_FURRET = 164
    FOLLOWER_MON_HOOTHOOT = 165
    FOLLOWER_MON_NOCTOWL = 166
    FOLLOWER_MON_LEDYBA = 167
    FOLLOWER_MON_LEDIAN = 168
    FOLLOWER_MON_SPINARAK = 169
    FOLLOWER_MON_ARIADOS = 170
    FOLLOWER_MON_CROBAT = 171
    FOLLOWER_MON_CHINCHOU = 172
    FOLLOWER_MON_LANTURN = 173
    FOLLOWER_MON_PICHU = 174
    FOLLOWER_MON_PICHU_SPIKY = 175
    FOLLOWER_MON_CLEFFA = 176
    FOLLOWER_MON_IGGLYBUFF = 177
    FOLLOWER_MON_TOGEPI = 178
    FOLLOWER_MON_TOGETIC = 179
    FOLLOWER_MON_NATU = 180
    FOLLOWER_MON_XATU = 181
    FOLLOWER_MON_MAREEP = 182
    FOLLOWER_MON_FLAAFFY = 183
    FOLLOWER_MON_AMPHAROS = 184
    FOLLOWER_MON_BELLOSSOM = 185
    FOLLOWER_MON_MARILL = 186
    FOLLOWER_MON_AZUMARILL = 187
    FOLLOWER_MON_SUDOWOODO = 188
    FOLLOWER_MON_POLITOED = 189
    FOLLOWER_MON_HOPPIP = 190
    FOLLOWER_MON_SKIPLOOM = 191
    FOLLOWER_MON_JUMPLUFF = 192
    FOLLOWER_MON_AIPOM = 193
    FOLLOWER_MON_SUNKERN = 194
    FOLLOWER_MON_SUNFLORA = 195
    FOLLOWER_MON_YANMA = 196
    FOLLOWER_MON_WOOPER = 197
    FOLLOWER_MON_QUAGSIRE = 198
    FOLLOWER_MON_ESPEON = 199
    FOLLOWER_MON_UMBREON = 200
    FOLLOWER_MON_MURKROW = 201
    FOLLOWER_MON_SLOWKING = 202
    FOLLOWER_MON_MISDREAVUS = 203
    FOLLOWER_MON_UNOWN_A = 204
    FOLLOWER_MON_UNOWN_B = 205
    FOLLOWER_MON_UNOWN_C = 206
    FOLLOWER_MON_UNOWN_D = 207
    FOLLOWER_MON_UNOWN_E = 208
    FOLLOWER_MON_UNOWN_F = 209
    FOLLOWER_MON_UNOWN_G = 210
    FOLLOWER_MON_UNOWN_H = 211
    FOLLOWER_MON_UNOWN_I = 212
    FOLLOWER_MON_UNOWN_J = 213
    FOLLOWER_MON_UNOWN_K = 214
    FOLLOWER_MON_UNOWN_L = 215
    FOLLOWER_MON_UNOWN_M = 216
    FOLLOWER_MON_UNOWN_N = 217
    FOLLOWER_MON_UNOWN_O = 218
    FOLLOWER_MON_UNOWN_P = 219
    FOLLOWER_MON_UNOWN_Q = 220
    FOLLOWER_MON_UNOWN_R = 221
    FOLLOWER_MON_UNOWN_S = 222
    FOLLOWER_MON_UNOWN_T = 223
    FOLLOWER_MON_UNOWN_U = 224
    FOLLOWER_MON_UNOWN_V = 225
    FOLLOWER_MON_UNOWN_W = 226
    FOLLOWER_MON_UNOWN_X = 227
    FOLLOWER_MON_UNOWN_Y = 228
    FOLLOWER_MON_UNOWN_Z = 229
    FOLLOWER_MON_UNOWN_QMARK = 230
    FOLLOWER_MON_UNOWN_EXCL = 231
    FOLLOWER_MON_WOBBUFFET = 232
    FOLLOWER_MON_WOBBUFFET_F = 233
    FOLLOWER_MON_GIRAFARIG = 234
    FOLLOWER_MON_PINECO = 235
    FOLLOWER_MON_FORRETRESS = 236
    FOLLOWER_MON_DUNSPARCE = 237
    FOLLOWER_MON_GLIGAR = 238
    FOLLOWER_MON_STEELIX = 239
    FOLLOWER_MON_STEELIX_F = 240
    FOLLOWER_MON_SNUBBULL = 241
    FOLLOWER_MON_GRANBULL = 242
    FOLLOWER_MON_QWILFISH = 243
    FOLLOWER_MON_SCIZOR = 244
    FOLLOWER_MON_SHUCKLE = 245
    FOLLOWER_MON_HERACROSS = 246
    FOLLOWER_MON_HERACROSS_F = 247
    FOLLOWER_MON_SNEASEL = 248
    FOLLOWER_MON_TEDDIURSA = 249
    FOLLOWER_MON_URSARING = 250
    FOLLOWER_MON_SLUGMA = 251
    FOLLOWER_MON_MAGCARGO = 252
    FOLLOWER_MON_SWINUB = 253
    FOLLOWER_MON_PILOSWINE = 254
    FOLLOWER_MON_CORSOLA = 255
    FOLLOWER_MON_REMORAID = 256
    FOLLOWER_MON_OCTILLERY = 257
    FOLLOWER_MON_DELIBIRD = 258
    FOLLOWER_MON_MANTINE = 259
    FOLLOWER_MON_SKARMORY = 260
    FOLLOWER_MON_HOUNDOUR = 261
    FOLLOWER_MON_HOUNDOOM = 262
    FOLLOWER_MON_KINGDRA = 263
    FOLLOWER_MON_PHANPY = 264
    FOLLOWER_MON_DONPHAN = 265
    FOLLOWER_MON_PORYGON2 = 266
    FOLLOWER_MON_STANTLER = 267
    FOLLOWER_MON_SMEARGLE = 268
    FOLLOWER_MON_TYROGUE = 269
    FOLLOWER_MON_HITMONTOP = 270
    FOLLOWER_MON_SMOOCHUM = 271
    FOLLOWER_MON_ELEKID = 272
    FOLLOWER_MON_MAGBY = 273
    FOLLOWER_MON_MILTANK = 274
    FOLLOWER_MON_BLISSEY = 275
    FOLLOWER_MON_RAIKOU = 276
    FOLLOWER_MON_ENTEI = 277
    FOLLOWER_MON_SUICUNE = 278
    FOLLOWER_MON_LARVITAR = 279
    FOLLOWER_MON_PUPITAR = 280
    FOLLOWER_MON_TYRANITAR = 281
    FOLLOWER_MON_LUGIA = 282
    FOLLOWER_MON_HO_OH = 283
    FOLLOWER_MON_CELEBI = 284
    FOLLOWER_MON_TREECKO = 285
    FOLLOWER_MON_GROVYLE = 286
    FOLLOWER_MON_SCEPTILE = 287
    FOLLOWER_MON_TORCHIC = 288
    FOLLOWER_MON_COMBUSKEN = 289
    FOLLOWER_MON_BLAZIKEN = 290
    FOLLOWER_MON_MUDKIP = 291
    FOLLOWER_MON_MARSHTOMP = 292
    FOLLOWER_MON_SWAMPERT = 293
    FOLLOWER_MON_POOCHYENA = 294
    FOLLOWER_MON_MIGHTYENA = 295
    FOLLOWER_MON_ZIGZAGOON = 296
    FOLLOWER_MON_LINOONE = 297
    FOLLOWER_MON_WURMPLE = 298
    FOLLOWER_MON_SILCOON = 299
    FOLLOWER_MON_BEAUTIFLY = 300
    FOLLOWER_MON_CASCOON = 301
    FOLLOWER_MON_DUSTOX = 302
    FOLLOWER_MON_LOTAD = 303
    FOLLOWER_MON_LOMBRE = 304
    FOLLOWER_MON_LUDICOLO = 305
    FOLLOWER_MON_SEEDOT = 306
    FOLLOWER_MON_NUZLEAF = 307
    FOLLOWER_MON_SHIFTRY = 308
    FOLLOWER_MON_TAILLOW = 309
    FOLLOWER_MON_SWELLOW = 310
    FOLLOWER_MON_WINGULL = 311
    FOLLOWER_MON_PELIPPER = 312
    FOLLOWER_MON_RALTS = 313
    FOLLOWER_MON_KIRLIA = 314
    FOLLOWER_MON_GARDEVOIR = 315
    FOLLOWER_MON_SURSKIT = 316
    FOLLOWER_MON_MASQUERAIN = 317
    FOLLOWER_MON_SHROOMISH = 318
    FOLLOWER_MON_BRELOOM = 319
    FOLLOWER_MON_SLAKOTH = 320
    FOLLOWER_MON_VIGOROTH = 321
    FOLLOWER_MON_SLAKING = 322
    FOLLOWER_MON_NINCADA = 323
    FOLLOWER_MON_NINJASK = 324
    FOLLOWER_MON_SHEDINJA = 325
    FOLLOWER_MON_WHISMUR = 326
    FOLLOWER_MON_LOUDRED = 327
    FOLLOWER_MON_EXPLOUD = 328
    FOLLOWER_MON_MAKUHITA = 329
    FOLLOWER_MON_HARIYAMA = 330
    FOLLOWER_MON_AZURILL = 331
    FOLLOWER_MON_NOSEPASS = 332
    FOLLOWER_MON_SKITTY = 333
    FOLLOWER_MON_DELCATTY = 334
    FOLLOWER_MON_SABLEYE = 335
    FOLLOWER_MON_MAWILE = 336
    FOLLOWER_MON_ARON = 337
    FOLLOWER_MON_LAIRON = 338
    FOLLOWER_MON_AGGRON = 339
    FOLLOWER_MON_MEDITITE = 340
    FOLLOWER_MON_MEDICHAM = 341
    FOLLOWER_MON_ELECTRIKE = 342
    FOLLOWER_MON_MANECTRIC = 343
    FOLLOWER_MON_PLUSLE = 344
    FOLLOWER_MON_MINUN = 345
    FOLLOWER_MON_VOLBEAT = 346
    FOLLOWER_MON_ILLUMISE = 347
    FOLLOWER_MON_ROSELIA = 348
    FOLLOWER_MON_GULPIN = 349
    FOLLOWER_MON_SWALOT = 350
    FOLLOWER_MON_CARVANHA = 351
    FOLLOWER_MON_SHARPEDO = 352
    FOLLOWER_MON_WAILMER = 353
    FOLLOWER_MON_WAILORD = 354
    FOLLOWER_MON_NUMEL = 355
    FOLLOWER_MON_CAMERUPT = 356
    FOLLOWER_MON_TORKOAL = 357
    FOLLOWER_MON_SPOINK = 358
    FOLLOWER_MON_GRUMPIG = 359
    FOLLOWER_MON_SPINDA = 360
    FOLLOWER_MON_TRAPINCH = 361
    FOLLOWER_MON_VIBRAVA = 362
    FOLLOWER_MON_FLYGON = 363
    FOLLOWER_MON_CACNEA = 364
    FOLLOWER_MON_CACTURNE = 365
    FOLLOWER_MON_SWABLU = 366
    FOLLOWER_MON_ALTARIA = 367
    FOLLOWER_MON_ZANGOOSE = 368
    FOLLOWER_MON_SEVIPER = 369
    FOLLOWER_MON_LUNATONE = 370
    FOLLOWER_MON_SOLROCK = 371
    FOLLOWER_MON_BARBOACH = 372
    FOLLOWER_MON_WHISCASH = 373
    FOLLOWER_MON_CORPHISH = 374
    FOLLOWER_MON_CRAWDAUNT = 375
    FOLLOWER_MON_BALTOY = 376
    FOLLOWER_MON_CLAYDOL = 377
    FOLLOWER_MON_LILEEP = 378
    FOLLOWER_MON_CRADILY = 379
    FOLLOWER_MON_ANORITH = 380
    FOLLOWER_MON_ARMALDO = 381
    FOLLOWER_MON_FEEBAS = 382
    FOLLOWER_MON_MILOTIC = 383
    FOLLOWER_MON_CASTFORM = 384
    FOLLOWER_MON_KECLEON = 385
    FOLLOWER_MON_SHUPPET = 386
    FOLLOWER_MON_BANETTE = 387
    FOLLOWER_MON_DUSKULL = 388
    FOLLOWER_MON_DUSCLOPS = 389
    FOLLOWER_MON_TROPIUS = 390
    FOLLOWER_MON_CHIMECHO = 391
    FOLLOWER_MON_ABSOL = 392
    FOLLOWER_MON_WYNAUT = 393
    FOLLOWER_MON_SNORUNT = 394
    FOLLOWER_MON_GLALIE = 395
    FOLLOWER_MON_SPHEAL = 396
    FOLLOWER_MON_SEALEO = 397
    FOLLOWER_MON_WALREIN = 398
    FOLLOWER_MON_CLAMPERL = 399
    FOLLOWER_MON_HUNTAIL = 400
    FOLLOWER_MON_GOREBYSS = 401
    FOLLOWER_MON_RELICANTH = 402
    FOLLOWER_MON_LUVDISC = 403
    FOLLOWER_MON_BAGON = 404
    FOLLOWER_MON_SHELGON = 405
    FOLLOWER_MON_SALAMENCE = 406
    FOLLOWER_MON_BELDUM = 407
    FOLLOWER_MON_METANG = 408
    FOLLOWER_MON_METAGROSS = 409
    FOLLOWER_MON_REGIROCK = 410
    FOLLOWER_MON_REGICE = 411
    FOLLOWER_MON_REGISTEEL = 412
    FOLLOWER_MON_LATIAS = 413
    FOLLOWER_MON_LATIOS = 414
    FOLLOWER_MON_KYOGRE = 415
    FOLLOWER_MON_GROUDON = 416
    FOLLOWER_MON_RAYQUAZA = 417
    FOLLOWER_MON_JIRACHI = 418
    FOLLOWER_MON_DEOXYS = 419
    FOLLOWER_MON_DEOXYS_ATK = 420
    FOLLOWER_MON_DEOXYS_DEF = 421
    FOLLOWER_MON_DEOXYS_SPD = 422
    FOLLOWER_MON_TURTWIG = 423
    FOLLOWER_MON_GROTLE = 424
    FOLLOWER_MON_TORTERRA = 425
    FOLLOWER_MON_CHIMCHAR = 426
    FOLLOWER_MON_MONFERNO = 427
    FOLLOWER_MON_INFERNAPE = 428
    FOLLOWER_MON_PIPLUP = 429
    FOLLOWER_MON_PRINPLUP = 430
    FOLLOWER_MON_EMPOLEON = 431
    FOLLOWER_MON_STARLY = 432
    FOLLOWER_MON_STARAVIA = 433
    FOLLOWER_MON_STARAPTOR = 434
    FOLLOWER_MON_BIDOOF = 435
    FOLLOWER_MON_BIBAREL = 436
    FOLLOWER_MON_KRICKETOT = 437
    FOLLOWER_MON_KRICKETUNE = 438
    FOLLOWER_MON_SHINX = 439
    FOLLOWER_MON_LUXIO = 440
    FOLLOWER_MON_LUXRAY = 441
    FOLLOWER_MON_BUDEW = 442
    FOLLOWER_MON_ROSERADE = 443
    FOLLOWER_MON_CRANIDOS = 444
    FOLLOWER_MON_RAMPARDOS = 445
    FOLLOWER_MON_SHIELDON = 446
    FOLLOWER_MON_BASTIODON = 447
    FOLLOWER_MON_BURMY = 448
    FOLLOWER_MON_BURMY_SANDY = 449
    FOLLOWER_MON_BURMY_TRASH = 450
    FOLLOWER_MON_WORMADAM = 451
    FOLLOWER_MON_WORMADAM_SANDY = 452
    FOLLOWER_MON_WORMADAM_TRASH = 453
    FOLLOWER_MON_MOTHIM = 454
    FOLLOWER_MON_COMBEE = 455
    FOLLOWER_MON_COMBEE_F = 456
    FOLLOWER_MON_VESPIQUEN = 457
    FOLLOWER_MON_PACHIRISU = 458
    FOLLOWER_MON_BUIZEL = 459
    FOLLOWER_MON_FLOATZEL = 460
    FOLLOWER_MON_CHERUBI = 461
    FOLLOWER_MON_CHERRIM = 462
    FOLLOWER_MON_SHELLOS_WEST = 463
    FOLLOWER_MON_SHELLOS_EAST = 464
    FOLLOWER_MON_GASTRODON_WEST = 465
    FOLLOWER_MON_GASTRODON_EAST = 466
    FOLLOWER_MON_AMBIPOM = 467
    FOLLOWER_MON_DRIFLOON = 468
    FOLLOWER_MON_DRIFBLIM = 469
    FOLLOWER_MON_BUNEARY = 470
    FOLLOWER_MON_LOPUNNY = 471
    FOLLOWER_MON_MISMAGIUS = 472
    FOLLOWER_MON_HONCHKROW = 473
    FOLLOWER_MON_GLAMEOW = 474
    FOLLOWER_MON_PURUGLY = 475
    FOLLOWER_MON_CHINGLING = 476
    FOLLOWER_MON_STUNKY = 477
    FOLLOWER_MON_SKUNTANK = 478
    FOLLOWER_MON_BRONZOR = 479
    FOLLOWER_MON_BRONZONG = 480
    FOLLOWER_MON_BONSLY = 481
    FOLLOWER_MON_MIME_JR = 482
    FOLLOWER_MON_HAPPINY = 483
    FOLLOWER_MON_CHATOT = 484
    FOLLOWER_MON_SPIRITOMB = 485
    FOLLOWER_MON_GIBLE = 486
    FOLLOWER_MON_GIBLE_F = 487
    FOLLOWER_MON_GABITE = 488
    FOLLOWER_MON_GABITE_F = 489
    FOLLOWER_MON_GARCHOMP = 490
    FOLLOWER_MON_GARCHOMP_F = 491
    FOLLOWER_MON_MUNCHLAX = 492
    FOLLOWER_MON_RIOLU = 493
    FOLLOWER_MON_LUCARIO = 494
    FOLLOWER_MON_HIPPOPOTAS = 495
    FOLLOWER_MON_HIPPOPOTAS_F = 496
    FOLLOWER_MON_HIPPOWDON = 497
    FOLLOWER_MON_HIPPOWDON_F = 498
    FOLLOWER_MON_SKORUPI = 499
    FOLLOWER_MON_DRAPION = 500
    FOLLOWER_MON_CROAGUNK = 501
    FOLLOWER_MON_TOXICROAK = 502
    FOLLOWER_MON_CARNIVINE = 503
    FOLLOWER_MON_FINNEON = 504
    FOLLOWER_MON_LUMINEON = 505
    FOLLOWER_MON_MANTYKE = 506
    FOLLOWER_MON_SNOVER = 507
    FOLLOWER_MON_ABOMASNOW = 508
    FOLLOWER_MON_WEAVILE = 509
    FOLLOWER_MON_MAGNEZONE = 510
    FOLLOWER_MON_LICKILICKY = 511
    FOLLOWER_MON_RHYPERIOR = 512
    FOLLOWER_MON_TANGROWTH = 513
    FOLLOWER_MON_ELECTIVIRE = 514
    FOLLOWER_MON_MAGMORTAR = 515
    FOLLOWER_MON_TOGEKISS = 516
    FOLLOWER_MON_YANMEGA = 517
    FOLLOWER_MON_LEAFEON = 518
    FOLLOWER_MON_GLACEON = 519
    FOLLOWER_MON_GLISCOR = 520
    FOLLOWER_MON_MAMOSWINE = 521
    FOLLOWER_MON_PORYGON_Z = 522
    FOLLOWER_MON_GALLADE = 523
    FOLLOWER_MON_PROBOPASS = 524
    FOLLOWER_MON_DUSKNOIR = 525
    FOLLOWER_MON_FROSLASS = 526
    FOLLOWER_MON_ROTOM = 527
    FOLLOWER_MON_ROTOM_HEAT = 528
    FOLLOWER_MON_ROTOM_WASH = 529
    FOLLOWER_MON_ROTOM_FROST = 530
    FOLLOWER_MON_ROTOM_FAN = 531
    FOLLOWER_MON_ROTOM_MOW = 532
    FOLLOWER_MON_UXIE = 533
    FOLLOWER_MON_MESPRIT = 534
    FOLLOWER_MON_AZELF = 535
    FOLLOWER_MON_DIALGA = 536
    FOLLOWER_MON_PALKIA = 537
    FOLLOWER_MON_HEATRAN = 538
    FOLLOWER_MON_REGIGIGAS = 539
    FOLLOWER_MON_GIRATINA = 540
    FOLLOWER_MON_GIRATINA_ORIGIN = 541
    FOLLOWER_MON_CRESSELIA = 542
    FOLLOWER_MON_PHIONE = 543
    FOLLOWER_MON_MANAPHY = 544
    FOLLOWER_MON_DARKRAI = 545
    FOLLOWER_MON_SHAYMIN = 546
    FOLLOWER_MON_SHAYMIN_SKY = 547
    FOLLOWER_MON_ARCEUS_NORMAL = 548
    FOLLOWER_MON_ARCEUS_FIGHTING = 549
    FOLLOWER_MON_ARCEUS_FLYING = 550
    FOLLOWER_MON_ARCEUS_POISON = 551
    FOLLOWER_MON_ARCEUS_GROUND = 552
    FOLLOWER_MON_ARCEUS_ROCK = 553
    FOLLOWER_MON_ARCEUS_BUG = 554
    FOLLOWER_MON_ARCEUS_GHOST = 555
    FOLLOWER_MON_ARCEUS_STEEL = 556
    FOLLOWER_MON_ARCEUS_MYSTERY = 557
    FOLLOWER_MON_ARCEUS_FIRE = 558
    FOLLOWER_MON_ARCEUS_WATER = 559
    FOLLOWER_MON_ARCEUS_GRASS = 560
    FOLLOWER_MON_ARCEUS_ELECTRIC = 561
    FOLLOWER_MON_ARCEUS_PSYCHIC = 562
    FOLLOWER_MON_ARCEUS_ICE = 563
    FOLLOWER_MON_ARCEUS_DRAGON = 564
    FOLLOWER_MON_ARCEUS_DARK = 565

PLAYER_STATE_WALKING = 0
    PLAYER_STATE_CYCLING = 1
    PLAYER_STATE_SURFING = 2
    PLAYER_STATE_ROCKET = 3
    PLAYER_STATE_USE_HM = 4
    PLAYER_STATE_WATERING = 5
    PLAYER_STATE_POKEATHLON = 6
    PLAYER_STATE_FISHING = 7
    PLAYER_STATE_POKETCH = 8
    PLAYER_STATE_SAVING = 9
    PLAYER_STATE_HEAL = 10
    PLAYER_STATE_LADDER = 11
    PLAYER_STATE_ROCKET_HEAL = 12
    PLAYER_STATE_APRICORN_SHAKE = 13
    PLAYER_STATE_ROCKET_SAVING = 14

MAP_EVERYWHERE = 0 //MAP_EVERYWHERE
    MAP_NOTHING = 1 //MAP_NOTHING
    MAP_UNION = 2 //MAP_UNION
    MAP_UNDERGROUND = 3 //MAP_UG
    MAP_WIFI_SINGLE_BATTLE_AREA = 4 //MAP_DIRECT2
    MAP_WIFI_MULTI_BATTLE_AREA = 5 //MAP_DIRECT4
    MAP_BELLCHIME_TOWER = 6 //MAP_D17R1101
    MAP_BURNED_TOWER_1F = 7 //MAP_D18R0101
    MAP_RUINS_OF_ALPH_UNUSED = 8 //MAP_D24
    MAP_ROUTE_1 = 9 //MAP_R01
    MAP_ROUTE_2 = 10 //MAP_R02
    MAP_ROUTE_3 = 11 //MAP_R03
    MAP_ROUTE_4 = 12 //MAP_R04
    MAP_ROUTE_5 = 13 //MAP_R05
    MAP_ROUTE_6 = 14 //MAP_R06
    MAP_ROUTE_7 = 15 //MAP_R07
    MAP_ROUTE_8 = 16 //MAP_R08
    MAP_ROUTE_9 = 17 //MAP_R09
    MAP_ROUTE_10 = 18 //MAP_R10
    MAP_ROUTE_11 = 19 //MAP_R11
    MAP_ROUTE_12 = 20 //MAP_R12
    MAP_ROUTE_13 = 21 //MAP_R13
    MAP_ROUTE_14 = 22 //MAP_R14
    MAP_ROUTE_15 = 23 //MAP_R15
    MAP_ROUTE_16 = 24 //MAP_R16
    MAP_ROUTE_17 = 25 //MAP_R17
    MAP_ROUTE_18 = 26 //MAP_R18
    MAP_ROUTE_22 = 27 //MAP_R22
    MAP_ROUTE_24 = 28 //MAP_R24
    MAP_ROUTE_25 = 29 //MAP_R25
    MAP_ROUTE_26 = 30 //MAP_R26
    MAP_ROUTE_27 = 31 //MAP_R27
    MAP_ROUTE_28 = 32 //MAP_R28
    MAP_ROUTE_29 = 33 //MAP_R29
    MAP_ROUTE_30 = 34 //MAP_R30
    MAP_ROUTE_31 = 35 //MAP_R31
    MAP_ROUTE_32 = 36 //MAP_R32
    MAP_ROUTE_33 = 37 //MAP_R33
    MAP_ROUTE_34 = 38 //MAP_R34
    MAP_ROUTE_35 = 39 //MAP_R35
    MAP_ROUTE_36 = 40 //MAP_R36
    MAP_ROUTE_37 = 41 //MAP_R37
    MAP_ROUTE_38 = 42 //MAP_R38
    MAP_ROUTE_39 = 43 //MAP_R39
    MAP_ROUTE_42 = 44 //MAP_R42
    MAP_ROUTE_43 = 45 //MAP_R43
    MAP_ROUTE_44 = 46 //MAP_R44
    MAP_ROUTE_45 = 47 //MAP_R45
    MAP_ROUTE_46 = 48 //MAP_R46
    MAP_PALLET = 49 //MAP_T01
    MAP_VIRIDIAN = 50 //MAP_T02
    MAP_PEWTER = 51 //MAP_T03
    MAP_CERULEAN = 52 //MAP_T04
    MAP_LAVENDER = 53 //MAP_T05
    MAP_VERMILION = 54 //MAP_T06
    MAP_CELADON = 55 //MAP_T07
    MAP_FUCHSIA = 56 //MAP_T08
    MAP_CINNABAR_ISLAND = 57 //MAP_T09
    MAP_INDIGO_PLATEAU = 58 //MAP_T10
    MAP_SAFFRON = 59 //MAP_T11
    MAP_NEW_BARK = 60 //MAP_T20
    MAP_NEW_BARK_ELMS_LAB_1F = 61 //MAP_T20R0101
    MAP_NEW_BARK_ELMS_LAB_2F = 62 //MAP_T20R0102
    MAP_NEW_BARK_PLAYER_HOUSE_1F = 63 //MAP_T20R0201
    MAP_NEW_BARK_PLAYER_HOUSE_2F = 64 //MAP_T20R0202
    MAP_NEW_BARK_SOUTHWEST_HOUSE = 65 //MAP_T20R0301
    MAP_NEW_BARK_RIVAL_HOUSE_1F = 66 //MAP_T20R0401
    MAP_CHERRYGROVE = 67 //MAP_T21
    MAP_CHERRYGROVE_POKEMART = 68 //MAP_T21FS0101
    MAP_CHERRYGROVE_POKECENTER_1F = 69 //MAP_T21PC0101
    MAP_CHERRYGROVE_SOUTHWEST_HOUSE = 70 //MAP_T21R0301
    MAP_CHERRYGROVE_GUIDE_GENT_HOUSE = 71 //MAP_T21R0401
    MAP_CHERRYGROVE_SOUTHEAST_HOUSE = 72 //MAP_T21R0501
    MAP_VIOLET = 73 //MAP_T22
    MAP_AZALEA = 74 //MAP_T23
    MAP_CIANWOOD = 75 //MAP_T24
    MAP_GOLDENROD = 76 //MAP_T25
    MAP_OLIVINE = 77 //MAP_T26
    MAP_ECRUTEAK = 78 //MAP_T27
    MAP_ECRUTEAK_POKEMART = 79 //MAP_T27FS0101
    MAP_ECRUTEAK_GYM = 80 //MAP_T27GYM0101
    MAP_ECRUTEAK_POKECENTER_1F = 81 //MAP_T27PC0101
    MAP_ECRUTEAK_UNUSED_HOUSE = 82 //MAP_T27R0101
    MAP_ECRUTEAK_BELL_TOWER_BARRIER_STATION = 83 //MAP_T27R0201
    MAP_ECRUTEAK_DOWSING_MACHINE_HOUSE = 84 //MAP_T27R0801
    MAP_ECRUTEAK_SOUTHWEST_HOUSE = 85 //MAP_T27R0401
    MAP_ECRUTEAK_DANCE_THEATER = 86 //MAP_T27R0501
    MAP_MAHOGANY = 87 //MAP_T28
    MAP_LAKE_OF_RAGE = 88 //MAP_T29
    MAP_BLACKTHORN = 89 //MAP_T30
    MAP_MOUNT_SILVER = 90 //MAP_T31
    MAP_ROUTE_19 = 91 //MAP_W19
    MAP_ROUTE_20 = 92 //MAP_W20
    MAP_ROUTE_21 = 93 //MAP_W21
    MAP_ROUTE_40 = 94 //MAP_W40
    MAP_ROUTE_41 = 95 //MAP_W41
    MAP_NATIONAL_PARK = 96 //MAP_D22R0101
    MAP_ROUTE_31_VIOLET_GATEHOUSE = 97 //MAP_R31R0101
    MAP_ROUTE_32_RUINS_OF_ALPH_GATEHOUSE = 98 //MAP_R32R0101
    MAP_UNION_CAVE_1F = 99 //MAP_D25R0101
    MAP_AZALEA_ILEX_FOREST_GATEHOUSE = 100 //MAP_T23R0101
    MAP_ROUTE_35_GOLDENROD_GATEHOUSE = 101 //MAP_R35R0101
    MAP_ROUTE_35_NATIONAL_PARK_POKEATHALON_GATEHOUSE = 102 //MAP_R35R0201
    MAP_ROUTE_36_RUINS_OF_ALPH_GATEHOUSE = 103 //MAP_R36R0101
    MAP_ROUTE_36_NATIONAL_PARK_GATEHOUSE = 104 //MAP_R36R0201
    MAP_ECRUTEAK_UNUSED_GATEHOUSE = 105 //MAP_T27R0601
    MAP_DIGLETT_CAVE = 106 //MAP_D01R0101
    MAP_MOUNT_MOON = 107 //MAP_D02R0101
    MAP_ROCK_TUNNEL_1F = 108 //MAP_D05R0101
    MAP_PAL_PARK = 109 //MAP_D10R0101
    MAP_SPROUT_TOWER_1F = 110 //MAP_D15R0101
    MAP_BELL_TOWER_1F = 111 //MAP_D17R0101
    MAP_GOLDENROD_RADIO_TOWER_1F = 112 //MAP_D23R0101
    MAP_RUINS_OF_ALPH = 113 //MAP_D24R0101
    MAP_SLOWPOKE_WELL_ENTRANCE = 114 //MAP_D26R0101
    MAP_OLIVINE_LIGHTHOUSE_1F = 115 //MAP_D27R0101
    MAP_MAHOGANY_SOUVENIR_SHOP = 116 //MAP_D35R0101
    MAP_ILEX_FOREST = 117 //MAP_D36R0101
    MAP_GOLDENROD_TUNNEL_1F = 118 //MAP_D37R0101
    MAP_MOUNT_MORTAR_1F_ENTRANCE = 119 //MAP_D38R0101
    MAP_ICE_PATH_1F = 120 //MAP_D39R0101
    MAP_WHIRL_ISLANDS_1F = 121 //MAP_D40R0101
    MAP_MOUNT_SILVER_CAVE_1F = 122 //MAP_D41R0101
    MAP_DARK_CAVE_ROUTE_45_SIDE = 123 //MAP_D42R0101
    MAP_VICTORY_ROAD_1F = 124 //MAP_D43R0101
    MAP_DRAGONS_DEN_ENTRANCE = 125 //MAP_D44R0101
    MAP_TOHJO_FALLS = 126 //MAP_D45R0101
    MAP_ROUTE_30_APRICORN_HOUSE = 127 //MAP_R30R0101
    MAP_ECRUTEAK_POKECENTER_UNUSED_1 = 128 //MAP_T27PC0102
    MAP_ECRUTEAK_POKECENTER_UNUSED_2 = 129 //MAP_T27PC0103
    MAP_ECRUTEAK_POKECENTER_UNUSED_3 = 130 //MAP_T27PC0104
    MAP_ECRUTEAK_POKECENTER_B1F = 131 //MAP_T27PC0105
    MAP_ROUTE_42_ECRUTEAK_GATEHOUSE = 132 //MAP_R42R0101
    MAP_MAHOGANY_EAST_HOUSE = 133 //MAP_T28R0201
    MAP_ROUTE_29_ROUTE_46_GATEHOUSE = 134 //MAP_R29R0101
    MAP_VIOLET_GYM = 135 //MAP_T22GYM0101
    MAP_AZALEA_GYM_ENTRANCE = 136 //MAP_T23GYM0101
    MAP_GOLDENROD_GYM = 137 //MAP_T25GYM0101
    MAP_OLIVINE_GYM = 138 //MAP_T26GYM0101
    MAP_CIANWOOD_GYM = 139 //MAP_T24GYM0101
    MAP_MAHOGANY_GYM_LEADER_ROOM = 140 //MAP_T28GYM0101
    MAP_BLACKTHORN_GYM = 141 //MAP_T30GYM0101
    MAP_ROUTE_43_MAHOGANY_GATEHOUSE = 142 //MAP_R43R0101
    MAP_ROUTE_30_MR_POKEMON_HOUSE = 143 //MAP_R30R0201
    MAP_CHERRYGROVE_POKECENTER_B1F = 144 //MAP_T21PC0102
    MAP_CERULEAN_CAVE_1F = 145 //MAP_D03R0101
    MAP_SEAFOAM_ISLANDS_1F = 146 //MAP_D11R0101
    MAP_VIRIDIAN_FOREST = 147 //MAP_D46R0101
    MAP_ROUTE_9_UNUSED = 148 //MAP_R09R0101
    MAP_VIOLET_ROUTE_36_GATEHOUSE = 149 //MAP_T22R0701
    MAP_NATIONAL_PARK_UNUSED_GATEHOUSE = 150 //MAP_D22R0201
    MAP_ROUTE_47 = 151 //MAP_R47
    MAP_ROUTE_48 = 152 //MAP_R48
    MAP_UNION_CAVE_B1F = 153 //MAP_D25R0102
    MAP_UNION_CAVE_B2F = 154 //MAP_D25R0103
    MAP_SPROUT_TOWER_2F = 155 //MAP_D15R0102
    MAP_SPROUT_TOWER_3F = 156 //MAP_D15R0103
    MAP_VIOLET_POKEMART = 157 //MAP_T22FS0101
    MAP_VIOLET_POKECENTER_1F = 158 //MAP_T22PC0101
    MAP_VIOLET_POKEMON_SCHOOL = 159 //MAP_T22R0301
    MAP_VIOLET_NORTHWEST_HOUSE = 160 //MAP_T22R0401
    MAP_VIOLET_UNUSED = 161 //MAP_T22R0501
    MAP_VIOLET_BELLSPROUT_ONYX_TRADE_HOUSE = 162 //MAP_T22R0601
    MAP_AZALEA_CHARCOAL_KILN = 163 //MAP_T23R0201
    MAP_AZALEA_KURT_HOUSE = 164 //MAP_T23R0501
    MAP_AZALEA_POKEMART = 165 //MAP_T23FS0101
    MAP_AZALEA_POKECENTER_1F = 166 //MAP_T23PC0101
    MAP_VIOLET_POKECENTER_B1F = 167 //MAP_T22PC0102
    MAP_AZALEA_POKECENTER_B1F = 168 //MAP_T23PC0102
    MAP_ROUTE_32_POKECENTER_1F = 169 //MAP_R32PC0101
    MAP_ROUTE_32_POKECENTER_B1F = 170 //MAP_R32PC0102
    MAP_ROUTE_34_ILEX_FOREST_GATEHOUSE = 171 //MAP_R34R0201
    MAP_ROUTE_38_ECRUTEAK_GATEHOUSE = 172 //MAP_R38R0101
    MAP_SAFARI_ZONE_ENTRANCE_INTERIOR = 173 //MAP_D47R0101
    MAP_SAFARI_ZONE_GATE = 174 //MAP_D47
    MAP_ECRUTEAK_UNUSED_1 = 175 //MAP_T27R0301
    MAP_DARK_CAVE_ROUTE_31_SIDE = 176 //MAP_D42R0102
    MAP_SLOWPOKE_WELL_B1F = 177 //MAP_D26R0102
    MAP_VICTORY_ROAD_2F = 178 //MAP_D43R0102
    MAP_VICTORY_ROAD_3F = 179 //MAP_D43R0103
    MAP_AZALEA_GYM = 180 //MAP_T23GYM0102
    MAP_SLOWPOKE_WELL_B2F = 181 //MAP_D26R0103
    MAP_GOLDENROD_BIKE_SHOP = 182 //MAP_T25R0201
    MAP_GOLDENROD_GAME_CORNER_JP = 183 //MAP_T25R1101
    MAP_GOLDENROD_FLOWER_SHOP = 184 //MAP_T25R0601
    MAP_GOLDENROD_POKECENTER_1F = 185 //MAP_T25PC0101
    MAP_GOLDENROD_RADIO_TOWER_2F = 186 //MAP_D23R0102
    MAP_GOLDENROD_RADIO_TOWER_3F = 187 //MAP_D23R0103
    MAP_GOLDENROD_RADIO_TOWER_4F = 188 //MAP_D23R0104
    MAP_GOLDENROD_RADIO_TOWER_5F = 189 //MAP_D23R0105
    MAP_GOLDENROD_RADIO_TOWER_OBSERVATION_DECK = 190 //MAP_D23R0106
    MAP_GOLDENROD_DEPARTMENT_STORE_1F = 191 //MAP_T25R1001
    MAP_GOLDENROD_DEPARTMENT_STORE_2F = 192 //MAP_T25R1002
    MAP_GOLDENROD_DEPARTMENT_STORE_3F = 193 //MAP_T25R1003
    MAP_GOLDENROD_DEPARTMENT_STORE_4F = 194 //MAP_T25R1004
    MAP_GOLDENROD_DEPARTMENT_STORE_5F = 195 //MAP_T25R1005
    MAP_GOLDENROD_DEPARTMENT_STORE_6F = 196 //MAP_T25R1006
    MAP_GOLDENROD_MAGNET_TRAIN_STATION_1F = 197 //MAP_T25R0501
    MAP_GOLDENROD_MAGNET_TRAIN_STATION_2F = 198 //MAP_T25R0502
    MAP_GOLDENROD_TUNNEL_B1F = 199 //MAP_D37R0102
    MAP_GOLDENROD_DEPARTMENT_STORE_BASEMENT = 200 //MAP_D37R0103
    MAP_GOLDENROD_TUNNEL_B2F = 201 //MAP_D37R0104
    MAP_GOLDENROD_TUNNEL_WAREHOUSE = 202 //MAP_D37R0105
    MAP_GOLDENROD_BILLS_HOUSE = 203 //MAP_T25R0401
    MAP_GOLDENROD_FRIENDSHIP_CHECKER_HOUSE = 204 //MAP_T25R0301
    MAP_GOLDENROD_NORTHEAST_HOUSE = 205 //MAP_T25R0801
    MAP_GOLDENROD_NAME_RATER_HOUSE = 206 //MAP_T25R0901
    MAP_GOLDENROD_GLOBAL_TERMINAL_1F = 207 //MAP_T25R1201
    MAP_GOLDENROD_UNUSED_1 = 208 //MAP_T25R1301
    MAP_GOLDENROD_UNUSED_2 = 209 //MAP_T25R1302
    MAP_GOLDENROD_UNUSED_3 = 210 //MAP_T25R1303
    MAP_GOLDENROD_UNUSED_4 = 211 //MAP_T25R1304
    MAP_GOLDENROD_UNUSED_5 = 212 //MAP_T25R1305
    MAP_GOLDENROD_UNUSED_6 = 213 //MAP_T25R1306
    MAP_ROUTE_39_MOOMOO_FARM_HOUSE = 214 //MAP_R39R0101
    MAP_ROUTE_39_MOOMOO_FARM_STABLE = 215 //MAP_R39R0201
    MAP_ECRUTEAK_BELL_TOWER_BARRIER_STATION_CORRIDOR = 216 //MAP_T27R0202
    MAP_BURNED_TOWER_B1F = 217 //MAP_D18R0102
    MAP_RUINS_OF_ALPH_UNUSED_2 = 218 //MAP_D24R0201
    MAP_GOLDENROD_POKECENTER_B1F = 219 //MAP_T25PC0102
    MAP_OLIVINE_LIGHTHOUSE_2F = 220 //MAP_D27R0102
    MAP_OLIVINE_LIGHTHOUSE_EXTERIOR = 221 //MAP_D27R0103
    MAP_OLIVINE_LIGHTHOUSE_3F = 222 //MAP_D27R0104
    MAP_OLIVINE_LIGHTHOUSE_4F = 223 //MAP_D27R0105
    MAP_OLIVINE_LIGHTHOUSE_5F = 224 //MAP_D27R0106
    MAP_OLIVINE_LIGHTHOUSE_LIGHT_ROOM = 225 //MAP_D27R0107
    MAP_OLIVINE_POKECENTER_1F = 226 //MAP_T26PC0101
    MAP_OLIVINE_POKEMART = 227 //MAP_T26FS0101
    MAP_OLIVINE_NORTH_HOUSE = 228 //MAP_T26R0301
    MAP_OLIVINE_NORTHEAST_HOUSE = 229 //MAP_T26R0501
    MAP_OLIVINE_NORTHWEST_HOUSE = 230 //MAP_T26R0601
    MAP_OLIVINE_CAFE = 231 //MAP_T26R0701
    MAP_CIANWOOD_KIRKS_HOUSE = 232 //MAP_T24R0201
    MAP_CIANWOOD_PHARMACY = 233 //MAP_T24R0501
    MAP_CIANWOOD_CAMERONS_HOUSE = 234 //MAP_T24R0601
    MAP_CIANWOOD_CENTRAL_HOUSE = 235 //MAP_T24R0701
    MAP_CIANWOOD_POKECENTER_1F = 236 //MAP_T24PC0101
    MAP_ICE_PATH_B1F = 237 //MAP_D39R0102
    MAP_ICE_PATH_B2F = 238 //MAP_D39R0103
    MAP_ICE_PATH_B3F = 239 //MAP_D39R0104
    MAP_SS_AQUA_OLIVINE_PORT_INTERIOR = 240 //MAP_P01R0101
    MAP_CIANWOOD_POKECENTER_B1F = 241 //MAP_T24PC0102
    MAP_WHIRL_ISLANDS_B1F = 242 //MAP_D40R0102
    MAP_WHIRL_ISLANDS_B2F = 243 //MAP_D40R0104
    MAP_WHIRL_ISLANDS_B3F_LUGIA_CAVE = 244 //MAP_D40R0107
    MAP_ROUTE_43_GATEHOUSE = 245 //MAP_R43R0201
    MAP_MAHOGANY_POKECENTER_1F = 246 //MAP_T28PC0101
    MAP_TEAM_ROCKET_HEADQUARTERS_B1F = 247 //MAP_D35R0102
    MAP_TEAM_ROCKET_HEADQUARTERS_B2F = 248 //MAP_D35R0103
    MAP_TEAM_ROCKET_HEADQUARTERS_B3F = 249 //MAP_D35R0104
    MAP_MOUNT_MORTAR_1F_BACK = 250 //MAP_D38R0102
    MAP_MOUNT_MORTAR_2F = 251 //MAP_D38R0103
    MAP_MOUNT_MORTAR_B1F = 252 //MAP_D38R0104
    MAP_DRAGONS_DEN = 253 //MAP_D44R0102
    MAP_FIGHT_AREA_UNUSED_1 = 254 //MAP_C11
    MAP_FIGHT_AREA_UNUSED_2 = 255 //MAP_C11PC0101
    MAP_FIGHT_AREA_UNUSED_3 = 256 //MAP_C11PC0102
    MAP_FIGHT_AREA_UNUSED_4 = 257 //MAP_C11FS0101
    MAP_FIGHT_AREA_UNUSED_5 = 258 //MAP_C11R0101
    MAP_FIGHT_AREA_UNUSED_6 = 259 //MAP_C11R0201
    MAP_FIGHT_AREA_UNUSED_7 = 260 //MAP_C11R0301
    MAP_FIGHT_AREA_UNUSED_8 = 261 //MAP_C11R0401
    MAP_FIGHT_AREA_UNUSED_9 = 262 //MAP_C11PC0103
    MAP_BATTLE_PARK_UNUSED_1 = 263 //MAP_D31
    MAP_BATTLE_PARK_UNUSED_2 = 264 //MAP_D31R0101
    MAP_BATTLE_TOWER = 265 //MAP_D31R0201
    MAP_BATTLE_TOWER_ELEVATOR = 266 //MAP_D31R0202
    MAP_BATTLE_TOWER_UNUSED_1 = 267 //MAP_D31R0203
    MAP_BATTLE_TOWER_UNUSED_2 = 268 //MAP_D31R0204
    MAP_BATTLE_TOWER_UNUSED_3 = 269 //MAP_D31R0205
    MAP_BATTLE_TOWER_UNUSED_4 = 270 //MAP_D31R0206
    MAP_BATTLE_TOWER_PARTNER_ROOM = 271 //MAP_D31R0207
    MAP_BATTLE_FRONTIER = 272 //MAP_D32
    MAP_BATTLE_FRONTIER_FRONTIER_ACCESS_GATEHOUSE = 273 //MAP_D32R0101
    MAP_BATTLE_FRONTIER_BATTLE_TOWER_UNUSED = 274 //MAP_D32R0201
    MAP_BATTLE_FRONTIER_BATTLE_FACTORY = 275 //MAP_D32R0301
    MAP_BATTLE_FRONTIER_BATTLE_HALL = 276 //MAP_D32R0401
    MAP_BATTLE_FRONTIER_BATTLE_CASTLE = 277 //MAP_D32R0501
    MAP_BATTLE_FRONTIER_BATTLE_ARCADE = 278 //MAP_D32R0601
    MAP_CLIFF_EDGE_GATE = 279 //MAP_D48R0101
    MAP_POKEATHLON_DOME = 280 //MAP_D49
    MAP_POKEATHLON_DOME_INTERIOR_1F = 281 //MAP_D49R0101
    MAP_POKEATHLON_DOME_INTERIOR_2F = 282 //MAP_D49R0102
    MAP_POKEATHLON_DOME_INTERIOR_2F_ENTRANCE = 283 //MAP_D49R0103
    MAP_POKEATHLON_DOME_INTERIOR_B1F_SOLIDARITY_ROOM = 284 //MAP_D49R0104
    MAP_POKEATHLON_DOME_INTERIOR_B1F_TRUST_ROOM = 285 //MAP_D49R0105
    MAP_POKEATHLON_DOME_INTERIOR_B1F_POTENTIAL_ROOM = 286 //MAP_D49R0106
    MAP_POKEATHLON_DOME_INTERIOR_B1F_FRIENDSHIP_ROOM = 287 //MAP_D49R0107
    MAP_DRAGONS_DEN_SHRINE = 288 //MAP_D44R0103
    MAP_BLACKTHORN_WEST_HOUSE = 289 //MAP_T30R0201
    MAP_BLACKTHORN_EAST_HOUSE = 290 //MAP_T30R0301
    MAP_BLACKTHORN_MOVE_TUTOR_HOUSE = 291 //MAP_T30R0601
    MAP_BLACKTHORN_POKEMART = 292 //MAP_T30FS0101
    MAP_BLACKTHORN_POKECENTER_1F = 293 //MAP_T30PC0101
    MAP_LAKE_OF_RAGE_HIDDEN_POWER_HOUSE = 294 //MAP_T29R0101
    MAP_LAKE_OF_RAGE_FISHING_GURU_HOUSE = 295 //MAP_T29R0201
    MAP_ROUTE_26_NORTH_HOUSE = 296 //MAP_R26R0101
    MAP_ROUTE_26_WEEK_SIBLINGS_HOUSE = 297 //MAP_R26R0201
    MAP_TOHJO_FALLS_HIDDEN_ROOM = 298 //MAP_D45R0102
    MAP_ROUTE_22_POKEMON_LEAGUE_RECEPTION_GATE = 299 //MAP_R22R0101
    MAP_POKEMON_LEAGUE_ENTRANCE = 300 //MAP_T10R0101
    MAP_POKEMON_LEAGUE_WILL_ROOM = 301 //MAP_T10R0201
    MAP_POKEMON_LEAGUE_KOGA_ROOM = 302 //MAP_T10R0301
    MAP_POKEMON_LEAGUE_BRUNO_ROOM = 303 //MAP_T10R0401
    MAP_POKEMON_LEAGUE_KAREN_ROOM = 304 //MAP_T10R0501
    MAP_POKEMON_LEAGUE_LANCE_ROOM = 305 //MAP_T10R0601
    MAP_POKEMON_LEAGUE_HALL_OF_FAME = 306 //MAP_T10R0701
    MAP_SS_AQUA_1F = 307 //MAP_P01R0301
    MAP_SS_AQUA_CAPTAIN_ROOM = 308 //MAP_P01R0302
    MAP_SS_AQUA_1F_SOUTHEAST_ROOMS = 309 //MAP_P01R0303
    MAP_SS_AQUA_1F_SOUTHWEST_ROOMS = 310 //MAP_P01R0304
    MAP_SS_AQUA_1F_NORTHEAST_ROOMS = 311 //MAP_P01R0305
    MAP_RUINS_OF_ALPH_NORTHEAST_ENTRANCE_FIRST_ROOM = 312 //MAP_D24R0202
    MAP_RUINS_OF_ALPH_NORTHEAST_HIDDEN_ROOM = 313 //MAP_D24R0203
    MAP_RUINS_OF_ALPH_SOUTHEAST_ENTRANCE_FIRST_ROOM = 314 //MAP_D24R0204
    MAP_RUINS_OF_ALPH_UNDERGROUND_HALL = 315 //MAP_D24R0205
    MAP_RUINS_OF_ALPH_SOUTHWEST_ENTRANCE_FIRST_ROOM = 316 //MAP_D24R0206
    MAP_RUINS_OF_ALPH_SOUTHWEST_HIDDEN_ROOM = 317 //MAP_D24R0207
    MAP_RUINS_OF_ALPH_NORTHWEST_ENTRANCE_FIRST_ROOM = 318 //MAP_D24R0208
    MAP_RUINS_OF_ALPH_NORTHWEST_HIDDEN_ROOM = 319 //MAP_D24R0209
    MAP_RUINS_OF_ALPH_SOUTHEAST_HIDDEN_ROOM = 320 //MAP_D24R0210
    MAP_RUINS_OF_ALPH_RESEARCH_CENTER = 321 //MAP_D24R0102
    MAP_ROUTE_27_HOUSE = 322 //MAP_R27R0101
    MAP_RUINS_OF_ALPH_HALL_ENTRANCE = 323 //MAP_D24R0211
    MAP_RUINS_OF_ALPH_NORTHEAST_ENTRANCE_SECOND_ROOM = 324 //MAP_D24R0212
    MAP_RUINS_OF_ALPH_SOUTHEAST_ENTRANCE_SECOND_ROOM = 325 //MAP_D24R0213
    MAP_RUINS_OF_ALPH_NORTHWEST_ENTRANCE_SECOND_ROOM = 326 //MAP_D24R0214
    MAP_RUINS_OF_ALPH_SOUTHWEST_ENTRANCE_SECOND_ROOM = 327 //MAP_D24R0215
    MAP_SS_AQUA_1F_NORTHWEST_ROOMS = 328 //MAP_P01R0306
    MAP_SS_AQUA_B1F = 329 //MAP_P01R0307
    MAP_SS_AQUA_OLIVINE_PORT_EXTERIOR = 330 //MAP_P01R0102
    MAP_ROUTE_34_DAYCARE = 331 //MAP_R34R0101
    MAP_BELL_TOWER_2F = 332 //MAP_D17R0102
    MAP_BELL_TOWER_3F = 333 //MAP_D17R0103
    MAP_BELL_TOWER_4F = 334 //MAP_D17R0104
    MAP_BELL_TOWER_5F = 335 //MAP_D17R0105
    MAP_BELL_TOWER_6F = 336 //MAP_D17R0106
    MAP_BELL_TOWER_7F = 337 //MAP_D17R0107
    MAP_BELL_TOWER_8F = 338 //MAP_D17R0108
    MAP_BELL_TOWER_9F = 339 //MAP_D17R0109
    MAP_BELL_TOWER_ROOF = 340 //MAP_D17R0110
    MAP_BELL_TOWER_10F = 341 //MAP_D17R0112
    MAP_CLIFF_CAVE = 342 //MAP_D50R0101
    MAP_SAFARI_ZONE_01 = 343 //MAP_SAF01
    MAP_SAFARI_ZONE_02 = 344 //MAP_SAF02
    MAP_SAFARI_ZONE_03 = 345 //MAP_SAF03
    MAP_SAFARI_ZONE_04 = 346 //MAP_SAF04
    MAP_SAFARI_ZONE_05 = 347 //MAP_SAF05
    MAP_SAFARI_ZONE_06 = 348 //MAP_SAF06
    MAP_SAFARI_ZONE_07 = 349 //MAP_SAF07
    MAP_SAFARI_ZONE_08 = 350 //MAP_SAF08
    MAP_SAFARI_ZONE_09 = 351 //MAP_SAF09
    MAP_SAFARI_ZONE_10 = 352 //MAP_SAF10
    MAP_SAFARI_ZONE_11 = 353 //MAP_SAF11
    MAP_SAFARI_ZONE_12 = 354 //MAP_SAF12
    MAP_SAFARI_ZONE_13 = 355 //MAP_SAF13
    MAP_SAFARI_ZONE_14 = 356 //MAP_SAF14
    MAP_SAFARI_ZONE_ENTRANCE_EXTERIOR = 357 //MAP_D47R0102
    MAP_VERMILION_POKECENTER_1F = 358 //MAP_T06PC0101
    MAP_VERMILION_POKECENTER_B1F = 359 //MAP_T06PC0102
    MAP_VERMILION_POKEMART = 360 //MAP_T06FS0101
    MAP_VERMILION_FISHING_DUDE_HOUSE = 361 //MAP_T06R0101
    MAP_VERMILION_POKEMON_FAN_CLUB = 362 //MAP_T06R0301
    MAP_VERMILION_CENTRAL_HOUSE = 363 //MAP_T06R0401
    MAP_VERMILION_SOUTH_HOUSE = 364 //MAP_T06R0601
    MAP_VERMILION_GYM = 365 //MAP_T06GYM0101
    MAP_ROUTE_40_BATTLE_FRONTIER_GATEHOUSE = 366 //MAP_W40R0101
    MAP_OLIVINE_POKECENTER_B1F = 367 //MAP_T26PC0102
    MAP_MAHOGANY_POKECENTER_B1F = 368 //MAP_T28PC0102
    MAP_BLACKTHORN_POKECENTER_B1F = 369 //MAP_T30PC0102
    MAP_CELADON_DEPARTMENT_STORE_1F = 370 //MAP_T07R0101
    MAP_CELADON_DEPARTMENT_STORE_2F = 371 //MAP_T07R0102
    MAP_CELADON_DEPARTMENT_STORE_3F = 372 //MAP_T07R0103
    MAP_CELADON_DEPARTMENT_STORE_4F = 373 //MAP_T07R0104
    MAP_CELADON_DEPARTMENT_STORE_5F = 374 //MAP_T07R0105
    MAP_CELADON_DEPARTMENT_STORE_ROOF = 375 //MAP_T07R0106
    MAP_CELADON_CONDOMINIUMS_1F = 376 //MAP_T07R0201
    MAP_CELADON_CONDOMINIUMS_2F = 377 //MAP_T07R0202
    MAP_CELADON_CONDOMINIUMS_3F = 378 //MAP_T07R0203
    MAP_CELADON_CONDOMINIUMS_ROOF = 379 //MAP_T07R0204
    MAP_CELADON_CONDOMINIUMS_ROOF_ROOM = 380 //MAP_T07R0205
    MAP_CELADON_GAME_CORNER_JP = 381 //MAP_T07R0401
    MAP_CELADON_PRIZE_CORNER = 382 //MAP_T07R0501
    MAP_CELADON_RESTAURANT = 383 //MAP_T07R0701
    MAP_NEW_BARK_RIVAL_HOUSE_2F = 384 //MAP_T20R0402
    MAP_CIANWOOD_NORTH_HOUSE = 385 //MAP_T24R0801
    MAP_SS_AQUA_VERMILION_PORT_INTERIOR = 386 //MAP_P01R0103
    MAP_SS_AQUA_VERMILION_PORT_EXTERIOR = 387 //MAP_P01R0104
    MAP_ROUTE_10_SOUTH = 388 //MAP_R10R0101
    MAP_ROUTE_6_SAFFRON_GATEHOUSE = 389 //MAP_R06R0201
    MAP_ROUTE_8_SAFFRON_GATEHOUSE = 390 //MAP_R08R0201
    MAP_ROUTE_5_SAFFRON_GATEHOUSE = 391 //MAP_R05R0301
    MAP_ROUTE_15_FUCHSIA_GATEHOUSE = 392 //MAP_R15R0101
    MAP_CELADON_POKECENTER_1F = 393 //MAP_T07PC0101
    MAP_CELADON_POKECENTER_B1F = 394 //MAP_T07PC0102
    MAP_CELADON_GYM = 395 //MAP_T07GYM0101
    MAP_MAHOGANY_GYM_ROOM_2 = 396 //MAP_T28GYM0102
    MAP_MAHOGANY_GYM_ROOM_1 = 397 //MAP_T28GYM0103
    MAP_SAFFRON_FIGHTING_DOJO = 398 //MAP_T11R0101
    MAP_SAFFRON_MR_PSYCHIC_HOUSE = 399 //MAP_T11R0501
    MAP_SAFFRON_MAGNET_TRAIN_STATION_1F = 400 //MAP_T11R0601
    MAP_SAFFRON_MAGNET_TRAIN_STATION_2F = 401 //MAP_T11R0602
    MAP_SAFFRON_SILPH_CO_HQ = 402 //MAP_T11R0701
    MAP_SAFFRON_SILPH_CO_ROTOM_ROOM = 403 //MAP_T11R0702
    MAP_SAFFRON_COPYCAT_HOUSE_1F = 404 //MAP_T11R0801
    MAP_SAFFRON_COPYCAT_HOUSE_2F = 405 //MAP_T11R0802
    MAP_SAFFRON_UNUSED = 406 //MAP_T11R0901
    MAP_SAFFRON_POKECENTER_1F = 407 //MAP_T11PC0101
    MAP_SAFFRON_POKECENTER_2F = 408 //MAP_T11PC0102
    MAP_SAFFRON_POKEMART = 409 //MAP_T11FS0101
    MAP_SAFFRON_GYM = 410 //MAP_T11GYM0101
    MAP_BATTLE_FRONTIER_FRONTIER_ACCESS = 411 //MAP_D32R0102
    MAP_GOLDENROD_GLOBAL_TERMINAL_2F = 412 //MAP_T25R1202
    MAP_GOLDENROD_GLOBAL_TERMINAL_3F = 413 //MAP_T25R1203
    MAP_ROUTE_2_EAST = 414 //MAP_R02R0101
    MAP_ROUTE_16_HOUSE = 415 //MAP_R16R0101
    MAP_ROUTE_20_UNUSED = 416 //MAP_W20R0101
    MAP_ROUTE_2_HOUSE = 417 //MAP_R02R0201
    MAP_ROUTE_2_SOUTHEAST_GATEHOUSE = 418 //MAP_R02R0301
    MAP_ROUTE_2_VIRIDIAN_FOREST_SOUTH_GATEHOUSE = 419 //MAP_R02R0401
    MAP_ROUTE_2_VIRIDIAN_FOREST_NORTH_GATEHOUSE = 420 //MAP_R02R0501
    MAP_ROUTE_16_GATEHOUSE = 421 //MAP_R16R0201
    MAP_ROUTE_16_EAST = 422 //MAP_R16R0301
    MAP_ROUTE_18_GATEHOUSE = 423 //MAP_R18R0101
    MAP_ROUTE_19_FUCHSIA_GATEHOUSE = 424 //MAP_W19R0101
    MAP_ROUTE_19_ROUTE_12_GATEHOUSE = 425 //MAP_R11R0101
    MAP_CERULEAN_POKEMART = 426 //MAP_T04FS0101
    MAP_CERULEAN_GYM = 427 //MAP_T04GYM0101
    MAP_CERULEAN_POKECENTER_1F = 428 //MAP_T04PC0101
    MAP_CERULEAN_NORTH_HOUSE = 429 //MAP_T04R0101
    MAP_CERULEAN_EAST_HOUSE = 430 //MAP_T04R0201
    MAP_CERULEAN_WEST_HOUSE = 431 //MAP_T04R0301
    MAP_CERULEAN_BIKE_MANIAC_HOUSE = 432 //MAP_T04R0401
    MAP_LAVENDER_POKEMART = 433 //MAP_T05FS0101
    MAP_LAVENDER_POKECENTER_1F = 434 //MAP_T05PC0101
    MAP_LAVENDER_VOLUNTEER_POKEMON_HOUSE = 435 //MAP_T05R0201
    MAP_LAVENDER_SOUTHWEST_HOUSE = 436 //MAP_T05R0301
    MAP_LAVENDER_NAME_RATER = 437 //MAP_T05R0401
    MAP_LAVENDER_HOUSE_OF_MEMORIES = 438 //MAP_T05R0601
    MAP_LAVENDER_RADIO_STATION = 439 //MAP_T05R0701
    MAP_ROUTE_25_SEA_COTTAGE = 440 //MAP_R25R0101
    MAP_GOLDENROD_DEPARTMENT_STORE_ELEVATOR = 441 //MAP_T25R1007
    MAP_CELADON_DEPARTMENT_STORE_ELEVATOR = 442 //MAP_T07R0107
    MAP_CELADON_CONDOMINIUMS_LEFT_ELEVATOR = 443 //MAP_T07R0206
    MAP_CELADON_CONDOMINIUMS_RIGHT_ELEVATOR = 444 //MAP_T07R0207
    MAP_SAFFRON_SILPH_CO_ELEVATOR = 445 //MAP_T11R0703
    MAP_OLIVINE_LIGHTHOUSE_ELEVATOR = 446 //MAP_D27R0108
    MAP_GOLDENROD_RADIO_TOWER_ELEVATOR = 447 //MAP_D23R0107
    MAP_MOUNT_MOON_SQUARE_ENTRANCE = 448 //MAP_D02R0102
    MAP_MOUNT_MOON_SQUARE = 449 //MAP_D02R0103
    MAP_CERULEAN_CAVE_2F = 450 //MAP_D03R0102
    MAP_CERULEAN_CAVE_B1F = 451 //MAP_D03R0103
    MAP_ROCK_TUNNEL_B1F = 452 //MAP_D05R0102
    MAP_SEAFOAM_ISLANDS_B1F = 453 //MAP_D11R0102
    MAP_SEAFOAM_ISLANDS_B2F = 454 //MAP_D11R0103
    MAP_SEAFOAM_ISLANDS_B3F = 455 //MAP_D11R0104
    MAP_SEAFOAM_ISLANDS_B4F = 456 //MAP_D11R0105
    MAP_SEAFOAM_ISLANDS_CINNABAR_GYM = 457 //MAP_D11R0106
    MAP_SEAFOAM_ISLANDS_UNUSED = 458 //MAP_D11R0107
    MAP_MOUNT_SILVER_CAVE_UPPER_MOUNTAINSIDE = 459 //MAP_D41R0102
    MAP_MOUNT_SILVER_CAVE_LOWER_MOUNTAINSIDE = 460 //MAP_D41R0103
    MAP_MOUNT_SILVER_CAVE_EXPERT_BELT_CHAMBER = 461 //MAP_D41R0104
    MAP_MOUNT_SILVER_CAVE_MOLTRES_CHAMBER = 462 //MAP_D41R0105
    MAP_MOUNT_SILVER_CAVE_2F = 463 //MAP_D41R0106
    MAP_MOUNT_SILVER_CAVE_3F = 464 //MAP_D41R0107
    MAP_MOUNT_SILVER_CAVE_SUMMIT = 465 //MAP_D41R0108
    MAP_ROUTE_10_POKECENTER_1F = 466 //MAP_R10PC0101
    MAP_ROUTE_10_POWER_PLANT_REPAIRED = 467 //MAP_R10R0201
    MAP_ROUTE_5_UNUSED = 468 //MAP_R05R0101
    MAP_ROUTE_5_UNDERGROUND_PATH_GATE = 469 //MAP_R05R0201
    MAP_ROUTE_6_UNDERGROUND_PATH_GATE = 470 //MAP_R06R0101
    MAP_PEWTER_MUSEUM_OF_SCIENCE = 471 //MAP_T03R0101
    MAP_PEWTER_NORTHEAST_HOUSE = 472 //MAP_T03R0201
    MAP_PEWTER_GYM = 473 //MAP_T03GYM0101
    MAP_PEWTER_POKEMART = 474 //MAP_T03FS0101
    MAP_PEWTER_POKECENTER_1F = 475 //MAP_T03PC0101
    MAP_PEWTER_POKECENTER_B1F = 476 //MAP_T03PC0102
    MAP_PEWTER_SOUTHWEST_HOUSE = 477 //MAP_T03R0601
    MAP_FUCHSIA_POKEMART = 478 //MAP_T08FS0101
    MAP_FUCHSIA_PAL_PARK_ENTRANCE = 479 //MAP_T08R0201
    MAP_FUCHSIA_GYM = 480 //MAP_T08GYM0101
    MAP_FUCHSIA_SOUTHWEST_HOUSE = 481 //MAP_T08R0401
    MAP_FUCHSIA_POKECENTER_1F = 482 //MAP_T08PC0101
    MAP_FUCHSIA_SAFARI_ZONE_WARDEN_HOUSE = 483 //MAP_T08R0601
    MAP_ROUTE_10_POKECENTER_B1F = 484 //MAP_R10PC0102
    MAP_FUCHSIA_POKECENTER_B1F = 485 //MAP_T08PC0102
    MAP_WHIRL_ISLANDS_B3F = 486 //MAP_D40R0106
    MAP_NATIONAL_PARK_BUG_CATCHING_CONTEST = 487 //MAP_D22R0102
    MAP_NATIONAL_PARK_UNUSED = 488 //MAP_D22R0103
    MAP_ROUTE_10_POWER_PLANT_BROKEN = 489 //MAP_R10R0202
    MAP_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT = 490 //MAP_D24R0216
    MAP_RUINS_OF_ALPH_HALL_ENTRANCE_SINJOH_EVENT = 491 //MAP_D24R0217
    MAP_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2 = 492 //MAP_D24R0218
    MAP_ROUTE_7_SAFFRON_GATEHOUSE = 493 //MAP_R07R0101
    MAP_LAVENDER_POKECENTER_B1F = 494 //MAP_T05PC0102
    MAP_CERULEAN_POKECENTER_B1F = 495 //MAP_T04PC0102
    MAP_VIRIDIAN_GYM = 496 //MAP_T02GYM0101
    MAP_VIRIDIAN_NORTHEAST_HOUSE = 497 //MAP_T02R0201
    MAP_VIRIDIAN_TRAINER_HOUSE_1F = 498 //MAP_T02R0301
    MAP_VIRIDIAN_TRAINER_HOUSE_B1F = 499 //MAP_T02R0302
    MAP_VIRIDIAN_POKEMART = 500 //MAP_T02FS0101
    MAP_VIRIDIAN_POKECENTER_1F = 501 //MAP_T02PC0101
    MAP_VIRIDIAN_POKECENTER_B1F = 502 //MAP_T02PC0102
    MAP_PALLET_TOWN_REDS_HOUSE_1F = 503 //MAP_T01R0101
    MAP_PALLET_TOWN_BLUES_HOUSE_1F = 504 //MAP_T01R0201
    MAP_PALLET_TOWN_OAKS_LAB = 505 //MAP_T01R0301
    MAP_PALLET_TOWN_REDS_HOUSE_2F = 506 //MAP_T01R0102
    MAP_PALLET_TOWN_BLUES_HOUSE_2F = 507 //MAP_T01R0202
    MAP_CINNABAR_ISLAND_POKECENTER_1F = 508 //MAP_T09PC0101
    MAP_CINNABAR_ISLAND_POKECENTER_B1F = 509 //MAP_T09PC0102
    MAP_ROUTE_28_HOUSE = 510 //MAP_R28R0101
    MAP_ROUTE_3_POKECENTER_1F = 511 //MAP_R03PC0101
    MAP_ROUTE_3_POKECENTER_B1F = 512 //MAP_R03PC0102
    MAP_MOUNT_MOON_SQUARE_CLEFAIRY_EVENT = 513 //MAP_D02R0104
    MAP_MOUNT_SILVER_POKECENTER_1F = 514 //MAP_T31PC0101
    MAP_MOUNT_SILVER_POKECENTER_B1F = 515 //MAP_T31PC0102
    MAP_WIFI_PLAZA_WARP_ROOM = 516 //MAP_HIROBA
    MAP_ROUTE_5_HOUSE = 517 //MAP_R05R0401
    MAP_MOUNT_MOON_SQUARE_SHOP = 518 //MAP_D02FS0101
    MAP_GOLDENROD_MAGNET_TRAIN_STATION_2F_EMPTY = 519 //MAP_T25R0503
    MAP_SAFFRON_MAGNET_TRAIN_STATION_2F_EMPTY = 520 //MAP_T11R0603
    MAP_SINJOH_RUINS_EXTERIOR = 521 //MAP_D51R0101
    MAP_SINJOH_RUINS_MYSTRI_STAGE = 522 //MAP_D51R0201
    MAP_SINJOH_RUINS_CABIN = 523 //MAP_D51R0301
    MAP_EMBEDDED_TOWER_GROUDON_ROOM = 524 //MAP_D52R0101
    MAP_EMBEDDED_TOWER_KYOGRE_ROOM = 525 //MAP_D52R0102
    MAP_EMBEDDED_TOWER_RAYQUAZA_ROOM = 526 //MAP_D52R0103
    MAP_VIRIDIAN_ROUTE_1_GATEHOUSE = 527 //MAP_T02R0401
    MAP_FRONTIER_ACCESS_POKECENTER_1F = 528 //MAP_D32PC0101
    MAP_FRONTIER_ACCESS_POKECENTER_B1F = 529 //MAP_D32PC0102
    MAP_FRONTIER_ACCESS_POKEMART = 530 //MAP_D32FS0101
    MAP_FRONTIER_ACCESS_MOVE_TUTOR_HOUSE = 531 //MAP_D32R0103
    MAP_ROUTE_5_UNDERGROUND_PATH = 532 //MAP_R05R0202
    MAP_ROUTE_12_FISHING_BROTHER_HOUSE = 533 //MAP_R12R0101
    MAP_SAFARI_ZONE_GATE_POKECENTER_1F = 534 //MAP_D47PC0101
    MAP_SAFARI_ZONE_GATE_POKECENTER_B1F = 535 //MAP_D47PC0102
    MAP_GOLDENROD_GAME_CORNER = 536 //MAP_T25SP0101
    MAP_CELADON_GAME_CORNER = 537 //MAP_T07SP0101
    MAP_UNUSED = 538 //MAP_R00
    MAP_POKEMON_LEAGUE_ENTRANCE_WIFI_ROOM = 539 //MAP_T10R0801

MOVE_NONE = 0
    MOVE_POUND = 1
    MOVE_KARATE_CHOP = 2
    MOVE_DOUBLE_SLAP = 3
    MOVE_COMET_PUNCH = 4
    MOVE_MEGA_PUNCH = 5
    MOVE_PAY_DAY = 6
    MOVE_FIRE_PUNCH = 7
    MOVE_ICE_PUNCH = 8
    MOVE_THUNDER_PUNCH = 9
    MOVE_SCRATCH = 10
    MOVE_VICE_GRIP = 11
    MOVE_GUILLOTINE = 12
    MOVE_RAZOR_WIND = 13
    MOVE_SWORDS_DANCE = 14
    MOVE_CUT = 15
    MOVE_GUST = 16
    MOVE_WING_ATTACK = 17
    MOVE_WHIRLWIND = 18
    MOVE_FLY = 19
    MOVE_BIND = 20
    MOVE_SLAM = 21
    MOVE_VINE_WHIP = 22
    MOVE_STOMP = 23
    MOVE_DOUBLE_KICK = 24
    MOVE_MEGA_KICK = 25
    MOVE_JUMP_KICK = 26
    MOVE_ROLLING_KICK = 27
    MOVE_SAND_ATTACK = 28
    MOVE_HEADBUTT = 29
    MOVE_HORN_ATTACK = 30
    MOVE_FURY_ATTACK = 31
    MOVE_HORN_DRILL = 32
    MOVE_TACKLE = 33
    MOVE_BODY_SLAM = 34
    MOVE_WRAP = 35
    MOVE_TAKE_DOWN = 36
    MOVE_THRASH = 37
    MOVE_DOUBLE_EDGE = 38
    MOVE_TAIL_WHIP = 39
    MOVE_POISON_STING = 40
    MOVE_TWINEEDLE = 41
    MOVE_PIN_MISSILE = 42
    MOVE_LEER = 43
    MOVE_BITE = 44
    MOVE_GROWL = 45
    MOVE_ROAR = 46
    MOVE_SING = 47
    MOVE_SUPERSONIC = 48
    MOVE_SONIC_BOOM = 49
    MOVE_DISABLE = 50
    MOVE_ACID = 51
    MOVE_EMBER = 52
    MOVE_FLAMETHROWER = 53
    MOVE_MIST = 54
    MOVE_WATER_GUN = 55
    MOVE_HYDRO_PUMP = 56
    MOVE_SURF = 57
    MOVE_ICE_BEAM = 58
    MOVE_BLIZZARD = 59
    MOVE_PSYBEAM = 60
    MOVE_BUBBLE_BEAM = 61
    MOVE_AURORA_BEAM = 62
    MOVE_HYPER_BEAM = 63
    MOVE_PECK = 64
    MOVE_DRILL_PECK = 65
    MOVE_SUBMISSION = 66
    MOVE_LOW_KICK = 67
    MOVE_COUNTER = 68
    MOVE_SEISMIC_TOSS = 69
    MOVE_STRENGTH = 70
    MOVE_ABSORB = 71
    MOVE_MEGA_DRAIN = 72
    MOVE_LEECH_SEED = 73
    MOVE_GROWTH = 74
    MOVE_RAZOR_LEAF = 75
    MOVE_SOLAR_BEAM = 76
    MOVE_POISON_POWDER = 77
    MOVE_STUN_SPORE = 78
    MOVE_SLEEP_POWDER = 79
    MOVE_PETAL_DANCE = 80
    MOVE_STRING_SHOT = 81
    MOVE_DRAGON_RAGE = 82
    MOVE_FIRE_SPIN = 83
    MOVE_THUNDER_SHOCK = 84
    MOVE_THUNDERBOLT = 85
    MOVE_THUNDER_WAVE = 86
    MOVE_THUNDER = 87
    MOVE_ROCK_THROW = 88
    MOVE_EARTHQUAKE = 89
    MOVE_FISSURE = 90
    MOVE_DIG = 91
    MOVE_TOXIC = 92
    MOVE_CONFUSION = 93
    MOVE_PSYCHIC = 94
    MOVE_HYPNOSIS = 95
    MOVE_MEDITATE = 96
    MOVE_AGILITY = 97
    MOVE_QUICK_ATTACK = 98
    MOVE_RAGE = 99
    MOVE_TELEPORT = 100
    MOVE_NIGHT_SHADE = 101
    MOVE_MIMIC = 102
    MOVE_SCREECH = 103
    MOVE_DOUBLE_TEAM = 104
    MOVE_RECOVER = 105
    MOVE_HARDEN = 106
    MOVE_MINIMIZE = 107
    MOVE_SMOKE_SCREEN = 108
    MOVE_CONFUSE_RAY = 109
    MOVE_WITHDRAW = 110
    MOVE_DEFENSE_CURL = 111
    MOVE_BARRIER = 112
    MOVE_LIGHT_SCREEN = 113
    MOVE_HAZE = 114
    MOVE_REFLECT = 115
    MOVE_FOCUS_ENERGY = 116
    MOVE_BIDE = 117
    MOVE_METRONOME = 118
    MOVE_MIRROR_MOVE = 119
    MOVE_SELFDESTRUCT = 120
    MOVE_EGG_BOMB = 121
    MOVE_LICK = 122
    MOVE_SMOG = 123
    MOVE_SLUDGE = 124
    MOVE_BONE_CLUB = 125
    MOVE_FIRE_BLAST = 126
    MOVE_WATERFALL = 127
    MOVE_CLAMP = 128
    MOVE_SWIFT = 129
    MOVE_SKULL_BASH = 130
    MOVE_SPIKE_CANNON = 131
    MOVE_CONSTRICT = 132
    MOVE_AMNESIA = 133
    MOVE_KINESIS = 134
    MOVE_SOFTBOILED = 135
    MOVE_HI_JUMP_KICK = 136
    MOVE_GLARE = 137
    MOVE_DREAM_EATER = 138
    MOVE_POISON_GAS = 139
    MOVE_BARRAGE = 140
    MOVE_LEECH_LIFE = 141
    MOVE_LOVELY_KISS = 142
    MOVE_SKY_ATTACK = 143
    MOVE_TRANSFORM = 144
    MOVE_BUBBLE = 145
    MOVE_DIZZY_PUNCH = 146
    MOVE_SPORE = 147
    MOVE_FLASH = 148
    MOVE_PSYWAVE = 149
    MOVE_SPLASH = 150
    MOVE_ACID_ARMOR = 151
    MOVE_CRABHAMMER = 152
    MOVE_EXPLOSION = 153
    MOVE_FURY_SWIPES = 154
    MOVE_BONEMERANG = 155
    MOVE_REST = 156
    MOVE_ROCK_SLIDE = 157
    MOVE_HYPER_FANG = 158
    MOVE_SHARPEN = 159
    MOVE_CONVERSION = 160
    MOVE_TRI_ATTACK = 161
    MOVE_SUPER_FANG = 162
    MOVE_SLASH = 163
    MOVE_SUBSTITUTE = 164
    MOVE_STRUGGLE = 165
    MOVE_SKETCH = 166
    MOVE_TRIPLE_KICK = 167
    MOVE_THIEF = 168
    MOVE_SPIDER_WEB = 169
    MOVE_MIND_READER = 170
    MOVE_NIGHTMARE = 171
    MOVE_FLAME_WHEEL = 172
    MOVE_SNORE = 173
    MOVE_CURSE = 174
    MOVE_FLAIL = 175
    MOVE_CONVERSION_2 = 176
    MOVE_AEROBLAST = 177
    MOVE_COTTON_SPORE = 178
    MOVE_REVERSAL = 179
    MOVE_SPITE = 180
    MOVE_POWDER_SNOW = 181
    MOVE_PROTECT = 182
    MOVE_MACH_PUNCH = 183
    MOVE_SCARY_FACE = 184
    MOVE_FAINT_ATTACK = 185
    MOVE_SWEET_KISS = 186
    MOVE_BELLY_DRUM = 187
    MOVE_SLUDGE_BOMB = 188
    MOVE_MUD_SLAP = 189
    MOVE_OCTAZOOKA = 190
    MOVE_SPIKES = 191
    MOVE_ZAP_CANNON = 192
    MOVE_FORESIGHT = 193
    MOVE_DESTINY_BOND = 194
    MOVE_PERISH_SONG = 195
    MOVE_ICY_WIND = 196
    MOVE_DETECT = 197
    MOVE_BONE_RUSH = 198
    MOVE_LOCK_ON = 199
    MOVE_OUTRAGE = 200
    MOVE_SANDSTORM = 201
    MOVE_GIGA_DRAIN = 202
    MOVE_ENDURE = 203
    MOVE_CHARM = 204
    MOVE_ROLLOUT = 205
    MOVE_FALSE_SWIPE = 206
    MOVE_SWAGGER = 207
    MOVE_MILK_DRINK = 208
    MOVE_SPARK = 209
    MOVE_FURY_CUTTER = 210
    MOVE_STEEL_WING = 211
    MOVE_MEAN_LOOK = 212
    MOVE_ATTRACT = 213
    MOVE_SLEEP_TALK = 214
    MOVE_HEAL_BELL = 215
    MOVE_RETURN = 216
    MOVE_PRESENT = 217
    MOVE_FRUSTRATION = 218
    MOVE_SAFEGUARD = 219
    MOVE_PAIN_SPLIT = 220
    MOVE_SACRED_FIRE = 221
    MOVE_MAGNITUDE = 222
    MOVE_DYNAMIC_PUNCH = 223
    MOVE_MEGAHORN = 224
    MOVE_DRAGON_BREATH = 225
    MOVE_BATON_PASS = 226
    MOVE_ENCORE = 227
    MOVE_PURSUIT = 228
    MOVE_RAPID_SPIN = 229
    MOVE_SWEET_SCENT = 230
    MOVE_IRON_TAIL = 231
    MOVE_METAL_CLAW = 232
    MOVE_VITAL_THROW = 233
    MOVE_MORNING_SUN = 234
    MOVE_SYNTHESIS = 235
    MOVE_MOONLIGHT = 236
    MOVE_HIDDEN_POWER = 237
    MOVE_CROSS_CHOP = 238
    MOVE_TWISTER = 239
    MOVE_RAIN_DANCE = 240
    MOVE_SUNNY_DAY = 241
    MOVE_CRUNCH = 242
    MOVE_MIRROR_COAT = 243
    MOVE_PSYCH_UP = 244
    MOVE_EXTREME_SPEED = 245
    MOVE_ANCIENT_POWER = 246
    MOVE_SHADOW_BALL = 247
    MOVE_FUTURE_SIGHT = 248
    MOVE_ROCK_SMASH = 249
    MOVE_WHIRLPOOL = 250
    MOVE_BEAT_UP = 251
    MOVE_FAKE_OUT = 252
    MOVE_UPROAR = 253
    MOVE_STOCKPILE = 254
    MOVE_SPIT_UP = 255
    MOVE_SWALLOW = 256
    MOVE_HEAT_WAVE = 257
    MOVE_HAIL = 258
    MOVE_TORMENT = 259
    MOVE_FLATTER = 260
    MOVE_WILL_O_WISP = 261
    MOVE_MEMENTO = 262
    MOVE_FACADE = 263
    MOVE_FOCUS_PUNCH = 264
    MOVE_SMELLING_SALT = 265
    MOVE_FOLLOW_ME = 266
    MOVE_NATURE_POWER = 267
    MOVE_CHARGE = 268
    MOVE_TAUNT = 269
    MOVE_HELPING_HAND = 270
    MOVE_TRICK = 271
    MOVE_ROLE_PLAY = 272
    MOVE_WISH = 273
    MOVE_ASSIST = 274
    MOVE_INGRAIN = 275
    MOVE_SUPERPOWER = 276
    MOVE_MAGIC_COAT = 277
    MOVE_RECYCLE = 278
    MOVE_REVENGE = 279
    MOVE_BRICK_BREAK = 280
    MOVE_YAWN = 281
    MOVE_KNOCK_OFF = 282
    MOVE_ENDEAVOR = 283
    MOVE_ERUPTION = 284
    MOVE_SKILL_SWAP = 285
    MOVE_IMPRISON = 286
    MOVE_REFRESH = 287
    MOVE_GRUDGE = 288
    MOVE_SNATCH = 289
    MOVE_SECRET_POWER = 290
    MOVE_DIVE = 291
    MOVE_ARM_THRUST = 292
    MOVE_CAMOUFLAGE = 293
    MOVE_TAIL_GLOW = 294
    MOVE_LUSTER_PURGE = 295
    MOVE_MIST_BALL = 296
    MOVE_FEATHER_DANCE = 297
    MOVE_TEETER_DANCE = 298
    MOVE_BLAZE_KICK = 299
    MOVE_MUD_SPORT = 300
    MOVE_ICE_BALL = 301
    MOVE_NEEDLE_ARM = 302
    MOVE_SLACK_OFF = 303
    MOVE_HYPER_VOICE = 304
    MOVE_POISON_FANG = 305
    MOVE_CRUSH_CLAW = 306
    MOVE_BLAST_BURN = 307
    MOVE_HYDRO_CANNON = 308
    MOVE_METEOR_MASH = 309
    MOVE_ASTONISH = 310
    MOVE_WEATHER_BALL = 311
    MOVE_AROMATHERAPY = 312
    MOVE_FAKE_TEARS = 313
    MOVE_AIR_CUTTER = 314
    MOVE_OVERHEAT = 315
    MOVE_ODOR_SLEUTH = 316
    MOVE_ROCK_TOMB = 317
    MOVE_SILVER_WIND = 318
    MOVE_METAL_SOUND = 319
    MOVE_GRASS_WHISTLE = 320
    MOVE_TICKLE = 321
    MOVE_COSMIC_POWER = 322
    MOVE_WATER_SPOUT = 323
    MOVE_SIGNAL_BEAM = 324
    MOVE_SHADOW_PUNCH = 325
    MOVE_EXTRASENSORY = 326
    MOVE_SKY_UPPERCUT = 327
    MOVE_SAND_TOMB = 328
    MOVE_SHEER_COLD = 329
    MOVE_MUDDY_WATER = 330
    MOVE_BULLET_SEED = 331
    MOVE_AERIAL_ACE = 332
    MOVE_ICICLE_SPEAR = 333
    MOVE_IRON_DEFENSE = 334
    MOVE_BLOCK = 335
    MOVE_HOWL = 336
    MOVE_DRAGON_CLAW = 337
    MOVE_FRENZY_PLANT = 338
    MOVE_BULK_UP = 339
    MOVE_BOUNCE = 340
    MOVE_MUD_SHOT = 341
    MOVE_POISON_TAIL = 342
    MOVE_COVET = 343
    MOVE_VOLT_TACKLE = 344
    MOVE_MAGICAL_LEAF = 345
    MOVE_WATER_SPORT = 346
    MOVE_CALM_MIND = 347
    MOVE_LEAF_BLADE = 348
    MOVE_DRAGON_DANCE = 349
    MOVE_ROCK_BLAST = 350
    MOVE_SHOCK_WAVE = 351
    MOVE_WATER_PULSE = 352
    MOVE_DOOM_DESIRE = 353
    MOVE_PSYCHO_BOOST = 354
    MOVE_ROOST = 355
    MOVE_GRAVITY = 356
    MOVE_MIRACLE_EYE = 357
    MOVE_WAKE_UP_SLAP = 358
    MOVE_HAMMER_ARM = 359
    MOVE_GYRO_BALL = 360
    MOVE_HEALING_WISH = 361
    MOVE_BRINE = 362
    MOVE_NATURAL_GIFT = 363
    MOVE_FEINT = 364
    MOVE_PLUCK = 365
    MOVE_TAILWIND = 366
    MOVE_ACUPRESSURE = 367
    MOVE_METAL_BURST = 368
    MOVE_U_TURN = 369
    MOVE_CLOSE_COMBAT = 370
    MOVE_PAYBACK = 371
    MOVE_ASSURANCE = 372
    MOVE_EMBARGO = 373
    MOVE_FLING = 374
    MOVE_PSYCHO_SHIFT = 375
    MOVE_TRUMP_CARD = 376
    MOVE_HEAL_BLOCK = 377
    MOVE_WRING_OUT = 378
    MOVE_POWER_TRICK = 379
    MOVE_GASTRO_ACID = 380
    MOVE_LUCKY_CHANT = 381
    MOVE_ME_FIRST = 382
    MOVE_COPYCAT = 383
    MOVE_POWER_SWAP = 384
    MOVE_GUARD_SWAP = 385
    MOVE_PUNISHMENT = 386
    MOVE_LAST_RESORT = 387
    MOVE_WORRY_SEED = 388
    MOVE_SUCKER_PUNCH = 389
    MOVE_TOXIC_SPIKES = 390
    MOVE_HEART_SWAP = 391
    MOVE_AQUA_RING = 392
    MOVE_MAGNET_RISE = 393
    MOVE_FLARE_BLITZ = 394
    MOVE_FORCE_PALM = 395
    MOVE_AURA_SPHERE = 396
    MOVE_ROCK_POLISH = 397
    MOVE_POISON_JAB = 398
    MOVE_DARK_PULSE = 399
    MOVE_NIGHT_SLASH = 400
    MOVE_AQUA_TAIL = 401
    MOVE_SEED_BOMB = 402
    MOVE_AIR_SLASH = 403
    MOVE_X_SCISSOR = 404
    MOVE_BUG_BUZZ = 405
    MOVE_DRAGON_PULSE = 406
    MOVE_DRAGON_RUSH = 407
    MOVE_POWER_GEM = 408
    MOVE_DRAIN_PUNCH = 409
    MOVE_VACUUM_WAVE = 410
    MOVE_FOCUS_BLAST = 411
    MOVE_ENERGY_BALL = 412
    MOVE_BRAVE_BIRD = 413
    MOVE_EARTH_POWER = 414
    MOVE_SWITCHEROO = 415
    MOVE_GIGA_IMPACT = 416
    MOVE_NASTY_PLOT = 417
    MOVE_BULLET_PUNCH = 418
    MOVE_AVALANCHE = 419
    MOVE_ICE_SHARD = 420
    MOVE_SHADOW_CLAW = 421
    MOVE_THUNDER_FANG = 422
    MOVE_ICE_FANG = 423
    MOVE_FIRE_FANG = 424
    MOVE_SHADOW_SNEAK = 425
    MOVE_MUD_BOMB = 426
    MOVE_PSYCHO_CUT = 427
    MOVE_ZEN_HEADBUTT = 428
    MOVE_MIRROR_SHOT = 429
    MOVE_FLASH_CANNON = 430
    MOVE_ROCK_CLIMB = 431
    MOVE_DEFOG = 432
    MOVE_TRICK_ROOM = 433
    MOVE_DRACO_METEOR = 434
    MOVE_DISCHARGE = 435
    MOVE_LAVA_PLUME = 436
    MOVE_LEAF_STORM = 437
    MOVE_POWER_WHIP = 438
    MOVE_ROCK_WRECKER = 439
    MOVE_CROSS_POISON = 440
    MOVE_GUNK_SHOT = 441
    MOVE_IRON_HEAD = 442
    MOVE_MAGNET_BOMB = 443
    MOVE_STONE_EDGE = 444
    MOVE_CAPTIVATE = 445
    MOVE_STEALTH_ROCK = 446
    MOVE_GRASS_KNOT = 447
    MOVE_CHATTER = 448
    MOVE_JUDGMENT = 449
    MOVE_BUG_BITE = 450
    MOVE_CHARGE_BEAM = 451
    MOVE_WOOD_HAMMER = 452
    MOVE_AQUA_JET = 453
    MOVE_ATTACK_ORDER = 454
    MOVE_DEFEND_ORDER = 455
    MOVE_HEAL_ORDER = 456
    MOVE_HEAD_SMASH = 457
    MOVE_DOUBLE_HIT = 458
    MOVE_ROAR_OF_TIME = 459
    MOVE_SPACIAL_REND = 460
    MOVE_LUNAR_DANCE = 461
    MOVE_CRUSH_GRIP = 462
    MOVE_MAGMA_STORM = 463
    MOVE_DARK_VOID = 464
    MOVE_SEED_FLARE = 465
    MOVE_OMINOUS_WIND = 466
    MOVE_SHADOW_FORCE = 467

TYPE_NORMAL = 0
    TYPE_FIGHTING = 1
    TYPE_FLYING = 2
    TYPE_POISON = 3
    TYPE_GROUND = 4
    TYPE_ROCK = 5
    TYPE_BUG = 6
    TYPE_GHOST = 7
    TYPE_STEEL = 8
    TYPE_MYSTERY = 9
    TYPE_FIRE = 10
    TYPE_WATER = 11
    TYPE_GRASS = 12
    TYPE_ELECTRIC = 13
    TYPE_PSYCHIC = 14
    TYPE_ICE = 15
    TYPE_DRAGON = 16
    TYPE_DARK = 17

TRAINER_NONE = 0
    TRAINER_RIVAL_SILVER = 1
    TRAINER_RIVAL_SILVER_2 = 2
    TRAINER_RIVAL_SILVER_3 = 3
    TRAINER_BUG_CATCHER_WADE = 4
    TRAINER_BEAUTY_VICTORIA = 5
    TRAINER_POLICEMAN_KEITH = 6
    TRAINER_JUGGLER_IRWIN = 7
    TRAINER_YOUNGSTER_JOEY = 8
    TRAINER_SWIMMER_F_ELAINE = 9
    TRAINER_TWINS_AMY_AND_MIMI = 10
    TRAINER_KIMONO_GIRL_MICKEY = 11
    TRAINER_TEAM_ROCKET_GRUNT = 12
    TRAINER_TEAM_ROCKET_F_GRUNT = 13
    TRAINER_BURGLAR_DUNCAN = 14
    TRAINER_FIREBREATHER_OTIS = 15
    TRAINER_SWIMMER_M_SIMON = 16
    TRAINER_BLACK_BELT_KENJI = 17
    TRAINER_FISHERMAN_JUSTIN = 18
    TRAINER_BIKER_MICKEY = 19
    TRAINER_LEADER_FALKNER_FALKNER = 20
    TRAINER_LEADER_BUGSY_BUGSY = 21
    TRAINER_LASS_CARRIE = 22
    TRAINER_POKE_MANIAC_LARRY = 23
    TRAINER_SCHOOL_KID_M_ALAN = 24
    TRAINER_HIKER_RUSSEL = 25
    TRAINER_CAMPER_ROLAND = 26
    TRAINER_PICNICKER_LIZ = 27
    TRAINER_ACE_TRAINER_M_JAKE = 28
    TRAINER_BIRD_KEEPER_GS_ROD = 29
    TRAINER_LEADER_WHITNEY = 30
    TRAINER_LEADER_MORTY_MORTY = 31
    TRAINER_LEADER_PRYCE_PRYCE = 32
    TRAINER_LEADER_JASMINE_JASMINE = 33
    TRAINER_LEADER_CHUCK_CHUCK = 34
    TRAINER_LEADER_CLAIR_CLAIR = 35
    TRAINER_ACE_TRAINER_F_JOYCE = 36
    TRAINER_GENTLEMAN_PRESTON = 37
    TRAINER_TEACHER_COLETTE = 38
    TRAINER_SAILOR_EUGENE = 39
    TRAINER_SUPER_NERD_MICKEY = 40
    TRAINER_GUITARIST_CLYDE = 41
    TRAINER_PSYCHIC_M_NATHAN = 42
    TRAINER_SAGE_CHOW = 43
    TRAINER_POKEFAN_M_DEREK = 44
    TRAINER_POKEFAN_RUTH = 45
    TRAINER_MEDIUM_MARTHA = 46
    TRAINER_YOUNGSTER_MIKEY = 47
    TRAINER_BUG_CATCHER_ROB = 48
    TRAINER_YOUNGSTER_ALBERT = 49
    TRAINER_BIRD_KEEPER_GS_ABE = 50
    TRAINER_SAGE_NICO = 51
    TRAINER_SAGE_EDMOND = 52
    TRAINER_SAGE_JIN = 53
    TRAINER_SAGE_TROY = 54
    TRAINER_SAGE_NEAL = 55
    TRAINER_YOUNGSTER_GORDON = 56
    TRAINER_FISHERMAN_RALPH = 57
    TRAINER_FISHERMAN_ARNOLD = 58
    TRAINER_FISHERMAN_KYLE = 59
    TRAINER_FISHERMAN_HENRY = 60
    TRAINER_HIKER_ANTHONY = 61
    TRAINER_YOUNGSTER_SAMUEL = 62
    TRAINER_TEAM_ROCKET_MICKEY = 63
    TRAINER_YOUNGSTER_IAN = 64
    TRAINER_PICNICKER_GINA = 65
    TRAINER_CAMPER_TODD = 66
    TRAINER_BUG_CATCHER_BENNY = 67
    TRAINER_BUG_CATCHER_AL = 68
    TRAINER_BUG_CATCHER_JOSH = 69
    TRAINER_BEAUTY_SAMANTHA = 70
    TRAINER_LASS_CATHY = 71
    TRAINER_BIRD_KEEPER_GS_BRYAN = 72
    TRAINER_BIRD_KEEPER_GS_THEO = 73
    TRAINER_CAMPER_IVAN = 74
    TRAINER_CAMPER_ELLIOT = 75
    TRAINER_PICNICKER_BROOKE = 76
    TRAINER_PICNICKER_KIM = 77
    TRAINER_BUG_CATCHER_ARNIE = 78
    TRAINER_BUG_CATCHER_KEN = 79
    TRAINER_POLICEMAN_DIRK = 80
    TRAINER_TWINS_TORI_AND_TIL = 81
    TRAINER_BIRD_KEEPER_GS_TOBY = 82
    TRAINER_PICNICKER_CINDY = 83
    TRAINER_CAMPER_BARRY = 84
    TRAINER_SWIMMER_F_PAULA = 85
    TRAINER_SWIMMER_M_RANDALL = 86
    TRAINER_SAGE_MICKEY = 87
    TRAINER_SAGE_MICKEY_2 = 88
    TRAINER_MEDIUM_GRACE = 89
    TRAINER_SWIMMER_F_KAYLEE = 90
    TRAINER_SWIMMER_F_SUSIE = 91
    TRAINER_SWIMMER_F_DENISE = 92
    TRAINER_SWIMMER_F_KARA = 93
    TRAINER_SWIMMER_F_WENDY = 94
    TRAINER_SWIMMER_M_CHARLIE = 95
    TRAINER_SWIMMER_M_GEORGE = 96
    TRAINER_SWIMMER_M_BERKE = 97
    TRAINER_SWIMMER_M_RONALD = 98
    TRAINER_SWIMMER_M_MATTHEW = 99
    TRAINER_HIKER_ANTHONY_2 = 100
    TRAINER_TEAM_ROCKET_GRUNT_2 = 101
    TRAINER_ACE_TRAINER_M_GAVEN = 102
    TRAINER_ACE_TRAINER_M_BLAKE = 103
    TRAINER_ACE_TRAINER_M_BRIAN = 104
    TRAINER_ACE_TRAINER_M_MICKEY = 105
    TRAINER_ACE_TRAINER_M_MICKEY_2 = 106
    TRAINER_ACE_TRAINER_M_MICKEY_3 = 107
    TRAINER_ACE_TRAINER_M_RYAN = 108
    TRAINER_ACE_TRAINER_M_ALTON = 109
    TRAINER_ACE_TRAINER_M_PAULO = 110
    TRAINER_ACE_TRAINER_M_MIKE = 111
    TRAINER_ACE_TRAINER_M_CODY = 112
    TRAINER_ACE_TRAINER_F_JAMIE = 113
    TRAINER_ACE_TRAINER_F_REENA = 114
    TRAINER_ACE_TRAINER_F_MEGAN = 115
    TRAINER_ACE_TRAINER_F_LOIS = 116
    TRAINER_ACE_TRAINER_F_LOLA = 117
    TRAINER_ACE_TRAINER_F_KATE = 118
    TRAINER_ACE_TRAINER_F_FRAN = 119
    TRAINER_ACE_TRAINER_F_IRENE = 120
    TRAINER_ACE_TRAINER_F_KELLY = 121
    TRAINER_FISHERMAN_MARVIN = 122
    TRAINER_FISHERMAN_TULLY = 123
    TRAINER_FISHERMAN_WILTON = 124
    TRAINER_FISHERMAN_EDGAR = 125
    TRAINER_FISHERMAN_ANDRE = 126
    TRAINER_FISHERMAN_RAYMOND = 127
    TRAINER_FISHERMAN_JONAH = 128
    TRAINER_POKE_MANIAC_SHANE = 129
    TRAINER_POKE_MANIAC_BECKETT = 130
    TRAINER_POKE_MANIAC_BRENT = 131
    TRAINER_POKE_MANIAC_RON = 132
    TRAINER_POKE_MANIAC_MORGAN = 133
    TRAINER_HIKER_BENJAMIN = 134
    TRAINER_SCHOOL_KID_M_JOHNNY = 135
    TRAINER_LASS_LINDA = 136
    TRAINER_BIRD_KEEPER_GS_VANCE = 137
    TRAINER_CAMPER_MICKEY = 138
    TRAINER_PICNICKER_DEBRA = 139
    TRAINER_BUG_CATCHER_DOUG = 140
    TRAINER_CAMPER_MICKEY_2 = 141
    TRAINER_PICNICKER_GINA_2 = 142
    TRAINER_HIKER_ERIK = 143
    TRAINER_HIKER_MICHAEL = 144
    TRAINER_HIKER_PARRY = 145
    TRAINER_HIKER_TIMOTHY = 146
    TRAINER_CAMPER_TED = 147
    TRAINER_CAMPER_LLOYD = 148
    TRAINER_CAMPER_DEAN = 149
    TRAINER_CAMPER_SID = 150
    TRAINER_PICNICKER_ERIN = 151
    TRAINER_PICNICKER_HOPE = 152
    TRAINER_PICNICKER_SHARON = 153
    TRAINER_HIKER_BAILEY = 154
    TRAINER_HIKER_ANTHONY_3 = 155
    TRAINER_BLACK_BELT_YOSHI = 156
    TRAINER_BLACK_BELT_LAO = 157
    TRAINER_BLACK_BELT_KIYO = 158
    TRAINER_BLACK_BELT_LUNG = 159
    TRAINER_KIMONO_GIRL_NAOKO = 160
    TRAINER_KIMONO_GIRL_SAYO = 161
    TRAINER_KIMONO_GIRL_ZUKI = 162
    TRAINER_KIMONO_GIRL_KUNI = 163
    TRAINER_KIMONO_GIRL_MIKI = 164
    TRAINER_SWIMMER_F_MICKEY = 165
    TRAINER_SWIMMER_F_MICKEY_2 = 166
    TRAINER_SWIMMER_F_MICKEY_3 = 167
    TRAINER_SWIMMER_M_MICKEY = 168
    TRAINER_SWIMMER_M_MICKEY_2 = 169
    TRAINER_SWIMMER_M_MICKEY_3 = 170
    TRAINER_SWIMMER_M_MICKEY_4 = 171
    TRAINER_POKE_MANIAC_BRENT_2 = 172
    TRAINER_POKE_MANIAC_BRENT_3 = 173
    TRAINER_BIKER_MICKEY_2 = 174
    TRAINER_MEDIUM_BETHANY = 175
    TRAINER_MEDIUM_MARGARET = 176
    TRAINER_MEDIUM_ETHEL = 177
    TRAINER_SCHOOL_KID_M_JACK = 178
    TRAINER_SCHOOL_KID_M_KIPP = 179
    TRAINER_BEAUTY_MICKEY = 180
    TRAINER_POKEFAN_M_WILLIAM = 181
    TRAINER_POKEFAN_BEVERLY = 182
    TRAINER_LASS_ALICE = 183
    TRAINER_LASS_KRISE = 184
    TRAINER_TEAM_ROCKET_GRUNT_3 = 185
    TRAINER_TEAM_ROCKET_GRUNT_4 = 186
    TRAINER_TEAM_ROCKET_GRUNT_5 = 187
    TRAINER_TEAM_ROCKET_GRUNT_6 = 188
    TRAINER_TEAM_ROCKET_GRUNT_7 = 189
    TRAINER_TEAM_ROCKET_GRUNT_8 = 190
    TRAINER_TEAM_ROCKET_GRUNT_9 = 191
    TRAINER_TEAM_ROCKET_GRUNT_10 = 192
    TRAINER_TEAM_ROCKET_GRUNT_11 = 193
    TRAINER_TEAM_ROCKET_MICKEY_2 = 194
    TRAINER_TEAM_ROCKET_GRUNT_12 = 195
    TRAINER_TEAM_ROCKET_GRUNT_13 = 196
    TRAINER_TEAM_ROCKET_GRUNT_14 = 197
    TRAINER_TEAM_ROCKET_F_GRUNT_2 = 198
    TRAINER_TEAM_ROCKET_F_GRUNT_3 = 199
    TRAINER_TEAM_ROCKET_F_GRUNT_4 = 200
    TRAINER_POKE_MANIAC_ANDREW = 201
    TRAINER_POKE_MANIAC_CALVIN = 202
    TRAINER_HIKER_PHILLIP = 203
    TRAINER_HIKER_LEONARD = 204
    TRAINER_ACE_TRAINER_M_NICK = 205
    TRAINER_ACE_TRAINER_F_GWEN = 206
    TRAINER_BEAUTY_MICKEY_2 = 207
    TRAINER_BEAUTY_MICKEY_3 = 208
    TRAINER_BEAUTY_CASSIE = 209
    TRAINER_BEAUTY_CAROLINE = 210
    TRAINER_SAILOR_HUEY = 211
    TRAINER_SAILOR_TERRELL = 212
    TRAINER_SAILOR_KENT = 213
    TRAINER_SAILOR_ROBERTO = 214
    TRAINER_LASS_CONNIE = 215
    TRAINER_TEAM_ROCKET_GRUNT_15 = 216
    TRAINER_BIRD_KEEPER_GS_DENIS = 217
    TRAINER_TEAM_ROCKET_GRUNT_16 = 218
    TRAINER_TEAM_ROCKET_GRUNT_17 = 219
    TRAINER_TEAM_ROCKET_GRUNT_18 = 220
    TRAINER_TEAM_ROCKET_MICKEY_3 = 221
    TRAINER_TEAM_ROCKET_GRUNT_19 = 222
    TRAINER_TEAM_ROCKET_GRUNT_20 = 223
    TRAINER_TEAM_ROCKET_GRUNT_21 = 224
    TRAINER_TEAM_ROCKET_MICKEY_4 = 225
    TRAINER_TEAM_ROCKET_MICKEY_5 = 226
    TRAINER_TEAM_ROCKET_GRUNT_22 = 227
    TRAINER_TEAM_ROCKET_GRUNT_23 = 228
    TRAINER_TEAM_ROCKET_MICKEY_6 = 229
    TRAINER_PSYCHIC_M_FRANKLIN = 230
    TRAINER_GENTLEMAN_EDWARD = 231
    TRAINER_GUITARIST_VINCENT = 232
    TRAINER_SUPER_NERD_ERIC = 233
    TRAINER_HIKER_EOIN = 234
    TRAINER_HIKER_NOLAND = 235
    TRAINER_ACE_TRAINER_M_SHAYE = 236
    TRAINER_ACE_TRAINER_F_CAROL = 237
    TRAINER_SAILOR_STANLY = 238
    TRAINER_SAILOR_JEFF = 239
    TRAINER_SAILOR_GARRETT = 240
    TRAINER_SAILOR_KENNETH = 241
    TRAINER_JUGGLER_FRITZ = 242
    TRAINER_SWIMMER_F_KATIE = 243
    TRAINER_CHAMPION_LANCE = 244
    TRAINER_ELITE_FOUR_WILL_WILL = 245
    TRAINER_ELITE_FOUR_KAREN_KAREN = 246
    TRAINER_ELITE_FOUR_KOGA_KOGA = 247
    TRAINER_BUG_CATCHER_ED = 248
    TRAINER_BUG_CATCHER_DON = 249
    TRAINER_BLACK_BELT_KENJI_2 = 250
    TRAINER_BLACK_BELT_NOB = 251
    TRAINER_SWIMMER_M_HAROLD = 252
    TRAINER_LEADER_BROCK_BROCK = 253
    TRAINER_LEADER_MISTY_MISTY = 254
    TRAINER_LEADER_LT_SURGE_LT__SURGE = 255
    TRAINER_LEADER_ERIKA_ERIKA = 256
    TRAINER_LEADER_JANINE_JANINE = 257
    TRAINER_LEADER_SABRINA_SABRINA = 258
    TRAINER_LEADER_BLAINE_BLAINE = 259
    TRAINER_PKMN_TRAINER_RED_RED = 260
    TRAINER_LEADER_BLUE_BLUE = 261
    TRAINER_TEAM_ROCKET_MICKEY_7 = 262
    TRAINER_RIVAL_SILVER_4 = 263
    TRAINER_RIVAL_SILVER_5 = 264
    TRAINER_RIVAL_SILVER_6 = 265
    TRAINER_RIVAL_SILVER_7 = 266
    TRAINER_RIVAL_SILVER_8 = 267
    TRAINER_RIVAL_SILVER_9 = 268
    TRAINER_RIVAL_SILVER_10 = 269
    TRAINER_RIVAL_SILVER_11 = 270
    TRAINER_RIVAL_SILVER_12 = 271
    TRAINER_RIVAL_SILVER_13 = 272
    TRAINER_SWIMMER_M_MICKEY_5 = 273
    TRAINER_CAMPER_TODD_2 = 274
    TRAINER_CAMPER_TODD_3 = 275
    TRAINER_PICNICKER_LIZ_2 = 276
    TRAINER_PICNICKER_LIZ_3 = 277
    TRAINER_BLACK_BELT_KENJI_3 = 278
    TRAINER_YOUNGSTER_JOEY_2 = 279
    TRAINER_YOUNGSTER_JOEY_3 = 280
    TRAINER_FIREBREATHER_RICHARD = 281
    TRAINER_FIREBREATHER_NED = 282
    TRAINER_BURGLAR_ORSON = 283
    TRAINER_BURGLAR_COREY = 284
    TRAINER_RIVAL_SILVER_14 = 285
    TRAINER_RIVAL_SILVER_15 = 286
    TRAINER_RIVAL_SILVER_16 = 287
    TRAINER_RIVAL_SILVER_17 = 288
    TRAINER_RIVAL_SILVER_18 = 289
    TRAINER_ELDER_LI = 290
    TRAINER_SWIMMER_F_DEBBIE = 291
    TRAINER_SWIMMER_F_MICKEY_4 = 292
    TRAINER_SWIMMER_F_NICOLE = 293
    TRAINER_SWIMMER_F_LORI = 294
    TRAINER_SWIMMER_F_MICKEY_5 = 295
    TRAINER_SWIMMER_F_NIKKI = 296
    TRAINER_SWIMMER_F_DIANA = 297
    TRAINER_SWIMMER_F_BRIANA = 298
    TRAINER_BIRD_KEEPER_GS_HANK = 299
    TRAINER_BIRD_KEEPER_GS_ROY = 300
    TRAINER_BIRD_KEEPER_GS_BORIS = 301
    TRAINER_BIRD_KEEPER_GS_BOB = 302
    TRAINER_BIRD_KEEPER_GS_JOSE = 303
    TRAINER_CAMPER_MICKEY_3 = 304
    TRAINER_CAMPER_MICKEY_4 = 305
    TRAINER_CAMPER_MICKEY_5 = 306
    TRAINER_CAMPER_MICKEY_6 = 307
    TRAINER_CAMPER_JERRY = 308
    TRAINER_BIKER_DWAYNE = 309
    TRAINER_BIKER_HARRIS = 310
    TRAINER_BIKER_ZEKE = 311
    TRAINER_BIKER_CHARLES = 312
    TRAINER_BIKER_REESE = 313
    TRAINER_BIKER_JOEL = 314
    TRAINER_BIKER_GLENN = 315
    TRAINER_PSYCHIC_M_HERMAN = 316
    TRAINER_PSYCHIC_M_FIDEL = 317
    TRAINER_FIREBREATHER_BURT = 318
    TRAINER_FIREBREATHER_BILL = 319
    TRAINER_FISHERMAN_MARTIN = 320
    TRAINER_FISHERMAN_STEPHEN = 321
    TRAINER_FISHERMAN_BARNEY = 322
    TRAINER_FISHERMAN_TULLY_2 = 323
    TRAINER_FISHERMAN_TULLY_3 = 324
    TRAINER_FISHERMAN_WILTON_2 = 325
    TRAINER_TWINS_JO_AND_ZOE = 326
    TRAINER_SCHOOL_KID_M_DANNY = 327
    TRAINER_SCHOOL_KID_M_TOMMY = 328
    TRAINER_SCHOOL_KID_M_DUDLEY = 329
    TRAINER_SCHOOL_KID_M_JOE = 330
    TRAINER_SCHOOL_KID_M_BILLY = 331
    TRAINER_PICNICKER_HEIDI = 332
    TRAINER_PICNICKER_EDNA = 333
    TRAINER_PICNICKER_GINA_3 = 334
    TRAINER_PICNICKER_ERIN_2 = 335
    TRAINER_PICNICKER_TANYA = 336
    TRAINER_GENTLEMAN_GREGORY = 337
    TRAINER_GENTLEMAN_MICKEY = 338
    TRAINER_BLACK_BELT_WAI = 339
    TRAINER_BEAUTY_MICKEY_4 = 340
    TRAINER_BEAUTY_MICKEY_5 = 341
    TRAINER_BEAUTY_MICKEY_6 = 342
    TRAINER_BEAUTY_MICKEY_7 = 343
    TRAINER_BEAUTY_MICKEY_8 = 344
    TRAINER_BEAUTY_MICKEY_9 = 345
    TRAINER_BEAUTY_JULIA = 346
    TRAINER_BEAUTY_MICKEY_10 = 347
    TRAINER_POKEFAN_M_ROBERT = 348
    TRAINER_POKEFAN_M_JOSHUA = 349
    TRAINER_POKEFAN_M_CARTER = 350
    TRAINER_POKEFAN_M_TREVOR = 351
    TRAINER_POKEFAN_GEORGIA = 352
    TRAINER_TEAM_ROCKET_GRUNT_24 = 353
    TRAINER_LASS_LAURA = 354
    TRAINER_LASS_SHANNON = 355
    TRAINER_LASS_MICHELLE = 356
    TRAINER_HIKER_CLARKE = 357
    TRAINER_HIKER_KENNY = 358
    TRAINER_HIKER_JIM = 359
    TRAINER_BUG_CATCHER_ARNIE_2 = 360
    TRAINER_ACE_TRAINER_M_KEVIN = 361
    TRAINER_ACE_TRAINER_F_QUINN = 362
    TRAINER_ACE_TRAINER_F_EMMA = 363
    TRAINER_SUPER_NERD_SAM = 364
    TRAINER_SUPER_NERD_TYRONE = 365
    TRAINER_SUPER_NERD_PAT = 366
    TRAINER_SUPER_NERD_SHAWN = 367
    TRAINER_MEDIUM_REBECCA = 368
    TRAINER_MEDIUM_DARCY = 369
    TRAINER_SWIMMER_M_JEROME = 370
    TRAINER_SWIMMER_M_TUCKER = 371
    TRAINER_SWIMMER_M_MICKEY_6 = 372
    TRAINER_SWIMMER_M_FRANKIE = 373
    TRAINER_SWIMMER_M_TYSON = 374
    TRAINER_SWIMMER_M_MICKEY_7 = 375
    TRAINER_SWIMMER_M_MICKEY_8 = 376
    TRAINER_SWIMMER_M_PARKER = 377
    TRAINER_YOUNGSTER_WARREN = 378
    TRAINER_YOUNGSTER_JIMMY = 379
    TRAINER_YOUNGSTER_OWEN = 380
    TRAINER_YOUNGSTER_JASON = 381
    TRAINER_TEACHER_HILLARY = 382
    TRAINER_BIRD_KEEPER_GS_PETER = 383
    TRAINER_HIKER_DANIEL = 384
    TRAINER_TWINS_DARA_AND_DIA = 385
    TRAINER_PSYCHIC_M_GREG = 386
    TRAINER_TWINS_AMY_AND_MIMI_2 = 387
    TRAINER_FIREBREATHER_WALT = 388
    TRAINER_PSYCHIC_M_NELSON = 389
    TRAINER_FIREBREATHER_RAY = 390
    TRAINER_POKE_MANIAC_ISSAC = 391
    TRAINER_POKE_MANIAC_DONALD = 392
    TRAINER_SUPER_NERD_TERU = 393
    TRAINER_ACE_TRAINER_M_MICKEY_4 = 394
    TRAINER_PSYCHIC_M_MARK = 395
    TRAINER_JUGGLER_HORTON = 396
    TRAINER_SCHOOL_KID_M_CHAD = 397
    TRAINER_BEAUTY_VALERIE = 398
    TRAINER_FIREBREATHER_LYLE = 399
    TRAINER_LASS_DANA = 400
    TRAINER_GENTLEMAN_ALFRED = 401
    TRAINER_PICNICKER_TIFFANY = 402
    TRAINER_CAMPER_SPENCER = 403
    TRAINER_TEAM_ROCKET_F_GRUNT_5 = 404
    TRAINER_PSYCHIC_M_PHIL = 405
    TRAINER_POKE_MANIAC_ZACH = 406
    TRAINER_ACE_TRAINER_M_ALLEN = 407
    TRAINER_ACE_TRAINER_F_CYBIL = 408
    TRAINER_POKEFAN_M_BRANDON = 409
    TRAINER_SAILOR_HARRY = 410
    TRAINER_PSYCHIC_M_VERNON = 411
    TRAINER_PSYCHIC_M_ELI = 412
    TRAINER_FISHERMAN_SCOTT = 413
    TRAINER_BIRD_KEEPER_GS_JOSE_2 = 414
    TRAINER_PSYCHIC_M_JARED = 415
    TRAINER_TWINS_JO_AND_ZOE_2 = 416
    TRAINER_ACE_TRAINER_F_JENN = 417
    TRAINER_ELITE_FOUR_BRUNO_BRUNO = 418
    TRAINER_LASS_ELLEN = 419
    TRAINER_BIRD_KEEPER_GS_PERRY = 420
    TRAINER_BIRD_KEEPER_GS_BRET = 421
    TRAINER_PSYCHIC_M_RODNEY = 422
    TRAINER_POKEFAN_M_JEREMY = 423
    TRAINER_POKEFAN_M_COLIN = 424
    TRAINER_TWINS_MEG_AND_PEG = 425
    TRAINER_TWINS_MEG_AND_PEG_2 = 426
    TRAINER_TEACHER_SHIRLEY = 427
    TRAINER_SCHOOL_KID_M_NATE = 428
    TRAINER_SCHOOL_KID_M_RICKY = 429
    TRAINER_SCHOOL_KID_M_JACK_2 = 430
    TRAINER_SCHOOL_KID_M_JACK_3 = 431
    TRAINER_SCHOOL_KID_M_ALAN_2 = 432
    TRAINER_SCHOOL_KID_M_ALAN_3 = 433
    TRAINER_SCHOOL_KID_M_CHAD_2 = 434
    TRAINER_SCHOOL_KID_M_CHAD_3 = 435
    TRAINER_POKEFAN_BEVERLY_2 = 436
    TRAINER_POKEFAN_BEVERLY_3 = 437
    TRAINER_POKEFAN_M_DEREK_2 = 438
    TRAINER_POKEFAN_M_DEREK_3 = 439
    TRAINER_SAILOR_HUEY_2 = 440
    TRAINER_SAILOR_HUEY_3 = 441
    TRAINER_LASS_MICKEY = 442
    TRAINER_LASS_MICKEY_2 = 443
    TRAINER_ACE_TRAINER_F_REENA_2 = 444
    TRAINER_ACE_TRAINER_F_REENA_3 = 445
    TRAINER_BIRD_KEEPER_GS_JOSE_3 = 446
    TRAINER_BIRD_KEEPER_GS_VANCE_2 = 447
    TRAINER_BIRD_KEEPER_GS_VANCE_3 = 448
    TRAINER_BUG_CATCHER_ARNIE_3 = 449
    TRAINER_FISHERMAN_WILTON_3 = 450
    TRAINER_HIKER_PARRY_2 = 451
    TRAINER_HIKER_PARRY_3 = 452
    TRAINER_PICNICKER_ERIN_3 = 453
    TRAINER_JUGGLER_IRWIN_2 = 454
    TRAINER_JUGGLER_IRWIN_3 = 455
    TRAINER_ACE_TRAINER_M_GAVEN_2 = 456
    TRAINER_ACE_TRAINER_M_GAVEN_3 = 457
    TRAINER_ACE_TRAINER_F_JAMIE_2 = 458
    TRAINER_ACE_TRAINER_F_JAMIE_3 = 459
    TRAINER_BUG_CATCHER_WADE_2 = 460
    TRAINER_BUG_CATCHER_WADE_3 = 461
    TRAINER_FISHERMAN_RALPH_2 = 462
    TRAINER_FISHERMAN_RALPH_3 = 463
    TRAINER_LASS_DANA_2 = 464
    TRAINER_LASS_DANA_3 = 465
    TRAINER_PICNICKER_TIFFANY_2 = 466
    TRAINER_PICNICKER_TIFFANY_3 = 467
    TRAINER_SCIENTIST_GS_ROSS = 468
    TRAINER_SCIENTIST_GS_MITCH = 469
    TRAINER_SCIENTIST_GS_GREGG = 470
    TRAINER_SCIENTIST_GS_GARETT = 471
    TRAINER_SCIENTIST_GS_TRENTON = 472
    TRAINER_SUPER_NERD_MICKEY_2 = 473
    TRAINER_SUPER_NERD_MICKEY_3 = 474
    TRAINER_SUPER_NERD_MICKEY_4 = 475
    TRAINER_SUPER_NERD_MICKEY_5 = 476
    TRAINER_SUPER_NERD_MICKEY_6 = 477
    TRAINER_EXECUTIVE_ARIANA_ARIANA = 478
    TRAINER_EXECUTIVE_ARIANA_ARIANA_2 = 479
    TRAINER_SKIER_DIANA = 480
    TRAINER_SKIER_JILL = 481
    TRAINER_BOARDER_DEANDRE = 482
    TRAINER_BOARDER_PATTON = 483
    TRAINER_BOARDER_GERARDO = 484
    TRAINER_EXECUTIVE_ARCHER_ARCHER = 485
    TRAINER_EXECUTIVE_PROTON_PROTON = 486
    TRAINER_EXECUTIVE_PETREL_PETREL = 487
    TRAINER_EXECUTIVE_PETREL_PETREL_2 = 488
    TRAINER_RIVAL_SILVER_19 = 489
    TRAINER_RIVAL_SILVER_20 = 490
    TRAINER_RIVAL_SILVER_21 = 491
    TRAINER_POKEFAN_M_ALEX = 492
    TRAINER_MEDIUM_EDITH = 493
    TRAINER_MEDIUM_GEORGINA = 494
    TRAINER_PASSERBY_BOY = 495
    TRAINER_PASSERBY_BOY_2 = 496
    TRAINER_PASSERBY_BOY_3 = 497
    TRAINER_MYSTERY_MAN_EUSINE = 498
    TRAINER_TEAM_ROCKET_GRUNT_25 = 499
    TRAINER_ACE_TRAINER_M_KOBE = 500
    TRAINER_ACE_TRAINER_F_PIPER = 501
    TRAINER_TWINS_CLEA_AND_GIL = 502
    TRAINER_SCHOOL_KID_M_JACK_4 = 503
    TRAINER_SCHOOL_KID_M_MICKEY = 504
    TRAINER_SCHOOL_KID_M_ALAN_4 = 505
    TRAINER_SCHOOL_KID_M_MICKEY_2 = 506
    TRAINER_SCHOOL_KID_M_CHAD_4 = 507
    TRAINER_SCHOOL_KID_M_MICKEY_3 = 508
    TRAINER_SAILOR_HUEY_4 = 509
    TRAINER_YOUNGSTER_JOEY_4 = 510
    TRAINER_YOUNGSTER_MICKEY = 511
    TRAINER_BUG_CATCHER_WADE_4 = 512
    TRAINER_BUG_CATCHER_ARNIE_4 = 513
    TRAINER_BUG_CATCHER_MICKEY = 514
    TRAINER_FISHERMAN_RALPH_4 = 515
    TRAINER_FISHERMAN_MICKEY = 516
    TRAINER_FISHERMAN_TULLY_4 = 517
    TRAINER_PICNICKER_LIZ_4 = 518
    TRAINER_PICNICKER_MICKEY = 519
    TRAINER_PICNICKER_GINA_4 = 520
    TRAINER_PICNICKER_MICKEY_2 = 521
    TRAINER_PICNICKER_TIFFANY_4 = 522
    TRAINER_HIKER_ANTHONY_4 = 523
    TRAINER_HIKER_MICKEY = 524
    TRAINER_CAMPER_TODD_4 = 525
    TRAINER_CAMPER_MICKEY_7 = 526
    TRAINER_JUGGLER_IRWIN_4 = 527
    TRAINER_LASS_DANA_4 = 528
    TRAINER_LASS_MICKEY_3 = 529
    TRAINER_POKE_MANIAC_BRENT_4 = 530
    TRAINER_TWINS_MICKEY = 531
    TRAINER_BUG_CATCHER_MICKEY_2 = 532
    TRAINER_BUG_CATCHER_WAYNE = 533
    TRAINER_BEAUTY_KIMBERLY = 534
    TRAINER_POKEFAN_MARIGOLD = 535
    TRAINER_CAMPER_BERTRAND = 536
    TRAINER_POKE_MANIAC_HARRISON = 537
    TRAINER_SUPER_NERD_HUGH = 538
    TRAINER_SUPER_NERD_MARKUS = 539
    TRAINER_POKEFAN_M_REX = 540
    TRAINER_POKEFAN_M_ANDY = 541
    TRAINER_SAGE_MICKEY_3 = 542
    TRAINER_SAGE_MICKEY_4 = 543
    TRAINER_SAGE_MICKEY_5 = 544
    TRAINER_ACE_TRAINER_M_FRENCH = 545
    TRAINER_SCHOOL_KID_M_SHERMAN = 546
    TRAINER_HIKER_BRUCE = 547
    TRAINER_BLACK_BELT_MANFORD = 548
    TRAINER_DOUBLE_TEAM_ZAC_AND_JEN = 549
    TRAINER_BLACK_BELT_ANDER = 550
    TRAINER_HIKER_DWIGHT = 551
    TRAINER_YOUNGSTER_REGIS = 552
    TRAINER_YOUNG_COUPLE_MOE_AND_LULU = 553
    TRAINER_GENTLEMAN_MILTON = 554
    TRAINER_BIRD_KEEPER_GS_JUSTIN = 555
    TRAINER_BIRD_KEEPER_GS_GAIL = 556
    TRAINER_YOUNG_COUPLE_VIC_AND_TARA = 557
    TRAINER_FISHERMAN_KYLER = 558
    TRAINER_YOUNG_COUPLE_TIM_AND_SUE = 559
    TRAINER_CAMPER_CLARK = 560
    TRAINER_CAMPER_TANNER = 561
    TRAINER_PICNICKER_PIPER = 562
    TRAINER_PICNICKER_GINGER = 563
    TRAINER_TEACHER_CLARICE = 564
    TRAINER_BIRD_KEEPER_GS_JOSH = 565
    TRAINER_SCHOOL_KID_M_CONNOR = 566
    TRAINER_SCHOOL_KID_M_TORIN = 567
    TRAINER_SCHOOL_KID_M_TRAVIS = 568
    TRAINER_TWINS_KAY_AND_TIA = 569
    TRAINER_POKEFAN_M_BOONE = 570
    TRAINER_POKEFAN_ELEANOR = 571
    TRAINER_BIKER_DALE = 572
    TRAINER_BIKER_JACOB = 573
    TRAINER_BIKER_AIDEN = 574
    TRAINER_BIKER_DAN = 575
    TRAINER_BIKER_THERON = 576
    TRAINER_BIKER_MARKEY = 577
    TRAINER_BIKER_TEDDY = 578
    TRAINER_BIKER_ERNEST = 579
    TRAINER_CAMPER_PEDRO = 580
    TRAINER_PICNICKER_ADRIAN = 581
    TRAINER_PICNICKER_CHEYENNE = 582
    TRAINER_BIRD_KEEPER_GS_BERT = 583
    TRAINER_BIRD_KEEPER_GS_ERNIE = 584
    TRAINER_SWIMMER_M_ELMO = 585
    TRAINER_SWIMMER_M_LUIS = 586
    TRAINER_SWIMMER_F_LEONA = 587
    TRAINER_SWIMMER_F_MINA = 588
    TRAINER_FISHERMAN_MURPHY = 589
    TRAINER_FISHERMAN_LIAM = 590
    TRAINER_FISHERMAN_GIDEON = 591
    TRAINER_SWIMMER_F_CHELAN = 592
    TRAINER_SWIMMER_F_KENDRA = 593
    TRAINER_SWIMMER_M_ESTEBAN = 594
    TRAINER_SWIMMER_M_DUANE = 595
    TRAINER_BIRD_KEEPER_GS_KINSLEY = 596
    TRAINER_BIRD_KEEPER_GS_EASTON = 597
    TRAINER_TWINS_DAY_AND_DANI = 598
    TRAINER_CAMPER_VIRGIL = 599
    TRAINER_PICNICKER_SELINA = 600
    TRAINER_TEAM_ROCKET_GRUNT_26 = 601
    TRAINER_BIRD_KEEPER_GS_JOSE_4 = 602
    TRAINER_PICNICKER_ERIN_4 = 603
    TRAINER_ACE_TRAINER_M_GAVEN_4 = 604
    TRAINER_BLACK_BELT_KENJI_4 = 605
    TRAINER_HIKER_PARRY_4 = 606
    TRAINER_ACE_TRAINER_F_REENA_4 = 607
    TRAINER_FISHERMAN_WILTON_4 = 608
    TRAINER_ACE_TRAINER_F_JAMIE_4 = 609
    TRAINER_POKEFAN_M_DEREK_4 = 610
    TRAINER_POKEFAN_BEVERLY_4 = 611
    TRAINER_BIRD_KEEPER_GS_VANCE_4 = 612
    TRAINER_LASS_KRISE_2 = 613
    TRAINER_LASS_KRISE_3 = 614
    TRAINER_LASS_KRISE_4 = 615
    TRAINER_YOUNGSTER_IAN_2 = 616
    TRAINER_YOUNGSTER_IAN_3 = 617
    TRAINER_YOUNGSTER_IAN_4 = 618
    TRAINER_FIREBREATHER_WALT_2 = 619
    TRAINER_FIREBREATHER_WALT_3 = 620
    TRAINER_FIREBREATHER_WALT_4 = 621
    TRAINER_BUG_CATCHER_DOUG_2 = 622
    TRAINER_BUG_CATCHER_DOUG_3 = 623
    TRAINER_BUG_CATCHER_DOUG_4 = 624
    TRAINER_BUG_CATCHER_ROB_2 = 625
    TRAINER_BUG_CATCHER_ROB_3 = 626
    TRAINER_BUG_CATCHER_ROB_4 = 627
    TRAINER_BIKER_REESE_2 = 628
    TRAINER_BIKER_REESE_3 = 629
    TRAINER_BIKER_REESE_4 = 630
    TRAINER_BIKER_AIDEN_2 = 631
    TRAINER_BIKER_AIDEN_3 = 632
    TRAINER_BIKER_AIDEN_4 = 633
    TRAINER_BIKER_ERNEST_2 = 634
    TRAINER_BIKER_ERNEST_3 = 635
    TRAINER_BIKER_ERNEST_4 = 636
    TRAINER_TEACHER_HILLARY_2 = 637
    TRAINER_TEACHER_HILLARY_3 = 638
    TRAINER_TEACHER_HILLARY_4 = 639
    TRAINER_SCHOOL_KID_M_BILLY_2 = 640
    TRAINER_SCHOOL_KID_M_BILLY_3 = 641
    TRAINER_SCHOOL_KID_M_BILLY_4 = 642
    TRAINER_TWINS_KAY_AND_TIA_2 = 643
    TRAINER_TWINS_KAY_AND_TIA_3 = 644
    TRAINER_TWINS_KAY_AND_TIA_4 = 645
    TRAINER_BIRD_KEEPER_GS_JOSH_2 = 646
    TRAINER_BIRD_KEEPER_GS_JOSH_3 = 647
    TRAINER_BIRD_KEEPER_GS_JOSH_4 = 648
    TRAINER_SCHOOL_KID_M_TORIN_2 = 649
    TRAINER_SCHOOL_KID_M_TORIN_3 = 650
    TRAINER_SCHOOL_KID_M_TORIN_4 = 651
    TRAINER_YOUNG_COUPLE_TIM_AND_SUE_2 = 652
    TRAINER_YOUNG_COUPLE_TIM_AND_SUE_3 = 653
    TRAINER_YOUNG_COUPLE_TIM_AND_SUE_4 = 654
    TRAINER_HIKER_KENNY_2 = 655
    TRAINER_HIKER_KENNY_3 = 656
    TRAINER_HIKER_KENNY_4 = 657
    TRAINER_CAMPER_TANNER_2 = 658
    TRAINER_CAMPER_TANNER_3 = 659
    TRAINER_CAMPER_TANNER_4 = 660
    TRAINER_FISHERMAN_KYLE_2 = 661
    TRAINER_FISHERMAN_KYLE_3 = 662
    TRAINER_FISHERMAN_KYLE_4 = 663
    TRAINER_FISHERMAN_KYLER_2 = 664
    TRAINER_FISHERMAN_KYLER_3 = 665
    TRAINER_FISHERMAN_KYLER_4 = 666
    TRAINER_PKMN_TRAINER_CHERYL_CHERYL = 667
    TRAINER_PKMN_TRAINER_BUCK_MARLEY = 668
    TRAINER_PKMN_TRAINER_MARLEY_MIRA = 669
    TRAINER_PKMN_TRAINER_RILEY_RILEY = 670
    TRAINER_PKMN_TRAINER_MIRA_BUCK = 671
    TRAINER_GENTLEMAN_ALFRED_2 = 672
    TRAINER_GENTLEMAN_ALFRED_3 = 673
    TRAINER_GENTLEMAN_ALFRED_4 = 674
    TRAINER_PKMN_TRAINER_LANCE_LANCE = 675
    TRAINER_SAILOR_PARKER = 676
    TRAINER_SAILOR_EDDIE = 677
    TRAINER_SWIMMER_F_JOY = 678
    TRAINER_BEAUTY_CALLIE = 679
    TRAINER_BEAUTY_KASSANDRA = 680
    TRAINER_ACE_TRAINER_M_ARABELLA = 681
    TRAINER_ACE_TRAINER_M_BONITA = 682
    TRAINER_ACE_TRAINER_F_SALMA = 683
    TRAINER_DOUBLE_TEAM_ELAN_AND_IDA = 684
    TRAINER_HIKER_EDWIN = 685
    TRAINER_BOARDER_BRYCE = 686
    TRAINER_BOARDER_SHAUN = 687
    TRAINER_SKIER_CADY = 688
    TRAINER_SUPER_NERD_CARY = 689
    TRAINER_SUPER_NERD_WALDO = 690
    TRAINER_SUPER_NERD_MERLE = 691
    TRAINER_SCIENTIST_GS_LOWELL = 692
    TRAINER_SCIENTIST_GS_LINDEN = 693
    TRAINER_SCIENTIST_GS_DANIEL = 694
    TRAINER_BUG_CATCHER_DANE = 695
    TRAINER_BUG_CATCHER_DION = 696
    TRAINER_BUG_CATCHER_STACEY = 697
    TRAINER_BUG_CATCHER_ELLIS = 698
    TRAINER_BUG_CATCHER_ABNER = 699
    TRAINER_ROCKET_BOSS_GIOVANNI = 700
    TRAINER_CHAMPION_LANCE_2 = 701
    TRAINER_ELITE_FOUR_WILL_WILL_2 = 702
    TRAINER_ELITE_FOUR_KOGA_KOGA_2 = 703
    TRAINER_ELITE_FOUR_BRUNO_BRUNO_2 = 704
    TRAINER_ELITE_FOUR_KAREN_KAREN_2 = 705
    TRAINER_EXECUTIVE_PROTON_PROTON_2 = 706
    TRAINER_TOWER_TYCOON_PALMER = 707
    TRAINER_HALL_MATRON_ARGENTA = 708
    TRAINER_FACTORY_HEAD_THORTON = 709
    TRAINER_ARCADE_STAR_DAHLIA = 710
    TRAINER_CASTLE_VALET_DARACH = 711
    TRAINER_LEADER_FALKNER_FALKNER_2 = 712
    TRAINER_LEADER_BUGSY_BUGSY_2 = 713
    TRAINER_LEADER_WHITNEY_2 = 714
    TRAINER_LEADER_MORTY_MORTY_2 = 715
    TRAINER_LEADER_PRYCE_PRYCE_2 = 716
    TRAINER_LEADER_JASMINE_JASMINE_2 = 717
    TRAINER_LEADER_CHUCK_CHUCK_2 = 718
    TRAINER_LEADER_CLAIR_CLAIR_2 = 719
    TRAINER_LEADER_BROCK_BROCK_2 = 720
    TRAINER_LEADER_MISTY_MISTY_2 = 721
    TRAINER_LEADER_LT_SURGE_LT__SURGE_2 = 722
    TRAINER_LEADER_ERIKA_ERIKA_2 = 723
    TRAINER_LEADER_JANINE_JANINE_2 = 724
    TRAINER_LEADER_SABRINA_SABRINA_2 = 725
    TRAINER_LEADER_BLAINE_BLAINE_2 = 726
    TRAINER_LEADER_BLUE_BLUE_2 = 727
    TRAINER_BEAUTY_CHARLOTTE = 728
    TRAINER_YOUNG_COUPLE_DUFF_AND_EDA = 729
    TRAINER_DOUBLE_TEAM_THOM_AND_KAE = 730
    TRAINER_HIKER_DEVIN = 731
    TRAINER_CAMPER_GRANT = 732
    TRAINER_CHAMPION_LANCE_3 = 733
    TRAINER_LEADER_CLAIR_CLAIR_3 = 734
    TRAINER_PARTNER_RIVAL_1 = 735
    TRAINER_PARTNER_RIVAL_2 = 736
    TRAINER_PARTNER_RIVAL_3 = 737

WEATHER_SUNNY = 0
    WEATHER_RAIN = 1
    WEATHER_HEAVY_RAIN = 2
    WEATHER_THUNDERSTORM = 3
    WEATHER_UNKNOWN_4 = 4
    WEATHER_SNOW = 5
    WEATHER_BLIZZARD = 6
    WEATHER_SANDSTORM = 7
    WEATHER_DIAMOND_DUST = 8
    WEATHER_UNKNOWN_9 = 9
    WEATHER_UNKNOWN_10 = 10
    WEATHER_FLASH = 11
    WEATHER_FLASH_2 = 12
    WEATHER_LOW_LIGHT = 13


GROUP_FLAG_INCENSE = [
    FLAG_HIDE_ITEMBALL_D38R0102_FULL_INCENSE,
    FLAG_HIDE_ITEMBALL_D41R0102_PURE_INCENSE,
    FLAG_HIDE_ITEMBALL_D03R0101_SEA_INCENSE,
    FLAG_HIDE_ITEMBALL_D03R0102_ODD_INCENSE,
    FLAG_HIDE_ITEMBALL_R38_LAX_INCENSE,
    FLAG_HIDE_ITEMBALL_R47_WAVE_INCENSE,
    FLAG_HIDE_ITEMBALL_T06_LUCK_INCENSE,
    FLAG_HIDE_ITEMBALL_D01R0101_ROCK_INCENSE,
    FLAG_HIDE_ITEMBALL_R15_ROSE_INCENSE
]

GROUP_FLAG_FLUTE = [
    FLAG_HIDE_ITEMBALL_R12_YELLOW_FLUTE,
    FLAG_HIDE_ITEMBALL_D46R0101_BLUE_FLUTE,
    FLAG_HIDE_ITEMBALL_R47_WHITE_FLUTE,
    FLAG_HIDE_ITEMBALL_T29_RED_FLUTE,
    FLAG_HIDE_ITEMBALL_D42R0102_BLACK_FLUTE
]

MAP_TRAINERS = {
    MAP_EVERYWHERE: [ // Mystery Zone / EVERYWHERE [ev0]
    ],
    
    MAP_UNION: [ // Mystery Zone / UNION [ev1]
    ],
    
    MAP_WIFI_SINGLE_BATTLE_AREA: [ // Mystery Zone / DIRECT2 [ev2]
    ],
    
    MAP_WIFI_MULTI_BATTLE_AREA: [ // Mystery Zone / DIRECT4 [ev3]
    ],
    
    MAP_BELLCHIME_TOWER: [ // Bellchime Trail / D17R1101 [ev4]
    ],
    
    MAP_BURNED_TOWER_1F: [ // Burned Tower / D18R0101 [ev5]
    281, // Firebreather Richard
    282, // Firebreather Ned
    ],
    
    MAP_ROUTE_1: [ // Route 1 / R01 [ev6]
    362, // Ace Trainer Quinn
    545, // Ace Trainer French
    327, // School Kid Danny
    546, // School Kid Sherman
    ],
    
    MAP_ROUTE_2: [ // Route 2 / R02 [ev7]
    48, // Bug Catcher Rob
    140, // Bug Catcher Doug
    ],
    
    MAP_ROUTE_3: [ // Route 3 / R03 [ev8]
    378, // Youngster Warren
    15, // Firebreather Otis
    379, // Youngster Jimmy
    549, // Double Team Zac & Jen
    //549, // Double Team Zac & Jen
    318, // Firebreather Burt
    547, // Hiker Bruce
    548, // Black Belt Manford
    550, // Black Belt Ander
    551, // Hiker Dwight
    552, // Youngster Regis
    ],
    
    MAP_ROUTE_4: [ // Route 4 / R04 [ev9]
    152, // Picknicker Hope
    153, // Picknicker Sharon
    299, // Bird Keeper Hank
    ],
    
    MAP_ROUTE_5: [ // Route 5 / R05 [ev10]
    ],
    
    MAP_ROUTE_6: [ // Route 6 / R06 [ev11]
    599, // Camper Virgil
    600, // Picknicker Selina
    598, // Twins Day & Dani
    //598, // Twins Day & Dani - double battle dupe
    ],
    
    MAP_ROUTE_7: [ // Route 7 / R07 [ev12]
    ],
    
    MAP_ROUTE_8: [ // Route 8 / R08 [ev13]
    309, // Biker Dwayne
    310, // Biker Harris
    311, // Biker Zeke
    364, // Super Nerd Sam
    365, // Super Nerd Tyrone
    553, // Young Couple Moe & Lulu
    //553, // Young Couple Moe & Lulu
    554, // Gentleman Milton
    ],
    
    MAP_ROUTE_9: [ // Route 9 / R09 [ev14]
    150, // Camper Sid
    333, // Picknicker Edna
    149, // Camper Dean
    357, // Hiker Clarke
    234, // Hiker Eoin
    332, // Picknicker Heidi
    ],
    
    MAP_ROUTE_10: [ // Route 10 / R10 [ev15]
    ],
    
    MAP_ROUTE_11: [ // Route 11 / R11 [ev16]
    317, // Psychic Fidel
    316, // Psychic Herman
    380, // Youngster Owen
    381, // Youngster Jason
    ],
    
    MAP_ROUTE_12: [ // Route 12 / R12 [ev17]
    59, // Fisherman Kyle
    320, // Fisherman Martin
    555, // Bird Keeper Justin
    557, // Young Couple Vic & Tara
    //557, // Young Couple Vic & Tara
    321, // Fisherman Stephen
    322, // Fisherman Barney
    556, // Bird Keeper Gail
    558, // Fisherman Kyler
    ],
    
    MAP_ROUTE_13: [ // Route 13 / R13 [ev18]
    358, // Hiker Kenny
    559, // Young Couple Tim & Sue
    //559, // Young Couple Tim & Sue
    349, // PokÃ©fan Joshua
    492, // PokÃ©fan Alex
    560, // Camper Clark
    561, // Camper Tanner
    562, // Picknicker Piper
    563, // Picknicker Ginger
    421, // Bird Keeper Bret
    420, // Bird Keeper Perry
    ],
    
    MAP_ROUTE_14: [ // Route 14 / R14 [ev19]
    351, // PokÃ©fan Trevor
    564, // Teacher Clarice
    300, // Bird Keeper Roy
    350, // PokÃ©fan Carter
    565, // Bird Keeper Josh
    567, // School Kid Torin
    566, // School Kid Connor
    568, // School Kid Travis
    //6, // Policeman Keith - npc with junk trainer data?
    ],
    
    MAP_ROUTE_15: [ // Route 15 / R15 [ev20]
    179, // School Kid Kipp
    328, // School Kid Tommy
    382, // Teacher Hillary
    569, // Twins Kay & Tia
    //569, // Twins Kay & Tia - double battle dupe
    571, // PokÃ©fan Eleanor
    570, // PokÃ©fan Boone
    38, // Teacher Colette
    135, // School Kid Johnny
    331, // School Kid Billy
    ],
    
    MAP_ROUTE_16: [ // Route 16 / R16 [ev21]
    ],
    
    MAP_ROUTE_17: [ // Route 17 / R17 [ev22]
    313, // Biker Reese
    314, // Biker Joel
    315, // Biker Glenn - MANUALLY ADDED
    577, // Biker Markey
    572, // Biker Dale
    573, // Biker Jacob
    574, // Biker Aiden
    575, // Biker Dan
    576, // Biker Theron
    578, // Biker Teddy
    579, // Biker Ernest
    ],
    
    MAP_ROUTE_18: [ // Route 18 / R18 [ev23]
    302, // Bird Keeper Bob
    301, // Bird Keeper Boris
    312, // Biker Charles
    ],
    
    MAP_ROUTE_22: [ // Route 22 / R22 [ev24]
    ],
    
    MAP_ROUTE_24: [ // Route 24 / R24 [ev25]
    ],
    
    MAP_ROUTE_25: [ // Route 25 / R25 [ev26]
    329, // School Kid Dudley
    419, // Lass Ellen
    330, // School Kid Joe
    354, // Lass Laura
    355, // Lass Shannon
    148, // Camper Lloyd
    366, // Super Nerd Pat
    ],
    
    MAP_ROUTE_26: [ // Route 26 / R26 [ev27]
    413, // Fisherman Scott
    411, // Psychic Vernon
    36, // Ace Trainer Joyce
    102, // Ace Trainer Gaven
    28, // Ace Trainer Jake
    113, // Ace Trainer Jamie
    ],
    
    MAP_ROUTE_27: [ // Route 27 / R27 [ev28]
    115, // Ace Trainer Megan
    103, // Ace Trainer Blake
    414, // Bird Keeper Jose
    104, // Ace Trainer Brian
    412, // Psychic Eli
    114, // Ace Trainer Reena
    ],
    
    MAP_ROUTE_28: [ // Route 28 / R28 [ev29]
    ],
    
    MAP_ROUTE_29: [ // Route 29 / R29 [ev30]
    ],
    
    MAP_ROUTE_30: [ // Route 30 / R30 [ev31]
    249, // Bug Catcher Don
    8, // Youngster Joey
    47, // Youngster Mikey
    ],
    
    MAP_ROUTE_31: [ // Route 31 / R31 [ev32]
    4, // Bug Catcher Wade
    ],
    
    MAP_ROUTE_32: [ // Route 32 / R32 [ev33]
    49, // Youngster Albert
    27, // Picknicker Liz
    60, // Fisherman Henry
    18, // Fisherman Justin
    57, // Fisherman Ralph
    26, // Camper Roland
    56, // Youngster Gordon
    383, // Bird Keeper Peter
    ],
    
    MAP_ROUTE_33: [ // Route 33 / R33 [ev34]
    61, // Hiker Anthony
    ],
    
    MAP_ROUTE_34: [ // Route 34 / R34 [ev35]
    62, // Youngster Samuel
    65, // Picknicker Gina
    64, // Youngster Ian
    6, // Policeman Keith
    66, // Camper Todd
    409, // PokÃ©fan Brandon
    ],
    
    MAP_ROUTE_35: [ // Route 35 / R35 [ev36]
    80, // Policeman Dirk
    77, // Picknicker Kim
    75, // Camper Elliot
    76, // Picknicker Brooke
    74, // Camper Ivan
    7, // Juggler Irwin
    78, // Bug Catcher Arnie
    72, // Bird Keeper Bryan
    388, // Firebreather Walt
    ],
    
    MAP_ROUTE_36: [ // Route 36 / R36 [ev37]
    395, // Psychic Mark
    24, // School Kid Alan
    ],
    
    MAP_ROUTE_37: [ // Route 37 / R37 [ev38]
    81, // Twins Tori & Til
    //81, // Twins Tori & Til - double battle dupe
    386, // Psychic Greg
    679, // Beauty Callie
    680, // Beauty Kassandra
    ],
    
    MAP_ROUTE_38: [ // Route 38 / R38 [ev39]
    397, // School Kid Chad
    82, // Bird Keeper Toby
    400, // Lass Dana
    398, // Beauty Valerie
    410, // Sailor Harry
    ],
    
    MAP_ROUTE_39: [ // Route 39 / R39 [ev40]
    39, // Sailor Eugene
    44, // PokÃ©fan Derek
    45, // PokÃ©fan Ruth
    389, // Psychic Nelson
    ],
    
    MAP_ROUTE_42: [ // Route 42 / R42 [ev41]
    123, // Fisherman Tully
    129, // PokÃ© Maniac Shane
    134, // Hiker Benjamin
    ],
    
    MAP_ROUTE_43: [ // Route 43 / R43 [ev42]
    403, // Camper Spencer
    402, // Picknicker Tiffany
    131, // PokÃ© Maniac Brent
    130, // PokÃ© Maniac Beckett
    132, // PokÃ© Maniac Ron
    122, // Fisherman Marvin
    ],
    
    MAP_ROUTE_44: [ // Route 44 / R44 [ev43]
    405, // Psychic Phil
    125, // Fisherman Edgar
    124, // Fisherman Wilton
    408, // Ace Trainer Cybil
    407, // Ace Trainer Allen
    406, // PokÃ© Maniac Zach
    137, // Bird Keeper Vance
    ],
    
    MAP_ROUTE_45: [ // Route 45 / R45 [ev44]
    143, // Hiker Erik
    108, // Ace Trainer Ryan
    145, // Hiker Parry
    121, // Ace Trainer Kelly
    17, // Black Belt Kenji
    146, // Hiker Timothy
    144, // Hiker Michael
    ],
    
    MAP_ROUTE_46: [ // Route 46 / R46 [ev45]
    154, // Hiker Bailey
    147, // Camper Ted
    151, // Picknicker Erin
    ],
    
    MAP_PALLET: [ // Pallet Town / T01 [ev46]
    ],
    
    MAP_VIRIDIAN: [ // Viridian City / T02 [ev47]
    ],
    
    MAP_PEWTER: [ // Pewter City / T03 [ev48]
    ],
    
    MAP_CERULEAN: [ // Cerulean City / T04 [ev49]
    ],
    
    MAP_LAVENDER: [ // Lavender Town / T05 [ev50]
    ],
    
    MAP_VERMILION: [ // Vermilion City / T06 [ev51]
    ],
    
    MAP_CELADON: [ // Celadon City / T07 [ev52]
    ],
    
    MAP_FUCHSIA: [ // Fuchsia City / T08 [ev53]
    ],
    
    MAP_CINNABAR_ISLAND: [ // Cinnabar Island / T09 [ev54]
    ],
    
    MAP_INDIGO_PLATEAU: [ // Indigo Plateau / T10 [ev55]
    ],
    
    MAP_SAFFRON: [ // Saffron City / T11 [ev56]
    ],
    
    MAP_NEW_BARK: [ // New Bark Town / T20 [ev57]
    ],
    
    MAP_NEW_BARK_ELMS_LAB_1F: [ // New Bark Town / T20R0101 [ev58]
    ],
    
    MAP_NEW_BARK_ELMS_LAB_2F: [ // New Bark Town / T20R0102 [ev59]
    ],
    
    MAP_NEW_BARK_PLAYER_HOUSE_1F: [ // New Bark Town / T20R0201 [ev60]
    ],
    
    MAP_NEW_BARK_PLAYER_HOUSE_2F: [ // New Bark Town / T20R0202 [ev61]
    ],
    
    MAP_NEW_BARK_SOUTHWEST_HOUSE: [ // New Bark Town / T20R0301 [ev62]
    ],
    
    MAP_NEW_BARK_RIVAL_HOUSE_1F: [ // New Bark Town / T20R0401 [ev63]
    ],
    
    MAP_CHERRYGROVE: [ // Cherrygrove City / T21 [ev64]
    ],
    
    MAP_CHERRYGROVE_POKEMART: [ // Cherrygrove City / T21FS0101 [ev65]
    ],
    
    MAP_CHERRYGROVE_POKECENTER_1F: [ // Cherrygrove City / T21PC0101 [ev66]
    ],
    
    MAP_CHERRYGROVE_SOUTHWEST_HOUSE: [ // Cherrygrove City / T21R0301 [ev67]
    ],
    
    MAP_CHERRYGROVE_GUIDE_GENT_HOUSE: [ // Cherrygrove City / T21R0401 [ev68]
    ],
    
    MAP_CHERRYGROVE_SOUTHEAST_HOUSE: [ // Cherrygrove City / T21R0501 [ev69]
    ],
    
    MAP_VIOLET: [ // Violet City / T22 [ev70]
    ],
    
    MAP_AZALEA: [ // Azalea Town / T23 [ev71]
    ],
    
    MAP_CIANWOOD: [ // Cianwood City / T24 [ev72]
    ],
    
    MAP_GOLDENROD: [ // Goldenrod City / T25 [ev73]
    ],
    
    MAP_OLIVINE: [ // Olivine City / T26 [ev74]
    ],
    
    MAP_ECRUTEAK: [ // Ecruteak City / T27 [ev75]
    ],
    
    MAP_ECRUTEAK_POKEMART: [ // Ecruteak City / T27FS0101 [ev76]
    ],
    
    MAP_ECRUTEAK_GYM: [ // Ecruteak City / T27GYM0101 [ev77]
    //3, // Rival Silver - NPC with junk trainer data?
    //494, // Medium Georgina
    //89, // Medium Grace
    //493, // Medium Edith
    //46, // Medium Martha
    ],
    
    MAP_ECRUTEAK_POKECENTER_1F: [ // Ecruteak City / T27PC0101 [ev78]
    ],
    
    MAP_ECRUTEAK_UNUSED_HOUSE: [ // Jubilife City / T27R0101 [ev79]
    ],
    
    MAP_ECRUTEAK_BELL_TOWER_BARRIER_STATION: [ // Ecruteak City / T27R0201 [ev80]
    ],
    
    MAP_ECRUTEAK_DOWSING_MACHINE_HOUSE: [ // Ecruteak City / T27R0801 [ev81]
    ],
    
    MAP_ECRUTEAK_SOUTHWEST_HOUSE: [ // Ecruteak City / T27R0401 [ev82]
    ],
    
    MAP_ECRUTEAK_DANCE_THEATER: [ // Ecruteak City / T27R0501 [ev83]
    ],
    
    MAP_MAHOGANY: [ // Mahogany Town / T28 [ev84]
    ],
    
    MAP_LAKE_OF_RAGE: [ // Lake of Rage / T29 [ev85]
    126, // Fisherman Andre
    127, // Fisherman Raymond
    109, // Ace Trainer Alton
    116, // Ace Trainer Lois
    ],
    
    MAP_BLACKTHORN: [ // Blackthorn City / T30 [ev86]
    ],
    
    MAP_MOUNT_SILVER: [ // Mt. Silver / T31 [ev87]
    ],
    
    MAP_ROUTE_19: [ // Route 19 / W19 [ev88]
    370, // Swimmer Jerome
    252, // Swimmer Harold
    371, // Swimmer Tucker
    291, // Swimmer Debbie
    ],
    
    MAP_ROUTE_20: [ // Route 20 / W20 [ev89]
    373, // Swimmer Frankie
    580, // Camper Pedro
    581, // Picknicker Adrian
    582, // Picknicker Cheyenne
    583, // Bird Keeper Bert
    584, // Bird Keeper Ernie
    293, // Swimmer Nicole
    294, // Swimmer Lori - MANUALLY ADDED
    585, // Swimmer Elmo
    586, // Swimmer Luis
    587, // Swimmer Leona
    588, // Swimmer Mina
    ],
    
    MAP_ROUTE_21: [ // Route 21 / W21 [ev90]
    58, // Fisherman Arnold
    589, // Fisherman Murphy
    590, // Fisherman Liam
    591, // Fisherman Gideon
    296, // Swimmer Nikki
    592, // Swimmer Chelan
    593, // Swimmer Kendra
    594, // Swimmer Esteban
    595, // Swimmer Duane
    597, // Bird Keeper Easton
    596, // Bird Keeper Kinsley
    374, // Swimmer Tyson - MANUALLY ADDED
    ],
    
    MAP_ROUTE_40: [ // Route 40 / W40 [ev91]
    16, // Swimmer Simon
    9, // Swimmer Elaine
    86, // Swimmer Randall
    85, // Swimmer Paula
    ],
    
    MAP_ROUTE_41: [ // Route 41 / W41 [ev92]
    95, // Swimmer Charlie
    96, // Swimmer George
    97, // Swimmer Berke
    99, // Swimmer Matthew
    98, // Swimmer Ronald
    90, // Swimmer Kaylee
    91, // Swimmer Susie
    92, // Swimmer Denise
    93, // Swimmer Kara
    94, // Swimmer Wendy
    ],
    
    MAP_NATIONAL_PARK: [ // National Park / D22R0101 [ev93]
    182, // PokÃ©fan Beverly
    184, // Lass Krise
    181, // PokÃ©fan William
    178, // School Kid Jack
    ],
    
    MAP_ROUTE_31_VIOLET_GATEHOUSE: [ // Route 31 / R31R0101 [ev94]
    ],
    
    MAP_ROUTE_32_RUINS_OF_ALPH_GATEHOUSE: [ // Route 32 / R32R0101 [ev95]
    ],
    
    MAP_UNION_CAVE_1F: [ // Union Cave / D25R0101 [ev96]
    384, // Hiker Daniel
    25, // Hiker Russel
    319, // Firebreather Bill
    390, // Firebreather Ray
    23, // PokÃ© Maniac Larry
    ],
    
    MAP_AZALEA_ILEX_FOREST_GATEHOUSE: [ // Azalea Town / T23R0101 [ev97]
    ],
    
    MAP_ROUTE_35_GOLDENROD_GATEHOUSE: [ // Route 35 / R35R0101 [ev98]
    ],
    
    MAP_ROUTE_35_NATIONAL_PARK_POKEATHALON_GATEHOUSE: [ // Route 35 / R35R0201 [ev99]
    ],
    
    MAP_ROUTE_36_RUINS_OF_ALPH_GATEHOUSE: [ // Route 36 / R36R0101 [ev100]
    ],
    
    MAP_ROUTE_36_NATIONAL_PARK_GATEHOUSE: [ // Route 36 / R36R0201 [ev101]
    ],
    
    MAP_ECRUTEAK_UNUSED_GATEHOUSE: [ // Jubilife City / T27R0601 [ev102]
    ],
    
    MAP_DIGLETT_CAVE: [ // DIGLETT's Cave / D01R0101 [ev103]
    ],
    
    MAP_MOUNT_MOON: [ // Mt. Moon / D02R0101 [ev104]
    ],
    
    MAP_ROCK_TUNNEL_1F: [ // Rock Tunnel / D05R0101 [ev105]
    ],
    
    MAP_PAL_PARK: [ // Pal Park / D10R0101 [ev106]
    ],
    
    MAP_SPROUT_TOWER_1F: [ // Sprout Tower / D15R0101 [ev107]
    43, // Sage Chow
    ],
    
    MAP_BELL_TOWER_1F: [ // Bell Tower / D17R0101 [ev108]
    ],
    
    MAP_GOLDENROD_RADIO_TOWER_1F: [ // Radio Tower / D23R0101 [ev109]
    ],
    
    MAP_RUINS_OF_ALPH: [ // Ruins of Alph / D24R0101 [ev110]
    42, // Psychic Nathan
    ],
    
    MAP_SLOWPOKE_WELL_ENTRANCE: [ // SLOWPOKE Well / D26R0101 [ev111]
    ],
    
    MAP_OLIVINE_LIGHTHOUSE_1F: [ // Lighthouse / D27R0101 [ev112]
    ],
    
    MAP_MAHOGANY_SOUVENIR_SHOP: [ // Mahogany Town / D35R0101 [ev113]
    ],
    
    MAP_ILEX_FOREST: [ // Ilex Forest / D36R0101 [ev114]
    ],
    
    MAP_GOLDENROD_TUNNEL_1F: [ // Goldenrod Tunnel / D37R0101 [ev115]
    ],
    
    MAP_MOUNT_MORTAR_1F_ENTRANCE: [ // Mt. Mortar / D38R0101 [ev116]
    ],
    
    MAP_ICE_PATH_1F: [ // Ice Path / D39R0101 [ev117]
    ],
    
    MAP_WHIRL_ISLANDS_1F: [ // Whirl Islands / D40R0101 [ev118]
    ],
    
    MAP_MOUNT_SILVER_CAVE_1F: [ // Mt. Silver Cave / D41R0101 [ev119]
    ],
    
    MAP_DARK_CAVE_ROUTE_45_SIDE: [ // Dark Cave / D42R0101 [ev120]
    ],
    
    MAP_VICTORY_ROAD_1F: [ // Victory Road / D43R0101 [ev121]
    ],
    
    MAP_DRAGONS_DEN_ENTRANCE: [ // Dragon's Den / D44R0101 [ev122]
    ],
    
    MAP_TOHJO_FALLS: [ // Tohjo Falls / D45R0101 [ev123]
    ],
    
    MAP_ROUTE_30_APRICORN_HOUSE: [ // Route 30 / R30R0101 [ev124]
    ],
    
    MAP_ECRUTEAK_POKECENTER_UNUSED_1: [ // Ecruteak City / T27PC0102 [ev125]
    ],
    
    MAP_ECRUTEAK_POKECENTER_UNUSED_2: [ // Ecruteak City / T27PC0103 [ev126]
    ],
    
    MAP_ECRUTEAK_POKECENTER_B1F: [ // Ecruteak City / T27PC0105 [ev127]
    ],
    
    MAP_ROUTE_42_ECRUTEAK_GATEHOUSE: [ // Route 42 / R42R0101 [ev128]
    ],
    
    MAP_MAHOGANY_EAST_HOUSE: [ // Mahogany Town / T28R0201 [ev129]
    ],
    
    MAP_ROUTE_29_ROUTE_46_GATEHOUSE: [ // Route 29 / R29R0101 [ev130]
    ],
    
    MAP_VIOLET_GYM: [ // Violet City / T22GYM0101 [ev131]
    //50, // Bird Keeper Abe
    //29, // Bird Keeper Rod
    ],
    
    MAP_AZALEA_GYM_ENTRANCE: [ // Azalea Town / T23GYM0101 [ev132]
    ],
    
    MAP_GOLDENROD_GYM: [ // Goldenrod City / T25GYM0101 [ev133]
    //71, // Lass Cathy
    //22, // Lass Carrie
    //5, // Beauty Victoria
    //70, // Beauty Samantha
    ],
    
    MAP_OLIVINE_GYM: [ // Olivine City / T26GYM0101 [ev134]
    ],
    
    MAP_CIANWOOD_GYM: [ // Cianwood City / T24GYM0101 [ev135]
    //156, // Black Belt Yoshi
    //157, // Black Belt Lao
    //251, // Black Belt Nob
    //159, // Black Belt Lung
    ],
    
    MAP_MAHOGANY_GYM_LEADER_ROOM: [ // Mahogany Town / T28GYM0101 [ev136]
    //482, // Boarder Deandre
    //484, // Boarder Gerardo
    //481, // Skier Jill
    ],
    
    MAP_BLACKTHORN_GYM: [ // Blackthorn City / T30GYM0101 [ev137]
    //110, // Ace Trainer Paulo
    //117, // Ace Trainer Lola
    //112, // Ace Trainer Cody
    //119, // Ace Trainer Fran
    //111, // Ace Trainer Mike
    ],
    
    MAP_ROUTE_43_MAHOGANY_GATEHOUSE: [ // Route 43 / R43R0101 [ev138]
    ],
    
    MAP_ROUTE_30_MR_POKEMON_HOUSE: [ // Route 30 / R30R0201 [ev139]
    ],
    
    MAP_CHERRYGROVE_POKECENTER_B1F: [ // Cherrygrove City / T21PC0102 [ev140]
    ],
    
    MAP_CERULEAN_CAVE_1F: [ // Cerulean Cave / D03R0101 [ev141]
    ],
    
    MAP_SEAFOAM_ISLANDS_1F: [ // Seafoam Islands / D11R0101 [ev142]
    ],
    
    MAP_VIRIDIAN_FOREST: [ // Viridian Forest / D46R0101 [ev143]
    695, // Bug Catcher Dane
    696, // Bug Catcher Dion
    697, // Bug Catcher Stacey
    698, // Bug Catcher Ellis
    699, // Bug Catcher Abner
    ],
    
    MAP_VIOLET_ROUTE_36_GATEHOUSE: [ // Route 36 / T22R0701 [ev144]
    ],
    
    MAP_NATIONAL_PARK_UNUSED_GATEHOUSE: [ // Pokeathlon Dome / D22R0201 [ev145]
    ],
    
    MAP_ROUTE_47: [ // Route 47 / R47 [ev146]
    730, // Double Team Thom & Kae
    //730, // Double Team Thom & Kae
    732, // Camper Grant
    729, // Young Couple Duff & Eda
    //729, // Young Couple Duff & Eda
    731, // Hiker Devin
    ],
    
    MAP_ROUTE_48: [ // Route 48 / R48 [ev147]
    ],
    
    MAP_UNION_CAVE_B1F: [ // Union Cave / D25R0102 [ev148]
    203, // Hiker Phillip
    204, // Hiker Leonard
    201, // PokÃ© Maniac Andrew
    202, // PokÃ© Maniac Calvin
    ],
    
    MAP_UNION_CAVE_B2F: [ // Union Cave / D25R0103 [ev149]
    205, // Ace Trainer Nick
    206, // Ace Trainer Gwen
    363, // Ace Trainer Emma
    ],
    
    MAP_SPROUT_TOWER_2F: [ // Sprout Tower / D15R0102 [ev150]
    51, // Sage Nico
    52, // Sage Edmond
    ],
    
    MAP_SPROUT_TOWER_3F: [ // Sprout Tower / D15R0103 [ev151]
    53, // Sage Jin
    55, // Sage Neal
    54, // Sage Troy
    ],
    
    MAP_VIOLET_POKEMART: [ // Violet City / T22FS0101 [ev152]
    ],
    
    MAP_VIOLET_POKECENTER_1F: [ // Violet City / T22PC0101 [ev153]
    ],
    
    MAP_VIOLET_POKEMON_SCHOOL: [ // Violet City / T22R0301 [ev154]
    ],
    
    MAP_VIOLET_NORTHWEST_HOUSE: [ // Violet City / T22R0401 [ev155]
    ],
    
    MAP_VIOLET_BELLSPROUT_ONYX_TRADE_HOUSE: [ // Violet City / T22R0601 [ev156]
    ],
    
    MAP_AZALEA_CHARCOAL_KILN: [ // Azalea Town / T23R0201 [ev157]
    ],
    
    MAP_AZALEA_KURT_HOUSE: [ // Azalea Town / T23R0501 [ev158]
    ],
    
    MAP_AZALEA_POKEMART: [ // Azalea Town / T23FS0101 [ev159]
    ],
    
    MAP_AZALEA_POKECENTER_1F: [ // Azalea Town / T23PC0101 [ev160]
    ],
    
    MAP_VIOLET_POKECENTER_B1F: [ // Violet City / T22PC0102 [ev161]
    ],
    
    MAP_AZALEA_POKECENTER_B1F: [ // Azalea Town / T23PC0102 [ev162]
    ],
    
    MAP_ROUTE_32_POKECENTER_1F: [ // Route 32 / R32PC0101 [ev163]
    ],
    
    MAP_ROUTE_32_POKECENTER_B1F: [ // Route 32 / R32PC0102 [ev164]
    ],
    
    MAP_ROUTE_34_ILEX_FOREST_GATEHOUSE: [ // Route 34 / R34R0201 [ev165]
    ],
    
    MAP_ROUTE_38_ECRUTEAK_GATEHOUSE: [ // Route 38 / R38R0101 [ev166]
    ],
    
    MAP_SAFARI_ZONE_ENTRANCE_INTERIOR: [ // Safari Zone Gate / D47R0101 [ev167]
    ],
    
    MAP_SAFARI_ZONE_GATE: [ // Safari Zone Gate / D47 [ev168]
    ],
    
    MAP_DARK_CAVE_ROUTE_31_SIDE: [ // Dark Cave / D42R0102 [ev169]
    ],
    
    MAP_SLOWPOKE_WELL_B1F: [ // SLOWPOKE Well / D26R0102 [ev170]
    //101, // Team Rocket Grunt
    //12, // Team Rocket Grunt
    //13, // Team Rocket Grunt
    ],
    
    MAP_VICTORY_ROAD_2F: [ // Victory Road / D43R0102 [ev171]
    ],
    
    MAP_VICTORY_ROAD_3F: [ // Victory Road / D43R0103 [ev172]
    ],
    
    MAP_AZALEA_GYM: [ // Azalea Town / T23GYM0102 [ev173]
    //68, // Bug Catcher Al
    //67, // Bug Catcher Benny
    //10, // Twins Amy & Mimi
    //10, // Twins Amy & Mimi - double battle dupe
    //69, // Bug Catcher Josh
    ],
    
    MAP_SLOWPOKE_WELL_B2F: [ // SLOWPOKE Well / D26R0103 [ev174]
    ],
    
    MAP_GOLDENROD_BIKE_SHOP: [ // Goldenrod City / T25R0201 [ev175]
    ],
    
    MAP_GOLDENROD_GAME_CORNER_JP: [ // Goldenrod City / T25R1101 [ev176]
    ],
    
    MAP_GOLDENROD_FLOWER_SHOP: [ // Goldenrod City / T25R0601 [ev177]
    ],
    
    MAP_GOLDENROD_POKECENTER_1F: [ // Goldenrod City / T25PC0101 [ev178]
    ],
    
    MAP_GOLDENROD_RADIO_TOWER_2F: [ // Radio Tower / D23R0102 [ev179]
    //187, // Team Rocket Grunt
    //198, // Team Rocket Grunt
    //188, // Team Rocket Grunt
    //186, // Team Rocket Grunt
    ],
    
    MAP_GOLDENROD_RADIO_TOWER_3F: [ // Radio Tower / D23R0103 [ev180]
    //189, // Team Rocket Grunt
    //190, // Team Rocket Grunt
    //471, // Scientist Garett
    //191, // Team Rocket Grunt
    ],
    
    MAP_GOLDENROD_RADIO_TOWER_4F: [ // Radio Tower / D23R0104 [ev181]
    //472, // Scientist Trenton
    //192, // Team Rocket Grunt
    //9, // Swimmer Elaine - NPC junk data?
    //706, // Executive Proton
    ],
    
    MAP_GOLDENROD_RADIO_TOWER_5F: [ // Radio Tower / D23R0105 [ev182]
    //478, // Executive Ariana
    ],
    
    MAP_GOLDENROD_RADIO_TOWER_OBSERVATION_DECK: [ // Radio Tower / D23R0106 [ev183]
    ],
    
    MAP_GOLDENROD_DEPARTMENT_STORE_1F: [ // Goldenrod City / T25R1001 [ev184]
    ],
    
    MAP_GOLDENROD_DEPARTMENT_STORE_2F: [ // Goldenrod City / T25R1002 [ev185]
    ],
    
    MAP_GOLDENROD_DEPARTMENT_STORE_3F: [ // Goldenrod City / T25R1003 [ev186]
    ],
    
    MAP_GOLDENROD_DEPARTMENT_STORE_4F: [ // Goldenrod City / T25R1004 [ev187]
    ],
    
    MAP_GOLDENROD_DEPARTMENT_STORE_5F: [ // Goldenrod City / T25R1005 [ev188]
    ],
    
    MAP_GOLDENROD_DEPARTMENT_STORE_6F: [ // Goldenrod City / T25R1006 [ev189]
    ],
    
    MAP_GOLDENROD_MAGNET_TRAIN_STATION_1F: [ // Goldenrod City / T25R0501 [ev190]
    ],
    
    MAP_GOLDENROD_MAGNET_TRAIN_STATION_2F: [ // Goldenrod City / T25R0502 [ev191]
    ],
    
    MAP_GOLDENROD_TUNNEL_B1F: [ // Goldenrod Tunnel / D37R0102 [ev192]
    392, // PokÃ© Maniac Donald
    393, // Super Nerd Teru
    391, // PokÃ© Maniac Issac
    233, // Super Nerd Eric
    ],
    
    MAP_GOLDENROD_DEPARTMENT_STORE_BASEMENT: [ // Goldenrod City / D37R0103 [ev193]
    ],
    
    MAP_GOLDENROD_TUNNEL_B2F: [ // Goldenrod City / D37R0104 [ev194]
    //193, // Team Rocket Grunt
    //228, // Team Rocket Grunt
    //195, // Team Rocket Grunt
    //199, // Team Rocket Grunt
    //283, // Burglar Orson
    //14, // Burglar Duncan
    ],
    
    MAP_GOLDENROD_TUNNEL_WAREHOUSE: [ // Goldenrod City / D37R0105 [ev195]
    //196, // Team Rocket Grunt
    //197, // Team Rocket Grunt
    //227, // Team Rocket Grunt
    ],
    
    MAP_GOLDENROD_BILLS_HOUSE: [ // Goldenrod City / T25R0401 [ev196]
    ],
    
    MAP_GOLDENROD_FRIENDSHIP_CHECKER_HOUSE: [ // Goldenrod City / T25R0301 [ev197]
    ],
    
    MAP_GOLDENROD_NORTHEAST_HOUSE: [ // Goldenrod City / T25R0801 [ev198]
    ],
    
    MAP_GOLDENROD_NAME_RATER_HOUSE: [ // Goldenrod City / T25R0901 [ev199]
    ],
    
    MAP_GOLDENROD_GLOBAL_TERMINAL_1F: [ // Global Terminal / T25R1201 [ev200]
    ],
    
    MAP_ROUTE_39_MOOMOO_FARM_HOUSE: [ // Route 39 / R39R0101 [ev201]
    ],
    
    MAP_ROUTE_39_MOOMOO_FARM_STABLE: [ // Route 39 / R39R0201 [ev202]
    ],
    
    MAP_ECRUTEAK_BELL_TOWER_BARRIER_STATION_CORRIDOR: [ // Ecruteak City / T27R0202 [ev203]
    ],
    
    MAP_BURNED_TOWER_B1F: [ // Burned Tower / D18R0102 [ev204]
    ],
    
    MAP_GOLDENROD_POKECENTER_B1F: [ // Goldenrod City / T25PC0102 [ev205]
    ],
    
    MAP_OLIVINE_LIGHTHOUSE_2F: [ // Lighthouse / D27R0102 [ev206]
    401, // Gentleman Alfred
    211, // Sailor Huey
    ],
    
    MAP_OLIVINE_LIGHTHOUSE_EXTERIOR: [ // Lighthouse / D27R0103 [ev207]
    ],
    
    MAP_OLIVINE_LIGHTHOUSE_3F: [ // Lighthouse / D27R0104 [ev208]
    213, // Sailor Kent
    217, // Bird Keeper Denis
    73, // Bird Keeper Theo
    ],
    
    MAP_OLIVINE_LIGHTHOUSE_4F: [ // Lighthouse / D27R0105 [ev209]
    215, // Lass Connie
    37, // Gentleman Preston
    ],
    
    MAP_OLIVINE_LIGHTHOUSE_5F: [ // Lighthouse / D27R0106 [ev210]
    212, // Sailor Terrell
    214, // Sailor Roberto
    ],
    
    MAP_OLIVINE_LIGHTHOUSE_LIGHT_ROOM: [ // Lighthouse / D27R0107 [ev211]
    ],
    
    MAP_OLIVINE_POKECENTER_1F: [ // Olivine City / T26PC0101 [ev212]
    728, // Beauty Charlotte - MANUALLY ADDED
    ],
    
    MAP_OLIVINE_POKEMART: [ // Olivine City / T26FS0101 [ev213]
    ],
    
    MAP_OLIVINE_NORTH_HOUSE: [ // Olivine City / T26R0301 [ev214]
    ],
    
    MAP_OLIVINE_NORTHEAST_HOUSE: [ // Olivine City / T26R0501 [ev215]
    ],
    
    MAP_OLIVINE_NORTHWEST_HOUSE: [ // Olivine City / T26R0601 [ev216]
    ],
    
    MAP_OLIVINE_CAFE: [ // Olivine City / T26R0701 [ev217]
    ],
    
    MAP_CIANWOOD_KIRKS_HOUSE: [ // Cianwood City / T24R0201 [ev218]
    ],
    
    MAP_CIANWOOD_PHARMACY: [ // Cianwood City / T24R0501 [ev219]
    ],
    
    MAP_CIANWOOD_CAMERONS_HOUSE: [ // Cianwood City / T24R0601 [ev220]
    ],
    
    MAP_CIANWOOD_CENTRAL_HOUSE: [ // Cianwood City / T24R0701 [ev221]
    ],
    
    MAP_CIANWOOD_POKECENTER_1F: [ // Cianwood City / T24PC0101 [ev222]
    ],
    
    MAP_ICE_PATH_B1F: [ // Ice Path / D39R0102 [ev223]
    ],
    
    MAP_ICE_PATH_B2F: [ // Ice Path / D39R0103 [ev224]
    ],
    
    MAP_ICE_PATH_B3F: [ // Ice Path / D39R0104 [ev225]
    ],
    
    MAP_SS_AQUA_OLIVINE_PORT_INTERIOR: [ // Olivine City / P01R0101 [ev226]
    ],
    
    MAP_CIANWOOD_POKECENTER_B1F: [ // Cianwood City / T24PC0102 [ev227]
    ],
    
    MAP_WHIRL_ISLANDS_B1F: [ // Whirl Islands / D40R0102 [ev228]
    ],
    
    MAP_WHIRL_ISLANDS_B2F: [ // Whirl Islands / D40R0104 [ev229]
    ],
    
    MAP_WHIRL_ISLANDS_B3F_LUGIA_CAVE: [ // Whirl Islands / D40R0107 [ev230]
    ],
    
    MAP_ROUTE_43_GATEHOUSE: [ // Route 43 / R43R0201 [ev231]
    ],
    
    MAP_MAHOGANY_POKECENTER_1F: [ // Mahogany Town / T28PC0101 [ev232]
    ],
    
    MAP_TEAM_ROCKET_HEADQUARTERS_B1F: [ // Team Rocket HQ / D35R0102 [ev233]
    //216, // Team Rocket Grunt
    //470, // Scientist Gregg
    ],
    
    MAP_TEAM_ROCKET_HEADQUARTERS_B2F: [ // Team Rocket HQ / D35R0103 [ev234]
    //220, // Team Rocket Grunt
    //218, // Team Rocket Grunt
    //219, // Team Rocket Grunt
    ],
    
    MAP_TEAM_ROCKET_HEADQUARTERS_B3F: [ // Team Rocket HQ / D35R0104 [ev235]
    //468, // Scientist Ross
    //469, // Scientist Mitch
    //222, // Team Rocket Grunt
    //404, // Team Rocket Grunt
    ],
    
    MAP_MOUNT_MORTAR_1F_BACK: [ // Mt. Mortar / D38R0102 [ev236]
    537, // PokÃ© Maniac Harrison
    539, // Super Nerd Markus
    ],
    
    MAP_MOUNT_MORTAR_2F: [ // Mt. Mortar / D38R0103 [ev237]
    538, // Super Nerd Hugh
    ],
    
    MAP_MOUNT_MORTAR_B1F: [ // Mt. Mortar / D38R0104 [ev238]
    ],
    
    MAP_DRAGONS_DEN: [ // Dragon's Den / D44R0102 [ev239]
    500, // Ace Trainer Kobe
    501, // Ace Trainer Piper
    502, // Twins Clea & Gil
    //502, // Twins Clea & Gil - double battle dupe
    ],
    
    MAP_BATTLE_TOWER: [ // Battle Tower / D31R0201 [ev240]
    ],
    
    MAP_BATTLE_TOWER_ELEVATOR: [ // Battle Tower / D31R0202 [ev241]
    ],
    
    MAP_BATTLE_TOWER_PARTNER_ROOM: [ // Battle Tower / D31R0207 [ev242]
    ],
    
    MAP_BATTLE_FRONTIER: [ // Battle Frontier / D32 [ev243]
    ],
    
    MAP_BATTLE_FRONTIER_FRONTIER_ACCESS_GATEHOUSE: [ // Battle Frontier / D32R0101 [ev244]
    ],
    
    MAP_BATTLE_FRONTIER_BATTLE_TOWER_UNUSED: [ // Battle Tower / D32R0201 [ev245]
    ],
    
    MAP_BATTLE_FRONTIER_BATTLE_FACTORY: [ // Battle Factory / D32R0301 [ev246]
    ],
    
    MAP_BATTLE_FRONTIER_BATTLE_HALL: [ // Battle Hall / D32R0401 [ev247]
    ],
    
    MAP_BATTLE_FRONTIER_BATTLE_CASTLE: [ // Battle Castle / D32R0501 [ev248]
    ],
    
    MAP_BATTLE_FRONTIER_BATTLE_ARCADE: [ // Battle Arcade / D32R0601 [ev249]
    ],
    
    MAP_CLIFF_EDGE_GATE: [ // Cliff Edge Gate / D48R0101 [ev250]
    ],
    
    MAP_POKEATHLON_DOME: [ // Pokeathlon Dome / D49 [ev251]
    ],
    
    MAP_POKEATHLON_DOME_INTERIOR_1F: [ // Pokeathlon Dome / D49R0101 [ev252]
    ],
    
    MAP_POKEATHLON_DOME_INTERIOR_2F: [ // Pokeathlon Dome / D49R0102 [ev253]
    ],
    
    MAP_POKEATHLON_DOME_INTERIOR_2F_ENTRANCE: [ // Pokeathlon Dome / D49R0103 [ev254]
    ],
    
    MAP_POKEATHLON_DOME_INTERIOR_B1F_SOLIDARITY_ROOM: [ // Pokeathlon Dome / D49R0104 [ev255]
    ],
    
    MAP_POKEATHLON_DOME_INTERIOR_B1F_TRUST_ROOM: [ // Pokeathlon Dome / D49R0105 [ev256]
    ],
    
    MAP_POKEATHLON_DOME_INTERIOR_B1F_POTENTIAL_ROOM: [ // Pokeathlon Dome / D49R0106 [ev257]
    ],
    
    MAP_POKEATHLON_DOME_INTERIOR_B1F_FRIENDSHIP_ROOM: [ // Pokeathlon Dome / D49R0107 [ev258]
    ],
    
    MAP_DRAGONS_DEN_SHRINE: [ // Dragon's Den / D44R0103 [ev259]
    ],
    
    MAP_BLACKTHORN_WEST_HOUSE: [ // Blackthorn City / T30R0201 [ev260]
    ],
    
    MAP_BLACKTHORN_EAST_HOUSE: [ // Blackthorn City / T30R0301 [ev261]
    ],
    
    MAP_BLACKTHORN_MOVE_TUTOR_HOUSE: [ // Blackthorn City / T30R0601 [ev262]
    ],
    
    MAP_BLACKTHORN_POKEMART: [ // Blackthorn City / T30FS0101 [ev263]
    ],
    
    MAP_BLACKTHORN_POKECENTER_1F: [ // Blackthorn City / T30PC0101 [ev264]
    ],
    
    MAP_LAKE_OF_RAGE_HIDDEN_POWER_HOUSE: [ // Lake of Rage / T29R0101 [ev265]
    ],
    
    MAP_LAKE_OF_RAGE_FISHING_GURU_HOUSE: [ // Lake of Rage / T29R0201 [ev266]
    ],
    
    MAP_ROUTE_26_NORTH_HOUSE: [ // Route 26 / R26R0101 [ev267]
    ],
    
    MAP_ROUTE_26_WEEK_SIBLINGS_HOUSE: [ // Route 26 / R26R0201 [ev268]
    ],
    
    MAP_TOHJO_FALLS_HIDDEN_ROOM: [ // Tohjo Falls / D45R0102 [ev269]
    ],
    
    MAP_ROUTE_22_POKEMON_LEAGUE_RECEPTION_GATE: [ // Route 26 / R22R0101 [ev270]
    ],
    
    MAP_POKEMON_LEAGUE_ENTRANCE: [ // Pokemon League / T10R0101 [ev271]
    ],
    
    MAP_POKEMON_LEAGUE_WILL_ROOM: [ // Pokemon League / T10R0201 [ev272]
    ],
    
    MAP_POKEMON_LEAGUE_KOGA_ROOM: [ // Pokemon League / T10R0301 [ev273]
    ],
    
    MAP_POKEMON_LEAGUE_BRUNO_ROOM: [ // Pokemon League / T10R0401 [ev274]
    ],
    
    MAP_POKEMON_LEAGUE_KAREN_ROOM: [ // Pokemon League / T10R0501 [ev275]
    ],
    
    MAP_POKEMON_LEAGUE_LANCE_ROOM: [ // Pokemon League / T10R0601 [ev276]
    ],
    
    MAP_POKEMON_LEAGUE_HALL_OF_FAME: [ // Pokemon League / T10R0701 [ev277]
    ],
    
    MAP_SS_AQUA_1F: [ // S.S. Aqua / P01R0301 [ev278]
    ],
    
    MAP_SS_AQUA_CAPTAIN_ROOM: [ // S.S. Aqua / P01R0302 [ev279]
    ],
    
    MAP_SS_AQUA_1F_SOUTHEAST_ROOMS: [ // S.S. Aqua / P01R0303 [ev280]
    231, // Gentleman Edward
    284, // Burglar Corey
    ],
    
    MAP_SS_AQUA_1F_SOUTHWEST_ROOMS: [ // S.S. Aqua / P01R0304 [ev281]
    //235, // Hiker Noland
    236, // Ace Trainer Shaye
    237, // Ace Trainer Carol
    133, // PokÃ© Maniac Morgan
    ],
    
    MAP_SS_AQUA_1F_NORTHEAST_ROOMS: [ // S.S. Aqua / P01R0305 [ev282]
    //399, // Firebreather Lyle
    209, // Beauty Cassie
    41, // Guitarist Clyde
    79, // Bug Catcher Ken
    ],
    
    MAP_RUINS_OF_ALPH_NORTHEAST_ENTRANCE_FIRST_ROOM: [ // Ruins of Alph / D24R0202 [ev283]
    ],
    
    MAP_RUINS_OF_ALPH_NORTHEAST_HIDDEN_ROOM: [ // Ruins of Alph / D24R0203 [ev284]
    ],
    
    MAP_RUINS_OF_ALPH_SOUTHEAST_ENTRANCE_FIRST_ROOM: [ // Ruins of Alph / D24R0204 [ev285]
    ],
    
    MAP_RUINS_OF_ALPH_UNDERGROUND_HALL: [ // Ruins of Alph / D24R0205 [ev286]
    ],
    
    MAP_RUINS_OF_ALPH_SOUTHWEST_ENTRANCE_FIRST_ROOM: [ // Ruins of Alph / D24R0206 [ev287]
    ],
    
    MAP_RUINS_OF_ALPH_SOUTHWEST_HIDDEN_ROOM: [ // Ruins of Alph / D24R0207 [ev288]
    ],
    
    MAP_RUINS_OF_ALPH_NORTHWEST_ENTRANCE_FIRST_ROOM: [ // Ruins of Alph / D24R0208 [ev289]
    ],
    
    MAP_RUINS_OF_ALPH_NORTHWEST_HIDDEN_ROOM: [ // Ruins of Alph / D24R0209 [ev290]
    ],
    
    MAP_RUINS_OF_ALPH_SOUTHEAST_HIDDEN_ROOM: [ // Ruins of Alph / D24R0210 [ev291]
    ],
    
    MAP_RUINS_OF_ALPH_RESEARCH_CENTER: [ // Ruins of Alph / D24R0102 [ev292]
    ],
    
    MAP_ROUTE_27_HOUSE: [ // Route 27 / R27R0101 [ev293]
    ],
    
    MAP_RUINS_OF_ALPH_HALL_ENTRANCE: [ // Ruins of Alph / D24R0211 [ev294]
    ],
    
    MAP_RUINS_OF_ALPH_NORTHEAST_ENTRANCE_SECOND_ROOM: [ // Ruins of Alph / D24R0212 [ev295]
    ],
    
    MAP_RUINS_OF_ALPH_SOUTHEAST_ENTRANCE_SECOND_ROOM: [ // Ruins of Alph / D24R0213 [ev296]
    ],
    
    MAP_RUINS_OF_ALPH_NORTHWEST_ENTRANCE_SECOND_ROOM: [ // Ruins of Alph / D24R0214 [ev297]
    ],
    
    MAP_RUINS_OF_ALPH_SOUTHWEST_ENTRANCE_SECOND_ROOM: [ // Ruins of Alph / D24R0215 [ev298]
    ],
    
    MAP_SS_AQUA_1F_NORTHWEST_ROOMS: [ // S.S. Aqua / P01R0306 [ev299]
    //424, // PokÃ©fan Colin
    //425, // Twins Meg & Peg
    //425, // Twins Meg & Peg - double battle dupe
    367, // Super Nerd Shawn
    422, // Psychic Rodney
    352, // PokÃ©fan Georgia
    423, // PokÃ©fan Jeremy
    ],
    
    MAP_SS_AQUA_B1F: [ // S.S. Aqua / P01R0307 [ev300]
    //139, // Picknicker Debra
    //239, // Sailor Jeff
    242, // Juggler Fritz
    128, // Fisherman Jonah
    240, // Sailor Garrett
    339, // Black Belt Wai
    241, // Sailor Kenneth
    428, // School Kid Nate
    429, // School Kid Ricky
    427, // Teacher Shirley
    ],
    
    MAP_SS_AQUA_OLIVINE_PORT_EXTERIOR: [ // Olivine City / P01R0102 [ev301]
    ],
    
    MAP_ROUTE_34_DAYCARE: [ // Route 34 / R34R0101 [ev302]
    ],
    
    MAP_BELL_TOWER_2F: [ // Bell Tower / D17R0102 [ev303]
    ],
    
    MAP_BELL_TOWER_3F: [ // Bell Tower / D17R0103 [ev304]
    ],
    
    MAP_BELL_TOWER_4F: [ // Bell Tower / D17R0104 [ev305]
    ],
    
    MAP_BELL_TOWER_5F: [ // Bell Tower / D17R0105 [ev306]
    ],
    
    MAP_BELL_TOWER_6F: [ // Bell Tower / D17R0106 [ev307]
    ],
    
    MAP_BELL_TOWER_7F: [ // Bell Tower / D17R0107 [ev308]
    ],
    
    MAP_BELL_TOWER_8F: [ // Bell Tower / D17R0108 [ev309]
    ],
    
    MAP_BELL_TOWER_9F: [ // Bell Tower / D17R0109 [ev310]
    ],
    
    MAP_BELL_TOWER_ROOF: [ // Bell Tower / D17R0110 [ev311]
    ],
    
    MAP_BELL_TOWER_10F: [ // Bell Tower / D17R0112 [ev312]
    ],
    
    MAP_CLIFF_CAVE: [ // Cliff Cave / D50R0101 [ev313]
    ],
    
    MAP_SAFARI_ZONE_ENTRANCE_EXTERIOR: [ // Safari Zone / D47R0102 [ev314]
    ],
    
    MAP_VERMILION_POKECENTER_1F: [ // Vermilion City / T06PC0101 [ev315]
    ],
    
    MAP_VERMILION_POKECENTER_B1F: [ // Vermilion City / T06PC0102 [ev316]
    ],
    
    MAP_VERMILION_POKEMART: [ // Vermilion City / T06FS0101 [ev317]
    ],
    
    MAP_VERMILION_FISHING_DUDE_HOUSE: [ // Vermilion City / T06R0101 [ev318]
    ],
    
    MAP_VERMILION_POKEMON_FAN_CLUB: [ // Vermilion City / T06R0301 [ev319]
    ],
    
    MAP_VERMILION_CENTRAL_HOUSE: [ // Vermilion City / T06R0401 [ev320]
    ],
    
    MAP_VERMILION_SOUTH_HOUSE: [ // Vermilion City / T06R0601 [ev321]
    ],
    
    MAP_VERMILION_GYM: [ // Vermilion City / T06GYM0101 [ev322]
    //232, // Guitarist Vincent
    //396, // Juggler Horton
    //337, // Gentleman Gregory
    ],
    
    MAP_ROUTE_40_BATTLE_FRONTIER_GATEHOUSE: [ // Route 40 / W40R0101 [ev323]
    ],
    
    MAP_OLIVINE_POKECENTER_B1F: [ // Olivine City / T26PC0102 [ev324]
    ],
    
    MAP_MAHOGANY_POKECENTER_B1F: [ // Mahogany Town / T28PC0102 [ev325]
    ],
    
    MAP_BLACKTHORN_POKECENTER_B1F: [ // Blackthorn City / T30PC0102 [ev326]
    ],
    
    MAP_CELADON_DEPARTMENT_STORE_1F: [ // Celadon City / T07R0101 [ev327]
    ],
    
    MAP_CELADON_DEPARTMENT_STORE_2F: [ // Celadon City / T07R0102 [ev328]
    ],
    
    MAP_CELADON_DEPARTMENT_STORE_3F: [ // Celadon City / T07R0103 [ev329]
    ],
    
    MAP_CELADON_DEPARTMENT_STORE_4F: [ // Celadon City / T07R0104 [ev330]
    ],
    
    MAP_CELADON_DEPARTMENT_STORE_5F: [ // Celadon City / T07R0105 [ev331]
    ],
    
    MAP_CELADON_DEPARTMENT_STORE_ROOF: [ // Celadon City / T07R0106 [ev332]
    ],
    
    MAP_CELADON_CONDOMINIUMS_1F: [ // Celadon City / T07R0201 [ev333]
    ],
    
    MAP_CELADON_CONDOMINIUMS_2F: [ // Celadon City / T07R0202 [ev334]
    ],
    
    MAP_CELADON_CONDOMINIUMS_3F: [ // Celadon City / T07R0203 [ev335]
    ],
    
    MAP_CELADON_CONDOMINIUMS_ROOF: [ // Celadon City / T07R0204 [ev336]
    ],
    
    MAP_CELADON_CONDOMINIUMS_ROOF_ROOM: [ // Celadon City / T07R0205 [ev337]
    ],
    
    MAP_CELADON_GAME_CORNER_JP: [ // Celadon City / T07R0401 [ev338]
    ],
    
    MAP_CELADON_PRIZE_CORNER: [ // Celadon City / T07R0501 [ev339]
    ],
    
    MAP_CELADON_RESTAURANT: [ // Celadon City / T07R0701 [ev340]
    ],
    
    MAP_NEW_BARK_RIVAL_HOUSE_2F: [ // New Bark Town / T20R0402 [ev341]
    ],
    
    MAP_CIANWOOD_NORTH_HOUSE: [ // Cianwood City / T24R0801 [ev342]
    ],
    
    MAP_SS_AQUA_VERMILION_PORT_INTERIOR: [ // Vermilion City / P01R0103 [ev343]
    ],
    
    MAP_SS_AQUA_VERMILION_PORT_EXTERIOR: [ // Vermilion City / P01R0104 [ev344]
    ],
    
    MAP_ROUTE_10_SOUTH: [ // Route 10 / R10R0101 [ev345]
    359, // Hiker Jim
    348, // PokÃ©fan Robert
    ],
    
    MAP_ROUTE_6_SAFFRON_GATEHOUSE: [ // Route 6 / R06R0201 [ev346]
    ],
    
    MAP_ROUTE_8_SAFFRON_GATEHOUSE: [ // Route 8 / R08R0201 [ev347]
    ],
    
    MAP_ROUTE_5_SAFFRON_GATEHOUSE: [ // Route 5 / R05R0301 [ev348]
    ],
    
    MAP_ROUTE_15_FUCHSIA_GATEHOUSE: [ // Route 15 / R15R0101 [ev349]
    ],
    
    MAP_CELADON_POKECENTER_1F: [ // Celadon City / T07PC0101 [ev350]
    ],
    
    MAP_CELADON_POKECENTER_B1F: [ // Celadon City / T07PC0102 [ev351]
    ],
    
    MAP_CELADON_GYM: [ // Celadon City / T07GYM0101 [ev352]
    //326, // Twins Jo & Zoe
    //326, // Twins Jo & Zoe - double battle dupe
    //356, // Lass Michelle
    //336, // Picknicker Tanya
    //346, // Beauty Julia
    ],
    
    MAP_MAHOGANY_GYM_ROOM_2: [ // Mahogany Town / T28GYM0102 [ev353]
    //480, // Skier Diana
    //483, // Boarder Patton
    ],
    
    MAP_MAHOGANY_GYM_ROOM_1: [ // Mahogany Town / T28GYM0103 [ev354]
    ],
    
    MAP_SAFFRON_FIGHTING_DOJO: [ // Saffron City / T11R0101 [ev355]
    ],
    
    MAP_SAFFRON_MR_PSYCHIC_HOUSE: [ // Saffron City / T11R0501 [ev356]
    ],
    
    MAP_SAFFRON_MAGNET_TRAIN_STATION_1F: [ // Saffron City / T11R0601 [ev357]
    ],
    
    MAP_SAFFRON_MAGNET_TRAIN_STATION_2F: [ // Saffron City / T11R0602 [ev358]
    ],
    
    MAP_SAFFRON_SILPH_CO_HQ: [ // Saffron City / T11R0701 [ev359]
    ],
    
    MAP_SAFFRON_SILPH_CO_ROTOM_ROOM: [ // ROTOM's Room / T11R0702 [ev360]
    ],
    
    MAP_SAFFRON_COPYCAT_HOUSE_1F: [ // Saffron City / T11R0801 [ev361]
    ],
    
    MAP_SAFFRON_COPYCAT_HOUSE_2F: [ // Saffron City / T11R0802 [ev362]
    ],
    
    MAP_SAFFRON_POKECENTER_1F: [ // Saffron City / T11PC0101 [ev363]
    ],
    
    MAP_SAFFRON_POKECENTER_2F: [ // Saffron City / T11PC0102 [ev364]
    ],
    
    MAP_SAFFRON_POKEMART: [ // Saffron City / T11FS0101 [ev365]
    ],
    
    MAP_SAFFRON_GYM: [ // Saffron City / T11GYM0101 [ev366]
    //369, // Medium Darcy
    //415, // Psychic Jared
    //368, // Medium Rebecca
    //230, // Psychic Franklin
    ],
    
    MAP_BATTLE_FRONTIER_FRONTIER_ACCESS: [ // Frontier Access / D32R0102 [ev367]
    ],
    
    MAP_GOLDENROD_GLOBAL_TERMINAL_2F: [ // Global Terminal / T25R1202 [ev368]
    ],
    
    MAP_GOLDENROD_GLOBAL_TERMINAL_3F: [ // Global Terminal / T25R1203 [ev369]
    ],
    
    MAP_ROUTE_2_EAST: [ // Route 2 / R02R0101 [ev370]
    248, // Bug Catcher Ed
    ],
    
    MAP_ROUTE_16_HOUSE: [ // Route 16 / R16R0101 [ev371]
    ],
    
    MAP_ROUTE_2_HOUSE: [ // Route 2 / R02R0201 [ev372]
    ],
    
    MAP_ROUTE_2_SOUTHEAST_GATEHOUSE: [ // Route 2 / R02R0301 [ev373]
    ],
    
    MAP_ROUTE_2_VIRIDIAN_FOREST_SOUTH_GATEHOUSE: [ // Route 2 / R02R0401 [ev374]
    ],
    
    MAP_ROUTE_2_VIRIDIAN_FOREST_NORTH_GATEHOUSE: [ // Route 2 / R02R0501 [ev375]
    ],
    
    MAP_ROUTE_16_GATEHOUSE: [ // Route 16 / R16R0201 [ev376]
    ],
    
    MAP_ROUTE_16_EAST: [ // Route 16 / R16R0301 [ev377]
    ],
    
    MAP_ROUTE_18_GATEHOUSE: [ // Route 18 / R18R0101 [ev378]
    ],
    
    MAP_ROUTE_19_FUCHSIA_GATEHOUSE: [ // Route 19 / W19R0101 [ev379]
    ],
    
    MAP_ROUTE_19_ROUTE_12_GATEHOUSE: [ // Route 11 / R11R0101 [ev380]
    ],
    
    MAP_CERULEAN_POKEMART: [ // Cerulean City / T04FS0101 [ev381]
    ],
    
    MAP_CERULEAN_GYM: [ // Cerulean City / T04GYM0101 [ev382]
    //297, // Swimmer Diana
    //298, // Swimmer Briana
    //677, // Sailor Eddie
    //676, // Sailor Parker
    ],
    
    MAP_CERULEAN_POKECENTER_1F: [ // Cerulean City / T04PC0101 [ev383]
    ],
    
    MAP_CERULEAN_NORTH_HOUSE: [ // Cerulean City / T04R0101 [ev384]
    ],
    
    MAP_CERULEAN_EAST_HOUSE: [ // Cerulean City / T04R0201 [ev385]
    ],
    
    MAP_CERULEAN_WEST_HOUSE: [ // Cerulean City / T04R0301 [ev386]
    ],
    
    MAP_CERULEAN_BIKE_MANIAC_HOUSE: [ // Cerulean City / T04R0401 [ev387]
    ],
    
    MAP_LAVENDER_POKEMART: [ // Lavender Town / T05FS0101 [ev388]
    ],
    
    MAP_LAVENDER_POKECENTER_1F: [ // Lavender Town / T05PC0101 [ev389]
    ],
    
    MAP_LAVENDER_VOLUNTEER_POKEMON_HOUSE: [ // Lavender Town / T05R0201 [ev390]
    ],
    
    MAP_LAVENDER_SOUTHWEST_HOUSE: [ // Lavender Town / T05R0301 [ev391]
    ],
    
    MAP_LAVENDER_NAME_RATER: [ // Lavender Town / T05R0401 [ev392]
    ],
    
    MAP_LAVENDER_HOUSE_OF_MEMORIES: [ // Lavender Town / T05R0601 [ev393]
    ],
    
    MAP_LAVENDER_RADIO_STATION: [ // Lavender Town / T05R0701 [ev394]
    ],
    
    MAP_ROUTE_25_SEA_COTTAGE: [ // Route 25 / R25R0101 [ev395]
    ],
    
    MAP_GOLDENROD_DEPARTMENT_STORE_ELEVATOR: [ // Goldenrod City / T25R1007 [ev396]
    ],
    
    MAP_CELADON_DEPARTMENT_STORE_ELEVATOR: [ // Celadon City / T07R0107 [ev397]
    ],
    
    MAP_CELADON_CONDOMINIUMS_LEFT_ELEVATOR: [ // Celadon City / T07R0206 [ev398]
    ],
    
    MAP_CELADON_CONDOMINIUMS_RIGHT_ELEVATOR: [ // Celadon City / T07R0207 [ev399]
    ],
    
    MAP_SAFFRON_SILPH_CO_ELEVATOR: [ // Saffron City / T11R0703 [ev400]
    ],
    
    MAP_OLIVINE_LIGHTHOUSE_ELEVATOR: [ // Lighthouse / D27R0108 [ev401]
    ],
    
    MAP_GOLDENROD_RADIO_TOWER_ELEVATOR: [ // Radio Tower / D23R0107 [ev402]
    ],
    
    MAP_MOUNT_MOON_SQUARE_ENTRANCE: [ // Mt. Moon / D02R0102 [ev403]
    ],
    
    MAP_MOUNT_MOON_SQUARE: [ // Mt. Moon / D02R0103 [ev404]
    ],
    
    MAP_CERULEAN_CAVE_2F: [ // Cerulean Cave / D03R0102 [ev405]
    ],
    
    MAP_CERULEAN_CAVE_B1F: [ // Cerulean Cave / D03R0103 [ev406]
    ],
    
    MAP_ROCK_TUNNEL_B1F: [ // Rock Tunnel / D05R0102 [ev407]
    ],
    
    MAP_SEAFOAM_ISLANDS_B1F: [ // Seafoam Islands / D11R0102 [ev408]
    ],
    
    MAP_SEAFOAM_ISLANDS_B2F: [ // Seafoam Islands / D11R0103 [ev409]
    686, // Boarder Bryce
    687, // Boarder Shaun
    688, // Skier Cady
    ],
    
    MAP_SEAFOAM_ISLANDS_B3F: [ // Seafoam Islands / D11R0104 [ev410]
    ],
    
    MAP_SEAFOAM_ISLANDS_B4F: [ // Seafoam Islands / D11R0105 [ev411]
    ],
    
    MAP_SEAFOAM_ISLANDS_CINNABAR_GYM: [ // Seafoam Islands / D11R0106 [ev412]
    ],
    
    MAP_MOUNT_SILVER_CAVE_UPPER_MOUNTAINSIDE: [ // Mt. Silver Cave / D41R0102 [ev413]
    ],
    
    MAP_MOUNT_SILVER_CAVE_LOWER_MOUNTAINSIDE: [ // Mt. Silver Cave / D41R0103 [ev414]
    ],
    
    MAP_MOUNT_SILVER_CAVE_EXPERT_BELT_CHAMBER: [ // Mt. Silver Cave / D41R0104 [ev415]
    ],
    
    MAP_MOUNT_SILVER_CAVE_MOLTRES_CHAMBER: [ // Mt. Silver Cave / D41R0105 [ev416]
    ],
    
    MAP_MOUNT_SILVER_CAVE_2F: [ // Mt. Silver Cave / D41R0106 [ev417]
    ],
    
    MAP_MOUNT_SILVER_CAVE_3F: [ // Mt. Silver Cave / D41R0107 [ev418]
    ],
    
    MAP_MOUNT_SILVER_CAVE_SUMMIT: [ // Mt. Silver Cave / D41R0108 [ev419]
    ],
    
    MAP_ROUTE_10_POKECENTER_1F: [ // Route 10 / R10PC0101 [ev420]
    ],
    
    MAP_ROUTE_10_POWER_PLANT_REPAIRED: [ // Power Plant / R10R0201 [ev421]
    ],
    
    MAP_ROUTE_5_UNDERGROUND_PATH_GATE: [ // Route 5 / R05R0201 [ev422]
    ],
    
    MAP_ROUTE_6_UNDERGROUND_PATH_GATE: [ // Route 6 / R06R0101 [ev423]
    ],
    
    MAP_PEWTER_MUSEUM_OF_SCIENCE: [ // Pewter City / T03R0101 [ev424]
    ],
    
    MAP_PEWTER_NORTHEAST_HOUSE: [ // Pewter City / T03R0201 [ev425]
    ],
    
    MAP_PEWTER_GYM: [ // Pewter City / T03GYM0101 [ev426]
    //308, // Camper Jerry
    //685, // Hiker Edwin
    ],
    
    MAP_PEWTER_POKEMART: [ // Pewter City / T03FS0101 [ev427]
    ],
    
    MAP_PEWTER_POKECENTER_1F: [ // Pewter City / T03PC0101 [ev428]
    ],
    
    MAP_PEWTER_POKECENTER_B1F: [ // Pewter City / T03PC0102 [ev429]
    ],
    
    MAP_PEWTER_SOUTHWEST_HOUSE: [ // Pewter City / T03R0601 [ev430]
    ],
    
    MAP_FUCHSIA_POKEMART: [ // Fuchsia City / T08FS0101 [ev431]
    ],
    
    MAP_FUCHSIA_PAL_PARK_ENTRANCE: [ // Pal Park / T08R0201 [ev432]
    ],
    
    MAP_FUCHSIA_GYM: [ // Fuchsia City / T08GYM0101 [ev433]
    ],
    
    MAP_FUCHSIA_SOUTHWEST_HOUSE: [ // Fuchsia City / T08R0401 [ev434]
    ],
    
    MAP_FUCHSIA_POKECENTER_1F: [ // Fuchsia City / T08PC0101 [ev435]
    ],
    
    MAP_FUCHSIA_SAFARI_ZONE_WARDEN_HOUSE: [ // Fuchsia City / T08R0601 [ev436]
    ],
    
    MAP_ROUTE_10_POKECENTER_B1F: [ // Route 10 / R10PC0102 [ev437]
    ],
    
    MAP_FUCHSIA_POKECENTER_B1F: [ // Fuchsia City / T08PC0102 [ev438]
    ],
    
    MAP_WHIRL_ISLANDS_B3F: [ // Whirl Islands / D40R0106 [ev439]
    ],
    
    MAP_NATIONAL_PARK_BUG_CATCHING_CONTEST: [ // National Park / D22R0102 [ev440]
    ],
    
    MAP_ROUTE_10_POWER_PLANT_BROKEN: [ // Power Plant / R10R0202 [ev441]
    ],
    
    MAP_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT: [ // Ruins of Alph / D24R0216 [ev442]
    ],
    
    MAP_RUINS_OF_ALPH_HALL_ENTRANCE_SINJOH_EVENT: [ // Ruins of Alph / D24R0217 [ev443]
    ],
    
    MAP_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2: [ // Ruins of Alph / D24R0218 [ev444]
    ],
    
    MAP_ROUTE_7_SAFFRON_GATEHOUSE: [ // Route 7 / R07R0101 [ev445]
    ],
    
    MAP_LAVENDER_POKECENTER_B1F: [ // Lavender Town / T05PC0102 [ev446]
    ],
    
    MAP_CERULEAN_POKECENTER_B1F: [ // Cerulean City / T04PC0102 [ev447]
    ],
    
    MAP_VIRIDIAN_GYM: [ // Viridian City / T02GYM0101 [ev448]
    //681, // Ace Trainer Arabella
    //682, // Ace Trainer Bonita
    //683, // Ace Trainer Salma
    //684, // Double Team Elan & Ida
    //684, // Double Team Elan & Ida
    ],
    
    MAP_VIRIDIAN_NORTHEAST_HOUSE: [ // Viridian City / T02R0201 [ev449]
    ],
    
    MAP_VIRIDIAN_TRAINER_HOUSE_1F: [ // Viridian City / T02R0301 [ev450]
    ],
    
    MAP_VIRIDIAN_TRAINER_HOUSE_B1F: [ // Viridian City / T02R0302 [ev451]
    ],
    
    MAP_VIRIDIAN_POKEMART: [ // Viridian City / T02FS0101 [ev452]
    ],
    
    MAP_VIRIDIAN_POKECENTER_1F: [ // Viridian City / T02PC0101 [ev453]
    ],
    
    MAP_VIRIDIAN_POKECENTER_B1F: [ // Viridian City / T02PC0102 [ev454]
    ],
    
    MAP_PALLET_TOWN_REDS_HOUSE_1F: [ // Pallet Town / T01R0101 [ev455]
    ],
    
    MAP_PALLET_TOWN_BLUES_HOUSE_1F: [ // Pallet Town / T01R0201 [ev456]
    ],
    
    MAP_PALLET_TOWN_OAKS_LAB: [ // Pallet Town / T01R0301 [ev457]
    ],
    
    MAP_PALLET_TOWN_REDS_HOUSE_2F: [ // Pallet Town / T01R0102 [ev458]
    ],
    
    MAP_PALLET_TOWN_BLUES_HOUSE_2F: [ // Pallet Town / T01R0202 [ev459]
    ],
    
    MAP_CINNABAR_ISLAND_POKECENTER_1F: [ // Cinnabar Island / T09PC0101 [ev460]
    ],
    
    MAP_CINNABAR_ISLAND_POKECENTER_B1F: [ // Cinnabar Island / T09PC0102 [ev461]
    ],
    
    MAP_ROUTE_28_HOUSE: [ // Route 28 / R28R0101 [ev462]
    ],
    
    MAP_ROUTE_3_POKECENTER_1F: [ // Route 3 / R03PC0101 [ev463]
    ],
    
    MAP_ROUTE_3_POKECENTER_B1F: [ // Route 3 / R03PC0102 [ev464]
    ],
    
    MAP_MOUNT_MOON_SQUARE_CLEFAIRY_EVENT: [ // Mt. Moon / D02R0104 [ev465]
    ],
    
    MAP_MOUNT_SILVER_POKECENTER_1F: [ // Mt. Silver / T31PC0101 [ev466]
    ],
    
    MAP_MOUNT_SILVER_POKECENTER_B1F: [ // Mt. Silver / T31PC0102 [ev467]
    ],
    
    MAP_WIFI_PLAZA_WARP_ROOM: [ // Wifi Plaza / HIROBA [ev468]
    ],
    
    MAP_ROUTE_5_HOUSE: [ // Route 5 / R05R0401 [ev469]
    ],
    
    MAP_MOUNT_MOON_SQUARE_SHOP: [ // Mt. Moon / D02FS0101 [ev470]
    ],
    
    MAP_GOLDENROD_MAGNET_TRAIN_STATION_2F_EMPTY: [ // Goldenrod City / T25R0503 [ev471]
    ],
    
    MAP_SAFFRON_MAGNET_TRAIN_STATION_2F_EMPTY: [ // Saffron City / T11R0603 [ev472]
    ],
    
    MAP_SINJOH_RUINS_EXTERIOR: [ // Sinjoh Ruins / D51R0101 [ev473]
    ],
    
    MAP_SINJOH_RUINS_MYSTRI_STAGE: [ // Sinjoh Ruins / D51R0201 [ev474]
    ],
    
    MAP_SINJOH_RUINS_CABIN: [ // Sinjoh Ruins / D51R0301 [ev475]
    ],
    
    MAP_EMBEDDED_TOWER_GROUDON_ROOM: [ // Embedded Tower / D52R0101 [ev476]
    ],
    
    MAP_EMBEDDED_TOWER_KYOGRE_ROOM: [ // Embedded Tower / D52R0102 [ev477]
    ],
    
    MAP_EMBEDDED_TOWER_RAYQUAZA_ROOM: [ // Embedded Tower / D52R0103 [ev478]
    ],
    
    MAP_VIRIDIAN_ROUTE_1_GATEHOUSE: [ // Route 1 / T02R0401 [ev479]
    ],
    
    MAP_FRONTIER_ACCESS_POKECENTER_1F: [ // Frontier Access / D32PC0101 [ev480]
    ],
    
    MAP_FRONTIER_ACCESS_POKECENTER_B1F: [ // Frontier Access / D32PC0102 [ev481]
    ],
    
    MAP_FRONTIER_ACCESS_POKEMART: [ // Frontier Access / D32FS0101 [ev482]
    ],
    
    MAP_FRONTIER_ACCESS_MOVE_TUTOR_HOUSE: [ // Frontier Access / D32R0103 [ev483]
    ],
    
    MAP_ROUTE_5_UNDERGROUND_PATH: [ // Route 5 / R05R0202 [ev484]
    ],
    
    MAP_ROUTE_12_FISHING_BROTHER_HOUSE: [ // Route 12 / R12R0101 [ev485]
    ],
    
    MAP_SAFARI_ZONE_GATE_POKECENTER_1F: [ // Safari Zone / D47PC0101 [ev486]
    ],
    
    MAP_SAFARI_ZONE_GATE_POKECENTER_B1F: [ // Safari Zone / D47PC0102 [ev487]
    ],
    
    MAP_GOLDENROD_GAME_CORNER: [ // Goldenrod Game Corner / T25SP0101 [ev488]
    ],
    
    MAP_CELADON_GAME_CORNER: [ // Celadon Game Corner / T07SP0101 [ev489]
    ],
    
    MAP_POKEMON_LEAGUE_ENTRANCE_WIFI_ROOM: [ // Pokemon League / T10R0801 [ev490]
    ],
}

MAP_ITEMS = {
    MAP_BELLCHIME_TOWER: [ // Bellchime Trail / D17R1101
    8125,
    8126,
    8128,
    8127,
    8129,
    ],
    
    MAP_BURNED_TOWER_1F: [ // Burned Tower / D18R0101
    8020,
    8019,
	1073,
    1291,
    ],
	
	MAP_ROUTE_2: [ // Route 2 / R02 [ev7]
    1233,
    ],
	
	MAP_ROUTE_2_EAST: [ // Route 2 / R02R0101 [ev370]
    1232,
    ],
    
    MAP_ROUTE_3: [ // Route 3 / R03
    8145,
    8138,
    8139,
	1309,
    ],
    
    MAP_ROUTE_4: [ // Route 4 / R04
    8113,
    8194,
	1240,
    ],
	
	MAP_ROUTE_6: [ // Route 6 / R06 [ev11]
    1299,
    ],
    
    MAP_ROUTE_7: [ // Route 7 / R07 [ev12]
    1197,
    ],
    
    MAP_ROUTE_8: [ // Route 8 / R08 [ev13]
    1287,
    ],
    
    MAP_ROUTE_9: [ // Route 9 / R09
    8105,
	1301,
    1302,
    1303,
    1304,
    ],
    
    MAP_ROUTE_10: [ // Route 10 / R10
    8197,
    ],
	
	MAP_ROUTE_10_SOUTH: [ // Route 10 / R10R0101 [ev345]
    1300,
    ],
    
    MAP_ROUTE_11: [ // Route 11 / R11
    8104,
	1307,
    ],
    
    MAP_ROUTE_12: [ // Route 12 / R12
    8112,
	1228,
    1229,
    ],
    
    MAP_ROUTE_13: [ // Route 13 / R13
    8111,
    ],
	
	MAP_ROUTE_15: [ // Route 15 / R15 [ev20]
    1230,
    1306,
    ],
    
    MAP_ROUTE_17: [ // Route 17 / R17
    8109,
    8110,
    ],
    
    MAP_ROUTE_25: [ // Route 25 / R25
    8107,
	1227,
    ],
    
    MAP_ROUTE_26: [ // Route 26 / R26
    8183,
    8184,
	1115,
    ],
    
    MAP_ROUTE_27: [ // Route 27 / R27
    8181,
    8182,
    8183,
	1117,
    1118,
    1293,
    ],
    
    MAP_ROUTE_28: [ // Route 28 / R28
    8115,
	1280,
    ],
    
    MAP_ROUTE_29: [ // Route 29 / R29
    8001,
	1081,
    ],
    
    MAP_ROUTE_30: [ // Route 30 / R30
    8002,
    8001,
	1056,
    1088,
    ],
	
	MAP_ROUTE_31: [ // Route 31 / R31 [ev32]
    1057,
    1058,
    ],
    
    MAP_ROUTE_32: [ // Route 32 / R32
    8004,
    8005,
    8097,
	1065,
    1066,
    1273,
    1239,
    ],
    
    MAP_ROUTE_34: [ // Route 34 / R34
    8007,
    8008,
    8009,
	1087,
    1274,
    ],
    
    MAP_ROUTE_35: [ // Route 35 / R35
    8010,
	1097,
    1275,
    ],
    
    MAP_ROUTE_36: [ // Route 36 / R36
    8011,
	1276,
    ],
    
    MAP_ROUTE_38: [ // Route 38 / R38
    8022,
	1277,
    1278,
    ],
    
    MAP_ROUTE_39: [ // Route 39 / R39
    8098,
    8135,
    8136,
    8137,
	1279,
    ],
    
    MAP_ROUTE_42: [ // Route 42 / R42
    8042,
	1172,
    1193,
    1285,
    ],
	
	MAP_ROUTE_43: [ // Route 43 / R43 [ev42]
    1198,
    ],
    
    MAP_ROUTE_44: [ // Route 44 / R44
    8100,
	1201,
    1202,
    1203,
    ],
    
    MAP_ROUTE_45: [ // Route 45 / R45
    8101,
    8230,
	1212,
    1213,
    1214,
    1215,
    1216,
    ],
    
    MAP_ROUTE_46: [ // Route 46 / R46
    8230,
	1217,
    ],
    
    MAP_VIRIDIAN: [ // Viridian City / T02
    8200,
    ],
    
    MAP_PEWTER: [ // Pewter City / T03
    8198,
    8199,
    8227,
	1308,
    ],
    
    MAP_CERULEAN: [ // Cerulean City / T04
    8106,
    ],
    
    MAP_VERMILION: [ // Vermilion City / T06
    8103,
    8168,
    8162,
    8163,
    8164,
	1294,
    1295,
    ],
    
    MAP_CELADON: [ // Celadon City / T07
    8122,
	1305,
    ],
    
    MAP_FUCHSIA: [ // Fuchsia City / T08
    8134,
    ],
    
    MAP_CINNABAR_ISLAND: [ // Cinnabar Island / T09
    8114,
    8166,
    8167,
	1236,
    ],
    
    MAP_INDIGO_PLATEAU: [ // Indigo Plateau / T10
    8190,
    ],
    
    MAP_NEW_BARK: [ // New Bark Town / T20
    8000,
    ],
    
    MAP_CHERRYGROVE: [ // Cherrygrove City / T21
    8001,
    8225,
    ],
    
    MAP_VIOLET: [ // Violet City / T22
    8003,
    8108,
	1059,
    1060,
    ],
    
    MAP_AZALEA: [ // Azalea Town / T23
    8006,
    ],
    
    MAP_CIANWOOD: [ // Cianwood City / T24
    8025,
    8026,
    ],
    
    MAP_GOLDENROD: [ // Goldenrod City / T25
    8009,
    ],
    
    MAP_OLIVINE: [ // Olivine City / T26
    8023,
    8137,
	1310,
    ],
    
    MAP_ECRUTEAK: [ // Ecruteak City / T27
    8012,
    8013,
    8132,
    8133,
    ],
    
    MAP_LAKE_OF_RAGE: [ // Lake of Rage / T29
    8036,
    8037,
    8102,
	//651,
    //652,
    //649,
    1288,
    1290,
    1289,
    ],
    
    MAP_MOUNT_SILVER: [ // Mt. Silver / T31
    8116,
	1231,
    ],
    
    MAP_ROUTE_19: [ // Route 19 / W19
    8180,
    8179,
    8178,
    8207,
    8208,
	1199,
    ],
    
    MAP_ROUTE_20: [ // Route 20 / W20
    8174,
    8229,
    8038,
    ],
    
    MAP_ROUTE_21: [ // Route 21 / W21
    8175,
    8176,
    8177,
    8114,
    ],
    
    MAP_ROUTE_40: [ // Route 40 / W40
    8024,
	1266,
    ],
    
    MAP_ROUTE_41: [ // Route 41 / W41
    8099,
    8170,
    8171,
    8173,
    8172,
    ],
    
    MAP_NATIONAL_PARK: [ // National Park / D22R0101
    8034,
    8035,
	1145,
    1144,
    1286,
    ],
    
    MAP_UNION_CAVE_1F: [ // Union Cave / D25R0101
    8154,
    8151,
    8152,
	1067,
    1068,
    1069,
    1070,
    ],
    
    MAP_DIGLETT_CAVE: [ // DIGLETT's Cave / D01R0101
    8056,
    8224,
	1297,
    1298,
    ],
    
    MAP_MOUNT_MOON: [ // Mt. Moon / D02R0101
    8195,
    ],
    
    MAP_ROCK_TUNNEL_1F: [ // Rock Tunnel / D05R0101
    8060,
    8059,
	1222,
    1223,
    ],
	
	MAP_SPROUT_TOWER_1F: [ // Sprout Tower / D15R0101 [ev107]
    1061,
    ],
    
    MAP_RUINS_OF_ALPH: [ // Ruins of Alph / D24R0101
    8146,
    8149,
    8148,
    8147,
    8150,
	1146, // not counted in hgss set, in a building
    1147,
    ],
	
	MAP_RUINS_OF_ALPH_NORTHEAST_ENTRANCE_SECOND_ROOM: [ // Ruins of Alph / D24R0212 [ev295]
    1128,
    1129,
    1130,
    1131,
    ],
    
    MAP_RUINS_OF_ALPH_SOUTHEAST_ENTRANCE_SECOND_ROOM: [ // Ruins of Alph / D24R0213 [ev296]
    1132,
    1133,
    1134,
    1135,
    ],
    
    MAP_RUINS_OF_ALPH_NORTHWEST_ENTRANCE_SECOND_ROOM: [ // Ruins of Alph / D24R0214 [ev297]
    1140,
    1141,
    1142,
    1143,
    ],
    
    MAP_RUINS_OF_ALPH_SOUTHWEST_ENTRANCE_SECOND_ROOM: [ // Ruins of Alph / D24R0215 [ev298]
    1136,
    1137,
    1138,
    1139,
    ],
    
    MAP_SLOWPOKE_WELL_ENTRANCE: [ // SLOWPOKE Well / D26R0101
    8027,
    ],
    
    MAP_ILEX_FOREST: [ // Ilex Forest / D36R0101
    8030,
    8031,
    8032,
    8033,
    8211,
    8212,
    8213,
    8214,
    8215,
	1077,
    1084,
    1085,
    1086,
    ],
    
    MAP_MOUNT_MORTAR_1F_ENTRANCE: [ // Mt. Mortar / D38R0101
    8043,
    8044,
	1173,
    1174,
    ],
    
    MAP_ICE_PATH_1F: [ // Ice Path / D39R0101
    8070,
    8072,
	1111,
    1204,
    1205,
    ],
    
    MAP_WHIRL_ISLANDS_1F: [ // Whirl Islands / D40R0101
    8073,
	1162,
    1161,
    ],
    
    MAP_MOUNT_SILVER_CAVE_1F: [ // Mt. Silver Cave / D41R0101
    8076,
    8077,
    8201,
	1241,
    ],
    
    MAP_DARK_CAVE_ROUTE_45_SIDE: [ // Dark Cave / D42R0101
    8016,
    8017,
    8018,
	1113,
    1114,
    ],
    
    MAP_VICTORY_ROAD_1F: [ // Victory Road / D43R0101
    8080,
    8079,
	1119,
    1120,
    1121,
    ],
	
	MAP_TOHJO_FALLS: [ // Tohjo Falls / D45R0101 [ev123]
    1116,
    ],
    
    MAP_CERULEAN_CAVE_1F: [ // Cerulean Cave / D03R0101
    8093,
    8094,
    8095,
	1257,
    1260,
    1259,
    1261,
    ],
    
    MAP_SEAFOAM_ISLANDS_1F: [ // Seafoam Islands / D11R0101
    8088,
    ],
    
    MAP_VIRIDIAN_FOREST: [ // Viridian Forest / D46R0101
    8085,
    8087,
    8216,
    8217,
    8218,
    8219,
    8220,
	1234,
    1235,
    1237,
    1238,
    ],
    
    MAP_ROUTE_47: [ // Route 47 / R47
    8039,
    8040,
	1267,
    1281,
    1282,
    1283,
    ],
	
	MAP_ROUTE_48: [ // Route 48 / R48 [ev147]
    1284,
    ],
    
    MAP_UNION_CAVE_B1F: [ // Union Cave / D25R0102
    8153,
    8155,
	1072,
    1071,
    ],
	
	MAP_SPROUT_TOWER_2F: [ // Sprout Tower / D15R0102 [ev150]
    1062,
    ],
    
    MAP_SPROUT_TOWER_3F: [ // Sprout Tower / D15R0103 [ev151]
    1063,
    1064,
    ],
    
    MAP_UNION_CAVE_B2F: [ // Union Cave / D25R0103
    8156,
    8157,
	1082,
    1083,
    ],
    
    MAP_SAFARI_ZONE_GATE: [ // Safari Zone Gate / D47
    8041,
    8130,
    8131,
    ],
    
    MAP_DARK_CAVE_ROUTE_31_SIDE: [ // Dark Cave / D42R0102
    8014,
    8015,
	1218,
    1219,
    1220,
    1221,
    1292,
    ],
    
    MAP_SLOWPOKE_WELL_B1F: [ // SLOWPOKE Well / D26R0102
    8028,
    8029,
	1075,
    ],
	
	MAP_SLOWPOKE_WELL_B2F: [ // SLOWPOKE Well / D26R0103 [ev174]
    1076,
    ],
    
    MAP_VICTORY_ROAD_2F: [ // Victory Road / D43R0102
    8185,
    8186,
    8189,
	1122,
    1123,
    1124,
    ],
    
    MAP_VICTORY_ROAD_3F: [ // Victory Road / D43R0103
    8187,
    8188,
	1125,
    1126,
    1127,
    ],
    
    MAP_GOLDENROD_DEPARTMENT_STORE_BASEMENT: [ // Goldenrod City / D37R0103
    8052,
    8053,
    8067,
	1091,
    1090,
    1092,
    1093,
    ],
	
	MAP_GOLDENROD_GAME_CORNER_JP: [ // Goldenrod City / T25R1101 [ev176]
    //1200,
    ],

    MAP_GOLDENROD_TUNNEL_WAREHOUSE: [ // Goldenrod City / D37R0105
    8068,
    8069,
	1078,
    1079,
    1094,
    ],
	
	MAP_GOLDENROD_RADIO_TOWER_4F: [ // Radio Tower / D23R0104 [ev181]
    1089,
    ],
    
    MAP_GOLDENROD_TUNNEL_B2F: [ // Goldenrod City / D37R0104 [ev194]
    1095,
    1096,
    ],
    
    MAP_OLIVINE_LIGHTHOUSE_EXTERIOR: [ // Lighthouse / D27R0103 [ev207]
    1160,
    ],
	
    
    MAP_BURNED_TOWER_B1F: [ // Burned Tower / D18R0102
    8021,
    8065,
	1074,
    ],
    
    MAP_OLIVINE_LIGHTHOUSE_3F: [ // Lighthouse / D27R0104
    8066,
	1098,
    ],
	
	MAP_OLIVINE_LIGHTHOUSE_4F: [ // Lighthouse / D27R0105 [ev209]
    1099,
    ],
    
    MAP_OLIVINE_LIGHTHOUSE_5F: [ // Lighthouse / D27R0106 [ev210]
    1100,
    ],
    
    MAP_OLIVINE_LIGHTHOUSE_LIGHT_ROOM: [ // Lighthouse / D27R0107 [ev211]
    1101,
    ],
    
    MAP_ICE_PATH_B1F: [ // Ice Path / D39R0102
    8228,
	1209,
    ],
    
    MAP_ICE_PATH_B2F: [ // Ice Path / D39R0103
    8071,
	1110,
    1206,
    1207,
    ],
	
	MAP_ICE_PATH_B3F: [ // Ice Path / D39R0104 [ev225]
    1208,
    ],
    
    MAP_WHIRL_ISLANDS_B1F: [ // Whirl Islands / D40R0102
    8074,
    8191,
    8192,
    8193,
	1163,
    1164,
    1165,
    1166,
    1167,
	1168,
    1169,
    1170,
    ],
    
    MAP_WHIRL_ISLANDS_B2F: [ // Whirl Islands / D40R0104
    8075,
    ],
	
	MAP_WHIRL_ISLANDS_B3F: [ // Whirl Islands / D40R0106 [ev439]
    1171,
    ],
    
    MAP_TEAM_ROCKET_HEADQUARTERS_B1F: [ // Team Rocket HQ / D35R0102
    8051,
	1102,
    1103,
    1104,
    ],
    
    MAP_TEAM_ROCKET_HEADQUARTERS_B2F: [ // Team Rocket HQ / D35R0103
    8054,
    8055,
	1105,
    ],
	
	MAP_TEAM_ROCKET_HEADQUARTERS_B3F: [ // Team Rocket HQ / D35R0104 [ev235]
    1108,
    1109,
    1106,
    1107,
    1196,
    ],
    
    MAP_MOUNT_MORTAR_1F_BACK: [ // Mt. Mortar / D38R0102
    8045,
    8046,
    8140,
    8141,
    8142,
	1175,
    1176,
    1177,
    1178,
    1179,
    1180,
    1181,
    1194,
    1195,
    ],
    
    MAP_MOUNT_MORTAR_2F: [ // Mt. Mortar / D38R0103
    8047,
    8048,
    8143,
    8144,
	1182,
    1183,
    1184,
    1185,
    1186,
    1187,
    ],
    
    MAP_MOUNT_MORTAR_B1F: [ // Mt. Mortar / D38R0104
    8049,
    8050,
	1188,
    1189,
    1190,
    1191,
    1192,
    ],
    
    MAP_DRAGONS_DEN: [ // Dragon's Den / D44R0102
    8081,
    8083,
    8082,
	1112,
    1210,
    1211,
    ],
    
    MAP_CLIFF_EDGE_GATE: [ // Cliff Edge Gate / D48R0101
    8209,
    ],
    
    MAP_POKEATHLON_DOME: [ // Pokeathlon Dome / D49
    8159,
    8160,
    ],
    
    MAP_SS_AQUA_OLIVINE_PORT_EXTERIOR: [ // Olivine City / P01R0102
    8086,
    8158,
    ],
   
    MAP_BELL_TOWER_3F: [ // Bell Tower / D17R0103
    8062,
	1148,
    ],
	
	MAP_BELL_TOWER_4F: [ // Bell Tower / D17R0104 [ev305]
    1149,
    1150,
    1151,
    ],
    
    MAP_BELL_TOWER_5F: [ // Bell Tower / D17R0105
    8063,
	1152,
    ],
	
	MAP_BELL_TOWER_6F: [ // Bell Tower / D17R0106 [ev307]
    1153,
    1154,
    ],
    
    MAP_BELL_TOWER_7F: [ // Bell Tower / D17R0107 [ev308]
    1155,
    ],
    
    MAP_BELL_TOWER_8F: [ // Bell Tower / D17R0108
    8064,
	1156,
    1157,
    1158,
    ],
	
	MAP_BELL_TOWER_9F: [ // Bell Tower / D17R0109 [ev310]
    1159,
    ],
    
    MAP_CLIFF_CAVE: [ // Cliff Cave / D50R0101
    8226,
    ],
    
    MAP_SS_AQUA_VERMILION_PORT_EXTERIOR: [ // Vermilion City / P01R0104
    8084,
    ],
    
    MAP_BATTLE_FRONTIER_FRONTIER_ACCESS: [ // Frontier Access / D32R0102
    8161,
    ],
    
    MAP_MOUNT_MOON_SQUARE: [ // Mt. Moon / D02R0103
    8196,
    ],
    
    MAP_CERULEAN_CAVE_2F: [ // Cerulean Cave / D03R0102
    8096,
    8117,
    8118,
    8119,
    8120,
    8221,
	1262,
    1264,
    1263,
    1265,
    ],
    
    MAP_CERULEAN_CAVE_B1F: [ // Cerulean Cave / D03R0103
    8121,
    8123,
    8124,
	1268,
    1269,
    1270,
    1271,
    1272,
    ],
    
    MAP_ROCK_TUNNEL_B1F: [ // Rock Tunnel / D05R0102
    8061,
    8169,
	1224,
    1225,
    1226,
    1296,
    ],
    
    MAP_SEAFOAM_ISLANDS_B1F: [ // Seafoam Islands / D11R0102
    8089,
	1256,
    1251,
    ],
    
    MAP_SEAFOAM_ISLANDS_B2F: [ // Seafoam Islands / D11R0103
    8090,
    8091,
	1252,
    ],
    
    MAP_SEAFOAM_ISLANDS_B3F: [ // Seafoam Islands / D11R0104
    8092,
    8210,
	1253,
    1254,
    ],
    
    MAP_SEAFOAM_ISLANDS_B4F: [ // Seafoam Islands / D11R0105
    8223,
	1255,
    1258,
    ],
    
    MAP_MOUNT_SILVER_CAVE_UPPER_MOUNTAINSIDE: [ // Mt. Silver Cave / D41R0102
    8165,
    8204,
    8205,
	1242,
    1243,
    ],
	
	MAP_MOUNT_SILVER_CAVE_LOWER_MOUNTAINSIDE: [ // Mt. Silver Cave / D41R0103 [ev414]
    1244,
    1245,
    ],
    
    MAP_MOUNT_SILVER_CAVE_EXPERT_BELT_CHAMBER: [ // Mt. Silver Cave / D41R0104 [ev415]
    1246,
    ],
    
    MAP_MOUNT_SILVER_CAVE_MOLTRES_CHAMBER: [ // Mt. Silver Cave / D41R0105
    8202,
    8203,
    ],
    
    MAP_MOUNT_SILVER_CAVE_2F: [ // Mt. Silver Cave / D41R0106
    8078,
    8222,
	1247,
    1248,
    1249,
    1250,
    ],
    
    MAP_MOUNT_SILVER_CAVE_3F: [ // Mt. Silver Cave / D41R0107
    8206,
    ],
    
    MAP_NATIONAL_PARK_BUG_CATCHING_CONTEST: [ // National Park / D22R0102
    8034,
    8035,
	//1145,
    //1144,
    //1286,
    ],
	
    MAP_MOUNT_MOON_SQUARE_CLEFAIRY_EVENT: [ // Mt. Moon / D02R0104
    8196,
	//664,
    ],
    
    MAP_ROUTE_5_UNDERGROUND_PATH: [ // Route 5 / R05R0202
    8057,
    8058,
    ],
}

function totalTrainersGroups(groups) { 
    i = 0
    for g in groups {
            i = i + length(MAP_TRAINERS[g])
        }
        return i
    }
function sumTrainerGroups(groups) {
    i = 0
    for g in groups {
            for f in MAP_TRAINERS[g] {
            i = i + trainer_flag(f)
            
            }
            
        }
        return i
} 

function achTrainersDefeated(group) => measured(sumTrainerGroups(group) == totalTrainersGroups(group)) &&
        prev(sumTrainerGroups(group)) >= totalTrainersGroups(group) - 2 &&
        prev(sumTrainerGroups(group)) < totalTrainersGroups(group) &&
        unless(save_ptr() != prev(save_ptr())) &&
        unless(dword(REGION_PTR_ADDR) != prev(dword(REGION_PTR_ADDR))) &&
        unless(!inGame())

function totalItemsGroups(groups) {
    i = 0
    for g in groups {
        i = i + length(MAP_ITEMS[g])
    }
    return i
}

function sumItemsGroups(groups) {
    i = 0
    for g in groups {
        for f in MAP_ITEMS[g] {
            if (f >= 8000) {
                i = i + flag(f - 8000 + 800)
            } else {
                i = i + flag(f)
            }
        }
    }
    return i
}

function achItemsFound(groups) => measured(sumItemsGroups(groups) == totalItemsGroups(groups)) &&
        prev(sumItemsGroups(groups)) >= totalItemsGroups(groups) - 2 &&
        prev(sumItemsGroups(groups)) < totalItemsGroups(groups) &&
        unless(save_ptr() != prev(save_ptr())) &&
        unless(dword(REGION_PTR_ADDR) != prev(dword(REGION_PTR_ADDR))) &&
        unless(!inGame())

GenderLookup = {
    0: "♂",
    1: "♀"
}

rp_field_map = rich_presence_lookup("Map", currMapID(), AreaLookup, fallback="???")
rp_battle_trainer = rich_presence_lookup("Trainer", battleTrainer(), TrainerLookup)
rp_battle_trainer_s = rich_presence_lookup("TrainerS", battleTrainer(), TrainerLookupS, fallback="s")
function rp_battle_species(i) => rich_presence_lookup("PkmnSpecies", battleMonSpecies(i), PkmnLookup)
function rp_battle_level(i) => rich_presence_value("PkmnLvl", battleMonLevel(i))
function rp_battle_gender(i) => rich_presence_lookup("PkmnGender", battleMonGender(i), GenderLookup)
rp_num_badges = rich_presence_value("Badges", sumBadges())
rp_playtime = rich_presence_value("Playtime", igtTotalSecs(), "SECS")
rp_pkmn_caught_total = rich_presence_value("PkmnCaught", sumPkmnCaught())
rp_pkmn_seen_total = rich_presence_value("PkmnSeen", sumPkmnSeen())


rich_presence_conditional_display(isActiveOverlay(0) && currentOverlayID(0) == OV_INTRO_TITLE,"Viewing Title Screen")
rich_presence_conditional_display(isActiveOverlay(0) && currentOverlayID(0) == OV_MAINMENU,"Viewing Main Menu")
rich_presence_conditional_display(inGame() && isActiveOverlay(0) && currentOverlayID(0) == OV_OAKSSPEECH,"New Game")
rich_presence_conditional_display(inGame() && isActiveOverlay(0) && currentOverlayID(0) == OV_WIIMESSAGE,"Viewing Wii Message")
rich_presence_conditional_display(inGame() && isActiveOverlay(0) && currentOverlayID(0) == OV_WIFISETTINGS,"Viewing Wifi Settings")

// Trainer Battle - Double //TODO: test with Dragon's Den double battle
rich_presence_conditional_display(inGame() && isActiveOverlay(0) && currentOverlayID(0) == OV_BATTLE && isTrainerBattle() && isDoubleBattle(),"⚔️{2} {6}Lv{4}, {13} {14}Lv{15} vs {0}'{12} {3} {7}Lv{5}, {16} {17}Lv{18} 🗺️{1} 🎖️{8} 🔴{10} 👁️{11} 🕒{9}",
    rp_battle_trainer,
    rp_field_map,
    rp_battle_species(0),
    rp_battle_species(1),
    rp_battle_level(0),
    rp_battle_level(1),
    rp_battle_gender(0),
    rp_battle_gender(1),
    rp_num_badges,
    rp_playtime,
    rp_pkmn_caught_total,
    rp_pkmn_seen_total,
    rp_battle_trainer_s,
    rp_battle_species(2),
    rp_battle_gender(2),
    rp_battle_level(2),
    rp_battle_species(3),
    rp_battle_gender(3),
    rp_battle_level(3)
)


// Trainer Battle - Single
rich_presence_conditional_display(inGame() && isActiveOverlay(0) && currentOverlayID(0) == OV_BATTLE && isTrainerBattle(),"⚔️{2} {6}Lv{4} vs {0}'{12} {3} {7}Lv{5} 🗺️{1} 🎖️{8} 🔴{10} 👁️{11} 🕒{9}",
    rp_battle_trainer,
    rp_field_map,
    rp_battle_species(0),
    rp_battle_species(1),
    rp_battle_level(0),
    rp_battle_level(1),
    rp_battle_gender(0),
    rp_battle_gender(1),
    rp_num_badges,
    rp_playtime,
    rp_pkmn_caught_total,
    rp_pkmn_seen_total,
    rp_battle_trainer_s
)

// Wild Battle
rich_presence_conditional_display(inGame() && isActiveOverlay(0) && currentOverlayID(0) == OV_BATTLE,"⚔️{2} {6}Lv{4} vs {3} {7}Lv{5} 🗺️{1} 🎖️{8} 🔴{10} 👁️{11} 🕒{9}",
    rp_battle_trainer,
    rp_field_map,
    rp_battle_species(0),
    rp_battle_species(1),
    rp_battle_level(0),
    rp_battle_level(1),
    rp_battle_gender(0),
    rp_battle_gender(1),
    rp_num_badges,
    rp_playtime,
    rp_pkmn_caught_total,
    rp_pkmn_seen_total,
    rp_battle_trainer_s
)

rich_presence_conditional_display(inGame() /*&& currentOverlayID(0) == OV_FIELD*/,"🗺️{0} 🎖️{1} 🔴{3} 👁️{4} 🕒{2}",
    rp_field_map,
    rp_num_badges,
    rp_playtime,
    rp_pkmn_caught_total,
    rp_pkmn_seen_total
)

/*
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_VSRECORDER,"Viewing VS Recorder")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_PALPAD,"Viewing Pal Pad")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_BAG,"Viewing Bag")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_BERRYPOTS,"Viewing Berry Pots")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_APRICORNBOX,"Viewing Apricorn Box")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_UNOWN_REPORT,"Viewing UNOWN Report")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_POKEDEX,"Viewing Pokedex")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_TRAINERCARD,"Viewing Trainer Card")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_OPTIONS,"Viewing Options")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_PC_BOX,"Viewing PC Box")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_CAPSULES,"Viewing Capsules")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_MAILBOX,"Viewing Mailbox")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_PHOTOALBUM,"Viewing Photo Album")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_HALLOFFAME,"Viewing Hall of Fame")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_POKEGEAR,"Viewing Pokegear")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_MAP,"Viewing Map")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_SAFARICUSTOMIZER,"Viewing Safari Customizer")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_POKEWALKER,"Viewing Pokewalker")
rich_presence_conditional_display(inGame() && currentOverlayID(0) == OV_CHOOSE_STARTER,"Choosing Starter")

rich_presence_conditional_display(inGame(),"[unknown overlay] {0}",
    rich_presence_value("Overlay", currentOverlayID(0))
)*/

rich_presence_display("Loading...")


achs_reg = [
    //["_test","name rival",0,achFlagInMap(FLAG_GAVE_RIVAL_NAME_TO_OFFICER,MAP_NEW_BARK_ELMS_LAB_1F)],
    //["test_trainer","",0,battleTrainer() == 0x111],
    //["test_trainer2","",0,heapIndex(5) == 0x6],
    //["test_trainer3","",0,dword(heap(5)) == 0x6],
    //["test_battlemon_species","",0,battleMonSpecies(0) == 0x6],

["Rock Smash","Defeat Brock and earn the Boulder Badge",5,achKantoBadgeObtained(BADGE_BOULDER)],
["Fishing Trip","Defeat Misty and earn the Cascade Badge",5,achKantoBadgeObtained(BADGE_CASCADE)],
["The Badge of a Lieutenant","Defeat Lt. Surge and earn the Thunder Badge",5,achKantoBadgeObtained(BADGE_THUNDER)],
["As Beautiful As Ever","Defeat Erika and earn the Rainbow Badge",5,achKantoBadgeObtained(BADGE_RAINBOW)],
["The New Generation","Defeat Janine and earn the Soul Badge",5,achKantoBadgeObtained(BADGE_SOUL)],
["Besting the Genius","Defeat Sabrina and earn the Marsh Badge",5,achKantoBadgeObtained(BADGE_MARSH)],
["The Fire Specialist at the Core of the Island","Defeat Blaine and earn the Volcano Badge",5,achKantoBadgeObtained(BADGE_VOLCANO)],
["A Full Badge Collection","Defeat Blue and earn the Earth Badge",5,achKantoBadgeObtained(BADGE_EARTH)],
// Defeat the Elite Four in the second league and enter the Hall of Fame
// Defeat Red on Mt. Silver
// Enter the Violet City Gym without any Pokémon above level 13 and defeat every trainer on Set mode without leaving or using Rock type Pokémon
// Enter the Azalea Town Gym without any Pokémon above level 17 and defeat every trainer on Set mode without leaving or using Rock, Flying, or Fire type Pokémon
// Enter the Goldenrod City Gym without any Pokémon above level 19 and defeat every trainer on Set mode without leaving or using Fighting, Rock, or Ghost type Pokémon
// Enter the Ecruteak City Gym without any Pokémon above level 25 and defeat every trainer on Set mode without leaving or using Ghost, Psychic, or Normal type Pokémon
// Enter the Cianwood City Gym without any Pokémon above level 31 and defeat every trainer on Set mode without leaving or using Flying or Psychic type Pokémon
// Enter the Olivine City Gym without any Pokémon above level 35 and defeat every trainer on Set mode without leaving or using Fire, Fighting, or Ground type Pokémon
// Enter the Mahogany Town Gym without any Pokémon above level 34 and defeat every trainer on Set mode without leaving or using Fire, Fighting, or Rock type Pokémon
// Enter the Blackthorn City Gym without any Pokémon above level 41 and defeat every trainer on Set mode without leaving or using Ice or Electric type Pokémon
// Defeat the Elite Four and the Champ in the first league during a single session, all in Set Mode with Pokemon starting battle at level 45 or less and without using bag items
// Enter the Pewter City Gym without any Pokémon above level 54 and defeat every trainer on Set mode without leaving or using Water or Grass type Pokémon
// Enter the Cerulean City Gym without any Pokémon above level 54 and defeat every trainer on Set mode without leaving or using Grass or Electric type Pokémon
// Enter the Vermilion City Gym without any Pokémon above level 53 and defeat every trainer on Set mode without leaving or using Rock or Ground type Pokémon
// Enter the Celadon City Gym without any Pokémon above level 56 and defeat every trainer on Set mode without leaving or using Fire or Ice type Pokémon
// Enter the Fuschia City Gym without any Pokémon above level 50 and defeat every trainer on Set mode without leaving or using Ground, Fire, or Psychic type Pokémon
// Enter the Saffron City Gym without any Pokémon above level 55 and defeat every trainer on Set mode without leaving or using Ghost or Dark type Pokémon
// Enter the Seafoam Islands Gym without any Pokémon above level 59 and defeat every trainer on Set mode without leaving or using Water, Rock, or Ground type Pokémon
// Enter the Viridian City Gym without any Pokémon above level 60 and defeat every trainer on Set mode without leaving or using Water or Ice type Pokémon
// Defeat the Elite Four and the Champ in the second league during a single session, all in Set Mode with Pokemon starting battle at level 70 or less and without using bag items
// Obtain the Silver Print in the Battle Tower 
// Obtain the Gold Print in the Battle Tower
// Obtain the Silver Print in the Battle Factory
// Obtain the Gold Print in the Battle Factory
// Obtain the Silver Print in the Battle Hall
// Obtain the Gold Print in the Battle Hall
// Obtain the Silver Print in the Battle Castle
// Obtain the Gold Print in the Battle Castle
// Obtain the Silver Print in the Battle Arcade
// Obtain the Gold Print in the Battle Arcade
// Reach a streak of 100 wins in the Battle Tower and obtain a Trainer Card star
// Obtain every Gym Leader's Pokegear number
// Defeat Falkner in the Fighting Dojo using only non-legendary Johto Pokemon at level 60 or less and without using bag items
// Defeat Bugsy in the Fighting Dojo using only non-legendary Johto Pokemon at level 60 or less and without using bag items
// Defeat Whitney in the Fighting Dojo using only non-legendary Johto Pokemon at level 60 or less and without using bag items
// Defeat Morty in the Fighting Dojo using only non-legendary Johto Pokemon at level 60 or less and without using bag items
// Defeat Chuck in the Fighting Dojo using only non-legendary Johto Pokemon at level 60 or less and without using bag items
// Defeat Jasmine in the Fighting Dojo using only non-legendary Johto Pokemon at level 60 or less and without using bag items
// Defeat Pryce in the Fighting Dojo using only non-legendary Johto Pokemon at level 60 or less and without using bag items
// Defeat Clair in the Fighting Dojo using only non-legendary Johto Pokemon at level 60 or less and without using bag items
// Defeat Brock in the Fighting Dojo using only non-legendary Johto Pokemon at level 60 or less and without using bag items
// Defeat Misty in the Fighting Dojo using only non-legendary Johto Pokemon at level 60 or less and without using bag items
// Defeat Lt. Surge in the Fighting Dojo using only non-legendary Johto Pokemon at level 60 or less and without using bag items
// Defeat Erika in the Fighting Dojo using only non-legendary Johto Pokemon at level 60 or less and without using bag items
// Defeat Janine in the Fighting Dojo using only non-legendary Johto Pokemon at level 60 or less and without using bag items
// Defeat Sabrina in the Fighting Dojo using only non-legendary Johto Pokemon at level 60 or less and without using bag items
// Defeat Blaine in the Fighting Dojo using only non-legendary Johto Pokemon at level 60 or less and without using bag items
// Defeat Blue in the Fighting Dojo using only non-legendary Johto Pokemon at level 60 or less and without using bag items
// Catch all 221 Pokemon in the Johto Pokedex without events or external trades
// Catch all 371 Pokemon in the National Pokedex without events or external trades
// Catch all Pokemon that can be found by Headbutting trees
// Catch all Pokemon that can be found via Hoenn Sound
// Catch all Pokemon that can be found via Sinnoh Sound
// Catch all Pokemon that can be found in the Safari Zone
// Catch all Pokemon that can be found in Swarms
// Catch all Pokemon that can be found during the Bug Catching Contest
["The Silvered Soul","Catch Lugia in the Whirl Islands",10,achFlagAnyMap(FLAG_CAUGHT_LUGIA)],
["The Golden Heart","Catch Ho-Oh on the Bell Tower",10,achFlagAnyMap(FLAG_CAUGHT_HO_OH)],
["Aurora Borealis","Catch Suicune",5,achFlagAnyMap(FLAG_CAUGHT_SUICUNE)],
// Catch Raikou
// Catch Entei
["Mr. Fuji's Creation","Catch Mewtwo in Cerulean Cave",5,achFlagAnyMap(FLAG_CAUGHT_MEWTWO)],
["Chilling Wind","Catch Articuno in the Seafoam Islands",5,achFlagAnyMap(FLAG_CAUGHT_ARTICUNO)],
["Directly from Thunderclouds","Catch Zapdos outside the Power Plant on Route 10",5,achFlagAnyMap(FLAG_CAUGHT_ZAPDOS)],
["Blazing Plumes","Catch Moltres in Silver Cave",5,achFlagAnyMap(FLAG_CAUGHT_MOLTRES)],
// Catch Latios
["The Avatar of Land","Catch Groudon in the Hidden Tower",5,achFlagAnyMap(FLAG_CAUGHT_GROUDON)],
["The Sweet Smell of Babies","Obtain every Incense",5,achFlagGroup(GROUP_FLAG_INCENSE)],
// Obtain every Plate
["Blowhard","Obtain every colored Flute",5,achFlagGroup(GROUP_FLAG_FLUTE)],

["Hometown Collector","Find every item and hidden item in New Bark Town, Route 29, Cherrygrove City, and Route 30",3,achItemsFound([
MAP_NEW_BARK, // New Bark Town / T20
MAP_ROUTE_29, // Route 29 / R29 [ev30]
MAP_CHERRYGROVE, // Cherrygrove City / T21
MAP_ROUTE_30, // Route 30 / R30 [ev31]
])],
["Treasures with Nostalgic Scents","Find every item and hidden item in Route 31, Violet City, and Sprout Tower",3,achItemsFound([
MAP_ROUTE_31, // Route 31 / R31 [ev32]
MAP_VIOLET, // Violet City / T22 [ev70]
MAP_SPROUT_TOWER_1F, // Sprout Tower / D15R0101 [ev107]
MAP_SPROUT_TOWER_2F, // Sprout Tower / D15R0102 [ev150]
MAP_SPROUT_TOWER_3F, // Sprout Tower / D15R0103 [ev151]
])],
["Archeological Digs","Find every item and hidden item in Route 32, Ruins of Alph, and Union Cave",3,achItemsFound([
MAP_ROUTE_32, // Route 32 / R32 [ev33]
MAP_RUINS_OF_ALPH, // Ruins of Alph / D24R0101 [ev110]
MAP_RUINS_OF_ALPH_NORTHEAST_ENTRANCE_SECOND_ROOM, // Ruins of Alph / D24R0212 [ev295]
MAP_RUINS_OF_ALPH_SOUTHEAST_ENTRANCE_SECOND_ROOM, // Ruins of Alph / D24R0213 [ev296]
MAP_RUINS_OF_ALPH_NORTHWEST_ENTRANCE_SECOND_ROOM, // Ruins of Alph / D24R0214 [ev297]
MAP_RUINS_OF_ALPH_SOUTHWEST_ENTRANCE_SECOND_ROOM, // Ruins of Alph / D24R0215 [ev298]
MAP_RUINS_OF_ALPH, // Ruins of Alph / D24R0101
MAP_UNION_CAVE_B1F, // Union Cave / D25R0102 [ev148]
MAP_UNION_CAVE_B2F, // Union Cave / D25R0103 [ev149]
MAP_UNION_CAVE_1F, // Union Cave / D25R0101 [ev96]
])],
["Living Happily with Freebies","Find every item and hidden item in Azalea Town, Slowpoke Well, Ilex Forest, and Route 34",3,achItemsFound([
MAP_AZALEA, // Azalea Town / T23
MAP_SLOWPOKE_WELL_ENTRANCE, // SLOWPOKE Well / D26R0101
MAP_SLOWPOKE_WELL_B1F, // SLOWPOKE Well / D26R0102 [ev170]
MAP_SLOWPOKE_WELL_B2F, // SLOWPOKE Well / D26R0103 [ev174]
MAP_ILEX_FOREST, // Ilex Forest / D36R0101 [ev114]
MAP_ROUTE_34, // Route 34 / R34 [ev35]
])],
["Coastal Pickups","Find every item and hidden item in Goldrod City, Goldenrod Department Center, Goldenrod Radio Tower, Goldenrod Tunnel",3,achItemsFound([
MAP_GOLDENROD, // Goldenrod City / T25
MAP_GOLDENROD_GAME_CORNER_JP, // Goldenrod City / T25R1101 [ev176]
MAP_GOLDENROD_RADIO_TOWER_4F, // Radio Tower / D23R0104 [ev181]
MAP_GOLDENROD_DEPARTMENT_STORE_BASEMENT, // Goldenrod City / D37R0103 [ev193]
MAP_GOLDENROD_TUNNEL_B2F, // Goldenrod City / D37R0104 [ev194]
MAP_GOLDENROD_TUNNEL_WAREHOUSE, // Goldenrod City / D37R0105 [ev195]
])],
["Cleaning Up Litter at the Park","Find every item and hidden item in Route 35, Route 36, the Pokeathlon Dome, and the National Park",3,achItemsFound([
MAP_ROUTE_35, // Route 35 / R35 [ev36]
MAP_ROUTE_36, // Route 36 / R36 [ev37]
MAP_POKEATHLON_DOME, // Pokeathlon Dome / D49
MAP_NATIONAL_PARK, // National Park / D22R0101 [ev93]
MAP_NATIONAL_PARK_BUG_CATCHING_CONTEST, // National Park / D22R0102 [ev440]
])],
["A Historical Collection","Find every item and hidden item in Ecruteak City, the Burned Tower, Route 38, and Route 39",3,achItemsFound([
MAP_ECRUTEAK, // Ecruteak City / T27
MAP_BURNED_TOWER_1F, // Burned Tower / D18R0101 [ev5]
MAP_BURNED_TOWER_B1F, // Burned Tower / D18R0102 [ev204]
MAP_ROUTE_38, // Route 38 / R38 [ev39]
MAP_ROUTE_39, // Route 39 / R39 [ev40]
])],
["Legendary Crumbs Left Here and There","Find every item and hidden item on Bellchime Trail and in the Bell Tower",3,achItemsFound([
MAP_BELLCHIME_TOWER, // Bellchime Trail / D17R1101
MAP_BELL_TOWER_3F, // Bell Tower / D17R0103 [ev304]
MAP_BELL_TOWER_4F, // Bell Tower / D17R0104 [ev305]
MAP_BELL_TOWER_5F, // Bell Tower / D17R0105 [ev306]
MAP_BELL_TOWER_6F, // Bell Tower / D17R0106 [ev307]
MAP_BELL_TOWER_7F, // Bell Tower / D17R0107 [ev308]
MAP_BELL_TOWER_8F, // Bell Tower / D17R0108 [ev309]
MAP_BELL_TOWER_9F, // Bell Tower / D17R0109 [ev310]
])],
["The Port the Sea-crets","Find every item and hidden item in Olivine City, Glitter Lighthouse, Route 40, and the Frontier Access",3,achItemsFound([
MAP_SS_AQUA_OLIVINE_PORT_EXTERIOR, // Olivine City / P01R0102
MAP_OLIVINE, // Olivine City / T26 [ev74]
MAP_OLIVINE_LIGHTHOUSE_EXTERIOR, // Lighthouse / D27R0103 [ev207]
MAP_OLIVINE_LIGHTHOUSE_3F, // Lighthouse / D27R0104 [ev208]
MAP_OLIVINE_LIGHTHOUSE_4F, // Lighthouse / D27R0105 [ev209]
MAP_OLIVINE_LIGHTHOUSE_5F, // Lighthouse / D27R0106 [ev210]
MAP_OLIVINE_LIGHTHOUSE_LIGHT_ROOM, // Lighthouse / D27R0107 [ev211]
MAP_ROUTE_40, // Route 40 / W40 [ev91]
MAP_BATTLE_FRONTIER_FRONTIER_ACCESS, // Frontier Access / D32R0102
])],
["A Port of Crashing Leftovers","Find every item and hidden item in Cianwood City, Cliff Edge Gate, Cliff Cave, Route 47, Route 48, and the Safari Zone Gate",3,achItemsFound([
MAP_CIANWOOD, // Cianwood City / T24
MAP_CLIFF_EDGE_GATE, // Cliff Edge Gate / D48R0101
MAP_CLIFF_CAVE, // Cliff Cave / D50R0101
MAP_ROUTE_47, // Route 47 / R47 [ev146]
MAP_ROUTE_48, // Route 48 / R48 [ev147]
MAP_SAFARI_ZONE_GATE, // Safari Zone Gate / D47
])],
["Shinies in the Cenote","Find every item and hidden item in Mt. Mortar",3,achItemsFound([
MAP_MOUNT_MORTAR_1F_BACK, // Mt. Mortar / D38R0102 [ev236]
MAP_MOUNT_MORTAR_2F, // Mt. Mortar / D38R0103 [ev237]
MAP_MOUNT_MORTAR_B1F, // Mt. Mortar / D38R0104 [ev238]
MAP_MOUNT_MORTAR_1F_ENTRANCE, // Mt. Mortar / D38R0101 [ev116]
])],
["Gyarados' Trove","Find every item and hidden item in Route 42, Route 43, and the Lake of Rage",3,achItemsFound([
MAP_ROUTE_42, // Route 42 / R42 [ev41]
MAP_ROUTE_43, // Route 43 / R43 [ev42]
MAP_LAKE_OF_RAGE, // Lake of Rage / T29 [ev85]
])],
["Illegal Riches","Find every item and hidden item in the Team Rocket HQ",3,achItemsFound([
MAP_TEAM_ROCKET_HEADQUARTERS_B1F, // Team Rocket HQ / D35R0102 [ev233]
MAP_TEAM_ROCKET_HEADQUARTERS_B2F, // Team Rocket HQ / D35R0103 [ev234]
MAP_TEAM_ROCKET_HEADQUARTERS_B3F, // Team Rocket HQ / D35R0104 [ev235]
])],
["Frosty Surprises","Find every item and hidden item in Route 44 and the Ice Path",3,achItemsFound([
MAP_ROUTE_44, // Route 44 / R44 [ev43]
MAP_ICE_PATH_B1F, // Ice Path / D39R0102 [ev223]
MAP_ICE_PATH_B2F, // Ice Path / D39R0103 [ev224]
MAP_ICE_PATH_B3F, // Ice Path / D39R0104 [ev225]
MAP_ICE_PATH_1F, // Ice Path / D39R0101 [ev117]
])],
["Sweeping the Den's Floor","Find every item and hidden item in the Dragon's Den and Route 45",3,achItemsFound([
MAP_DRAGONS_DEN, // Dragon's Den / D44R0102 [ev239]
MAP_ROUTE_45, // Route 45 / R45 [ev44]
])],
["Lost and Found in the Darkness","Find every item and hidden item in the Dark Cave and Route 46",3,achItemsFound([
MAP_DARK_CAVE_ROUTE_45_SIDE, // Dark Cave / D42R0101 [ev120]
MAP_DARK_CAVE_ROUTE_31_SIDE, // Dark Cave / D42R0102 [ev169]
MAP_ROUTE_46, // Route 46 / R46 [ev45]
])],
["The Grand Connection and its Hidden Good Stuff","Find every item and hidden item in Route 27, Tohjo Falls, and Route 26",3,achItemsFound([
MAP_ROUTE_27, // Route 27 / R27 [ev28]
MAP_TOHJO_FALLS, // Tohjo Falls / D45R0101 [ev123]
MAP_ROUTE_26, // Route 26 / R26 [ev27]
])],
["Recovering Everything Ditched on the Road to Victory","Find every item and hidden item in Victory Road and the Indigo Plateau",3,achItemsFound([
MAP_VICTORY_ROAD_2F, // Victory Road / D43R0102 [ev171]
MAP_VICTORY_ROAD_3F, // Victory Road / D43R0103 [ev172]
MAP_VICTORY_ROAD_1F, // Victory Road / D43R0101
MAP_INDIGO_PLATEAU, // Indigo Plateau / T10
])],
["Nuggets and Precious Gems Whirling About","Find every item and hidden item in Route 41 and the Whirl Islands",3,achItemsFound([
MAP_ROUTE_41, // Route 41 / W41
MAP_WHIRL_ISLANDS_1F, // Whirl Islands / D40R0101 [ev118]
MAP_WHIRL_ISLANDS_B1F, // Whirl Islands / D40R0102 [ev228]
MAP_WHIRL_ISLANDS_B2F, // Whirl Islands / D40R0104 [ev229]
MAP_WHIRL_ISLANDS_B3F, // Whirl Islands / D40R0106 [ev439]
])],
["The Eternal Green Junk","Find every item and hidden item in Vermilion City, Route 11, and Route 6",3,achItemsFound([
MAP_VERMILION, // Vermilion City / T06 [ev51]
MAP_SS_AQUA_VERMILION_PORT_EXTERIOR, // Vermilion City / P01R0104
MAP_ROUTE_11, // Route 11 / R11 [ev16]
MAP_ROUTE_6, // Route 6 / R06 [ev11]
])],
["What the Land of Commerce Throws Away","Find every item and hidden item in Route 5, Route 7, and Route 8",3,achItemsFound([
MAP_ROUTE_7, // Route 7 / R07 [ev12]
MAP_ROUTE_8, // Route 8 / R08 [ev13]
MAP_ROUTE_5_UNDERGROUND_PATH, // Route 5 / R05R0202
])],
["Dabbling in the Dark","Find every item and hidden item in the Rock Tunnel, Route 9, and Route 10",3,achItemsFound([
MAP_ROCK_TUNNEL_1F, // Rock Tunnel / D05R0101 [ev105]
MAP_ROCK_TUNNEL_B1F, // Rock Tunnel / D05R0102 [ev407]
MAP_ROUTE_9, // Route 9 / R09 [ev14]
MAP_ROUTE_10_SOUTH, // Route 10 / R10R0101 [ev345]
MAP_ROUTE_10, // Route 10 / R10
])],
["The Mysterious Blue Ground Nuggets","Find every item and hidden item in Cerulean City, Cerulean Cave, Route 24, and Route 25",3,achItemsFound([
MAP_CERULEAN, // Cerulean City / T04
MAP_ROUTE_25, // Route 25 / R25 [ev26]
])],
["Rainbow Dream of Free Samples","Find every item and hidden item in Celadon City, Route 17, and Fuchsia City",3,achItemsFound([
MAP_CELADON, // Celadon City / T07 [ev52]
MAP_ROUTE_17, // Route 17 / R17
MAP_FUCHSIA, // Fuchsia City / T08
])],
["The Digletts Must Have Dug These Out","Find every item and hidden item in Diglett's Cave, Route 12, Route 13, Route 14, and Route 15",3,achItemsFound([
MAP_DIGLETT_CAVE, // DIGLETT's Cave / D01R0101 [ev103]
MAP_ROUTE_12, // Route 12 / R12 [ev17]
MAP_ROUTE_13, // Route 13 / R13
MAP_ROUTE_15, // Route 15 / R15 [ev20]
])],
["Moonlight Collector","Find every item and hidden item in Pewter City, Route 3, Route 4, and Mt. Moon",3,achItemsFound([
MAP_PEWTER, // Pewter City / T03 [ev48]
MAP_ROUTE_3, // Route 3 / R03 [ev8]
MAP_ROUTE_4, // Route 4 / R04 [ev9]
MAP_MOUNT_MOON, // Mt. Moon / D02R0101
MAP_MOUNT_MOON_SQUARE, // Mt. Moon / D02R0103
MAP_MOUNT_MOON_SQUARE_CLEFAIRY_EVENT, // Mt. Moon / D02R0104 [ev465]
])],
["Robbing Bees Blind","Find every item and hidden item in Viridian City, Viridian Forest, and Route 2",3,achItemsFound([
MAP_VIRIDIAN, // Viridian City / T02
MAP_VIRIDIAN_FOREST, // Viridian Forest / D46R0101 [ev143]
MAP_ROUTE_2, // Route 2 / R02 [ev7]
MAP_ROUTE_2_EAST, // Route 2 / R02R0101 [ev370]
])],
["Cool Wind and Cool Findings","Find every item and hidden item in Cinnabar Island, Route 19, Route 20, and Route 21",3,achItemsFound([
MAP_CINNABAR_ISLAND, // Cinnabar Island / T09 [ev54]
MAP_ROUTE_19, // Route 19 / W19 [ev88]
MAP_ROUTE_20, // Route 20 / W20
MAP_ROUTE_21, // Route 21 / W21
])],
["Pillaging the Archipelago","Find every item and hidden item in the Seafoam Islands",3,achItemsFound([
MAP_SEAFOAM_ISLANDS_1F, // Seafoam Islands / D11R0101
MAP_SEAFOAM_ISLANDS_B1F, // Seafoam Islands / D11R0102 [ev408]
MAP_SEAFOAM_ISLANDS_B2F, // Seafoam Islands / D11R0103 [ev409]
MAP_SEAFOAM_ISLANDS_B3F, // Seafoam Islands / D11R0104 [ev410]
MAP_SEAFOAM_ISLANDS_B4F, // Seafoam Islands / D11R0105 [ev411]
])],
["Treasure from the Cave of Legends","Find every item and hidden item in Mt. Silver and Route 28",3,achItemsFound([
MAP_ROUTE_28, // Route 28 / R28 [ev29]
MAP_MOUNT_SILVER, // Mt. Silver / T31 [ev87]
MAP_MOUNT_SILVER_CAVE_1F, // Mt. Silver Cave / D41R0101 [ev119]
MAP_MOUNT_SILVER_CAVE_MOLTRES_CHAMBER, // Mt. Silver Cave / D41R0105
MAP_MOUNT_SILVER_CAVE_3F, // Mt. Silver Cave / D41R0107
MAP_MOUNT_SILVER_CAVE_UPPER_MOUNTAINSIDE, // Mt. Silver Cave / D41R0102 [ev413]
MAP_MOUNT_SILVER_CAVE_LOWER_MOUNTAINSIDE, // Mt. Silver Cave / D41R0103 [ev414]
MAP_MOUNT_SILVER_CAVE_EXPERT_BELT_CHAMBER, // Mt. Silver Cave / D41R0104 [ev415]
MAP_MOUNT_SILVER_CAVE_2F, // Mt. Silver Cave / D41R0106 [ev417]
]
)],
["These Smell Like Clones","Find every item and hidden item in Cerulean Cave",3,achItemsFound([
MAP_CERULEAN_CAVE_1F, // Cerulean Cave / D03R0101 [ev141]
MAP_CERULEAN_CAVE_2F, // Cerulean Cave / D03R0102 [ev405]
MAP_CERULEAN_CAVE_B1F, // Cerulean Cave / D03R0103 [ev406]
])],

["The World Tour Begins","Defeat every unmissable trainer in Route 30, Route 31, and Sprout Tower",3,achTrainersDefeated([MAP_ROUTE_30, MAP_ROUTE_31, MAP_SPROUT_TOWER_1F, MAP_SPROUT_TOWER_2F, MAP_SPROUT_TOWER_3F, MAP_VIOLET_GYM])],
["Rumor of a Promising Trainer","Defeat every unmissable trainer in Route 32, Route 33, Ruins of Alph, and Union Cave",3,achTrainersDefeated([MAP_ROUTE_32, MAP_ROUTE_33, MAP_RUINS_OF_ALPH, MAP_UNION_CAVE_1F, MAP_UNION_CAVE_B1F, MAP_UNION_CAVE_B2F])],
    //TODO: route 33 was moved into above achievement, only 1 trainer
["A Champion in the Making","Defeat every unmissable trainer in Route 34, Route 35, and the Goldenrod Tunnel",3,achTrainersDefeated([MAP_ROUTE_34, MAP_ROUTE_35, MAP_GOLDENROD_TUNNEL_B1F, MAP_GOLDENROD_TUNNEL_B2F, MAP_GOLDENROD_TUNNEL_WAREHOUSE])],
["Will Accept Any Challenge","Defeat every unmissable trainer in National Park, Route 36, Route 37, and the Burned Tower",3,achTrainersDefeated([MAP_ROUTE_36, MAP_ROUTE_37, MAP_NATIONAL_PARK, MAP_BURNED_TOWER_1F])],
    //TODO: Burned Tower moved to above
    //["_trainers_6","Defeat every unmissable trainer in ",0,achTrainersDefeated([MAP_BURNED_TOWER_1F])],
["Spreading Your Name","Defeat every unmissable trainer in Route 38, Route 39, Olivine City, and Glitter Lighthouse",3,achTrainersDefeated([MAP_ROUTE_38, MAP_ROUTE_39, MAP_OLIVINE_POKECENTER_1F, MAP_OLIVINE_LIGHTHOUSE_2F, MAP_OLIVINE_LIGHTHOUSE_3F, MAP_OLIVINE_LIGHTHOUSE_4F, MAP_OLIVINE_LIGHTHOUSE_5F])],
["All the Way to the West","Defeat every unmissable trainer in Route 40, Route 41, and Route 47",3,achTrainersDefeated([MAP_ROUTE_40, MAP_ROUTE_41, MAP_CIANWOOD_GYM, MAP_ROUTE_47])],
["All the Way to the North","Defeat every unmissable trainer in Route 42, Route 43, Mt. Mortar, and the Lake of Rage",3,achTrainersDefeated([MAP_ROUTE_42, MAP_ROUTE_43, MAP_LAKE_OF_RAGE, MAP_MAHOGANY_GYM_ROOM_2, MAP_MAHOGANY_GYM_LEADER_ROOM, MAP_TEAM_ROCKET_HEADQUARTERS_B1F, MAP_TEAM_ROCKET_HEADQUARTERS_B2F, MAP_TEAM_ROCKET_HEADQUARTERS_B3F, MAP_MOUNT_MORTAR_1F_BACK, MAP_MOUNT_MORTAR_2F])],
    //TODO: goldenrod tunnel moved to route 34 & 35
    //["_trainers_10","Defeat every unmissable trainer in Goldenrod Radio Tower and Goldenrod Tunnel",0,achTrainersDefeated([MAP_GOLDENROD_RADIO_TOWER_2F, MAP_GOLDENROD_RADIO_TOWER_3F, MAP_GOLDENROD_RADIO_TOWER_4F, MAP_GOLDENROD_RADIO_TOWER_5F, MAP_GOLDENROD_TUNNEL_B1F, MAP_GOLDENROD_TUNNEL_B2F, MAP_GOLDENROD_TUNNEL_WAREHOUSE])],
["All the Way to the East","Defeat every unmissable trainer in Dragon's Den, Route 44, Route 45, and Route 46",3,achTrainersDefeated([MAP_ROUTE_44, MAP_ROUTE_45, MAP_ROUTE_46, MAP_DRAGONS_DEN])],
["Going National","Defeat every unmissable trainer in Route 27 and Route 26",3,achTrainersDefeated([MAP_ROUTE_26, MAP_ROUTE_27])],
["On Land and on the Sea","Defeat every unmissable trainer on the S.S. Aqua",3,achTrainersDefeated([MAP_SS_AQUA_1F_SOUTHEAST_ROOMS, MAP_SS_AQUA_1F_SOUTHWEST_ROOMS, MAP_SS_AQUA_1F_NORTHEAST_ROOMS, MAP_SS_AQUA_1F_NORTHWEST_ROOMS, MAP_SS_AQUA_B1F])],
["The Rumor Spreads in Kanto","Defeat every unmissable trainer in Route 6, Route 11, and Route 12",3,achTrainersDefeated([MAP_VERMILION_GYM, MAP_ROUTE_6, MAP_ROUTE_11, MAP_ROUTE_12])],
["To the Northeast","Defeat every unmissable trainer in Route 8, Route 9, and Route 10",3,achTrainersDefeated([MAP_SAFFRON_GYM,  MAP_ROUTE_8, MAP_ROUTE_9, MAP_ROUTE_10_SOUTH])],
["Northern Kanto Conquest","Defeat every unmissable trainer in Route 24, Route 25, Route 3, and Route 4",3,achTrainersDefeated([MAP_CERULEAN_GYM, MAP_ROUTE_25, MAP_ROUTE_3, MAP_ROUTE_4])],
["And Down the Pump Tracks","Defeat every unmissable trainer in Route 17, and Route 18",3,achTrainersDefeated([MAP_CELADON_GYM, MAP_ROUTE_17, MAP_ROUTE_18])],
["To the Southeast","Defeat every unmissable trainer in Route 13, Route 14, Route 15",3,achTrainersDefeated([MAP_ROUTE_13, MAP_ROUTE_14, MAP_ROUTE_15])],
["Around the Hometown of the Past Legend","Defeat every unmissable trainer in Route 1, Route 2, and Veridian Forest",3,achTrainersDefeated([MAP_ROUTE_1, MAP_ROUTE_2, MAP_ROUTE_2_EAST, MAP_PEWTER_GYM, MAP_VIRIDIAN_GYM, MAP_VIRIDIAN_FOREST])],
["And to Every Single Island!","Defeat every unmissable trainer in Route 19, Route 20, Route 21, and the Seafoam Islands",3,achTrainersDefeated([MAP_ROUTE_19, MAP_ROUTE_20, MAP_ROUTE_21, MAP_SEAFOAM_ISLANDS_B2F])],
// Defeat Ace Trainer Cal at the Trainer House
// Defeat every rematchable trainer's final team who are present on Sunday
// Defeat every rematchable trainer's final team who are present on Monday
// Defeat every rematchable trainer's final team who are present on Tuesday
// Defeat every rematchable trainer's final team who are present on Wednesday
// Defeat every rematchable trainer's final team who are present on Thursday
// Defeat every rematchable trainer's final team who are present on Friday
// Defeat every rematchable trainer's final team who are present on Saturday
// Obtain at least one of every accessory and backdrop for the Fashion Case
// Collect all 77 obtainable Seals in the Seal Case at once
// Collect all 43 available regular Berries in the Berry Pocket at once
// Take a photo with the Day-Care Man on Route 34 on Wednesday or Thursday //TODO: check Flag 393 and map and active event?
// Take a photo with the Dragon Master in the Dragon's Den Shrine on Monday or Thursday
// Take a photo with Professor Oak in Professor Oak's Lab
// Take a photo with Falkner in the Celadon Department Store on Wednesday
// Take a photo with Bugsy at the National Park on Friday
// Take a photo with Whitney in the Goldenrod Department Store
// Take a photo with Morty on Bellchime Trail on Friday
// Take a photo with Chuck on Route 47 on Sunday
// Take a photo with Jasmine at Olivine Cafe
// Take a photo with Pryce at Mahogany Gym
// Take a photo with Clair in the Dragon's Den
// Take a photo with Brock in Diglett's Cave
// Take a photo with Misty on Route 25
// Take a photo with Lt. Surge on Route 39 on Friday or Saturday
// Take a photo with Erika in Celadon City on Monday
// Take a photo with Janine at the Pokemon League Reception Gate
// Take a photo with Sabrina at Olivine Harbor on Monday
// Take a photo with Blaine on Cinnabar Island on Thursday
// Take a photo with Blue on Cinnabar Island on Friday
// Take a photo in Goldenrod Tunnel while dressed in a Team Rocket uniform
// Obtain a Silk Scarf, Choice Scarf, Muscle Band, and Focus Sash as gifts from your Mother
// Win the Bug Catching Contest at the National Park
// Catch a Pokemon in the Bug Catching Contest worth at least 350 points
["Arrested Development","Receive an Everstone from Professor Elm after showing him the hatched Togepi",2,achFlagAnyMap(FLAG_GOT_EVERSTONE_FROM_ELM)],
// Receive an HP Up from Gate Keeper Randy near Goldenrod City after delivering Kenya the Spearow to Route 31
["Young and Still Able to Become Anything","Receive an Eevee from Bill at his house in Goldenrod City",3,achFlagAnyMap(FLAG_GOT_EEVEE_FROM_BILL)],
// Receive Shuckie the Shuckle as a gift from a trainer in Cianwood City
["Martial Initiate","Receive a Tyrogue from the Karate King in Mt. Mortar",3,achFlagAnyMap(FLAG_GOT_TYROGUE_FROM_KARATE_KING)],
// Receive a Dratini from the elders in the Dragon's Den
// Obtain a Bulbasaur, Charmander, or Squirtle from Professor Oak after defeating Red
// Obtain a Treecko, Torchic, or Mudkip from Steven in Silph Co. after defeating Red
["Trading Up in Weight","Trade a Bellsprout for an Onix in Violet City",2,achFlagAnyMap(FLAG_TRADE_VIOLET_CITY_BELLSPROUT_ONIX)],
["Brains for Brawns","Trade a Drowzee for a Machop in the Goldenrod Department Store",2,achFlagAnyMap(FLAG_TRADE_GOLDENROD_CITY_DROWZEE_MACHOP)],
["Shocking Trade","Trade a Krabby for a Voltorb in Olivine City",2,achFlagAnyMap(FLAG_TRADE_OLIVINE_CITY_KRABBY_VOLTORB)],
["Scammed","Trade a female Dragonair for a Dodrio in Blackthorn City",2,achFlagAnyMap(FLAG_TRADE_BLACKTHORN_CITY_DRAGONAIR_DODRIO)],
["Letting You Go So You Can Grow, Pal","Trade a Haunter for a Xatu in Pewter City",2,achFlagAnyMap(FLAG_TRADE_PEWTER_CITY_HAUNTER_XATU)],
["From Raw Dirt to Refined Metal","Trade a Dugtrio for a Magneton in the Power Plant on Route 10",2,achFlagAnyMap(FLAG_TRADE_POWER_PLANT_DUGTRIO_MAGNETON)],
["Pikaswap","Trade a Pikachu for a Pikachu to Lt. Surge in the Saffron City Magnet Train Station",3,achFlagAnyMap(FLAG_TRADE_LT_SURGE_PIKACHU)],
["With Some Silph Co. Stocks, Please","Forretress for a Beldum to Steven in the lobby of Silph Co.",3,achFlagAnyMap(FLAG_TRADE_STEVEN_FORRETRESS_BELDUM)],
["Rock Collectors Sharing","Bonsly for a Rhyhorn to Brock in Diglett's Cave on Saturday",3,achFlagAnyMap(FLAG_TRADE_BROCK_BONSLY_RHYHORN)],
["Don't Mind If I Do!","Trade any Pokemon for a Steelix to Jasmine in her gym",3,achFlagAnyMap(FLAG_TRADE_JASMINE_STEELIX)],
// Find a Shiny Leaf for your Pokemon
// Have a Leaf Crown made by Lyra or Ethan after collecting 5 Shiny Leaves on a Pokemon
// Obtain a Stick from a wild Farfetch'd
// Solve all eight puzzles of the Ruins of Alph
// Complete every page of the Unown Report
// Receive three berries in exchange for a colored shard from the Juggler in Violet City
// Receive a Pokeball made from Apricorns from Kurt in Azalea Town
// Obtain all 5 items from Bill's Grandfather on Route 25 after showing him specific Pokemon
// Make a purchase at the Herb Shop in the Goldenrod Tunnel on Saturday or Sunday
// Purchase every item from the Bargain Shop in the Goldenrod Tunnel on Monday morning
// Have one of the Haircut Brothers give your Pokemon a haircut in the Goldenrod Tunnel
// Obtain an Ether after showing the Fishing Guru a large Magikarp at the Lake of Rage
// Have Daisy groom one of your Pokemon at the Rival's house in Pallet Town between 3:00-3:59PM
// Win a prize at the Lottery Corner in the Goldenrod Radio Tower
// Obtain Buena's Pokegear number after earning 30 points from her radio show
// Learn all the trendy phrases from the old man on Route 16
// Win a prize by matching three of the same Pokemon on a Scratch-Off Card at the Battle Frontier
// Heal Moomoo the Miltank at Moomoo Farm
// Obtain GB Sounds from a Game Freak's Sound Designer in Celadon City 
["Fortune Strikes Again and Again","Obtain Lucky Punch from showing a lady on Route 14 a Chansey",3,achFlagAnyMap(FLAG_GOT_LUCKY_PUNCH_FROM_ROUTE_14_WOMAN)],
// Wake up the Snorlax on Route 11
// Obtain an Effort Ribbon from a man in Blackthorn City
// Obtain TM27 Return from showing a lady in Goldenrod Department Store a high friendship Pokemon on Sunday 
["Scary Roar","Obtain TM05 Roar from a man on Route 32",2,achFlagAnyMap(FLAG_GOT_TM05_FROM_ROUTE_32_MAN)],
["What Type Will It Be?","Obtain TM10 Hidden Power from a man at the Lake of Rage",2,achFlagAnyMap(FLAG_GOT_TM10_FROM_LAKE_OF_RAGE_MAN)],
["Sunny Weather","Obtain TM11 Sunny Day from a woman at Goldenrod Radio Tower after defeating Team Rocket",2,achFlagAnyMap(FLAG_GOT_TM11_FROM_RADIO_TOWER_WOMAN)],
["Bring the Desert Anywhere","Obtain TM37 Sandstorm from a woman on Route 27",2,achFlagAnyMap(FLAG_GOT_TM37_FROM_ROUTE_27_WOMAN)],
["Technical Gunk","Obtain TM36 Sludge Bomb from a guard on Route 43 after clearing Team Rocket HQ",2,achFlagAnyMap(FLAG_GOT_TM36_FROM_ROUTE_43_GUARD)],
["Metallic Slash","Obtain TM47 Steel Wing from a celebrity on Route 28",2,achFlagAnyMap(FLAG_GOT_TM47_FROM_ROUTE_28_CELEBRITY)],
// Obtain TM64 Explosion from a man in the Underground Path between Route 5 and 6 in exchange for a Ragecandybar
["All Natural","Obtain TM83 Natural Gift from the Moomoo Farm's owner's wife after healing Moomoo",2,achFlagAnyMap(FLAG_GOT_TM83_FROM_MOOMOO_FARM_WOMAN)],
["Sleep Tight","Obtain TM85 Dream Eater from a man in Viridian City",2,achFlagAnyMap(FLAG_GOT_TM85_FROM_VIRIDIAN_CITY_MAN)],
["Goodie Detector","Obtain the Dowsing MCHN in Ecruteak City",2,achFlagAnyMap(FLAG_GOT_DOWSING_MACHINE)],
// Obtain an Exp. Share from Mr. Pokemon in exchange for the Red Scale
// Obtain a Bicycle in Goldenrod City
// Obtain a Pass to board the Magnet Train in Saffron City
// Obtain all 3 fishing rods
// Encounter a Lapras in Union Cave on Friday
// Witness the Clefairy dance at Mt. Moon on Monday night or Tuesday morning
// Defeat Clair and Lance in a double battle at the Dragon's Den
// Obtain every item from the Week Siblings
// Defeat your rival at the Indigo Plateau on Monday or Wednesday
// Witness Diamond Dust on Mt. Silver on a special day
// Have your Pay Day earnings doubled with an Amulet Coin or Luck Incense
// Land a Pokemon while fishing with a lead Pokemon whose ability is Sticky Hold or Suction Cups
// Interact with your starter on Victory Road
// Interact with your Togepi in the Cerulean City Gym
// Interact with one of your ghost type Pokemon in Lavender Town
// Complete level 5 in Voltorb Flip

]

achs_prog = [
    ["Plucking the Competition","Defeat Falkner and earn the Zephyr Badge",5,achJohtoBadgeObtained(BADGE_ZEPHYR)],
    ["A Net Victory","Defeat Bugsy and earn the Hive Badge",5,achJohtoBadgeObtained(BADGE_HIVE)],
    ["Milkshake","Defeat Whitney and earn the Plain Badge",5,achJohtoBadgeObtained(BADGE_PLAIN)],
    ["Exorcist","Defeat Morty and earn the Fog Badge",5,achJohtoBadgeObtained(BADGE_FOG)],
    ["Fighting Spirit","Defeat Chuck and earn the Storm Badge",5,achJohtoBadgeObtained(BADGE_STORM)],
    ["Pounding the Steel Flat","Defeat Jasmine and earn the Mineral Badge",5,achJohtoBadgeObtained(BADGE_MINERAL)],
    ["Tempering the Old Man","Defeat Pryce and earn the Glacier Badge",5,achJohtoBadgeObtained(BADGE_GLACIER)],
    ["Ready for the Big Leagues","Defeat Clair and earn the Rising Badge",5,achJohtoBadgeObtained(BADGE_RISING)],
]

achs_win = [
    // Defeat the Elite Four in the first league and enter the Hall of Fame
]

achs_missable = [
    ["Mysterious Passerby","Defeat the red-haired boy in Cherrygrove City",3,achTrainerDefeated([TRAINER_PASSERBY_BOY,TRAINER_PASSERBY_BOY_2,TRAINER_PASSERBY_BOY_3])],
]

for a in achs_reg ach(a,"")
for a in achs_prog ach(a,"progression")
for a in achs_win ach(a,"win_condition")
for a in achs_missable ach(a,"missable")