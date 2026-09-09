// Chindouchuu!! Paul no Daibouken
// #ID = 34726
// 珍道中!!ポールの大冒険

// Drop Shadow 0.0 2.5 -45 0.30

// translation
// Calibri size 23 (varies)
//  red  255 0 0
//  blue 66 99 255
// outline  3  0
// drop shadow  0.0 4.0 -45 1.00  89,89,89

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

function state_ptr() => dword_be(0x0017dec8)
function state_ascii() => ptr(state_ptr(),[0x00, 0x00, 0x00, 0x00], acc_addr)

function isLoaded() => state_ptr() != 0 &&
                       ptr(state_ptr(),[0x00]) != 0 &&
                       ptr(state_ptr(),[0x00, 0x00]) != 0 &&
                       ptr(state_ptr(),[0x00, 0x00, 0x00]) != 0 &&
                       ptr(state_ptr(),[0x00, 0x00, 0x00, 0x00]) != 0
function currentStateIs(s) => isLoaded() && ascii_string_equals(state_ascii(), s)

function neta_script_ptr() => dword_be(0x00223128)
function neta_ascii() => ptr(neta_script_ptr(),[0x34], acc_addr)
function netaStart(s) => neta_script_ptr() != 0 && has_changed(neta_script_ptr()) && ascii_string_equals(neta_ascii(), s)

function player_state_ptr() => dword_be(0x00183500)
function playerCanShootStatus() => ptr(player_state_ptr(), [0x7c])
function playerButtonFlags() => ptr(player_state_ptr(), [0x77], acc_addr)
function playerShootButtonStatus() => bit(3,playerButtonFlags())
function playerDirectionFacing() => ptr(player_state_ptr(), [0x4c])
FACING_LEFT = 0
FACING_RIGHT = 1

function ProcGame_Movie() => ptr(state_ptr(), [0x10DC])
function ProcGame_Timer() => ptr(state_ptr(), [0x10b4])

function currentStage() => dword_be(0x0017def0)
function currentPlaythrough() => dword_be(0x0017def4)
function score() => dword_be(0x0017defc)
function life() => dword_be(0x0017df00)
function power() => dword_be(0x0017df04)
function ProcGameState() => dword_be(0x0063e99c)
function playerStatus() => dword_be(0x0017df08)

function cameraX() => dword_be(0x0063d96c)
function cameraY() => dword_be(0x0063d970)


galleryFlagsStart = 0x0017df54
function galleryFlag(f) => bit(f%8, galleryFlagsStart + f/8)
function levelFlag(f) => bit((f + 1)%8, galleryFlagsStart + 0x10 + (f + 1)/8)

function achLevelComplete(level_id) => (currentStateIs("ProcGame") || currentStateIs("ProcStarting")) &&
                                       has_increased(levelFlag(level_id))

function achLevelCompleteA(level_id) => (currentStateIs("ProcGame") || currentStateIs("ProcStarting")) &&
                                       has_increased(levelFlag(level_id + 24))

function achJokeSeen(f) => currentStateIs("ProcGame") &&
                           has_increased(galleryFlag(f))

function achJokeSeenStr(s) => currentStateIs("ProcGame") && 
                              netaStart(s) &&
                              ProcGame_Movie() == 0

function achJokeAlien() => currentStateIs("ProcGame") && 
                              neta_script_ptr() != 0 && ascii_string_equals(neta_ascii(), "6m_12_1") &&
                              ProcGame_Movie() == 0 &&
                              has_decreased(life())

JOKES_RANGE = range(1,100)

function sumJokesSeen() => sum_of(JOKES_RANGE, j => galleryFlag(j))

function achNumJokesSeen(amt) => isLoaded() && 
                              sumJokesSeen() == amt &&
                              prev(sumJokesSeen()) < amt &&
                              prev(sumJokesSeen()) > amt - 3

PLAYTHROUGH_A = 1

function achLevelCompleteAnytime(stage, stage_next, p) => (currentStateIs("ProcGame") || currentStateIs("ProcStoryDemo")) &&
                                 currentStage() == stage_next &&
                                 prev(currentStage() == stage) &&
                                 ProcGameState() == 0x0e &&
                                 currentPlaythrough() == p

