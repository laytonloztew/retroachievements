// Snowpack Park
// #ID = 38358

function has_increased(addr) => addr > prev(addr)
function has_decreased(addr) => addr < prev(addr)
function has_changed(addr) => addr != prev(addr)
function hasnt_changed(addr) => addr == prev(addr)
function if_else(p, t, f) { if (p) { return t } else return f }
function is_even(v) => v % 2 == 0

// Pointer mask for custom memory map
RA_MASK = 0x1FFFFFFF

acc_addr = (v) => v // Dummy accessor for ptr for if the pointed-to address is desired
function ptr(base, offsets, accessor = dword_be)
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
            val = dword_be(addr)
            val = val & RA_MASK
        }
    }
    
    return val
}

function currentMap() => dword_be(0x003c4cc0)
function prevMap() => dword_be(0x003c4cc4)
MAP_PARK = 1
MAP_BRUSHWOOD_BEACH = 4
MAP_TENT = 5
MAP_FLIP_A_PENGUIN = 6
MAP_FOLLOW_THAT_TUNE = 7
MAP_CROISSANT_ROCK = 8
MAP_CRAGGY_CAVE = 9
MAP_FROSTY_FLOEBERG = 0xa
MAP_ICE_CHIP_ISLAND = 0xb
MAP_SLIPTOP_DRIFT_ICE = 0xc
MAP_FLIPPER_TIPPER = 0xd

SPOT_ANALYZER = 6
GAME_PENGUIN_PUSH = 7
GAME_BLOWFISH_BOWLING = 8
SPOT_TENT = 9
GAME_FREE_THROW_FOLLIES = 0x0a
GAME_CHUCK_A_CHOWFISH = 0x0b
GAME_ITS_MY_TUNA = 0x0c
SPOT_SLIDE = 0x0d

function playtime() => float_be(0x004e6ed0)
function timeAdd() => float_be(0x004e6ecc)
function timeOfDay() => float_be(0x004e6ec4) + timeAdd()
function hour() => (timeOfDay() / HOUR) % 12
function min() => (timeOfDay() % HOUR) / MINUTE
function ampm() => timeOfDay() / (HOUR * 12)

HOUR = 216000
MINUTE = 3600

player_data_ptr = 0x003df758

function PlayerData() {
        addr = dword_be(player_data_ptr) & RA_MASK

        obj = {
            "coat": dword_be(addr + 0x2c04),
            "fp": dword_be(addr + 0x2cdc),
            "inventory_slot_start": dword_be(addr + 0x2ce4),
            "items_found_start": addr + 0x2f64,
            "zone": dword_be(addr + 0x2b2c),
            "chuckachowfish_state": word_be(addr + 0xac7c),
            "chuckachowfish_score_float": float_be(addr + 0xaca8),
            "chuckachowfish_highscore_float": float_be(addr + 0xacac),
            "chuckachowfish_score": dword_be(addr + 0xad3c),
            "blowfishbowling_state": word_be(addr + 0xaa44),
            "blowfishbowling_finalscore": dword_be(addr + 0xaab0),
            "blowfishbowling_score_start_addr": addr + 0xaa8c,
            "penguinpush_state": word_be(addr + 0xab80),
            "penguinpush_round": dword_be(addr + 0xabc4),
            "penguinpush_round5score": dword_be(addr + 0xabd8),
            "penguinpush_finalscore": dword_be(addr + 0xabdc),
            "freethrow_state": word_be(addr + 0xa900),
            "freethrow_score_float": float_be(addr + 0xa92c),
            "freethrow_highscore_float": float_be(addr + 0xa930),
            "freethrow_shots_made": dword_be(addr + 0xa944),
            "freethrow_score": dword_be(addr + 0xa948),
            "freethrow_timer": float_be(addr + 0xa94c),
            "thatsmytuna_state": word_be(addr + 0xaf38),
            "thatsmytuna_score": float_be(addr + 0xaf64),
            "held_penguin_ptr": dword_be(addr + 0x2664)
        }

        return obj
    }

function heldPenguinData() => ptr(PlayerData()["held_penguin_ptr"],[0x2bfc],acc_addr)
function heldPenguinHat() => ptr(heldPenguinData(),[0x00,0x4c],dword_be)

function achHeldPenguinMusic() => inGame() && inPark() &&
    dword_be(heldPenguinData()) != 0 &&
    heldPenguinHat() >= 0x14 &&
    heldPenguinHat() <= 0x19 &&
    (
        photoEventIsActive(DIRECTION_SOUTH) && __ornext(
            has_changed(photoEventState(DIRECTION_SOUTH)) ||
            has_changed(dword_be(heldPenguinData()))
        ) ||
        photoEventIsActive(DIRECTION_EAST) && __ornext(
            has_changed(photoEventState(DIRECTION_EAST)) ||
            has_changed(dword_be(heldPenguinData()))
        ) ||
        photoEventIsActive(DIRECTION_WEST) && __ornext(
            has_changed(photoEventState(DIRECTION_WEST)) ||
            has_changed(dword_be(heldPenguinData()))
        )
    )

minigame_data_ptr = 0x005507f0
function MinigameData() {
    addr = dword_be(minigame_data_ptr) & RA_MASK

    obj = {
        "tune_state": dword_be(addr + 0x7cf8),
        "stage": dword_be(addr + 0x7d88),
        "lives": dword_be(addr + 0x7d8c),
        "tune_difficulty": dword_be(addr + 0x7d90),
        "flipper_levels_complete_start": addr + 0x494a,
        "flipper_state": dword_be(addr + 0x7d10),
        "flipper_level": dword_be(addr + 0xc134),
        "flipper_difficulty": dword_be(addr + 0xc138),
        "flipper_bonus": dword_be(addr + 0x7d4c),
        "pengflip_matchover_state": dword_be(addr + 0x7da4),
        "pengflip_difficulty": dword_be(addr + 0xad38),
        "pengflip_opp_identity": byte(addr + 0x7dfc),
        "pengflip_state": dword_be(addr + 0x7dcc)
    }

    return obj
}

// Level Complete Flags
FLIPPER_EASY_1 = 8
FLIPPER_EASY_2 = 9
FLIPPER_EASY_3 = 10
FLIPPER_EASY_4 = 11
FLIPPER_EASY_5 = 12
FLIPPER_NORMAL_1 = 13
FLIPPER_NORMAL_2 = 14
FLIPPER_NORMAL_3 = 15
FLIPPER_NORMAL_4 = 0
FLIPPER_NORMAL_5 = 1
FLIPPER_HARD_1 = 2
FLIPPER_HARD_2 = 3
FLIPPER_HARD_3 = 4
FLIPPER_HARD_4 = 5
FLIPPER_HARD_5 = 6

FLIPPER_LEVELS_EASY = [
    FLIPPER_EASY_1,
    FLIPPER_EASY_2,
    FLIPPER_EASY_3,
    FLIPPER_EASY_4,
    FLIPPER_EASY_5
]

FLIPPER_LEVELS_NORMAL = [
    FLIPPER_NORMAL_1,
    FLIPPER_NORMAL_2,
    FLIPPER_NORMAL_3,
    FLIPPER_NORMAL_4,
    FLIPPER_NORMAL_5
]

FLIPPER_LEVELS_HARD = [
    FLIPPER_HARD_1,
    FLIPPER_HARD_2,
    FLIPPER_HARD_3,
    FLIPPER_HARD_4,
    FLIPPER_HARD_5
]

