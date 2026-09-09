// Tomena Sanner
// #ID = 36138

// EU is -0x700, but shouldn't be supported?

// dance_#_#.txt files are for the goal dances

// drop shadow  0.0 3.0 0.40

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

function paused() => bit(0,0x27da43)
function isTurbo() => bit(5,0x27da43) == 1
function endless() => bit(1,0x27da43)
function isEndless() => endless() == 1
function numPlayers() => dword_be(0x27da44)

function gameState() => dword_be(0x27da9c)
STATE_NONE = 0
STATE_STRAP = 1
STATE_LOGO = 2
STATE_SAVE = 3
STATE_TITLE = 4
STATE_GAME = 5
STATE_ERR = 6

function score() => dword_be(0x27dac8)
function coins() => dword_be(0x27dad4)
function combo() => dword_be(0x27dae0)
function maxCombo() => dword_be(0x0027dae4)
function specials() => dword_be(0x27daec)
function time() => dword_be(0x27daf4)
function total_score() => dword_be(0x294a18)
function resultState() => dword_be(0x294a1c)
function jumpCounter() => dword_be(0x294c40)
function totalGreats() => dword_be(0x003b9980)
function totalCoins() => dword_be(0x003b9984)

function levelWorld() => dword_be(0x0027da54)
function levelStage() => dword_be(0x0027da58)

function levelState1() => dword_be(0x0027daa0)
function levelState2() => dword_be(0x0027dabc)

function startLevel() => levelState1() == 3 && prev(levelState1() == 2)
function goalLevel() => levelState2() == 4 && prev(levelState2()) == 1 && levelState1() == 3
//function finishLevel() => levelState2() == 0x0a && prev(levelState2()) == 9 && levelState1() == 3
function finishLevelResults() => (resultState() == 0x09 || resultState() == 12) && prev(resultState()) == 8 && levelState1() == 3 && levelState2() == 0x0a
function enteringSecret() => levelState2() == 1 && prev(levelState2()) == 2 && levelState1() == 3

function achLevelSecret(world, stage) => gameState() == STATE_GAME &&
                                         levelWorld() == world &&
                                         levelStage() == stage &&
                                         enteringSecret()

function achCompleteLevel(world, stage) => gameState() == STATE_GAME &&
                                           levelWorld() == world &&
                                           levelStage() == stage &&
                                           !isTurbo() &&
                                           goalLevel()

function achCompleteLevelTurbo(world, stage) => gameState() == STATE_GAME &&
                                           levelWorld() == world &&
                                           levelStage() == stage &&
                                           isTurbo() &&
                                           goalLevel()

function achCompleteEndlessAny() => gameState() == STATE_GAME &&
                                    levelWorld() == 2 &&
                                    levelStage() == 2 &&
                                    isEndless() &&
                                    goalLevel()

function achSpecialsReachedInLevel(world, stage, sp) =>
                                    measured(
                                        specials() == sp, 
                                        when=gameState() == STATE_GAME &&
                                            levelWorld() == world &&
                                            levelStage() == stage &&
                                            levelState1() < 0x05 &&
                                            levelState1() > 0x02 &&
                                            levelState2() < 0x04
                                    ) &&
                                    prev(specials()) == sp - 1 &&
                                    numPlayers() == 1

function achCoinsReachedInLevel(world, stage, sp) => gameState() == STATE_GAME &&
                                    levelWorld() == world &&
                                    levelStage() == stage &&
                                    levelState1() < 0x05 &&
                                    levelState1() > 0x02 &&
                                    levelState2() < 0x04 &&
                                    coins() == sp &&
                                    prev(coins()) == sp - 1 &&
                                    numPlayers() == 1

function achCoinsReachedInLevelNoSecret(world, stage, sp) => gameState() == STATE_GAME &&
                                    levelWorld() == world &&
                                    levelStage() == stage &&
                                    levelState1() < 0x05 &&
                                    levelState1() > 0x02 &&
                                    levelState2() < 0x04 &&
                                    trigger_when(coins() == sp) &&
                                    trigger_when(prev(coins()) == sp - 1) &&
                                    numPlayers() == 1 &&
                                    once(startLevel()) &&
                                    never(enteringSecret())

function achComboReached(c) => gameState() == STATE_GAME &&
                              levelState1() < 0x05 &&
                              levelState1() > 0x02 &&
                              levelState2() < 0x0a &&
                              maxCombo() == c &&
                              prev(maxCombo()) == c - 1

levelsCompleteStart = 0x3b992e
function levelFlag(f) => bit((f + 1)%8, levelsCompleteStart + (f + 1)/8) //unused

