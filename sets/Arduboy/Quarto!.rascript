// Quarto!
// #ID = 35173

// --------------------------------------------------------
// MARK: HELPERS
// 
// --------------------------------------------------------
function has_increased(addr) => addr > prev(addr)
function has_decreased(addr) => addr < prev(addr)
function has_changed(addr) => addr != prev(addr)
function hasnt_changed(addr) => addr == prev(addr)
function if_else(p, t, f) { if (p) { return t } else return f }

// --------------------------------------------------------
// MARK: DATA
// 
// --------------------------------------------------------

// --------------------------------------------------------
// MARK: FUNCTIONS
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

function achWinMatch(mode,level) => inMatch() && matchEnded() && playerWonMode(mode) && 
                                    gameMode == mode &&
                                    cpuLevel >= level

function achWinMatchChallenge(mode,level) => never(!inMatch()) &&
                                             never(gameMode != mode) &&
                                             never(cpuLevel != level) &&
                                             trigger_when(matchEnded() && playerWonMode(mode)) &&  
                                             once(currentTurn == 0) && never(prev(inMatch()) && currentTurn < prev(currentTurn)) && 
                                             never(hintsEnabled())

function achWinMatch2x2() => inMatch() &&  
                             variantEnabled() &&
                             matchEnded() &&
                             playerWon() && 
                             wonBy2x2() && 
                             gameMode <= 1

function matchEnded() => matchState == STATE_OVER && has_changed(matchState)
function playerWon() => currentTurn % 2 == gameMode && currentTurn < 16
function playerWonMode(mode) => currentTurn % 2 == mode && currentTurn < 16
function inMatch() => currentScreen == SCREEN_MATCH
function variantEnabled() => setting2x2Rule == 1
function hintsEnabled() => settingHints == 1

function wonBy2x2() =>
    any_of(range(0,11), i =>
        any_of([1,2,4,8], attr =>
            piecesSameAttribute(i,i+1,attr) &&
            piecesSameAttribute(i,i+4,attr) &&
            piecesSameAttribute(i,i+5,attr)
        )
    )

function piece(i) => byte(boardStateStartAddr + i)
function piecesSameColor(a,b) => piece(a) & 8 == piece(b) & 8
function piecesSameShape(a,b) => piece(a) & 4 == piece(b) & 4
function piecesSameSize(a,b)  => piece(a) & 2 == piece(b) & 2
function piecesSameSolid(a,b) => piece(a) & 1 == piece(b) & 1
function piecesSameAttribute(p1,p2,attr) => piece(p1) != 0xff && piece(p2) != 0xff && piece(p1) & attr == piece(p2) & attr

gameMode = byte(0x0186)
GAME_MODE_YOU_FIRST = 0
GAME_MODE_CPU_FIRST = 1
GAME_MODE_2PLAYERS  = 2

// $0187: [8-bit] Current CPU Level {cpuLevel}
cpuLevel = byte(0x0187)

// $0188: [8-bit] Max Level Unlocked (default=3) {maxLevel}
maxLevel = byte(0x188)

SETTINGS_ADDR = 0x0189
setting2x2Rule = bit(0,SETTINGS_ADDR)
settingHints = bit(3,SETTINGS_ADDR)

playFrames = dword(0x18a)

playCount = word(0x18e)

currentScreen = word(0x192)
SCREEN_INIT         = 0
SCREEN_TITLE        = 1
SCREEN_LEVEL        = 2
SCREEN_SETTINGS     = 3
SCREEN_INSTRUCTIONS = 4
SCREEN_CREDIT       = 5
SCREEN_MATCH        = 6

matchState = word(0x01cc)
STATE_INIT       = 0
STATE_PRE_PLACE  = 1
STATE_PLACING    = 2
STATE_POST_PLACE = 3
STATE_CHOOSING   = 4
STATE_MENU       = 5
STATE_OVER       = 6
STATE_LEAVE      = 7

// $01D0: [16 Bytes] Board State
boardStateStartAddr = 0x1d0

currentTurn = byte(0x1e0)

// --------------------------------------------------------
// MARK: RICH PRESENCE LOOKUPS
// 
// --------------------------------------------------------
ModeLookup = {
    GAME_MODE_YOU_FIRST: "You First",
    GAME_MODE_CPU_FIRST: "CPU First",
    GAME_MODE_2PLAYERS: "2 Players"
}

hintLookup = {
    1: " [Hints Enabled]"
}

varientLookup = {
    1: " [2x2 Enabled]"
}

