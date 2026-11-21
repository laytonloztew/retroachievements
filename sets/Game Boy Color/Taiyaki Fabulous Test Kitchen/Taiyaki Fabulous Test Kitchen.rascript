// ~Homebrew~ Taiyaki Fabulous Test Kitchen
// #ID = 48021

function has_increased(addr) => addr > prev(addr)
function has_decreased(addr) => addr < prev(addr)
function has_changed(addr) => addr != prev(addr)
function hasnt_changed(addr) => addr == prev(addr)
function if_else(p, t, f) { if (p) { return t } else return f }
function is_even(v) => v % 2 == 0
function bitflag(addr,f) => bit(f%8, addr + f/8)
function rp_num(x) => rich_presence_value("Number", x)

function currentScene() => tbyte(0x00c540)

VER_FREE = 0
VER_PAID = 1
function plus_status() => bit(0,0x00cd53)
function isPlus() => plus_status() == 1

function inGame() => currentScene() != 0

SCENE_LOGO = 0
SCENE_TITLE = 1
SCENE_TUTORIAL_1 = 2
SCENE_TUTORIAL_2 = 3
SCENE_TUTORIAL_3 = 4
SCENE_TUTORIAL_4 = 5
SCENE_TUTORIAL_5 = 6
SCENE_TUTORIAL_6 = 7
SCENE_TUTORIAL_7 = 8
SCENE_TUTORIAL_8 = 9
SCENE_TUTORIAL_9 = 10
SCENE_TUTORIAL_10 = 11
SCENE_TUTORIAL_11 = 12
SCENE_TUTORIAL_12 = 13
SCENE_TUTORIAL_13 = 14
SCENE_TUTORIAL_14 = 15
SCENE_PUZZLE_6 = 16
SCENE_COTTAGE = 17
SCENE_ISLAND_NW = 18
SCENE_ISLAND_W = 19
SCENE_ISLAND_SW = 20
SCENE_ISLAND_S = 21
SCENE_ISLAND_SE = 22
SCENE_ISLAND_C = 23
SCENE_DEV_HOUSE = 24
SCENE_CHARM_CHARMS = 25
SCENE_SCHOOL_ENTRANCE = 26
SCENE_SCHOOL_L1 = 27
SCENE_SCHOOL_L2 = 28
SCENE_PUZZLE_14 = 29
SCENE_PUZZLE_10 = 30
SCENE_ISLAND_N = 31
SCENE_ISLAND_N_CATHOUSE_1 = 32
SCENE_LIGHTHOUSE_1 = 33
SCENE_LIGHTHOUSE_2 = 34
SCENE_LIGHTHOUSE_3 = 35
SCENE_LIGHTHOUSE_4 = 36
SCENE_LIGHTHOUSE_5 = 37
SCENE_LIGHTHOUSE_6 = 38
SCENE_SILVER_ROOM = 39
SCENE_LONGBRARY = 40
SCENE_MODEL_ISLAND = 41
SCENE_PARTY = 42
SCENE_CREDITS = 43
SCENE_COMPLETION = 44
SCENE_ISLAND_TELEPORT = 45
SCENE_ISLAND_NE = 46
SCENE_ISLAND_NE_BARN = 47
SCENE_ISLAND_E = 48
SCENE_SCHOOL_L3 = 49
SCENE_SCHOOL_L4 = 50
SCENE_MASTER_KITCHEN = 51
SCENE_MENU_PROGRESS = 52
SCENE_MENU_ALBUM_SMALL_1 = 53
SCENE_MENU_ALBUM_SMALL_2 = 54
SCENE_MENU_ALBUM_SMALL_3 = 55
SCENE_MENU_ALBUM_SMALL_4 = 56
SCENE_MENU_ALBUM_SMALL_5 = 57
SCENE_MENU_ALBUM_SMALL_6 = 58
SCENE_MENU_ALBUM_LARGE_1 = 59
SCENE_MENU_ALBUM_LARGE_2 = 60
SCENE_MENU_ALBUM_LARGE_3 = 61
SCENE_MENU_ALBUM_LARGE_4 = 62
SCENE_MENU_ALBUM_LARGE_5 = 63
SCENE_MENU_ALBUM_LARGE_6 = 64
SCENE_MENU_ALBUM_BONUS_1 = 65
SCENE_MENU_ALBUM_BONUS_2 = 66
SCENE_MENU_ALBUM_BONUS_3 = 67
SCENE_MENU_ALBUM_BONUS_4 = 68
SCENE_LIGHTHOUSE_CLOTHES = 69
SCENE_DEBUG_ROOM = 70
SCENE_DEBUG_ROOM_ITEMS = 71
SCENE_DEBUG_ALBUM_1 = 72
SCENE_DEBUG_ALBUM_2 = 73
SCENE_DEBUG_ALBUM_3 = 74
SCENE_DEBUG_ALBUM_4 = 75
SCENE_DEBUG_ALBUM_5 = 76
SCENE_DEBUG_ALBUM_6 = 77
SCENE_DEBUG_ALBUM_7 = 78
SCENE_DEBUG_ALBUM_8 = 79
SCENE_DEBUG_ALBUM_9 = 80
SCENE_DEBUG_ALBUM_10 = 81
SCENE_DEBUG_ALBUM_11 = 82
SCENE_DEBUG_ALBUM_12 = 83
SCENE_DEBUG_ALBUM_13 = 84
SCENE_DEBUG_ALBUM_14 = 85
SCENE_DEBUG_ALBUM_15 = 86
SCENE_DEBUG_ALBUM_16 = 87
SCENE_COTTAGE_DREAM = 88
SCENE_ISLAND_NW_BIRDHOUSE = 89
SCENE_ISLAND_W_FISHHOUSE = 90
SCENE_UNDERWATER = 91
SCENE_UNDERWATER_HOUSE_1 = 92
SCENE_UNDERWATER_HOUSE_2 = 93
SCENE_SUNKEN_SHIP = 94
SCENE_PREMIUM_HUB = 95
SCENE_PREMIUM_FORE = 96
SCENE_PREMIUM_CLOTHES = 97
SCENE_PREMIUM_MUSIC = 98
SCENE_PREMIUM_FRUIT = 99
SCENE_PREMIUM_OSSUARY = 100
SCENE_PREMIUM_STORAGE = 101
SCENE_PREMIUM_SECRET = 102
SCENE_ARCADE_GAME = 103
SCENE_ISLAND_W_DREAM = 104
SCENE_ISLAND_SW_MOLEHOUSE = 105
SCENE_ISLAND_SW_BIRDHOUSE = 106
SCENE_ISLAND_S_TREE_3 = 107
SCENE_ISLAND_S_TREE_2 = 108
SCENE_ISLAND_S_TREE_1 = 109
SCENE_ISLAND_S_TREE_BIRDHOUSE = 110
SCENE_ISLAND_SW_UNDERWATER = 111
SCENE_ISLAND_S_DREAM = 112
SCENE_ISLAND_SE_TREE = 113
SCENE_ISLAND_E_CAVE_GRAY_BOTTOM = 114
SCENE_ISLAND_E_CAVE_GRAY_TOP = 115
SCENE_ISLAND_E_CAVE_1 = 116
SCENE_ISLAND_E_CAVE_2 = 117
SCENE_ISLAND_E_DREAM = 118
SCENE_ISLAND_NE_TREE = 119
SCENE_ISLAND_N_CATHOUSE_2 = 120
SCENE_MASTER_KITCHEN_SUB = 121
SCENE_SCHOOL_L2_SUB_LEFT = 122
SCENE_SCHOOL_L2_SUB_RIGHT = 123
SCENE_SCHOOL_L3_SUB_TOPRIGHT = 124
SCENE_SCHOOL_L3_SUB_TOPLEFT = 125
SCENE_SCHOOL_L3_SUB_BOTTOMLEFT = 126
SCENE_SCHOOL_L3_SUB_BOTTOMRIGHT = 127
SCENE_SCHOOL_L4_SUB = 128
SCENE_PARTY_SUB = 129
LIGHTHOUSE_DREAM = 130