MultiModeLookup = {
    2: "VS Mode",
    3: "3P Mode",
    4: "4P Mode",
}

ResultStateLookup = {
    0x09: " (Results)",
    0x0a: " (Results)",
    0x0b: " (Results)",
    0x10: " (Results)",
    0x11: " (Results)",
    0x12: " (Results)",
}

EndlessLookup = {
    1: " (Endless)"
}

PauseLookup = {
    1: "▌▌"
}

rich_presence_conditional_display(gameState() == STATE_TITLE, "Title Screen [Total | Greats: {0}, Coins: {1}]",
    rich_presence_value("Number", totalGreats()),
    rich_presence_value("Number", totalCoins())
)

rich_presence_conditional_display(gameState() == STATE_GAME && numPlayers() > 1, "{4}{0} in {6}-{7}{8} [Score: {1}] [Combo: {2}] [Specials: {3}/7] [Total | Greats: {9}, Coins: {10}]",
    rich_presence_lookup("MultiMode", numPlayers(), MultiModeLookup),
    rich_presence_value("Number", score()),
    rich_presence_value("Number", combo()),
    rich_presence_value("Number", specials()),
    rich_presence_lookup("Paused", paused(), PauseLookup),
    rich_presence_lookup("ResultState", resultState(), ResultStateLookup),
    rich_presence_value("Number", levelWorld()+1),
    rich_presence_value("Number", levelStage()+1),
    rich_presence_lookup("Endless", endless(), EndlessLookup),
    rich_presence_value("Number", totalGreats()),
    rich_presence_value("Number", totalCoins())
)

rich_presence_conditional_display(gameState() == STATE_GAME && isTurbo(), "{4}Turbo Mode in {6}-{7}{8} [Score: {1}] [Combo: {2}] [Specials: {3}/7] [Total | Greats: {9}, Coins: {10}]",
    rich_presence_value("Number", numPlayers()),
    rich_presence_value("Number", score()),
    rich_presence_value("Number", combo()),
    rich_presence_value("Number", specials()),
    rich_presence_lookup("Paused", paused(), PauseLookup),
    rich_presence_lookup("ResultState", resultState(), ResultStateLookup),
    rich_presence_value("Number", levelWorld()+1),
    rich_presence_value("Number", levelStage()+1),
    rich_presence_lookup("Endless", endless(), EndlessLookup),
    rich_presence_value("Number", totalGreats()),
    rich_presence_value("Number", totalCoins())
)

rich_presence_conditional_display(gameState() == STATE_GAME, "{4}Normal Mode in {6}-{7}{8} [Score: {1}] [Combo: {2}] [Specials: {3}/7] [Total | Greats: {9}, Coins: {10}]",
    rich_presence_value("Number", numPlayers()),
    rich_presence_value("Number", score()),
    rich_presence_value("Number", combo()),
    rich_presence_value("Number", specials()),
    rich_presence_lookup("Paused", paused(), PauseLookup),
    rich_presence_lookup("ResultState", resultState(), ResultStateLookup),
    rich_presence_value("Number", levelWorld()+1),
    rich_presence_value("Number", levelStage()+1),
    rich_presence_lookup("Endless", endless(), EndlessLookup),
    rich_presence_value("Number", totalGreats()),
    rich_presence_value("Number", totalCoins())
)

rich_presence_conditional_display(gameState() == STATE_ERR, "ERR")
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

