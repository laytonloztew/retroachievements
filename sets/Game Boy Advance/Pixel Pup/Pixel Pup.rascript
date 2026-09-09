// ~Homebrew~ Pixel Pup
// #ID = 42809

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
function bitflag(addr,f) => bit(f%8, addr + f/8)
function rp_num(x) => rich_presence_value("Number", x)

function ach(ach, t) {
    achievement(
        title = ach[0],
        points = ach[2],
        description = ach[1],
        trigger = ach[3],
        type=t
    )
}

// --------------------------------------------------------
// MARK: MEMORY
// 
// --------------------------------------------------------
function gameState() => byte(0x008028)
function currentPuzzleAddr() => dword(0x0017cc)
function currentPackAddr() => dword(0x0017d0)

function hintsLeft() => dword(0x00bbfc)
function timeLeft() => dword(0x00bcc8)
function mistakesMade() => dword(0x00bccc)
function puzzleState() => dword(0x00bc1c)
function puzzleSize() => dword(0x00bbf4)

function clockSetting() => byte(0x04800b)
function hintSetting() => byte(0x048009)

function puzzleSolved(i) => byte(0x04800d + i)
function ePuzzleUnlocked(i) => byte(0x04810d + i)
function ePuzzleSolved(i) => byte(0x048115 + i)
function puzzleTileState(col, row) => dword(0x005e54 + (col * 60) + (row * 4))

