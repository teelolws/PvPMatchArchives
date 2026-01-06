local addonName, addon = ...

local currentlySelectedIndex
addon.DBSortedKeys = {}

EventUtil.ContinueOnAddOnLoaded(addonName, function()
    if not PvPMatchArchiveDB then
        PvPMatchArchiveDB = {
            [1] = {
                ["IsMatchComplete"] = true,
                ["GetActiveMatchDuration"] = 9001,
                ["IsRatedMap"] = true,
                ["GetCustomVictoryStatID"] = 0,
                ["IsArena"] = false,
                ["GetTeamInfo"] = {
                    {
                        ["ratingMMR"] = 67,
                        ["name"] = "",
                        ["rating"] = -1,
                        ["ratingNew"] = -13,
                        ["size"] = 7,
                    },
                    [0] = {
                        ["ratingMMR"] = 420,
                        ["name"] = "",
                        ["rating"] = -1,
                        ["ratingNew"] = -13,
                        ["size"] = 8,
                    },
                },
                ["GetMatchPVPStatColumns"] = {
                    {
                        ["name"] = "Flag Captures",
                        ["columnHeaderID"] = 57,
                        ["pvpStatID"] = 928,
                        ["orderIndex"] = 1,
                        ["tooltip"] = "Number of times you have captured the flag",
                        ["tooltipTitle"] = "Flag Captures",
                    },
                    {
                        ["name"] = "Flag Returns",
                        ["columnHeaderID"] = 62,
                        ["pvpStatID"] = 929,
                        ["orderIndex"] = 0,
                        ["tooltip"] = "Number of times you have returned your Flag to your base from the field",
                        ["tooltipTitle"] = "Flag Returns",
                    },
                },
                ["DoesMatchOutcomeAffectRating"] = true,
                ["IsBrawlSoloShuffle"] = false,
                ["GetScoreInfo"] = {
                    {
                        ["mmrChange"] = 0,
                        ["stats"] = {
                            {
                              ["iconName"] = "ColumnIcon-FlagCapture0",
                              ["name"] = "Flag Captures",
                              ["pvpStatID"] = 928,
                              ["orderIndex"] = 1,
                              ["pvpStatValue"] = 0,
                              ["tooltip"] = "Number of times you have captured the flag",
                            },
                            {
                                ["iconName"] = "ColumnIcon-FlagReturn0",
                                ["name"] = "Flag Returns",
                                ["pvpStatID"] = 929,
                                ["orderIndex"] = 0,
                                ["pvpStatValue"] = 1,
                                ["tooltip"] = "Number of times you have returned your Flag to your base from the field",
                            },
                        },
                        ["prematchMMR"] = 1748,
                        ["guid"] = "Player",
                        ["healingDone"] = 69241787,
                        ["ratingChange"] = 15,
                        ["raceName"] = "Highmountain Tauren",
                        ["rating"] = 100,
                        ["damageDone"] = 9,
                        ["deaths"] = 4,
                        ["honorGained"] = 162,
                        ["killingBlows"] = 2,
                        ["honorLevel"] = 154,
                        ["roleAssigned"] = 8,
                        ["talentSpec"] = "Unholy",
                        ["name"] = "Example Player 1",
                        ["faction"] = 0,
                        ["classToken"] = "DEATHKNIGHT",
                        ["honorableKills"] = 30,
                        ["postmatchMMR"] = 15000,
                        ["className"] = "Death Knight",
                    },
                    {
                        ["mmrChange"] = 0,
                        ["stats"] = {
                        {
                            ["iconName"] = "ColumnIcon-FlagCapture0",
                            ["name"] = "Flag Captures",
                            ["pvpStatID"] = 928,
                            ["orderIndex"] = 1,
                            ["pvpStatValue"] = 0,
                            ["tooltip"] = "Number of times you have captured the flag",
                        },
                        {
                            ["iconName"] = "ColumnIcon-FlagReturn0",
                            ["name"] = "Flag Returns",
                            ["pvpStatID"] = 929,
                            ["orderIndex"] = 0,
                            ["pvpStatValue"] = 0,
                            ["tooltip"] = "Number of times you have returned your Flag to your base from the field",
                        },
                    },
                        ["prematchMMR"] = 1793,
                        ["guid"] = "Player2",
                        ["healingDone"] = 23033938,
                        ["ratingChange"] = 19,
                        ["raceName"] = "Gnome",
                        ["rating"] = 1744,
                        ["damageDone"] = 4,
                        ["deaths"] = 4,
                        ["honorGained"] = 185,
                        ["killingBlows"] = 4,
                        ["honorLevel"] = 473,
                        ["roleAssigned"] = 8,
                        ["talentSpec"] = "Assassination",
                        ["name"] = "Example Player 2",
                        ["faction"] = 1,
                        ["classToken"] = "ROGUE",
                        ["honorableKills"] = 39,
                        ["postmatchMMR"] = 1842,
                        ["className"] = "Rogue",
                    },
                },
                ["GetScoreInfoByPlayerGuid"] = {
                    ["mmrChange"] = 0,
                    ["stats"] = {
                        {
                            ["iconName"] = "ColumnIcon-FlagCapture0",
                            ["name"] = "Flag Captures",
                            ["pvpStatID"] = 928,
                            ["orderIndex"] = 1,
                            ["pvpStatValue"] = 0,
                            ["tooltip"] = "Number of times you have captured the flag",
                        },
                        {
                            ["iconName"] = "ColumnIcon-FlagReturn0",
                            ["name"] = "Flag Returns",
                            ["pvpStatID"] = 929,
                            ["orderIndex"] = 0,
                            ["pvpStatValue"] = 1,
                            ["tooltip"] = "Number of times you have returned your Flag to your base from the field",
                        },
                    },
                    ["prematchMMR"] = 1748,
                    ["guid"] = "Player",
                    ["healingDone"] = 69241787,
                    ["ratingChange"] = 15,
                    ["raceName"] = "Highmountain Tauren",
                    ["rating"] = 1811,
                    ["damageDone"] = 9,
                    ["deaths"] = 4,
                    ["honorGained"] = 162,
                    ["killingBlows"] = 2,
                    ["honorLevel"] = 154,
                    ["roleAssigned"] = 8,
                    ["talentSpec"] = "Unholy",
                    ["name"] = "Example Player 1",
                    ["faction"] = 0,
                    ["classToken"] = "DEATHKNIGHT",
                    ["honorableKills"] = 30,
                    ["postmatchMMR"] = 15000,
                    ["className"] = "Death Knight",
                },
                ["GetPVPActiveMatchPersonalRatedInfo"] = {
                    ["bestSeasonRating"] = 1921,
                    ["lastWeeksBestRating"] = 576,
                    ["hasWonBracketToday"] = false,
                    ["weeklyPlayed"] = 52,
                    ["roundsWeeklyWon"] = 0,
                    ["seasonWon"] = 26,
                    ["bestWeeklyRating"] = 1921,
                    ["seasonPlayed"] = 56,
                    ["roundsSeasonPlayed"] = 0,
                    ["personalRating"] = 1811,
                    ["roundsSeasonWon"] = 0,
                    ["roundsWeeklyPlayed"] = 0,
                    ["tier"] = 391,
                    ["weeklyWon"] = 24,
                },
                ["IsRatedArena"] = false,
                ["CanDisplayDeaths"] = true,
                ["GetActiveMatchWinner"] = 0,
                ["GetPvpTierInfo"] = {
                    ["ascendTier"] = 390,
                    ["name"] = "Solo RBG - 6 - Rival I",
                    ["descendTier"] = 387,
                    ["descendRating"] = 1775,
                    ["pvpTierEnum"] = 3,
                    ["tierIconID"] = 2023049,
                    ["ascendRating"] = 1950,
                },
                ["IsSoloRBG"] = true,
                ["GetPostMatchCurrencyRewards"] = {
                    {
                        ["currencyType"] = 1792,
                        ["quantityChanged"] = 232,
                    },
                    {
                        ["currencyType"] = 1585,
                        ["quantityChanged"] = 218,
                    },
                },
                ["CanDisplayKillingBlows"] = true,
                ["IsActiveBattlefield"] = true,
                ["IsSoloShuffle"] = false,
                ["GetPostMatchItemRewards"] = {},
                ["IsRatedSoloShuffle"] = false,
                ["IsRatedSoloRBG"] = true,
                ["CanDisplayHonorableKills"] = true,
                ["IsMatchFactional"] = true,
                ["GetActiveMatchState"] = 5,
                ["IsMatchActive"] = false,
                ["IsBrawlSoloRBG"] = false,
                ["CanDisplayDamage"] = true,
                ["CanDisplayHealing"] = true,
                ["IsBattleground"] = false,
                ["IsRatedBattleground"] = false,
                ["GetBattlefieldArenaFaction"] = 0,
                ["GetPlayerGuid"] = "Player",
                ["UnitFactionGroup"] = 0,
                ["GetNumBattlefieldScores"] = 2,
            },
        }
    end
    
    for timestamp in pairs(PvPMatchArchiveDB) do
        table.insert(addon.DBSortedKeys, timestamp)
    end
    table.sort(addon.DBSortedKeys)
    
    currentlySelectedIndex = #addon.DBSortedKeys
    addon.isDirty = true
end)