function achLevelCompleteAnytimeLastLevel(stage, stage_next, p) => (currentStateIs("ProcGame")  || currentStateIs("ProcStoryDemo")) &&
                                 currentStage() == stage_next &&
                                 prev(currentStage() == stage) &&
                                 ProcGameState() == 0x0e &&
                                 once(currentStateIs("ProcGame") && currentStage() == stage && ProcGameState() == 0x09 &&
                                 currentPlaythrough() == p) &&
                                 never(currentStateIs("ProcTitle"))

                                 

function achBigStage21A() => currentStateIs("ProcGame") &&
                                 currentStage() == 5 &&
                                 currentPlaythrough() == PLAYTHROUGH_A &&
                                 playerStatus() == 0x08 &&
                                 trigger_when(ProcGameState() == 0x09) &&
                                 trigger_when(has_changed(ProcGameState()))
                   
function achStage31AShootless() => never(!currentStateIs("ProcGame")) &&
                                 never(currentStage() != 9) &&
                                 never(currentPlaythrough() != PLAYTHROUGH_A) &&
                                 once(cameraX() == 0x24) &&
                                 never(has_decreased(life())) &&
                                 never(cameraX() != 0x24 && playerShootButtonStatus() == 1) &&
                                 trigger_when(ProcGameState() == 0x09) &&
                                 trigger_when(has_changed(ProcGameState()))

function achStage41AFaceRight() => never(!currentStateIs("ProcGame")) &&
                                 never(currentStage() != 0x0d) &&
                                 never(currentPlaythrough() != PLAYTHROUGH_A) &&
                                 once(cameraX() == 0x24) &&
                                 never(has_decreased(life())) &&
                                 never(playerDirectionFacing() == FACING_LEFT) &&
                                 trigger_when(cameraX() >= 8900)

// --------------------------------------------------------
// MARK: RP
// 
// --------------------------------------------------------
StageLookup = {
    0: "Practice Stage",
    1: "Stage 1-1",
    2: "Stage 1-2",
    3: "Stage 1-3",
    4: "???",
    5: "Stage 2-1",
    6: "Stage 2-2",
    7: "Stage 2-3",
    8: "???",
    9: "Stage 3-1",
    0x0a: "Stage 3-2",
    0x0b: "Stage 3-3",
    0x0c: "Stage 3-4",
    0x0d: "Stage 4-1",
    0x0e: "Stage 4-2",
    0x0f: "Stage 4-3",
    0x10: "???",
    0x11: "Stage 5-1",
    0x12: "Stage 5-2",
    0x13: "Stage 5-3",
    0x14: "Stage 5-4",
    0x15: "Stage 6-1",
    0x16: "Stage 6-2",
    0x17: "Stage 6-3",
    0x18: "???",
    0x19: "Stage 1-1"
}

PlaythroughLookup = {
    1: "A"
}


rich_presence_conditional_display(currentStateIs("ProcOpening"),"Viewing Opening")
rich_presence_conditional_display(currentStateIs("ProcEnding"),"Viewing Ending")
rich_presence_conditional_display(currentStateIs("ProcTitle"),"Title Screen")
rich_presence_conditional_display(currentStateIs("ProcOption"),"Viewing Options")
rich_presence_conditional_display(currentStateIs("ProcMovView"),"Viewing Gallery")
rich_presence_conditional_display(currentStateIs("ProcStarting"),"Starting Level...")

// Level - Movie
rich_presence_conditional_display(currentStateIs("ProcGame") && ProcGame_Movie() != 0,"Viewing Movie {0}",
    rich_presence_value("Number", ProcGame_Movie())
)

// Level
rich_presence_conditional_display(currentStateIs("ProcGame") && currentStage() == 0x19,"{0} [Score: {2}] [Life: {3}] [Neta: {4}]",
    rich_presence_lookup("Stage", currentStage(), StageLookup),
    rich_presence_lookup("Playthrough", currentPlaythrough(), PlaythroughLookup),
    rich_presence_value("Number", score()),
    rich_presence_value("Number", life()),
    rich_presence_value("Number", sumJokesSeen())
)


rich_presence_conditional_display(currentStateIs("ProcGame"),"{0}{1} [Score: {2}] [Life: {3}] [Neta: {4}]",
    rich_presence_lookup("Stage", currentStage(), StageLookup),
    rich_presence_lookup("Playthrough", currentPlaythrough(), PlaythroughLookup),
    rich_presence_value("Number", score()),
    rich_presence_value("Number", life()),
    rich_presence_value("Number", sumJokesSeen())
)