function inFlipper() => inGame() && currentMap() == MAP_FLIPPER_TIPPER
function inTune() => inGame() && currentMap() == MAP_FOLLOW_THAT_TUNE

function flipperLevelCompleteFlag(f) => bit(f%8, MinigameData()["flipper_levels_complete_start"] + f/8)

function flipperLevelsSum(difficulty_arr) => sum_of(difficulty_arr, i =>
        flipperLevelCompleteFlag(i)
    )

function achFlipperLevelsComplete(difficulty_arr) => inFlipper() &&
    flipperLevelsSum(difficulty_arr) == length(difficulty_arr) &&
    prev(flipperLevelsSum(difficulty_arr)) == length(difficulty_arr) - 1 &&
    hasnt_changed(dword_be(minigame_data_ptr)) &&
    dword_be(minigame_data_ptr) != 0

function flipperComplete() => inFlipper() &&
                MinigameData()["flipper_state"] == 5 && 
                prev(MinigameData()["flipper_state"]) == 3 &&
                hasnt_changed(dword_be(minigame_data_ptr)) &&
                dword_be(minigame_data_ptr) != 0

function flipperCompleteLevel(diff, level) => flipperComplete() && 
    MinigameData()["flipper_difficulty"] == diff &&
    MinigameData()["flipper_level"] == level

function achFlipperCompleteBonus(level, b) => flipperComplete() && 
    MinigameData()["flipper_level"] == level &&
    MinigameData()["flipper_bonus"] >= b

function inPengFlip() => inGame() && currentMap() == MAP_FLIP_A_PENGUIN
function pengflipComplete() => inPengFlip() && pengFlipInMatch() && 
        pengFlipOppIsCPU() &&
        MinigameData()["pengflip_matchover_state"] == 1 && 
        has_changed(MinigameData()["pengflip_matchover_state"])

function pengflipDifficulty() => MinigameData()["pengflip_difficulty"]
FLIPAPENGUIN_DIFFICULTY_EASY = 0
FLIPAPENGUIN_DIFFICULTY_NORMAL = 1
function pengFlipCompleteDifficulty(diff) => pengflipComplete() && 
        pengflipDifficulty() == diff

function pengFlipOppIdentity() => MinigameData()["pengflip_opp_identity"]
function pengFlipOppIsCPU() => pengFlipOppIdentity() == 0xff

function pengFlipState() => MinigameData()["pengflip_state"]
function pengFlipInMatch() => pengFlipState() == 0x08

function pengFlipPlayerScore() => dword_be(0x004eb64c)
function pengFlipOppScore() => dword_be(0x004ebc70)

function pengFlipWon(diff) => pengFlipCompleteDifficulty(diff) && pengFlipPlayerScore() > pengFlipOppScore()

function achPengFlipCompleteDifficulty(diff) => pengFlipWon(diff)

function currentZone() => PlayerData()["zone"]

function itemsFoundFlag(f) => bit(f%8, PlayerData()["items_found_start"] + f/8)

function sumItemsFound(arr) => sum_of(arr, i =>
    itemsFoundFlag(i)
)

penguin_data_start_addr = 0x00551244
PENGUIN_DATA_LENGTH = 0x78
function penguinData(i,offset) => penguin_data_start_addr + (i * PENGUIN_DATA_LENGTH) + offset
function penguinFlags(i) => penguinData(i,0x2c)
function penguinNameIsKnown(i) => bit(0, penguinData(i,0x2c)) == 1
function penguinPresentStatus(i) => bit(6, penguinData(i,0x2c))
function penguinIsPresent(i) => penguinPresentStatus(i) == 1
function penguinGender(i) => bit(7, penguinData(i,0x2c))

function penguinRevealedCount(i) => bit(0, penguinFlags(i)) + bit(1, penguinFlags(i)) + bit(2, penguinFlags(i)) + bit(3, penguinFlags(i))
function penguinNowFullyRevealed(i) => prev(penguinRevealedCount(i)) == 3 && penguinRevealedCount(i) == 4

function sumPenguins() => sum_of(range(0,99), i =>
    penguinPresentStatus(i)
)

function numPenguinsVisual() => word_be(0x0062cfc0)
function achHundredPenguins() => inGame() && inPark() && numPenguinsVisual() == 100 && prev(numPenguinsVisual()) == 99

function numPenguinsInRange(i) => word_be(0x0062cfd6 + (i * 2))

function minigameIsActive(state) => __ornext(state == 4 || state == 5)

TUNE_DIFFICULTY_EASY = 0
TUNE_DIFFICULTY_NORMAL = 1
TUNE_DIFFICULTY_HARD = 2
function achFollowThatTuneComplete(difficulty) => inGame() && currentMap() == MAP_FOLLOW_THAT_TUNE &&
            MinigameData()["tune_state"] == 0x0a &&
            prev(MinigameData()["tune_state"]) == 0x08 &&
            MinigameData()["tune_difficulty"] == difficulty

function completedChuckaChowfish() => inGame() && inPark() && currentZone() == ZONE_CHUCKACHOWFISH && 
    PlayerData()["chuckachowfish_state"] == 5 && 
    prev(PlayerData()["chuckachowfish_state"]) == 4 && 
    PlayerData()["chuckachowfish_score"] > 0

function completeFreeThrow() => inGame() && inPark() && currentZone() == ZONE_FREE_THROW_FOLLIES && 
    PlayerData()["freethrow_state"] == 5 && 
    prev(PlayerData()["freethrow_state"]) == 4 && 
    PlayerData()["freethrow_score"] > 0

function completedBlowfishBowling() => inGame() && inPark() && currentZone() == ZONE_BLOWFISH_BOWLING && 
    minigameIsActive(PlayerData()["blowfishbowling_state"]) && 
    prev(PlayerData()["blowfishbowling_finalscore"]) == 0xffffffff &&
    has_changed(PlayerData()["blowfishbowling_finalscore"]) && 
    PlayerData()["blowfishbowling_finalscore"] != 0

function completedPenguinPush() => inGame() && inPark() && currentZone() == ZONE_PENGUIN_PUSH && 
    minigameIsActive(PlayerData()["penguinpush_state"]) && 
    prev(PlayerData()["penguinpush_round5score"]) == 0xffffffff &&
    has_changed(PlayerData()["penguinpush_round5score"]) && 
    PlayerData()["penguinpush_finalscore"] != 0

function completeMyTuna() => inGame() && inPark() && currentZone() == ZONE_ITS_MY_TUNA &&
    PlayerData()["thatsmytuna_state"] == 5 && 
    prev(PlayerData()["thatsmytuna_state"]) == 4 && 
    PlayerData()["thatsmytuna_score"] > 0

function achItsMyTunaScoreReached(score) => inGame() && inPark() && currentZone() == ZONE_ITS_MY_TUNA &&
    minigameIsActive(PlayerData()["thatsmytuna_state"]) &&
    PlayerData()["thatsmytuna_score"] >= score &&
    has_increased(PlayerData()["thatsmytuna_score"])

function achFreeThrowScore(score) => inGame() && inPark() && currentZone() == ZONE_FREE_THROW_FOLLIES &&
    minigameIsActive(PlayerData()["freethrow_state"]) &&
    PlayerData()["freethrow_score"] >= score &&
    has_increased(PlayerData()["freethrow_score"])