function sramSaveHeader() => tbyte(0x048000)
// --------------------------------------------------------
// MARK: DATA
// 
// --------------------------------------------------------
// We use address of puzzle in Game Park ROM to detect current puzzle. ROM isn't accessible, these addresses change in updates
FANTASY_POTION = 0x08109430
FANTASY_WARHAMMER = 0x08108f08
FANTASY_BOW = 0x081089e0
FANTASY_ACCESSORY = 0x081084b8
FANTASY_AMULET = 0x08107f90
FANTASY_QUEST = 0x08107a68
FANTASY_GOBLIN = 0x08107540
FANTASY_CHEST = 0x08107018
FANTASY_SLIME = 0x08106af0
FANTASY_STAFF = 0x081065c8
FANTASY_SHIELD = 0x081060a0
FANTASY_MAGICMIRROR = 0x08105b78
FANTASY_DAGGER = 0x08105650
FANTASY_WIZARD_HAT = 0x08105128
FANTASY_CRYSTAL = 0x08104c00
FANTASY_WITCH = 0x081046d8
FANTASY_FLOATINGISLE = 0x081041b0
FANTASY_CLERIC = 0x08103c88
FANTASY_COCKATRICE = 0x08103760
FANTASY_MAGIC_SPELL = 0x08103238
FANTASY_WYVERN = 0x08102d10
FANTASY_MANDRAKE = 0x081027e8
FANTASY_FAIRY = 0x081022c0
FANTASY_DISASTER = 0x08101d98
DIY_DADO = 0x080f5e94
DIY_WING_NUT = 0x080f596c
DIY_OIL = 0x080f5444
DIY_SCREW = 0x080f4f1c
DIY_SUBWAY_TILE = 0x080f49f4
DIY_TRAINING = 0x080f44cc
DIY_COMBOWRENCH = 0x080f3fa4
DIY_TOILETFLANGE = 0x080f3a7c
DIY_IMPACTDRIVER = 0x080f3554
DIY_WIRE_NUT = 0x080f302c
DIY_PERMIT = 0x080f2b04
DIY_SWATCHES = 0x080f25dc
DIY_PLIERS = 0x080f20b4
DIY_HAMMER = 0x080f1b8c
DIY_BIGBOX_STORE = 0x080f1664
DIY_CRSCNTWRENCH = 0x080f113c
DIY_VANITY = 0x080f0c14
DIY_CAULK_GUN = 0x080f06ec
DIY_BLOWN_IN = 0x080f01c4
DIY_MITER_SAW = 0x080efc9c
DIY_P_TRAP = 0x080ef774
DIY_BURST_PIPE = 0x080ef24c
DIY_CIRCULAR_SAW = 0x080eed24
DIY_PAINT_ROLLER = 0x080ee7fc
ART_MUSEUM_PIECE_1 = 0x080e5618
ART_MUSEUM_PIECE_2 = 0x080e50f0
ART_MUSEUM_PIECE_3 = 0x080e4bc8
ART_MUSEUM_PIECE_4 = 0x080e46a0
ART_MUSEUM_PIECE_5 = 0x080e4178
ART_MUSEUM_PIECE_6 = 0x080e3c50
ART_MUSEUM_PIECE_7 = 0x080e3728
ART_MUSEUM_PIECE_8 = 0x080e3200
ART_MUSEUM_PIECE_9 = 0x080e2cd8
ART_MUSEUM_PIECE_10 = 0x080e27b0
ART_MUSEUM_PIECE_11 = 0x080e2288
ART_MUSEUM_PIECE_12 = 0x080e1d60
ART_MUSEUM_PIECE_13 = 0x080e1838
ART_MUSEUM_PIECE_14 = 0x080e1310
ART_MUSEUM_PIECE_15 = 0x080e0de8
ENTOMOLOGY_LADY_BIRD = 0x080fe56c
ENTOMOLOGY_MAGGOT = 0x080fe044
ENTOMOLOGY_HOUSEFLY = 0x080fdb1c
ENTOMOLOGY_FLEA = 0x080fd5f4
ENTOMOLOGY_GRUB = 0x080fd0cc
ENTOMOLOGY_MILLIPEDE = 0x080fcba4
ENTOMOLOGY_BUG = 0x080fc67c
ENTOMOLOGY_CRICKET = 0x080fc154
ENTOMOLOGY_BEE = 0x080fbc2c
ENTOMOLOGY_MAGNIFYGLASS = 0x080fb704
ENTOMOLOGY_ANT = 0x080fb1dc
ENTOMOLOGY_GUMMY_WORM = 0x080facb4
ENTOMOLOGY_EGG = 0x080fa78c
ENTOMOLOGY_MOTH = 0x080fa264
ENTOMOLOGY_MUSEUM = 0x080f9d3c
ENTOMOLOGY_BUTTERFLY = 0x080f9814
ENTOMOLOGY_SPECIMENS = 0x080f92ec
ENTOMOLOGY_DYNASTINAE = 0x080f8dc4
ENTOMOLOGY_INCH_WORM = 0x080f889c
ENTOMOLOGY_DAMSELFLY = 0x080f8374
ENTOMOLOGY_COCOON = 0x080f7e4c
ENTOMOLOGY_MICROSCOPE = 0x080f7924
ENTOMOLOGY_SCORPION = 0x080f73fc
ENTOMOLOGY_BEETLE = 0x080f6ed4
FABULOUS_PIECE_1 = 0x087a60c8
FABULOUS_PIECE_2 = 0x087a5ba0
FABULOUS_PIECE_3 = 0x087a5678
FABULOUS_PIECE_4 = 0x087a5150
FABULOUS_PIECE_5 = 0x087a4c28
FABULOUS_PIECE_6 = 0x087a4700
FABULOUS_PIECE_7 = 0x087a41d8
FABULOUS_PIECE_8 = 0x087a3cb0
FABULOUS_PIECE_9 = 0x087a3788
FABULOUS_PIECE_10 = 0x087a3260
FABULOUS_PIECE_11 = 0x087a2d38
FABULOUS_PIECE_12 = 0x087a2810
FABULOUS_PIECE_13 = 0x087a22e8
FABULOUS_PIECE_14 = 0x087a1dc0
FABULOUS_PIECE_15 = 0x087a1898
FABULOUS_PIECE_16 = 0x087a1370
TAIYAKI_FISH_POWER = 0x087a0350
TAIYAKI_SKULL = 0x0879fe28
TAIYAKI_BUBBLE = 0x0879f900
TAIYAKI_NOT_A_FISH = 0x0879f3d8
TAIYAKI_HARP = 0x0879eeb0
TAIYAKI_DIAMOND = 0x0879e988
TAIYAKI_HOLY_SNORKEL = 0x0879e460
TAIYAKI_THREE_HUNDO = 0x0879df38
TAIYAKI_LUCID_DREAM = 0x0879da10
TAIYAKI_END_SHIP = 0x0879d4e8
TAIYAKI_PEARL_CLAM = 0x0879cfc0
TAIYAKI_SHOVEL = 0x0879ca98
TAIYAKI_MAGIC_JUG = 0x0879c570
TAIYAKI_GATOR_BRIBE = 0x0879c048
TAIYAKI_ANGLERFISH = 0x0879bb20
TAIYAKI_JELLYFISH = 0x0879b5f8
TAIYAKI_SUNFISH = 0x0879b0d0
TAIYAKI_SEAHORSE = 0x0879aba8
TAIYAKI_MERMAID = 0x0879a680
TAIYAKI_CRAB = 0x0879a158
TAIYAKI_DUCK = 0x08799c30
TAIYAKI_CHAD = 0x08799708
TAIYAKI_SEA_ANGEL = 0x087991e0
TAIYAKI_LUCKY = 0x08798cb8
THE_NINETIES_POG = 0x0811208c
THE_NINETIES_COMPACTDOLL = 0x08111b64
THE_NINETIES_FRIENDSHIP = 0x0811163c
THE_NINETIES_YO_YO = 0x08111114
THE_NINETIES_USB = 0x08110bec
THE_NINETIES_CD_ROM = 0x081106c4
THE_NINETIES_VIRTUAL_PET = 0x0811019c
THE_NINETIES_FIGHT_GAME = 0x0810fc74
THE_NINETIES_SEATTLE = 0x0810f74c
THE_NINETIES_BOY_BAND = 0x0810f224
THE_NINETIES_100_MB = 0x0810ecfc
THE_NINETIES_FLANNEL = 0x0810e7d4
THE_NINETIES_FASHION = 0x0810e2ac
THE_NINETIES_TCG = 0x0810dd84
THE_NINETIES_MOBILE_GAME = 0x0810d85c
THE_NINETIES_HOME_ARCADE = 0x0810d334
THE_NINETIES_CELL_PHONE = 0x0810ce0c
THE_NINETIES_GOTH = 0x0810c8e4
THE_NINETIES_INLINE_SKATE = 0x0810c3bc
THE_NINETIES_SOCIAL_MEDIA = 0x0810be94
THE_NINETIES_LEATHER_BOOT = 0x0810b96c
THE_NINETIES_FRO_YO = 0x0810b444
THE_NINETIES_ICOMPUTER = 0x0810af1c
THE_NINETIES_CANT_TOUCH = 0x0810a9f4
ZOOLOGY_PAWPRINT = 0x087aeb04
ZOOLOGY_RABBIT = 0x087ae5dc
ZOOLOGY_STRIPES = 0x087ae0b4
ZOOLOGY_EGG = 0x087adb8c
ZOOLOGY_LION = 0x087ad664
ZOOLOGY_SNAKE = 0x087ad13c
ZOOLOGY_FOX = 0x087acc14
ZOOLOGY_FIELDMOUSE = 0x087ac6ec
ZOOLOGY_DESKMOUSE = 0x087ac1c4
ZOOLOGY_BEE_SKEP = 0x087abc9c
ZOOLOGY_STARFISH = 0x087ab774
ZOOLOGY_ROBIN = 0x087ab24c
ZOOLOGY_DRAGONFLY = 0x087aad24
ZOOLOGY_SURGEONFISH = 0x087aa7fc
ZOOLOGY_TORTOISE = 0x087aa2d4
ZOOLOGY_CAPYBARA = 0x087a9dac
ZOOLOGY_ELEPHANT = 0x087a9884
ZOOLOGY_GECKO = 0x087a935c
ZOOLOGY_PANDA = 0x087a8e34
ZOOLOGY_CORAL = 0x087a890c
ZOOLOGY_RAM = 0x087a83e4
ZOOLOGY_PENGUIN = 0x087a7ebc
ZOOLOGY_GIRAFFE = 0x087a7994
ZOOLOGY_BACTERIUM = 0x087a746c
HOWTOPLAY_HORSE = 0x0810a414
TITLE_FRANNY = 0x087a6e2c
CLASSROOM_PIECE_1 = 0x080edf1c
CLASSROOM_PIECE_2 = 0x080ed9f4
CLASSROOM_PIECE_3 = 0x080ed4cc
CLASSROOM_PIECE_4 = 0x080ecfa4
CLASSROOM_PIECE_5 = 0x080eca7c
CLASSROOM_PIECE_6 = 0x080ec554
CLASSROOM_PIECE_7 = 0x080ec02c
CLASSROOM_PIECE_8 = 0x080ebb04
CLASSROOM_PIECE_9 = 0x080eb5dc
CLASSROOM_PIECE_10 = 0x080eb0b4
CLASSROOM_PIECE_11 = 0x080eab8c
CLASSROOM_PIECE_12 = 0x080ea664
CLASSROOM_PIECE_13 = 0x080ea13c
CLASSROOM_PIECE_14 = 0x080e9c14
CLASSROOM_PIECE_15 = 0x080e96ec
CLASSROOM_PIECE_16 = 0x080e91c4
CLASSROOM_PIECE_17 = 0x080e8c9c
CLASSROOM_PIECE_18 = 0x080e8774
CLASSROOM_PIECE_19 = 0x080e824c
CLASSROOM_PIECE_20 = 0x080e7d24
CLASSROOM_PIECE_21 = 0x080e77fc
CLASSROOM_PIECE_22 = 0x080e72d4
CLASSROOM_PIECE_23 = 0x080e6dac
CLASSROOM_PIECE_24 = 0x080e6884
CLASSROOM_PIECE_25 = 0x080e635c
SURPRISE_PIECE_1 = 0x08798278
SURPRISE_PIECE_2 = 0x08797d50
SURPRISE_PIECE_3 = 0x08797828
SURPRISE_PIECE_4 = 0x08797300
SURPRISE_PIECE_5 = 0x08796dd8
SURPRISE_PIECE_6 = 0x087968b0
SURPRISE_PIECE_7 = 0x08796388
SURPRISE_PIECE_8 = 0x08795e60
SURPRISE_PIECE_9 = 0x08795938
E_READER_ELEPHANT = 0x08101458
E_READER_CHEESE = 0x08100f30
E_READER_SNAKE = 0x08100a08
E_READER_VICK = 0x081004e0
E_READER_PIG_TWERK = 0x080fffb8
E_READER_SPADE = 0x080ffa90
E_READER_EREADER_CARD = 0x080ff568

