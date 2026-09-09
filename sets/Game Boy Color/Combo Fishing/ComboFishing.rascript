// ~Homebrew~ Combo Fishing
// #ID = 31934

function has_increased(addr) => addr > prev(addr)
function has_decreased(addr) => addr < prev(addr)
function has_changed(addr) => addr != prev(addr)
function hasnt_changed(addr) => addr == prev(addr)
function if_else(p, t, f) { if (p) { return t } else return f }
function is_even(v) => v % 2 == 0

function bitflag(addr,f) => bit(f%8, addr + f/8)

function ach(ach, t) {
    achievement(
        title = ach[0],
        points = ach[2],
        description = ach[1],
        trigger = ach[3],
        type=t
    )
}

function var(f) => word(f)

CURRENT_SCENE = 0xC526
VAR_QUEST1 = 0xCB99
VAR_VARIABLE_1 = 0xCB9B
VAR_VARIABLE_2 = 0xCB9D
VAR_VARIABLE_4 = 0xCB9F
VAR_VARIABLE_6 = 0xCBA1
VAR_VARIABLE_7 = 0xCBA3
VAR_VARIABLE_9 = 0xCBA5
VAR_VARIABLE_10 = 0xCBA7
VAR_VARIABLE_12 = 0xCBA9
VAR_VARIABLE_13 = 0xCBAB
VAR_VARIABLE_14 = 0xCBAD
VAR_VARIABLE_15 = 0xCBAF
VAR_VARIABLE_16 = 0xCBB1
VAR_ISWALL = 0xCBB3
VAR_LIFETWO = 0xCBB5
VAR_LOOP_INDEX = 0xCBB7
VAR_LOOTCOLLECTED = 0xCBB9
VAR_SPAWNOBJ = 0xCBBB
VAR_BRACKENSPAWNED = 0xCBBD
VAR_LOOTLOCATION = 0xCBBF
VAR_ISPRESENT = 0xCBC1
VAR_ISDUCK = 0xCBC3
VAR_GAMESTART = 0xCBC5
VAR_HIGHSCORE = 0xCBC7
VAR_SPACEONE = 0xCBC9
VAR_SPACETWO = 0xCBCB
VAR_SPACETHREE = 0xCBCD
VAR_SPACEFOUR = 0xCBCF
VAR_SPACEFIVE = 0xCBD1
VAR_SPACESIX = 0xCBD3
VAR_SPACESEVEN = 0xCBD5
VAR_SPACEEIGHT = 0xCBD7
VAR_ANIMLOOP = 0xCBD9
VAR_MUSICCHOICE = 0xCBDB
VAR_FISHSPOTANIMLOOP = 0xCBDD
VAR_FISHHOOKED = 0xCBDF
VAR_FISHTIMER = 0xCBE1
VAR_ARROWONE = 0xCBE3
VAR_FISHCAUGHT = 0xCBE5
VAR_BUTTONSPRESSED = 0xCBE7
VAR_FISHRARITY = 0xCBE9
VAR_SWORDFISHCAUGHT = 0xCBEB
VAR_SEABASSCAUGHT = 0xCBED
VAR_SQUIDCAUGHT = 0xCBEF
VAR_COORD1 = 0xCBF1
VAR_COORD2 = 0xCBF3
VAR_COORD3 = 0xCBF5
VAR_COORD4 = 0xCBF7
VAR_COORD5 = 0xCBF9
VAR_COORD6 = 0xCBFB
VAR_COORD7 = 0xCBFD
VAR_COORD8 = 0xCBFF
VAR_COORD9 = 0xCC01
VAR_FAILEDSEQ = 0xCC03
VAR_ISFISHING = 0xCC05
VAR_LASTCAUGHT = 0xCC07
VAR_BOOTCAUGHT = 0xCC09
VAR_BUTTERFLYFISHCAUGHT = 0xCC0B
VAR_EELCAUGHT = 0xCC0D
VAR_JELLYFISHCAUGHT = 0xCC0F
VAR_LOACHCAUGHT = 0xCC11
VAR_FIREFISHCAUGHT = 0xCC13
VAR_WRASSECAUGHT = 0xCC15
VAR_COLELACANTHCAUGHT = 0xCC17
VAR_GOBYCAUGHT = 0xCC19
VAR_HAMMERHEADCAUGHT = 0xCC1B
VAR_GREATWHITECAUGHT = 0xCC1D
VAR_SEABUTTCAUGHT = 0xCC1F
VAR_SEAHORSECAUGHT = 0xCC21
VAR_FISHCOORD1 = 0xCC23
VAR_FISHCOORD2 = 0xCC25
VAR_FISHCOORD3 = 0xCC27
VAR_FISHCOORD4 = 0xCC29
VAR_ROCKCOUNTER = 0xCC2B
VAR_TOTALLOOT = 0xCC2D
VAR_MCOORD1 = 0xCC2F
VAR_MCOORD2 = 0xCC31
VAR_MCOORD3 = 0xCC33
VAR_MCOORD4 = 0xCC35
VAR_WINDOWBUBBLE1 = 0xCC37
VAR_WINDOWBUBBLE2 = 0xCC39
VAR_MCOORD5 = 0xCC3B
VAR_MCOORD6 = 0xCC3D
VAR_MCOORD7 = 0xCC3F
VAR_MCOORD8 = 0xCC41
VAR_MCOORD9_0 = 0xCC43
VAR_MCOORD10_0 = 0xCC45
VAR_MCOORD11 = 0xCC47
VAR_MCOORD12 = 0xCC49
VAR_MCOORD13 = 0xCC4B
VAR_MCOORD14 = 0xCC4D
VAR_MCOORD15 = 0xCC4F
VAR_MCOORD16 = 0xCC51
VAR_MCOORD17 = 0xCC53
VAR_MCOORD18 = 0xCC55
VAR_MCOORD19 = 0xCC57
VAR_MCOORD20 = 0xCC59
VAR_MCOORD21 = 0xCC5B
VAR_MCOORD22 = 0xCC5D
VAR_MCOORD23 = 0xCC5F
VAR_MCOORD24 = 0xCC61
VAR_MCOORD25 = 0xCC63
VAR_MCOORD26 = 0xCC65
VAR_MCOORD27 = 0xCC67
VAR_MCOORD28 = 0xCC69
VAR_MCOORD29_0 = 0xCC6B
VAR_MCOORD30 = 0xCC6D
VAR_MCOORD31 = 0xCC6F
VAR_MCOORD32 = 0xCC71
VAR_MCOORD33 = 0xCC73
VAR_MCOORD34 = 0xCC75
VAR_MCOORD35 = 0xCC77
VAR_MCOORD36 = 0xCC79
VAR_MCOORD37 = 0xCC7B
VAR_MCOORD38 = 0xCC7D
VAR_MCOORD39 = 0xCC7F
VAR_MCOORD40 = 0xCC81
VAR_MCOORD41 = 0xCC83
VAR_MCOORD42 = 0xCC85
VAR_MCOORD43 = 0xCC87
VAR_MCOORD44 = 0xCC89
VAR_MCOORD45 = 0xCC8B
VAR_MCOORD46 = 0xCC8D
VAR_MCOORD47 = 0xCC8F
VAR_MCOORD48 = 0xCC91
VAR_MCOORD49 = 0xCC93
VAR_MCOORD50 = 0xCC95
VAR_MCOORD51 = 0xCC97
VAR_MCOORD52 = 0xCC99
VAR_MCOORD53 = 0xCC9B
VAR_MCOORD54 = 0xCC9D
VAR_MCOORD55 = 0xCC9F
VAR_MCOORD56 = 0xCCA1
VAR_MCOORD57 = 0xCCA3
VAR_MCOORD58 = 0xCCA5
VAR_MCOORD59 = 0xCCA7
VAR_MCOORD60 = 0xCCA9
VAR_MCOORD61 = 0xCCAB
VAR_MCOORD62 = 0xCCAD
VAR_MCOORD63 = 0xCCAF
VAR_MCOORD64 = 0xCCB1
VAR_TOTALSWORDFISH = 0xCCB3
VAR_TOTALBASS = 0xCCB5
VAR_TOTALSQUID = 0xCCB7
VAR_TOTALBOOT = 0xCCB9
VAR_TOTALBUTTERFLYFISH = 0xCCBB
VAR_TOTALEEL = 0xCCBD
VAR_TOTALGOBY = 0xCCBF
VAR_TOTALWRASSE = 0xCCC1
VAR_TOTALSEAHORSE = 0xCCC3
VAR_TOTALLOACH = 0xCCC5
VAR_TOTALJELLYFISH = 0xCCC7
VAR_TOTALFIREFISH = 0xCCC9
VAR_TOTALCOLCEANTH = 0xCCCB
VAR_TOTALGREATWHITESHARK = 0xCCCD
VAR_TOTALHAMMERHEAD = 0xCCCF
VAR_TOTALSEABUTT = 0xCCD1
VAR_FROGTOKENS = 0xCCD3
VAR_RADIOBOUGHT = 0xCCD5
VAR_VOLLEYBALLBOUGHT = 0xCCD7
VAR_HATBOUGHT = 0xCCD9
VAR_FROGTOKENSEARNED = 0xCCDB
VAR_CHINCHOUSENDING = 0xCCDD
VAR_FROGTOKENLUCK = 0xCCDF
VAR_BONUSMODECHECK = 0xCCE1
VAR_ISBONUSFISHING = 0xCCE3
VAR_BONUSFISHCAUGHT = 0xCCE5
VAR_BONUSSCORE = 0xCCE7
VAR_BONUSFAILEDCATCH_0 = 0xCCE9
VAR_ISBONUSNORMAL = 0xCCEB
VAR_BONUSHARDHISCORE = 0xCCED
VAR_BONUSEXPERTHISCORE = 0xCCEF
VAR_BONUSNORMALHISCORE = 0xCCF1
VAR_BONUSTOKENSEARNED = 0xCCF3
VAR_BONUSHEALTH = 0xCCF5
VAR_AREABOUGHT = 0xCCF7
VAR_CREATURERESCUED = 0xCCF9
VAR_FALLINGARROWSHISCORE = 0xCCFB
VAR_PROJECTILESPEED = 0xCCFD
VAR_BALLSPAWN = 0xCCFF
VAR_LOOTBUGKICKBALLVISIBLE = 0xCD01
VAR_GOLDCOINUSED = 0xCD03
VAR_BALL_GOAL = 0xCD05
VAR_S0_LOCAL_0 = 0xCD07
VAR_TEMP_0 = 0xCD09
VAR_S1_MENU_CHOICE = 0xCD0B
VAR_S3_MENU_CHOICE = 0xCD0D
VAR_S7A7_DEFEATED = 0xCD0F
VAR_S7A7_DEFEATED_1 = 0xCD11
VAR_S7A7_DEFEATED_2 = 0xCD13
VAR_S7A3_SPOKEN_TO_GARDENER = 0xCD15
VAR_S7T1_LOCAL_0 = 0xCD17
VAR_S9_MENU_OPTION = 0xCD19
VAR_S9A7_SAVE_CHOICE = 0xCD1B
VAR_S9A7_SAVECHOICE2 = 0xCD1D
VAR_S10A10_LOCAL_1 = 0xCD1F
VAR_S10_LOCAL_0 = 0xCD21
VAR_S15_MENU_OPTION = 0xCD23
VAR_S15A10_SAVE_CHOICE = 0xCD25
VAR_S15A10_SAVECHOICE2 = 0xCD27
VAR_S16_LOCAL_0 = 0xCD29
VAR_S17_MENU_OPTION = 0xCD2B
VAR_S18_LOCAL_0 = 0xCD2D
VAR_S20_LOCAL_0 = 0xCD2F
VAR_S20A2_SAVE_CHOICE = 0xCD31
VAR_S20A2_SAVECHOICE2 = 0xCD33
VAR_S20A3_LOCAL_4 = 0xCD35
VAR_S20A4_LOCAL_4 = 0xCD37
VAR_S20A4_LOCAL_3 = 0xCD39
VAR_S20A4_LOCAL_0 = 0xCD3B
VAR_S20A4_LOCAL_1 = 0xCD3D
VAR_S20A5_LOCAL_4 = 0xCD3F
VAR_S20A5_LOCAL_3 = 0xCD41
VAR_S20A5_LOCAL_0 = 0xCD43
VAR_S20A5_LOCAL_1 = 0xCD45
VAR_S21A0_LOCAL_1 = 0xCD47
VAR_S23_LOCAL_0 = 0xCD49
VAR_S24A24_LOCAL_1 = 0xCD4B
VAR_S26_MENU_CHOICE = 0xCD4D
VAR_S26A0_LOCAL_0 = 0xCD4F
VAR_S26A0_LOCAL_1 = 0xCD51
VAR_S27_LOCAL_0 = 0xCD53
VAR_S28_LOCAL_0 = 0xCD55
VAR_S28A0_LOCAL_0 = 0xCD57
VAR_S28A0_LOCAL_1 = 0xCD59
VAR_S29_LOCAL_0 = 0xCD5B
VAR_S30_LOCAL_0 = 0xCD5D
VAR_S30_LOCAL_2 = 0xCD5F
VAR_S30_LOCAL_3 = 0xCD61
VAR_S31_MENU_CHOICE = 0xCD63
VAR_S33_LOCAL_0 = 0xCD65
VAR_S33A0_LOCAL_0 = 0xCD67
VAR_S33A5_LOCAL_0 = 0xCD69
VAR_S33A5_LOCAL_2 = 0xCD6B
VAR_S33A8_LOCAL_0 = 0xCD6D
VAR_S33A8_LOCAL_2 = 0xCD6F
VAR_S33A10_LOCAL_0 = 0xCD71
VAR_S33A10_LOCAL_2 = 0xCD73
VAR_S34_LOCAL_3 = 0xCD75
VAR_S36_LOCAL_3 = 0xCD77
VAR_S37_LOCAL_0 = 0xCD79
VAR_S37A3_LOCAL_0 = 0xCD7B
VAR_S37A3_LOCAL_2 = 0xCD7D
VAR_S37A6_LOCAL_0 = 0xCD7F
VAR_S37A6_LOCAL_2 = 0xCD81
VAR_S37A8_LOCAL_0 = 0xCD83
VAR_S37A8_LOCAL_2 = 0xCD85
VAR_S37A9_LOCAL_0 = 0xCD87
VAR_S39_LOCAL_0 = 0xCD89
VAR_S39A0_LOCAL_0 = 0xCD8B
VAR_S39A2_LOCAL_0 = 0xCD8D
VAR_S39A2_LOCAL_2 = 0xCD8F
VAR_S39A5_LOCAL_0 = 0xCD91
VAR_S39A5_LOCAL_2 = 0xCD93
VAR_S39A7_LOCAL_0 = 0xCD95
VAR_S39A7_LOCAL_2 = 0xCD97
VAR_S40A5_LOCAL_1 = 0xCD99