function achPengPushScore(score) => inGame() && inPark() && currentZone() == ZONE_PENGUIN_PUSH &&
    minigameIsActive(PlayerData()["penguinpush_state"]) &&
    PlayerData()["penguinpush_finalscore"] >= score &&
    has_increased(PlayerData()["penguinpush_finalscore"])

function blowfishBowlingScore(i) => dword_be(PlayerData()["blowfishbowling_score_start_addr"] + (i * 4))

function achBlowfishBowlingStrike() => inGame() && inPark() && currentZone() == ZONE_BLOWFISH_BOWLING &&
    minigameIsActive(PlayerData()["blowfishbowling_state"]) &&
    any_of(range(0,6), r =>
        prev(blowfishBowlingScore(r)) == 0xffffffff && blowfishBowlingScore(r) == 10
    )

function achChuckaChowfishScore(score) => inGame() && inPark() && currentZone() == ZONE_CHUCKACHOWFISH &&
    minigameIsActive(PlayerData()["chuckachowfish_state"]) &&
    PlayerData()["chuckachowfish_score"] >= score &&
    has_increased(PlayerData()["chuckachowfish_score"])

FISH_STICKS = 0x1
FISHING_POLE = 0x2
DRILL = 0x3
GOLD_KEY = 0x4
UFO = 0x5
GRAY_ELEPHANT_MASK = 0x6
GRAY_DOG_MASK = 0x7
GRAY_CAT_MASK = 0x8
COW_MASK = 0x9
TANGERINE = 0xA
GREEN_PEPPER = 0xB
SAMURAI_HELMET = 0xC
FEATHER_HEADDRESS = 0xD
PURPLE_BASEBALL_HAT = 0xE
BLOWFISH = 0xF
SILVER_KEY = 0x10
CHOWFISH = 0x11
GOLDEN_PENGUIN = 0x12
TUNA = 0x13
TRUMPET = 0x14
FLUTE = 0x15
VIOLIN = 0x16
CONGA = 0x17
KETTLEDRUM = 0x18
SAXOPHONE = 0x19
ALIEN_MASK = 0x1A
WRESTLING_MASK = 0x1B
BEIGE_TWEED_CAP = 0x1C
ORANGE_PUFFBALL_CAP = 0x1D
YELLOW_ELEPHANT_MASK = 0x1E
BLACK_TOP_HAT = 0x1F
RED_HAT = 0x20
GREEN_HAT = 0x21
GREEN_COW_MASK = 0x22
YELLOW_HELMET = 0x23
GOLD_HEADBAND = 0x24
HEAD_MIRROR = 0x25
BLUE_PANDA_MASK = 0x26
ORANGE_VISOR = 0x27
BLACK_CAT_MASK = 0x28
PINK_RIBBON = 0x29
BLUE_RIBBON = 0x2A
YELLOW_RIBBON = 0x2B
POLICE_HAT = 0x2C
CARDBOARD_BOX = 0x2D
BLUE_FLOWER = 0x2E
PINK_FLOWER = 0x2F
YELLOW_FLOWER = 0x30
PINK_BATTING_HELMET = 0x31
BLACK_DOG_MASK = 0x32
SOCCER_BALL = 0x33
BASKETBALL = 0x34
BASEBALL = 0x35
FOOTBALL = 0x36
BOWLING_PIN = 0x37
PINK_DEER_MASK = 0x38
NURSE_CAP = 0x39
HERO_HELMET = 0x3A
RED_TULIP = 0x3B
PURPLE_TULIP = 0x3C
YELLOW_TULIP = 0x3D
GOLF_BALL = 0x3E
TENNIS_BALL = 0x3F
VOLLEYBALL = 0x40
CAKE = 0x41
COFFEE = 0x42
ORANGE_MILKSHAKE = 0x43
GREEN_MILKSHAKE = 0x44
WHITE_TOP_HAT = 0x45
BLUE_BASEBALL_HAT = 0x46
RED_BASEBALL_HAT = 0x47
RED_PUFFBALL_CAP = 0x48
BLUE_PUFFBALL_CAP = 0x49
BLUE_VISOR = 0x4A
YELLOW_VISOR = 0x4B
RED_BATTING_HELMET = 0x4C
BLUE_BATTING_HELMET = 0x4D
BLUE_ELEPHANT_MASK = 0x4E
BROWN_DOG_MASK = 0x4F
BROWN_CAT_MASK = 0x50
PINK_COW_MASK = 0x51
EARTH = 0x52
BLUE_TWEED_CAP = 0x53
RED_TWEED_CAP = 0x54
METAL_WASHTUB = 0x55
SPACE_POLICE_HELMET = 0x56
BLUE_PARTY_HAT = 0x57
RED_PARTY_HAT = 0x58
YELLOW_PARTY_HAT = 0x59
PANDA_MASK = 0x5A
PINK_PANDA_MASK = 0x5B
FROG_MASK = 0x5C
BLUE_FROG_MASK = 0x5D
RED_FROG_MASK = 0x5E
DEER_MASK = 0x5F
WHITE_DEER_MASK = 0x60
RED_CAP = 0x61
WHITE_CAP = 0x62
BLUE_CAR = 0x63
RED_CAR = 0x64
YELLOW_CAR = 0x65
TRUCK = 0x66
BULLDOZER = 0x67
FORKLIFT = 0x68
CUSTARD = 0x69
JAPANESE_RICE_BALL = 0x6A
MARS = 0x6B
SATURN = 0x6C
SAMURAI_WIG = 0x6D
PENGUIN_EGG = 0x6E
RED_COAT = 0x6F
ORANGE_COAT = 0x70
YELLOW_COAT = 0x71
LIGHT_GREEN_COAT = 0x72
GREEN_COAT = 0x73
BLUE_COAT = 0x74
LIGHT_BLUE_COAT = 0x75
PINK_COAT = 0x76
PURPLE_COAT = 0x77
BROWN_COAT = 0x78
WHITE_COAT = 0x79
BLACK_COAT = 0x7A
BLUE_KEY = 0x7B

