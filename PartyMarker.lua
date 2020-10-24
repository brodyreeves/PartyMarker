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
            desc = "Display addon messages in the chat frame, because the event used fires multiple times this can clutter the chat fram when you form a group; you may want to enable this if you're having problems, as a debugging tool",
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
            name = "Partner",
            type = "group", inline = true, order = 4,
            args = {
                partnerIcon = {
                    name = "Icon",
                    desc = "Icon to assign to partner",
                    type = "select", order = 1, width = 0.8,
                    values = function() return PartyMarker.iconOptions end,
                    get = function(info) return PartyMarker.db.profile.partnerIcon end,
                    set = function(info, val) PartyMarker.db.profile.partnerIcon = val end,
                    disabled = function() return not PartyMarker.db.profile.enabled end,
                },
                partnerBTag = {
                    name = "BattleTag",
                    desc = "BattleTag of partner(e.g., 'Nickname#0001')",
                    type = "input", order = 2,
                    get = function(info) return PartyMarker.db.profile.partnerBTag end,
                    set = function(info, val) PartyMarker.db.profile.partnerBTag = val end,
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
        loot = {
            name = "Loot",
            type = "group", inline = true, order = 6,
            args = {
                lootMode = {
                    name = "Loot Mode",
                    desc = "Loot mode to use in the group",
                    type = "select", order = 1, width = 0.8,
                    values = function() return PartyMarker.lootModeOptions end,
                    get = function(info) return PartyMarker.db.profile.lootMode end,
                    set = function(info, val) PartyMarker.db.profile.lootMode = val end,
                    disabled = function() return not PartyMarker.db.profile.enabled end,
                },
                lootThresh = {
                    name = "Loot Threshold",
                    desc = "Loot Threshold to use in the group",
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
        lootMode = 1, -- group loot
        lootThresh = 2, -- greens
    },
}

local colorG, colorR, colorY, colorW = "|cFF00FF00", "|cffff0000", "|cFFFFFF00", "|r" -- text color flags

function PartyMarker:OnInitialize()
    -- Called when the addon is loaded
    self.db = LibStub("AceDB-3.0"):New("PartyMarkerDB", self.defaults, true)

    LibStub("AceConfig-3.0"):RegisterOptionsTable("PartyMarker", self.options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("PartyMarker", "PartyMarker")
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
    if GetNumGroupMembers() == 2 then -- group valid for marking
        local partnerName = "1" -- default to illegal name
        local partner2Name = "1"

        -- get partner's toon name
        local _,numOnline = BNGetNumFriends() -- number of online BNet friends
        for i = 1, numOnline do -- for each friend
            local _,_, battleTag,_, characterName ,_,client = BNGetFriendInfo( i ) -- read info

            if battleTag == self.db.profile.partnerBTag and client == "WoW" then -- partner BNet account is playing WoW
                partnerName = characterName  -- found the character name for partner account
            end

            if battleTag == self.db.profile.partner2BTag and client == "WoW" then -- partner BNet account is playing WoW
                partner2Name = characterName  -- found the character name for partner account
            end
        end

        -- marks
        if UnitInParty(partnerName) and CanBeRaidTarget(partnerName) and CanBeRaidTarget("player") then -- partner is in party, player and partner can be marked
            SetRaidTarget(partnerName, self.db.profile.partnerIcon)
            SetRaidTarget("player", self.db.profile.playerIcon) -- set symbol on player
            PartyMarker:Send_Message(colorG .. "Marked <" .. colorW .. partnerName .. colorG .. ">")
        else -- couldn't mark
            PartyMarker:Send_Message(colorR .. "Failed to mark <" .. colorW .. partnerName .. colorR .. ">")
        end

        if UnitInParty(partner2Name) and CanBeRaidTarget(partner2Name) and CanBeRaidTarget("player") then -- partner2 is in party, player and partner2 can be marked
            SetRaidTarget(partner2Name, self.db.profile.partner2Icon)
            SetRaidTarget("player", self.db.profile.playerIcon) -- set symbol on player
            PartyMarker:Send_Message(colorG .. "Marked <" .. colorW .. partner2Name .. colorG .. ">")
        else -- couldn't mark
            PartyMarker:Send_Message(colorR .. "Failed to mark <" .. colorW .. partner2Name .. colorR .. ">")
        end

        -- loot
        if UnitIsGroupLeader("player") then -- only do loot stuff as leader
            local curMethod = GetLootMethod()
            -- loot mode takes a string as the argument, access the options table to get the string
            if curMethod == PartyMarker.lootModeOptions[self.db.profile.lootMode]:lower() then -- only change if needed
                PartyMarker:Send_Message(colorG .. "Loot method already <" .. colorW .. PartyMarker.lootModeOptions[self.db.profile.lootMode] .. colorG .. ">")
            else
                if self.db.profile.lootMode == 3 then -- master loot needs a player name too
                    local playerName = UnitName("player")
                    SetLootMethod(PartyMarker.lootModeOptions[self.db.profile.lootMode], playerName) -- set group loot method
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
            PartyMarker:Send_Message(colorR .. "Failed to set loot method/threshold to <" .. colorW .. PartyMarker.lootModeOptions[self.db.profile.lootMode] .. ", " .. PartyMarker.lootThreshOptions[self.db.profile.lootThresh] .. colorR .. "> -- not party leader")
        end
    end
end

-- Utility
function PartyMarker:Send_Message(msg)
    if not self.db.profile.showMsg then return end
    LibStub("AceConsole-3.0"):Print(colorY .. "PartyMarker: " .. colorW .. msg)
end