VARS_FISH_CAUGHT = [
    VAR_SWORDFISHCAUGHT,
    VAR_SEABASSCAUGHT,
    VAR_SQUIDCAUGHT,
    VAR_BOOTCAUGHT,
    VAR_BUTTERFLYFISHCAUGHT,
    VAR_EELCAUGHT,
    VAR_JELLYFISHCAUGHT,
    VAR_LOACHCAUGHT,
    VAR_FIREFISHCAUGHT,
    VAR_WRASSECAUGHT,
    VAR_COLELACANTHCAUGHT,
    VAR_GOBYCAUGHT,
    VAR_HAMMERHEADCAUGHT,
    VAR_GREATWHITECAUGHT,
    VAR_SEABUTTCAUGHT,
    VAR_SEAHORSECAUGHT
]

VARS_FISH_TOTALS = [
    VAR_TOTALSWORDFISH,
    VAR_TOTALBASS,
    VAR_TOTALSQUID,
    VAR_TOTALBOOT,
    VAR_TOTALBUTTERFLYFISH,
    VAR_TOTALEEL,
    VAR_TOTALGOBY,
    VAR_TOTALWRASSE,
    VAR_TOTALSEAHORSE,
    VAR_TOTALLOACH,
    VAR_TOTALJELLYFISH,
    VAR_TOTALFIREFISH,
    VAR_TOTALCOLCEANTH,
    VAR_TOTALGREATWHITESHARK,
    VAR_TOTALHAMMERHEAD,
    VAR_TOTALSEABUTT
]