ITEM_FLAG_KETTLEDRUM = 0
ITEM_FLAG_SAXOPHONE = 1
ITEM_FLAG_ALIEN_MASK = 2
ITEM_FLAG_WRESTLING_MASK = 3
ITEM_FLAG_BEIGE_TWEED_CAP = 4
ITEM_FLAG_ORANGE_PUFFBALL_CAP = 5
ITEM_FLAG_YELLOW_ELEPHANT_MASK = 6
ITEM_FLAG_BLACK_TOP_HAT = 7
ITEM_FLAG_SILVER_KEY = 8
ITEM_FLAG_CHOWFISH = 9
ITEM_FLAG_GOLDEN_PENGUIN = 10
ITEM_FLAG_TUNA = 11
ITEM_FLAG_TRUMPET = 12
ITEM_FLAG_FLUTE = 13
ITEM_FLAG_VIOLIN = 14
ITEM_FLAG_CONGA = 15
ITEM_FLAG_GRAY_CAT_MASK = 16
ITEM_FLAG_COW_MASK = 17
ITEM_FLAG_TANGERINE = 18
ITEM_FLAG_GREEN_PEPPER = 19
ITEM_FLAG_SAMURAI_HELMET = 20
ITEM_FLAG_FEATHER_HEADDRESS = 21
ITEM_FLAG_PURPLE_BASEBALL_HAT = 22
ITEM_FLAG_BLOWFISH = 23
ITEM_FLAG_DUMMY = 24
ITEM_FLAG_FISH_STICKS = 25
ITEM_FLAG_FISHING_POLE = 26
ITEM_FLAG_DRILL = 27
ITEM_FLAG_GOLD_KEY = 28
ITEM_FLAG_UFO = 29
ITEM_FLAG_GRAY_ELEPHANT_MASK = 30
ITEM_FLAG_GRAY_DOG_MASK = 31
ITEM_FLAG_PINK_DEER_MASK = 32
ITEM_FLAG_NURSE_CAP = 33
ITEM_FLAG_HERO_HELMET = 34
ITEM_FLAG_RED_TULIP = 35
ITEM_FLAG_PURPLE_TULIP = 36
ITEM_FLAG_YELLOW_TULIP = 37
ITEM_FLAG_GOLF_BALL = 38
ITEM_FLAG_TENNIS_BALL = 39
ITEM_FLAG_YELLOW_FLOWER = 40
ITEM_FLAG_PINK_BATTING_HELMET = 41
ITEM_FLAG_BLACK_DOG_MASK = 42
ITEM_FLAG_SOCCER_BALL = 43
ITEM_FLAG_BASKETBALL = 44
ITEM_FLAG_BASEBALL = 45
ITEM_FLAG_FOOTBALL = 46
ITEM_FLAG_BOWLING_PIN = 47
ITEM_FLAG_BLACK_CAT_MASK = 48
ITEM_FLAG_PINK_RIBBON = 49
ITEM_FLAG_BLUE_RIBBON = 50
ITEM_FLAG_YELLOW_RIBBON = 51
ITEM_FLAG_POLICE_HAT = 52
ITEM_FLAG_CARDBOARD_BOX = 53
ITEM_FLAG_BLUE_FLOWER = 54
ITEM_FLAG_PINK_FLOWER = 55
ITEM_FLAG_RED_HAT = 56
ITEM_FLAG_GREEN_HAT = 57
ITEM_FLAG_GREEN_COW_MASK = 58
ITEM_FLAG_YELLOW_HELMET = 59
ITEM_FLAG_GOLD_HEADBAND = 60
ITEM_FLAG_HEAD_MIRROR = 61
ITEM_FLAG_BLUE_PANDA_MASK = 62
ITEM_FLAG_ORANGE_VISOR = 63
ITEM_FLAG_RED_PARTY_HAT = 64
ITEM_FLAG_YELLOW_PARTY_HAT = 65
ITEM_FLAG_PANDA_MASK = 66
ITEM_FLAG_PINK_PANDA_MASK = 67
ITEM_FLAG_FROG_MASK = 68
ITEM_FLAG_BLUE_FROG_MASK = 69
ITEM_FLAG_RED_FROG_MASK = 70
ITEM_FLAG_DEER_MASK = 71
ITEM_FLAG_BROWN_CAT_MASK = 72
ITEM_FLAG_PINK_COW_MASK = 73
ITEM_FLAG_EARTH = 74
ITEM_FLAG_BLUE_TWEED_CAP = 75
ITEM_FLAG_RED_TWEED_CAP = 76
ITEM_FLAG_METAL_WASHTUB = 77
ITEM_FLAG_SPACE_POLICE_HELMET = 78
ITEM_FLAG_BLUE_PARTY_HAT = 79
ITEM_FLAG_RED_PUFFBALL_CAP = 80
ITEM_FLAG_BLUE_PUFFBALL_CAP = 81
ITEM_FLAG_BLUE_VISOR = 82
ITEM_FLAG_YELLOW_VISOR = 83
ITEM_FLAG_RED_BATTING_HELMET = 84
ITEM_FLAG_BLUE_BATTING_HELMET = 85
ITEM_FLAG_BLUE_ELEPHANT_MASK = 86
ITEM_FLAG_BROWN_DOG_MASK = 87
ITEM_FLAG_VOLLEYBALL = 88
ITEM_FLAG_CAKE = 89
ITEM_FLAG_COFFEE = 90
ITEM_FLAG_ORANGE_MILKSHAKE = 91
ITEM_FLAG_GREEN_MILKSHAKE = 92
ITEM_FLAG_WHITE_TOP_HAT = 93
ITEM_FLAG_BLUE_BASEBALL_HAT = 94
ITEM_FLAG_RED_BASEBALL_HAT = 95
ITEM_FLAG_BROWN_COAT = 96
ITEM_FLAG_WHITE_COAT = 97
ITEM_FLAG_BLACK_COAT = 98
ITEM_FLAG_BLUE_KEY = 99
ITEM_FLAG_UNUSED_1 = 100
ITEM_FLAG_UNUSED_2 = 101
ITEM_FLAG_UNUSED_3 = 102
ITEM_FLAG_UNUSED_4 = 103
ITEM_FLAG_ORANGE_COAT = 104
ITEM_FLAG_YELLOW_COAT = 105
ITEM_FLAG_LIGHT_GREEN_COAT = 106
ITEM_FLAG_GREEN_COAT = 107
ITEM_FLAG_BLUE_COAT = 108
ITEM_FLAG_LIGHT_BLUE_COAT = 109
ITEM_FLAG_PINK_COAT = 110
ITEM_FLAG_PURPLE_COAT = 111
ITEM_FLAG_FORKLIFT = 112
ITEM_FLAG_CUSTARD = 113
ITEM_FLAG_JAPANESE_RICE_BALL = 114
ITEM_FLAG_MARS = 115
ITEM_FLAG_SATURN = 116
ITEM_FLAG_SAMURAI_WIG = 117
ITEM_FLAG_PENGUIN_EGG = 118
ITEM_FLAG_RED_COAT = 119
ITEM_FLAG_WHITE_DEER_MASK = 120
ITEM_FLAG_RED_CAP = 121
ITEM_FLAG_WHITE_CAP = 122
ITEM_FLAG_BLUE_CAR = 123
ITEM_FLAG_RED_CAR = 124
ITEM_FLAG_YELLOW_CAR = 125
ITEM_FLAG_TRUCK = 126
ITEM_FLAG_BULLDOZER = 127