STATE_CUTSCENE = 0
STATE_TITLE = 1
STATE_QUICK_SAVE = 2
STATE_PUZZLE_MENU = 3
STATE_PUZZLE = 4
STATE_SETTINGS = 5
STATE_TUTORIAL = 6
STATE_SAVE_WARN = 7
STATE_MULTI_SETUP = 8
STATE_MULTI_MODE = 9
STATE_COMM_ERROR = 0xa
STATE_RANDOM_MENU = 0xb
STATE_CREDITS = 0xc
STATE_DEMO = 0x0d
STATE_PODIUM = 0x0e
STATE_LOGO = 0x0f
STATE_SAVE_CORRUPT = 0x10
STATE_EREADER_CONNECT = 0x11
STATE_EREADER_MENU = 0x12
STATE_MULTI_LOBBY = 0x13
STATE_RACE = 0x14
STATE_RACE_PODIUM = 0x15

TUTORIAL_TILE_ARRAY = [[1,0],
[0,1],[1,1],
[1,2],[2,2],[3,2],[4,2],
[1,3],[2,3],[3,3],[4,3],
[1,4],[4,4]
]

// --------------------------------------------------------
// MARK: FUNCTIONS
// 
// --------------------------------------------------------
function inPuzzle() => gameState() == STATE_PUZZLE
function viewingDemo() => (gameState() == STATE_PUZZLE && prior(gameState()) == STATE_DEMO) || gameState() == STATE_DEMO
function noMistakesMade() => mistakesMade() == 0xffffffff