function sumFishCaught() => sum_of(VARS_FISH_CAUGHT, f => word(f))
function totalFishCaught() => sum_of(VARS_FISH_TOTALS, f => word(f))

SCENE_BEACH = 0x5b2b1d
SCENE_WEST_MUSEUM_PREPAYMENT = 0x631a1d
SCENE_WEST_MUSEUM = 0x5ffb1d
SCENE_DEVELOPER_ROOM = 0x644f1d
SCENE_GAMEDEMOLAND = 0x66ff1d
SCENE_OUTSIDE_MUSUEM = 0x5ba11d
SCENE_MUSEUM_COMPLETE = 0x5c901d
SCENE_VICTORY_AREA = 0x5ccb1d
SCENE_CONGRATZ = 0x63551d
SCENE_WEST_MUSEUM_POSTGAME = 0x64141d
SCENE_SHOPAREA = 0x5e001d
SCENE_CREDITS = 0x5f011d
SCENE_SHOPAREA_LIST = 0x5ec61d
SCENE_SHOPAREA_CATCH = 0x5f3c1d
SCENE_LOOT_LUNA = 0x66311d
SCENE_LOOT_LUNA_100 = 0x59b91d
SCENE_LOOT_EASTEREGG = 0x5a5c1d

function currentScene() => tbyte(CURRENT_SCENE)
function prevScene() => prev(currentScene())

