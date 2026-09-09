// Keio Flying Squadron
// #ID = 10069

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

function current_state() => word(0x000720)
STATE_TITLE = 0x03
STATE_STAGE_1 = 0x05
STATE_STAGE_2 = 0x06
STATE_STAGE_3 = 0x07
STATE_STAGE_3_BOSS = 0x08
STATE_STAGE_4 = 0x09
STATE_STAGE_5 = 0x0a
STATE_STAGE_6 = 0x0b
STATE_STAGE_7 = 0x0c
STATE_CUTSCENE = 0x1e
STATE_DEMO_1 = 0x35
STATE_DEMO_2 = 0x36
STATE_DEMO_3 = 0x37
STATE_INTRO = 0x38
STATE_LOGO = 0x3b
STATE_SUPER_CATCH = 0x3c

function isDemo() => current_state() >= STATE_DEMO_1 && current_state() <= STATE_DEMO_3
function onTitle() => current_state() == STATE_TITLE
function playingSuperCatch() => current_state() == STATE_SUPER_CATCH

function stateIs(state) => current_state() == state && hasnt_changed(current_state())

function current_stage() => byte(0x00f802)
function current_score() => bcd(dword(0x00f82a)) / 100
function current_difficulty() => byte(0x00f886)

function current_lives() => word(0x00f856)
function starting_lives() => byte(0x00f87e)
function current_continues() => byte(0x00f85a)
function level_select_active() => byte(0x003962)

function scg_score() => word(0x0010b6)
function scg_misses() => word(0x0010b8)

function achSuperCatchGameScore(target) => stateIs(STATE_SUPER_CATCH) &&
                                     scg_score() >= target &&
                                     prev(scg_score()) < target

function life_tracker_1() => word(0x00204e)
function life_tracker_3() => word(0x002384)
function life_tracker_4() => word(0x0050b4)
function life_tracker_5() => word(0x002666)
function life_tracker_7() => word(0x002396)

function achLifeStage1() => stateIs(STATE_STAGE_1) &&
                            current_score() != 0 &&
                            life_tracker_1() == 0x18 &&
                            prev(life_tracker_1()) <= 0x18

function achLifeStage3() => stateIs(STATE_STAGE_3) &&
                            current_score() != 0 &&
                            life_tracker_3() == 0 &&
                            prev(life_tracker_3()) > 0

function achLifeStage4() => stateIs(STATE_STAGE_4) &&
                            current_score() != 0 &&
                            life_tracker_4() == 0x0f &&
                            prev(life_tracker_4()) <= 0x0f

function achLifeStage5() => stateIs(STATE_STAGE_5) &&
                            current_score() != 0 &&
                            life_tracker_5() == 0 &&
                            prev(life_tracker_5()) > 0

function achLifeStage7() => stateIs(STATE_STAGE_7) &&
                            current_score() != 0 &&
                            life_tracker_7() == 0 &&
                            prev(life_tracker_7()) > 0

function enemyIsActive(index) => bit7(0x00ba50 + (0x40 * index) + 0x01) == 1
function enemyHP(index) => word(0x00ba50 + (0x40 * index) + 0x1e)
function enemyID(index) => word(0x00ba50 + (0x40 * index) + 0x02)
function enemyFishInteract(index) => word(0x00ba50 + (0x40 * index) + 0x32)

EnemyRange = range(0,63)

function achLifeStage2() => stateIs(STATE_STAGE_2) &&
                            any_of(EnemyRange, i =>
                                enemyIsActive(i) && 
                                enemyID(i) == 0x23 &&
                                enemyFishInteract(i) == 1 &&
                                prev(enemyFishInteract(i)) == 0
                            )

function achLifeStage6() => stateIs(STATE_STAGE_6) &&
                            any_of(EnemyRange, i =>
                                enemyIsActive(i) && 
                                enemyID(i) == 0x23 &&
                                enemyHP(i) == 0 &&
                                prev(enemyHP(i)) > 0
                            )

// --------------------------------------------------------
// MARK: RP
// 
// --------------------------------------------------------


StageLookup = {
    0: "Stage 1",
    1: "Stage 2",
    2: "Stage 3",
    3: "Stage 3 Boss",
    4: "Stage 4",
    5: "Stage 5",
    6: "Stage 6",
    7: "Stage 7",
    8: "Ending",
}