HATS = [
    ITEM_FLAG_UFO,
    ITEM_FLAG_GRAY_ELEPHANT_MASK,
    ITEM_FLAG_GRAY_DOG_MASK,
    ITEM_FLAG_GRAY_CAT_MASK,
    ITEM_FLAG_COW_MASK,
    ITEM_FLAG_TANGERINE,
    ITEM_FLAG_GREEN_PEPPER,
    ITEM_FLAG_SAMURAI_HELMET,
    ITEM_FLAG_FEATHER_HEADDRESS,
    ITEM_FLAG_PURPLE_BASEBALL_HAT,
    ITEM_FLAG_TRUMPET,
    ITEM_FLAG_FLUTE,
    ITEM_FLAG_VIOLIN,
    ITEM_FLAG_CONGA,
    ITEM_FLAG_KETTLEDRUM,
    ITEM_FLAG_SAXOPHONE,
    ITEM_FLAG_ALIEN_MASK,
    ITEM_FLAG_WRESTLING_MASK,
    ITEM_FLAG_BEIGE_TWEED_CAP,
    ITEM_FLAG_ORANGE_PUFFBALL_CAP,
    ITEM_FLAG_YELLOW_ELEPHANT_MASK,
    ITEM_FLAG_BLACK_TOP_HAT,
    ITEM_FLAG_RED_HAT,
    ITEM_FLAG_GREEN_HAT,
    ITEM_FLAG_GREEN_COW_MASK,
    ITEM_FLAG_YELLOW_HELMET,
    ITEM_FLAG_GOLD_HEADBAND,
    ITEM_FLAG_HEAD_MIRROR,
    ITEM_FLAG_BLUE_PANDA_MASK,
    ITEM_FLAG_ORANGE_VISOR,
    ITEM_FLAG_BLACK_CAT_MASK,
    ITEM_FLAG_PINK_RIBBON,
    ITEM_FLAG_BLUE_RIBBON,
    ITEM_FLAG_YELLOW_RIBBON,
    ITEM_FLAG_POLICE_HAT,
    ITEM_FLAG_CARDBOARD_BOX,
    ITEM_FLAG_BLUE_FLOWER,
    ITEM_FLAG_PINK_FLOWER,
    ITEM_FLAG_YELLOW_FLOWER,
    ITEM_FLAG_PINK_BATTING_HELMET,
    ITEM_FLAG_BLACK_DOG_MASK,
    ITEM_FLAG_SOCCER_BALL,
    ITEM_FLAG_BASKETBALL,
    ITEM_FLAG_BASEBALL,
    ITEM_FLAG_FOOTBALL,
    ITEM_FLAG_BOWLING_PIN,
    ITEM_FLAG_PINK_DEER_MASK,
    ITEM_FLAG_NURSE_CAP,
    ITEM_FLAG_HERO_HELMET,
    ITEM_FLAG_RED_TULIP,
    ITEM_FLAG_PURPLE_TULIP,
    ITEM_FLAG_YELLOW_TULIP,
    ITEM_FLAG_GOLF_BALL,
    ITEM_FLAG_TENNIS_BALL,
    ITEM_FLAG_VOLLEYBALL,
    ITEM_FLAG_CAKE,
    ITEM_FLAG_COFFEE,
    ITEM_FLAG_ORANGE_MILKSHAKE,
    ITEM_FLAG_GREEN_MILKSHAKE,
    ITEM_FLAG_WHITE_TOP_HAT,
    ITEM_FLAG_BLUE_BASEBALL_HAT,
    ITEM_FLAG_RED_BASEBALL_HAT,
    ITEM_FLAG_RED_PUFFBALL_CAP,
    ITEM_FLAG_BLUE_PUFFBALL_CAP,
    ITEM_FLAG_BLUE_VISOR,
    ITEM_FLAG_YELLOW_VISOR,
    ITEM_FLAG_RED_BATTING_HELMET,
    ITEM_FLAG_BLUE_BATTING_HELMET,
    ITEM_FLAG_BLUE_ELEPHANT_MASK,
    ITEM_FLAG_BROWN_DOG_MASK,
    ITEM_FLAG_BROWN_CAT_MASK,
    ITEM_FLAG_PINK_COW_MASK,
    ITEM_FLAG_EARTH,
    ITEM_FLAG_BLUE_TWEED_CAP,
    ITEM_FLAG_RED_TWEED_CAP,
    ITEM_FLAG_METAL_WASHTUB,
    ITEM_FLAG_SPACE_POLICE_HELMET,
    ITEM_FLAG_BLUE_PARTY_HAT,
    ITEM_FLAG_RED_PARTY_HAT,
    ITEM_FLAG_YELLOW_PARTY_HAT,
    ITEM_FLAG_PANDA_MASK,
    ITEM_FLAG_PINK_PANDA_MASK,
    ITEM_FLAG_FROG_MASK,
    ITEM_FLAG_BLUE_FROG_MASK,
    ITEM_FLAG_RED_FROG_MASK,
    ITEM_FLAG_DEER_MASK,
    ITEM_FLAG_WHITE_DEER_MASK,
    ITEM_FLAG_RED_CAP,
    ITEM_FLAG_WHITE_CAP,
    ITEM_FLAG_BLUE_CAR,
    ITEM_FLAG_RED_CAR,
    ITEM_FLAG_YELLOW_CAR,
    ITEM_FLAG_TRUCK,
    ITEM_FLAG_BULLDOZER,
    ITEM_FLAG_FORKLIFT,
    ITEM_FLAG_CUSTARD,
    ITEM_FLAG_JAPANESE_RICE_BALL,
    ITEM_FLAG_MARS,
    ITEM_FLAG_SATURN,
    ITEM_FLAG_SAMURAI_WIG
]

PENGUIN_PUSH_HATS = [
    ITEM_FLAG_SOCCER_BALL,
    ITEM_FLAG_BASKETBALL,
    ITEM_FLAG_BASEBALL,
    ITEM_FLAG_FOOTBALL,
    ITEM_FLAG_BOWLING_PIN
]

COATS = [
    ITEM_FLAG_RED_COAT,
    ITEM_FLAG_ORANGE_COAT,
    ITEM_FLAG_YELLOW_COAT,
    ITEM_FLAG_LIGHT_GREEN_COAT,
    ITEM_FLAG_GREEN_COAT,
    ITEM_FLAG_BLUE_COAT,
    ITEM_FLAG_LIGHT_BLUE_COAT,
    ITEM_FLAG_PINK_COAT,
    ITEM_FLAG_PURPLE_COAT,
    ITEM_FLAG_BROWN_COAT,
    ITEM_FLAG_WHITE_COAT,
    ITEM_FLAG_BLACK_COAT
]

KEYS = [
    ITEM_FLAG_BLUE_KEY,
    ITEM_FLAG_GOLD_KEY,
    ITEM_FLAG_SILVER_KEY
]

shortcut_ptr = 0x005aec80
function shortcutFlag(f) => bit(f%8, ptr(shortcut_ptr,[0x00,0x0d],acc_addr) + f/8)
SHORTCUT_HOLE_1 = 0
SHORTCUT_HOLE_2 = 1
SHORTCUT_HOLE_3 = 2
SHORTCUT_MOUND = 8
SHORTCUT_CLIFF = 9
SHORTCUT_BIGICE = 10
SHORTCUT_BRIDGE = 21
SHORTCUT_POOL = 22

SHORTCUTS = [
    SHORTCUT_HOLE_1,
    SHORTCUT_HOLE_2,
    SHORTCUT_HOLE_3,
    SHORTCUT_MOUND,
    SHORTCUT_CLIFF,
    SHORTCUT_BIGICE,
    SHORTCUT_BRIDGE,
    SHORTCUT_POOL
]

function sumShortcuts() => sum_of(SHORTCUTS, i =>
    shortcutFlag(i)
)

flags_ptr = 0x003dde78

function sealState() => ptr(flags_ptr,[0x00,0x30e2],byte)
function achSeal() => inGame() && inPark() && sealState() == 1 && prev(sealState()) == 0
function achPool() => inGame() && inPark() && has_increased(shortcutFlag(SHORTCUT_POOL))
function achBridge() => inGame() && inPark() && has_increased(shortcutFlag(SHORTCUT_BRIDGE))


function onTitle() => prevMap() == 0xffffffff
function inGame() => dword_be(player_data_ptr) != 0 && !onTitle()
function inPark() => currentMap() == MAP_PARK

function ach(ach, t) {
    achievement(
        title = ach[0],
        points = ach[2],
        description = ach[1],
        trigger = ach[3],
        type=t
    )
}

function achPenguinFullyRevealed() => inGame() && inPark() && any_of(range(0,99), i =>
        penguinNowFullyRevealed(i)
    )