function atShop() => __ornext(
    currentScene() == SCENE_SHOPAREA ||
    currentScene() == SCENE_SHOPAREA_LIST
)

function isPlayingLethalRunner() => __ornext(
    currentScene() == 0x58381d ||
    currentScene() == 0x59311d
)

function isPetLuna() => __ornext(
    currentScene() == SCENE_LOOT_LUNA_100 ||
    currentScene() == SCENE_LOOT_LUNA
)

function playerTileX() => byte(0x00c0bb)
function playerTileY() => byte(0x00c0bd)
function playerDirection() => byte(0x00c0be) 

function achVarSetToOneInArea(v, a) => currentScene() == a &&
                                    var(v) == 1 && 
                                    prev(var(v)) == 0

function achVarIncreaseInArea(v, a) => currentScene() == a &&
                                    has_increased(var(v))

function achFishCaught(v) => achVarIncreaseInArea(v, SCENE_BEACH)

function achGoalLootBug() => achVarSetToOneInArea(VAR_BALL_GOAL, SCENE_DEVELOPER_ROOM) &&
                             var(VAR_LOOTBUGKICKBALLVISIBLE) == 1

function achAreaChange(from, to) => prevScene() == from && 
                                    currentScene() == to &&
                                    playerTileX() != 0

function achRescueCreature() => currentScene() == SCENE_CONGRATZ &&
                                var(VAR_CREATURERESCUED) == 1 &&
                                prev(var(VAR_CREATURERESCUED)) == 0
                
