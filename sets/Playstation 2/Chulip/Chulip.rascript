// Chulip
// #ID = 20614

// --------------------------------------------------------
// MARK: HELPERS
// 
// --------------------------------------------------------
function ptr(x) => dword(x)
function has_increased(addr) => addr > prev(addr)
function has_decreased(addr) => addr < prev(addr)
function has_changed(addr) => addr != prev(addr)
function hasnt_changed(addr) => addr == prev(addr)
function if_else(p, t, f) { if (p) { return t } else return f }
function is_even(v) => v % 2 == 0

// --------------------------------------------------------
// MARK: MEMORY
// 
// --------------------------------------------------------
EVENT_FLAG_PTR = 0x001ed740
MAP_ADDRESS = 0x00201bc0

function current_hearts() => word(0x001a69ec)
function max_hearts() => word(0x001a69ee)
function current_money() => dword(0x001a69f4)
function current_level() => word(0x001a69fc)
function current_kisses() => word(0x001a69fe)
function current_time() => dword(0x001ffb48)
function current_day() => word(0x001ffb7c)
function dialogue_id() => dword(0x002d8880)

function current_room() => word(ptr(0x001ed700) + 0x0c)
function current_hole() => word(ptr(0x001ed700) + 0x0e)
function reaper_damage() => word(ptr(0x001ed700) + 0x16e)

// --------------------------------------------------------
// MARK: DATA
// 
// --------------------------------------------------------
MAP_LLT = "00"
MAP_WDT = "01"
MAP_SCF = "02"
MAP_UNDASURAPARK = "03"
MAP_LASTDUNGEON = "04"
MAP_FUNNYBONEFACTORY = "05"
MAP_FUNNYBONECITY = "06"
MAP_STAFFROLL = "07"
MAP_LOVERSTREE_ENDING = "97"
MAP_PROLOGUE = "98"
MAP_TITLE = "99"

CHARCOAL_MINIGAME_STRIKES = 664 // 0x01835953 bit0
CHARCOAL_MINIGAME_PLAYER_WINS = 666 // 0x01835953 bit2
CHARCOAL_MINIGAME_PROGAMER_WON = 725 // 0x0183595A bit5
CHARCOAL_MINIGAME_KIDSNOWADAYS_WON = 726 // 0x0183595A bit6
CHARCOAL_MINIGAME_REGULARCUSTOMER_WON = 727 // 0x0183595A bit7
LETTER_READ_ONIONLADY = 2112 // 0x01835A08 bit0
LETTER_READ_PINCHPONCHO = 2113 // 0x01835A08 bit1
LETTER_READ_VOODOO = 2114 // 0x01835A08 bit2
LETTER_READ_MISSCLAM = 2115 // 0x01835A08 bit3
LETTER_READ_CHOPPER = 2116 // 0x01835A08 bit4
LETTER_READ_SWIMMERDANIEL = 2117 // 0x01835A08 bit5
CHARCOAL_DEFEATED_TODAY = 2183 // 0x01835A10 bit7
KISSED_ONIONLADY = 2304 // 0x01835A20 bit0
KISSED_CHAMP = 2305 // 0x01835A20 bit1
KISSED_MRAPOLLO = 2306 // 0x01835A20 bit2
KISSED_MSTHICKGLASSES = 2307 // 0x01835A20 bit3
KISSED_MRRETIREDBUCKET = 2308 // 0x01835A20 bit4
KISSED_MRMUSICBOX = 2309 // 0x01835A20 bit5
KISSED_DRFILL = 2310 // 0x01835A20 bit6
KISSED_TINSIGNBOARD = 2311 // 0x01835A20 bit7
KISSED_PINCHPONCHO = 2312 // 0x01835A21 bit0
KISSED_THIEFTIPTOEIV = 2313 // 0x01835A21 bit1
KISSED_EUCALYPTUSKI = 2314 // 0x01835A21 bit2
KISSED_BOXMAN = 2315 // 0x01835A21 bit3
KISSED_CHUCK = 2316 // 0x01835A21 bit4
KISSED_AGONYMAN = 2317 // 0x01835A21 bit5
KISSED_SNOBBYTENGU = 2318 // 0x01835A21 bit6
KISSED_VOODOODOLL = 2319 // 0x01835A21 bit7
KISSED_EGGPLANTBOY = 2320 // 0x01835A22 bit0
KISSED_MRFROG = 2321 // 0x01835A22 bit1
KISSED_SWIMMERDANIEL = 2322 // 0x01835A22 bit2
KISSED_ROBOTKING = 2323 // 0x01835A22 bit3
KISSED_JIGSAW = 2324 // 0x01835A22 bit4
KISSED_MECHAYODZILLA = 2325 // 0x01835A22 bit5
KISSED_ADBALLOON = 2326 // 0x01835A22 bit6
KISSED_MANSPIDER = 2327 // 0x01835A22 bit7
KISSED_20YEAROLDGUY = 2328 // 0x01835A23 bit0
KISSED_MRSNIPER = 2329 // 0x01835A23 bit1
KISSED_MRTARGET = 2330 // 0x01835A23 bit2
KISSED_MISSCLAM = 2331 // 0x01835A23 bit3
KISSED_YODZILLA = 2332 // 0x01835A23 bit4
KISSED_JAMTRACK415 = 2333 // 0x01835A23 bit5
KISSED_CHOPPER = 2334 // 0x01835A23 bit6
KISSED_TURTLEBOY = 2335 // 0x01835A23 bit7
KISSED_HASTYWIZARD = 2336 // 0x01835A24 bit0
KISSED_BATAYAN = 2356 // 0x01835A26 bit4
KISSED_CHARCOAL = 2357 // 0x01835A26 bit5
KISSED_GORO = 2358 // 0x01835A26 bit6
KISSED_MONK = 2359 // 0x01835A26 bit7
KISSED_MICHELLE = 2360 // 0x01835A27 bit0
KISSED_POLICEMAN = 2361 // 0x01835A27 bit1
KISSED_MRSPLUM = 2362 // 0x01835A27 bit2
KISSED_BELL = 2363 // 0x01835A27 bit3
KISSED_JULIE = 2364 // 0x01835A27 bit4
KISSED_CONDUCTOR = 2365 // 0x01835A27 bit5
KISSED_MRCHEAPOT = 2366 // 0x01835A27 bit6
KISSED_DRDANDY = 2367 // 0x01835A27 bit7
KISSED_LEO = 2368 // 0x01835A28 bit0
KISSED_WORKER = 2374 // 0x01835A28 bit6
KISSED_SCARECROW = 2376 // 0x01835A29 bit0
KISSED_ALIEN = 2377 // 0x01835A29 bit1
KISSED_MISS_ZOMBIE = 2388 // 0x01835A2A bit4
ITEM_OBTAINED_MAGNIFIER = 2689 // 0x01835A50 bit1
ITEM_OBTAINED_EXPENSIVERING = 2693 // 0x01835A50 bit5
ITEM_OBTAINED_BROKENTELESCOPE = 2694 // 0x01835A50 bit6
ITEM_OBTAINED_RTTKT_SCF = 2695 // 0x01835A50 bit7
ITEM_OBTAINED_RTTKT_WDT = 2696 // 0x01835A51 bit0
ITEM_OBTAINED_RTTKT_FBC = 2697 // 0x01835A51 bit1
ITEM_OBTAINED_PRMNT_FREE_PASS = 2698 // 0x01835A51 bit2
ITEM_OBTAINED_MICHELLE_CARD = 2699 // 0x01835A51 bit3
ITEM_OBTAINED_LEO_CARD = 2700 // 0x01835A51 bit4
ITEM_OBTAINED_MRS_PLUM_CARD = 2701 // 0x01835A51 bit5
ITEM_OBTAINED_HER_CARD = 2702 // 0x01835A51 bit6
ITEM_OBTAINED_DR_DANDY_CARD = 2703 // 0x01835A51 bit7
ITEM_OBTAINED_POLICEMAN_CARD = 2704 // 0x01835A52 bit0
ITEM_OBTAINED_GORO_CARD = 2705 // 0x01835A52 bit1
ITEM_OBTAINED_MRCHEAPOT_CARD = 2707 // 0x01835A52 bit3
ITEM_OBTAINED_BATAYAN_CARD = 2708 // 0x01835A52 bit4
ITEM_OBTAINED_YOUR_CARD = 2709 // 0x01835A52 bit5
ITEM_OBTAINED_JULIE_PICTURE = 2710 // 0x01835A52 bit6
ITEM_OBTAINED_HEART_POTION = 2711 // 0x01835A52 bit7
ITEM_OBTAINED_HEART_BREAKER = 2712 // 0x01835A53 bit0
ITEM_OBTAINED_DEAD_CICADA2 = 2714 // 0x01835A53 bit2
ITEM_OBTAINED_POPSICLE = 2715 // 0x01835A53 bit3
ITEM_OBTAINED_FROG_1C = 2716 // 0x01835A53 bit4
ITEM_OBTAINED_FRESH_MINT = 2717 // 0x01835A53 bit5
ITEM_OBTAINED_WILTING_FLOWER = 2718 // 0x01835A53 bit6
ITEM_OBTAINED_LALAVENDER = 2719 // 0x01835A53 bit7
ITEM_OBTAINED_CLUSTER_MAMARYLLIS = 2720 // 0x01835A54 bit0
ITEM_OBTAINED_EYEBALL = 2721 // 0x01835A54 bit1
ITEM_OBTAINED_FUNNY_COLA = 2722 // 0x01835A54 bit2
ITEM_OBTAINED_MICRO_GUM = 2723 // 0x01835A54 bit3
ITEM_OBTAINED_BLACK_COOKIE = 2724 // 0x01835A54 bit4
ITEM_OBTAINED_HEART_CHOCOLATE = 2725 // 0x01835A54 bit5
ITEM_OBTAINED_MOCHI_KEBAB = 2726 // 0x01835A54 bit6
ITEM_OBTAINED_SWEET_POTATO_WINE = 2727 // 0x01835A54 bit7
ITEM_OBTAINED_COLD_SWEET_POTATO = 2728 // 0x01835A55 bit0
ITEM_OBTAINED_HOT_SWEET_POTATO = 2729 // 0x01835A55 bit1
ITEM_OBTAINED_BEST_SWEET_POTATO = 2730 // 0x01835A55 bit2
ITEM_OBTAINED_TOBACCO = 2731 // 0x01835A55 bit3
ITEM_OBTAINED_DENTURES = 2734 // 0x01835A55 bit6
ITEM_OBTAINED_ALIEN_DICT_1 = 2736 // 0x01835A56 bit0
ITEM_OBTAINED_ALIEN_DICT_2 = 2737 // 0x01835A56 bit1
ITEM_OBTAINED_ALIEN_DICT_3 = 2738 // 0x01835A56 bit2
ITEM_OBTAINED_ALIEN_DICT_4 = 2739 // 0x01835A56 bit3
ITEM_OBTAINED_REFRIGERATOR = 2741 // 0x01835A56 bit5
ITEM_OBTAINED_FRYINGPAN = 2742 // 0x01835A56 bit6
ITEM_OBTAINED_COMPUTER = 2743 // 0x01835A56 bit7
ITEM_OBTAINED_TEAPOT = 2744 // 0x01835A57 bit0
ITEM_OBTAINED_TIRE = 2745 // 0x01835A57 bit1
ITEM_OBTAINED_CLASSIFIED_AD = 2746 // 0x01835A57 bit2
ITEM_OBTAINED_1DAY_MANAGER_PASS = 2747 // 0x01835A57 bit3
ITEM_OBTAINED_LOVELETTER1 = 2748 // 0x01835A57 bit4
ITEM_OBTAINED_LEGENDARY_SWORD = 2749 // 0x01835A57 bit5
ITEM_OBTAINED_LOVE_INK = 2751 // 0x01835A57 bit7
ITEM_OBTAINED_LOVE_PAPER = 2752 // 0x01835A58 bit0
ITEM_OBTAINED_LOVE_PEN = 2753 // 0x01835A58 bit1
ITEM_OBTAINED_GOOD_LOVELETTER = 2754 // 0x01835A58 bit2
ITEM_OBTAINED_LOVELETTER2 = 2755 // 0x01835A58 bit3
ITEM_OBTAINED_LETTERSET = 2756 // 0x01835A58 bit4
ITEM_OBTAINED_BOSSCARD = 2757 // 0x01835A58 bit5
EVENT_2758 = 2758 // 0x01835A58 bit6
ITEM_OBTAINED_WEEKLY_COMIC = 2759 // 0x01835A58 bit7
ITEM_OBTAINED_MONTHLY_COMIC = 2760 // 0x01835A59 bit0
ITEM_OBTAINED_GOGO_COMIC = 2761 // 0x01835A59 bit1
EVENT_2762 = 2762 // 0x01835A59 bit2
EVENT_2763 = 2763 // 0x01835A59 bit3
ITEM_OBTAINED_GOODEGGPLANT = 2764 // 0x01835A59 bit4
ITEM_OBTAINED_GOODRADISH = 2765 // 0x01835A59 bit5
ITEM_OBTAINED_GOODCABBAGE = 2766 // 0x01835A59 bit6
ITEM_OBTAINED_JULIE_HAIR_PIN = 2767 // 0x01835A59 bit7
ITEM_OBTAINED_SPARE_KEY = 2768 // 0x01835A5A bit0
ITEM_OBTAINED_FROG_51 = 2769 // 0x01835A5A bit1
ITEM_OBTAINED_FUNNY_LETTER = 2770 // 0x01835A5A bit2
ITEM_OBTAINED_WINE_COUPON = 2771 // 0x01835A5A bit3
ITEM_OBTAINED_GOLD_RACCOON = 2772 // 0x01835A5A bit4
ITEM_OBTAINED_CRANE_FEATHER = 2773 // 0x01835A5A bit5
ITEM_OBTAINED_STARSEED = 2774 // 0x01835A5A bit6
ITEM_OBTAINED_GOOD_VEGGIE_SEED = 2775 // 0x01835A5A bit7
ITEM_OBTAINED_DAD_WOODEN_GONG = 2776 // 0x01835A5B bit0
ITEM_OBTAINED_INCENSE_STICKS = 2777 // 0x01835A5B bit1
ITEM_OBTAINED_POOPIE = 2778 // 0x01835A5B bit2
ITEM_OBTAINED_BIG_POOPIE = 2779 // 0x01835A5B bit3
ITEM_OBTAINED_HUGE_POOPIE = 2780 // 0x01835A5B bit4
ITEM_OBTAINED_SPEEDUPPLE = 2781 // 0x01835A5B bit5
ITEM_OBTAINED_DEAD_CICADA = 2782 // 0x01835A5B bit6
ITEM_OBTAINED_JIGSAW_PIECE_CORRECT = 2783 // 0x01835A5B bit7
ITEM_OBTAINED_JIGSAW_PIECE_1 = 2784 // 0x01835A5C bit0
ITEM_OBTAINED_JIGSAW_PIECE_2 = 2785 // 0x01835A5C bit1
ITEM_OBTAINED_SPACE_BANANA = 2786 // 0x01835A5C bit2
ITEM_OBTAINED_GOLD_POOPIE = 2787 // 0x01835A5C bit3
ITEM_OBTAINED_BEST_RADISH = 2788 // 0x01835A5C bit4
ITEM_OBTAINED_OLD_FILM = 2800 // 0x01835A5E bit0
ITEM_OBTAINED_KURODA_FILM = 2801 // 0x01835A5E bit1
ITEM_OBTAINED_TANIGUCHI_FILM = 2802 // 0x01835A5E bit2
ITEM_OBTAINED_HODA_FILM = 2803 // 0x01835A5E bit3
ITEM_OBTAINED_CHIN_FILM = 2804 // 0x01835A5E bit4
ITEM_OBTAINED_HIDEYUKI_FILM = 2805 // 0x01835A5E bit5
ITEM_OBTAINED_ISHIKAWA_FILM = 2806 // 0x01835A5E bit6
ITEM_OBTAINED_ITO_FILM = 2808 // 0x01835A5F bit0
ITEM_OBTAINED_KATSUSHI_FILM = 2809 // 0x01835A5F bit1
ITEM_OBTAINED_YUKIYOSHI_FILM = 2810 // 0x01835A5F bit2
ITEM_OBTAINED_MAEHARA_FILM = 2811 // 0x01835A5F bit3
ITEM_OBTAINED_KURASHIMA_FILM = 2812 // 0x01835A5F bit4
FBC_BUSH_EVENT_WITNESSED = 2936 // 0x01835A6F bit0
FBC_BUSH_EVENT_MONEY_RETRIEVED = 2938 // 0x01835A6F bit2
INTRO_ATTEMPTED_KISS_HER = 3140 // 0x01835A88 bit4
INTRO_DAD_LOST_LETTER_SET = 3141 // 0x01835A88 bit5
INTRO_LOVE_LETTER_WRITTEN = 3146 // 0x01835A89 bit2
INTRO_TUNNEL_OPENED = 3147 // 0x01835A89 bit3
INTRO_BAD_LETTER_DEPOSITED = 3148 // 0x01835A89 bit4
INTRO_MANHOLE_OUTSIDE = 3149 // 0x01835A89 bit5
INTRO_MANHOLE_INTRODUCTION = 3150 // 0x01835A89 bit6
INTRO_HER_MET = 3168 // 0x01835A8C bit0
INTRO_MICHELLE_MET = 3169 // 0x01835A8C bit1
INTRO_DANDY_MET = 3170 // 0x01835A8C bit2
INTRO_MRCHEAPOT_MET = 3171 // 0x01835A8C bit3
INTRO_BATAYAN_MET = 3172 // 0x01835A8C bit4
INTRO_MISSPLUM_MET = 3173 // 0x01835A8C bit5
PARK_BENCH_USED_MIDNIGHT = 3180 // 0x01835A8D bit4
PARK_BENCH_USED_LUNCH = 3182 // 0x01835A8D bit6
PARK_BENCH_USED_SUNSET = 3183 // 0x01835A8D bit7
INTRO_MICHELLE_DANDY_EAVESDROP = 3184 // 0x01835A8E bit0
INTRO_POLICEMAN_CONDUCTOR_EAVESDROP = 3185 // 0x01835A8E bit1
INTRO_DOG_STOLE_LETTER_SET = 3189 // 0x01835A8E bit5
INTRO_TALK_CHEAPOT_LOST_LETTER_SET = 3192 // 0x01835A8F bit0
LOVE_INK_RETURNED = 3212 // 0x01835A91 bit4
LOVE_PAPER_RETURNED = 3213 // 0x01835A91 bit5
LOVE_FOUNTAIN_PEN_RETURNED = 3214 // 0x01835A91 bit6
WDT_PANDA_SEEN = 3223 // 0x01835A92 bit7
INVISIBLE_MAN_TREASURE_OBTAINED = 3227 // 0x01835A93 bit3

