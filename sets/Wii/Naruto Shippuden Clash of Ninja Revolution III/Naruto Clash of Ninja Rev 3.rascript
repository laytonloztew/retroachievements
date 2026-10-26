// Naruto Shippuden: Clash of Ninja Revolution III
// #ID = 35361

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

serial_1 = dword_be(0x00000000)

class Region {
    r_name = ""
    r_flag = ""
    r_mark = ""

    addr_fpack_ptr = -1
    addr_current_mode = -1
    addr_score = -1
    addr_match_state_ptr = -1
    addr_character_ptr_start = -1
    addr_kumite_level = -1

    function addr_seq_ptr() => ptr(this.addr_fpack_ptr, [0x90], acc_addr)
    function addr_seq(offset = 0) => ptr(dword_be(this.addr_fpack_ptr), [0x90, 0x10 + offset], acc_addr)

    function char(i) => this.CharacterState(i)
    function char_ptr(i) => dword_be(this.addr_character_ptr_start + (i * 8))
    function pauseState() => dword_be(this.addr_character_ptr_start + 0x36c)

    function actPaused() => this.pauseState() == 1 && has_changed(this.pauseState())
    function actUnpaused() => this.pauseState() != 1 && prev(this.pauseState()) == 1

    function CharacterState(i) {
        addr = this.char_ptr(i) & RA_MASK

        obj = {
            "is_active": byte(this.addr_character_ptr_start + (i * 8) - 4),
            "dead_state": bit(4,addr + 0x03),
            "char_index": dword_be(addr + 0x04),
            "player_index": dword_be(addr + 0x08),
            "player_associated": dword_be(addr + 0x0c),
            "character_id": dword_be(addr + 0x18),
            "max_hp": dword_be(addr + 0x24),
            "curr_hp": dword_be(addr + 0x28),
            "hp_change": dword_be(addr + 0x2c),
            "max_chakra": dword_be(addr + 0x40),
            "curr_chakra": dword_be(addr + 0x44),
            "target_char_index": dword_be(addr + 0xac),
            "act_id": dword_be(addr + 0x140),
            "last_act_id": dword_be(addr + 0x144),
            "attack_multiplier": float_be(addr + 0x9a4),
            "curr_combo": dword_be(addr + 0x9ac),
            "combo_timer": dword_be(addr + 0x9b0),
            "transform_status": dword_be(addr + 0x164c),
            "target_ptr": dword_be(addr + 0x3854),
            "hit_enemy_ptr": dword_be(addr + 0x3860)
        }

        return obj
    }

    function charIsAlive(b) => this.char(b)["dead_state"] == 0
    function charIsActive(b) => this.char(b)["is_active"] == 1 && this.char_ptr(b) != 0
    function charHP(b) => this.char(b)["curr_hp"]
    function charIsSubCharacter(b) => this.char(b)["player_index"] == -1
    function charIsHuman(b) => this.charIsActive(b) && !this.charIsSubCharacter(b) && this.playerCharacterIsHuman(this.char(b)["player_index"])
    
    
    function charTargetID(b) => ptr(this.char(b)["target_ptr"], [0x18])
    function charTargetTransformStatus(b) => ptr(this.char(b)["target_ptr"], [0x164c])
    function charTargetHP(b) => ptr(this.char(b)["target_ptr"], [0x28])

    function charHitID(b) => ptr(this.char(b)["hit_enemy_ptr"], [0x18])
    function charHitHP(b) => ptr(this.char(b)["hit_enemy_ptr"], [0x28])
    
    function MatchState() {
        addr = dword_be(this.addr_match_state_ptr) & RA_MASK

        obj = {
            "state": dword_be(addr + 0x10),
            "total_rounds": dword_be(addr + 0x30),
            "current_round": dword_be(addr + 0x34),
            "total_timer": dword_be(addr + 0x38),
            "timer": dword_be(addr + 0x3c)
        }

        return obj
    }

    function matchTimer() => this.MatchState()["timer"]

    function match_team_wins(team_id) => dword_be(ptr(dword_be(this.addr_match_state_ptr), [0x14], acc_addr) + (team_id * 4))

    function addr_unlock_flags_start() => this.addr_score + 0xe8
    function addr_mode_flags_start() => this.addr_score + 0x288
    function addr_shop_flags_start() => this.addr_score + 0x31a
    function info_playtime() => dword_be(this.addr_score + 0x3C8)
    function addr_matches_played_start() => this.addr_score + 0x3ec
    function addr_mission_ranks_start() => this.addr_score + 0x5b8

    function missionRank(char_id, mission_id) => dword_be(this.addr_mission_ranks_start() + (char_id * 0x40) + (mission_id * 4))

    function missionsHokageForChar(char_id) => 10 - sum_of(range(0,9), i =>
            // Hokage rank is 0, none is 0xffffffff 
            this.missionRank(char_id, i) / this.missionRank(char_id, i)
    )

    function missionsCompleteForChar(char_id) => 10 - sum_of(range(0,9), i => 
            this.missionRank(char_id, i) / 0xffffffff
    )

    function isRegion() => ascii_string_equals(0x0, this.r_mark)
    function unlockFlag(f) => bit(f%8, this.addr_unlock_flags_start() + f/8)
    function modeFlag(f) => bit(f%8, this.addr_mode_flags_start() + f/8)

    function sumUnlocks(group) => sum_of(group, f => 
                    this.unlockFlag(f)
                )

    function storyFlag(m,difficulty) => this.modeFlag(((m-1) * 4) + difficulty)

    function seqActive() => dword_be(this.addr_fpack_ptr) != 0 && this.addr_seq_ptr() != 0
    function currentSeqIs(s, offset = 0) => this.seqActive() && ascii_string_equals(this.addr_seq(offset), s)
    function isLoadingSave() => ascii_string_equals(this.addr_seq(4), "/sav")
    function inBattle() => ascii_string_equals(this.addr_seq(), "game")

    function currentMode() => dword_be(this.addr_current_mode) //NOTE: changes to 3 when trying to skip results in story mode
    function currentSubMode() => dword_be(this.addr_current_mode + 0x04)
    function lastMenuSelection() => dword_be(this.addr_current_mode + 0x0c)
    function playerCharacterID(index) => dword_be(this.addr_current_mode + 0x24 + (index * 0x78))
    function playerCharacterCostume(index) => dword_be(this.addr_current_mode + 0x24 + (index * 0x78) + 0x04)
    function playerControlStatus(index) => dword_be(this.addr_current_mode + 0x24 + (index * 0x78) + 0x0c)
    function playerCharacterIsHuman(index) => this.playerControlStatus(index) == 0
    function playerCharacterIsCpu(index) => this.playerControlStatus(index) == 1
    function playerCharacterSquad(index) => dword_be(this.addr_current_mode + 0x24 + (index * 0x78) + 0x10)

    function inStoryMode() => this.lastMenuSelection() <= 0x0d

    function currentMap() => dword_be(this.addr_score - 0x28)
    function score() => dword_be(this.addr_score)
    function timer() => dword_be(this.addr_score + 0x04)
    function battle() => dword_be(this.addr_score + 0x08)

    // Lazily assumes player is in team 0, but should work for all practical uses
    function playerLostRound() => __ornext(
                                    has_increased(this.match_team_wins(1)) || 
                                    has_increased(this.match_team_wins(2)) || 
                                    has_increased(this.match_team_wins(3))
                                    )

    function playerWonRound(i) => has_increased(this.match_team_wins(i))

    function storyChapter() => dword_be(this.addr_match_state_ptr + 0x20) 

    // Options
    function options_rounds() => dword_be(this.addr_score + 0x8c)
    function options_matchtime() => dword_be(this.addr_score + 0x90)
    function options_matchtime_two() => dword_be(this.addr_score + 0x98)
    function options_difficulty() => dword_be(this.addr_score + 0x9c)
    function options_attackpower() => dword_be(this.addr_score + 0xa0)
    function options_specials_navigator() => dword_be(this.addr_score + 0xa8)
    function options_stage_transitions() => dword_be(this.addr_score + 0xb0)
    function options_obstacles() => dword_be(this.addr_score + 0xb4)