function achAllShortcuts() => inGame() && 
        sumShortcuts() == length(SHORTCUTS) && 
        prev(sumShortcuts()) == length(SHORTCUTS) - 1 && 
        hasnt_changed(dword_be(shortcut_ptr)) && 
        dword_be(shortcut_ptr) != 0 && 
        currentMap() == MAP_PARK

function achItemsFound(arr) => measured(sumItemsFound(arr) == length(arr), when=inGame()) &&
    prev(sumItemsFound(arr)) == length(arr) - 1

DIRECTION_SOUTH = 0
DIRECTION_EAST = 1
DIRECTION_WEST = 2
photo_event_ptr_start = 0x005509b4
function photoEventPtr(dir) => photo_event_ptr_start + (dir * 4)
function photoEventState(dir) => ptr(photoEventPtr(dir),[0x00,0xe8,0xd82],byte)
function photoEventIsActive(dir) => photoEventState(dir) == 1 && 
                                    dword_be(photoEventPtr(dir)) != 0 && 
                                    hasnt_changed(dword_be(photoEventPtr(dir))) && 
                                    ptr(photoEventPtr(dir),[0x00,0xe8],acc_addr) != 0 && 
                                    hasnt_changed(ptr(photoEventPtr(dir),[0x00,0xe8],acc_addr))

function photoVisibleWest() => has_increased(bit(0,0x00550c00))
function photoVisibleEast() => has_increased(bit(1,0x00550c00))
function photoVisibleSouth() => has_increased(bit(7,0x00550c01))

function achEastPhotoEvent() => inGame() && currentMap() == MAP_PARK && photoEventIsActive(DIRECTION_EAST) && photoVisibleEast()
function achWestPhotoEvent() => inGame() && currentMap() == MAP_PARK && photoEventIsActive(DIRECTION_WEST) && photoVisibleWest()



MapLookup = {
    MAP_PARK: "Snowpack Park",
    MAP_BRUSHWOOD_BEACH: "Brushwood Beach",
    MAP_TENT: "Tent",
    MAP_FLIP_A_PENGUIN: "Flip-A-Penguin",
    MAP_FOLLOW_THAT_TUNE: "Follow That Tune",
    MAP_CROISSANT_ROCK: "Croissant Rock",
    MAP_CRAGGY_CAVE: "Craggy Cave",
    MAP_FROSTY_FLOEBERG: "Frosty Floeberg",
    MAP_ICE_CHIP_ISLAND: "Ice Chip Island",
    MAP_SLIPTOP_DRIFT_ICE: "Sliptop Drift Ice",
    MAP_FLIPPER_TIPPER: "Flipper Tipper"
}

DifficultyLookup = {
    0: "Easy",
    1: "Normal",
    2: "Hard"
}

ZONE_PENGUIN_PUSH = 7
ZONE_BLOWFISH_BOWLING = 8
ZONE_FREE_THROW_FOLLIES = 0x0a
ZONE_CHUCKACHOWFISH = 0x0b
ZONE_ITS_MY_TUNA = 0x0c

ZoneLookup = {
    6: "Measuring",
    ZONE_PENGUIN_PUSH: "Penguin Push",
    ZONE_BLOWFISH_BOWLING: "Blowfish Bowling",
    ZONE_FREE_THROW_FOLLIES: "Free-Throw Follies",
    ZONE_CHUCKACHOWFISH: "Chuck-a-Chowfish",
    ZONE_ITS_MY_TUNA: "It's My Tuna!",
    0x0d: "Slide"
}

AMPMLookup = {
    0: "AM",
    1: "PM"
}

LeadZeroLookup = {
    0: "0",
    1: "0",
    2: "0",
    3: "0",
    4: "0",
    5: "0",
    6: "0",
    7: "0",
    8: "0",
    9: "0"
}

rp_lookup_map = rich_presence_lookup("Map", currentMap(), MapLookup, fallback="Snowpack Park")
rp_value_playtime = rich_presence_value("Playtime", playtime(), "FRAMES")
rp_value_fp = rich_presence_value("FP", PlayerData()["fp"])
rp_value_penguins = rich_presence_value("Penguins", sumPenguins())
rp_value_hr = rich_presence_value("hr", hour())
rp_value_min = rich_presence_value("min", min())
rp_lookup_minZero = rich_presence_lookup("LeadZero", min(), LeadZeroLookup)
rp_lookup_ampm = rich_presence_lookup("ampm", ampm(), AMPMLookup)



// Title Screen
rich_presence_conditional_display(onTitle(),"Title Screen")

rich_presence_conditional_display(inTune(),"🕹️{0} [⚖️{8}] 🐧{3} 🕒{4}:{6}{5}{7} ❤️{2}fp ⌛{1}",
    rp_lookup_map,
    rp_value_playtime,
    rp_value_fp,
    rp_value_penguins,
    rp_value_hr,
    rp_value_min,
    rp_lookup_minZero,
    rp_lookup_ampm,
    rich_presence_lookup("tuneDifficulty", MinigameData()["tune_difficulty"], DifficultyLookup)
)

rich_presence_conditional_display(inFlipper(),"🕹️{0} [⚖️{9} {8}] 🐧{3} 🕒{4}:{6}{5}{7} ❤️{2}fp ⌛{1}",
    rp_lookup_map,
    rp_value_playtime,
    rp_value_fp,
    rp_value_penguins,
    rp_value_hr,
    rp_value_min,
    rp_lookup_minZero,
    rp_lookup_ampm,
    rich_presence_value("flipperLevel", MinigameData()["flipper_level"] + 1),
    rich_presence_lookup("flipperDifficulty", MinigameData()["flipper_difficulty"], DifficultyLookup)
)

// Flip-A-Penguin
rich_presence_conditional_display(inPengFlip() && !pengFlipInMatch(),"🕹️{0} 🐧{3} 🕒{4}:{6}{5}{7} ❤️{2}fp ⌛{1}",
    rp_lookup_map,
    rp_value_playtime,
    rp_value_fp,
    rp_value_penguins,
    rp_value_hr,
    rp_value_min,
    rp_lookup_minZero,
    rp_lookup_ampm
)

//      Vs Human
rich_presence_conditional_display(inPengFlip() && pengFlipOppIdentity() != 0xff,"🕹️{0} [Vs Human ⚫{8} ⚪{9}] 🕒{4}:{6}{5}{7} ❤️{2}fp ⌛{1}",
    rp_lookup_map,
    rp_value_playtime,
    rp_value_fp,
    rp_value_penguins,
    rp_value_hr,
    rp_value_min,
    rp_lookup_minZero,
    rp_lookup_ampm,
    rich_presence_lookup("PengFlipDifficulty", pengflipDifficulty(), DifficultyLookup),
    rich_presence_value("PengFlipScore1", pengFlipPlayerScore()),
    rich_presence_value("PengFlipScore2", pengFlipOppScore())
)

//      Vs CPU
rich_presence_conditional_display(inPengFlip(),"🕹️{0} [⚖️{8} ⚫{9} ⚪{10}] 🐧{3} 🕒{4}:{6}{5}{7} ❤️{2}fp ⌛{1}",
    rp_lookup_map,
    rp_value_playtime,
    rp_value_fp,
    rp_value_penguins,
    rp_value_hr,
    rp_value_min,
    rp_lookup_minZero,
    rp_lookup_ampm,
    rich_presence_lookup("PengFlipDifficulty", pengflipDifficulty(), DifficultyLookup),
    rich_presence_value("PengFlipScore1", pengFlipPlayerScore()),
    rich_presence_value("PengFlipScore2", pengFlipOppScore())
)