GROUP_ALIEN_DICT = [
    ITEM_OBTAINED_ALIEN_DICT_1,
    ITEM_OBTAINED_ALIEN_DICT_2,
    ITEM_OBTAINED_ALIEN_DICT_3,
    ITEM_OBTAINED_ALIEN_DICT_4 
]

GROUP_FILM = [
    ITEM_OBTAINED_OLD_FILM,
    ITEM_OBTAINED_KURODA_FILM,
    ITEM_OBTAINED_TANIGUCHI_FILM, 
    ITEM_OBTAINED_HODA_FILM,
    ITEM_OBTAINED_CHIN_FILM,
    ITEM_OBTAINED_HIDEYUKI_FILM,
    ITEM_OBTAINED_ISHIKAWA_FILM,
    ITEM_OBTAINED_ITO_FILM,
    ITEM_OBTAINED_KATSUSHI_FILM,
    ITEM_OBTAINED_YUKIYOSHI_FILM,
    ITEM_OBTAINED_MAEHARA_FILM,
    ITEM_OBTAINED_KURASHIMA_FILM
]

GROUP_TRASH = [
    ITEM_OBTAINED_POOPIE, 
    ITEM_OBTAINED_BIG_POOPIE,
    ITEM_OBTAINED_HUGE_POOPIE,
    ITEM_OBTAINED_GOLD_POOPIE,
    ITEM_OBTAINED_REFRIGERATOR,
    ITEM_OBTAINED_FRYINGPAN,
    ITEM_OBTAINED_COMPUTER,
    ITEM_OBTAINED_TEAPOT,
    ITEM_OBTAINED_TIRE,
    ITEM_OBTAINED_EXPENSIVERING,
    ITEM_OBTAINED_BROKENTELESCOPE
]