local factionFilter = -1
local sortTypes = {
    ["honorLevel"] = true,
    ["class"] = "className",
    ["name"] = true,
    ["stat2"] = function(toSort)
        table.sort(toSort, function(a, b)
            if a.stats[1].pvpStatValue == b.stats[1].pvpStatValue then
                return a.guid < b.guid
            end
            return a.stats[1].pvpStatValue < b.stats[1].pvpStatValue
        end)
    end,
    ["stat1"] = function(toSort)
        table.sort(toSort, function(a, b)
            if a.stats[2].pvpStatValue == b.stats[2].pvpStatValue then
                return a.guid < b.guid
            end
            return a.stats[2].pvpStatValue < b.stats[2].pvpStatValue
        end)
    end,
    ["kills"] = "killingBlows",
    ["hk"] = "honorableKills",
    ["deaths"] = true,
    ["damage"] = "damageDone",
    ["healing"] = "healingDone",
    ["mmrPre"] = "prematchMMR",
    ["bgratingPre"] = "rating",
    ["bgratingPost"] = "rating",
    ["bgratingChange"] = "ratingChange",
}
local currentSortType
local sortInverse = false

local function doSort(toSort)
    local sortTypeColumn = sortTypes[currentSortType]
    if type(sortTypeColumn) == "string" then
        table.sort(toSort, function(a, b)
            if a[sortTypeColumn] == b[sortTypeColumn] then
                return a.guid < b.guid
            end
            if sortInverse then
                return a[sortTypeColumn] > b[sortTypeColumn]
            else
                return a[sortTypeColumn] < b[sortTypeColumn]
            end
        end)
    elseif type(sortTypeColumn) == "boolean" then
        table.sort(toSort, function(a, b)
            if a[currentSortType] == b[currentSortType] then
                return a.guid < b.guid
            end
            if sortInverse then
                return a[currentSortType] > b[currentSortType]
            else
                return a[currentSortType] < b[currentSortType]
            end
        end)
    elseif type(sortTypeColumn) == "function" then
        sortTypeColumn(toSort)
    end