SCENE_NAMES_LIST = [
"Logo", // LOGO
"Title Screen", // TITLE
"Tutorial", // TUTORIAL_1
"Tutorial", // TUTORIAL_2
"Tutorial", // TUTORIAL_3
"Tutorial", // TUTORIAL_4
"Tutorial", // TUTORIAL_5
"Tutorial", // TUTORIAL_6
"Tutorial", // TUTORIAL_7
"Tutorial", // TUTORIAL_8
"Tutorial", // TUTORIAL_9
"Tutorial", // TUTORIAL_10
"Tutorial", // TUTORIAL_11
"Tutorial", // TUTORIAL_12
"Tutorial", // TUTORIAL_13
"Tutorial", // TUTORIAL_14
"Puzzle", // PUZZLE_6
"Cottage", // COTTAGE
"Fishcake Island Northwest", // ISLAND_NW
"Fishcake Island West", // ISLAND_W
"Fishcake Island Southwest", // ISLAND_SW
"Fishcake Island South", // ISLAND_S
"Fishcake Island Southeast", // ISLAND_SE
"Fishcake Island Central", // ISLAND_C
"Developer House", // DEV_HOUSE
"Charm's Charms", // CHARM_CHARMS
"Culinary Academy Entrance", // SCHOOL_ENTRANCE
"Culinary Academy L1", // SCHOOL_L1
"Culinary Academy L2", // SCHOOL_L2
"Puzzle", // PUZZLE_14
"Puzzle", // PUZZLE_10
"Fishcake Island North", // ISLAND_N
"Fishcake Island North", // ISLAND_N_CATHOUSE_1
"Luna Lighthouse", // LIGHTHOUSE_1
"Luna Lighthouse", // LIGHTHOUSE_2
"Luna Lighthouse", // LIGHTHOUSE_3
"Luna Lighthouse", // LIGHTHOUSE_4
"Luna Lighthouse", // LIGHTHOUSE_5
"Luna Lighthouse", // LIGHTHOUSE_6
"Silver Room", // SILVER_ROOM
"Longbrary", // LONGBRARY
"Model Island", // MODEL_ISLAND
"Giant Fruit Gala", // PARTY
"Credits", // CREDITS
"Credits", // COMPLETION
"Fishcake Island Teleport", // ISLAND_TELEPORT
"Fishcake Island Northeast", // ISLAND_NE
"Fishcake Island Northeast", // ISLAND_NE_BARN
"Fishcake Island East", // ISLAND_E
"Culinary Academy L3", // SCHOOL_L3
"Culinary Academy L4", // SCHOOL_L4
"Test Kitchen", // MASTER_KITCHEN
"(MENU)", // MENU_PROGRESS
"(MENU)", // MENU_ALBUM_SMALL_1
"(MENU)", // MENU_ALBUM_SMALL_2
"(MENU)", // MENU_ALBUM_SMALL_3
"(MENU)", // MENU_ALBUM_SMALL_4
"(MENU)", // MENU_ALBUM_SMALL_5
"(MENU)", // MENU_ALBUM_SMALL_6
"(MENU)", // MENU_ALBUM_LARGE_1
"(MENU)", // MENU_ALBUM_LARGE_2
"(MENU)", // MENU_ALBUM_LARGE_3
"(MENU)", // MENU_ALBUM_LARGE_4
"(MENU)", // MENU_ALBUM_LARGE_5
"(MENU)", // MENU_ALBUM_LARGE_6
"(MENU)", // MENU_ALBUM_BONUS_1
"(MENU)", // MENU_ALBUM_BONUS_2
"(MENU)", // MENU_ALBUM_BONUS_3
"(MENU)", // MENU_ALBUM_BONUS_4
"Luna Lighthouse", // LIGHTHOUSE_CLOTHES
"Debug Room", // DEBUG_ROOM
"Debug Room", // DEBUG_ROOM_ITEMS
"Debug Room", // DEBUG_ALBUM_1
"Debug Room", // DEBUG_ALBUM_2
"Debug Room", // DEBUG_ALBUM_3
"Debug Room", // DEBUG_ALBUM_4
"Debug Room", // DEBUG_ALBUM_5
"Debug Room", // DEBUG_ALBUM_6
"Debug Room", // DEBUG_ALBUM_7
"Debug Room", // DEBUG_ALBUM_8
"Debug Room", // DEBUG_ALBUM_9
"Debug Room", // DEBUG_ALBUM_10
"Debug Room", // DEBUG_ALBUM_11
"Debug Room", // DEBUG_ALBUM_12
"Debug Room", // DEBUG_ALBUM_13
"Debug Room", // DEBUG_ALBUM_14
"Debug Room", // DEBUG_ALBUM_15
"Debug Room", // DEBUG_ALBUM_16
"Vivid Dream", // COTTAGE_DREAM
"Fishcake Island Northwest", // ISLAND_NW_BIRDHOUSE
"Fishcake Island West", // ISLAND_W_FISHHOUSE
"Underwater", // UNDERWATER
"Underwater", // UNDERWATER_HOUSE_1
"Underwater", // UNDERWATER_HOUSE_2
"Sunken Ship", // SUNKEN_SHIP
"Premium Ship Hub", // PREMIUM_HUB
"Premium Ship Fore", // PREMIUM_FORE
"Premium Ship Closet", // PREMIUM_CLOTHES
"Premium Ship Conservatory", // PREMIUM_MUSIC
"Premium Ship Aft", // PREMIUM_FRUIT
"Premium Ship Ossuary", // PREMIUM_OSSUARY
"Premium Ship Storage", // PREMIUM_STORAGE
"Premium Ship Secret", // PREMIUM_SECRET
"Teppanyaki Miracle Carp Repository", // ARCADE_GAME
"Vivid Dream", // ISLAND_W_DREAM
"Fishcake Island Southwest", // ISLAND_SW_MOLEHOUSE
"Fishcake Island Southwest", // ISLAND_SW_BIRDHOUSE
"Fishcake Island South", // ISLAND_S_TREE_3
"Fishcake Island South", // ISLAND_S_TREE_2
"Fishcake Island South", // ISLAND_S_TREE_1
"Fishcake Island South", // ISLAND_S_TREE_BIRDHOUSE
"Fishcake Island Southwest", // ISLAND_SW_UNDERWATER
"Vivid Dream", // ISLAND_S_DREAM
"Fishcake Island Southeast", // ISLAND_SE_TREE
"Fishcake Island East", // ISLAND_E_CAVE_GRAY_BOTTOM
"Fishcake Island East", // ISLAND_E_CAVE_GRAY_TOP
"Fishcake Island East", // ISLAND_E_CAVE_1
"Fishcake Island East", // ISLAND_E_CAVE_2
"Vivid Dream", // ISLAND_E_DREAM
"Fishcake Island Northeast", // ISLAND_NE_TREE
"Fishcake Island North", // ISLAND_N_CATHOUSE_2
"Test Kitchen", // MASTER_KITCHEN_SUB
"Culinary Academy L2", // SCHOOL_L2_SUB_LEFT
"Culinary Academy L2", // SCHOOL_L2_SUB_RIGHT
"Culinary Academy L3", // SCHOOL_L3_SUB_TOPRIGHT
"Culinary Academy L3", // SCHOOL_L3_SUB_TOPLEFT
"Culinary Academy L3", // SCHOOL_L3_SUB_BOTTOMLEFT
"Culinary Academy L3", // SCHOOL_L3_SUB_BOTTOMRIGHT
"Culinary Academy L4", // SCHOOL_L4_SUB
"Giant Fruit Gala", // PARTY_SUB
"Vivid Dream", // LIGHTHOUSE_DREAM
]