    function isCompletingLastMatch() => this.battle() == 10 && prev(this.battle()) == 9
    function isDefaultSettings() => this.options_attackpower() == 1 && 
                                    this.options_difficulty() == 1 //&& 
                                    //this.options_rounds() == 2 && 
                                    //this.options_matchtime() == 0xe10
    function matchStateIs(s) => dword_be(this.addr_match_state_ptr) != 0 && this.MatchState()["state"] == s
    function isStartingMatch() => this.matchStateIs(MATCH_STATE_BATTLE) && has_changed(this.MatchState()["state"])

    function combo_counter(i) {
        return once(this.char(0)["curr_combo"] >= i)
    }

    function comboIncreased() => has_increased(this.char(0)["curr_combo"])

    function kumiteLevel() => dword_be(this.addr_kumite_level)
    function kumiteOppsDefeated() => dword_be(this.addr_kumite_level + 0x18)

    function rp_playtime() => rich_presence_value("Time", this.info_playtime(), format="FRAMES")
    function rp_score_tracker() => rich_presence_value("Number", this.score())
    function rp_kumite_level() => rich_presence_value("Number", this.kumiteLevel())
    function rp_opps_defeated() => rich_presence_value("Number", this.kumiteOppsDefeated())
    function rp_time_tracker() => rich_presence_value("Time", this.timer(), format="FRAMES")
    function rp_match() => rich_presence_value("Number", this.battle() + 1)
    function rp_mode() => rich_presence_lookup("Mode", this.currentMode(), ModeLookup)
    function rp_story_chapter() => rich_presence_lookup("Story", this.storyChapter(), StoryNames)
    function rp_character(index) => rich_presence_lookup("Character", this.playerCharacterID(index), CharacterLookupShort)
    function rp_region() => rich_presence_lookup("Region", serial_1, RegionLookup, fallback="(???)")
    function rp_difficulty() => rich_presence_value("Number", this.options_difficulty() + 1)
    function rp_attackpower() => rich_presence_value("Number", this.options_attackpower() + 1)
}

REGIONS = [
    Region(
        r_name = "US",
        r_flag = "🇺🇸",
        r_mark = "RNEEDA",
        addr_fpack_ptr = 0x0049cef0,
        addr_current_mode = 0x00394eac,
        addr_score = 0x00395ab8,
        addr_match_state_ptr = 0x0038fd0c,
        addr_character_ptr_start = 0x0038fe64,
        addr_kumite_level = 0x003a1414
    ),
    Region(
        r_name = "EU",
        r_flag = "🇪🇺",
        r_mark = "RNEPDA",
        addr_fpack_ptr = 0x0049d770,
        addr_current_mode = 0x0039572c,
        addr_score = 0x00396338,
        addr_match_state_ptr = 0x0039058c,
        addr_character_ptr_start = 0x003906e4,
        addr_kumite_level = 0x003a1c94
    )
]

RegionLookup = {
    0x524e4545: "🇺🇸",
    0x524e4550: "🇪🇺"
}

MATCH_STATE_INTRO = 0
MATCH_STATE_READY = 1
MATCH_STATE_ROUNDNUM = 2
MATCH_STATE_BEGIN = 3
MATCH_STATE_BATTLE = 4
MATCH_STATE_OBJECTIVE = 8
MATCH_STATE_TRANSITION = 9
MATCH_STATE_ROUND_OVER = 0x0a
MATCH_STATE_ROUND_OVER_ANIM = 0x0b
MATCH_STATE_COMPLETE = 0x0d
MATCH_STATE_CONTINUE_PROMPT = 0x0e

MODE_SINGLE_VS = 0
MODE_MULTI_2PLAYER_VS = 1
MODE_MULTI_4PLAYER_VS = 2
MODE_SINGLE_SCORE = 3
MODE_SINGLE_TIME = 4
MODE_SINGLE_SURVIVAL = 5
MODE_SINGLE_SCORE_TWO = 6
MODE_SINGLE_TIME_TWO = 7
MODE_SINGLE_SURVIVAL_TWO = 8
MODE_MULTI_2PLAYER_SCORE = 9
MODE_MULTI_2PLAYER_TIME = 0xa
MODE_MULTI_2PLAYER_SURVIVAL = 0xb
MODE_TRAINING = 0xc
MODE_SINGLE_SPECTATOR = 0xd
MODE_DEMO = 0xf
MODE_KUMITE = 0x10
MODE_SINGLE_VS_TWO = 0x11
MODE_STORY = 0x12
MODE_TUTORIAL = 0x13
MODE_MISSION_1 = 0x14
MODE_MISSION_2 = 0x15
MODE_MISSION_3 = 0x16
MODE_MISSION_4 = 0x17
MODE_MISSION_5 = 0x18
MODE_MISSION_6 = 0x19
MODE_MISSION_7 = 0x1a
MODE_MISSION_8 = 0x1b
MODE_MISSION_9 = 0x1c
MODE_MISSION_10 = 0x1d
MODE_TRAINING_SQUAD = 0x1e
MODE_SPECTATOR_THREE_FOUR = 0x1f
MODE_SPECTATOR_TWO = 0x20

CHARACTER_NARUTO = 0x01
CHARACTER_SAKURA = 0x02
CHARACTER_KAKASHI = 0x03
CHARACTER_LEE = 0x04
CHARACTER_NEJI = 0x05
CHARACTER_TENTEN = 0x06
CHARACTER_GUY = 0x07
CHARACTER_GAARA = 0x08
CHARACTER_TEMARI = 0x09
CHARACTER_WINDWEASEL = 0x0a // Temari Sub
CHARACTER_KANKURO = 0x0b
CHARACTER_CROW = 0x0c // Kankuro Sub
CHARACTER_KURO = 0x0d // Kankuro Sub
CHARACTER_SHINO = 0x0e
CHARACTER_KIBA = 0x0f
CHARACTER_AKAMARU = 0x10 // Kiba Sub
CHARACTER_HINATA = 0x11
CHARACTER_CHOJI = 0x12
CHARACTER_SHIKMARU = 0x13
//0x14 unused?
CHARACTER_SAI = 0x15
CHARACTER_YAMATO = 0x16
CHARACTER_SASUKE = 0x17
CHARACTER_ITACHI = 0x18
CHARACTER_KISAME = 0x19
CHARACTER_DEIDARA = 0x1a
CHARACTER_HIRUKO = 0x1b
CHARACTER_SASORI = 0x1c
CHARACTER_JIRAIYA = 0x1d
CHARACTER_TOAD = 0x1e // Jiraiya Sub
CHARACTER_TSUNADE = 0x1f
CHARACTER_OROCHIMARU = 0x20
CHARACTER_KABUTO = 0x21
CHARACTER_ASUMA = 0x22
CHARACTER_ANKO = 0x23
CHARACTER_KURENAI = 0x24
CHARACTER_YUGAO = 0x25
CHARACTER_BAKI = 0x26
CHARACTER_BANDO = 0x27
CHARACTER_KOMACHI = 0x28
CHARACTER_KAGURA = 0x29
CHARACTER_TOWA = 0x2a
//0x2b unused?
CHARACTER_CHIYO = 0x2c
CHARACTER_FATHER = 0x2d // Chiyo Sub
CHARACTER_MOTHER = 0x2e // Chiyo Sub
CHARACTER_HIDAN = 0x2f
CHARACTER_KAKUZU = 0x30
CHARACTER_ANBUKAKASHI = 0x31

UNLOCK_TIME_ATTACK = 4
UNLOCK_SURVIVAL = 5
UNLOCK_KUMITE = 6
UNLOCK_MISSION_LIST = 7
UNLOCK_2P_TIME_ATTACK = 11
UNLOCK_2P_SURVIVAL = 12