DifficultyLookup = {
    0: "Easy",
    1: "Normal",
    2: "Hard"
}

LevelSelectLookup = {
    1: " [Level Select]"
}

SCGMissLookup = {
    0: "🐈🐈🐈",
    1: "❌🐈🐈",
    2: "❌❌🐈",
    3: "❌❌❌"
}

SCGLeadZeroLookup = {
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

sLookup = {
    1: "",
}

rich_presence_conditional_display(isDemo(),"Viewing Demo") 

rich_presence_conditional_display(onTitle(),"Title Screen{0}",
    rich_presence_lookup("LevelSelect", level_select_active(), LevelSelectLookup)
)

rich_presence_conditional_display(current_state() == STATE_CUTSCENE,"Viewing Cutscene{0}",
    rich_presence_lookup("LevelSelect", level_select_active(), LevelSelectLookup)
)

rich_presence_conditional_display(playingSuperCatch() && scg_score() == 1000,"SUPER CATCH GAME")

rich_presence_conditional_display(playingSuperCatch(),"SUPER CATCH GAME [{0}] [{3}{2}{1}]",
    rich_presence_lookup("SCGMisses", scg_misses(), SCGMissLookup),
    rich_presence_value("Number", scg_score()),
    rich_presence_lookup("SCGZero", scg_score(), SCGLeadZeroLookup),
    rich_presence_lookup("SCGZero", scg_score() / 10, SCGLeadZeroLookup)
)

rich_presence_conditional_display(current_state() >= STATE_STAGE_1 && current_state() <= STATE_STAGE_7 && current_lives() == 0xffff,"{0} [⚖️{1}] [Score: {2}]{6} Game Over!",
    rich_presence_lookup("Stage", current_stage(), StageLookup),
    rich_presence_lookup("Difficulty", current_difficulty(), DifficultyLookup),
    rich_presence_value("Number", current_score()),
    rich_presence_value("Number", current_lives()),
    rich_presence_value("Number", starting_lives()),
    rich_presence_value("Number", current_continues()),
    rich_presence_lookup("LevelSelect", level_select_active(), LevelSelectLookup)
)

rich_presence_conditional_display(current_state() >= STATE_STAGE_1 && current_state() <= STATE_STAGE_7,"{0} [⚖️{1}] [Score: {2}] [{3} / {4} Lives] [{5} Continue{7}]{6}",
    rich_presence_lookup("Stage", current_stage(), StageLookup),
    rich_presence_lookup("Difficulty", current_difficulty(), DifficultyLookup),
    rich_presence_value("Number", current_score()),
    rich_presence_value("Number", current_lives()),
    rich_presence_value("Number", starting_lives()),
    rich_presence_value("Number", current_continues()),
    rich_presence_lookup("LevelSelect", level_select_active(), LevelSelectLookup),
    rich_presence_lookup("s", current_continues(), sLookup, fallback="s")

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
    ["Super Cat Catcher","Reach 200 points in Super Catch Game",5,achSuperCatchGameScore(200)],
    ["Barrelling Up and Down","Defeat 24 barrel tanukis in Stage 1",3,achLifeStage1()],
    ["To Become a Dragon","Touch the fish on the waterfall in Stage 2",1,achLifeStage2()],
    ["Symbol of Luck","Defeat all the blue daruma dolls in Stage 3",3,achLifeStage3()],
    ["High-Flying Bonus","Destroy 15 huge missiles in Stage 4",3,achLifeStage4()],
    ["Manned Extra","Destroy all the orange turrets in Stage 5",3,achLifeStage5()],
    ["Secret of the Ark","Find a hidden 1-up at the beginning of Stage 6",2,achLifeStage6()],
    ["Close the Gates!","Defeat all the tanukis closing gates in Stage 7",5,achLifeStage7()],
]

for a in achs_reg ach(a,"")


leaderboard(
        title = "Super Catch Game",
        description = "Highest Score",
        start  = playingSuperCatch() &&
                 scg_score() > 0 &&
                 scg_misses() == 3 &&
                 prev(scg_misses()) == 2
                 ,
        cancel = always_false(),
        submit = always_true(),
        value = scg_score(),
        format = "Value",
        lower_is_better = false
    )