SCENE_IDS = [
    [ //FREE
0x5d0e4a, // LOGO
0x5dc84a, // TITLE
0x53704a, // TUTORIAL_1
0x542b4a, // TUTORIAL_2
0x54ab4a, // TUTORIAL_3
0x552b4a, // TUTORIAL_4
0x55ab4a, // TUTORIAL_5
0x562b4a, // TUTORIAL_6
0x56ab4a, // TUTORIAL_7
0x572b4a, // TUTORIAL_8
0x57ab4a, // TUTORIAL_9
0x58934a, // TUTORIAL_10
0x597b4a, // TUTORIAL_11
0x5a364a, // TUTORIAL_12
0x5ab64a, // TUTORIAL_13
0x5b364a, // TUTORIAL_14
0x5fcd4a, // PUZZLE_6
0x43ab4b, // COTTAGE
0x44d24b, // ISLAND_NW
0x445c4b, // ISLAND_W
0x45484b, // ISLAND_SW
0x44214b, // ISLAND_S
0x45834b, // ISLAND_SE
0x4ebc4a, // ISLAND_C
0x4c244b, // DEV_HOUSE
0x4c5f4b, // CHARM_CHARMS
0x4bae4b, // SCHOOL_ENTRANCE
0x50b24b, // SCHOOL_L1
0x52144b, // SCHOOL_L2
0x4ef74a, // PUZZLE_14
0x43354b, // PUZZLE_10
0x43e64b, // ISLAND_N
0x466f4b, // ISLAND_N_CATHOUSE_1
0x45f94b, // LIGHTHOUSE_1
0x4c9a4b, // LIGHTHOUSE_2
0x4d104b, // LIGHTHOUSE_3
0x4d4b4b, // LIGHTHOUSE_4
0x4dc14b, // LIGHTHOUSE_5
0x4dfc4b, // LIGHTHOUSE_6
0x51814a, // SILVER_ROOM
0x52f84a, // LONGBRARY
0x51bc4a, // MODEL_ISLAND
0x51f74a, // PARTY
0x50a34a, // CREDITS
0x50de4a, // COMPLETION
0x4f504b, // ISLAND_TELEPORT
0x450d4b, // ISLAND_NE
0x4a534b, // ISLAND_NE_BARN
0x44974b, // ISLAND_E
0x524f4b, // SCHOOL_L3
0x51284b, // SCHOOL_L4
0x4be94b, // MASTER_KITCHEN
0x43704b, // MENU_PROGRESS
0x5e034a, // MENU_ALBUM_SMALL_1
0x5e3e4a, // MENU_ALBUM_SMALL_2
0x5e794a, // MENU_ALBUM_SMALL_3
0x5eb44a, // MENU_ALBUM_SMALL_4
0x5eef4a, // MENU_ALBUM_SMALL_5
0x5f2a4a, // MENU_ALBUM_SMALL_6
0x60084a, // MENU_ALBUM_LARGE_1
0x60434a, // MENU_ALBUM_LARGE_2
0x607e4a, // MENU_ALBUM_LARGE_3
0x420e4b, // MENU_ALBUM_LARGE_4
0x42494b, // MENU_ALBUM_LARGE_5
0x42844b, // MENU_ALBUM_LARGE_6
0x42bf4b, // MENU_ALBUM_BONUS_1
0x42fa4b, // MENU_ALBUM_BONUS_2
0xDEAD08, // MENU_ALBUM_BONUS_3
0xDEAD09, // MENU_ALBUM_BONUS_4
0x4cd54b, // LIGHTHOUSE_CLOTHES
0x5cd34a, // DEBUG_ROOM
0x50ed4b, // DEBUG_ROOM_ITEMS
0x4d864b, // DEBUG_ALBUM_1
0x50774b, // DEBUG_ALBUM_2
0x4f324a, // DEBUG_ALBUM_3
0x53ab4a, // DEBUG_ALBUM_4
0x59b64a, // DEBUG_ALBUM_5
0x5b714a, // DEBUG_ALBUM_6
0x48404b, // DEBUG_ALBUM_7
0x4ac94b, // DEBUG_ALBUM_8
0x5be74a, // DEBUG_ALBUM_9
0x5c224a, // DEBUG_ALBUM_10
0x5c5d4a, // DEBUG_ALBUM_11
0x5c984a, // DEBUG_ALBUM_12
0x526d4a, // DEBUG_ALBUM_13
0x5bac4a, // DEBUG_ALBUM_14
0xDEAD10, // DEBUG_ALBUM_15
0xDEAD11, // DEBUG_ALBUM_16
0x4f154b, // COTTAGE_DREAM
0x47204b, // ISLAND_NW_BIRDHOUSE
0x46aa4b, // ISLAND_W_FISHHOUSE
0x45be4b, // UNDERWATER
0x4b044b, // UNDERWATER_HOUSE_1
0x4a8e4b, // UNDERWATER_HOUSE_2
0x4b3f4b, // SUNKEN_SHIP
0xDEAD00, // PREMIUM_HUB
0xDEAD01, // PREMIUM_FORE
0xDEAD02, // PREMIUM_CLOTHES
0xDEAD03, // PREMIUM_MUSIC
0xDEAD04, // PREMIUM_FRUIT
0xDEAD05, // PREMIUM_OSSUARY
0xDEAD06, // PREMIUM_STORAGE
0xDEAD07, // PREMIUM_SECRET
0x51d94b, // ARCADE_GAME
0x50014b, // ISLAND_W_DREAM
0x475b4b, // ISLAND_SW_MOLEHOUSE
0x46e54b, // ISLAND_SW_BIRDHOUSE
0x487b4b, // ISLAND_S_TREE_3
0x47964b, // ISLAND_S_TREE_2
0x48054b, // ISLAND_S_TREE_1
0x48b64b, // ISLAND_S_TREE_BIRDHOUSE
0x4e374b, // ISLAND_SW_UNDERWATER
0x503c4b, // ISLAND_S_DREAM
0x48f14b, // ISLAND_SE_TREE
0x49dd4b, // ISLAND_E_CAVE_GRAY_BOTTOM
0x49674b, // ISLAND_E_CAVE_GRAY_TOP
0x492c4b, // ISLAND_E_CAVE_1
0x49a24b, // ISLAND_E_CAVE_2
0x4fc64b, // ISLAND_E_DREAM
0x4a184b, // ISLAND_NE_TREE
0x46344b, // ISLAND_N_CATHOUSE_2
0x519e4b, // MASTER_KITCHEN_SUB
0x528a4b, // SCHOOL_L2_SUB_LEFT
0x52c54b, // SCHOOL_L2_SUB_RIGHT
0x4fa84a, // SCHOOL_L3_SUB_TOPRIGHT
0x4f6d4a, // SCHOOL_L3_SUB_TOPLEFT
0x4fe34a, // SCHOOL_L3_SUB_BOTTOMLEFT
0x501e4a, // SCHOOL_L3_SUB_BOTTOMRIGHT
0x51634b, // SCHOOL_L4_SUB
0x52324a, // PARTY_SUB
0x4ea64b, // LIGHTHOUSE_DREAM
    ],
    [ //PAID
0x53ae53, // LOGO
0x53e953, // TITLE
0x4a6a53, // TUTORIAL_1
0x4b2553, // TUTORIAL_2
0x4ba553, // TUTORIAL_3
0x4c2553, // TUTORIAL_4
0x4ca553, // TUTORIAL_5
0x4d2553, // TUTORIAL_6
0x4da553, // TUTORIAL_7
0x4e2553, // TUTORIAL_8
0x4ea553, // TUTORIAL_9
0x4f2553, // TUTORIAL_10
0x4fa553, // TUTORIAL_11
0x506053, // TUTORIAL_12
0x50e053, // TUTORIAL_13
0x516053, // TUTORIAL_14
0x558653, // PUZZLE_6
0x588553, // COTTAGE
0x5a3453, // ISLAND_NW
0x597653, // ISLAND_W
0x5aaa53, // ISLAND_SW
0x58fb53, // ISLAND_S
0x5ae553, // ISLAND_SE
0x440353, // ISLAND_C
0x616753, // DEV_HOUSE
0x61a253, // CHARM_CHARMS
0x60f153, // SCHOOL_ENTRANCE
0x666153, // SCHOOL_L1
0x67c353, // SCHOOL_L2
0x443e53, // PUZZLE_14
0x580f53, // PUZZLE_10
0x58c053, // ISLAND_N
0x5bd153, // ISLAND_N_CATHOUSE_1
0x5b5b53, // LIGHTHOUSE_1
0x61dd53, // LIGHTHOUSE_2
0x625353, // LIGHTHOUSE_3
0x628e53, // LIGHTHOUSE_4
0x630453, // LIGHTHOUSE_5
0x638553, // LIGHTHOUSE_6
0x466053, // SILVER_ROOM
0x479953, // LONGBRARY
0x46ad53, // MODEL_ISLAND
0x46e853, // PARTY
0x45ea53, // CREDITS
0x462553, // COMPLETION
0x64ff53, // ISLAND_TELEPORT
0x5a6f53, // ISLAND_NE
0x5f8153, // ISLAND_NE_BARN
0x59b153, // ISLAND_E
0x67fe53, // SCHOOL_L3
0x66d753, // SCHOOL_L4
0x612c53, // MASTER_KITCHEN
0x584a53, // MENU_PROGRESS
0x542453, // MENU_ALBUM_SMALL_1
0x545f53, // MENU_ALBUM_SMALL_2
0x549a53, // MENU_ALBUM_SMALL_3
0x54d553, // MENU_ALBUM_SMALL_4
0x551053, // MENU_ALBUM_SMALL_5
0x554b53, // MENU_ALBUM_SMALL_6
0x55c153, // MENU_ALBUM_LARGE_1
0x55fc53, // MENU_ALBUM_LARGE_2
0x563753, // MENU_ALBUM_LARGE_3
0x567253, // MENU_ALBUM_LARGE_4
0x56ad53, // MENU_ALBUM_LARGE_5
0x56e853, // MENU_ALBUM_LARGE_6
0x572353, // MENU_ALBUM_BONUS_1
0x575e53, // MENU_ALBUM_BONUS_2
0x579953, // MENU_ALBUM_BONUS_3
0x57d453, // MENU_ALBUM_BONUS_4
0x621853, // LIGHTHOUSE_CLOTHES
0x52fd53, // DEBUG_ROOM
0x669c53, // DEBUG_ROOM_ITEMS
0x62c953, // DEBUG_ALBUM_1
0x662653, // DEBUG_ALBUM_2
0x447953, // DEBUG_ALBUM_3
0x4aa553, // DEBUG_ALBUM_4
0x4fe053, // DEBUG_ALBUM_5
0x519b53, // DEBUG_ALBUM_6
0x5d6e53, // DEBUG_ALBUM_7
0x5ff753, // DEBUG_ALBUM_8
0x521153, // DEBUG_ALBUM_9
0x524c53, // DEBUG_ALBUM_10
0x528753, // DEBUG_ALBUM_11
0x52c253, // DEBUG_ALBUM_12
0x475e53, // DEBUG_ALBUM_13
0x51d653, // DEBUG_ALBUM_14
0x533853, // DEBUG_ALBUM_15
0x537353, // DEBUG_ALBUM_16
0x647c53, // COTTAGE_DREAM
0x5c8253, // ISLAND_NW_BIRDHOUSE
0x5c0c53, // ISLAND_W_FISHHOUSE
0x5b2053, // UNDERWATER
0x603253, // UNDERWATER_HOUSE_1
0x5fbc53, // UNDERWATER_HOUSE_2
0x606d53, // SUNKEN_SHIP
0x480c53, // PREMIUM_HUB
0x49b753, // PREMIUM_FORE
0x488253, // PREMIUM_CLOTHES
0x48f853, // PREMIUM_MUSIC
0x484753, // PREMIUM_FRUIT
0x48bd53, // PREMIUM_OSSUARY
0x493353, // PREMIUM_STORAGE
0x49f253, // PREMIUM_SECRET
0x678853, // ARCADE_GAME
0x65b053, // ISLAND_W_DREAM
0x5cbd53, // ISLAND_SW_MOLEHOUSE
0x5c4753, // ISLAND_SW_BIRDHOUSE
0x5da953, // ISLAND_S_TREE_3
0x5cf853, // ISLAND_S_TREE_2
0x5d3353, // ISLAND_S_TREE_1
0x5de453, // ISLAND_S_TREE_BIRDHOUSE
0x640653, // ISLAND_SW_UNDERWATER
0x65eb53, // ISLAND_S_DREAM
0x5e1f53, // ISLAND_SE_TREE
0x5f0b53, // ISLAND_E_CAVE_GRAY_BOTTOM
0x5e9553, // ISLAND_E_CAVE_GRAY_TOP
0x5e5a53, // ISLAND_E_CAVE_1
0x5ed053, // ISLAND_E_CAVE_2
0x657553, // ISLAND_E_DREAM
0x5f4653, // ISLAND_NE_TREE
0x5b9653, // ISLAND_N_CATHOUSE_2
0x674d53, // MASTER_KITCHEN_SUB
0x683953, // SCHOOL_L2_SUB_LEFT
0x687453, // SCHOOL_L2_SUB_RIGHT
0x44ef53, // SCHOOL_L3_SUB_TOPRIGHT
0x44b453, // SCHOOL_L3_SUB_TOPLEFT
0x452a53, // SCHOOL_L3_SUB_BOTTOMLEFT
0x456553, // SCHOOL_L3_SUB_BOTTOMRIGHT
0x671253, // SCHOOL_L4_SUB
0x472353, // PARTY_SUB
0x644153, // LIGHTHOUSE_DREAM
    ]
]