UNLOCK_NARUTO = 55
UNLOCK_SAKURA = 56
UNLOCK_KAKASHI = 57
UNLOCK_LEE = 58
UNLOCK_NEJI = 59
UNLOCK_TENTEN = 60
UNLOCK_GUY = 61
UNLOCK_GAARA = 62
UNLOCK_TEMARI = 63
UNLOCK_KANKURO = 65
UNLOCK_SHINO = 68
UNLOCK_KIBA = 69
UNLOCK_HINATA = 71
UNLOCK_CHOJI = 72
UNLOCK_SHIKAMARU = 73
UNLOCK_SAI = 75
UNLOCK_YAMATO = 76
UNLOCK_SASUKE = 77
UNLOCK_ITACHI = 78
UNLOCK_KISAME = 79
UNLOCK_DEIDARA = 80
UNLOCK_HIRUKO = 81
UNLOCK_SASORI = 82
UNLOCK_JIRAIYA = 83
UNLOCK_TSUNADE = 85
UNLOCK_OROCHIMARU = 86
UNLOCK_KABUTO = 87
UNLOCK_ASUMA = 88
UNLOCK_ANKO = 89
UNLOCK_KURENAI = 90
UNLOCK_YUGAO = 91
UNLOCK_BAKI = 92
UNLOCK_BANDO = 93
UNLOCK_KOMACHI = 94
UNLOCK_KAGURA = 95
UNLOCK_TOWA = 96
UNLOCK_GRANNY_CHIYO = 98
UNLOCK_HIDAN = 101
UNLOCK_KAKUZU = 102
UNLOCK_ANBU_KAKASHI = 103
UNLOCK_CHUNIN_EXAMS_FINALS = 108
UNLOCK_LEAF_FOREST = 109
UNLOCK_TANZAKU_CASTLE = 110
UNLOCK_NINE_TAILED_FOX_ROOM = 112
UNLOCK_HIDDEN_LEAF_VILLAGE_MAIN_GATE = 114
UNLOCK_HIDDEN_LEAF_VILLAGE_RIVERSIDE = 115
UNLOCK_HIDDEN_LEAF_VILLAGE_PILLAR_CHAMBER = 116
UNLOCK_FOREST_AT_NIGHT = 117
UNLOCK_HIDDEN_LEAF_VILLAGE_NIGHT = 118
UNLOCK_FOREST_HIDEOUT = 119
UNLOCK_WAREHOUSE_ROAD = 120
UNLOCK_SHIRATO_STREET = 121
UNLOCK_INTERSECTION = 122
UNLOCK_THIRD_TRAINING_FIELD = 124
UNLOCK_HIDDEN_SAND_VILLAGE_ENTRANCE = 125
UNLOCK_SILENT_SHRINE = 126
UNLOCK_AKATSUKI_HIDEOUT = 127

UNLOCK_ATTACK_STRENGTH_4 = 129
UNLOCK_DIFFICULTY_4 = 130

GROUP_UNLOCK_CHAR = [
    //UNLOCK_NARUTO,
    //UNLOCK_SAKURA,
    //UNLOCK_KAKASHI,
    //UNLOCK_LEE,
    //UNLOCK_NEJI,
    //UNLOCK_TENTEN,
    //UNLOCK_GUY,
    //UNLOCK_GAARA,
    UNLOCK_TEMARI,
    UNLOCK_KANKURO,
    UNLOCK_SHINO,
    UNLOCK_KIBA,
    UNLOCK_HINATA,
    UNLOCK_CHOJI,
    UNLOCK_SHIKAMARU,
    UNLOCK_SAI,
    UNLOCK_YAMATO,
    UNLOCK_SASUKE,
    UNLOCK_ITACHI,
    UNLOCK_KISAME,
    UNLOCK_DEIDARA,
    UNLOCK_HIRUKO,
    UNLOCK_SASORI,
    UNLOCK_JIRAIYA,
    UNLOCK_TSUNADE,
    UNLOCK_OROCHIMARU,
    UNLOCK_KABUTO,
    UNLOCK_ASUMA,
    UNLOCK_ANKO,
    UNLOCK_KURENAI,
    UNLOCK_YUGAO,
    UNLOCK_BAKI,
    UNLOCK_BANDO,
    UNLOCK_KOMACHI,
    UNLOCK_KAGURA,
    UNLOCK_TOWA,
    UNLOCK_GRANNY_CHIYO,
    UNLOCK_HIDAN,
    UNLOCK_KAKUZU,
    UNLOCK_ANBU_KAKASHI,
]

GROUP_UNLOCK_STAGE = [
    UNLOCK_CHUNIN_EXAMS_FINALS,
    UNLOCK_LEAF_FOREST,
    UNLOCK_TANZAKU_CASTLE,
    UNLOCK_NINE_TAILED_FOX_ROOM,
    UNLOCK_HIDDEN_LEAF_VILLAGE_MAIN_GATE,
    UNLOCK_HIDDEN_LEAF_VILLAGE_RIVERSIDE,
    UNLOCK_HIDDEN_LEAF_VILLAGE_PILLAR_CHAMBER,
    UNLOCK_FOREST_AT_NIGHT,
    UNLOCK_HIDDEN_LEAF_VILLAGE_NIGHT,
    UNLOCK_FOREST_HIDEOUT,
    UNLOCK_WAREHOUSE_ROAD,
    UNLOCK_SHIRATO_STREET,
    UNLOCK_INTERSECTION,
    UNLOCK_THIRD_TRAINING_FIELD,
    UNLOCK_HIDDEN_SAND_VILLAGE_ENTRANCE,
    UNLOCK_SILENT_SHRINE,
    UNLOCK_AKATSUKI_HIDEOUT,
]

GROUP_UNLOCK_MODE = [
    UNLOCK_TIME_ATTACK,
    UNLOCK_SURVIVAL,
    UNLOCK_KUMITE,
    UNLOCK_MISSION_LIST,
    UNLOCK_2P_TIME_ATTACK,
    UNLOCK_2P_SURVIVAL,
    UNLOCK_ATTACK_STRENGTH_4,
    UNLOCK_DIFFICULTY_4,
]


function minutes(m) => m * 3600
function seconds(s) => s * 60

function ach(ach, t) {
    achievement(
        title = ach[0],
        points = ach[2],
        description = ach[1],
        trigger = ach[3],
        type=t
    )
}

ModeLookup = {
    MODE_SINGLE_VS: "Versus",
    MODE_MULTI_2PLAYER_VS: "Versus",
    MODE_MULTI_4PLAYER_VS: "Versus",
    MODE_SINGLE_SCORE: "Score",
    MODE_SINGLE_TIME: "Time Attack",
    MODE_SINGLE_SURVIVAL: "Survival",
    MODE_MULTI_2PLAYER_SCORE: "Score Attack (2P)",
    MODE_MULTI_2PLAYER_TIME: "Time Attack (2P)",
    MODE_MULTI_2PLAYER_SURVIVAL: "Survival (2P)",
    MODE_TRAINING: "Training",
    MODE_SINGLE_SPECTATOR: "Spectator",
    MODE_SPECTATOR_TWO: "Spectator",
    MODE_SPECTATOR_THREE_FOUR: "Spectator",
    MODE_MISSION_1: "Mission 1",
    MODE_MISSION_2: "Mission 2",
    MODE_MISSION_3: "Mission 3",
    MODE_MISSION_4: "Mission 4",
    MODE_MISSION_5: "Mission 5",
    MODE_MISSION_6: "Mission 6",
    MODE_MISSION_7: "Mission 7",
    MODE_MISSION_8: "Mission 8",
    MODE_MISSION_9: "Mission 9",
    MODE_MISSION_10: "Mission 10",
    MODE_DEMO: "Demo",
    MODE_SINGLE_VS_TWO: "Versus",
    MODE_SINGLE_SCORE_TWO: "Score Attack",
    MODE_SINGLE_TIME_TWO: "Time Attack",
    MODE_KUMITE: "Kumite",
    MODE_TRAINING_SQUAD: "Squad Training",
    MODE_TUTORIAL: "Tutorial",
    MODE_STORY: "Story"
}

