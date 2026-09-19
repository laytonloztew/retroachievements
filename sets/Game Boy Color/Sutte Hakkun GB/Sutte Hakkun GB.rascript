// ~Prototype~ Sutte Hakkun GB
// #ID = 15592

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

function current_screen() => byte(0x00c6a4) & 0x3F
SCREEN_TITLE = 0
SCREEN_LEVEL = 1
SCREEN_PAUSED = 2
SCREEN_OPTION = 3
SCREEN_WORLD_CLEAR_1 = 6
SCREEN_WORLD_CLEAR_2 = 7
SCREEN_FILESELECT = 8
SCREEN_WORLDSELECT_CUTSCENE = 9
SCREEN_LEVELCLEAR = 0x10
SCREEN_STAGESELECT = 0x11
SCREEN_DEMO = 0x12
SCREEN_WORLDSELECT = 0x14
SCREEN_HELP1 = 0x15
SCREEN_HELP2 = 0x16
SCREEN_VIEWINGHINT = 0x17
SCREEN_HELPTUTORIAL = 0x18
SCREEN_OPENING = 0x19
SCREEN_COMPLETIONRANK = 0x1a

// $D88F: [8-bit] Current Level
function current_level() => byte(0xD88F)

function current_world() => (current_level() / 10) + 1 
function current_stage() => (current_level() % 10) + 1 

// $D890: [8-bit] Total Clear Time - Milliseconds
function total_clear_time_milliseconds() => byte(0xD890)

// $D891: [8-bit] Total Clear Time - Seconds
function total_clear_time_seconds() => byte(0xD891)

// $D892: [8-bit] Total Clear Time - Minutes
function total_clear_time_minutes() => byte(0xD892)

// $D893: [8-bit] Total Clear Time - Hours
//        < 1 = A Rank
//        < 5 = B Rank
//        >= 5 = C Rank
function total_clear_time_hours() => byte(0xD893)

//function level_status(i) => byte(0xD899 + (i * 4))

function level_status_addr(w,s) => 0xD899 + ((s-1) * 4) + ((w-1) * 40)
function level_status(w,s) => byte(level_status_addr(w,s))
function level_time_ms(w,s) => byte(0xD899 + ((s-1) * 4) + ((w-1) * 40) + 1)
function level_time_sec(w,s) => byte(0xD899 + ((s-1) * 4) + ((w-1) * 40) + 2)
function level_time_min(w,s) => byte(0xD899 + ((s-1) * 4) + ((w-1) * 40) + 3)

function levelBestTime(w,s) => (level_time_min(w,s) * 100 * 60) + (level_time_sec(w,s) * 100) + level_time_ms(w,s) * 10
function levelBestTimeSeconds(w,s) => (level_time_min(w,s) * 60) + level_time_sec(w,s)

function current_level_milliseconds_tens() => byte(0x00c200)
function current_level_milliseconds() => byte(0x00c203)
function current_level_seconds() => byte(0x00c201)
function current_level_minutes() => byte(0x00c202)

function currentlevelTime() => (current_level_minutes() * 100 * 60) + (current_level_seconds() * 100) + current_level_milliseconds_tens() * 10 + current_level_milliseconds()

function inLevel() => __ornext(current_screen() == SCREEN_LEVEL || current_screen() == SCREEN_LEVELCLEAR)

function numLevelsComplete() {
    i = 0
    for w in range(1,10) {
        for s in range(1,10) {
            i = i + bit(0,level_status_addr(w,s))
        }
    }
    return i
}

function isColorAbsorbed() => bit(5,0x00ffa8)
function isBlockAbsorbed() => bit(6,0x00ffa8)

function totalTimeInWorld(w) {
    h = 0
    for s in range(1,10) {
        h = h + levelBestTime(w,s)
    }
    return h
}

function totalTimeInWorldSeconds(w) {
    h = 0
    for s in range(1,10) {
        h = h + levelBestTimeSeconds(w,s)
    }
    return h
}

function totalTime() => sum_of(range(1,10), w => totalTimeInWorld(w))

function worldComplete(w) => sum_of(range(1,10), s => bit(0,level_status_addr(w,s))) == 10

function achWorldComplete(w) => inLevel() && worldComplete(w) && prev(sum_of(range(1,10), s => bit(0,level_status_addr(w,s)))) == 9

function allLevelsComplete() => numLevelsComplete() == 100