rich_presence_conditional_display(currentStateIs("ProcStoryDemo"),"Viewing Cutscene")
//rich_presence_conditional_display(currentStateIs("ProcStrapReminder"),"Never forget the wrist strap")
//rich_presence_conditional_display(currentStateIs("ProcSegaLogo"),"SEGA")
//rich_presence_conditional_display(currentStateIs("ProcFileCheck"),"Start New File?")

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
    ["It's Hard! My Face Hurts!","Find a hard apple in Stage 1-1",1,achJokeSeenStr("1a_01_1")],

    ["Too Big! Too Big!","Grow big in Stage 1-2",1,achJokeSeenStr("1a_09_3")],
    ["What Will the Neighbors Think?","Enter a filthy pipe in Stage 1-2",1,achJokeSeenStr("1a_11_1")],
    ["What's Exploding?!","Collect a banana in Stage 1-2",1,achJokeSeenStr("1a_13_1")],
    ["Too Many Apples...","Puke in Stage 1-2A",2,achJokeSeenStr("1a_a_1")],

    ["Whoa, I'm a Total Badass!","Grow big in Stage 2-1",2,achJokeSeenStr("2b_03_2")],
    ["Is This the Star's Big Entrance?!","Make a flashy entrance in Stage 2-1",2,achJokeSeenStr("2b_05_1")],
    ["We're Rich!","Find a lot of money in Stage 2-1",1,achJokeSeenStr("2b_06_1")],
    ["Why Am I Suddenly So Sloppy?","Become a line drawing in Stage 2-1",1,achJokeSeenStr("2b_15_1")],
    
    ["I Just Learned Multiplication Tables?!","Level up in Stage 2-2",2,achJokeSeenStr("2b_13_2")],
    ["One Apple Too Many","Gain weight in Stage 2-2A",3,achJokeSeenStr("2b_a_1")],
    ["That's It?! I'm Barely Any Taller!","Grow slightly taller in Stage 3-1",2,achJokeSeenStr("3c_02_2")],
    ["You Got Here Fast!","Get a premature 1-up in Stage 3-1",1,achJokeSeenStr("3c_05_1")],
    ["Maybe If I Input That Code...","Discover Superman in Stage 3-1",2,achJokeSeenStr("3c_06_1")],

    ["This Reminds Me of a Carbonated Beverage...","Find a 7-up in Stage 3-3",2,achJokeSeenStr("3c_08_1")],
    ["Gives a Whole New Meaning to Death Star","Get impaled by a star in Stage 3-3",1,achJokeSeenStr("3c_11_1")],
    ["Bikini Sniper","Get shot at by an unexpected enemy in Stage 3-3A",2,achJokeSeenStr("3c_a_1")],

    //["__56","",1,achJokeSeen(56)],
    ["Wait, That Actually Killed Me?","Freeze to death in Stage 4-1",1,achJokeSeenStr("4s_16_2")],

    ["That's Not a Proper Snowman!","Find a daruma doll in Stage 4-1A",2,achJokeSeenStr("4s_a_1")],
    ["I Mean, It Is a Mushroom After All","Grow big in Stage 5-1",2,achJokeSeenStr("5j_01_2")],
    ["I Feel a Sense of Guilt...","Take money from the offering box in Stage 5-1",2,achJokeSeenStr("5j_02_1")],

    ["Why Can I Pick This Up?! Where Do I Put It?!","Collect a Tokyo Tower",2,achJokeSeenStr("5j_05_1")],
    ["Who Are You People?!","Recruit some party members in Stage 5-1",2,achJokeSeenStr("5j_16_1")],
    ["No, No... It's a Misunderstanding!","Collect panties in Stage 5-3",2,achJokeSeenStr("5j_09_1")],
    ["An Apple That Instantly Renders All Previous Effort Useless","Earn 100,000,000 points in Stage 5-3",2,achJokeSeenStr("5j_12_1")],

    ["It's Only Worth One?!","Collect a huge apple in Stage 5-1A",1,achJokeSeenStr("5j_a_2")],

    ["I Don't Suppose We Can Go Back Now...","Destroy Earth in Stage 6-1",2,achJokeSeenStr("6m_02_1")],
    ["I'm Going Super, I'm Sayin'!","Unlock a power up in Stage 6-1",3,achJokeSeenStr("6m_03_1")],

    ["Do I Really Need to Write This Down?","Find hidden words after getting a game over in Stage 6-1",1,achJokeSeenStr("6m_15_1")],
    ["Maybe I Shouldn't Have Eaten That...","Have an alien burst out of your chest in Stage 6-2",2,achJokeAlien()],
    ["Gonna Take You Back to the Past","Take a shortcut in Stage 6-2",3,achJokeSeenStr("6m_13_1")],
    ["This Joke Makes More Sense in Japanese","Find a sitting man constellation in Stage 6-1A",3,achJokeSeenStr("6m_a_1")],

    ["You're Kidding Me!","See all 100 gags",25,achNumJokesSeen(100)],

    ["I'd Be Lion If I Said This Was Easy","Complete World 1A",5,achLevelCompleteAnytime(3,5,1)],
    ["Swallow Your Pride, and Everything Else","Complete World 2A",5,achLevelCompleteAnytime(7,9,1)],
    ["Full Frontal Assault","Complete World 3A",10,achLevelCompleteAnytime(0xc,0xd,1)],
    ["It Was a Bloodbath, for Them","Complete World 4A",10,achLevelCompleteAnytime(0xf,0x11,1)],
    ["Birds Are Singing, Flowers Are Blooming...","Complete World 5A",25,achLevelCompleteAnytime(0x14,0x15,1)],
    ["Impractical Fusion","Complete World 6A",25,achLevelCompleteAnytimeLastLevel(0x17,0x19,1)],


    //scrapped //["That's Not a Real Challenge!","Complete Stage 3-2 without taking damage, collecting apples, swimming, touching blocks, using springs, shooting turtles, collecting mushrooms, powering up, gaining lives, looking at enemies, double jumping, levelling up, or finding aliens",1,achInsaneChallenge()],
    ["Wish I Was Shorter","Reach the end of Stage 2-1A in a powered up form",5,achBigStage21A()],
    ["Nice Day at the Beach","Complete Stage 3-1A without dying or firing bullets",10,achStage31AShootless()],
    ["Sliding into Adventure","Complete Stage 4-1A without dying or facing left",10,achStage41AFaceRight()],
]