// Snowpack Park - Minigames
rich_presence_conditional_display(inPark() && currentZone() == ZONE_ITS_MY_TUNA,"🕹️{0} 🐧{8} 🗺️Snowpack Park 🐧{3} 🕒{4}:{6}{5}{7} ❤️{2}fp ⌛{1}",
    rich_presence_lookup("Zone", currentZone(), ZoneLookup),
    rp_value_playtime,
    rp_value_fp,
    rp_value_penguins,
    rp_value_hr,
    rp_value_min,
    rp_lookup_minZero,
    rp_lookup_ampm,
    rich_presence_value("PenguinsRange", numPenguinsInRange(4))
)

// Chuck-a-Chowfish (caps at 30)
rich_presence_conditional_display(inPark() && currentZone() == ZONE_CHUCKACHOWFISH && numPenguinsInRange(3) > 30,"🕹️{0} 🐧30/30 🗺️Snowpack Park 🐧{3} 🕒{4}:{6}{5}{7} ❤️{2}fp ⌛{1}",
    rich_presence_lookup("Zone", currentZone(), ZoneLookup),
    rp_value_playtime,
    rp_value_fp,
    rp_value_penguins,
    rp_value_hr,
    rp_value_min,
    rp_lookup_minZero,
    rp_lookup_ampm,
    rich_presence_value("PenguinsRange", numPenguinsInRange(3))
)

rich_presence_conditional_display(inPark() && currentZone() == ZONE_CHUCKACHOWFISH,"🕹️{0} 🐧{8}/30 🗺️Snowpack Park 🐧{3} 🕒{4}:{6}{5}{7} ❤️{2}fp ⌛{1}",
    rich_presence_lookup("Zone", currentZone(), ZoneLookup),
    rp_value_playtime,
    rp_value_fp,
    rp_value_penguins,
    rp_value_hr,
    rp_value_min,
    rp_lookup_minZero,
    rp_lookup_ampm,
    rich_presence_value("PenguinsRange", numPenguinsInRange(3))
)

// Penguin Push (need 5, can have more but not necessary)
rich_presence_conditional_display(inPark() && currentZone() == ZONE_PENGUIN_PUSH && numPenguinsInRange(2) > 5,"🕹️{0} 🐧5/5 🗺️Snowpack Park 🐧{3} 🕒{4}:{6}{5}{7} ❤️{2}fp ⌛{1}",
    rich_presence_lookup("Zone", currentZone(), ZoneLookup),
    rp_value_playtime,
    rp_value_fp,
    rp_value_penguins,
    rp_value_hr,
    rp_value_min,
    rp_lookup_minZero,
    rp_lookup_ampm,
    rich_presence_value("PenguinsRange", numPenguinsInRange(2))
)

rich_presence_conditional_display(inPark() && currentZone() == ZONE_PENGUIN_PUSH,"🕹️{0} 🐧{8}/5 🗺️Snowpack Park 🐧{3} 🕒{4}:{6}{5}{7} ❤️{2}fp ⌛{1}",
    rich_presence_lookup("Zone", currentZone(), ZoneLookup),
    rp_value_playtime,
    rp_value_fp,
    rp_value_penguins,
    rp_value_hr,
    rp_value_min,
    rp_lookup_minZero,
    rp_lookup_ampm,
    rich_presence_value("PenguinsRange", numPenguinsInRange(2))
)

// Blowfish Bowling (need 1 to 10)
rich_presence_conditional_display(inPark() && currentZone() == ZONE_BLOWFISH_BOWLING && numPenguinsInRange(1) > 10,"🕹️{0} 🐧10/10 🗺️Snowpack Park 🐧{3} 🕒{4}:{6}{5}{7} ❤️{2}fp ⌛{1}",
    rich_presence_lookup("Zone", currentZone(), ZoneLookup),
    rp_value_playtime,
    rp_value_fp,
    rp_value_penguins,
    rp_value_hr,
    rp_value_min,
    rp_lookup_minZero,
    rp_lookup_ampm,
    rich_presence_value("PenguinsRange", numPenguinsInRange(1))
)


rich_presence_conditional_display(inPark() && currentZone() == ZONE_BLOWFISH_BOWLING,"🕹️{0} 🐧{8}/10 🗺️Snowpack Park 🐧{3} 🕒{4}:{6}{5}{7} ❤️{2}fp ⌛{1}",
    rich_presence_lookup("Zone", currentZone(), ZoneLookup),
    rp_value_playtime,
    rp_value_fp,
    rp_value_penguins,
    rp_value_hr,
    rp_value_min,
    rp_lookup_minZero,
    rp_lookup_ampm,
    rich_presence_value("PenguinsRange", numPenguinsInRange(1))
)

// Free-Throw Follies (caps at 9 Penguins)
rich_presence_conditional_display(inPark() && currentZone() == ZONE_FREE_THROW_FOLLIES && numPenguinsInRange(0) > 9,"🕹️{0} 🐧9/9 🗺️Snowpack Park 🐧{3} 🕒{4}:{6}{5}{7} ❤️{2}fp ⌛{1}",
    rich_presence_lookup("Zone", currentZone(), ZoneLookup),
    rp_value_playtime,
    rp_value_fp,
    rp_value_penguins,
    rp_value_hr,
    rp_value_min,
    rp_lookup_minZero,
    rp_lookup_ampm,
    rich_presence_value("PenguinsRange", numPenguinsInRange(0))
)

rich_presence_conditional_display(inPark() && currentZone() == ZONE_FREE_THROW_FOLLIES,"🕹️{0} 🐧{8}/9 🗺️Snowpack Park 🐧{3} 🕒{4}:{6}{5}{7} ❤️{2}fp ⌛{1}",
    rich_presence_lookup("Zone", currentZone(), ZoneLookup),
    rp_value_playtime,
    rp_value_fp,
    rp_value_penguins,
    rp_value_hr,
    rp_value_min,
    rp_lookup_minZero,
    rp_lookup_ampm,
    rich_presence_value("PenguinsRange", numPenguinsInRange(0))
)
/*
rich_presence_conditional_display(inPark() && currentZone() != 0,"🕹️{0} 🗺️Snowpack Park 🐧{3} 🕒{4}:{6}{5}{7} ❤️{2}fp ⌛{1}",
    rich_presence_lookup("Zone", currentZone(), ZoneLookup),
    rp_value_playtime,
    rp_value_fp,
    rp_value_penguins,
    rp_value_hr,
    rp_value_min,
    rp_lookup_minZero,
    rp_lookup_ampm
)*/

// Various Maps
rich_presence_conditional_display(inGame(),"🗺️{0} 🐧{3} 🕒{4}:{6}{5}{7} ❤️{2}fp ⌛{1}",
    rp_lookup_map,
    rp_value_playtime,
    rp_value_fp,
    rp_value_penguins,
    rp_value_hr,
    rp_value_min,
    rp_lookup_minZero,
    rp_lookup_ampm
)

rich_presence_display("Loading...")

