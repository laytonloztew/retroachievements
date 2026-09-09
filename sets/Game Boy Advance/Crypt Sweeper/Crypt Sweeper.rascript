// ~Homebrew~ Crypt Sweeper
// #ID = 37882

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

function g_lava_frame() => dword(0x00258c)

function currentSong() => byte(0x003414)
SONG_TITLE = 0
SONG_SUCCESS = 1
SONG_FAILURE = 2
SONG_MAIN = 3 

function win_status() => byte(0x00247e) // win
function selx() => byte(0x002478)
function sely() => byte(0x002479)

function pause_selection_x() => dword(0x002590)
function pause_selection_y() => dword(0x002594)

function isTitle() => currentSong() == SONG_TITLE
function inPuzzle() => currentSong() == SONG_MAIN//g_lava_frame() != 0xffffffff
function puzzleWon() => currentSong() == SONG_SUCCESS
function puzzleFailed() => currentSong() == SONG_FAILURE

function tutorial() => byte(0x007cc9)
function inTutorial() => inPuzzle() && tutorial() == 1

function hp() => byte(0x00247c)
function exp() => byte(0x00247d)
function level() => byte(0x00247b)
function max_hp() => 5 + (level() / 2)
function max_xp() => 0

function cheat() => byte(0x002468)
function hasntCheated() => cheat() == 0
function hasCheated() => cheat() == 1

function difficulty() => byte(0x00247a)
function isOnlyMines() => difficulty() >= ONLYMINES_EASY && difficulty() <= ONLYMINES_EXPERT
DIFFICULTY_EASY = 0
DIFFICULTY_MILD = 1
DIFFICULTY_NORMAL = 2
DIFFICULTY_HARD = 3
DIFFICULTY_EXPERT = 4
ONLYMINES_EASY = 0x10
ONLYMINES_MILD = 0x11
ONLYMINES_NORMAL = 0x12
ONLYMINES_HARD = 0x13
ONLYMINES_EXPERT = 0x14

book_start_addr = 0x002454
function book(f) => bit(f%8, book_start_addr + f/8)
function bookObtained(f) => has_increased(book(f))

function min() => dword(0x00245c)
function sec() => dword(0x002460)

function total_sec() => (min() * 60) + sec()

function ach(ach, t) {
    achievement(
        title = ach[0],
        points = ach[2],
        description = ach[1],
        trigger = ach[3],
        type=t
    )
}

function achBookObtained(f) => puzzleWon() && bookObtained(f) && hasntCheated()

function sumBooksObtained() => sum_of(
                                    range(0,29), f => book(f)
                                )

function achLevelReached(n) => inPuzzle() && 
                                !isOnlyMines() && 
                                hasntCheated() &&
                                level() == n && 
                                prev(level()) == (n - 1)

function selectedTile() => byte(0x002507 + (sely() * 14) + selx())

function achSelectedTileChangedTo(id) => inPuzzle() &&
                                        !isOnlyMines() && 
                                        hasntCheated() &&
                                        selectedTile() == id &&
                                        hasnt_changed(selx()) &&
                                        hasnt_changed(sely()) &&
                                        __ornext(
                                            prev(selectedTile()) == (id - 0x9c) ||
                                            prev(selectedTile()) == (id - 0x5c)
                                        )

function defeatedDeath() => selectedTile() == 0x94 && prev(selectedTile()) == 0x54


B_INTRO = 0
B_ITEMS = 1
B_LOWLEVEL = 2
B_LV1B = 3
B_LV3A = 4
B_LV3BC = 5
B_LV4A = 6
B_LV4B = 7
B_LV4C = 8
B_LV5A = 9
B_LV5B = 10
B_LV5C = 11
B_LV6 = 12
B_LV7 = 13
B_LV8 = 14
B_LV9 = 15
B_LV10 = 16
B_LV11 = 17
B_LV13 = 18
B_MINE = 19
B_WALL = 20
B_CHEST = 21
B_LAVA = 22
B_EASY = 23
B_MILD = 24
B_NORMAL = 25
B_HARD = 26
B_EXPERT = 27
B_ONLYMINES = 28
B_100 = 29

MaxEXPLookup = {
    0: "4",
    1: "5",
    2: "7",
    3: "9",
    4: "9",
    5: "10",
    6: "12",
    7: "12",
    8: "12",
    9: "15",
    10: "18",
    11: "21",
    12: "21"
}

CheatLookup = {
    1: " [Cheater!]"
}