function puzzleComplete() => puzzleState() == 6 && prev(puzzleState()) == 5
function puzzleClear() => puzzleState() == 0x0a && prev(puzzleState()) < 0x0a
function puzzleStarted() => puzzleState() == 5 && prev(puzzleState()) < 5 && prev(puzzleState()) > 2

function achPuzzleClear(p) => inPuzzle() && puzzleClear() && currentPuzzleAddr() == p

function saveLoaded() => sramSaveHeader() == 0x707070

function sumPuzzleTiles(arr) => sum_of(arr, coords => puzzleTileState(coords[0],coords[1]) / 3) 

function sumPuzzleRange(start,amt) => sum_of(range(start,start+amt-1), i => puzzleSolved(i))

function sumAllPuzzles() { 
    total = 0
    for i in range(0,209) {
        if (i >= 175) { // Skip Tutorial
            total = total + puzzleSolved(i + 1)
        } else {
            total = total + puzzleSolved(i)
        }
    }
    return total
}

// Prior gamestate prevents quick save, and none_of prevents puzzle packs random option
function isRandomPuzzleNoContinue(p) => prior(gameState()) == STATE_RANDOM_MENU && none_of(LookupPuzzle, k => p == k)

// --------------------------------------------------------
// MARK: RICH PRESENCE LOOKUPS
// 
// --------------------------------------------------------
LookupPuzzle = {
    FANTASY_POTION: "Fantasy #1", // Potion
    FANTASY_WARHAMMER: "Fantasy #2", // Warhammer
    FANTASY_BOW: "Fantasy #3", // Bow
    FANTASY_ACCESSORY: "Fantasy #4", // Accessory
    FANTASY_AMULET: "Fantasy #5", // Amulet
    FANTASY_QUEST: "Fantasy #6", // Quest
    FANTASY_GOBLIN: "Fantasy #7", // Goblin
    FANTASY_CHEST: "Fantasy #8", // Chest
    FANTASY_SLIME: "Fantasy #9", // Slime
    FANTASY_STAFF: "Fantasy #10", // Staff
    FANTASY_SHIELD: "Fantasy #11", // Shield
    FANTASY_MAGICMIRROR: "Fantasy #12", // MagicMirror
    FANTASY_DAGGER: "Fantasy #13", // Dagger
    FANTASY_WIZARD_HAT: "Fantasy #14", // Wizard Hat
    FANTASY_CRYSTAL: "Fantasy #15", // Crystal
    FANTASY_WITCH: "Fantasy #16", // Witch
    FANTASY_FLOATINGISLE: "Fantasy #17", // FloatingIsle
    FANTASY_CLERIC: "Fantasy #18", // Cleric
    FANTASY_COCKATRICE: "Fantasy #19", // Cockatrice
    FANTASY_MAGIC_SPELL: "Fantasy #20", // Magic Spell
    FANTASY_WYVERN: "Fantasy #21", // Wyvern
    FANTASY_MANDRAKE: "Fantasy #22", // Mandrake
    FANTASY_FAIRY: "Fantasy #23", // Fairy
    FANTASY_DISASTER: "Fantasy #24", // Disaster
    DIY_DADO: "DIY #1", // Dado
    DIY_WING_NUT: "DIY #2", // Wing Nut
    DIY_OIL: "DIY #3", // Oil
    DIY_SCREW: "DIY #4", // Screw
    DIY_SUBWAY_TILE: "DIY #5", // Subway Tile
    DIY_TRAINING: "DIY #6", // Training
    DIY_COMBOWRENCH: "DIY #7", // ComboWrench
    DIY_TOILETFLANGE: "DIY #8", // ToiletFlange
    DIY_IMPACTDRIVER: "DIY #9", // ImpactDriver
    DIY_WIRE_NUT: "DIY #10", // Wire Nut
    DIY_PERMIT: "DIY #11", // Permit
    DIY_SWATCHES: "DIY #12", // Swatches
    DIY_PLIERS: "DIY #13", // Pliers
    DIY_HAMMER: "DIY #14", // Hammer
    DIY_BIGBOX_STORE: "DIY #15", // BigBox Store
    DIY_CRSCNTWRENCH: "DIY #16", // CrscntWrench
    DIY_VANITY: "DIY #17", // Vanity
    DIY_CAULK_GUN: "DIY #18", // Caulk Gun
    DIY_BLOWN_IN: "DIY #19", // Blown In
    DIY_MITER_SAW: "DIY #20", // Miter Saw
    DIY_P_TRAP: "DIY #21", // P Trap
    DIY_BURST_PIPE: "DIY #22", // Burst Pipe
    DIY_CIRCULAR_SAW: "DIY #23", // Circular Saw
    DIY_PAINT_ROLLER: "DIY #24", // Paint Roller
    ART_MUSEUM_PIECE_1: "Art Museum #1", // piece 1
    ART_MUSEUM_PIECE_2: "Art Museum #2", // piece 2
    ART_MUSEUM_PIECE_3: "Art Museum #3", // piece 3
    ART_MUSEUM_PIECE_4: "Art Museum #4", // piece 4
    ART_MUSEUM_PIECE_5: "Art Museum #5", // piece 5
    ART_MUSEUM_PIECE_6: "Art Museum #6", // piece 6
    ART_MUSEUM_PIECE_7: "Art Museum #7", // piece 7
    ART_MUSEUM_PIECE_8: "Art Museum #8", // piece 8
    ART_MUSEUM_PIECE_9: "Art Museum #9", // piece 9
    ART_MUSEUM_PIECE_10: "Art Museum #10", // piece 10
    ART_MUSEUM_PIECE_11: "Art Museum #11", // piece 11
    ART_MUSEUM_PIECE_12: "Art Museum #12", // piece 12
    ART_MUSEUM_PIECE_13: "Art Museum #13", // piece 13
    ART_MUSEUM_PIECE_14: "Art Museum #14", // piece 14
    ART_MUSEUM_PIECE_15: "Art Museum #15", // piece 15
    ENTOMOLOGY_LADY_BIRD: "Entomology #1", // Lady Bird
    ENTOMOLOGY_MAGGOT: "Entomology #2", // Maggot
    ENTOMOLOGY_HOUSEFLY: "Entomology #3", // Housefly
    ENTOMOLOGY_FLEA: "Entomology #4", // Flea
    ENTOMOLOGY_GRUB: "Entomology #5", // Grub
    ENTOMOLOGY_MILLIPEDE: "Entomology #6", // Millipede
    ENTOMOLOGY_BUG: "Entomology #7", // Bug
    ENTOMOLOGY_CRICKET: "Entomology #8", // Cricket
    ENTOMOLOGY_BEE: "Entomology #9", // Bee
    ENTOMOLOGY_MAGNIFYGLASS: "Entomology #10", // MagnifyGlass
    ENTOMOLOGY_ANT: "Entomology #11", // Ant
    ENTOMOLOGY_GUMMY_WORM: "Entomology #12", // Gummy Worm
    ENTOMOLOGY_EGG: "Entomology #13", // Egg
    ENTOMOLOGY_MOTH: "Entomology #14", // Moth
    ENTOMOLOGY_MUSEUM: "Entomology #15", // Museum
    ENTOMOLOGY_BUTTERFLY: "Entomology #16", // Butterfly
    ENTOMOLOGY_SPECIMENS: "Entomology #17", // Specimens
    ENTOMOLOGY_DYNASTINAE: "Entomology #18", // Dynastinae
    ENTOMOLOGY_INCH_WORM: "Entomology #19", // Inch Worm
    ENTOMOLOGY_DAMSELFLY: "Entomology #20", // Damselfly
    ENTOMOLOGY_COCOON: "Entomology #21", // Cocoon
    ENTOMOLOGY_MICROSCOPE: "Entomology #22", // Microscope
    ENTOMOLOGY_SCORPION: "Entomology #23", // Scorpion
    ENTOMOLOGY_BEETLE: "Entomology #24", // Beetle
    FABULOUS_PIECE_1: "Fabulous #1", // piece 1
    FABULOUS_PIECE_2: "Fabulous #2", // piece 2
    FABULOUS_PIECE_3: "Fabulous #3", // piece 3
    FABULOUS_PIECE_4: "Fabulous #4", // piece 4
    FABULOUS_PIECE_5: "Fabulous #5", // piece 5
    FABULOUS_PIECE_6: "Fabulous #6", // piece 6
    FABULOUS_PIECE_7: "Fabulous #7", // piece 7
    FABULOUS_PIECE_8: "Fabulous #8", // piece 8
    FABULOUS_PIECE_9: "Fabulous #9", // piece 9
    FABULOUS_PIECE_10: "Fabulous #10", // piece 10
    FABULOUS_PIECE_11: "Fabulous #11", // piece 11
    FABULOUS_PIECE_12: "Fabulous #12", // piece 12
    FABULOUS_PIECE_13: "Fabulous #13", // piece 13
    FABULOUS_PIECE_14: "Fabulous #14", // piece 14
    FABULOUS_PIECE_15: "Fabulous #15", // piece 15
    FABULOUS_PIECE_16: "Fabulous #16", // piece 16
    TAIYAKI_FISH_POWER: "Taiyaki #1", // Fish Power
    TAIYAKI_SKULL: "Taiyaki #2", // Skull
    TAIYAKI_BUBBLE: "Taiyaki #3", // Bubble
    TAIYAKI_NOT_A_FISH: "Taiyaki #4", // Not a Fish
    TAIYAKI_HARP: "Taiyaki #5", // Harp
    TAIYAKI_DIAMOND: "Taiyaki #6", // Diamond
    TAIYAKI_HOLY_SNORKEL: "Taiyaki #7", // Holy Snorkel
    TAIYAKI_THREE_HUNDO: "Taiyaki #8", // Three Hundo
    TAIYAKI_LUCID_DREAM: "Taiyaki #9", // Lucid Dream
    TAIYAKI_END_SHIP: "Taiyaki #10", // End Ship
    TAIYAKI_PEARL_CLAM: "Taiyaki #11", // Pearl Clam
    TAIYAKI_SHOVEL: "Taiyaki #12", // Shovel
    TAIYAKI_MAGIC_JUG: "Taiyaki #13", // Magic Jug
    TAIYAKI_GATOR_BRIBE: "Taiyaki #14", // Gator Bribe
    TAIYAKI_ANGLERFISH: "Taiyaki #15", // Anglerfish
    TAIYAKI_JELLYFISH: "Taiyaki #16", // Jellyfish
    TAIYAKI_SUNFISH: "Taiyaki #17", // Sunfish
    TAIYAKI_SEAHORSE: "Taiyaki #18", // Seahorse
    TAIYAKI_MERMAID: "Taiyaki #19", // Mermaid
    TAIYAKI_CRAB: "Taiyaki #20", // Crab
    TAIYAKI_DUCK: "Taiyaki #21", // Duck
    TAIYAKI_CHAD: "Taiyaki #22", // Chad
    TAIYAKI_SEA_ANGEL: "Taiyaki #23", // Sea Angel
    TAIYAKI_LUCKY: "Taiyaki #24", // Lucky
    THE_NINETIES_POG: "The Nineties #1", // Pog
    THE_NINETIES_COMPACTDOLL: "The Nineties #2", // CompactDoll
    THE_NINETIES_FRIENDSHIP: "The Nineties #3", // Friendship
    THE_NINETIES_YO_YO: "The Nineties #4", // Yo Yo
    THE_NINETIES_USB: "The Nineties #5", // USB
    THE_NINETIES_CD_ROM: "The Nineties #6", // CD ROM
    THE_NINETIES_VIRTUAL_PET: "The Nineties #7", // Virtual Pet
    THE_NINETIES_FIGHT_GAME: "The Nineties #8", // Fight Game
    THE_NINETIES_SEATTLE: "The Nineties #9", // Seattle
    THE_NINETIES_BOY_BAND: "The Nineties #10", // Boy Band
    THE_NINETIES_100_MB: "The Nineties #11", // 100 MB
    THE_NINETIES_FLANNEL: "The Nineties #12", // Flannel
    THE_NINETIES_FASHION: "The Nineties #13", // Fashion
    THE_NINETIES_TCG: "The Nineties #14", // TCG
    THE_NINETIES_MOBILE_GAME: "The Nineties #15", // Mobile Game
    THE_NINETIES_HOME_ARCADE: "The Nineties #16", // Home Arcade
    THE_NINETIES_CELL_PHONE: "The Nineties #17", // Cell Phone
    THE_NINETIES_GOTH: "The Nineties #18", // Goth
    THE_NINETIES_INLINE_SKATE: "The Nineties #19", // Inline Skate
    THE_NINETIES_SOCIAL_MEDIA: "The Nineties #20", // Social Media
    THE_NINETIES_LEATHER_BOOT: "The Nineties #21", // Leather Boot
    THE_NINETIES_FRO_YO: "The Nineties #22", // Fro Yo
    THE_NINETIES_ICOMPUTER: "The Nineties #23", // iComputer
    THE_NINETIES_CANT_TOUCH: "The Nineties #24", // Cant Touch
    ZOOLOGY_PAWPRINT: "Zoology #1", // Pawprint
    ZOOLOGY_RABBIT: "Zoology #2", // Rabbit
    ZOOLOGY_STRIPES: "Zoology #3", // Stripes
    ZOOLOGY_EGG: "Zoology #4", // Egg
    ZOOLOGY_LION: "Zoology #5", // Lion
    ZOOLOGY_SNAKE: "Zoology #6", // Snake
    ZOOLOGY_FOX: "Zoology #7", // Fox
    ZOOLOGY_FIELDMOUSE: "Zoology #8", // Fieldmouse
    ZOOLOGY_DESKMOUSE: "Zoology #9", // Deskmouse
    ZOOLOGY_BEE_SKEP: "Zoology #10", // Bee Skep
    ZOOLOGY_STARFISH: "Zoology #11", // Starfish
    ZOOLOGY_ROBIN: "Zoology #12", // Robin
    ZOOLOGY_DRAGONFLY: "Zoology #13", // Dragonfly
    ZOOLOGY_SURGEONFISH: "Zoology #14", // Surgeonfish
    ZOOLOGY_TORTOISE: "Zoology #15", // Tortoise
    ZOOLOGY_CAPYBARA: "Zoology #16", // Capybara
    ZOOLOGY_ELEPHANT: "Zoology #17", // Elephant
    ZOOLOGY_GECKO: "Zoology #18", // Gecko
    ZOOLOGY_PANDA: "Zoology #19", // Panda
    ZOOLOGY_CORAL: "Zoology #20", // Coral
    ZOOLOGY_RAM: "Zoology #21", // Ram
    ZOOLOGY_PENGUIN: "Zoology #22", // Penguin
    ZOOLOGY_GIRAFFE: "Zoology #23", // Giraffe
    ZOOLOGY_BACTERIUM: "Zoology #24", // Bacterium
    HOWTOPLAY_HORSE: "Tutorial", // Horse
    TITLE_FRANNY: "Franny", // Franny
    CLASSROOM_PIECE_1: "Classroom #1", // piece 1
    CLASSROOM_PIECE_2: "Classroom #2", // piece 2
    CLASSROOM_PIECE_3: "Classroom #3", // piece 3
    CLASSROOM_PIECE_4: "Classroom #4", // piece 4
    CLASSROOM_PIECE_5: "Classroom #5", // piece 5
    CLASSROOM_PIECE_6: "Classroom #6", // piece 6
    CLASSROOM_PIECE_7: "Classroom #7", // piece 7
    CLASSROOM_PIECE_8: "Classroom #8", // piece 8
    CLASSROOM_PIECE_9: "Classroom #9", // piece 9
    CLASSROOM_PIECE_10: "Classroom #10", // piece 10
    CLASSROOM_PIECE_11: "Classroom #11", // piece 11
    CLASSROOM_PIECE_12: "Classroom #12", // piece 12
    CLASSROOM_PIECE_13: "Classroom #13", // piece 13
    CLASSROOM_PIECE_14: "Classroom #14", // piece 14
    CLASSROOM_PIECE_15: "Classroom #15", // piece 15
    CLASSROOM_PIECE_16: "Classroom #16", // piece 16
    CLASSROOM_PIECE_17: "Classroom #17", // piece 17
    CLASSROOM_PIECE_18: "Classroom #18", // piece 18
    CLASSROOM_PIECE_19: "Classroom #19", // piece 19
    CLASSROOM_PIECE_20: "Classroom #20", // piece 20
    CLASSROOM_PIECE_21: "Classroom #21", // piece 21
    CLASSROOM_PIECE_22: "Classroom #22", // piece 22
    CLASSROOM_PIECE_23: "Classroom #23", // piece 23
    CLASSROOM_PIECE_24: "Classroom #24", // piece 24
    CLASSROOM_PIECE_25: "Classroom #25", // piece 25
    SURPRISE_PIECE_1: "Surprise #1", // piece 1
    SURPRISE_PIECE_2: "Surprise #2", // piece 2
    SURPRISE_PIECE_3: "Surprise #3", // piece 3
    SURPRISE_PIECE_4: "Surprise #4", // piece 4
    SURPRISE_PIECE_5: "Surprise #5", // piece 5
    SURPRISE_PIECE_6: "Surprise #6", // piece 6
    SURPRISE_PIECE_7: "Surprise #7", // piece 7
    SURPRISE_PIECE_8: "Surprise #8", // piece 8
    SURPRISE_PIECE_9: "Surprise #9", // piece 9
    E_READER_ELEPHANT: "e-Reader #1", // Elephant
    E_READER_CHEESE: "e-Reader #2", // Cheese
    E_READER_SNAKE: "e-Reader #3", // Snake
    E_READER_VICK: "e-Reader #4", // Vick
    E_READER_PIG_TWERK: "e-Reader #5", // Pig Twerk
    E_READER_SPADE: "e-Reader #6", // Spade
    E_READER_EREADER_CARD: "e-Reader #7", // EReader Card
}

