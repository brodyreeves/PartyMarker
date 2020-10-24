std = "lua51"
max_line_length = false
exclude_files = {
    "Libs/",
    ".luacheckrc"
}
ignore = {
    "211", -- Unused local variable
    "211/L", -- Unused local variable "L"
    "211/CL", -- Unused local variable "CL"
    "212", -- Unused argument
    "213", -- Unused loop variable
    "311", -- Value assigned to a local variable is unused
    "314", -- Value of a field in a table literal is unused
    "42.", -- Shadowing a local variable, an argument, a loop variable.
    "43.", -- Shadowing an upvalue, an upvalue argument, an upvalue loop variable.
    "542", -- An empty if branch
}
globals = {
    -- Libs used
    "LibStub",
    "IsControlKeyDown", -- from ace

    -- lua

    -- Blizz API
    "BNGetNumFriends",
    "C_BattleNet",
    "UnitInParty",
    "CanBeRaidTarget",
    "SetRaidTarget",
    "UnitIsGroupLeader",
    "GetLootMethod",
    "UnitName",
    "SetLootMethod",
    "GetLootThreshold",
    "SetLootThreshold",
    "GetNumGroupMembers",

    -- Blizz Globals

    -- My Globals
    "PartyMarker"
}