CharacterLookup = {
    CHARACTER_NARUTO: "Naruto",
    CHARACTER_SASUKE: "Sasuke",
    CHARACTER_SAKURA: "Sakura",
    CHARACTER_LEE: "Rock Lee",
    CHARACTER_SHIKMARU: "Shikamaru",
    CHARACTER_GAARA: "Gaara",
    CHARACTER_TEMARI: "Temari",
    CHARACTER_KANKURO: "Kankuro",
    CHARACTER_KAKASHI: "Kakashi",
    CHARACTER_GUY: "Might Guy",
    CHARACTER_JIRAIYA: "Jiraiya",
    CHARACTER_TSUNADE: "Tsunade",
    CHARACTER_OROCHIMARU: "Orochimaru",
    CHARACTER_ITACHI: "Itachi",
    CHARACTER_NEJI: "Neji",
    CHARACTER_TENTEN: "Tenten",
    CHARACTER_HINATA: "Hinata",
    CHARACTER_CHOJI: "Choji",
    CHARACTER_KISAME: "Kisame",
    CHARACTER_SHINO: "Shino",
    CHARACTER_ASUMA: "Asuma",
    CHARACTER_KABUTO: "Kabuto",
    CHARACTER_ANKO: "Anko",
    CHARACTER_KIBA: "Kiba",
    CHARACTER_KURENAI: "Kurenai",
    CHARACTER_YUGAO: "Yugao",
    CHARACTER_BAKI: "Baki",
    CHARACTER_BANDO: "Bando",
    CHARACTER_KOMACHI: "Komachi",
    CHARACTER_KAGURA: "Kagura",
    CHARACTER_TOWA: "Towa",
    CHARACTER_CHIYO: "Granny Chiyo",
    CHARACTER_SAI: "Sai",
    CHARACTER_YAMATO: "Yamato",
    CHARACTER_DEIDARA: "Deidara",
    CHARACTER_HIRUKO: "Hiruko",
    CHARACTER_SASORI: "Sasori",
    CHARACTER_HIDAN: "Hidan",
    CHARACTER_KAKUZU: "Kakuzu",
    CHARACTER_ANBUKAKASHI: "Anbu Kakashi",
}

CharacterLookupShort = {
    CHARACTER_NARUTO: "Naruto",
    CHARACTER_SASUKE: "Sasuke",
    CHARACTER_SAKURA: "Sakura",
    CHARACTER_LEE: "Rock Lee",
    CHARACTER_SHIKMARU: "Shikamaru",
    CHARACTER_GAARA: "Gaara",
    CHARACTER_TEMARI: "Temari",
    CHARACTER_KANKURO: "Kankuro",
    CHARACTER_KAKASHI: "Kakashi",
    CHARACTER_GUY: "Might Guy",
    CHARACTER_JIRAIYA: "Jiraiya",
    CHARACTER_TSUNADE: "Tsunade",
    CHARACTER_OROCHIMARU: "Orochimaru",
    CHARACTER_ITACHI: "Itachi",
    CHARACTER_NEJI: "Neji",
    CHARACTER_TENTEN: "Tenten",
    CHARACTER_HINATA: "Hinata",
    CHARACTER_CHOJI: "Choji",
    CHARACTER_KISAME: "Kisame",
    CHARACTER_SHINO: "Shino",
    CHARACTER_ASUMA: "Asuma",
    CHARACTER_KABUTO: "Kabuto",
    CHARACTER_ANKO: "Anko",
    CHARACTER_KIBA: "Kiba",
    CHARACTER_KURENAI: "Kurenai",
    CHARACTER_YUGAO: "Yugao",
    CHARACTER_BAKI: "Baki",
    CHARACTER_BANDO: "Bando",
    CHARACTER_KOMACHI: "Komachi",
    CHARACTER_KAGURA: "Kagura",
    CHARACTER_TOWA: "Towa",
    CHARACTER_CHIYO: "Chiyo",
    CHARACTER_SAI: "Sai",
    CHARACTER_YAMATO: "Yamato",
    CHARACTER_DEIDARA: "Deidara",
    CHARACTER_HIRUKO: "Hiruko",
    CHARACTER_SASORI: "Sasori",
    CHARACTER_HIDAN: "Hidan",
    CHARACTER_KAKUZU: "Kakuzu",
    CHARACTER_ANBUKAKASHI: "Anbu Kakashi",
}

StoryNames = {
    1: "Chapter One - Episode One",
    2: "Chapter One - Episode Two",
    3: "Chapter One - Episode Three",
    4: "Chapter One - Episode Four",
    5: "Chapter One - Episode Five",
    6: "Chapter Two - Episode One",
    7: "Chapter Two - Episode Two",
    8: "Chapter Two - Episode Three",
    9: "Chapter Two - Episode Four",
    10: "Chapter Two - Episode Five",
    11: "Chapter Three - Episode One",
    12: "Chapter Three - Episode Two",
    13: "Chapter Three - Episode Three",
    14: "Chapter Three - Episode Four",
    15: "Chapter Three - Episode Five",
    16: "Chapter Three - Episode Six",
    17: "Chapter Three - Episode Seven"
}

MissionNames = {
    MODE_MISSION_1: "A Clash of Rivals!",
    MODE_MISSION_2: "Two Man Squad!",
    MODE_MISSION_3: "10 Straight Battles!",
    MODE_MISSION_4: "Secret Tech. K.O!",
    MODE_MISSION_5: "No Substitution!",
    MODE_MISSION_6: "No Health Recovery!",
    MODE_MISSION_7: "Hit Combo Challenge!",
    MODE_MISSION_8: "1-on-3 Battle!",
    MODE_MISSION_9: "Two Man Squad!",
    MODE_MISSION_10: "Rival Match-Up!",
}

function rp_region() => rich_presence_lookup("Region", serial_1, RegionLookup, fallback="(???)")