achs_prog = [
    //["Just Getting Started","Complete the Practice Level",1,achLevelComplete(0)],
    ["Are You Okay, My Deer?","Complete World 1",3,achLevelCompleteAnytime(3,5,0)],
    ["You Sure Got Fat...","Complete World 2",3,achLevelCompleteAnytime(7,9,0)],
    ["Have You Been Lifting Weights?","Complete World 3",5,achLevelCompleteAnytime(0xc,0xd,0)],
    ["Something Is Fishy About This...","Complete World 4",5,achLevelCompleteAnytime(0xf,0x11,0)],
    ["I'm Sort of Scared to Touch You","Complete World 5",10,achLevelCompleteAnytime(0x14,0x15,0)],
]

achs_win = [
    ["Happily Ever After","Complete World 6",10,achLevelCompleteAnytimeLastLevel(0x17,0x19,0)],
]

for a in achs_reg ach(a,"")
for a in achs_prog ach(a,"progression")
for a in achs_win ach(a,"win_condition")


leaderboard(
    title = "Game",
    description = "Highest Score",
    start = currentStateIs("ProcGame") &&
                                 currentStage() == 0x17 &&
                                 currentPlaythrough() != PLAYTHROUGH_A &&
                                 ProcGameState() == 0x09 &&
                                 has_changed(ProcGameState()),
    cancel = always_false(),
    submit = always_true(),
    value = measured(score()),
    format = "VALUE"
)

leaderboard(
    title = "Game A",
    description = "Highest Score",
    start = currentStateIs("ProcGame") &&
                                 currentStage() == 0x17 &&
                                 currentPlaythrough() == PLAYTHROUGH_A &&
                                 ProcGameState() == 0x09 &&
                                 has_changed(ProcGameState()),
    cancel = always_false(),
    submit = always_true(),
    value = measured(score()),
    format = "VALUE"
)