SCENE_NAMES_FREE = {}
SCENE_NAMES_PAID = {}

for i in range(0,length(SCENE_IDS[0])-1) {
    name = SCENE_NAMES_LIST[i]
    SCENE_NAMES_FREE[SCENE_IDS[0][i]] = name
    SCENE_NAMES_PAID[SCENE_IDS[1][i]] = name
}

function sceneValue(v, i) => SCENE_IDS[v][i]
function sceneIs(v, i) => currentScene() == sceneValue(v, i)

function isInScene(i) => (
    (isPlus() && sceneIs(VER_PAID, i)) ||
    (!isPlus() && sceneIs(VER_FREE, i))
)

function wasInScene(i) => (
    (isPlus() && prev(sceneIs(VER_PAID, i))) ||
    (!isPlus() && prev(sceneIs(VER_FREE, i)))
)

VAR_NONOPLAYERX = 0
VAR_NONOPLAYERY = 1
VAR_NONONUM00 = 2
VAR_NONONUM01 = 3
VAR_NONOENTRYROW12 = 4
VAR_NONOENTRYROW13 = 5
VAR_NONOSOLUTIONROW12 = 6
VAR_NONOSOLUTIONROW13 = 7
VAR_NONOENTRYROW01 = 8
VAR_NONOENTRYROW00 = 9
VAR_NONOSOLUTIONROW00 = 10
VAR_NONOSOLUTIONROW01 = 11
VAR_NONOSOLUTIONROW02 = 12
VAR_NONOSOLUTIONROW03 = 13
VAR_NONOSOLUTIONROW04 = 14
VAR_NONOSOLUTIONROW05 = 15
VAR_NONOSOLUTIONROW06 = 16
VAR_NONOSOLUTIONROW07 = 17
VAR_NONOSOLUTIONROW08 = 18
VAR_NONOENTRYROW02 = 19
VAR_NONOENTRYROW03 = 20
VAR_NONOENTRYROW04 = 21
VAR_NONOENTRYROW05 = 22
VAR_NONOENTRYROW06 = 23
VAR_NONOENTRYROW07 = 24
VAR_NONOENTRYROW08 = 25
VAR_NONOSOLUTIONROW09 = 26
VAR_NONOSOLUTIONROW10 = 27
VAR_NONOSOLUTIONROW11 = 28
VAR_NONOENTRYROW09 = 29
VAR_NONOENTRYROW10 = 30
VAR_NONOENTRYROW11 = 31
VAR_NONONUM03 = 32
VAR_NONOCOUNTER = 33
VAR_NONONUM04 = 34
VAR_NONONUM02 = 35
VAR_NONONUM05 = 36
VAR_NONONUM06 = 37
VAR_NONONUM07 = 38
VAR_NONONUM08 = 39
VAR_NONONUM09 = 40
VAR_NONONUM0A = 41
VAR_NONONUM0B = 42
VAR_NONONUM0C = 43
VAR_NONONUM0D = 44
VAR_NONONUM0E = 45
VAR_NONONUM0F = 46
VAR_NONONUM10 = 47
VAR_NONONUM11 = 48
VAR_NONONUM12 = 49
VAR_NONONUM13 = 50
VAR_NONONUM14 = 51
VAR_NONONUM15 = 52
VAR_NONONUM16 = 53
VAR_NONONUM17 = 54
VAR_NONONUM18 = 55
VAR_NONONUM19 = 56
VAR_NONONUM1A = 57
VAR_NONONUM1B = 58
VAR_NONONUM1C = 59
VAR_NONONUM1D = 60
VAR_NONONUM1E = 61
VAR_NONONUM1F = 62
VAR_NONONUM20 = 63
VAR_NONONUM21 = 64
VAR_NONONUM22 = 65
VAR_NONONUM23 = 66
VAR_NONONUM24 = 67
VAR_NONONUM25 = 68
VAR_NONONUM26 = 69
VAR_NONONUM27 = 70
VAR_NONONUM28 = 71
VAR_NONONUM29 = 72
VAR_NONONUM2A = 73
VAR_NONONUM2B = 74
VAR_NONONUM2C = 75
VAR_NONONUM2D = 76
VAR_NONONUM2E = 77
VAR_NONONUM2F = 78
VAR_NONONUM30 = 79
VAR_NONONUM31 = 80
VAR_NONONUM32 = 81
VAR_NONONUM33 = 82
VAR_NONONUM34 = 83
VAR_NONONUM35 = 84
VAR_NONONUM36 = 85
VAR_NONONUM37 = 86
VAR_NONONUM38 = 87
VAR_NONONUM39 = 88
VAR_NONONUM3A = 89
VAR_NONONUM3B = 90
VAR_NONONUM3C = 91
VAR_NONONUM3D = 92
VAR_NONONUM3E = 93
VAR_NONONUM3F = 94
VAR_NONONUM40 = 95
VAR_NONONUM41 = 96
VAR_NONONUM42 = 97
VAR_NONONUM43 = 98
VAR_NONONUM44 = 99
VAR_NONONUM45 = 100
VAR_NONONUM46 = 101
VAR_NONONUM47 = 102
VAR_NONONUM48 = 103
VAR_NONONUM49 = 104
VAR_NONONUM4A = 105
VAR_NONONUM4B = 106
VAR_NONONUM4C = 107
VAR_NONONUM4D = 108
VAR_NONONUM4E = 109
VAR_NONONUM4F = 110
VAR_NONONUM50 = 111
VAR_NONONUM51 = 112
VAR_NONONUM52 = 113
VAR_NONOVARTALLY = 114
VAR_NONONUM53 = 115
VAR_NONONUM54 = 116
VAR_NONONUM58 = 117
VAR_NONONUM5C = 118
VAR_NONONUM60 = 119
VAR_NONONUM64 = 120
VAR_NONONUM68 = 121
VAR_NONONUM6C = 122
VAR_NONONUM70 = 123
VAR_NONONUM74 = 124
VAR_NONONUM78 = 125
VAR_NONONUM7C = 126
VAR_NONONUM80 = 127
VAR_NONONUM84 = 128
VAR_NONONUM88 = 129
VAR_NONONUM55 = 130
VAR_NONONUM59 = 131
VAR_NONONUM5D = 132
VAR_NONONUM61 = 133
VAR_NONONUM65 = 134
VAR_NONONUM69 = 135
VAR_NONONUM6D = 136
VAR_NONONUM71 = 137
VAR_NONONUM75 = 138
VAR_NONONUM79 = 139
VAR_NONONUM7D = 140
VAR_NONONUM81 = 141
VAR_NONONUM85 = 142
VAR_NONONUM89 = 143
VAR_NONONUM56 = 144
VAR_NONONUM5A = 145
VAR_NONONUM5E = 146
VAR_NONONUM62 = 147
VAR_NONONUM66 = 148
VAR_NONONUM6A = 149
VAR_NONONUM6E = 150
VAR_NONONUM72 = 151
VAR_NONONUM76 = 152
VAR_NONONUM7A = 153
VAR_NONONUM7E = 154
VAR_NONONUM82 = 155
VAR_NONONUM86 = 156
VAR_NONONUM8A = 157
VAR_NONONUM57 = 158
VAR_NONONUM5B = 159
VAR_NONONUM5F = 160
VAR_NONONUM63 = 161
VAR_NONONUM67 = 162
VAR_NONONUM6B = 163
VAR_NONONUM6F = 164
VAR_NONONUM73 = 165
VAR_NONONUM77 = 166
VAR_NONONUM7B = 167
VAR_NONONUM7F = 168
VAR_NONONUM83 = 169
VAR_NONONUM87 = 170
VAR_NONONUM8B = 171
VAR_NONOVARDIRECTORY = 172
VAR_NONOVARFLAG = 173
VAR_NONOSIZE = 174
VAR_SOLVEDPUZZLES01 = 175
VAR_SOLVEDPUZZLES02 = 176
VAR_SOLVEDPUZZLES03 = 177
VAR_SOLVEDPUZZLES04 = 178
VAR_SOLVEDPUZZLES05 = 179
VAR_SOLVEDPUZZLES06 = 180
VAR_SOLVEDPUZZLES07 = 181
VAR_SOLVEDPUZZLES08 = 182
VAR_SOLVEDPUZZLES09 = 183
VAR_SOLVEDPUZZLES10 = 184
VAR_SOLVEDPUZZLES11 = 185
VAR_SOLVEDPUZZLES12 = 186
VAR_SOLVEDPUZZLES13 = 187
VAR_SOLVEDPUZZLES14 = 188
VAR_SOLVEDPUZZLES15 = 189
VAR_SOLVEDPUZZLES16 = 190
VAR_SOLVEDPUZZLES17 = 191
VAR_SOLVEDPUZZLES18 = 192
VAR_SOLVEDPUZZLES19 = 193
VAR_SOLVEDPUZZLES20 = 194
VAR_SOLVEDPUZZLES21 = 195
VAR_SOLVEDPUZZLES22 = 196
VAR_SOLVEDPUZZLES23 = 197
VAR_SOLVEDPUZZLES24 = 198
VAR_SOLVEDPUZZLES25 = 199
VAR_MENUSELECTION = 200
VAR_LOADING = 201
VAR_GOTOUTFIT = 202
VAR_GOTDEVWAND = 203
VAR_GOTCINNIBBLE = 204
VAR_GOTPLUSVERSION = 205
VAR_GOTDEBUGROOM = 206
VAR_GOTLIGHTHOUSEWARP = 207
VAR_GOTFULLPUZZLEMUSICVOLUME = 208
VAR_NONOSHADOWX = 209
VAR_GOTPROGRESS = 210
VAR_GOTDEVKEY = 211
VAR_LOCAL_0 = 212