LookupState = {
    STATE_CUTSCENE: "Loading...",
    STATE_TITLE: "Title Screen",
    STATE_QUICK_SAVE: "Viewing Quick Save",
    STATE_PUZZLE_MENU: "Puzzle Menu",
    STATE_SETTINGS: "Settings",
    STATE_TUTORIAL: "Tutorial",
    STATE_SAVE_WARN: "Unable to Save!",
    STATE_MULTI_SETUP: "Multiplayer Setup",
    STATE_MULTI_MODE: "Multiplayer Mode",
    STATE_COMM_ERROR: "Communication Error!",
    STATE_RANDOM_MENU: "Random Menu",
    STATE_CREDITS: "Viewing Credits",
    STATE_PODIUM: "Podium",
    STATE_LOGO: "Loading...",
    STATE_SAVE_CORRUPT: "Corrupt Save!",
    STATE_EREADER_CONNECT: "E-reader Connect",
    STATE_EREADER_MENU: "E-reader Menu",
    STATE_MULTI_LOBBY: "Multiplayer Lobby",
    STATE_RACE: "Race",
    STATE_RACE_PODIUM: "Race Podium",
}

LookupSize = {
    30: "Small",
    60: "Medium",
    90: "Large",
    120: "Extra Large",
}

rp_sum_puzzles = rp_num(sumAllPuzzles())

