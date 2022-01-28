PartyMarker = LibStub("AceAddon-3.0"):NewAddon("PartyMarker", "AceConsole-3.0", "AceEvent-3.0")

PartyMarker.iconOptions = {
    [0] = "None",
    [1] = "Star",
    [2] = "Circle",
    [3] = "Diamond",
    [4] = "Triangle",
    [5] = "Moon",
    [6] = "Square",
    [7] = "Cross",
    [8] = "Skull",
}

PartyMarker.lootModeOptions = {
    [1] = "Group",
    [2] = "FreeForAll",
    [3] = "Master",
    [4] = "NeedBeforeGreed",
    [5] = "RoundRobin",
}

PartyMarker.lootThreshOptions = {
    [0] = "Poor",
    [1] = "Common",
    [2] = "Uncommon",
    [3] = "Rare",
    [4] = "Epic",
}

PartyMarker.options = {
    name = "PartyMarker",
    handler = PartyMarker,
    type = 'group',
    args = {
        enable = {
            name = "Enable",
            desc = "Enable/disable the addon",
            type = "toggle", order = 1, width = "half",
            get = function(info) return PartyMarker.db.profile.enabled end,
            set = function(info, val)
                PartyMarker.db.profile.enabled = val
                if val then
                    PartyMarker:OnEnable()
                else
                    PartyMarker:OnDisable()
                end
            end,
        },
        showMsg = {
            name = "Display messages", width = "double",
            desc = "Display addon messages in the chat frame, because the event used fires multiple times this can clutter the chat frame when you form a group; you may want to enable this if you're having problems, as a debugging tool",
            type = "toggle", order = 2,
            get = function(info) return PartyMarker.db.profile.showMsg end,
            set = function(info, val) PartyMarker.db.profile.showMsg = val end,
            disabled = function() return not PartyMarker.db.profile.enabled end,
        },
        player = {
            name = "Player",
            type = "group", inline = true, order = 3,
            args = {
                playerIcon = {
                    name = "Icon",
                    desc = "Icon to assign to player",
                    type = "select", order = 1, width = 0.8,
                    values = function() return PartyMarker.iconOptions end,
                    get = function(info) return PartyMarker.db.profile.playerIcon end,
                    set = function(info, val) PartyMarker.db.profile.playerIcon = val end,
                    disabled = function() return not PartyMarker.db.profile.enabled end,
                },
            },
        },
        partner = {
            name = "Partner 1",
            type = "group", inline = true, order = 4,
            args = {
                partnerIcon = {
                    name = "Icon",
                    desc = "Icon to assign to partner 1",
                    type = "select", order = 1, width = 0.8,
                    values = function() return PartyMarker.iconOptions end,
                    get = function(info) return PartyMarker.db.profile.partner1Icon end,
                    set = function(info, val) PartyMarker.db.profile.partner1Icon = val end,
                    disabled = function() return not PartyMarker.db.profile.enabled end,
                },
                partnerBTag = {
                    name = "BattleTag",
                    desc = "BattleTag of partner 1 (e.g., 'Nickname#0001')",
                    type = "input", order = 2,
                    get = function(info) return PartyMarker.db.profile.partner1BTag end,
                    set = function(info, val) PartyMarker.db.profile.partner1BTag = val end,
                    disabled = function() return not PartyMarker.db.profile.enabled end,
                },
            },
        },
        partner2 = {
            name = "Partner 2",
            type = "group", inline = true, order = 5,
            args = {
                partner2Icon = {
                    name = "Icon",
                    desc = "Icon to assign to partner 2",
                    type = "select", order = 1, width = 0.8,
                    values = function() return PartyMarker.iconOptions end,
                    get = function(info) return PartyMarker.db.profile.partner2Icon end,
                    set = function(info, val) PartyMarker.db.profile.partner2Icon = val end,
                    disabled = function() return not PartyMarker.db.profile.enabled end,
                },
                partner2BTag = {
                    name = "BattleTag",
                    desc = "BattleTag of partner 2 (e.g., 'Nickname#0002')",
                    type = "input", order = 2,
                    get = function(info) return PartyMarker.db.profile.partner2BTag end,
                    set = function(info, val) PartyMarker.db.profile.partner2BTag = val end,
                    disabled = function() return not PartyMarker.db.profile.enabled end,
                },
            },
        },
        partner3 = {
            name = "Partner 3",
            type = "group", inline = true, order = 6,
            args = {
                partner3Icon = {
                    name = "Icon",
                    desc = "Icon to assign to partner 3",
                    type = "select", order = 1, width = 0.8,
                    values = function() return PartyMarker.iconOptions end,
                    get = function(info) return PartyMarker.db.profile.partner3Icon end,
                    set = function(info, val) PartyMarker.db.profile.partner3Icon = val end,
                    disabled = function() return not PartyMarker.db.profile.enabled end,
                },
                partner3BTag = {
                    name = "BattleTag",
                    desc = "BattleTag of partner 3 (e.g., 'Nickname#0003')",
                    type = "input", order = 2,
                    get = function(info) return PartyMarker.db.profile.partner3BTag end,
                    set = function(info, val) PartyMarker.db.profile.partner3BTag = val end,
                    disabled = function() return not PartyMarker.db.profile.enabled end,
                },
            },
        },
        partner4 = {
            name = "Partner 4",
            type = "group", inline = true, order = 7,
            args = {
                partner4Icon = {
                    name = "Icon",
                    desc = "Icon to assign to partner 4",
                    type = "select", order = 1, width = 0.8,
                    values = function() return PartyMarker.iconOptions end,
                    get = function(info) return PartyMarker.db.profile.partner4Icon end,
                    set = function(info, val) PartyMarker.db.profile.partner4Icon = val end,
                    disabled = function() return not PartyMarker.db.profile.enabled end,
                },
                partner4BTag = {
                    name = "BattleTag",
                    desc = "BattleTag of partner 4 (e.g., 'Nickname#0004')",
                    type = "input", order = 2,
                    get = function(info) return PartyMarker.db.profile.partner4BTag end,
                    set = function(info, val) PartyMarker.db.profile.partner4BTag = val end,
                    disabled = function() return not PartyMarker.db.profile.enabled end,
                },
            },
        },
        loot = {
            name = "Loot",
            type = "group", inline = true, order = 10,
            args = {
                lootMode = {
                    name = "Loot Mode",
                    desc = "Loot mode to use in the group, only applies if you are the leader",
                    type = "select", order = 1, width = 0.8,
                    values = function() return PartyMarker.lootModeOptions end,
                    get = function(info) return PartyMarker.db.profile.lootMode end,
                    set = function(info, val) PartyMarker.db.profile.lootMode = val end,
                    disabled = function() return not PartyMarker.db.profile.enabled end,
                },
                lootThresh = {
                    name = "Loot Threshold",
                    desc = "Loot Threshold to use in the group, only applies if you are the leader",
                    type = "select", order = 2, width = 0.8,
                    values = function() return PartyMarker.lootThreshOptions end,
                    get = function(info) return PartyMarker.db.profile.lootThresh end,
                    set = function(info, val) PartyMarker.db.profile.lootThresh = val end,
                    disabled = function() return not PartyMarker.db.profile.enabled end,
                },
            },
        },
    },
}