end

local function applyFactionFilter(toFilter)
    local filtered = {}
    if factionFilter == -1 then
        return CopyTable(toFilter)
    elseif factionFilter == 1 then
        for _, data in pairs(toFilter) do
            if data.faction == 1 then
                table.insert(filtered, data)
            end
        end
    else
        for _, data in pairs(toFilter) do
            if data.faction == 0 then
                table.insert(filtered, data)
            end
        end
    end
    return filtered
end

-- Suppress global C_PvP with version that accesses SavedVariable database instead
addon.C_PvP = {
    GetHonorRewardInfo = C_PvP.GetHonorRewardInfo,
    IsPlayerGuid = function(guid)
        return PvPMatchArchiveDB[addon.DBSortedKeys[currentlySelectedIndex]][C_PvP.GetPlayerGuid()] == guid
    end,
    GetScoreInfo = function(index)
        if (not currentSortType) or (not sortTypes[currentSortType]) then
            return applyFactionFilter(PvPMatchArchiveDB[addon.DBSortedKeys[currentlySelectedIndex]].GetScoreInfo)[index]
        end
        
        local toSort = applyFactionFilter(PvPMatchArchiveDB[addon.DBSortedKeys[currentlySelectedIndex]].GetScoreInfo)
        doSort(toSort)
        return toSort[index]
    end,
    GetNumBattlefieldScores = function()
        if factionFilter == -1 then
            return PvPMatchArchiveDB[addon.DBSortedKeys[currentlySelectedIndex]].GetNumBattlefieldScores
        elseif factionFilter == 1 then
            local count = 0
            for _, data in pairs(PvPMatchArchiveDB[addon.DBSortedKeys[currentlySelectedIndex]].GetScoreInfo) do
                if data.faction == 1 then
                    count = count + 1
                end
            end
            return count
        else
            local count = 0
            for _, data in pairs(PvPMatchArchiveDB[addon.DBSortedKeys[currentlySelectedIndex]].GetScoreInfo) do
                if data.faction == 0 then
                    count = count + 1
                end
            end
            return count
        end
    end,
}
setmetatable(addon.C_PvP, {
    __index = function(_, key)
        return function() return PvPMatchArchiveDB[addon.DBSortedKeys[currentlySelectedIndex]][key] end
    end,
})

function ArchivePvPMatch_PrevButton()
    if currentlySelectedIndex == 1 then return end
    currentlySelectedIndex = currentlySelectedIndex - 1
    addon.isDirty = true
end

function ArchivePvPMatch_NextButton()
    if currentlySelectedIndex == #addon.DBSortedKeys then return end
    currentlySelectedIndex = currentlySelectedIndex + 1
    addon.isDirty = true
end

-- -1: no filter
-- 1: horde
-- 0: alliance
function addon.SetFactionFilter(faction)
    factionFilter = faction
end

function addon.SetSortType(sortType)
    if currentSortType == sortType then
        sortInverse = not sortInverse
    end
    currentSortType = sortType
    addon.isDirty = true
end
hooksecurefunc("SortBattlefieldScoreData", function(sortType)
    addon.SetSortType(sortType)
end)