// --------------------------------------------------------
// MARK: RICH PRESENCE CONDITIONALS
// 
// --------------------------------------------------------
rich_presence_conditional_display(viewingDemo(),"Viewing Demo")
rich_presence_conditional_display(gameState() == STATE_CUTSCENE,"Loading...")
rich_presence_conditional_display(gameState() == STATE_LOGO,"Loading...")

rich_presence_conditional_display(inPuzzle(), "Solving {0} 🛟{1} ⏰{2} ✏️{3}/210",
    rich_presence_lookup("Puzzle", currentPuzzleAddr(), LookupPuzzle, fallback="Random Puzzle"),
    rp_num(hintsLeft()),
    rich_presence_value("TimLeft", timeLeft(), "SECS"),
    rp_sum_puzzles
)

rich_presence_conditional_display(saveLoaded(),"{0} ✏️{1}/210",
    rich_presence_lookup("State", gameState(), LookupState),
    rp_sum_puzzles
)

rich_presence_display("Loading...")

// --------------------------------------------------------
// MARK: ACHIEVEMENT FUNCTIONS
// 
// --------------------------------------------------------
function achPuzzleDone(addr) => __ornext(inPuzzle() || gameState() == STATE_TUTORIAL) && saveLoaded() &&
    puzzleSolved(addr-0x04800d) == 1 &&
    prev(puzzleSolved(addr-0x04800d)) == 0