achs_reg = [
    ["Breaking the Ice","Discover a penguin's name, height, weight, and gender",3,achPenguinFullyRevealed()],
    ["Snowpack Explorer","Reveal every shortcut in Snowpack Park",5,achAllShortcuts()],
    ["Batch of Hats","Collect every hat",25,achItemsFound(HATS)],
    ["Push and Pull","Collect the Soccer Ball, Basketball, Baseball, Football, and Bowling Pin hats",5,achItemsFound(PENGUIN_PUSH_HATS)],
    ["Stylish Fit","Collect every coat",10,achItemsFound(COATS)],
    ["Keys to the Park","Find all three keys",5,achItemsFound(KEYS)],
    ["Yahoo! Let's-a-Go!","Collect the Red and Green hats",5,achItemsFound([ITEM_FLAG_RED_HAT,ITEM_FLAG_GREEN_HAT])],
    ["Extraterrestrial Landing","Collect the UFO hat after witnessing a UFO crash",5,achItemsFound([ITEM_FLAG_UFO])],
    
    // PHOTOS
    ["Floating in the Sky","Take a photo during a weather event at the eastern photo spot",4,achEastPhotoEvent()],
    ["Sight of the Sun","Take a photo during a weather event at the western photo spot",4,achWestPhotoEvent()],
    ["Notes Are the Sign","Hold a penguin playing a song",5,achHeldPenguinMusic()],

    // FOLLOW THAT TUNE
    ["Repeat After Me","Complete Follow That Tune! on Easy",3,achFollowThatTuneComplete(TUNE_DIFFICULTY_EASY)],
    ["Cheddar Says","Complete Follow That Tune! on Normal",5,achFollowThatTuneComplete(TUNE_DIFFICULTY_NORMAL)],
    ["You Can't Tuna Fish","Complete Follow That Tune! on Hard",10,achFollowThatTuneComplete(TUNE_DIFFICULTY_HARD)],
    
    // FLIPPER TIPPER
    ["Tipping Point","Clear every Easy level in Flipper Tipper",5,achFlipperLevelsComplete(FLIPPER_LEVELS_EASY)],
    ["Feelin' Tipsy","Clear every Normal level in Flipper Tipper",10,achFlipperLevelsComplete(FLIPPER_LEVELS_NORMAL)],
    ["Tip of the Iceberg","Clear every Hard level in Flipper Tipper",25,achFlipperLevelsComplete(FLIPPER_LEVELS_HARD)],
    ["Tip-Top Shape","Clear Stage 1 of Flipper Tipper with at least 20 bonus penguins on any difficulty",5,achFlipperCompleteBonus(0,20)],
    ["Tip and Tumble","Clear Stage 2 of Flipper Tipper with at least 14 bonus penguins on any difficulty",5,achFlipperCompleteBonus(1,14)],
    ["Pinpoint Placement","Clear Stage 3 of Flipper Tipper with at least 16 bonus penguins on any difficulty",10,achFlipperCompleteBonus(2,16)],
    ["Superstar Summit","Clear Stage 4 of Flipper Tipper with at least 18 bonus penguins on any difficulty",10,achFlipperCompleteBonus(3,18)],
    ["Gratuitous Tip","Clear Stage 5 of Flipper Tipper with at least 12 bonus penguins on any difficulty",10,achFlipperCompleteBonus(4,12)],

    // FLIP A PENGUIN
    ["Flipping the Birds","Win a game of Flip-a-Penguin on Easy",5,achPengFlipCompleteDifficulty(FLIPAPENGUIN_DIFFICULTY_EASY)],
    ["Club Penguin","Win a game of Flip-a-Penguin on Normal",10,achPengFlipCompleteDifficulty(FLIPAPENGUIN_DIFFICULTY_NORMAL)],

    //ITS MY TUNA
    ["I Don't Know You!","Score 70 points in It's My Tuna!",5,achItsMyTunaScoreReached(70)],
    
    // FREE THROW
    ["The Ice Lakers","Score 70 points in Free-Throw Follies",5,achFreeThrowScore(70)],

    // PENGUIN PUSH
    ["Pushed to the Edge","Score 35 points in Penguin Push",5,achPengPushScore(35)],

    // BOWLING
    ["Out of the Park","Get a strike in Blowfish Bowling",5,achBlowfishBowlingStrike()],

    // CHUCK A CHOWFISH
    ["Chow Down Showdown","Score 70 points in Chuck-a-Chowfish",5,achChuckaChowfishScore(70)],
]

achs_prog = [
    ["Unsealed Containment","Get past the Seals in Snowpack Park",3,achSeal()],
    ["Weight of our Actions","Make the bridge collapse in Snowpack Park",5,achBridge()],
    ["Pooled Resources","Drain the pool in Snowpack Park",5,achPool()],
]

achs_win = [
    ["Aren't You Forgetting Someone?","Capture 100 penguins",25,achHundredPenguins()]
]

for a in achs_reg ach(a,"")
for a in achs_prog ach(a,"progression")
for a in achs_win ach(a,"win_condition")

leaderboard(
        title = "Chuck-a-Chowfish",
        description = "Highest Score",
        start = completedChuckaChowfish(),
        cancel = always_false(),
        submit = always_true(),
        value  = PlayerData()["chuckachowfish_score"],
        format = "VALUE", lower_is_better = false
    )

leaderboard(
        title = "Blowfish Bowling",
        description = "Highest Score",
        start = completedBlowfishBowling(),
        cancel = always_false(),
        submit = always_true(),
        value  = PlayerData()["blowfishbowling_finalscore"],
        format = "VALUE", lower_is_better = false
    )

leaderboard(
        title = "Penguin Push",
        description = "Highest Score",
        start = completedPenguinPush(),
        cancel = always_false(),
        submit = always_true(),
        value  = PlayerData()["penguinpush_finalscore"],
        format = "VALUE", lower_is_better = false
    )

leaderboard(
        title = "Free-Throw Follies",
        description = "Highest Score",
        start = completeFreeThrow(),
        cancel = always_false(),
        submit = always_true(),
        value  = PlayerData()["freethrow_score"],
        format = "VALUE", lower_is_better = false
    )

leaderboard(
        title = "It's My Tuna!",
        description = "Highest Score",
        start = completeMyTuna(),
        cancel = always_false(),
        submit = always_true(),
        value  = PlayerData()["thatsmytuna_score"],
        format = "VALUE", lower_is_better = false
    )

for difficulty in DifficultyLookup {
    difficulty_name = DifficultyLookup[difficulty]

    for level in range(0,4) {
        leaderboard(
            title = format("Flipper Tipper ({0} {1})", difficulty_name, level + 1),
            description = "Highest Bonus",
            start = flipperCompleteLevel(difficulty, level) && MinigameData()["flipper_bonus"] > 0,
            cancel = always_false(),
            submit = always_true(),
            value  = MinigameData()["flipper_bonus"],
            format = "VALUE", lower_is_better = false
        )
    }
}

leaderboard(
        title = "Flip-a-Penguin (Easy)",
        description = "Highest Score Advantage",
        start = pengFlipCompleteDifficulty(FLIPAPENGUIN_DIFFICULTY_EASY),
        cancel = always_false(),
        submit = always_true(),
        value  = pengFlipPlayerScore() - pengFlipOppScore(),
        format = "VALUE", lower_is_better = false
    )

leaderboard(
        title = "Flip-a-Penguin (Normal)",
        description = "Highest Score Advantage",
        start = pengFlipCompleteDifficulty(FLIPAPENGUIN_DIFFICULTY_NORMAL),
        cancel = always_false(),
        submit = always_true(),
        value  = pengFlipPlayerScore() - pengFlipOppScore(),
        format = "VALUE", lower_is_better = false
    )