function achDemoLand() => __ornext(prevScene() == SCENE_WEST_MUSEUM ||
                                prevScene() == SCENE_WEST_MUSEUM_POSTGAME) && 
                            currentScene() == SCENE_GAMEDEMOLAND &&
                            playerTileX() != 0 &&
                            playerTileY() != 0

function achRock() => prev(var(VAR_ROCKCOUNTER)) == 5 && 
                        var(VAR_ROCKCOUNTER) == 6 && 
                        var(VAR_HATBOUGHT) == 1 && 
                        currentScene() == SCENE_BEACH

function achPurchaseShop(v) => atShop() &&
                               var(v) == 1 && 
                               prev(var(v)) == 0

function achFishService() => var(VAR_LASTCAUGHT) != 0 &&
                            prev(currentScene()) == SCENE_SHOPAREA_CATCH &&
                            atShop()

function lethalLoot() => var(VAR_LOOTCOLLECTED)
function lethalDied() => prev(var(VAR_LIFETWO)) == 7 && 
                         var(VAR_LIFETWO) == 8

function achLethalRunnerLoot(amt) => isPlayingLethalRunner() &&
                                  lethalDied() && 
                                  lethalLoot() >= amt

function achPetCat() => isPetLuna() &&
                        playerTileX() > 4 && playerTileX() < 9 &&
                        bit2(0x00C155) < prev(bit2(0x00C155))