function var_addr(i) => 0x00cbb9 + (i * 2)

ITEM_KEY = 0
ITEM_BUCKET = 1
ITEM_BIRDSONG = 2
ITEM_TOKENS = 3
ITEM_MOLECLAW = 4
ITEM_BROOM = 5
ITEM_CATSEYE = 6
ITEM_ONEIRING = 7
ITEM_FISHSCALE = 8
ITEM_CANDLE = 9
ITEM_SPAGHETTICODE = 10
ITEM_STONESOUP = 11
ITEM_HIBISCUSGRAVY = 12
ITEM_KITTYBISCUITS = 13
ITEM_TAIYAKI = 14
ITEM_GIANTPRODUCE = 15

CINNABBLE_1 = 0
CINNABBLE_2 = 1
CINNABBLE_3 = 2
CINNABBLE_4 = 3
CINNABBLE_5 = 4
CINNABBLE_6 = 5
CINNABBLE_7 = 6
CINNABBLE_8 = 7
CINNABBLE_9 = 8
CINNABBLE_10 = 9
CINNABBLE_11 = 10
CINNABBLE_12 = 11
CINNABBLE_ROCKET = 12
CINNABBLE_CROWBAR = 13
CINNABBLE_OCARINA = 14
CINNABBLE_SKELEKEY = 15