GROUP_FOOD = [
    ITEM_OBTAINED_DEAD_CICADA2,
    ITEM_OBTAINED_POPSICLE,
    ITEM_OBTAINED_FROG_1C,
    ITEM_OBTAINED_FRESH_MINT,
    ITEM_OBTAINED_WILTING_FLOWER,
    ITEM_OBTAINED_LALAVENDER,
    ITEM_OBTAINED_CLUSTER_MAMARYLLIS,
    ITEM_OBTAINED_FUNNY_COLA,
    ITEM_OBTAINED_MICRO_GUM,
    ITEM_OBTAINED_BLACK_COOKIE,
    ITEM_OBTAINED_HEART_CHOCOLATE, 
    ITEM_OBTAINED_MOCHI_KEBAB,
    ITEM_OBTAINED_SWEET_POTATO_WINE, 
    ITEM_OBTAINED_COLD_SWEET_POTATO,
    ITEM_OBTAINED_HOT_SWEET_POTATO,
    ITEM_OBTAINED_BEST_SWEET_POTATO, 
    ITEM_OBTAINED_GOODEGGPLANT,
    ITEM_OBTAINED_GOODRADISH, 
    ITEM_OBTAINED_GOODCABBAGE,
    ITEM_OBTAINED_FROG_51, 
    ITEM_OBTAINED_STARSEED,
    ITEM_OBTAINED_GOOD_VEGGIE_SEED,
    ITEM_OBTAINED_SPEEDUPPLE, 
    ITEM_OBTAINED_DEAD_CICADA,
    ITEM_OBTAINED_SPACE_BANANA,
    ITEM_OBTAINED_BEST_RADISH
]

GROUP_MEET = [
    ITEM_OBTAINED_MICHELLE_CARD,
    ITEM_OBTAINED_LEO_CARD,
    ITEM_OBTAINED_MRS_PLUM_CARD,
    ITEM_OBTAINED_HER_CARD,
    ITEM_OBTAINED_DR_DANDY_CARD,
    ITEM_OBTAINED_POLICEMAN_CARD,
    ITEM_OBTAINED_GORO_CARD,
    ITEM_OBTAINED_MRCHEAPOT_CARD,
    ITEM_OBTAINED_BATAYAN_CARD,
    ITEM_OBTAINED_JULIE_PICTURE
]

GROUP_LETTER = [
    LETTER_READ_ONIONLADY,
    LETTER_READ_PINCHPONCHO,
    LETTER_READ_VOODOO,
    LETTER_READ_MISSCLAM,
    LETTER_READ_CHOPPER,
    LETTER_READ_SWIMMERDANIEL
]

GROUP_KISSES = [
    KISSED_ONIONLADY,
    KISSED_CHAMP,
    KISSED_MRAPOLLO,
    KISSED_MSTHICKGLASSES,
    KISSED_MRRETIREDBUCKET, 
    KISSED_MRMUSICBOX,
    KISSED_DRFILL,
    KISSED_TINSIGNBOARD,
    KISSED_PINCHPONCHO,
    KISSED_THIEFTIPTOEIV,
    KISSED_EUCALYPTUSKI,
    KISSED_BOXMAN,
    KISSED_CHUCK,
    KISSED_AGONYMAN,
    KISSED_SNOBBYTENGU,
    KISSED_VOODOODOLL,
    KISSED_EGGPLANTBOY,
    KISSED_MRFROG,
    KISSED_SWIMMERDANIEL,
    KISSED_ROBOTKING,
    KISSED_JIGSAW,
    KISSED_MECHAYODZILLA,
    KISSED_ADBALLOON,
    KISSED_MANSPIDER,
    KISSED_20YEAROLDGUY,
    KISSED_MRSNIPER,
    KISSED_MRTARGET,
    KISSED_MISSCLAM,
    KISSED_YODZILLA,
    KISSED_JAMTRACK415,
    KISSED_CHOPPER, 
    KISSED_TURTLEBOY,
    KISSED_HASTYWIZARD,
    KISSED_BATAYAN, 
    KISSED_CHARCOAL,
    KISSED_GORO,
    KISSED_MONK,
    KISSED_MICHELLE,
    KISSED_POLICEMAN,
    KISSED_MRSPLUM, 
    KISSED_BELL,
    KISSED_JULIE,
    KISSED_CONDUCTOR,
    KISSED_MRCHEAPOT,
    KISSED_DRDANDY,
    KISSED_LEO,
    KISSED_WORKER,
    KISSED_SCARECROW,
    KISSED_ALIEN,
    KISSED_MISS_ZOMBIE
]

// --------------------------------------------------------
// MARK: FUNCTIONS
// 
// --------------------------------------------------------
function current_map_is(map_string,offset=0) => ascii_string_equals(MAP_ADDRESS+offset, map_string)
function isTitle() => current_map_by_id(MAP_TITLE)
function validMap() => dword(MAP_ADDRESS) != 0 && current_map_is("\\MAP") && dword(EVENT_FLAG_PTR) != 0
function current_map_by_id(id) => current_map_is(id,4)

function inGame() => !isTitle() && validMap()

function dialogue_reached(id) => dialogue_id() == id && has_changed(dialogue_id())
function dialogue_checks(arr) => all_of(arr, d =>
    tally(1,dialogue_reached(d))
)

function event_flag(f) => bit(f%8, ptr(EVENT_FLAG_PTR) + f/8)
function sum_event_flags(g) => sum_of(g, i => event_flag(i))
function allow_player_movement() => bit(7,0x001ffb40) == 0
function wait_for_player_movement() => allow_player_movement() && never(prev(allow_player_movement()))

// --------------------------------------------------------
// MARK: RICH PRESENCE LOOKUPS
// 
// --------------------------------------------------------
LevelLookup = {
    0: "Poor Boy",
    1: "Poor Boy",
    2: "Hard Worker",
    3: "Pompous Boy",
    4: "Bragger Boy",
    5: "Bad Teenager",
    6: "Handsome Boy",
    7: "Ladykiller",
    8: "Player",
    9: "Frisky Man",
    10: "Big Shot",
}

RoomLLTLookup = {
    0x00: "(Drain Pipe) ",
    0x01: "(Batayan's Trailer) ",
    0x02: "(Yabu Hospital) ",
    0x03: "(Snack Shop) ",
    0x04: "(Tunnel) ",
    0x06: "(Your House) ",
    0x0a: "(Underground Residence) ",
    0x0c: "(Julie's Bar) ",
    0x0e: "(Your House) ",
    0x0f: "(Turtle Bath) ",
    0x11: "(Crossing Road) ",
    0x12: "(Tunnel) ",
    0x13: "(Tea Room) ",
    0x14: "(Suzuki's Home) ",
    0x17: "(Train Station) ",
    0x18: "(Michelle's House) ",
    0x19: "(Lover's Tree) ",
    0x1a: "(Coop) ",
    0x1b: "(Long Life Vista Point) ",
    0x1c: "(Mr. Cheapot's Store) "
}

RoomProLookup = {
    0x00: "(Lover's Tree) ",
    0x03: "(Your House) ",
    0x04: "(Tunnel) ",
    0x05: "(Suzuki's Home) ",
    0x06: "(Your House) ",
    0x0a: "(Underground Residence) ",
    0x0c: "(Julie's Bar) ",
    0x0e: "(Your House) ",
    0x0f: "(Turtle Bath) ",
    0x12: "(Tunnel) ",
    0x13: "(Tea Room) ",
    0x14: "(Suzuki's Home) ",
    0x17: "(Train Station) ",
    0x18: "(Michelle's House) ",
    0x19: "(Lover's Tree) ",
    0x1a: "(Coop) ",
    0x1b: "(Long Life Vista Point) ",
    0x1c: "(Mr. Cheapot's Store) "
}

RoomSCFLookup = {
    0x06: "(Mill) ",
    0x07: "(Top of Tower) ",
    0x08: "(Climbing Tower) "
}

RoomWDTLookup = {
    0x00: "(Cave) ",
    0x01: "(Inside Temple) ",
    0x02: "(Inside Temple Attic) ",
    //0x04: "(TRAIN LLT->WDT?) ",
    0x07: "(Staircase) ",
    0x08: "(Cemetery) ",
    0x0a: "(Graveyard) ",
    0x0d: "(Graveyard) "
}

ZeroPadLookup = {
    0:"0",
    1:"0",
    2:"0",
    3:"0",
    4:"0",
    5:"0",
    6:"0",
    7:"0",
    8:"0",
    9:"0"
}

//Time: current_time() * 2, "SECS"

// --------------------------------------------------------
// MARK: RICH PRESENCE CONDITIONALS
// 
// --------------------------------------------------------
rich_presence_conditional_display(current_map_by_id(MAP_LLT),"🗺️Long Life Town {0}✨{1} 💋{2} 💰{3}Z ❤️{4}/{5} 📅Day {6} 🕒{7}:{8}{9}",
    rich_presence_lookup("MapLLT", current_room(), RoomLLTLookup),
    rich_presence_lookup("Level", current_level(), LevelLookup),
    rich_presence_value("Number", current_kisses()),
    rich_presence_value("Number", current_money()),
    rich_presence_value("Number", current_hearts()),
    rich_presence_value("Number", max_hearts()),
    rich_presence_value("Number", current_day()),
    rich_presence_value("Hour", current_time() / 1800),
    rich_presence_lookup("MinutePad", (current_time() % 1800) / 30, ZeroPadLookup),
    rich_presence_value("Minute", (current_time() % 1800) / 30)
)

rich_presence_conditional_display(current_map_by_id(MAP_WDT),"🗺️Wordly Desire Temple {0}✨{1} 💋{2} 💰{3}Z ❤️{4}/{5} 📅Day {6} 🕒{7}:{8}{9}",
    rich_presence_lookup("MapWDT", current_room(), RoomWDTLookup),
    rich_presence_lookup("Level", current_level(), LevelLookup),
    rich_presence_value("Number", current_kisses()),
    rich_presence_value("Number", current_money()),
    rich_presence_value("Number", current_hearts()),
    rich_presence_value("Number", max_hearts()),
    rich_presence_value("Number", current_day()),
    rich_presence_value("Hour", current_time() / 1800),
    rich_presence_lookup("MinutePad", (current_time() % 1800) / 30, ZeroPadLookup),
    rich_presence_value("Minute", (current_time() % 1800) / 30)
)

rich_presence_conditional_display(current_map_by_id(MAP_SCF),"🗺️Scarecrow Field {0}✨{1} 💋{2} 💰{3}Z ❤️{4}/{5} 📅Day {6} 🕒{7}:{8}{9}",
    rich_presence_lookup("MapSCF", current_room(), RoomSCFLookup),
    rich_presence_lookup("Level", current_level(), LevelLookup),
    rich_presence_value("Number", current_kisses()),
    rich_presence_value("Number", current_money()),
    rich_presence_value("Number", current_hearts()),
    rich_presence_value("Number", max_hearts()),
    rich_presence_value("Number", current_day()),
    rich_presence_value("Hour", current_time() / 1800),
    rich_presence_lookup("MinutePad", (current_time() % 1800) / 30, ZeroPadLookup),
    rich_presence_value("Minute", (current_time() % 1800) / 30)
)