function totalHoursBelow(h) => inLevel() && allLevelsComplete() && any_of(range(1,10), w => has_changed(totalTimeInWorld(w))) &&
        totalTime() < h * 600 * 100

function achTotalWorldTimeBelow(w,m,s) => inLevel() && worldComplete(w) && totalTimeInWorldSeconds(w) < ((m * 60) + s) && has_changed(totalTimeInWorld(w))

function startLevelCheckpoint(w,s) => tally(1, current_world() == w && current_stage() == s && prev(current_screen()) == SCREEN_STAGESELECT && current_screen() == SCREEN_LEVEL)

switch_state_addr = 0x00ffb2

COLOR_RED = 0
COLOR_BLUE = 1
COLOR_ORANGE = 2

function levelChallengeLogic(w,s) => startLevelCheckpoint(w,s) &&
        trigger_when(current_screen() == SCREEN_LEVELCLEAR) &&
        never(current_screen() != SCREEN_LEVEL && 
              current_screen() != SCREEN_LEVELCLEAR && 
              current_screen() != SCREEN_PAUSED && 
              current_screen() != SCREEN_VIEWINGHINT && 
              current_screen() != SCREEN_HELP1 && 
              current_screen() != SCREEN_HELP2
        )

function achChallengeLevelSwitchOnlyColor(w,s,c) => levelChallengeLogic(w,s) &&
        never(bit(4+c, switch_state_addr) == 0)
        

function achChallengeLevelNoColor(w,s) => levelChallengeLogic(w,s) &&
        never(isColorAbsorbed() == 1)

function object_addr(i) => 0x00c410 + i
function object_id(i) => byte(object_addr(i) + 0)
function object_y(i) => byte(object_addr(i) + 12)
function object_x(i) => byte(object_addr(i) + 24)
function object_state_addr(i) => object_addr(i) + 36

function object_moved(i) => __ornext(has_changed(object_x(i)) || has_changed(object_y(i)))

function achChallenge6_3_Only2Blocks() => levelChallengeLogic(6,3) && 
    never(tally(3, once(object_moved(1)), once(object_moved(2)), once(object_moved(3))))

function ach(ach, t) {
    achievement(
        title = ach[0],
        points = ach[2],
        description = ach[1],
        trigger = ach[3],
        type=t
    )
}

rp_numlevels = rich_presence_value("Number",numLevelsComplete())

rich_presence_conditional_display(current_screen() == SCREEN_TITLE,"Title Screen")
rich_presence_conditional_display(current_screen() == SCREEN_FILESELECT,"File Select")
rich_presence_conditional_display(current_screen() == SCREEN_OPTION,"Viewing Options")
rich_presence_conditional_display(current_screen() == SCREEN_HELPTUTORIAL,"Viewing Opening")
rich_presence_conditional_display(current_screen() == SCREEN_OPENING,"Viewing Opening")
rich_presence_conditional_display(current_screen() == SCREEN_DEMO,"Viewing Demo")
rich_presence_conditional_display(current_screen() == SCREEN_WORLDSELECT_CUTSCENE,"World Select [{0}/100 Stages Cleared]",rp_numlevels)
rich_presence_conditional_display(current_screen() == SCREEN_WORLDSELECT,"World Select [{0}/100 Stages Cleared]",rp_numlevels)
rich_presence_conditional_display(current_screen() == SCREEN_STAGESELECT,"Stage Select [{0}/100 Stages Cleared]",rp_numlevels)
rich_presence_conditional_display(current_screen() == SCREEN_WORLD_CLEAR_1,"Stage Clear [{0}/100 Stages Cleared]",rp_numlevels)
rich_presence_conditional_display(current_screen() == SCREEN_WORLD_CLEAR_2,"Stage Clear [{0}/100 Stages Cleared]",rp_numlevels)
rich_presence_conditional_display(current_screen() == SCREEN_COMPLETIONRANK,"Viewing Completion Ranking [{0}/100 Stages Cleared]",rp_numlevels)
rich_presence_conditional_display(inLevel() || current_screen() == SCREEN_PAUSED || current_screen() == SCREEN_VIEWINGHINT || current_screen() == SCREEN_HELP1  || current_screen() == SCREEN_HELP2,"Level {0}-{1} ⏰{2} [{3}/100 Stages Cleared]",
    rich_presence_value("Number",current_world()),
    rich_presence_value("Number",current_stage()),
    rich_presence_value("Time", currentlevelTime(), "MILLISECS"),
    rp_numlevels
)