PartyMarker.defaults = {
    profile = {
        enabled = true,
        showMsg = false, -- primarily used for debugging
        playerIcon = 0,
        partnerIcon = 0,
        partnerBTag = "",
        partner2Icon = 0,
        partner2BTag = "",
        partner3Icon = 0,
        partner3BTag = "",
        partner4Icon = 0,
        partner4BTag = "",
        lootMode = 1, -- group loot
        lootThresh = 2, -- greens
    },
}

local colorG, colorR, colorY, colorW = "|cFF00FF00", "|cffff0000", "|cFFFFFF00", "|r" -- text color flags

local BNGetNumFriends = BNGetNumFriends
local CanBeRaidTarget = CanBeRaidTarget
local GetLootMethod = GetLootMethod
local GetLootThreshold = GetLootThreshold
local GetNumGroupMembers = GetNumGroupMembers
local SetLootMethod = SetLootMethod
local SetLootThreshold = SetLootThreshold
local SetRaidTarget = SetRaidTarget
local tinsert = table.insert
local UnitInParty = UnitInParty
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitName = UnitName
--@retail@
-- API call only exists in SL+
local GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
--@end-retail@

--@non-retail@
-- API needed to work pre-SL
local BNGetFriendInfo = BNGetFriendInfo
--@end-non-retail@