rich_presence_conditional_display(current_map_by_id(MAP_UNDASURAPARK),"🗺️Undasura Park ✨{0} 💋{1} 💰{2}Z ❤️{3}/{4} 📅Day {5} 🕒{6}:{7}{8}",
    rich_presence_lookup("Level", current_level(), LevelLookup),
    rich_presence_value("Number", current_kisses()),
    rich_presence_value("Number", current_money()),
    rich_presence_value("Number", current_hearts()),
    rich_presence_value("Number", max_hearts()),
    rich_presence_value("Number", current_day()),
    rich_presence_value("Hour", current_time() / 1800),
    rich_presence_lookup("MinutePad", (current_time() % 1800) / 30, ZeroPadLookup),
    rich_presence_value("Minute", (current_time() % 1800) / 30)
)

rich_presence_conditional_display(current_map_by_id(MAP_LASTDUNGEON),"🗺️Final Dungeon ✨{0} 💋{1} 💰{2}Z ❤️{3}/{4} 📅Day {5} 🕒{6}:{7}{8}",
    rich_presence_lookup("Level", current_level(), LevelLookup),
    rich_presence_value("Number", current_kisses()),
    rich_presence_value("Number", current_money()),
    rich_presence_value("Number", current_hearts()),
    rich_presence_value("Number", max_hearts()),
    rich_presence_value("Number", current_day()),
    rich_presence_value("Hour", current_time() / 1800),
    rich_presence_lookup("MinutePad", (current_time() % 1800) / 30, ZeroPadLookup),
    rich_presence_value("Minute", (current_time() % 1800) / 30)
)

rich_presence_conditional_display(current_map_by_id(MAP_FUNNYBONEFACTORY),"🗺️Funny Bone Factory ✨{0} 💋{1} 💰{2}Z ❤️{3}/{4} 📅Day {5} 🕒{6}:{7}{8}",
    rich_presence_lookup("Level", current_level(), LevelLookup),
    rich_presence_value("Number", current_kisses()),
    rich_presence_value("Number", current_money()),
    rich_presence_value("Number", current_hearts()),
    rich_presence_value("Number", max_hearts()),
    rich_presence_value("Number", current_day()),
    rich_presence_value("Hour", current_time() / 1800),
    rich_presence_lookup("MinutePad", (current_time() % 1800) / 30, ZeroPadLookup),
    rich_presence_value("Minute", (current_time() % 1800) / 30)
)

rich_presence_conditional_display(current_map_by_id(MAP_FUNNYBONECITY),"🗺️Funny Bone City ✨{0} 💋{1} 💰{2}Z ❤️{3}/{4} 📅Day {5} 🕒{6}:{7}{8}",
    rich_presence_lookup("Level", current_level(), LevelLookup),
    rich_presence_value("Number", current_kisses()),
    rich_presence_value("Number", current_money()),
    rich_presence_value("Number", current_hearts()),
    rich_presence_value("Number", max_hearts()),
    rich_presence_value("Number", current_day()),
    rich_presence_value("Hour", current_time() / 1800),
    rich_presence_lookup("MinutePad", (current_time() % 1800) / 30, ZeroPadLookup),
    rich_presence_value("Minute", (current_time() % 1800) / 30)
)
rich_presence_conditional_display(current_map_by_id(MAP_STAFFROLL),"Viewing Credits")

rich_presence_conditional_display(current_map_by_id(MAP_LOVERSTREE_ENDING),"🗺️Lover's Tree ✨{0} 💋{1} 💰{2}Z ❤️{3}/{4} 📅Day {5} 🕒{6}:{7}{8}",
    rich_presence_lookup("Level", current_level(), LevelLookup),
    rich_presence_value("Number", current_kisses()),
    rich_presence_value("Number", current_money()),
    rich_presence_value("Number", current_hearts()),
    rich_presence_value("Number", max_hearts()),
    rich_presence_value("Number", current_day()),
    rich_presence_value("Hour", current_time() / 1800),
    rich_presence_lookup("MinutePad", (current_time() % 1800) / 30, ZeroPadLookup),
    rich_presence_value("Minute", (current_time() % 1800) / 30)
)

rich_presence_conditional_display(current_map_by_id(MAP_PROLOGUE),"🗺️Long Life Town {0}✨{1} 💋{2} 💰{3}Z ❤️{4}/{5} 📅Day {6} 🕒{7}:{8}{9}",
    rich_presence_lookup("MapPro", current_room(), RoomProLookup),
    rich_presence_lookup("Level", current_level(), LevelLookup),
    rich_presence_value("Number", current_kisses()),
    rich_presence_value("Number", current_money()),
    rich_presence_value("Number", current_hearts()),
    rich_presence_value("Number", max_hearts()),
    rich_presence_value("Number", current_day()),
    rich_presence_value("Hour", current_time() / 1800),
    rich_presence_lookup("MinutePad", (current_time() % 1800) / 30, ZeroPadLookup),
    rich_presence_value("Minute", (current_time() % 1800) / 30)
)

rich_presence_conditional_display(current_map_by_id(MAP_TITLE),"Title Screen")

rich_presence_display("Loading...")

// --------------------------------------------------------
// MARK: ACHIEVEMENT FUNCTIONS
// 
// --------------------------------------------------------
function ach(ach, t) {
    achievement(
        title = ach[0],
        points = ach[2],
        description = ach[1],
        trigger = ach[3],
        type=t
    )
}

function achSumEventFlags(g) => measured(sum_event_flags(g) == length(g), when=inGame()) && 
                                prev(sum_event_flags(g)) < length(g) &&
                                prev(sum_event_flags(g)) > 0 &&
                                dword(EVENT_FLAG_PTR) == prev(dword(EVENT_FLAG_PTR))

function achSumEventFlagsStrict(g) => measured(sum_event_flags(g) == length(g), when=inGame()) && 
                                prev(sum_event_flags(g)) == length(g) - 1 && dword(EVENT_FLAG_PTR) == prev(dword(EVENT_FLAG_PTR))

function achEventFlag(id) => inGame() && has_increased(event_flag(id)) && dword(EVENT_FLAG_PTR) == prev(dword(EVENT_FLAG_PTR))

function achKissHer() => inGame() && current_map_by_id("97") && current_room() == 0 && prev(current_room()) == 0xffff

function achWorkerWorkout() => achRegainMovementAfterDialogueInMap([0x8a6,0xaa8], "05") || achRegainMovementAfterDialogueInMap([0x8e2,0xa90], "05")

function achReaperDamage() => never(!inGame()) && wait_for_player_movement() && tally(1,reaper_damage() == 100 && prev(reaper_damage() == 96))

function achDialogueMapFlag(d,m,f) => inGame() && event_flag(f) == 1 && current_map_by_id(m) && dialogue_reached(d) && dword(EVENT_FLAG_PTR) == prev(dword(EVENT_FLAG_PTR))

function achRegainMovementAfterDialogues(id_arr) => never(!inGame()) && wait_for_player_movement() && dialogue_checks(id_arr)
function achRegainMovementAfterEventFlag(id) => never(!inGame()) && wait_for_player_movement() && tally(1,dword(EVENT_FLAG_PTR) == prev(dword(EVENT_FLAG_PTR)) && has_increased(event_flag(id))) && never(current_map_by_id(MAP_LASTDUNGEON)) && never(current_map_by_id(MAP_STAFFROLL))

function achRegainMovementAfterDialogueInMap(id_arr, map_id) => never(!inGame()) && wait_for_player_movement() && dialogue_checks(id_arr) && never(!current_map_by_id(map_id))
function achDialogueIDReachedInMap(d_id, map_id) => inGame() && dialogue_reached(d_id) && current_map_by_id(map_id)

function achDialogueIDReached(id) => inGame() && dialogue_reached(id)

// --------------------------------------------------------
// MARK: ACHIEVEMENTS
// 
// --------------------------------------------------------