// --------------------------------------------------------
// MARK: ACHIEVEMENTS
// 
// --------------------------------------------------------
achs_reg = [
    ["Fever on a Saturday Night","Beat 1-1 on Turbo mode",5,achCompleteLevelTurbo(0, 0)],
    ["Interesting Maneuver, Need I Say More","Beat 1-2 on Turbo mode",5,achCompleteLevelTurbo(0, 1)],
    ["In a Galaxy Far, Far Away","Beat 1-3 on Turbo mode",5,achCompleteLevelTurbo(0, 2)],
    ["Once Upon a Time in Shaolin","Beat 2-1 on Turbo mode",5,achCompleteLevelTurbo(1, 0)],
    ["I Sprang with the Quickness, like Lightning","Beat 2-2 on Turbo mode",5,achCompleteLevelTurbo(1, 1)],
    ["Larger than Life, Just like My Hair","Beat 2-3 on Turbo mode",5,achCompleteLevelTurbo(1, 2)],
    ["Man Cannot Slay the Beast That Is Gravity","Beat 3-1 on Turbo mode",10,achCompleteLevelTurbo(2, 0)],
    ["Rough Rider, No You Don't Want Nada","Beat 3-2 on Turbo mode",10,achCompleteLevelTurbo(2, 1)],
    ["Run like You-Know-What!","Beat 3-3 on Turbo mode",10,achCompleteLevelTurbo(2, 2)],

    ["Call Me Mr. Domino, No One Can Stop Me","Beat every level in Endless on Normal or Turbo mode",10,achCompleteEndlessAny()],

    ["It's a Coin Heaven","Find a hidden area in 1-1",3,achLevelSecret(0, 0)],
    ["Clouded Detour","Find a hidden area in 1-2",3,achLevelSecret(0, 1)],
    ["Martian Madness","Find a hidden area in 1-3",3,achLevelSecret(0, 2)],
    ["Like a Breeze","Find a hidden area in 2-1",3,achLevelSecret(1, 0)],
    ["Funky Fresh Beats","Find a hidden area in 2-2",3,achLevelSecret(1, 1)],
    ["Hidden in the City","Find a hidden area in 2-3",3,achLevelSecret(1, 2)],
    ["Mile High Club","Find a hidden area in 3-1",3,achLevelSecret(2, 0)],
    ["A-Stone-a-Shin' Moves","Find a hidden area in 3-2",3,achLevelSecret(2, 1)],
    ["Center of the Earth","Find a hidden area in 3-3",3,achLevelSecret(2, 2)],

    ["King of All Moves","Perform 7 special moves in 1-1",10,achSpecialsReachedInLevel(0, 0, 7)],
    ["Special Swinger","Perform 7 special moves in 1-2",10,achSpecialsReachedInLevel(0, 1, 7)],
    ["Moonwalker","Perform 7 special moves in 1-3",10,achSpecialsReachedInLevel(0, 2, 7)],
    ["Men In Black","Perform 7 special moves in 2-1",10,achSpecialsReachedInLevel(1, 0, 7)],
    ["Show Me Your Moves","Perform 7 special moves in 2-2",10,achSpecialsReachedInLevel(1, 1, 7)],
    ["Hitoshi Susumu's Pro Skater","Perform 7 special moves in 2-3",10,achSpecialsReachedInLevel(1, 2, 7)],
    ["Too Good for His Own Good","Perform 6 special moves in 3-1",10,achSpecialsReachedInLevel(2, 0, 6)],
    ["Gettin' Juvenile on the Nile","Perform 7 special moves in 3-2",10,achSpecialsReachedInLevel(2, 1, 7)],
    ["Slidin' with Panache","Perform 7 special moves in 3-3",10,achSpecialsReachedInLevel(2, 2, 7)],

    ["Feelin' the Funk","Collect 5 large coins in 1-3 without entering the hidden area",5,achCoinsReachedInLevelNoSecret(0,2,5)],
    ["Another Cutback at Work","Collect 12 large coins in 2-1 without entering the hidden area",10,achCoinsReachedInLevelNoSecret(1,0,12)],
    ["Big O Notation","Collect 6 large coins in 2-2",5,achCoinsReachedInLevel(1,1,6)],
    ["Future Wealth","Collect 6 large coins in 2-3 without entering the hidden area",5,achCoinsReachedInLevelNoSecret(1,2,6)],
    ["With a Vertical Twist","Collect 7 large coins in 3-1 without entering the hidden area",5,achCoinsReachedInLevelNoSecret(2,0,7)],
    ["The Parched Throat Never Roars","Collect 7 large coins in 3-2 without entering the hidden area",5,achCoinsReachedInLevelNoSecret(2,1,7)],
    ["The Way the Cookie Crumbles","Collect 6 large coins in 3-3 without entering the hidden area",5,achCoinsReachedInLevelNoSecret(2,2,6)],
    
    ["Just Keep Movin'","Reach a combo of 15",5,achComboReached(15)],
    ["I'm Feelin' Greeeeeeeeeeeeeeeeeat","Reach a combo of 30",10,achComboReached(30)],
]

achs_prog = [
    ["Mother of a Job","Beat 1-1 on Normal mode",3,achCompleteLevel(0, 0)],
    ["Steps of a Prehistoric Dance","Beat 1-2 on Normal mode",3,achCompleteLevel(0, 1)],
    ["He Can Run, He Can Breathe!","Beat 1-3 on Normal mode",3,achCompleteLevel(0, 2)],
    ["Cultural Destruction","Beat 2-1 on Normal mode",3,achCompleteLevel(1, 0)],
    ["Show Some Skillz","Beat 2-2 on Normal mode",3,achCompleteLevel(1, 1)],
    ["Towards a Brighter Future","Beat 2-3 on Normal mode",3,achCompleteLevel(1, 2)],
    ["No Time to Chew the Fat","Beat 3-1 on Normal mode",5,achCompleteLevel(2, 0)],
    ["Rockin' in Style","Beat 3-2 on Normal mode",5,achCompleteLevel(2, 1)],
]

