// PictoImage
// #ID = 40790

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


// Pointer mask for custom memory map
RA_MASK = 0x00FFFFFF

acc_addr = (v) => v // Dummy accessor for ptr for if the pointed-to address is desired
function ptr(base, offsets, accessor = dword)
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
            val = dword(addr)
            val = val & RA_MASK
        }
    }
    
    return val
}

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
// MARK: MEMORY / FUNCTIONS
// 
// --------------------------------------------------------
class Region {
    r_name = ""

    r_region_value = -1

    addr_current_screen = -1
    addr_level_state_start = -1
    addr_points = -1

    region_addr = 0x00000ba8
    function isRegion() => dword(this.region_addr) == this.r_region_value
    function saveLoaded() => this.levelState(0) != 0xff
    function lessonSaveLoaded() => this.lessonState(0) != 0xff
    function inGame() => this.currentScreen() > 0x0a

    function currentScreen() => dword(this.addr_current_screen)
    function levelState(i) => byte(this.addr_level_state_start + i)
    function lessonState(i) => this.levelState(i + 0x134) 

    function currentPoints() => dword(this.addr_points)

    function sumPuzzlesComplete() => sum_of(range(0,299), i => 
        this.levelState(i) / 3
    )

    function sumLessonsComplete() => this.sumLessonsRange(0,30) + 
        this.sumLessonsRange(48,87) + 
        this.sumLessonsRange(92,112) + 
        this.sumLessonsRange(117,128)

    function sumLessonsRange(start,end) => sum_of(range(start,end-1), i => 
        this.lessonState(i) / 2
    )

    function sumLevelsRange(start,end) => sum_of(range(start,end-1), i => 
        this.levelState(i) / 3
    )

    function rp_puzzles_complete() => rp_num(this.sumPuzzlesComplete())
    function rp_lessons_complete() => rp_num(this.sumLessonsComplete())
    function rp_points() => rp_num(this.currentPoints())
    function rp_state_lookup() => rich_presence_lookup("State",this.currentScreen(),StateLookup) 
}

REGIONS = [
    Region(
        r_name = "EU",
        r_region_value = 0x021b0d00,
        addr_current_screen = 0x001c15b0,
        addr_level_state_start = 0x00203c50,
        addr_points = 0x001c0a80
    ),
    Region(
        r_name = "US",
        r_region_value = 0x021ad000,
        addr_current_screen = 0x001bd8b0,
        addr_level_state_start = 0x001fff70,
        addr_points = 0x001bcd80
    ),
    Region(
        r_name = "JP",
        r_region_value = 0x21810e0,
        addr_current_screen = 0x00188800,
        addr_level_state_start = 0x001d9030,
        addr_points = 0x00187574
    )
]

// --------------------------------------------------------
// MARK: RICH PRESENCE LOOKUPS
// 
// --------------------------------------------------------
StateLookup = {
    0x03: "Title Screen",
    0x0d: "Drawing",
    0x0f: "Guessing",
    0x15: "Main Menu",
    0x3b: "Editing Player ID",
    0x3d: "Entering Player Nickname",
    0x3e: "Viewing Rankings",
    0x40: "Viewing Rankings",
    0x42: "Viewing Rankings",
    0x44: "Viewing Rankings",
    0x48: "Deleting Data",
    0x33: "PictoImage",
    0x37: "Gallery",
}

LessonLookup = {
    0: "Animals",
    1: "Objects",
    2: "Food",
    3: "Other",
}

// --------------------------------------------------------
// MARK: RICH PRESENCE CONDITIONALS
// 
// --------------------------------------------------------
for r in REGIONS {
    rich_presence_conditional_display(r.isRegion() && r.currentScreen() == 0x3,"Title Screen")
    rich_presence_conditional_display(r.isRegion() && r.currentScreen() < 0xa,"Loading...")

    rich_presence_conditional_display(r.isRegion() && !r.saveLoaded(),"{0}",
        r.rp_state_lookup()
    )

    rich_presence_conditional_display(r.isRegion() && __ornext(r.currentScreen() == 0x35 || r.currentScreen() == 0x4c),"PictoImage ✔️{0}/300 ✍️{2}/100 [{1} Points]",
        r.rp_puzzles_complete(),
        r.rp_points(),
        r.rp_lessons_complete()
    )

    rich_presence_conditional_display(r.isRegion() && r.currentScreen() == 0x4b,"How to Draw ✔️{0}/300 ✍️{2}/100 [{1} Points]",
        r.rp_puzzles_complete(),
        r.rp_points(),
        r.rp_lessons_complete()
    )

    rich_presence_conditional_display(r.isRegion(),"{3} ✔️{0}/300 ✍️{2}/100 [{1} Points]",
        r.rp_puzzles_complete(),
        r.rp_points(),
        r.rp_lessons_complete(),
        r.rp_state_lookup()
    )
}

rich_presence_display("Loading...")

// --------------------------------------------------------
// MARK: ACHIEVEMENT FUNCTIONS
// 
// --------------------------------------------------------
function achSumLessons(start, end) => 
    any_of(REGIONS, r =>
        measured(r.sumLessonsRange(start, end) == (end - start), when=(r.inGame() || prev(r.lessonSaveLoaded())) && r.isRegion()) &&
        prev(r.sumLessonsRange(start, end)) == (end - start - 1)
    )