function inPuzzle(v) => __ornext(
    sceneIs(v, SCENE_PUZZLE_6) ||
    sceneIs(v, SCENE_PUZZLE_10) ||
    sceneIs(v, SCENE_PUZZLE_14)
)

function inMenu(v) => __ornext(
    sceneIs(v, SCENE_MENU_PROGRESS) ||
    sceneIs(v, SCENE_MENU_ALBUM_SMALL_1) ||
    sceneIs(v, SCENE_MENU_ALBUM_SMALL_2) ||
    sceneIs(v, SCENE_MENU_ALBUM_SMALL_3) ||
    sceneIs(v, SCENE_MENU_ALBUM_SMALL_4) ||
    sceneIs(v, SCENE_MENU_ALBUM_SMALL_5) ||
    sceneIs(v, SCENE_MENU_ALBUM_SMALL_6) ||
    sceneIs(v, SCENE_MENU_ALBUM_LARGE_1) ||
    sceneIs(v, SCENE_MENU_ALBUM_LARGE_2) ||
    sceneIs(v, SCENE_MENU_ALBUM_LARGE_3) ||
    sceneIs(v, SCENE_MENU_ALBUM_LARGE_4) ||
    sceneIs(v, SCENE_MENU_ALBUM_LARGE_5) ||
    sceneIs(v, SCENE_MENU_ALBUM_LARGE_6) ||
    sceneIs(v, SCENE_MENU_ALBUM_BONUS_1) ||
    sceneIs(v, SCENE_MENU_ALBUM_BONUS_2) ||
    sceneIs(v, SCENE_MENU_ALBUM_BONUS_3) ||
    sceneIs(v, SCENE_MENU_ALBUM_BONUS_4)
)