function bonusScore() => var(VAR_BONUSSCORE)
function timedChallengedDifficulty() => bit(0, VAR_ISBONUSNORMAL) + bit(1, VAR_ISBONUSNORMAL) + bit(1, VAR_ISBONUSNORMAL)
function bonusGameEnded() => prev(bonusScore()) == 26555 && bonusScore() < 26555

function achTimeChallengeScore(diff, target) => currentScene() == 0x610b1d && timedChallengedDifficulty() == diff && bonusGameEnded() &&
        bonusScore() >= target

function achFallingArrowsScore(target) => currentScene() == 0x625b1d && bonusGameEnded() && bonusScore() >= target
                            

achs_reg = [
    ["Not Punny, Didn't Laugh", "Catch a Seabass at the beach",2,achFishCaught(VAR_TOTALBASS)],
    ["Took a Stab at It",       "Catch a Swordfish at the beach",2,achFishCaught(VAR_TOTALSWORDFISH)],
    ["If It Fits",              "Catch a Boot at the beach",2,achFishCaught(VAR_TOTALBOOT)],
    ["Swim Like a Butterfly",   "Catch a Butterfly Fish at the beach",2,achFishCaught(VAR_TOTALBUTTERFLYFISH)],
    ["Three of Hearts",         "Catch a Squid at the beach",2,achFishCaught(VAR_TOTALSQUID)],
    ["Eels Again!",             "Catch an Eel at the beach",3,achFishCaught(VAR_TOTALEEL)],
    ["Citation Needed",         "Catch a Jellyfish at the beach",2,achFishCaught(VAR_TOTALJELLYFISH)],
    ["Low Achievement Earned",  "Catch a Loach at the beach",2,achFishCaught(VAR_TOTALLOACH)],
    ["Burning Catch",           "Catch a Firefish at the beach",2,achFishCaught(VAR_TOTALFIREFISH)],
    ["Sea Wrastlin'",           "Catch a Wrasse at the beach",2,achFishCaught(VAR_TOTALWRASSE)],
    ["Cole, a Fossil!",         "Catch a Coelacanth at the beach",3,achFishCaught(VAR_TOTALCOLCEANTH)],
    ["Go, Bees!",               "Catch a Goby at the beach",2,achFishCaught(VAR_TOTALGOBY)],
    ["Hammer on the Head",      "Catch a Hammerhead Shark at the beach",3,achFishCaught(VAR_TOTALHAMMERHEAD)],
    ["Shark Week Star",         "Catch a Great White Shark at the beach",3,achFishCaught(VAR_TOTALGREATWHITESHARK)],
    ["Good Things Come to Those Who Bait","Catch a Sea Butterfly at the beach",3,achFishCaught(VAR_TOTALSEABUTT)],
    ["See, No Horses Here",     "Catch a Seahorse at the beach",3,achFishCaught(VAR_TOTALSEAHORSE)],
    ["Cozy Jams","Purchase the radio from the shop",3,achPurchaseShop(VAR_RADIOBOUGHT)],
    ["Friendly Purchase","Purchase a hat from the shop",2,achPurchaseShop(VAR_HATBOUGHT)],
    ["Maybe Next Time","Purchase the Volleyball Court from the shop",5,achPurchaseShop(VAR_VOLLEYBALLBOUGHT)],
    ["Finder's Fee","Use the Fish Catching Service to catch a fish",5,achFishService()],
    ["You Rock, Man","Have your persistent coolness acknowledged by a rock",3,achRock()],
    ["Lethal Looter","Collect 50 loot or more in Lethal Runner",5,achLethalRunnerLoot(50)],
    ["Company Quota","Collect 100 loot or more in Lethal Runner",10,achLethalRunnerLoot(100)],
    ["Backroom Boogie","Find the easter egg in Lethal Runner",5,achAreaChange(SCENE_LOOT_LUNA_100, SCENE_LOOT_EASTEREGG)],
    ["You Can Pet the Cat","Pet Luna",1,achPetCat()],
    ["World's Best Catcher","Catch every fish and enter the Victory Area",10,achAreaChange(SCENE_MUSEUM_COMPLETE, SCENE_VICTORY_AREA)],

    ["New Horizons", "Clear the rocks at the Lake",2,achVarSetToOneInArea(VAR_AREABOUGHT, SCENE_WEST_MUSEUM_PREPAYMENT)],
    ["Good Catchin'","Complete Timed Challenge on Normal with a score of at least 26",3,achTimeChallengeScore(0,26)],
    ["Challenging Times","Complete Timed Challenge on Hard with a score of at least 16",4,achTimeChallengeScore(1,16)],
    ["Combo Challenger","Complete Timed Challenge on Expert with a score of at least 8",5,achTimeChallengeScore(2,8)],
    ["Cast Cast Reelvolution","Complete Falling Arrows with a score of at least 170",5,achFallingArrowsScore(170)],
    ["Through the Trees","Reach Game Demo Land",3,achDemoLand()],
    ["Just For a Minute","Reach the Developer Room",5,achAreaChange(SCENE_OUTSIDE_MUSUEM, SCENE_DEVELOPER_ROOM)],
    ["Fun With Friends", "Get a goal in the Developer Room while the Loot Bug is present",3,achGoalLootBug()],
]