// --------------------------------------------------------
// MARK: RICH PRESENCE CONDITIONALS
// 
// --------------------------------------------------------
rich_presence_conditional_display(currentScreen == SCREEN_TITLE, "Title Screen{2}{3} [Play Count: {0}] [Play Time: {1}]",
    rich_presence_value("Number", playCount),
    rich_presence_value("Frames", playFrames, "FRAMES"),
    rich_presence_lookup("Hint", settingHints, hintLookup, fallback=""),
    rich_presence_lookup("Varient", setting2x2Rule, varientLookup, fallback="")
)
rich_presence_conditional_display(currentScreen == SCREEN_CREDIT, "Viewing Credits{2}{3} [Play Count: {0}] [Play Time: {1}]",
    rich_presence_value("Number", playCount),
    rich_presence_value("Frames", playFrames, "FRAMES"),
    rich_presence_lookup("Hint", settingHints, hintLookup, fallback=""),
    rich_presence_lookup("Varient", setting2x2Rule, varientLookup, fallback="")
)
rich_presence_conditional_display(currentScreen == SCREEN_INSTRUCTIONS, "Viewing Instructions{2}{3} [Play Count: {0}] [Play Time: {1}]",
    rich_presence_value("Number", playCount),
    rich_presence_value("Frames", playFrames, "FRAMES"),
    rich_presence_lookup("Hint", settingHints, hintLookup, fallback=""),
    rich_presence_lookup("Varient", setting2x2Rule, varientLookup, fallback="")
)
rich_presence_conditional_display(currentScreen == SCREEN_LEVEL, "Choosing Difficulty Level{2}{3} [Play Count: {0}] [Play Time: {1}]",
    rich_presence_value("Number", playCount),
    rich_presence_value("Frames", playFrames, "FRAMES"),
    rich_presence_lookup("Hint", settingHints, hintLookup, fallback=""),
    rich_presence_lookup("Varient", setting2x2Rule, varientLookup, fallback="")
)
rich_presence_conditional_display(currentScreen == SCREEN_SETTINGS, "Changing Settings{2}{3} [Play Count: {0}] [Play Time: {1}]",
    rich_presence_value("Number", playCount),
    rich_presence_value("Frames", playFrames, "FRAMES"),
    rich_presence_lookup("Hint", settingHints, hintLookup, fallback=""),
    rich_presence_lookup("Varient", setting2x2Rule, varientLookup, fallback="")
)
rich_presence_conditional_display(currentScreen == SCREEN_MATCH, "{0} - Level {1} [Turn: {2}]{3}{4} [Play Count: {5}] [Play Time: {6}]",
    rich_presence_lookup("Mode", gameMode, ModeLookup, fallback="????"),
    rich_presence_value("Number", cpuLevel),
    rich_presence_value("Number", currentTurn),
    rich_presence_lookup("Hint", settingHints, hintLookup, fallback=""),
    rich_presence_lookup("Varient", setting2x2Rule, varientLookup, fallback=""),
    rich_presence_value("Number", playCount),
    rich_presence_value("Frames", playFrames, "FRAMES")

)
rich_presence_display("Loading...")


// --------------------------------------------------------
// MARK: ACHIEVEMENTS
// 
// --------------------------------------------------------

achs_reg = [
    ["First Line","Win against a Level 1 or above CPU on You First",1,achWinMatch(GAME_MODE_YOU_FIRST,1)],
    ["Board Sense","Win against a Level 2 or above CPU on You First",2,achWinMatch(GAME_MODE_YOU_FIRST,2)],
    ["Fourth Dimension","Win against a Level 4 CPU on You First with hints off and without cancelling moves",5,achWinMatchChallenge(GAME_MODE_YOU_FIRST,4)],
    ["Supreme Strategist","Win against a Level 5 CPU on You First with hints off and without cancelling moves",10,achWinMatchChallenge(GAME_MODE_YOU_FIRST,5)],
    ["Common Ground","Win against a Level 1 or above CPU on CPU First",1,achWinMatch(GAME_MODE_CPU_FIRST,1)],
    ["Aligned Attributes","Win against a Level 2 or above CPU on CPU First",2,achWinMatch(GAME_MODE_CPU_FIRST,2)],
    ["Unbroken Sequence","Win against a Level 4 CPU on CPU First with hints off and without cancelling moves",5,achWinMatchChallenge(GAME_MODE_CPU_FIRST,4)],
    ["Pattern Master","Win against a Level 5 CPU on CPU First with hints off and without cancelling moves",10,achWinMatchChallenge(GAME_MODE_CPU_FIRST,5)],
    ["Alternative Rule","Win against a CPU by placing 4 matching pieces in a 2x2 square with approve 2x2 on",3,achWinMatch2x2()],
]

achs_missable = []
achs_prog = []
achs_win = [
    ["Impartial Game","Win against a Level 3 or above CPU on You First",3,achWinMatch(GAME_MODE_YOU_FIRST,3)], 
    ["Type Advantage","Win against a Level 3 or above CPU on CPU First",3,achWinMatch(GAME_MODE_CPU_FIRST,3)], 
]

for a in achs_reg ach(a,"")
for a in achs_missable ach(a,"missable")
for a in achs_prog ach(a,"progression")
for a in achs_win ach(a,"win_condition")