achs_reg = [
    ["A Champ's Kiss","Kiss Champ",3,achEventFlag(KISSED_CHAMP)],
    ["We Have Liftoff","Kiss Mr. Apollo",5,achEventFlag(KISSED_MRAPOLLO)],
    ["Young Graduate","Kiss Ms. Thick Glasses",3,achEventFlag(KISSED_MSTHICKGLASSES)],
    ["Pitiful Mr. Bucket","Kiss Retired Bucket",3,achEventFlag(KISSED_MRRETIREDBUCKET)],
    ["Every Last Note","Kiss Mr. Music Box",3,achEventFlag(KISSED_MRMUSICBOX)],
    ["Unemployed Artist","Kiss Batayan",10,achEventFlag(KISSED_BATAYAN)],
    ["Professional Sleepwalker","Kiss Mr. Dandy",10,achEventFlag(KISSED_DRDANDY)],
    ["Golden Raccoon","Kiss Mr. Cheapot",10,achEventFlag(KISSED_MRCHEAPOT)],
    ["Shackled and Zipped","Kiss Chuck",5,achEventFlag(KISSED_CHUCK)],
    ["Big Invention","Kiss Dr. Fill",5,achEventFlag(KISSED_DRFILL)],
    ["Look At Me","Kiss Tin Signboard",5,achEventFlag(KISSED_TINSIGNBOARD)],
    ["Red Light Green Light","Kiss Pinch Poncho",5,achEventFlag(KISSED_PINCHPONCHO)],
    ["Bar Thief","Kiss Thief Tip Toe IV",10,achEventFlag(KISSED_THIEFTIPTOEIV)],
    ["Clean Neighbor","Kiss Michelle",10,achEventFlag(KISSED_MICHELLE)],
    ["Smooch Criminal","Kiss Policeman",10,achEventFlag(KISSED_POLICEMAN)],
    ["Unappreciated Cook","Kiss Julie",10,achEventFlag(KISSED_JULIE)],
    ["Drunk Producer","Kiss Goro",5,achEventFlag(KISSED_GORO)],
    ["Sweet as Candy","Kiss Mrs. Plum",10,achEventFlag(KISSED_MRSPLUM)],
    ["Take a Bath Correctly","Kiss Leo",10,achEventFlag(KISSED_LEO)],
    ["Falling Down","Kiss Eucalyptuski",5,achEventFlag(KISSED_EUCALYPTUSKI)],
    ["Nude Aficionado","Kiss Turtle Boy",5,achEventFlag(KISSED_TURTLEBOY)],
    ["Yodzilla Attacks","Kiss Yodzilla",5,achEventFlag(KISSED_YODZILLA)],
    ["Station to Station","Kiss Jamtrack 415",10,achEventFlag(KISSED_JAMTRACK415)],
    ["Kiss to the Chopper","Kiss Chopper",10,achEventFlag(KISSED_CHOPPER)],
    ["World Traveler","Kiss Conductor",5,achEventFlag(KISSED_CONDUCTOR)],
    ["Mmmm! Ugh!","Kiss Agony Man",5,achEventFlag(KISSED_AGONYMAN)],
    ["Flipping Snob","Kiss Snobby Tengu",5,achEventFlag(KISSED_SNOBBYTENGU)],
    ["Never Forgive You","Kiss Voodoo Doll",10,achEventFlag(KISSED_VOODOODOLL)],
    ["Eat My Brethren","Kiss Eggplant Boy",10,achEventFlag(KISSED_EGGPLANTBOY)],
    ["Fresh Bellhop","Kiss Mr. Frog",5,achEventFlag(KISSED_MRFROG)],
    ["Bing! Bing! Pi-","Kiss Charcoal",10,achDialogueMapFlag(0x4adc,"01",KISSED_CHARCOAL)],
    ["Man of Many Words","Kiss Monk",10,achEventFlag(KISSED_MONK)],
    ["For Me the Bell Rings","Kiss Bell",10,achEventFlag(KISSED_BELL)],
    ["Youthful Undead","Kiss Miss Zombie Mika",10,achEventFlag(KISSED_MISS_ZOMBIE)],
    ["Casting Haste","Kiss Hasty Wizard",5,achEventFlag(KISSED_HASTYWIZARD)],
    ["Hungry Little Spider","Kiss Man Spider",5,achEventFlag(KISSED_MANSPIDER)],
    ["Traffic Surveyor","Kiss 20-Year-Old Guy",10,achEventFlag(KISSED_20YEAROLDGUY)],
    ["Steamed Clams","Kiss Miss Clam",10,achEventFlag(KISSED_MISSCLAM)],
    ["Armed Clockworker","Kiss Sniper",5,achEventFlag(KISSED_MRSNIPER)],
    ["A Target? Really!?","Kiss Target",5,achEventFlag(KISSED_MRTARGET)],
    ["Funny Scarecrow","Kiss Scarecrow",5,achEventFlag(KISSED_SCARECROW)],
    ["From Another Planet","Kiss Alien",10,achEventFlag(KISSED_ALIEN)],
    ["I Want to Fly Away","Kiss Ad Balloon",5,achEventFlag(KISSED_ADBALLOON)],
    ["Your Robot Majesty","Kiss Robot-King",10,achEventFlag(KISSED_ROBOTKING)],
    ["Born in a Factory","Kiss Mecha-Yodzilla",10,achEventFlag(KISSED_MECHAYODZILLA)],
    ["Puzzling Pieces","Kiss Jigsaw",25,achEventFlag(KISSED_JIGSAW)],
    ["So, How Do You Like My Swimming?","Kiss Swimmer Daniel",10,achEventFlag(KISSED_SWIMMERDANIEL)],
    ["Man in a Box","Kiss Box-Man",10,achEventFlag(KISSED_BOXMAN)],
    ["Working Hard or Hardly Working","Kiss Worker",10,achEventFlag(KISSED_WORKER)],
    ["Certified Lover Boy","Kiss all 50 residents, not including Her",50,achSumEventFlagsStrict(GROUP_KISSES)],
    ["Meet and Greet","Exchange cards with all 10 willing residents",10,achSumEventFlagsStrict(GROUP_MEET)],
    ["Mail Reader","Read every letter from kissed residents",5,achSumEventFlagsStrict(GROUP_LETTER)],
    ["First Class Pass","Buy the Prmnt. Free Pass",10,achEventFlag(ITEM_OBTAINED_PRMNT_FREE_PASS)],
    ["One Man's Poopie Is Another Man's Trash","Discover every garbage item",25,achSumEventFlags(GROUP_TRASH)],
    ["Snacks, Trash Cans and Dives","Discover every food item",25,achSumEventFlags(GROUP_FOOD)],
    ["Film Connoisseur","Discover every film",25,achSumEventFlagsStrict(GROUP_FILM)],
    ["Language Learner","Discover every Alien Dictionary",10,achSumEventFlagsStrict(GROUP_ALIEN_DICT)],
    ["Pro-Gamer","Defeat Charcoal at the 'Pro-gamer' level",3,achDialogueMapFlag(0x5056,"01",CHARCOAL_MINIGAME_PROGAMER_WON)],
    ["Kids Nowadays","Defeat Charcoal at the 'Kids Nowadays' level",5,achDialogueMapFlag(0x5056,"01",CHARCOAL_MINIGAME_KIDSNOWADAYS_WON)],
    ["Regular Customer","Defeat Charcoal at the 'Regular Customer' level",10,achDialogueMapFlag(0x5056,"01",CHARCOAL_MINIGAME_REGULARCUSTOMER_WON)],
    ["Freshen Up","Witness Leo filling the bath at Turtle Bath",3,achRegainMovementAfterDialogueInMap([0x805a,0x8072], "00")],
    ["Blur Blur Blur Blur","Get thoroughly disciplined by Julie for looking at her safe",5,achRegainMovementAfterDialogueInMap([0xccf0,0xcd46], "00")],
    ["Horoscope of the Day","Receive a 'Very Good' fortune reading in the Long Life Town Tunnel",5,achDialogueIDReachedInMap(0x1ee2, "00")],
    ["Midnight Massage","Receive Midnight Massage Service at Undasura Park",5,achRegainMovementAfterEventFlag(PARK_BENCH_USED_MIDNIGHT)],
    ["Batayan's Serenade","Attend Batayan's performance of 'A Single Guy's Serenade'",3,achRegainMovementAfterDialogueInMap([0xe6c6,0xe6fe], "00")],
    ["Feel So Good","Discover the famous Happy Panda of Worldly Desire Temple",5,achEventFlag(WDT_PANDA_SEEN)],
    ["Worker's Workout","Perform the Funny Bone Exercise correctly",5,achWorkerWorkout()],
    ["Out of the Bush and Into the Bathroom","Retrieve the naked mystery man's stashed cash at Funny Bone City",10,achEventFlag(FBC_BUSH_EVENT_MONEY_RETRIEVED)], //TODO: and check other flag?
    ["Royal Poopie","Survive after obtaining Gold Poopie",10,achRegainMovementAfterEventFlag(ITEM_OBTAINED_GOLD_POOPIE)],
    ["Invisible Men Tell Tales","Obtain the Invisible Man's treasure in Scarecrow Field",10,achEventFlag(INVISIBLE_MAN_TREASURE_OBTAINED)],
    ["Reaper's Curse","Prove you don't fear death, and receive a reward from the Reaper in Worldly Desire Temple",25,achReaperDamage()],
]

achs_missable = [
    ["Just My Type","Survive after donating blood against your will",10,achRegainMovementAfterDialogueInMap([0xfc64,0xfd04], "00")],
]

achs_prog = [
    ["My First Kiss","Kiss Onion Lady",5,achEventFlag(KISSED_ONIONLADY)],
    ["Love Ink Restored","Return the Love Ink to Mr. Suzuki",10,achEventFlag(LOVE_INK_RETURNED)],
    ["Love Fountain Pen Restored","Return the Love Fountain Pen to Mr. Suzuki",10,achEventFlag(LOVE_FOUNTAIN_PEN_RETURNED)],
    ["Love Paper Restored","Return the Love Paper to Mr. Suzuki",10,achEventFlag(LOVE_PAPER_RETURNED)],
]

achs_win = [
    ["Love at First Sight","Kiss Her",25,achKissHer()],

]

for a in achs_reg ach(a,"")
for a in achs_missable ach(a,"missable")
for a in achs_prog ach(a,"progression")
for a in achs_win ach(a,"win_condition")

// --------------------------------------------------------
// MARK: LEADERBOARDS
// 
// --------------------------------------------------------