achs_win = [
    ["Thanks For Playing!","Rescue the creature in the lake",10,achRescueCreature()]
]

achs_missable = [
]

for a in achs_reg ach(a,"")
for a in achs_win ach(a,"win_condition")
for a in achs_missable ach(a,"missable")

AreaLookup = {
    SCENE_BEACH: "Beach",
    0x5d061d: "Main Menu",
    SCENE_SHOPAREA: "Shop Area",
    SCENE_SHOPAREA_LIST: "Shop Area",
    SCENE_SHOPAREA_CATCH: "Shop Area",
    0x5e8b1d: "Volleyball Court",
    0x58381d: "Lethal Runner", // Game
    0x59311d: "Lethal Runner", // Caught
    0x58731d: "Lethal Runner", // Game Over
    0x673a1d: "Lethal Runner", // Title
    0x64c51d: "Lethal Runner", // Credits
    SCENE_LOOT_LUNA: "Pet Luna", //Luna
    SCENE_LOOT_LUNA_100: "Pet Luna", //Luna (100)
    SCENE_LOOT_EASTEREGG: "Lethal Runner (Easter Egg)", //Easter Egg
    0x57a11d: "Museum",
    SCENE_MUSEUM_COMPLETE: "Museum", // Complete
    SCENE_WEST_MUSEUM_PREPAYMENT: "Lake",
    SCENE_WEST_MUSEUM: "Lake",
    SCENE_WEST_MUSEUM_POSTGAME: "Lake", // Post-game
    SCENE_OUTSIDE_MUSUEM: "Outside Museum",
    SCENE_VICTORY_AREA: "Victory Area",
    SCENE_GAMEDEMOLAND: "Game Demo Land",
    0x67751d: "Game Demo Land", // House
    0x666c1d: "Game Demo Land",
    0x680b1d: "Game Demo Land", // Puzzle
    0x65001d: "Game Demo Land", // Puzzle 2 
    SCENE_DEVELOPER_ROOM: "Developer Room", // Puzzle 2 
    0x61b31d: "Rescuing Creature",
    SCENE_CONGRATZ: "Congratz",
    0x653b1d: "Viewing Fish Encyclopedia",
    0x65761d: "Viewing Fish Encyclopedia",
    SCENE_CREDITS: "Credits",
    0x625b1d: "Falling Arrows",
    0x610b1d: "Timed Challenge",
}