function inTutorial(v) => __ornext(
    sceneIs(v, SCENE_TUTORIAL_1) ||
    sceneIs(v, SCENE_TUTORIAL_2) ||
    sceneIs(v, SCENE_TUTORIAL_3) ||
    sceneIs(v, SCENE_TUTORIAL_4) ||
    sceneIs(v, SCENE_TUTORIAL_5) ||
    sceneIs(v, SCENE_TUTORIAL_6) ||
    sceneIs(v, SCENE_TUTORIAL_7) ||
    sceneIs(v, SCENE_TUTORIAL_8) ||
    sceneIs(v, SCENE_TUTORIAL_9) ||
    sceneIs(v, SCENE_TUTORIAL_10) ||
    sceneIs(v, SCENE_TUTORIAL_11) ||
    sceneIs(v, SCENE_TUTORIAL_12) ||
    sceneIs(v, SCENE_TUTORIAL_13) ||
    sceneIs(v, SCENE_TUTORIAL_14)
)

function sceneStack(i) => tbyte(0xc558 + (i*8))

function nonoSize() => word(0x00cd15)

function puzzleSolved(f) => bitflag(0xcd17,f)

function debugCheck() => word(var_addr(VAR_GOTDEBUGROOM))
function cheatProtection() => debugCheck() == 0
function achItemInMap(item, map) => inGame() && isInScene(map) && has_increased(bitflag(var_addr(VAR_GOTPROGRESS), item)) && cheatProtection()

function totalPuzzlesTally() => word(var_addr(VAR_NONOVARTALLY))

function cinnableFlag(i) => bitflag(var_addr(VAR_GOTCINNIBBLE), i)
function gotCinnable(i) => has_increased(cinnableFlag(i))
function sumCinnableNibbles() => sum_of(range(0,11), i => cinnableFlag(i))

function sumPuzzles(g) => sum_of(g, p => puzzleSolved(p))

function achPuzzlesSolved(g) => measured(sumPuzzles(g) == length(g), when=inGame() && cheatProtection()) && prev(sumPuzzles(g)) == (length(g) - 1)

PLUS_LOOKUP = {
    1: " ➕"
}

DEBUG_LOOKUP = {
    1: " [DEBUG ACTIVATED, ACHIEVEMENTS DISABLED]"
}

rp_scene_free = rich_presence_lookup("AreaFree", currentScene(), SCENE_NAMES_FREE)
rp_scene_plus = rich_presence_lookup("AreaPlus", currentScene(), SCENE_NAMES_PAID)
rp_last_scene_free = rich_presence_lookup("AreaFree", prior(currentScene()), SCENE_NAMES_FREE)
rp_last_scene_plus = rich_presence_lookup("AreaPlus", prior(currentScene()), SCENE_NAMES_PAID)

rp_scene_stack_first_free = rich_presence_lookup("AreaFree", sceneStack(0), SCENE_NAMES_FREE)
rp_scene_stack_first_plus = rich_presence_lookup("AreaPlus", sceneStack(0), SCENE_NAMES_PAID)

rp_nonosize = rich_presence_value("Number", nonoSize())
rp_total_puzzles = rich_presence_value("Number",totalPuzzlesTally())
rp_plus = rich_presence_lookup("Plus", plus_status(), PLUS_LOOKUP)
rp_debug = rich_presence_lookup("Debug", debugCheck(), DEBUG_LOOKUP)

rich_presence_conditional_display(inGame() && isPlus() && (isInScene(SCENE_LOGO) || isInScene(SCENE_TITLE)),"Viewing Title ➕")
rich_presence_conditional_display(inGame() && (isInScene(SCENE_LOGO) || isInScene(SCENE_TITLE)),"Viewing Title")


rich_presence_conditional_display(inGame() && isPlus() && inTutorial(VER_PAID),"Viewing Tutorial ➕")
rich_presence_conditional_display(inGame() && inTutorial(VER_FREE),"Viewing Tutorial")

rich_presence_conditional_display(inGame() && isPlus() && inMenu(VER_PAID),"🗺️{0} [🚩{1}] ➕{2}",
    rp_scene_stack_first_plus,
    rp_total_puzzles,
    rp_debug
)

rich_presence_conditional_display(inGame() && isPlus() && inPuzzle(VER_PAID),"📝Solving a {1}x{1} puzzle at {0} [🚩{2}] ➕{3}",
    rp_scene_stack_first_plus,
    rp_nonosize,
    rp_total_puzzles,
    rp_debug
)

rich_presence_conditional_display(inGame() && isPlus(),"🗺️{0} [🚩{1}] ➕{2}",
    rp_scene_plus,
    rp_total_puzzles,
    rp_debug
)

rich_presence_conditional_display(inGame() && inMenu(VER_FREE),"🗺️{0} [🚩{1}]{2}",
    rp_scene_stack_first_free,
    rp_total_puzzles,
    rp_debug
)

rich_presence_conditional_display(inGame() && inPuzzle(VER_FREE),"📝Solving a {1}x{1} puzzle at {0} [🚩{2}]{3}",
    rp_scene_stack_first_free,
    rp_nonosize,
    rp_total_puzzles,
    rp_debug
)

rich_presence_conditional_display(inGame(),"🗺️{0} [🚩{1}]{2}",
    rp_scene_free,
    rp_total_puzzles,
    rp_debug
)

rich_presence_display("Loading...")

achievement(
    title = "Key to the Island",
    points = 2,
    description = "Obtain the Key",
    trigger = achItemInMap(ITEM_KEY, SCENE_SCHOOL_ENTRANCE)
)

achievement(
    title = "Gift of the Fishfolk",
    points = 3,
    description = "Obtain the Fishscale",
    trigger = achItemInMap(ITEM_FISHSCALE, SCENE_ISLAND_W_FISHHOUSE),
    type="progression"
)

achievement(
    title = "A Bright Idea",
    points = 3,
    description = "Obtain the Candle",
    trigger = achItemInMap(ITEM_CANDLE, SCENE_SUNKEN_SHIP),
    type="progression"
)

achievement(
    title = "Diggy Diggy Mole",
    points = 3,
    description = "Obtain the Moleclaw",
    trigger = achItemInMap(ITEM_MOLECLAW, SCENE_ISLAND_E_CAVE_GRAY_BOTTOM),
    type="progression"
)

achievement(
    title = "It Holds Water",
    points = 3,
    description = "Obtain the Bucket",
    trigger = achItemInMap(ITEM_BUCKET, SCENE_ISLAND_NE),
    type="progression"
)

achievement(
    title = "Eye of the Hunter",
    points = 3,
    description = "Obtain the Catseye",
    trigger = achItemInMap(ITEM_CATSEYE, SCENE_ISLAND_N_CATHOUSE_1),
    type="progression"
)

achievement(
    title = "Song of the Linguist",
    points = 3,
    description = "Obtain the Birdsong",
    trigger = achItemInMap(ITEM_BIRDSONG, SCENE_ISLAND_S_TREE_2),
    type="progression"
)

achievement(
    title = "Time to Play",
    points = 3,
    description = "Obtain the Tokens",
    trigger = achItemInMap(ITEM_TOKENS, SCENE_ISLAND_SE),
    type="progression"
)

achievement(
    title = "I Just Need to Burrow This",
    points = 3,
    description = "Obtain the Broom",
    trigger = achItemInMap(ITEM_BROOM, SCENE_ISLAND_SW_MOLEHOUSE)
)