// --------------------------------------------------------
// MARK: OLD LOGIC BACKUP
// 
// --------------------------------------------------------
/*
achievement(
    title = "My First Kiss", points = 3, type="progression",
    description = "Kiss Onion Lady.",
    id = 255315, badge = "283200", published = "10/12/2022 5:38:46 AM", modified = "10/12/2022 5:38:46 AM",
    trigger = prev(bit0(0x1835A20)) == 0 && bit0(0x1835A20) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "A Champ's Kiss", points = 4,
    description = "Kiss Champ.",
    id = 255325, badge = "283210", published = "10/12/2022 5:40:47 AM", modified = "10/12/2022 5:40:47 AM",
    trigger = prev(bit1(0x1835A20)) == 0 && bit1(0x1835A20) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "We Have Liftoff", points = 5,
    description = "Kiss Mr. Apollo.",
    id = 255334, badge = "283537", published = "10/12/2022 5:43:16 AM", modified = "10/13/2022 6:56:58 AM",
    trigger = prev(bit2(0x1835A20)) == 0 && bit2(0x1835A20) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Young Graduate", points = 4,
    description = "Kiss Ms. Thick Glasses.",
    id = 255328, badge = "283213", published = "10/12/2022 5:40:48 AM", modified = "10/12/2022 5:40:48 AM",
    trigger = prev(bit3(0x1835A20)) == 0 && bit3(0x1835A20) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Pitiful Mr. Bucket", points = 4,
    description = "Kiss Retired Bucket.",
    id = 255327, badge = "283212", published = "10/12/2022 5:40:47 AM", modified = "10/13/2022 6:40:38 AM",
    trigger = prev(bit4(0x1835A20)) == 0 && bit4(0x1835A20) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Every Last Note", points = 4,
    description = "Kiss Mr. Music Box.",
    id = 255326, badge = "283211", published = "10/12/2022 5:40:47 AM", modified = "10/12/2022 5:40:47 AM",
    trigger = prev(bit5(0x1835A20)) == 0 && bit5(0x1835A20) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Unemployed Artist", points = 10,
    description = "Kiss Batayan.",
    id = 255333, badge = "283538", published = "10/12/2022 5:43:16 AM", modified = "10/13/2022 6:56:58 AM",
    trigger = prev(bit4(0x1835A26)) == 0 && bit4(0x1835A26) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Healthy Doctor", points = 10,
    description = "Kiss Dr. Dandy.",
    id = 256023, badge = "283950", published = "10/14/2022 6:39:35 AM", modified = "10/14/2022 6:39:35 AM",
    trigger = prev(bit7(0x1835A27)) == 0 && bit7(0x1835A27) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Gold Raccoon", points = 10,
    description = "Kiss Mr. Cheapot.",
    id = 255340, badge = "283543", published = "10/12/2022 5:43:18 AM", modified = "10/16/2022 5:48:04 PM",
    trigger = prev(bit6(0x1835A27)) == 0 && bit6(0x1835A27) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Shackled and Zipped", points = 5,
    description = "Kiss Chuck.",
    id = 255318, badge = "283203", published = "10/12/2022 5:39:57 AM", modified = "10/12/2022 5:39:57 AM",
    trigger = prev(bit4(0x1835A21)) == 0 && bit4(0x1835A21) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Big Invention", points = 5,
    description = "Kiss Dr. Fill.",
    id = 256025, badge = "283952", published = "10/14/2022 7:19:02 AM", modified = "10/14/2022 7:19:02 AM",
    trigger = prev(bit6(0x1835A20)) == 0 && bit6(0x1835A20) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Look At Me", points = 5,
    description = "Kiss Tin Signboard.",
    id = 256022, badge = "283949", published = "10/14/2022 6:23:54 AM", modified = "10/14/2022 6:23:54 AM",
    trigger = prev(bit7(0x1835A20)) == 0 && bit7(0x1835A20) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Red Light Green Light", points = 5,
    description = "Kiss Pinch Poncho.",
    id = 255317, badge = "283202", published = "10/12/2022 5:39:57 AM", modified = "10/12/2022 5:39:57 AM",
    trigger = prev(bit0(0x1835A21)) == 0 && bit0(0x1835A21) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Bar Thief", points = 10,
    description = "Kiss Thief Tip Toe IV.",
    id = 256011, badge = "283937", published = "10/14/2022 3:47:42 AM", modified = "10/14/2022 3:47:42 AM",
    trigger = prev(bit1(0x1835A21)) == 0 && bit1(0x1835A21) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Clean Neighbor", points = 10,
    description = "Kiss Michelle.",
    id = 255339, badge = "283536", published = "10/12/2022 5:43:18 AM", modified = "10/13/2022 6:56:57 AM",
    trigger = prev(bit0(0x1835A27)) == 0 && bit0(0x1835A27) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Smooch Criminal", points = 10,
    description = "Kiss Policeman.",
    id = 255342, badge = "283541", published = "10/12/2022 5:43:19 AM", modified = "10/13/2022 11:06:13 PM",
    trigger = prev(bit1(0x1835A27)) == 0 && bit1(0x1835A27) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Unappreciated Cook", points = 10,
    description = "Kiss Julie.",
    id = 255337, badge = "283542", published = "10/12/2022 5:43:17 AM", modified = "10/13/2022 6:56:59 AM",
    trigger = prev(bit4(0x1835A27)) == 0 && bit4(0x1835A27) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Drunk Producer", points = 5,
    description = "Kiss Goro.",
    id = 255575, badge = "283523", published = "10/13/2022 5:31:31 AM", modified = "10/13/2022 6:18:37 AM",
    trigger = prev(bit6(0x1835A26)) == 0 && bit6(0x1835A26) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Sweet as Candy", points = 10,
    description = "Kiss Mrs. Plum.",
    id = 255341, badge = "283539", published = "10/12/2022 5:43:18 AM", modified = "10/16/2022 5:48:29 PM",
    trigger = prev(bit2(0x1835A27)) == 0 && bit2(0x1835A27) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Take a Bath Correctly", points = 10,
    description = "Kiss Leo.",
    id = 255324, badge = "283209", published = "10/12/2022 5:40:33 AM", modified = "10/12/2022 5:40:33 AM",
    trigger = prev(bit0(0x1835A28)) == 0 && bit0(0x1835A28) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Falling Down", points = 5,
    description = "Kiss Eucalyptuski.",
    id = 256021, badge = "283948", published = "10/14/2022 6:17:19 AM", modified = "10/14/2022 6:17:19 AM",
    trigger = prev(bit2(0x1835A21)) == 0 && bit2(0x1835A21) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Nude Aficionado", points = 5,
    description = "Kiss Turtle Boy.",
    id = 256014, badge = "283940", published = "10/14/2022 4:29:08 AM", modified = "10/14/2022 4:29:08 AM",
    trigger = prev(bit7(0x1835A23)) == 0 && bit7(0x1835A23) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Yodzilla Attacks", points = 5,
    description = "Kiss Yodzilla.",
    id = 255322, badge = "283207", published = "10/12/2022 5:40:33 AM", modified = "10/12/2022 5:40:33 AM",
    trigger = prev(bit4(0x1835A23)) == 0 && bit4(0x1835A23) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Station to Station", points = 10,
    description = "Kiss Jamtrack 415.",
    id = 256003, badge = "283926", published = "10/14/2022 2:38:20 AM", modified = "10/14/2022 2:38:20 AM",
    trigger = prev(bit5(0x1835A23)) == 0 && bit5(0x1835A23) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Kiss to the Chopper", points = 10,
    description = "Kiss Chopper.",
    id = 256004, badge = "283927", published = "10/14/2022 2:38:20 AM", modified = "10/14/2022 2:38:20 AM",
    trigger = prev(bit6(0x1835A23)) == 0 && bit6(0x1835A23) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "World Traveler", points = 5,
    description = "Kiss Conductor.",
    id = 255571, badge = "283519", published = "10/13/2022 5:30:50 AM", modified = "10/13/2022 5:30:50 AM",
    trigger = prev(bit5(0x1835A27)) == 0 && bit5(0x1835A27) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Mmmm! Ugh!", points = 5,
    description = "Kiss Agony Man.",
    id = 255316, badge = "283201", published = "10/12/2022 5:39:57 AM", modified = "10/12/2022 5:39:57 AM",
    trigger = prev(bit5(0x1835A21)) == 0 && bit5(0x1835A21) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Flipping Snob", points = 5,
    description = "Kiss Snobby Tengu.",
    id = 255338, badge = "283540", published = "10/12/2022 5:43:17 AM", modified = "10/13/2022 6:56:59 AM",
    trigger = prev(bit6(0x1835A21)) == 0 && bit6(0x1835A21) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Never Forgive You", points = 10,
    description = "Kiss Voodoo Doll.",
    id = 256007, badge = "283930", published = "10/14/2022 2:57:19 AM", modified = "10/14/2022 2:57:19 AM",
    trigger = prev(bit7(0x1835A21)) == 0 && bit7(0x1835A21) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Eat My Brethren", points = 10,
    description = "Kiss Eggplant Boy.",
    id = 256006, badge = "283929", published = "10/14/2022 2:49:34 AM", modified = "10/14/2022 2:49:34 AM",
    trigger = prev(bit0(0x1835A22)) == 0 && bit0(0x1835A22) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Fresh Bellhop", points = 5,
    description = "Kiss Mr. Frog.",
    id = 255321, badge = "283206", published = "10/12/2022 5:40:32 AM", modified = "10/12/2022 5:40:32 AM",
    trigger = prev(bit1(0x1835A22)) == 0 && bit1(0x1835A22) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Bing! Bing! Pi-", points = 10,
    description = "Kiss Charcoal.",
    id = 256015, badge = "283941", published = "10/14/2022 4:29:08 AM", modified = "10/14/2022 4:29:08 AM",
    trigger = dword(0x2D8880) != prev(dword(0x2D8880)) && dword(0x2D8880) == 19164 && bit5(0x1835A26) == 1 &&
              dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Man of Words", points = 10,
    description = "Kiss Monk.",
    id = 256005, badge = "283928", published = "10/14/2022 2:40:27 AM", modified = "10/14/2022 2:40:27 AM",
    trigger = prev(bit7(0x1835A26)) == 0 && bit7(0x1835A26) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "For Me the Bell Rings", points = 10,
    description = "Kiss Bell.",
    id = 256016, badge = "283942", published = "10/14/2022 4:29:08 AM", modified = "10/14/2022 4:29:08 AM",
    trigger = prev(bit3(0x1835A27)) == 0 && bit3(0x1835A27) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Youthful Undead", points = 10,
    description = "Kiss Miss Zombie Mika.",
    id = 256020, badge = "283947", published = "10/14/2022 6:12:17 AM", modified = "10/14/2022 6:12:17 AM",
    trigger = prev(bit4(0x1835A2A)) == 0 && bit4(0x1835A2A) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Casting Haste", points = 5,
    description = "Kiss Hasty Wizard.",
    id = 255320, badge = "283205", published = "10/12/2022 5:40:32 AM", modified = "10/12/2022 5:40:32 AM",
    trigger = prev(bit0(0x1835A24)) == 0 && bit0(0x1835A24) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Hungry Little Spider", points = 5,
    description = "Kiss Man Spider.",
    id = 256000, badge = "283923", published = "10/14/2022 2:08:08 AM", modified = "10/14/2022 2:08:08 AM",
    trigger = prev(bit7(0x1835A22)) == 0 && bit7(0x1835A22) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Traffic Surveyor", points = 10,
    description = "Kiss 20-Year-Old Guy.",
    id = 255319, badge = "283204", published = "10/12/2022 5:39:58 AM", modified = "10/13/2022 6:40:38 AM",
    trigger = prev(bit0(0x1835A23)) == 0 && bit0(0x1835A23) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Steamed Clams", points = 10,
    description = "Kiss Miss Clam.",
    id = 255323, badge = "283208", published = "10/12/2022 5:40:33 AM", modified = "10/12/2022 5:40:33 AM",
    trigger = prev(bit3(0x1835A23)) == 0 && bit3(0x1835A23) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Armed Clockworker", points = 5,
    description = "Kiss Sniper.",
    id = 255329, badge = "283214", published = "10/12/2022 5:40:48 AM", modified = "10/13/2022 6:40:39 AM",
    trigger = prev(bit1(0x1835A23)) == 0 && bit1(0x1835A23) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "A Target? Really!?", points = 5,
    description = "Kiss Target.",
    id = 256002, badge = "283925", published = "10/14/2022 2:22:07 AM", modified = "10/14/2022 2:22:07 AM",
    trigger = prev(bit2(0x1835A23)) == 0 && bit2(0x1835A23) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Funny Scarecrow", points = 5,
    description = "Kiss Scarecrow.",
    id = 255998, badge = "283922", published = "10/14/2022 1:50:12 AM", modified = "10/14/2022 1:50:12 AM",
    trigger = prev(bit0(0x1835A29)) == 0 && bit0(0x1835A29) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "From Another Planet", points = 10,
    description = "Kiss Alien.",
    id = 256001, badge = "283924", published = "10/14/2022 2:08:08 AM", modified = "10/14/2022 2:08:08 AM",
    trigger = prev(bit1(0x1835A29)) == 0 && bit1(0x1835A29) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Balloon Girl", points = 5,
    description = "Kiss Ad Balloon.",
    id = 255576, badge = "283525", published = "10/13/2022 6:35:54 AM", modified = "10/13/2022 6:35:54 AM",
    trigger = prev(bit6(0x1835A22)) == 0 && bit6(0x1835A22) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Your Robot Majesty", points = 10,
    description = "Kiss Robot-King.",
    id = 255813, badge = "283755", published = "10/13/2022 11:33:51 PM", modified = "10/13/2022 11:33:51 PM",
    trigger = prev(bit3(0x1835A22)) == 0 && bit3(0x1835A22) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Born in a Factory", points = 10,
    description = "Kiss Mecha-Yodzilla.",
    id = 255811, badge = "283753", published = "10/13/2022 11:25:03 PM", modified = "10/13/2022 11:25:03 PM",
    trigger = prev(bit5(0x1835A22)) == 0 && bit5(0x1835A22) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Puzzling Pieces", points = 25,
    description = "Kiss Jigsaw.",
    id = 255837, badge = "283779", published = "10/13/2022 11:55:07 PM", modified = "10/13/2022 11:55:07 PM",
    trigger = prev(bit4(0x1835A22)) == 0 && bit4(0x1835A22) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "So, How Do You Like My Swimming?", points = 10,
    description = "Kiss Swimmer Daniel.",
    id = 255810, badge = "283752", published = "10/13/2022 11:25:03 PM", modified = "10/13/2022 11:25:03 PM",
    trigger = prev(bit2(0x1835A22)) == 0 && bit2(0x1835A22) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Man in a Box", points = 5,
    description = "Kiss Box-Man.",
    id = 255812, badge = "283754", published = "10/13/2022 11:33:51 PM", modified = "10/13/2022 11:33:51 PM",
    trigger = prev(bit3(0x1835A21)) == 0 && bit3(0x1835A21) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Working Hard or Hardly Working", points = 10,
    description = "Kiss Worker.",
    id = 255997, badge = "283921", published = "10/14/2022 1:36:31 AM", modified = "10/14/2022 1:36:31 AM",
    trigger = prev(bit6(0x1835A28)) == 0 && bit6(0x1835A28) == 1 && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "Love Ink Restored", points = 10, type="progression",
    description = "Return the Love Ink to Mr. Suzuki.",
    id = 256028, badge = "283953", published = "10/14/2022 7:45:07 AM", modified = "10/14/2022 7:45:07 AM",
    trigger = bit4(0x1835A91) > prev(bit4(0x1835A91)) && dword(0x2A1E80) == 6396160
)

achievement(
    title = "Love Fountain Pen Restored", points = 10, type="progression",
    description = "Return the Love Fountain Pen to Mr. Suzuki.",
    id = 256029, badge = "283954", published = "10/14/2022 7:45:07 AM", modified = "10/14/2022 11:57:48 PM",
    trigger = bit6(0x1835A91) > prev(bit6(0x1835A91)) && dword(0x2A1E80) == 6396160
)

achievement(
    title = "Love Paper Restored", points = 10, type="progression",
    description = "Return the Love Paper to Mr. Suzuki.",
    id = 256030, badge = "283955", published = "10/14/2022 7:45:07 AM", modified = "10/14/2022 11:57:48 PM",
    trigger = bit5(0x1835A91) > prev(bit5(0x1835A91)) && dword(0x2A1E80) == 6396160
)


achievement(
    title = "Love at First Sight", points = 25, type="win_condition",
    description = "Kiss Her.",
    id = 256354, badge = "284299", published = "10/14/2022 11:32:21 PM", modified = "10/14/2022 11:32:21 PM",
    trigger = dword(0x2A1E80) == 5927424 && prev(word(0x1835B0C)) == 65535 && word(0x1835B0C) == 0
)


achievement(
    title = "Certified Lover Boy", points = 50,
    description = "Kiss Her after kissing all 50 residents.",
    id = 256353, badge = "284298", published = "10/14/2022 11:32:20 PM", modified = "2/22/2023 8:00:35 PM",
    trigger = measured((bit0(0x1835A20) + bit1(0x1835A20) + bit2(0x1835A20) + bit3(0x1835A20) + bit4(0x1835A20) +
                  bit5(0x1835A20) + bit6(0x1835A20) + bit7(0x1835A20) + bit0(0x1835A21) + bit1(0x1835A21) + bit2(0x1835A21)
                  + bit3(0x1835A21) + bit4(0x1835A21) + bit5(0x1835A21) + bit6(0x1835A21) + bit7(0x1835A21) +
                  bit0(0x1835A22) + bit1(0x1835A22) + bit2(0x1835A22) + bit3(0x1835A22) + bit4(0x1835A22) + bit5(0x1835A22)
                  + bit6(0x1835A22) + bit7(0x1835A22) + bit0(0x1835A23) + bit1(0x1835A23) + bit2(0x1835A23) +
                  bit3(0x1835A23) + bit4(0x1835A23) + bit5(0x1835A23) + bit6(0x1835A23) + bit7(0x1835A23) + bit0(0x1835A24)
                  + bit4(0x1835A26) + bit5(0x1835A26) + bit6(0x1835A26) + bit7(0x1835A26) + bit0(0x1835A27) +
                  bit1(0x1835A27) + bit2(0x1835A27) + bit3(0x1835A27) + bit4(0x1835A27) + bit5(0x1835A27) + bit6(0x1835A27)
                  + bit7(0x1835A27) + bit0(0x1835A28) + bit6(0x1835A28) + bit0(0x1835A29) + bit1(0x1835A29) +
                  bit4(0x1835A2A)) == 50, when=(dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0)
              ) && dword(0x2A1E80) == 5927424 && prev(word(0x1835B0C)) == 65535 && word(0x1835B0C) == 0
)

achievement(
    title = "Meet and Greet", points = 10,
    description = "Exchange cards with all 10 willing residents.",
    id = 255345, badge = "283229", published = "10/12/2022 6:30:26 AM", modified = "2/22/2023 8:00:36 PM",
    trigger = measured((bit3(0x1835A51) + bit4(0x1835A51) + bit5(0x1835A51) + bit6(0x1835A51) + bit7(0x1835A51) +
                  bit0(0x1835A52) + bit1(0x1835A52) + bit3(0x1835A52) + bit4(0x1835A52) + bit6(0x1835A52)) == 10,
                  when=(dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0)
              ) &&
              (prev(bit3(0x1835A51)) + prev(bit4(0x1835A51)) + prev(bit5(0x1835A51)) + prev(bit6(0x1835A51)) +
              prev(bit7(0x1835A51)) + prev(bit0(0x1835A52)) + prev(bit1(0x1835A52)) + prev(bit3(0x1835A52)) +
              prev(bit4(0x1835A52)) + prev(bit6(0x1835A52))) < 10
)

achievement(
    title = "Mail Reader", points = 5,
    description = "Read every letter from kissed residents.",
    id = 256031, badge = "283956", published = "10/14/2022 7:45:08 AM", modified = "2/22/2023 8:00:36 PM",
    trigger = measured((bit0(0x1835A08) + bit1(0x1835A08) + bit2(0x1835A08) + bit3(0x1835A08) + bit4(0x1835A08) +
                  bit5(0x1835A08)) == 6, when=(dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0)
              ) &&
              (prev(bit0(0x1835A08)) + prev(bit1(0x1835A08)) + prev(bit2(0x1835A08)) + prev(bit3(0x1835A08)) +
              prev(bit4(0x1835A08)) + prev(bit5(0x1835A08))) == 5 &&
              (dword(0x2A1E80) == 6396160 || dword(0x2A1E80) == 6395136 || dword(0x2A1E80) == 5910848)
)

achievement(
    title = "First Class Pass", points = 10,
    description = "Buy the Prmnt. Free Pass.",
    id = 255573, badge = "283521", published = "10/13/2022 5:30:51 AM", modified = "10/13/2022 5:30:51 AM",
    trigger = bit2(0x1835A51) > prev(bit2(0x1835A51)) && dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0
)

achievement(
    title = "One Man's Poopie Is Another Man's Trash", points = 25,
    description = "Obtain every garbage item at least once.",
    id = 256350, badge = "284295", published = "10/14/2022 11:32:19 PM", modified = "2/22/2023 8:00:36 PM",
    trigger = measured((bit2(0x1835A5B) + bit3(0x1835A5B) + bit4(0x1835A5B) + bit3(0x1835A5C) + bit5(0x1835A56) +
                  bit6(0x1835A56) + bit7(0x1835A56) + bit0(0x1835A57) + bit1(0x1835A57) + bit6(0x1835A50) + bit5(0x1835A50))
                  == 11, when=(dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0)
              ) &&
              (prev(bit2(0x1835A5B)) + prev(bit3(0x1835A5B)) + prev(bit4(0x1835A5B)) + prev(bit3(0x1835A5C)) +
              prev(bit5(0x1835A56)) + prev(bit6(0x1835A56)) + prev(bit7(0x1835A56)) + prev(bit0(0x1835A57)) +
              prev(bit1(0x1835A57)) + prev(bit6(0x1835A50)) + prev(bit5(0x1835A50))) == 10
)

achievement(
    title = "Snacks, Trash Cans and Dives", points = 25,
    description = "Obtain every food item at least once.",
    id = 256352, badge = "284297", published = "10/14/2022 11:32:20 PM", modified = "2/22/2023 8:00:37 PM",
    trigger = measured((bit2(0x1835A53) + bit3(0x1835A53) + bit4(0x1835A53) + bit5(0x1835A53) + bit6(0x1835A53) +
                  bit7(0x1835A53) + bit0(0x1835A54) + bit2(0x1835A54) + bit3(0x1835A54) + bit4(0x1835A54) + bit5(0x1835A54)
                  + bit6(0x1835A54) + bit7(0x1835A54) + bit0(0x1835A55) + bit1(0x1835A55) + bit2(0x1835A55) +
                  bit4(0x1835A59) + bit5(0x1835A59) + bit6(0x1835A59) + bit1(0x1835A5A) + bit6(0x1835A5A) + bit7(0x1835A5A)
                  + bit5(0x1835A5B) + bit6(0x1835A5B) + bit2(0x1835A5C) + bit4(0x1835A5C)) == 26,
                  when=(dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0)
              ) &&
              (prev(bit2(0x1835A53)) + prev(bit3(0x1835A53)) + prev(bit4(0x1835A53)) + prev(bit5(0x1835A53)) +
              prev(bit6(0x1835A53)) + prev(bit7(0x1835A53)) + prev(bit0(0x1835A54)) + prev(bit2(0x1835A54)) +
              prev(bit3(0x1835A54)) + prev(bit4(0x1835A54)) + prev(bit5(0x1835A54)) + prev(bit6(0x1835A54)) +
              prev(bit7(0x1835A54)) + prev(bit0(0x1835A55)) + prev(bit1(0x1835A55)) + prev(bit2(0x1835A55)) +
              prev(bit4(0x1835A59)) + prev(bit5(0x1835A59)) + prev(bit6(0x1835A59)) + prev(bit1(0x1835A5A)) +
              prev(bit6(0x1835A5A)) + prev(bit7(0x1835A5A)) + prev(bit5(0x1835A5B)) + prev(bit6(0x1835A5B)) +
              prev(bit2(0x1835A5C)) + prev(bit4(0x1835A5C))) == 25
)

achievement(
    title = "Film Connoisseur", points = 25,
    description = "Obtain every film at least once.",
    id = 256351, badge = "284296", published = "10/14/2022 11:32:20 PM", modified = "2/22/2023 8:00:37 PM",
    trigger = measured((bit0(0x1835A5E) + bit1(0x1835A5E) + bit2(0x1835A5E) + bit3(0x1835A5E) + bit4(0x1835A5E) +
                  bit5(0x1835A5E) + bit6(0x1835A5E) + bit0(0x1835A5F) + bit1(0x1835A5F) + bit2(0x1835A5F) + bit3(0x1835A5F)
                  + bit4(0x1835A5F)) == 12, when=(dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0)
              ) &&
              (prev(bit0(0x1835A5E)) + prev(bit1(0x1835A5E)) + prev(bit2(0x1835A5E)) + prev(bit3(0x1835A5E)) +
              prev(bit4(0x1835A5E)) + prev(bit5(0x1835A5E)) + prev(bit6(0x1835A5E)) + prev(bit0(0x1835A5F)) +
              prev(bit1(0x1835A5F)) + prev(bit2(0x1835A5F)) + prev(bit3(0x1835A5F)) + prev(bit4(0x1835A5F))) == 11
)

achievement(
    title = "Language Learner", points = 10,
    description = "Obtain every Alien Dictionary at least once.",
    id = 255335, badge = "283946", published = "10/12/2022 5:43:16 AM", modified = "2/22/2023 8:00:37 PM",
    trigger = measured((bit0(0x1835A56) + bit1(0x1835A56) + bit2(0x1835A56) + bit3(0x1835A56)) == 4,
                  when=(dword(0x2A1E80) != 5835648 && dword(0x2A1E80) != 0)
              ) && (prev(bit0(0x1835A56)) + prev(bit1(0x1835A56)) + prev(bit2(0x1835A56)) + prev(bit3(0x1835A56))) == 3
)*/