function PartyMarker:OnInitialize()
    -- Called when the addon is loaded
    self.db = LibStub("AceDB-3.0"):New("PartyMarkerDB", self.defaults, true)

    LibStub("AceConfig-3.0"):RegisterOptionsTable("PartyMarker", self.options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("PartyMarker", "PartyMarker")

    -- TODO v1.3.0 updated SV to new name, delete in future
    if self.db.profile.partnerIcon and not self.db.profile.partner1Icon then -- update SVar
        self.db.profile.partner1Icon = self.db.profile.partnerIcon
        self.db.profile.partnerIcon = nil
    end
    if self.db.profile.partnerBTag and not self.db.profile.partner1BTag then -- update SVar
        self.db.profile.partner1BTag = self.db.profile.partnerBTag
        self.db.profile.partnerBTag = nil
    end
end

function PartyMarker:OnEnable()
    self:RegisterEvent("GROUP_ROSTER_UPDATE")
    PartyMarker:Send_Message(colorG .. "Enabled" .. colorW)
end

function PartyMarker:OnDisable()
    self:UnregisterEvent("GROUP_ROSTER_UPDATE")
    PartyMarker:Send_Message(colorR .. "Disabled" .. colorW)
end

-- Event Handlers
function PartyMarker:GROUP_ROSTER_UPDATE()
    PartyMarker:Send_Message(colorY .. "Event triggered")
    local groupSize = GetNumGroupMembers()

    if groupSize < 2 or groupSize > 5 then -- group < 2 means party disbanded, group > 5 means impossible for party to all be partners
        PartyMarker:Send_Message(colorR .. "Not marking: group size incompatible")
        return
    end

    local _, numOnline = BNGetNumFriends() -- number of online BNet friends
    local partnersInWoW = {} -- character names of partners playing wow
    local inParty = 1 -- player always in party

    for id = 1, numOnline do -- check each online friend's BTag (saved partner), client (playing WoW), characterName (in party)
        --@retail@
        -- API call only exists in SL+
        local accountInfo = GetFriendAccountInfo(id) -- read friend info
        local battleTag = accountInfo and accountInfo.battleTag or "1"
        local client = accountInfo and accountInfo.gameAccountInfo and accountInfo.gameAccountInfo.clientProgram or "1"
        local characterName = accountInfo and accountInfo.gameAccountInfo and accountInfo.gameAccountInfo.characterName or "1"
        --@end-retail@

        --@non-retail
        -- variable setup for pre-SL
        local _, _, battleTag, _, characterName, _, client = BNGetFriendInfo(id)
        --@end-non-retail

        for i = 1, 4 do -- check against partners
            -- BTag is saved and they are playing WoW with a valid character name
            if battleTag == self.db.profile["partner" .. i .. "BTag"] and client == "WoW" and characterName ~= "1" then
                PartyMarker:Send_Message(colorY .. "Friend " .. id .. "/Partner " .. i .. ") " .. colorW .. battleTag .. colorY .. " matched, playing " .. colorW .. characterName)
                tinsert(partnersInWoW, {n=characterName, i=self.db.profile["partner" .. i .. "Icon"]}) -- store the character name and icon to give them
            end
        end
    end

    -- NOTE: overhead is either checking partners in WoW (max 4) to count # in party or check through party (max 40) to count # of partners
    for _, p in ipairs(partnersInWoW) do -- count number of partners in party
        if UnitInParty(p.n) then
            inParty = inParty + 1
        end
    end
    PartyMarker:Send_Message(colorY .. "Found " .. colorW .. inParty .. colorY .. " partners in party of " .. groupSize)

    if groupSize <= inParty then -- only execute when party is all partners
        -- marks
        if CanBeRaidTarget("player") then -- mark player
            SetRaidTarget("player", self.db.profile.playerIcon)
            PartyMarker:Send_Message(colorG .. "Marked <" .. colorW .. "Player" .. colorG .. ">")
        else -- couldn't mark
            PartyMarker:Send_Message(colorR .. "Unable to mark <" .. colorW .. "Player" .. colorR .. ">")
        end

        for _, p in ipairs(partnersInWoW) do -- mark each partner
            if CanBeRaidTarget(p.n) then
                SetRaidTarget(p.n, p.i)
                PartyMarker:Send_Message(colorG .. "Marked <" .. colorW .. p.n .. colorG .. ">")
            else -- couldn't mark
                PartyMarker:Send_Message(colorR .. "Unable to mark <" .. colorW .. p.n .. colorR .. ">")
            end
        end

        -- loot
        if UnitIsGroupLeader("player") then -- only do loot stuff as leader
            local curMethod = GetLootMethod()
            -- loot mode takes a string as the argument, access the options table to get the string
            if curMethod == PartyMarker.lootModeOptions[self.db.profile.lootMode]:lower() then -- only change if needed
                PartyMarker:Send_Message(colorG .. "Loot method already <" .. colorW .. PartyMarker.lootModeOptions[self.db.profile.lootMode] .. colorG .. ">")
            else
                if self.db.profile.lootMode == 3 then -- master loot needs a player name too
                    SetLootMethod(PartyMarker.lootModeOptions[self.db.profile.lootMode], UnitName("player")) -- set group loot method
                else
                    SetLootMethod(PartyMarker.lootModeOptions[self.db.profile.lootMode]) -- set group loot method
                end
                PartyMarker:Send_Message(colorG .. "Set loot method to <" .. colorW .. PartyMarker.lootModeOptions[self.db.profile.lootMode] .. colorG .. ">")
            end

            if GetLootThreshold() == self.db.profile.lootThresh then
                PartyMarker:Send_Message(colorG .. "Loot threshold already <" .. colorW .. PartyMarker.lootThreshOptions[self.db.profile.lootThresh] .. colorG .. ">")
            else
                SetLootThreshold(self.db.profile.lootThresh) -- set loot threshold
                PartyMarker:Send_Message(colorG .. "Set loot threshold to <" .. colorW .. PartyMarker.lootThreshOptions[self.db.profile.lootThresh] .. colorG .. ">")
            end
        else -- not party leader
            PartyMarker:Send_Message(colorR .. "Not setting loot method/threshold: not party leader")
        end
    else
        PartyMarker:Send_Message(colorR .. "Not marking: group is not partners only")
    end
end

-- Utility
function PartyMarker:Send_Message(msg)
    if not self.db.profile.showMsg then return end
    LibStub("AceConsole-3.0"):Print(colorY .. "PartyMarker: " .. colorW .. msg)
end