achievement(
    title = "One Ring to Snooze Them All",
    points = 5,
    description = "Obtain the Oneiring",
    trigger = achItemInMap(ITEM_ONEIRING, SCENE_LIGHTHOUSE_CLOTHES)
)

achievement(
    title = "A Balanced Diet",
    points = 5,
    description = "Obtain every essential ingredient",
    trigger = achPuzzlesSolved([23,71,134,151,215,230,263,278,294,310,342,343,359,374,375,391]),
    type="progression"
)

achievement(
    title = "Plentiful Harvest",
    points = 5,
    description = "Obtain every non-essential ingredient",
    trigger = achPuzzlesSolved([39,55,102,103,118,119,135,150,182,183,198,199,214,231,262,279,295,311,358,390])
)

function achChangeScene(from,to) => inGame() && wasInScene(from) && isInScene(to) && cheatProtection()

achievement(
    title = "Breathtaking Prize",
    points = 25,
    description = "Receive the Prize Rocket",
    trigger = achChangeScene(SCENE_SILVER_ROOM,SCENE_CREDITS)
)

achievement(
    title = "Onward and Upward",
    points = 10,
    description = "Reach the Plane of Mastery",
    trigger = achChangeScene(SCENE_ISLAND_NW,SCENE_CREDITS),
    type="win_condition"
)

achievement(
    title = "Everything and the Kitchen Sink",
    points = 5,
    description = "Obtain every cooking tool",
    trigger = achPuzzlesSolved([6,22,38,54,70])
)

achievement(
    title = "Dress for Success",
    points = 5,
    description = "Obtain every clothing item",
    trigger = achPuzzlesSolved([3,19,35,51,67])
)

achievement(
    title = "Collecting Collectibles",
    points = 10,
    description = "Obtain every collectible",
    trigger = achPuzzlesSolved([243,259,275,291,307,323,339,355,371,387])
)

achievement(
    title = "Interior Decorator",
    points = 10,
    description = "Obtain every furniture",
    trigger = achPuzzlesSolved([83,99,115,131,147,163,179,195,211,227])
)

achievement(
    title = "Island Hopper",
    points = 3,
    description = "Unlock every warp spot",
    trigger = achPuzzlesSolved([98,114,130,178,194,210,258,274,290])
)

achievement(
    title = "Cooking Fresh",
    points = 5,
    description = "Learn every ingredient category in the L1 class at the Culinary Academy",
    trigger = achPuzzlesSolved([7,86,87,166,167,246,247,326,327])
)

achievement(
    title = "Studious Chef",
    points = 10,
    description = "Cook every dish in the L2 class at the Culinary Academy",
    trigger = achPuzzlesSolved([5,21,37,53,69,85,101,117,133,149,164,165,180,181,196,197,212,213,228,229,244,245,260,261,276,277,292,293,308,309,324,325,340,341,356,357,372,373,388,389])
)

achievement(
    title = "Combinatoric Cuisine",
    points = 10,
    description = "Cook every dish in the L3 class at the Culinary Academy",
    trigger = achPuzzlesSolved([9,10,25,26,41,42,57,58,73,74,89,90,105,106,121,122,137,138,153,154,168,169,170,184,185,186,200,201,202,216,217,218,232,233,234,248,249,250,264,265,266,280,281,282,296,297,298,312,313,314,328,329,330,344,345,346,360,361,362,376,377,378,392,393])
)

achievement(
    title = "Master Delicacies",
    points = 10,
    description = "Cook all 4 dishes in the L4 class at the Culinary Academy",
    trigger = achPuzzlesSolved([11,27,43,59,75,91,107,123,139,155,171,187,251,267,331,347])
)

achievement(
    title = "Seeds of Power",
    points = 5,
    description = "Collect every seed in the Model Island and the Longbrary",
    trigger = achPuzzlesSolved([172,188,220,236])
)

achievement(
    title = "Fabulous Treat",
    points = 50,
    description = "Collect all Cinnibbles",
    trigger = measured(sumCinnableNibbles() == 12, when=inGame() && cheatProtection()) && prev(sumCinnableNibbles()) == 11
)

achievement(
    title = "Fishcake Fantasy",
    points = 25,
    description = "Solve every puzzle in Bonus Album 1 and 2",
    trigger = achPuzzlesSolved([172,188,220,236,92,108,124,140,156,332,348,364,380,396,12,28,44,60,76,252,268,284,300,316,13,29,45,61,77,93,109,125,141,157,173,189,221,237,253,269,285,301,317,333,349,365,381,397,204,205])
)

premium_set = achievement_set("Premium Ship",type="Specialty",id=49421,game_id=49433)
function achPlusCinnableInMap(i, map) => inGame() && isPlus() && sceneIs(VER_PAID, map) && gotCinnable(i) && cheatProtection()

achievement(
    title = "Trusty Hardware",
    points = 3,
    description = "Obtain the Crowbar on the Premium Ship",
    trigger = achPlusCinnableInMap(CINNABBLE_CROWBAR, SCENE_PREMIUM_FORE),
    set = premium_set
)

achievement(
    title = "The Essential Key",
    points = 3,
    description = "Obtain the Skeleton Key on the Premium Ship",
    trigger = achPlusCinnableInMap(CINNABBLE_SKELEKEY, SCENE_PREMIUM_STORAGE),
    set = premium_set
)

achievement(
    title = "Time for the Ocarina",
    points = 3,
    description = "Obtain the Ocarina on the Premium Ship",
    trigger = achPlusCinnableInMap(CINNABBLE_OCARINA, SCENE_PREMIUM_STORAGE),
    set = premium_set
)

achievement(
    title = "Looking for Leaks",
    points = 5,
    description = "Open every crate in the Premium Ship Aft",
    trigger = isPlus() && achPuzzlesSolved([95,111,127,143,159,175,191,207,223,239]),
    set=premium_set
)

achievement(
    title = "Music to My Ears",
    points = 5,
    description = "Solve every puzzle in the Premium Ship Conservatory",
    trigger = isPlus() && achPuzzlesSolved([78,206,254,270,286,302,318,334,350,366,382,398]),
    set=premium_set
)

achievement(
    title = "Scattered Specimens",
    points = 5,
    description = "Gather every specimen in the Premium Ship",
    trigger = isPlus() && achPuzzlesSolved([174,190,206,222,238]),
    set=premium_set
)

achievement(
    title = "Literally Unethical",
    points = 5,
    description = "Accept a large bribe on the Premium Ship",
    trigger = inGame() && isPlus() && sceneIs(VER_PAID, SCENE_PREMIUM_HUB) && has_increased(puzzleSolved(79)) && cheatProtection(),
    set=premium_set
)

achievement(
    title = "Sailing the Seas",
    points = 10,
    description = "Solve every puzzle on the Premium Ship",
    trigger = isPlus() && achPuzzlesSolved([14,15,30,46,62,78,79,95,110,111,127,142,143,158,159,174,175,190,191,206,207,222,223,238,239,254,255,270,271,286,287,302,303,318,319,334,335,350,351,366,367,382,383,398,399,94,126,31,47,63]),
    set=premium_set
)