for r in REGIONS {
    // Menus
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("menu/main"),"Title Screen [🕒{1} ⚖️{2} 🗡️{3}] {0}",
        rp_region(),
        r.rp_playtime(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("menu/chrsel"),"Character Select [🕒{1} ⚖️{2} 🗡️{3}] {0}",
        rp_region(),
        r.rp_playtime(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("menu/mission"),"Mission Select [🕒{1} ⚖️{2} 🗡️{3}] {0}",
        rp_region(),
        r.rp_playtime(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("menu/extra/shop"),"Shop [🕒{1} ⚖️{2} 🗡️{3}] {0}",
        rp_region(),
        r.rp_playtime(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("menu/extra/playdata"),"Ninja Info Card [🕒{1} ⚖️{2} 🗡️{3}] {0}",
        rp_region(),
        r.rp_playtime(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("menu/extra/sound"),"Media Player [🕒{1} ⚖️{2} 🗡️{3}] {0}",
        rp_region(),
        r.rp_playtime(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("menu/wifi"),"Wifi Information [🕒{1} ⚖️{2} 🗡️{3}] {0}",
        rp_region(),
        r.rp_playtime(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("staff"),"Viewing Credits [🕒{1} ⚖️{2} 🗡️{3}] {0}",
        rp_region(),
        r.rp_playtime(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )


    // Extras
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("menu/extra/rank"),"Viewing Rankings [🕒{1} ⚖️{2} 🗡️{3}] {0}",
        rp_region(),
        r.rp_playtime(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("event/"),"Story [🕒{1} ⚖️{2} 🗡️{3}] {0}",
        rp_region(),
        r.rp_playtime(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

// Multi
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && !r.inStoryMode() && r.currentMode() == MODE_MULTI_4PLAYER_VS && r.playerCharacterID(3) == 0,"Multi | {1}, {2}, {5} [🕒{3} ⚖️{7} 🗡️{8}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && !r.inStoryMode() && r.currentMode() == MODE_MULTI_4PLAYER_VS,"Multi | {1}, {2}, {5}, {6} [🕒{3} ⚖️{7} 🗡️{8}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

// Kumite
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && !r.inStoryMode() && r.currentMode() == MODE_KUMITE,"Kumite [Level {8}] [{7} Defeated] {1} vs Rogue Ninja [🕒{3} ⚖️{9} 🗡️{10}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_opps_defeated(),
        r.rp_kumite_level(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

// Survival
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && !r.inStoryMode() && r.currentMode() == MODE_SINGLE_SURVIVAL,"Survival [Battle {8}] {1} vs {2} [🕒{3} ⚖️{9} 🗡️{10}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_score_tracker(),
        r.rp_match(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && !r.inStoryMode() && r.currentMode() == MODE_SINGLE_SURVIVAL_TWO,"Survival [Battle {8}] {1}, {5} vs {2}, {6} [🕒{3} ⚖️{9} 🗡️{10}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_score_tracker(),
        r.rp_match(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && !r.inStoryMode() && r.currentMode() == MODE_MULTI_2PLAYER_SURVIVAL,"Survival (2P) [Battle {8}] {1}, {2} vs {5}, {6} [🕒{3} ⚖️{9} 🗡️{10}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_score_tracker(),
        r.rp_match(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

//Time Attack
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && !r.inStoryMode() && r.currentMode() == MODE_SINGLE_TIME_TWO,"Time Attack [Battle {8}] [{7}] {1}, {5} vs {2}, {6} [🕒{3} ⚖️{9} 🗡️{10}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_time_tracker(),
        r.rp_match(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && !r.inStoryMode() && r.currentMode() == MODE_SINGLE_TIME,"Time Attack [Battle {8}] [{7}] {1} vs {2} [🕒{3} ⚖️{9} 🗡️{10}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_time_tracker(),
        r.rp_match(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && !r.inStoryMode() && r.currentMode() == MODE_MULTI_2PLAYER_TIME,"Time Attack (2P) [Battle {8}] [{7}] {1}, {2} vs {5}, {6} [🕒{3} ⚖️{9} 🗡️{10}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_time_tracker(),
        r.rp_match(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

// Score Attack
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && !r.inStoryMode() && r.currentMode() == MODE_SINGLE_SCORE,"Score Attack [Battle {8}] [Score {7}] {1} vs {2} [🕒{3} ⚖️{9} 🗡️{10}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_score_tracker(),
        r.rp_match(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && !r.inStoryMode() && r.currentMode() == MODE_SINGLE_SCORE_TWO,"Score Attack [Battle {8}] [Score {7}] {1}, {5} vs {2}, {6} [🕒{3} ⚖️{9} 🗡️{10}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_score_tracker(),
        r.rp_match(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && !r.inStoryMode() && r.currentMode() == MODE_MULTI_2PLAYER_SCORE,"Score Attack (2P) [Battle {8}] [Score {7}] {1}, {2} vs {5}, {6} [🕒{3} ⚖️{9} 🗡️{10}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_score_tracker(),
        r.rp_match(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

//Spectator
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && !r.inStoryMode() && r.currentMode() == MODE_SPECTATOR_TWO,"Spectator | {1}, {5} vs {2}, {6} [🕒{3} ⚖️{7} 🗡️{8}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && !r.inStoryMode() && r.currentMode() == MODE_SPECTATOR_THREE_FOUR && r.playerCharacterID(3) == 0,"Spectator | {1}, {5}, {2} [🕒{3} ⚖️{7} 🗡️{8}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_difficulty(),
        r.rp_attackpower()
    )
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && !r.inStoryMode() && r.currentMode() == MODE_SPECTATOR_THREE_FOUR,"Spectator | {1}, {5}, {2}, {6} [🕒{3} ⚖️{7} 🗡️{8}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

// Versus
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && !r.inStoryMode() && r.currentMode() == MODE_SINGLE_VS_TWO,"Versus | {1}, {5} vs {2}, {6} [🕒{3} ⚖️{7} 🗡️{8}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

// Training
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && !r.inStoryMode() && r.currentMode() == MODE_TRAINING_SQUAD,"Squad Training | {1}, {5} vs {2}, {6} [🕒{3} ⚖️{7} 🗡️{8}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

// Story
    //Overrides
    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && r.inStoryMode() && r.currentMode() == MODE_STORY && __ornext(r.storyChapter() == 0x04 || r.storyChapter() == 0x0b || r.storyChapter() == 0x0d || r.storyChapter() == 0x10),"Story - {0} | {1}, {5} vs {2} [🕒{3} ⚖️{7} 🗡️{8}] {4}",
        r.rp_story_chapter(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && r.inStoryMode() && r.currentMode() == MODE_STORY && (r.storyChapter() == 0x09 || r.storyChapter() == 0x0e),"Story - {0} | {1}, {2} vs {5} [🕒{3} ⚖️{7} 🗡️{8}] {4}",
        r.rp_story_chapter(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && r.inStoryMode() && r.currentMode() == MODE_STORY && r.storyChapter() == 0x0a && r.playerCharacterID(0) == CHARACTER_GUY,"Story - {0} | Might Guy vs Kisame [🕒{3} ⚖️{7} 🗡️{8}] {4}",
        r.rp_story_chapter(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && r.inStoryMode() && r.currentMode() == MODE_STORY && r.storyChapter() == 0x0a,"Story - {0} | {1}, {5}, {2} vs {6} [🕒{3} ⚖️{7} 🗡️{8}] {4}",
        r.rp_story_chapter(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && r.inStoryMode() && r.currentMode() == MODE_STORY && r.storyChapter() == 0x05,"Story - {0} | {1} vs {2}, {6} [🕒{3} ⚖️{7} 🗡️{8}] {4}",
        r.rp_story_chapter(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_character(2),
        r.rp_character(3),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

    rich_presence_conditional_display(r.isRegion() && r.currentSeqIs("game/game") && r.inStoryMode() && r.currentMode() == MODE_STORY,"Story - {0} | {1} vs {2} [🕒{3} ⚖️{5} 🗡️{6}] {4}",
        r.rp_story_chapter(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

// (other battles)
    rich_presence_conditional_display(r.isRegion() && !r.inStoryMode() && r.currentSeqIs("game/game"),"{0} | {1} vs {2} [🕒{3} ⚖️{5} 🗡️{6}] {4}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_character(1),
        r.rp_playtime(),
        rp_region(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )

    rich_presence_conditional_display(r.isRegion() && !r.inStoryMode() && r.currentSeqIs("menu/result"),"{0} [Viewing Results] {1} [🕒{2} ⚖️{4} 🗡️{5}] {3}",
        r.rp_mode(),
        r.rp_character(0),
        r.rp_playtime(),
        rp_region(),
        r.rp_difficulty(),
        r.rp_attackpower()
    )
}

rich_presence_display("Loading...")

BATTLERS = range(0,12)
//3 - Naruto,Itachi,Yugao,Kankuro,Chiyo
//2 - Kisame,Yamato,Temari,Kiba

function achAnyCharacterPerformAction(act_id) => any_of(REGIONS, r =>
            r.isRegion() &&
            r.seqActive() &&
            r.inBattle() &&
            any_of(BATTLERS, b => 
                r.charIsAlive(b) &&
                r.charIsHuman(b) && 
                r.char(b)["act_id"] == act_id &&
                has_changed(r.char(b)["act_id"])
            )
        )

function achCharacterPerformAction(char_id, act_id) => any_of(REGIONS, r =>
            r.isRegion() &&
            r.seqActive() &&
            r.inBattle() &&
            any_of(BATTLERS, b => 
                r.charIsAlive(b) &&
                r.charIsHuman(b) && 
                r.char(b)["character_id"] == char_id &&
                r.char(b)["act_id"] == act_id &&
                has_changed(r.char(b)["act_id"])
            )
        )

function achCharacterPerformActionAgainst(char_id, act_id, enemy_id) => any_of(REGIONS, r =>
            r.isRegion() &&
            r.seqActive() &&
            r.inBattle() &&
            any_of(BATTLERS, b => 
                r.charIsAlive(b) &&
                r.charIsHuman(b) && 
                r.char(b)["character_id"] == char_id &&
                r.char(b)["act_id"] == act_id &&
                has_changed(r.char(b)["act_id"]) &&
                r.char(b)["target_ptr"] != 0 &&
                r.charTargetID(b) == enemy_id
            )
        )

function achCharacterPerformActionAgainst(char_id, act_id, enemy_id) => any_of(REGIONS, r =>
            r.isRegion() &&
            r.seqActive() &&
            r.inBattle() &&
            any_of(BATTLERS, b => 
                r.charIsAlive(b) &&
                r.charIsHuman(b) && 
                r.char(b)["character_id"] == char_id &&
                r.char(b)["act_id"] == act_id &&
                has_changed(r.char(b)["act_id"]) &&
                r.char(b)["target_ptr"] != 0 &&
                r.charTargetID(b) == enemy_id
            )
        )

function achOrochimaruSeal() => any_of(REGIONS, r =>
            r.isRegion() &&
            r.seqActive() &&
            r.inBattle() &&
            any_of(BATTLERS, b => 
                r.charIsAlive(b) &&
                r.charIsHuman(b) && 
                r.char(b)["character_id"] == CHARACTER_OROCHIMARU &&
                prior(r.char(b)["act_id"]) == 0x193 &&
                r.char(b)["target_ptr"] != 0 &&
                r.charTargetTransformStatus(b) == 0 &&
                prev(r.charTargetTransformStatus(b)) != 0
            )
        )

function achStoryCompleteAnyDifficulty(m) => any_of(REGIONS, r =>
            r.isRegion() &&
            r.seqActive() &&
            r.inBattle() &&
            r.currentSeqIs("game/game") &&
            __ornext(
                r.currentMode() == MODE_STORY ||
                r.currentMode() == 2
            ) &&
            r.storyChapter() == m &&
            __ornext(
                has_increased(r.storyFlag(m,0)) ||
                has_increased(r.storyFlag(m,1)) ||
                has_increased(r.storyFlag(m,2)) ||
                has_increased(r.storyFlag(m,3))
            )
        )

function achCharacterHokageAllMissions(char_id) => any_of(REGIONS, r =>
            r.currentSeqIs("menu/result") &&
            measured(r.missionsHokageForChar(char_id) == 10, when=r.isRegion() && r.seqActive()) &&
            prev(r.missionsHokageForChar(char_id)) == 9
        )

function achCharacterAllMissions(char_id) => any_of(REGIONS, r =>
            r.currentSeqIs("menu/result") &&
            r.missionRank(char_id, 0) <= 5 &&
            r.missionRank(char_id, 1) <= 5 &&
            r.missionRank(char_id, 2) <= 5 &&
            r.missionRank(char_id, 3) <= 5 &&
            r.missionRank(char_id, 4) <= 5 &&
            r.missionRank(char_id, 5) <= 5 &&
            r.missionRank(char_id, 6) <= 5 &&
            r.missionRank(char_id, 7) <= 5 &&
            r.missionRank(char_id, 8) <= 5 &&
            r.missionRank(char_id, 9) <= 5 &&
            __ornext(
                prev(r.missionRank(char_id, 0)) >= 6 ||
                prev(r.missionRank(char_id, 1)) >= 6 ||
                prev(r.missionRank(char_id, 2)) >= 6 ||
                prev(r.missionRank(char_id, 3)) >= 6 ||
                prev(r.missionRank(char_id, 4)) >= 6 ||
                prev(r.missionRank(char_id, 5)) >= 6 ||
                prev(r.missionRank(char_id, 6)) >= 6 ||
                prev(r.missionRank(char_id, 7)) >= 6 ||
                prev(r.missionRank(char_id, 8)) >= 6 ||
                prev(r.missionRank(char_id, 9)) >= 6
            )
            //measured(r.missionsCompleteForChar(char_id) == 10, when=r.isRegion() && r.seqActive()) &&
            //prev(r.missionsCompleteForChar(char_id)) == 9
        )

function achKakashiSharinganCopy() => any_of(REGIONS, r =>
            r.isRegion() &&
            r.seqActive() &&
            r.inBattle() &&
            any_of(BATTLERS, b => 
                r.charIsAlive(b) &&
                r.charIsHuman(b) && 
                r.char(b)["character_id"] == CHARACTER_KAKASHI &&
                r.char(b)["act_id"] >= 0x198 &&
                r.char(b)["act_id"] <= 0x19c &&
                has_changed(r.char(b)["act_id"])
            )
        )

function achChojiChips() => any_of(REGIONS, r =>
            r.isRegion() &&
            r.seqActive() &&
            r.inBattle() &&
            any_of(BATTLERS, b => 
                r.charIsAlive(b) &&
                r.charIsHuman(b) && 
                r.char(b)["character_id"] == CHARACTER_CHOJI &&
                r.char(b)["attack_multiplier"] == 1.5 &&
                has_increased(r.char(b)["attack_multiplier"])
            )
        )

function achTimeAttackHokage() => any_of(REGIONS, r =>
            r.isRegion() &&
            !r.inStoryMode() && 
            r.currentMode() == MODE_SINGLE_TIME &&
            r.inBattle() &&
            r.isDefaultSettings() &&
            trigger_when(r.isCompletingLastMatch()) &&
            trigger_when(r.timer() < minutes(6))
        )

function achScoreAttack() => any_of(REGIONS, r =>
            r.isRegion() &&
            !r.inStoryMode() && 
            __ornext(r.currentMode() == MODE_SINGLE_SCORE || r.currentMode() == MODE_SINGLE_SCORE_TWO)&&
            r.currentSeqIs("game/game") &&
            r.isCompletingLastMatch()
        )

function achTimeAttack() => any_of(REGIONS, r =>
            r.isRegion() &&
            !r.inStoryMode() && 
            __ornext(r.currentMode() == MODE_SINGLE_TIME || r.currentMode() == MODE_SINGLE_TIME_TWO) &&
            r.inBattle() &&
            r.isCompletingLastMatch() &&
            r.timer() < minutes(13)
        )

function achSinglePlayerScore(target) => any_of(REGIONS, r =>
            r.isRegion() &&
            !r.inStoryMode() && 
            r.currentMode() == MODE_SINGLE_SCORE &&
            r.isDefaultSettings() &&
            r.currentSeqIs("game/game") &&
            trigger_when(r.isCompletingLastMatch()) &&
            trigger_when(r.score() >= target)
        )

function achSinglePlayerSquadScore(target) => any_of(REGIONS, r =>
            r.isRegion() &&
            !r.inStoryMode() && 
            r.currentMode() == MODE_SINGLE_SCORE_TWO &&
            r.isDefaultSettings() &&
            r.currentSeqIs("game/game") &&
            trigger_when(r.isCompletingLastMatch()) &&
            trigger_when(r.score() >= target)
        )

function achTimeAttackSquadHokage() => any_of(REGIONS, r =>
            r.isRegion() &&
            !r.inStoryMode() && 
            r.currentMode() == MODE_SINGLE_TIME_TWO &&
            r.inBattle() &&
            r.isDefaultSettings() &&
            r.currentSeqIs("game/game") &&
            trigger_when(r.isCompletingLastMatch()) &&
            trigger_when(r.timer() < minutes(6))
        )

function achSurvival(amt) => any_of(REGIONS, r =>
            r.isRegion() &&
            !r.inStoryMode() && 
            r.currentMode() == MODE_SINGLE_SURVIVAL &&
            r.currentSeqIs("game/game") &&
            trigger_when(r.battle() >= amt) &&
            trigger_when(r.inBattle()) &&
            trigger_when(r.playerLostRound())
        )

function achSurvivalDefault(amt) => any_of(REGIONS, r =>
            r.isRegion() &&
            !r.inStoryMode() && 
            r.currentMode() == MODE_SINGLE_SURVIVAL &&
            r.isDefaultSettings() &&
            r.currentSeqIs("game/game") &&
            trigger_when(r.battle() >= amt) &&
            trigger_when(r.inBattle()) &&
            trigger_when(r.playerLostRound())
        )

function achSurvivalSquadHokage() => any_of(REGIONS, r =>
            r.isRegion() &&
            !r.inStoryMode() && 
            r.currentMode() == MODE_SINGLE_SURVIVAL_TWO &&
            r.isDefaultSettings() &&
            r.currentSeqIs("game/game") &&
            trigger_when(r.battle() >= 50) &&
            trigger_when(r.inBattle()) &&
            trigger_when(r.playerLostRound())
        )

function achKumiteDefeated(amt) => any_of(REGIONS, r =>
            r.isRegion() &&
            !r.inStoryMode() && 
            r.currentMode() == MODE_KUMITE &&
            r.isDefaultSettings() &&
            r.currentSeqIs("game/game") &&
            trigger_when(r.kumiteOppsDefeated() >= amt) &&
            trigger_when(r.inBattle()) &&
            trigger_when(r.playerLostRound())
        )

function achSumUnlocks(group) => any_of(REGIONS, r =>
            unless(!r.isRegion()) &&
            measured(r.sumUnlocks(group) == length(group), when=r.isRegion()) &&
            prev(r.sumUnlocks(group)) == length(group) - 1 &&
            r.currentSeqIs("menu/extra/shop")
        ) 

function achHidanInstantKill() => any_of(REGIONS, r =>
            r.isRegion() &&
            r.seqActive() &&
            r.inBattle() &&
            any_of(BATTLERS, b => 
                r.charIsAlive(b) &&
                r.charIsHuman(b) && 
                r.char(b)["character_id"] == CHARACTER_HIDAN &&
                r.char(b)["hit_enemy_ptr"] != 0 &&
                r.char(b)["act_id"] == 258 &&
                (
                    (
                        r.charHitID(b) != CHARACTER_CHIYO &&
                        r.charHitID(b) != CHARACTER_KANKURO &&
                        r.charHitHP(b) == 0 &&
                        prev(r.charTargetHP(b)) >= 8000
                    ) ||
                    (
                        r.charHitID(b) == CHARACTER_CHIYO &&
                        r.charHitHP(b) == 0 &&
                        prev(r.charTargetHP(b)) >= 6400
                    ) ||
                    (
                        r.charHitID(b) == CHARACTER_KANKURO &&
                        r.charHitHP(b) == 0 &&
                        prev(r.charTargetHP(b)) >= 7200
                    )
                )
            )
        )

function achChapterTwo() => any_of(REGIONS, r =>
            r.isRegion() &&
            r.seqActive() &&
            r.inBattle() &&
            r.storyChapter() == 10 &&
            r.playerWonRound(0) &&
            r.char(0)["character_id"] == CHARACTER_GUY
)

function achHirukoRoundTimeoutWin() => any_of(REGIONS, r =>
            r.isRegion() &&
            r.seqActive() &&
            r.inBattle() &&
            __ornext(
                r.currentMode() == MODE_SINGLE_SCORE ||
                r.currentMode() == MODE_SINGLE_SURVIVAL ||
                r.currentMode() == MODE_SINGLE_TIME ||
                r.currentMode() == MODE_SINGLE_VS_TWO ||
                r.currentMode() == MODE_MULTI_2PLAYER_VS
            ) &&
            r.matchTimer() <= 1 &&
            has_decreased(r.matchTimer()) && 
            any_of(BATTLERS, b => 
                r.charIsAlive(b) &&
                r.charIsHuman(b) && 
                r.char(b)["character_id"] == CHARACTER_HIRUKO &&
                r.char(b)["hit_enemy_ptr"] != 0 &&
                r.charTargetHP(b) > r.charHP(b) 
            )
        )

AchTitlesMissions = {
    CHARACTER_NARUTO: "Naruto, the Child",
    CHARACTER_SASUKE: "Sasuke, the Cursed",
    CHARACTER_SAKURA: "Sakura, the Powerful",
    CHARACTER_LEE: "Rock Lee, the Energetic",
    CHARACTER_SHIKMARU: "Shikamaru, the Slacker",
    CHARACTER_GAARA: "Gaara, the Kazekage",
    CHARACTER_TEMARI: "Temari, the Blunt",
    CHARACTER_KANKURO: "Kankuro, the Prideful",
    CHARACTER_KAKASHI: "Kakashi, the Perceptive",
    CHARACTER_GUY: "Might Guy, the Youthful",
    CHARACTER_JIRAIYA: "Jiraiya, the Sage",
    CHARACTER_TSUNADE: "Tsunade, the Hokage",
    CHARACTER_OROCHIMARU: "Orochimaru, the Snake",
    CHARACTER_ITACHI: "Itachi, the Methodical",
    CHARACTER_NEJI: "Neji, the Genius",
    CHARACTER_TENTEN: "Tenten, the Skilled",
    CHARACTER_HINATA: "Hinata, the Shy",
    CHARACTER_CHOJI: "Choji, the Hungry",
    CHARACTER_KISAME: "Kisame, the Sadistic",
    CHARACTER_SHINO: "Shino, the Quiet",
    CHARACTER_ASUMA: "Asuma, the Calm",
    CHARACTER_KABUTO: "Kabuto, the Spy",
    CHARACTER_ANKO: "Anko, the Proctor",
    CHARACTER_KIBA: "Kiba, the Impulsive",
    CHARACTER_KURENAI: "Kurenai, the Caring",
    CHARACTER_YUGAO: "Yugao, the Avenger",
    CHARACTER_BAKI: "Baki, the Ruthless",
    CHARACTER_BANDO: "Bando, the Arms Dealer",
    CHARACTER_KOMACHI: "Komachi, the Cat",
    CHARACTER_KAGURA: "Kagura, the Heartless",
    CHARACTER_TOWA: "Towa, the Bird",
    CHARACTER_CHIYO: "Chiyo, the Elder",
    CHARACTER_SAI: "Sai, the Loyal",
    CHARACTER_YAMATO: "Yamato, the Cautious",
    CHARACTER_DEIDARA: "Deidara, the Artist",
    CHARACTER_HIRUKO: "Hiruko, the Puppet",
    CHARACTER_SASORI: "Sasori, the Master",
    CHARACTER_HIDAN: "Hidan, the Immortal",
    CHARACTER_KAKUZU: "Kakuzu, the Treasurer",
    CHARACTER_ANBUKAKASHI: "Anbu Kakashi, the Anbu",
}

AchTitlesHokage = {
    CHARACTER_NARUTO: "I Better Stop Acting like an Idiot",
    CHARACTER_SASUKE: "You Could Never Stop Me",
    CHARACTER_SAKURA: "I'm Not the Same Person I Used to Be",
    CHARACTER_LEE: "Youth Does Not Last Forever",
    CHARACTER_SHIKMARU: "Every Piece Has Its Purpose",
    CHARACTER_GAARA: "I'm Not the Same as I Used to Be",
    CHARACTER_TEMARI: "Drown in the Wind",
    CHARACTER_KANKURO: "Puppets Are Only as Strong as Their Master",
    CHARACTER_KAKASHI: "It Must Feel Good to Be Young",
    CHARACTER_GUY: "The Noble Blue Beast",
    CHARACTER_JIRAIYA: "Maybe I Overdid It a Bit",
    CHARACTER_TSUNADE: "No Matter What, I Can't Lose",
    CHARACTER_OROCHIMARU: "History Is Doomed to Repeat Itself",
    CHARACTER_ITACHI: "The Outcome Is the Same",
    CHARACTER_NEJI: "The Strongest Clan",
    CHARACTER_TENTEN: "Did I Go Too Far?",
    CHARACTER_HINATA: "I Know I Can Fight",
    CHARACTER_CHOJI: "I'm Not Mad, Just Hungry",
    CHARACTER_KISAME: "My Sword Is Thirsty for More",
    CHARACTER_SHINO: "You'll Remember Us",
    CHARACTER_ASUMA: "What Took So Long?",
    CHARACTER_KABUTO: "Oh, Another Dangerous Character",
    CHARACTER_ANKO: "Softer than a Marshmellow",
    CHARACTER_KIBA: "Hold Nothing Back",
    CHARACTER_KURENAI: "Something Nice to Dream About",
    CHARACTER_YUGAO: "I Will Defeat the Enemy",
    CHARACTER_BAKI: "The True Power of Wind",
    CHARACTER_BANDO: "Finished Already?",
    CHARACTER_KOMACHI: "Everything I Do...",
    CHARACTER_KAGURA: "Nothing More than a Pawn",
    CHARACTER_TOWA: "...Is for the Hidden Leaf",
    CHARACTER_CHIYO: "I Must Have Gotten Old After All",
    CHARACTER_SAI: "I Don't Really Care",
    CHARACTER_YAMATO: "This Is Just My Mission",
    CHARACTER_DEIDARA: "All of My Jutsu Are Art",
    CHARACTER_HIRUKO: "Another Candidate to Add to My Collection",
    CHARACTER_SASORI: "Puppets Are Your Friends",
    CHARACTER_HIDAN: "Even an Immortal Can Still Feel Pain",
    CHARACTER_KAKUZU: "Everything's Got a Price, Everything",
    CHARACTER_ANBUKAKASHI: "Finished in a Heartbeat",
}

achs_reg = [
    ["Keeping Score","Complete One Player Single Score Attack with a score of 500,000 or more while Attack Power and Difficulty are set to 2",10,achSinglePlayerScore(500000)],
    ["We Win Together","Complete One Player Squad Score Attack with a score of 500,000 or more while Attack Power and Difficulty are set to 2",10,achSinglePlayerSquadScore(500000)],
    ["Brilliant Speed","Complete One Player Single Time Attack in less than 6 minutes while Attack Power and Difficulty are set to 2",10,achTimeAttackHokage()],
    ["Tag, You're It","Complete One Player Squad Time Attack in less than 6 minutes while Attack Power and Difficulty are set to 2",10,achTimeAttackSquadHokage()],
    ["Last Survivor","Complete One Player Single Survival with at least 50 wins while Attack Power and Difficulty are set to 2",10,achSurvivalDefault(50)],
    ["Enduring Team","Complete One Player Squad Survival with at least 50 wins while Attack Power and Difficulty are set to 2",10,achSurvivalSquadHokage()],
    ["All-Out Combat","Complete One Player Kumite with 300 defeat opponents or more while Attack Power and Difficulty are set to 2",10,achKumiteDefeated(300)],
    ["Pure Synergy","Perform a unique squad jutsu",2,achAnyCharacterPerformAction(0x1d1)],
    ["Again and Again","Perform a Y-Cancel",1,achAnyCharacterPerformAction(0x25)],
    ["Clashing Stars","Deflect thrown projectiles",1,achAnyCharacterPerformAction(0x26)],
    ["Gallery of the Ninja","Purchase every character from the shop",25,achSumUnlocks(GROUP_UNLOCK_CHAR)],
    ["Final Destination","Purchase every stage from the shop",10,achSumUnlocks(GROUP_UNLOCK_STAGE)],
    ["Fiercest of Battles","Purchase every mode and options setting from the shop",10,achSumUnlocks(GROUP_UNLOCK_MODE)],
    ["The More I Eat, the Stronger I Get","Max out your attack power by eating chips as Choji",2,achChojiChips()],
    ["Its Been a While Since I Had to Use Myself","Transform into an enhanced Sasori in a Two Man Squad match as Hiruko",3,achCharacterPerformAction(CHARACTER_SASORI, 0x1d2)],
    ["Judgment Shall Come","As Hidan, instantly kill an opponent who has at least 80% HP left",5,achHidanInstantKill()],
    ["Time Is on My Side","Win a 1v1 round by time out while having less HP than your opponent as Hiruko",5,achHirukoRoundTimeoutWin()],
]

achs_prog = [
    ["The Boy's Back in Town","Complete Chapter One of Story mode",3,achStoryCompleteAnyDifficulty(5)],
    ["Trouble in the Sand","Complete Chapter Two of Story mode",5,achChapterTwo()]
]

achs_win = [
    ["Explosive Finale","Complete Chapter Three of Story mode",10,achStoryCompleteAnyDifficulty(17)]
]

for char_id in CharacterLookup {
    char_name = CharacterLookup[char_id]
    ach([AchTitlesMissions[char_id],format("Achieve Genin rank or higher in all of {0}'s missions",char_name),10,achCharacterAllMissions(char_id)],"")
}

for char_id in CharacterLookup {
    char_name = CharacterLookup[char_id]
    ach([AchTitlesHokage[char_id],format("Achieve Hokage ranks in all of {0}'s missions",char_name),25,achCharacterHokageAllMissions(char_id)],"")
}

for a in achs_reg ach(a,"")
for a in achs_prog ach(a,"progression")
for a in achs_win ach(a,"win_condition")

// Score Attack
for char_id in CharacterLookup {
    char_name = CharacterLookup[char_id]

    // Single Player
    leaderboard(
        title = format("Single Score Attack - {0}",char_name),
        description = "Highest Score (Default Options)",
        start = any_of(REGIONS, r =>
                    r.isRegion() &&
                    r.playerCharacterID(0) == char_id &&
                    !r.inStoryMode() && 
                    r.currentMode() == MODE_SINGLE_SCORE && 
                    r.inBattle() &&
                    r.isDefaultSettings() &&
                    r.isCompletingLastMatch()
                ),
        cancel = always_false(),
        submit = always_true(),
        value  = max_of(
            array_map(REGIONS, r => measured(r.score(), when=r.isRegion()))
            ),
        format = "VALUE"
    )
}

// Time Attack
for char_id in CharacterLookup {
    char_name = CharacterLookup[char_id]

    // Single Player
    leaderboard(
        title = format("Single Time Attack - {0}",char_name),
        description = "Lowest Time",
        start = any_of(REGIONS, r =>
                    r.isRegion() &&
                    r.playerCharacterID(0) == char_id &&
                    !r.inStoryMode() && 
                    r.currentMode() == MODE_SINGLE_TIME && 
                    r.inBattle() &&
                    r.isDefaultSettings() &&
                    r.isCompletingLastMatch()
                ),
        cancel = always_false(),
        submit = always_true(),
        value  = max_of(
            array_map(REGIONS, r => measured(r.timer(), when=r.isRegion()))
            ),
        format = "FRAMES", lower_is_better = true
    )
}

// Survival
for char_id in CharacterLookup {
    char_name = CharacterLookup[char_id]

    // Single Player
    leaderboard(
        title = format("Single Survival - {0}",char_name),
        description = "Most Wins (Default Options)",
        start = any_of(REGIONS, r =>
                    r.isRegion() &&
                    r.playerCharacterID(0) == char_id &&
                    !r.inStoryMode() && 
                    r.currentMode() == MODE_SINGLE_SURVIVAL && 
                    r.inBattle() &&
                    r.isDefaultSettings() &&
                    r.playerLostRound()
                ),
        cancel = always_false(),
        submit = always_true(),
        value  = max_of(
            array_map(REGIONS, r => measured(r.battle(), when=r.isRegion()))
            ),
        format = "VALUE"
    )
}

// Kumite
for char_id in CharacterLookup {
    char_name = CharacterLookup[char_id]

    leaderboard(
        title = format("Kumite - {0}",char_name),
        description = "Most Opponents Defeated (Default Options)",
        start = any_of(REGIONS, r =>
                    r.isRegion() &&
                    r.playerCharacterID(0) == char_id &&
                    !r.inStoryMode() && 
                    r.currentMode() == MODE_KUMITE && 
                    r.inBattle() &&
                    r.isDefaultSettings() &&
                    r.playerLostRound()
                ),
        cancel = always_false(),
        submit = always_true(),
        value  = max_of(
            array_map(REGIONS, r => measured(r.kumiteOppsDefeated(), when=r.isRegion()))
            ),
        format = "VALUE"
    )
}

// Training
for char_id in CharacterLookup {
    char_name = CharacterLookup[char_id]
    
    leaderboard(
        title = format("Single Training - {0}",char_name),
        description = "Highest Combo",
        start = any_of(REGIONS, r => unless(!r.isRegion()) && r.currentMode() == MODE_TRAINING &&
                (r.isStartingMatch() || r.actUnpaused()) &&
                r.charIsActive(0) &&
                r.char(0)["character_id"] == char_id ),
        cancel = any_of(REGIONS, r => unless(!r.isRegion()) && !prev(r.inBattle()) ),
        submit = any_of(REGIONS, r => 
            unless(!r.isRegion()) && 
            once(r.char(0)["curr_combo"] == 1 &&
            r.inBattle() && 
            r.currentMode() == MODE_TRAINING && 
            r.char(0)["character_id"] == char_id) && 
            !r.inBattle()
        ),
        value = 
            max_of(
        array_map(REGIONS, r => measured(tally_of(range(1,99),1,r.combo_counter), when=r.isRegion() && __ornext(r.matchStateIs(MATCH_STATE_BATTLE) || r.matchStateIs(MATCH_STATE_TRANSITION)) && r.charIsActive(0) && r.char(0)["character_id"] == char_id ) /*&& never(prev(r.pauseState()) == 1)*/)
    ),
        format = "VALUE"
    )
}