function achPuzzleRangeDone(startAddr, amt) => inPuzzle() &&
    measured(sumPuzzleRange(startAddr-0x04800d,amt) == (amt),when=saveLoaded()) &&
    prev(sumPuzzleRange(startAddr-0x04800d,amt)) == (amt - 1)

function achAllPuzzles() => inPuzzle() &&
    measured(sumAllPuzzles() == 210,when=saveLoaded()) &&
    prev(sumAllPuzzles()) == 209

function achRandomPuzzleChallenge(size, hints) => inPuzzle() &&
    isRandomPuzzleNoContinue(currentPuzzleAddr()) &&
    puzzleSize() == size &&
    trigger_when(puzzleComplete()) &&
    hintsLeft() >= hints &&
    noMistakesMade()

// --------------------------------------------------------
// MARK: ACHIEVEMENTS
// 
// --------------------------------------------------------
achs_reg = [
    ["Hay, Good Job!","Complete the tutorial",1,achPuzzleDone(0x0480bc)],
    ["Impeccable Taste","Complete the Franny Answers e-reader puzzle after inputting a code",3,achPuzzleClear(E_READER_CHEESE)],
    ["Small Surprises","Solve a Small Random puzzle without making mistakes, using hints, or quick saving",2,achRandomPuzzleChallenge(30, 1)],
    ["Fox on Fire","Solve a Medium Random puzzle without making mistakes, using hints, or quick saving",3,achRandomPuzzleChallenge(60, 2)],
    ["Marked Peaks","Solve a Large Random puzzle without making mistakes, using hints, or quick saving",5,achRandomPuzzleChallenge(90, 3)],
    ["Living Extra Large","Solve an Extra Large Random puzzle without making mistakes, using hints, or quick saving",10,achRandomPuzzleChallenge(120, 4)],
]

