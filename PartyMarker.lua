PartyMarkerClassic = LibStub("AceAddon-3.0"):NewAddon("PartyMarkerClassic", "AceConsole-3.0", "AceEvent-3.0")

PartyMarkerClassic.iconOptions = {
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

PartyMarkerClassic.lootModeOptions = {
    [1] = "Group",
    [2] = "FreeForAll",
    [3] = "Master",
    [4] = "NeedBeforeGreed",
    [5] = "RoundRobin",
}

PartyMarkerClassic.lootThreshOptions = {
    [0] = "Poor",
    [1] = "Common",
    [2] = "Uncommon",
    [3] = "Rare",
    [4] = "Epic",
    [5] = "Legendary",
    [6] = "Artifact",
}

PartyMarkerClassic.options = {
    name = "PartyMarkerClassic",
    handler = PartyMarkerClassic,
    type = 'group',
    args = {
        enable = {
            name = "Enable",
            desc = "Enable/disable the addon",
            type = "toggle", order = 1, width = "half",
            get = function(info) return PartyMarkerClassic.db.profile.enabled end,
            set = function(info, val)
                PartyMarkerClassic.db.profile.enabled = val
                if val then
                    PartyMarkerClassic:OnEnable()
                else
                    PartyMarkerClassic:OnDisable()
                end
            end,
        },
        showMsg = {
            name = "Display messages", width = "double",
            desc = "Display addon messages in the chat frame",
            type = "toggle", order = 2,
            get = function(info) return PartyMarkerClassic.db.profile.showMsg end,
            set = function(info, val) PartyMarkerClassic.db.profile.showMsg = val end,
            disabled = function() return not PartyMarkerClassic.db.profile.enabled end,
        },
        player = {
            name = "Player",
            type = "group", inline = true, order = 3,
            args = {
                playerIcon = {
                    name = "Icon",
                    desc = "Icon to assign to player",
                    type = "select", order = 1, width = 0.8,
                    values = function() return PartyMarkerClassic.iconOptions end,
                    get = function(info) return PartyMarkerClassic.db.profile.playerIcon end,
                    set = function(info, val) PartyMarkerClassic.db.profile.playerIcon = val end,
                    disabled = function() return not PartyMarkerClassic.db.profile.enabled end,
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
                    values = function() return PartyMarkerClassic.iconOptions end,
                    get = function(info) return PartyMarkerClassic.db.profile.partnerIcon end,
                    set = function(info, val) PartyMarkerClassic.db.profile.partnerIcon = val end,
                    disabled = function() return not PartyMarkerClassic.db.profile.enabled end,
                },
                partnerBTag = {
                    name = "BattleTag",
                    desc = "BattleTag of partner",
                    type = "input", order = 2,
                    get = function(info) return PartyMarkerClassic.db.profile.partnerBTag end,
                    set = function(info, val) PartyMarkerClassic.db.profile.partnerBTag = val end,
                    disabled = function() return not PartyMarkerClassic.db.profile.enabled end,
                },
            },
        },
        loot = {
            name = "Loot",
            type = "group", inline = true, order = 5,
            args = {
                lootMode = {
                    name = "Loot Mode",
                    desc = "Loot mode to use in the group",
                    type = "select", order = 1, width = 0.8,
                    values = function() return PartyMarkerClassic.lootModeOptions end,
                    get = function(info) return PartyMarkerClassic.db.profile.lootMode end,
                    set = function(info, val) PartyMarkerClassic.db.profile.lootMode = val end,
                    disabled = function() return not PartyMarkerClassic.db.profile.enabled end,
                },
                lootThresh = {
                    name = "Loot Threshold",
                    desc = "Loot Threshold to use in the group",
                    type = "select", order = 2, width = 0.8,
                    values = function() return PartyMarkerClassic.lootThreshOptions end,
                    get = function(info) return PartyMarkerClassic.db.profile.lootThresh end,
                    set = function(info, val) PartyMarkerClassic.db.profile.lootThresh = val end,
                    disabled = function() return not PartyMarkerClassic.db.profile.enabled end,
                },
            },
        },
    },
}

PartyMarkerClassic.defaults = {
    profile = {
        enabled = true,
        showMsg = true,
        playerIcon = 0,
        partnerIcon = 0,
        partnerBTag = "",
        lootMode = 1, -- group loot
        lootThresh = 2, -- greens
    },
}

local colorG, colorR, colorY, colorW = "|cFF00FF00", "|cffff0000", "|cFFFFFF00", "|r" -- text color flags

function PartyMarkerClassic:OnInitialize()
    -- Called when the addon is loaded
    self.db = LibStub("AceDB-3.0"):New("PartyMarkerClassicDB", self.defaults, true)

    LibStub("AceConfig-3.0"):RegisterOptionsTable("PartyMarkerClassic", self.options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("PartyMarkerClassic", "PartyMarkerClassic")
end

function PartyMarkerClassic:OnEnable()
    self:RegisterEvent("GROUP_ROSTER_UPDATE")

    if self.db.profile.showMsg then
        LibStub("AceConsole-3.0"):Print(colorY .. "PartyMarkerClassic: " .. colorG .. "Enabled" .. colorW)
     end
end

function PartyMarkerClassic:OnDisable()
    self:UnregisterEvent("GROUP_ROSTER_UPDATE")
    if self.db.profile.showMsg then
        LibStub("AceConsole-3.0"):Print(colorY .. "PartyMarkerClassic: " .. colorR .. "Disabled" .. colorW)
     end
end

-- Event Handlers
function PartyMarkerClassic:GROUP_ROSTER_UPDATE()
    if GetNumGroupMembers() == 2 then -- group valid for marking
        local partnerName = "1" -- default to illegal name

        -- get partner's toon name
        local _,numOnline = BNGetNumFriends() -- number of online BNet friends
        for i = 1, numOnline do -- for each friend
            local _,_, battleTag,_, toonName,_,client = BNGetFriendInfo( i ) -- read info
            if battleTag == self.db.profile.partnerBTag and client == "WoW" then -- partner BNet account is playing WoW
                partnerName = toonName -- found the character name for partner account
                break -- from loop through friends
            end
        end

        if UnitInParty(partnerName) and CanBeRaidTarget(partnerName) and CanBeRaidTarget("player") then -- partner is in party, player and partner can be marked
            SetRaidTarget(partnerName, self.db.profile.partnerIcon)
            SetRaidTarget("player", self.db.profile.playerIcon) -- set symbol on player

            if IsPartyLeader() then -- only do loot stuff as leader
                -- loot mode and threshold take strings as the argument, access the options table to get the string
                if self.db.profile.lootMode == 3 then -- master loot needs a player name too
                    local playerName = UnitName("player")
                    SetLootMethod(PartyMarkerClassic.lootModeOptions[self.db.profile.lootMode], playerName) -- set group loot method
                else
                    SetLootMethod(PartyMarkerClassic.lootModeOptions[self.db.profile.lootMode]) -- set group loot method
                end

                SetLootThreshold(PartyMarkerClassic.lootThreshOptions[self.db.profile.lootThresh]) -- set loot threshold
            end

            if self.db.profile.showMsg then
                LibStub("AceConsole-3.0"):Print(colorY .. "PartyMarkerClassic: " .. colorG .. "Marked " .. colorW .. partnerName)
            end
        else -- couldn't mark
            if self.db.profile.showMsg then
                LibStub("AceConsole-3.0"):Print(colorY .. "PartyMarkerClassic: " .. colorR .. "Failed to mark " .. colorW .. partnerName)
            end
        end
    end
end
