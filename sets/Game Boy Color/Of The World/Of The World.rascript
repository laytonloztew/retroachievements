// ~Homebrew~ Of The World
// #ID = 49619

function has_increased(addr) => addr > prev(addr)
function has_decreased(addr) => addr < prev(addr)
function has_changed(addr) => addr != prev(addr)
function hasnt_changed(addr) => addr == prev(addr)
function if_else(p, t, f) { if (p) { return t } else return f }
function is_even(v) => v % 2 == 0
function bitflag(addr,f) => bit(f%8, addr + f/8)
function rp_num(x) => rich_presence_value("Number", x)

class Version {
    checksum = -1
    scene_title = -1
    scene_garden = -1
    scene_potions = -1
    scene_training = -1
    scene_dodge = -1

    function isVersion() => word(0x00014e) == this.checksum
    function inGame() => _current_scene() != 0 && _current_scene() != this.scene_title
}

VERSIONS = [
    /*
    Version( // 1.1
        checksum=0x78a9,
        scene_title=0x468b67,
        scene_garden=0x642e66,
        scene_potions=0x675266,
        scene_training=0x660366,
        scene_dodge=0x5a3c66
    ),*/
    Version( // 1.2
        checksum=0x9e74,
        scene_title=0x4ff767,
        scene_garden=0x6d9e66,
        scene_potions=0x70c266,
        scene_training=0x6f7366,
        scene_dodge=0x475467
    ),
]

function _current_scene() => tbyte(0x00d755)

function temDefeated() => word(0x00c566)

function hp() => word(0x00c49a)
function ability() => word(0x00c4a6)

LookupAbility = {
    0: "🗡️ Spear",
    1: "👁️ Power"
}

LookupHat = {
    1: " 🧢"
}

for v in VERSIONS {
    rich_presence_conditional_display(v.isVersion() && _current_scene() == v.scene_title,"Title Screen")

    rich_presence_conditional_display(v.isVersion() && _current_scene() == v.scene_garden,"Gardening with Aimottle")
    rich_presence_conditional_display(v.isVersion() && _current_scene() == v.scene_potions,"Making Potions with Claire")
    rich_presence_conditional_display(v.isVersion() && _current_scene() == v.scene_training,"Training with Zera")

    rich_presence_conditional_display(v.isVersion() && v.inGame(),"❤️{0}/8 {1}{2}",
        rp_num(hp()),
        rich_presence_lookup("Ability", ability(), LookupAbility),
        rich_presence_lookup("Hat", bit(5,0xc55c), LookupHat)
    )
}

rich_presence_display("Loading...")

function zeraBattleState() => word(0x00c4ac)
function seiDefeated() => word(0x00c4d6) == 1 && prev(word(0x00c4d6)) == 2

achievement(
    title = "Man of Your Dreams",
    points = 2,
    description = "Defeat Zera",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            zeraBattleState() == 2 &&
            prev(zeraBattleState()) == 1
            ),
    type="progression"
)

achievement(
    title = "Watching Over You",
    points = 3,
    description = "Fall asleep at the Dragon statue",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            has_increased(bit(7,0x00c54c)))
)

achievement(
    title = "Looks Can Be Deceiving",
    points = 3,
    description = "Defeat the Wolf",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            has_increased(bit(0,0x00c510))),
    type="progression"
)

achievement(
    title = "Demonstration of Power",
    points = 3,
    description = "Defeat the Dragon",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() &&  
            hasnt_changed(_current_scene()) &&
            has_increased(bit(1,0x00c510))),
    type="progression"
)

achievement(
    title = "Calm Before the Storm",
    points = 3,
    description = "Witness a scene as Aimottle between her and Zera",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            has_increased(bit(1,0x00c54d)))
)

achievement(
    title = "Inn and Out",
    points = 3,
    description = "Witness a scene as Claire alone at home",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            has_increased(bit(0,0x00c54d)))
)

achievement(
    title = "The Sophistication! The Grace!",
    points = 2,
    description = "Try on an outfit",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            has_increased(word(0x00c540)))
)

achievement(
    title = "Something About Gardening",
    points = 5,
    description = "Help Aimottle with her garden",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            has_increased(bit(2,0x00c512)))
)