achs_win = [
    ["World Tour","Beat 3-3 on Normal mode",10,achCompleteLevel(2, 2)],
]

for a in achs_reg ach(a,"")
for a in achs_prog ach(a,"progression")
for a in achs_win ach(a,"win_condition")

// --------------------------------------------------------
// MARK: LEADERBOARDS
// 
// --------------------------------------------------------

TIME_SETTINGS = [3,5,10,15]

for world in [0,1,2] {
    for stage in [0,1,2] {
        leaderboard(
            title = format("{0}-{1} Normal - Score", world+1, stage+1),
            description = "Highest Score",
            start = gameState() == STATE_GAME &&
                    levelWorld() == world &&
                    levelStage() == stage &&
                    !isEndless() &&
                    !isTurbo() &&
                    numPlayers() == 1 &&
                    finishLevelResults(),
            cancel = always_false(),
            submit = always_true(),
            value = measured(total_score()),
            format = "VALUE"
        )
    }
}

for world in [0,1,2] {
    for stage in [0,1,2] {
        leaderboard(
            title = format("{0}-{1} Turbo - Score", world+1, stage+1),
            description = "Highest Score",
            start = gameState() == STATE_GAME &&
                    levelWorld() == world &&
                    levelStage() == stage &&
                    !isEndless() &&
                    isTurbo() &&
                    numPlayers() == 1 &&
                    finishLevelResults(),
            cancel = always_false(),
            submit = always_true(),
            value = measured(total_score()),
            format = "VALUE"
        )
    }
}

for world in [0,1,2] {
    for stage in [0,1,2] {
        leaderboard(
            title = format("{0}-{1} Normal - Combo", world+1, stage+1),
            description = "Highest Combo",
            start = gameState() == STATE_GAME &&
                    levelWorld() == world &&
                    levelStage() == stage &&
                    !isTurbo() &&
                    numPlayers() == 1 &&
                    finishLevelResults(),
            cancel = always_false(),
            submit = always_true(),
            value = measured(maxCombo()),
            format = "VALUE"
        )
    }
}

for world in [0,1,2] {
    for stage in [0,1,2] {
        leaderboard(
            title = format("{0}-{1} Turbo - Combo", world+1, stage+1),
            description = "Highest Combo",
            start = gameState() == STATE_GAME &&
                    levelWorld() == world &&
                    levelStage() == stage &&
                    isTurbo() &&
                    numPlayers() == 1 &&
                    finishLevelResults(),
            cancel = always_false(),
            submit = always_true(),
            value = measured(maxCombo()),
            format = "VALUE"
        )
    }
}

for world in [0,1,2] {
    for stage in [0,1,2] {
        leaderboard(
            title = format("{0}-{1} Normal - Large Coins", world+1, stage+1),
            description = "Most Coins",
            start = gameState() == STATE_GAME &&
                    levelWorld() == world &&
                    levelStage() == stage &&
                    !isTurbo() &&
                    numPlayers() == 1 &&
                    finishLevelResults(),
            cancel = always_false(),
            submit = always_true(),
            value = measured(coins()),
            format = "VALUE"
        )
    }
}

for world in [0,1,2] {
    for stage in [0,1,2] {
        leaderboard(
            title = format("{0}-{1} Turbo - Large Coins", world+1, stage+1),
            description = "Most Coins",
            start = gameState() == STATE_GAME &&
                    levelWorld() == world &&
                    levelStage() == stage &&
                    isTurbo() &&
                    numPlayers() == 1 &&
                    finishLevelResults(),
            cancel = always_false(),
            submit = always_true(),
            value = measured(coins()),
            format = "VALUE"
        )
    }
}

leaderboard(
    title = "Endless Normal - Score",
    description = "Highest Score",
    start = gameState() == STATE_GAME &&
            !isTurbo() &&
            isEndless() &&
            numPlayers() == 1 &&
            finishLevelResults(),
    cancel = always_false(),
    submit = always_true(),
    value = measured(total_score()),
    format = "VALUE"
)

leaderboard(
    title = "Endless Turbo - Score",
    description = "Highest Score",
    start = gameState() == STATE_GAME &&
            isTurbo() &&
            isEndless() &&
            numPlayers() == 1 &&
            finishLevelResults(),
    cancel = always_false(),
    submit = always_true(),
    value = measured(total_score()),
    format = "VALUE"
)