rich_presence_display("Loading...")

achs_reg = [
    ["Dreams of Clear Clouds","Complete every stage in World 10",10,achWorldComplete(10)],
    ["Hakkun Master","Achieve an A Completion Rank with a total clear time of less than 1 hour",25,totalHoursBelow(1)],
    ["Blue Is Not My Color","Clear Level 1-6 without absorbing color",2,achChallengeLevelNoColor(1,6)],
    ["Orange? Not Interested","Clear Level 2-2 without absorbing color",2,achChallengeLevelNoColor(2,2)],
    ["Watch Your Head","Clear Level 3-10 without using the switch",3,achChallengeLevelSwitchOnlyColor(3,10,COLOR_ORANGE)],
    ["Close to the Edge","Clear Level 6-3 without moving all 3 blocks",4,achChallenge6_3_Only2Blocks()],
    ["All I Need Is Blue (and Red)","Clear Level 7-7 without using the switch",4,achChallengeLevelSwitchOnlyColor(7,7,COLOR_BLUE)],

    //["_w1_time","Clear every stage in World 1 with a total clear time of less than 1:30",5,achTotalWorldTimeBelow(1,1,30)],
    //["_w2_time","Clear every stage in World 2 with a total clear time of less than 2:30",5,achTotalWorldTimeBelow(2,2,30)],
    //["_w3_time","Clear every stage in World 3 with a total clear time of less than 3:30",10,achTotalWorldTimeBelow(3,3,30)],
    //["_w4_time","Clear every stage in World 3 with a total clear time of less than 4:00",10,achTotalWorldTimeBelow(4,4,00)],
    //["_w5_time","Clear every stage in World 3 with a total clear time of less than 5:00",10,achTotalWorldTimeBelow(5,5,00)],
    //["_w6_time","Clear every stage in World 3 with a total clear time of less than 6:00",10,achTotalWorldTimeBelow(6,6,00)],
    //["_w7_time","Clear every stage in World 3 with a total clear time of less than 8:00",10,achTotalWorldTimeBelow(7,8,00)],
    //["_w8_time","Clear every stage in World 3 with a total clear time of less than 16:00",10,achTotalWorldTimeBelow(8,16,00)],
    //["_w9_time","Clear every stage in World 3 with a total clear time of less than 15:00",10,achTotalWorldTimeBelow(9,15,00)],
]

achs_prog = [
    ["Bright Days","Complete every stage in World 1",3,achWorldComplete(1)],
    ["Ruined Setting","Complete every stage in World 2",3,achWorldComplete(2)],
    ["Bridging Gaps","Complete every stage in World 3",5,achWorldComplete(3)],
    ["Going Overboard","Complete every stage in World 4",5,achWorldComplete(4)],
    ["Puzzling Pipes","Complete every stage in World 5",5,achWorldComplete(5)],
    ["Sharp Thinking","Complete every stage in World 6",5,achWorldComplete(6)],
    ["Blocks of Bamboo","Complete every stage in World 7",5,achWorldComplete(7)],
    ["Dry Deduction","Complete every stage in World 8",5,achWorldComplete(8)],
]

achs_win = [
    ["Magical Feeling","Complete every stage in World 9",10,achWorldComplete(9)],
]

achs_missable = [
]

for a in achs_reg ach(a,"")
for a in achs_prog ach(a,"progression")
for a in achs_win ach(a,"win_condition")
for a in achs_missable ach(a,"missable")

for w in range(1,10) {
    for s in range(1,10) {
        leaderboard(
            title = format("Level {0}-{1}",w,s),
            description = "Fastest Time",
            start  = inLevel() && has_changed(levelBestTime(w,s)),
            //current_screen() == SCREEN_LEVELCLEAR && prev(current_screen()) == SCREEN_LEVEL && current_level() == ((w-1) * 10) + (s-1),
            cancel = always_false(),
            submit = always_true(),
            value  = measured(levelBestTime(w,s)),
            format = "MILLISECS",
            lower_is_better=true
        )
    }
}

leaderboard(
    title = "All Levels",
    description = "Fastest Total Time",
    start  = inLevel() && any_of(range(1,10), w => has_changed(totalTimeInWorld(w))) && allLevelsComplete(),
    cancel = always_false(),
    submit = always_true(),
    value  = measured(totalTime()),
    format = "MILLISECS",
    lower_is_better=true
)