achievement(
    title = "For Your Own Good",
    points = 5,
    description = "Complete Zera's Training",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            has_increased(bit(4,0x00c54c)))
)

achievement(
    title = "Cooking by the Tome",
    points = 5,
    description = "Assist Claire with making potions",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            has_increased(bit(4,0x00c512)))
)

achievement(
    title = "Explosives In Action",
    points = 10,
    description = "Defeat Claire",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            has_increased(bit(5,0x00c512))),
    type="missable"
)

achievement(
    title = "Strange Beings",
    points = 3,
    description = "Defeat both Beast-Type enemies",
    trigger = 
        any_of(VERSIONS, v =>
            measured(bit(0,0x00c512) + bit(1,0x00c512) == 2, when=v.inGame() && v.isVersion()) &&
            prev(bit(0,0x00c512) + bit(1,0x00c512)) == 1 && hasnt_changed(_current_scene())
        ),
    type="missable"
)

achievement(
    title = "this is serious",
    points = 25,
    description = "Survive Tem's onslaught",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            temDefeated() == 1 &&
            prev(temDefeated()) == 0),
    type="missable"
)

achievement(
    title = "Power of the Prince",
    points = 5,
    description = "Defeat the High Knight with Power",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            has_increased(bit(2,0x00c510)) &&
            ability() == 1),
    type="missable"
)


achievement(
    title = "No Spear, No Problem",
    points = 10,
    description = "Defeat the High Knight without Power",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            has_increased(bit(2,0x00c510)) &&
            ability() == 0),
    type="missable"
)

achievement(
    title = "Conscious Invader",
    points = 5,
    description = "Defeat Null",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            has_increased(bit(3,0x00c510))),
    type="progression"
)

achievement(
    title = "Keep Lying to Yourself",
    points = 5,
    description = "Have a strange encounter in the village",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            has_increased(bit(5,0x00c55a)))
)

achievement(
    title = "Fetch Quest",
    points = 5,
    description = "Obtain the hat",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            has_increased(bit(5,0xc55c)))
)

achievement(
    title = "Flames of Power",
    points = 5,
    description = "Interact with every flame in Zera's Manor",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            has_increased(bit(3,0x00c58e))
    ),
    type="missable"
)

achievement(
    title = "Lost Control",
    points = 10,
    description = "Defeat Sei",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            seiDefeated()),
    type = "win_condition"
)

achievement(
    title = "One Last Time",
    points = 25,
    description = "Defeat Sei after obtaining the Doll",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            seiDefeated() &&
            bit(5,0x00c532) == 1)
)

achievement(
    title = "Left or Right",
    points = 5,
    description = "Dodge the flag-waving blob's attack",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            never(!v.inGame()) && 
            once(_current_scene() == v.scene_dodge && prev(_current_scene()) != v.scene_dodge) &&
            never(has_decreased(hp())) &&
            trigger_when(_current_scene() != v.scene_dodge))
)

leaderboard(
    title = "Aimottle's Garden",
    description = "Highest Score",
    start = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            _current_scene() == v.scene_garden &&
            hasnt_changed(_current_scene()) &&
            word(0x00c4f8) == 0 &&
            prev(word(0x00c4f8)) == 1 &&
            word(0x00c4fa) == 0
    ),
    cancel = always_false(),
    submit = always_true(),
    value  = measured(
        (word(0x00c4f2) * 10) + 
        (word(0x00c4f4) * 100) + 
        (word(0x00c4f6) * 1000)
    ),
    format = "VALUE",
    lower_is_better=false
)

leaderboard(
    title = "Claire's Potions",
    description = "Seconds Left",
    start = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            _current_scene() == v.scene_potions &&
            hasnt_changed(_current_scene()) &&
            has_increased(bit(4,0x00c512))
    ),
    cancel = always_false(),
    submit = always_true(),
    value  = measured(
        (word(0x00c4f8) * 1) + 
        (word(0x00c4fa) * 10)
    ),
    format = "VALUE",
    lower_is_better=false
)


/*
achievement(
    title = "_glove",
    points = 3,
    description = "Find a glove in the sewers",
    trigger = any_of(VERSIONS, v =>
            v.isVersion() &&
            v.inGame() && 
            hasnt_changed(_current_scene()) &&
            has_increased(bit(7,0x00c55b)))
)
*/