DifficultyLookup = {
DIFFICULTY_EASY: "Easy",
DIFFICULTY_MILD: "Mild",
DIFFICULTY_NORMAL: "Normal",
DIFFICULTY_HARD: "Hard",
DIFFICULTY_EXPERT: "Expert",
ONLYMINES_EASY: "Easy",
ONLYMINES_MILD: "Mild",
ONLYMINES_NORMAL: "Normal",
ONLYMINES_HARD: "Hard",
ONLYMINES_EXPERT: "Expert"
}
 

rich_presence_conditional_display(inTutorial(), "In Tutorial 📕{0}/30",
    rich_presence_value("Number", sumBooksObtained())
)

rich_presence_conditional_display(inPuzzle() && isOnlyMines(), "Classic Puzzle ⚖️{2} 📕{0}/30{1}",
    rich_presence_value("Number", sumBooksObtained()),
    rich_presence_lookup("Cheat", cheat(), CheatLookup),
    rich_presence_lookup("Difficulty", difficulty(), DifficultyLookup)
)

rich_presence_conditional_display(inPuzzle(), "Regular Puzzle ⚖️{6} ❤️{3}/{4} 🪦{1}/{2} 📕{0}/30{5}",
    rich_presence_value("Number", sumBooksObtained()),
    rich_presence_value("Number", exp()),
    rich_presence_lookup("MaxEXP", level(), MaxEXPLookup, fallback="25"),
    rich_presence_value("Number", hp()),
    rich_presence_value("Number", max_hp()),
    rich_presence_lookup("Cheat", cheat(), CheatLookup),
    rich_presence_lookup("Difficulty", difficulty(), DifficultyLookup)
)

rich_presence_conditional_display(puzzleWon() && isOnlyMines(), "💀Classic Puzzle ⚖️{6} 📕{0}/30{5}",
    rich_presence_value("Number", sumBooksObtained()),
    rich_presence_value("Number", exp()),
    rich_presence_lookup("MaxEXP", level(), MaxEXPLookup, fallback="25"),
    rich_presence_value("Number", hp()),
    rich_presence_value("Number", max_hp()),
    rich_presence_lookup("Cheat", cheat(), CheatLookup),
    rich_presence_lookup("Difficulty", difficulty(), DifficultyLookup)
)

rich_presence_conditional_display(puzzleWon(), "💀Regular Puzzle ⚖️{6} ❤️{3}/{4} 🪦{1}/{2} 📕{0}/30{5}",
    rich_presence_value("Number", sumBooksObtained()),
    rich_presence_value("Number", exp()),
    rich_presence_lookup("MaxEXP", level(), MaxEXPLookup, fallback="25"),
    rich_presence_value("Number", hp()),
    rich_presence_value("Number", max_hp()),
    rich_presence_lookup("Cheat", cheat(), CheatLookup),
    rich_presence_lookup("Difficulty", difficulty(), DifficultyLookup)
)

rich_presence_conditional_display(puzzleFailed() && isOnlyMines(), "💥Classic Puzzle ⚖️{6} 📕{0}/30{5}",
    rich_presence_value("Number", sumBooksObtained()),
    rich_presence_value("Number", exp()),
    rich_presence_lookup("MaxEXP", level(), MaxEXPLookup, fallback="25"),
    rich_presence_value("Number", hp()),
    rich_presence_value("Number", max_hp()),
    rich_presence_lookup("Cheat", cheat(), CheatLookup),
    rich_presence_lookup("Difficulty", difficulty(), DifficultyLookup)
)


rich_presence_conditional_display(puzzleFailed(), "💥Regular Puzzle ⚖️{6} ❤️{3}/{4} 🪦{1}/{2} 📕{0}/30{5}",
    rich_presence_value("Number", sumBooksObtained()),
    rich_presence_value("Number", exp()),
    rich_presence_lookup("MaxEXP", level(), MaxEXPLookup, fallback="25"),
    rich_presence_value("Number", hp()),
    rich_presence_value("Number", max_hp()),
    rich_presence_lookup("Cheat", cheat(), CheatLookup),
    rich_presence_lookup("Difficulty", difficulty(), DifficultyLookup)
)

rich_presence_conditional_display(isTitle(), "Title Screen 📕{0}/30",
    rich_presence_value("Number", sumBooksObtained())
)

rich_presence_display("Loading...")