RadioLookup = {
    0: "•",
}

VolleyballLookup = {
    0: "•",
}

HatLookup = {
    0: "•",
}

rp_scene = rich_presence_lookup("Area", currentScene(), AreaLookup)
rp_tokens = rich_presence_value("Number", var(VAR_FROGTOKENS))
rp_radio = rich_presence_lookup("Radio", var(VAR_RADIOBOUGHT), RadioLookup, fallback="📻")
rp_hat = rich_presence_lookup("Hat", var(VAR_HATBOUGHT), HatLookup, fallback="🎩")
rp_volley = rich_presence_lookup("Volleyball", var(VAR_VOLLEYBALLBOUGHT), VolleyballLookup, fallback="🏐")

rich_presence_conditional_display(currentScene() == 0x5d061d, "Main Menu")

// LETHAL RUNNER
rich_presence_conditional_display(isPlayingLethalRunner(), "🏃Playing Lethal Runner [🎁{1}] 🐟{2}/16 🐸{3} [{4}{5}{6}] 🐟Total {7}",
    rich_presence_lookup("LeadZero", lethalLoot(), LeadZeroLookup),
    rich_presence_value("Number", lethalLoot()),
    rich_presence_value("Number", sumFishCaught()),
    rp_tokens,
    rp_radio,
    rp_hat,
    rp_volley,
    rich_presence_value("Number", totalFishCaught())
)



// CREDITS
rich_presence_conditional_display(currentScene() == SCENE_CREDITS, "Viewing Credits")

// OTHER MAPS
rich_presence_conditional_display(currentScene() != 0, "🗺️{0} 🐟{1}/16 🐸{2} [{3}{4}{5}] 🐟Total {6}",
    rp_scene,
    rich_presence_value("Number", sumFishCaught()),
    rp_tokens,
    rp_radio,
    rp_hat,
    rp_volley,
    rich_presence_value("Number", totalFishCaught())
)

rich_presence_display("Loading...")


leaderboard(
    title = "Lethal Runner [Old]",
    description = "Most Loot",
    start  = isPlayingLethalRunner() && lethalDied() && var(VAR_LOOTCOLLECTED) > 0,
    cancel = always_false(),
    submit = always_true(),
    value  = measured(lethalLoot()),
    id = 121881,
    format = "VALUE"
)

leaderboard(
    title = "Lethal Runner",
    description = "Most Loot",
    start  = isPlayingLethalRunner() && lethalDied() && var(VAR_LOOTCOLLECTED) > 0,
    cancel = always_false(),
    submit = always_true(),
    value  = measured(lethalLoot()),
    format = "VALUE"
)

leaderboard(
    title = "Timed Challenge (Normal)",
    description = "Highest Score",
    start  = currentScene() == 0x610b1d && timedChallengedDifficulty() == 0 && bonusGameEnded(),
    cancel = always_false(),
    submit = always_true(),
    value  = measured(bonusScore()),
    format = "VALUE"
)

leaderboard(
    title = "Timed Challenge (Hard)",
    description = "Highest Score",
    start  = currentScene() == 0x610b1d && timedChallengedDifficulty() == 1 && bonusGameEnded(),
    cancel = always_false(),
    submit = always_true(),
    value  = measured(bonusScore()),
    format = "VALUE"
)

leaderboard(
    title = "Timed Challenge (Expert)",
    description = "Highest Score",
    start  = currentScene() == 0x610b1d && timedChallengedDifficulty() == 2 && bonusGameEnded(),
    cancel = always_false(),
    submit = always_true(),
    value  = measured(bonusScore()),
    format = "VALUE"
)

leaderboard(
    title = "Falling Arrows",
    description = "Highest Score",
    start  = currentScene() == 0x625b1d && bonusGameEnded(),
    cancel = always_false(),
    submit = always_true(),
    value  = measured(bonusScore()),
    format = "VALUE"
)