function achSumLevels(amt) =>
    any_of(REGIONS, r =>
        measured(r.sumPuzzlesComplete() == amt, when=(r.inGame() || prev(r.saveLoaded())) && r.isRegion()) &&
        prev(r.sumPuzzlesComplete()) == amt - 1
    )

function achSumLevelsRange(start, end) =>
    any_of(REGIONS, r =>
        r.inGame() && r.isRegion()  && r.saveLoaded() &&
        r.sumLevelsRange(start, end + 1) == (end - start + 1) &&
        prev(r.sumLevelsRange(start, end + 1)) == (end - start)
    )

function achPoints(amt) =>
    any_of(REGIONS, r =>
        r.inGame() && r.isRegion() && r.saveLoaded() &&
        r.currentPoints() >= amt &&
        prev(r.currentPoints()) < amt
    )

// --------------------------------------------------------
// MARK: ACHIEVEMENTS
// 
// --------------------------------------------------------
achs_reg = [
    ["Draw the Rest of the Owl","Complete all 30 Animal How to Draw lessons",1,achSumLessons(0,30)],
    ["Objective Drawing","Complete all 39 Object How to Draw lessons",1,achSumLessons(48,87)],
    ["Tasty Lesson","Complete all 20 Food How to Draw lessons",1,achSumLessons(92,112)],
    ["Something or Other","Complete all 11 Other How to Draw lessons",1,achSumLessons(117,128)],

    //Solving every puzzle first try doesn't give enough points, need multiplayer
    /*["_50","Earn 50 points and unlock the Teal color palette",0,achPoints(50)],
    ["_170","Earn 170 points and unlock the Light Green color palette",0,achPoints(170)],
    ["_310","Earn 310 points and unlock the Orange color palette",0,achPoints(310)],
    ["_450","Earn 450 points and unlock the Pink color palette",0,achPoints(450)],
    ["_600","Earn 600 points and unlock the Dark Gray color palette",0,achPoints(600)],
    ["_800","Earn 800 points and unlock the Light Gray color palette",0,achPoints(800)],
    ["_1150","Earn 1150 points and unlock the Brown color palette",0,achPoints(1150)],
    ["_1650","Earn 1650 points and unlock the Blue-Green color palette",0,achPoints(1650)],
    ["_2200","Earn 2200 points and unlock the Purple color palette",0,achPoints(2200)],*/
]

achs_prog = [
    ["Easy Backstroke","Complete Puzzles No.1 - No.20 in PictoImage",2,achSumLevelsRange(0,19)],
    ["Soldering Snack","Complete Puzzles No.21 - No.40 in PictoImage",2,achSumLevelsRange(20,39)],
    ["Let's Make This Brief","Complete Puzzles No.41 - No.60 in PictoImage",2,achSumLevelsRange(40,59)],
    ["Baby Mosquito","Complete Puzzles No.61 - No.80 in PictoImage",2,achSumLevelsRange(60,79)],
    ["Scroll of Invisibility","Complete Puzzles No.81 - No.100 in PictoImage",2,achSumLevelsRange(80,99)],
    ["Wedding in Italy","Complete Puzzles No.101 - No.120 in PictoImage",2,achSumLevelsRange(100,119)],
    ["Martian Cowboy","Complete Puzzles No.121 - No.140 in PictoImage",2,achSumLevelsRange(120,139)],
    ["Stairs of Saturn","Complete Puzzles No.141 - No.160 in PictoImage",2,achSumLevelsRange(140,159)],
    ["Try Looking Upside Down","Complete Puzzles No.161 - No.180 in PictoImage",2,achSumLevelsRange(160,179)],
    ["Spots Car","Complete Puzzles No.180 - No.200 in PictoImage",2,achSumLevelsRange(180,199)],
    ["Thunder Fox","Complete Puzzles No.201 - No.220 in PictoImage",2,achSumLevelsRange(200,219)],
    ["Magic Flask","Complete Puzzles No.221 - No.240 in PictoImage",2,achSumLevelsRange(220,239)],
    ["Lily of the Cavity","Complete Puzzles No.241 - No.260 in PictoImage",2,achSumLevelsRange(240,259)],
    ["Sleep Clown Ruler","Complete Puzzles No.261 - No.280 in PictoImage",2,achSumLevelsRange(260,279)],
    ["Star of the Sea","Complete Puzzles No.281 - No.300 in PictoImage",2,achSumLevelsRange(280,299)],
    //"_puzzles_100","Complete 100 PictoImage puzzles",0,achSumLevels(100)],
    //["_puzzles_200","Complete 200 PictoImage puzzles",0,achSumLevels(200)],
    
]

achs_win = [
    ["Virtual Masterpieces","Complete all 300 PictoImage puzzles",10,achSumLevels(300)],
]

achs_missable = [
    //
]

for a in achs_reg ach(a,"")
for a in achs_prog ach(a,"progression")
for a in achs_win ach(a,"win_condition")
for a in achs_missable ach(a,"missable")

// --------------------------------------------------------
// MARK: LEADERBOARDS
// 
// --------------------------------------------------------