achs_reg = [
    ["Eye of the Achiever","Obtain the Items book",3,achBookObtained(B_ITEMS)],
    ["Not to Be Overestimated","Obtain the Weaklings book",3,achBookObtained(B_LOWLEVEL)],
    ["Edge of Life and Death","Obtain the Mummy book",4,achBookObtained(B_LV1B)],
    ["Piercing Screams","Obtain the Banshee 1 book",4,achBookObtained(B_LV3A)],
    ["Haunting Calls","Obtain the Banshee 2-3 book",4,achBookObtained(B_LV3BC)],
    ["Bony Buddies","Obtain the Skeleton book",4,achBookObtained(B_LV4A)],
    ["Graveyard Boogie","Obtain the Disco Skeleton book",5,achBookObtained(B_LV4B)],
    ["Pair of Boneheads","Obtain the Skeleton Knight book",5,achBookObtained(B_LV4C)],
    ["Squishing Scarabs","Obtain the Scarab book",4,achBookObtained(B_LV5A)],
    ["Mischievous Royalty","Obtain the Widow Queen book",5,achBookObtained(B_LV5B)],
    ["Mystifying Magic","Obtain the Swamp Witch book",5,achBookObtained(B_LV5C)],
    ["Bury Me with My Money","Obtain the Draugr book",5,achBookObtained(B_LV6)],
    ["Ruined Routine","Obtain the Zombox book",5,achBookObtained(B_LV7)],
    ["Guardians of the Dead","Obtain the Anubis Warrior book",5,achBookObtained(B_LV8)],
    ["Not Quite Possible","Obtain the Phantom Twins book",10,achBookObtained(B_LV9)],
    ["Cornered Count","Obtain the Dracula book",5,achBookObtained(B_LV10)],
    ["Don't Judge a Book By Its Cover","Obtain the Mimic book",5,achBookObtained(B_LV11)],
    ["Out of Retirement","Obtain the Death book",3,achBookObtained(B_LV13)],
    ["Mine and Mine Alone","Obtain the Mine book",3,achBookObtained(B_MINE)],
    ["Wall to Wall Coverage","Obtain the Wall book",3,achBookObtained(B_WALL)],
    ["Precious Treasures","Obtain the Chest book",4,achBookObtained(B_CHEST)],
    ["Sizzling Regret","Obtain the Lava book",5,achBookObtained(B_LAVA)],
    ["You Rock!!!","Complete a classic game",5,achBookObtained(B_ONLYMINES)],
    ["Ghoul's Gallery","Obtain every book",25,achBookObtained(B_100)],
    // Use Dracula's Ire before having 11 HP, then defeat Death without touching lava

    ["Triple the Trouble","Defeat all the Banshee Triplets",3,achSelectedTileChangedTo(0xa3)],
    ["Double the Shrieks","Defeat both the Banshee Twins",2,achSelectedTileChangedTo(0xa2)],
]

achs_prog = [
    ["Spooky Sweeper","Reach level 10",3,achLevelReached(10)],
]

achs_win = [
    ["Easy Retirement","Complete a game on Easy difficulty",5,achBookObtained(B_EASY)],
    ["Back to Work","Complete a game on Mild difficulty",5,achBookObtained(B_MILD)],
    ["Nothing is Normal About This","Complete a game on Normal difficulty",10,achBookObtained(B_NORMAL)],
    ["Reduced to Rubble","Complete a game on Hard difficulty",10,achBookObtained(B_HARD)],
    ["Expert of the Crypt","Complete a game on Expert difficulty",10,achBookObtained(B_EXPERT)],
]

for a in achs_reg ach(a,"")
for a in achs_prog ach(a,"progression")
for a in achs_win ach(a,"win_condition")

NORMAL_DIFFICULTIES = [DIFFICULTY_EASY,DIFFICULTY_MILD,DIFFICULTY_NORMAL,DIFFICULTY_HARD,DIFFICULTY_EXPERT]
MINE_DIFFICULTIES = [ONLYMINES_EASY,ONLYMINES_MILD,ONLYMINES_NORMAL,ONLYMINES_HARD,ONLYMINES_EXPERT]

for difficulty in NORMAL_DIFFICULTIES {
    leaderboard(
        title = format("Regular - {0}",DifficultyLookup[difficulty]),
        description = "Lowest Time",
        start = puzzleWon() && 
            prev(inPuzzle()) &&
            difficulty() == difficulty && 
            hasntCheated(),
        cancel = always_false(),
        submit = always_true(),
        value  = total_sec(),
        format = "SECS", lower_is_better = true
    )
}

for difficulty in MINE_DIFFICULTIES {
    leaderboard(
        title = format("Classic - {0}",DifficultyLookup[difficulty]),
        description = "Lowest Time",
        start = puzzleWon() && 
            prev(inPuzzle()) &&
            difficulty() == difficulty && 
            hasntCheated(),
        cancel = always_false(),
        submit = always_true(),
        value  = total_sec(),
        format = "SECS", lower_is_better = true
    )
}