// Ōkamiden
// #ID = 9298

function has_increased(addr) => addr > prev(addr)
function has_decreased(addr) => addr < prev(addr)
function has_changed(addr) => addr != prev(addr)
function hasnt_changed(addr) => addr == prev(addr)
function if_else(p, t, f) { if (p) { return t } else return f }
function is_even(v) => v % 2 == 0

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

REGION_PTR_ADDR = 0x00000b90

function inGame() => dword(REGION_PTR_ADDR) != 0

function mapID() => ptr(REGION_PTR_ADDR,[0x00,0x386c,0x00,0x5c,0x30,0x8c],word)
function subMapID() => ptr(REGION_PTR_ADDR,[0x00,0x386c,0x00,0x5c,0x30,0x8e],word)
function currentMap() => (mapID() * 0x100) + subMapID()

MapLookup = {
    0x0101: "Cave of Nagi",
    0x0102: "Cave of Nagi",
    0x0103: "Cave of Nagi",
    0x0104: "Cave of Nagi",
    0x0105: "Cave of Nagi",
    0x0201: "Kamiki Village",
    0x0202: "Kamiki Village",
    0x0203: "Kamiki Village",
    0x0204: "Kamiki Village (Home of the Elder)",
    0x0205: "Kamiki Village (Kushi's Sake House)",
    0x0206: "Kamiki Village (Home of Mushi)",
    0x0207: "Kamiki Village (Water Wheel)",
    0x0208: "Kamiki Village (Home of Susano)",
    0x0301: "Shinshu Field",
    0x0501: "Yakushi Village Upper Lv.",
    0x0502: "Yakushi Village Upper Lv.",
    0x0503: "Yakushi Village Upper Lv.",
    0x0504: "Yakushi Village Lower Lv.",
    0x0507: "Yakushi Village Upper Lv. (Dr. Redbeard's House)",
    0x0508: "Yakushi Village Upper Lv. (Dr. Redbeard's House)",
    0x4602: "Deity Cutscene", //TODO: location name? Use this to detect meeting deitys?
}

rich_presence_conditional_display(inGame(),"🗺️{0} ({1} {2}) ",
rich_presence_lookup("Area", currentMap(), MapLookup),
rich_presence_value("Map", mapID()),
rich_presence_value("SubMap", subMapID())
)

rich_presence_display("Loading...")