achs_prog = [
    ["So Pretty!","Complete every Art Museum puzzle",5,achPuzzleRangeDone(0x04803d,15)],
    ["Solving Specimens","Complete every Entomology puzzle",5,achPuzzleRangeDone(0x04804c,24)],
    ["Painting by Numbers","Complete every DIY puzzle",5,achPuzzleRangeDone(0x048025,24)],
    ["Fantastic Solutions","Complete every Fantasy puzzle",5,achPuzzleRangeDone(0x04800d,24)],
    ["No Mines Here","Complete every The Nineties puzzle",5,achPuzzleRangeDone(0x04808c,24)],
    ["Museum of Fish","Complete every Taiyaki puzzle",5,achPuzzleRangeDone(0x048074,24)],
    ["See You Next Fishcake!","Complete every Fabulous puzzle",5,achPuzzleRangeDone(0x048064,16)],
    ["Canis Familiaris","Complete every Zoology puzzle",5,achPuzzleRangeDone(0x0480a4,24)],
    ["Back to School","Complete every Classroom puzzle",5,achPuzzleRangeDone(0x0480be,25)],
    ["Too Blind to See It","Complete every Surprise puzzle",3,achPuzzleRangeDone(0x0480d7,9)],
    ["Franny's Favorite","Complete the Title Screen puzzle",3,achPuzzleDone(0x0480bd)],
]

achs_win = [
    ["Pixel Pup","Complete all 210 regular puzzles",25,achAllPuzzles()],
]

achs_missable = [
]

for a in achs_reg ach(a,"")
for a in achs_prog ach(a,"progression")
for a in achs_win ach(a,"win_condition")
for a in achs_missable ach(a,"missable")

// --------------------------------------------------------
// MARK: LEADERBOARDS
// 
// --------------------------------------------------------