/*
achievement(
    title = "Pro-Gamer", points = 3,
    description = "Defeat Charcoal at the 'Pro-gamer' level.",
    id = 256017, badge = "283943", published = "10/14/2022 5:21:19 AM", modified = "10/14/2022 5:21:19 AM",
    trigger = dword(0x2A1E80) == 6385408 && bit5(0x183595A) == 1 && dword(0x2D8880) != prev(dword(0x2D8880)) &&
              dword(0x2D8880) == 20566
)

achievement(
    title = "Kids Nowadays", points = 5,
    description = "Defeat Charcoal at the 'Kids Nowadays' level.",
    id = 256018, badge = "283944", published = "10/14/2022 5:21:19 AM", modified = "10/14/2022 5:21:19 AM",
    trigger = dword(0x2A1E80) == 6385408 && bit6(0x183595A) == 1 && dword(0x2D8880) != prev(dword(0x2D8880)) &&
              dword(0x2D8880) == 20566
)

achievement(
    title = "Regular Customer", points = 10,
    description = "Defeat Charcoal at the 'Regular Customer' level.",
    id = 256019, badge = "283945", published = "10/14/2022 5:21:20 AM", modified = "10/14/2022 5:21:20 AM",
    trigger = dword(0x2A1E80) == 6385408 && bit7(0x183595A) == 1 && dword(0x2D8880) != prev(dword(0x2D8880)) &&
              dword(0x2D8880) == 20566
)
achievement(
    title = "Freshen Up", points = 3,
    description = "Witness Leo filling the bath at Turtle Bath.",
    id = 255336, badge = "283545", published = "10/12/2022 5:43:17 AM", modified = "10/13/2022 7:22:29 AM",
    trigger = (dword(0x2A1E80) == 6396160 || dword(0x2A1E80) == 6395136 || dword(0x2A1E80) == 5910848) &&
              once(dword(0x2D8880) != prev(dword(0x2D8880)) && dword(0x2D8880) == 32858) &&
              once(dword(0x2D8880) != prev(dword(0x2D8880)) && dword(0x2D8880) == 32882) && bit7(0x1FFB40) == 0 &&
              never(prev(bit7(0x1FFB40)) == 0) && never(dword(0x2A1E80) == 0) && never(dword(0x2A1E80) == 5905152)
)

achievement(
    title = "Blur Blur Blur Blur", points = 3,
    description = "Get thoroughly disciplined by Julie for looking at her safe.",
    id = 255587, badge = "283546", published = "10/13/2022 7:41:57 AM", modified = "10/13/2022 7:41:57 AM",
    trigger = (dword(0x2A1E80) == 6396160 || dword(0x2A1E80) == 6395136 || dword(0x2A1E80) == 5910848) &&
              once(dword(0x2D8880) != prev(dword(0x2D8880)) && dword(0x2D8880) == 52464) &&
              once(dword(0x2D8880) != prev(dword(0x2D8880)) && dword(0x2D8880) == 52550) && bit7(0x1FFB40) == 0 &&
              never(prev(bit7(0x1FFB40)) == 0) && never(dword(0x2A1E80) == 0) && never(dword(0x2A1E80) == 5905152)
)

achievement(
    title = "Horoscope of the Day", points = 10,
    description = "Receive a 'Very Good' fortune reading in the Long Life Town Tunnel.",
    id = 255330, badge = "283215", published = "10/12/2022 5:42:42 AM", modified = "10/12/2022 5:42:42 AM",
    trigger = word(0x1835B0C) == 18 &&
              (dword(0x2A1E80) == 6396160 || dword(0x2A1E80) == 6395136 || dword(0x2A1E80) == 5910848) &&
              word(0x1835BD0) != prev(word(0x1835BD0)) && word(0x1835BD0) == 1
)

achievement(
    title = "Midnight Massage", points = 4,
    description = "Receive Midnight Massage Service at Undasura Park.",
    id = 255343, badge = "283228", published = "10/12/2022 5:54:18 AM", modified = "10/13/2022 5:28:11 AM",
    trigger = dword(0x2A1E80) == 6105664 && once(bit4(0x1835A8D) > prev(bit4(0x1835A8D))) && bit7(0x1FFB40) == 0 &&
              never(prev(bit7(0x1FFB40)) == 0) && never(dword(0x2A1E80) == 0) && never(dword(0x2A1E80) == 5905152)
)

achievement(
    title = "Just My Type", points = 10, type="missable",
    description = "Donate blood unwillingly - and survive.",
    id = 255572, badge = "283520", published = "10/13/2022 5:30:50 AM", modified = "10/13/2022 5:34:51 AM",
    trigger = (dword(0x2A1E80) == 6396160 || dword(0x2A1E80) == 6395136 || dword(0x2A1E80) == 5910848) &&
              once(dword(0x2D8880) != prev(dword(0x2D8880)) && dword(0x2D8880) == 64612) &&
              once(dword(0x2D8880) != prev(dword(0x2D8880)) && dword(0x2D8880) == 64772) && bit7(0x1FFB40) == 0 &&
              never(prev(bit7(0x1FFB40)) == 0) && never(dword(0x2A1E80) == 0) && never(dword(0x2A1E80) == 5905152)
)

achievement(
    title = "Batayan's Serenade", points = 3,
    description = "Listen to Batayan's performance of \"A Single Guy's Serenade\".",
    id = 256024, badge = "283951", published = "10/14/2022 6:58:04 AM", modified = "10/14/2022 11:58:28 PM",
    trigger = (dword(0x2A1E80) == 6396160 || dword(0x2A1E80) == 6395136 || dword(0x2A1E80) == 5910848) &&
              once(dword(0x2D8880) != prev(dword(0x2D8880)) && dword(0x2D8880) == 59078) &&
              once(dword(0x2D8880) != prev(dword(0x2D8880)) && dword(0x2D8880) == 59134) && bit7(0x1FFB40) == 0 &&
              never(prev(bit7(0x1FFB40)) == 0) && never(dword(0x2A1E80) == 0) && never(dword(0x2A1E80) == 5905152)
)

achievement(
    title = "Feel So Good", points = 4,
    description = "Discover the famous Happy Panda of Worldly Desire Temple.",
    id = 255332, badge = "283217", published = "10/12/2022 5:42:42 AM", modified = "10/12/2022 5:42:42 AM",
    trigger = bit7(0x1835A92) > prev(bit7(0x1835A92)) && dword(0x2A1E80) == 6385408
)

achievement(
    title = "Worker's Workout", points = 5,
    description = "Perform the Funny Bone Exercise correctly.",
    id = 255773, badge = "283712", published = "10/13/2022 9:46:25 PM", modified = "10/14/2022 1:29:39 AM",
    trigger = bit7(0x1FFB40) == 0 && never(prev(bit7(0x1FFB40)) == 0) && never(dword(0x2A1E80) != 6117952) &&
              ((once(dword(0x2D8880) != prev(dword(0x2D8880)) && dword(0x2D8880) == 2214) &&
                once(dword(0x2D8880) != prev(dword(0x2D8880)) && dword(0x2D8880) == 2728)) ||
               (once(dword(0x2D8880) != prev(dword(0x2D8880)) && dword(0x2D8880) == 2274) &&
                once(dword(0x2D8880) != prev(dword(0x2D8880)) && dword(0x2D8880) == 2704)))
)

achievement(
    title = "Out of the Bush and Into the Bathroom", points = 10,
    description = "Retrieve the naked mystery man's stashed cash at Funny Bone City.",
    id = 255331, badge = "283216", published = "10/12/2022 5:42:42 AM", modified = "10/12/2022 5:42:42 AM",
    trigger = dword(0x2A1E80) == 6113664 && bit0(0x1835A6F) == 1 && bit2(0x1835A6F) > prev(bit2(0x1835A6F))
)

achievement(
    title = "Royal Poopie", points = 10,
    description = "Obtain Gold Poopie - and survive.",
    id = 255809, badge = "283751", published = "10/13/2022 11:16:37 PM", modified = "10/15/2022 11:50:38 PM",
    trigger = once(bit3(0x1835A5C) > prev(bit3(0x1835A5C))) && bit7(0x1FFB40) == 0 && never(dword(0x2A1E80) != 6117952) &&
              never(prev(bit7(0x1FFB40)) == 0)
)

achievement(
    title = "Invisible Men Tell Tales", points = 10,
    description = "Obtain the Invisible Man's treasure in Scarecrow Field.",
    id = 255346, badge = "283230", published = "10/12/2022 6:51:26 AM", modified = "10/13/2022 6:40:39 AM",
    trigger = dword(0x2A1E80) == 6316416 && bit3(0x1835A93) > prev(bit3(0x1835A93))
)

achievement(
    title = "Reaper's Curse", points = 25,
    description = "Prove you don't fear death, and receive a reward from the Reaper in Worldly Desire Temple.",
    id = 255574, badge = "283522", published = "10/13/2022 5:30:51 AM", modified = "10/13/2022 5:30:51 AM",
    trigger = dword(0x2A1E80) == 6385408 && bit7(0x1FFB40) == 0 && never(prev(bit7(0x1FFB40)) == 0) &&
              once(prev(word(0x1835C6E)) == 96 && word(0x1835C6E) == 100) && never(dword(0x2A1E80) == 0) &&
              never(dword(0x2A1E80) == 5905152)
)*/

