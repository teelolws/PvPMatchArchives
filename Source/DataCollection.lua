local addonName, addon = ...

EventRegistry:RegisterFrameEventAndCallback("PVP_MATCH_COMPLETE", function()
	if C_Commentator.IsSpectating() then return end

    local db = {}
    local timestamp = GetServerTime()
    PvPMatchArchiveDB[timestamp] = db
    table.insert(addon.DBSortedKeys, timestamp)
    
    db.CanDisplayDamage = C_PvP.CanDisplayDamage()
    db.CanDisplayDeaths = C_PvP.CanDisplayDeaths()
    db.CanDisplayHealing = C_PvP.CanDisplayHealing()
    db.CanDisplayHonorableKills = C_PvP.CanDisplayHonorableKills()
    db.CanDisplayKillingBlows = C_PvP.CanDisplayKillingBlows()
    db.DoesMatchOutcomeAffectRating = C_PvP.DoesMatchOutcomeAffectRating()
    db.GetActiveBrawlInfo = C_PvP.GetActiveBrawlInfo()
    
    -- TODO: This is not currently shown anywhere by the default UI. Show it somewhere.
    db.GetActiveMatchDuration = C_PvP.GetActiveMatchDuration()
    
    db.GetActiveMatchState = C_PvP.GetActiveMatchState()
    db.GetActiveMatchWinner = C_PvP.GetActiveMatchWinner()
    db.GetCustomVictoryStatID = C_PvP.GetCustomVictoryStatID()
    db.GetMatchPVPStatColumns = C_PvP.GetMatchPVPStatColumns()
    db.GetPostMatchCurrencyRewards = C_PvP.GetPostMatchCurrencyRewards()
    db.GetPostMatchItemRewards = C_PvP.GetPostMatchItemRewards()
    
    db.GetPVPActiveMatchPersonalRatedInfo = C_PvP.GetPVPActiveMatchPersonalRatedInfo()
    if db.GetPVPActiveMatchPersonalRatedInfo then
        db.GetPvpTierInfo = C_PvP.GetPvpTierInfo(db.GetPVPActiveMatchPersonalRatedInfo.tier)
    end
    
    db.GetScoreInfo = {}
    for index = 1, GetNumBattlefieldScores() do
        db.GetScoreInfo[index] = C_PvP.GetScoreInfo(index)
    end
    
    db.GetScoreInfoByPlayerGuid = C_PvP.GetScoreInfoByPlayerGuid(GetPlayerGuid())
    
    db.GetTeamInfo = {}
    db.GetTeamInfo[0] = C_PvP.GetTeamInfo(0)
    db.GetTeamInfo[1] = C_PvP.GetTeamInfo(1)
    
    db.IsActiveBattlefield = C_PvP.IsActiveBattlefield()
    db.IsArena = C_PvP.IsArena()
    db.IsBattleground = C_PvP.IsBattleground()
    db.IsBrawlSoloRBG = C_PvP.IsBrawlSoloRBG()
    db.IsBrawlSoloShuffle = C_PvP.IsBrawlSoloShuffle()
    db.IsMatchActive = C_PvP.IsMatchActive()
    db.IsMatchComplete = C_PvP.IsMatchComplete()
    db.IsMatchFactional = C_PvP.IsMatchFactional()
    db.IsRatedArena = C_PvP.IsRatedArena()
    db.IsRatedBattleground = C_PvP.IsRatedBattleground()
    db.IsRatedMap = C_PvP.IsRatedMap()
    db.IsRatedSoloRBG = C_PvP.IsRatedSoloRBG()
    db.IsRatedSoloShuffle = C_PvP.IsRatedSoloShuffle()
    db.IsSoloRBG = C_PvP.IsSoloRBG()
    db.IsSoloShuffle = C_PvP.IsSoloShuffle()
    
    db.IsArenaSkirmish = IsArenaSkirmish()
    db.GetBattlefieldArenaFaction = GetBattlefieldArenaFaction()
    db.GetNumBattlefieldScores = GetNumBattlefieldScores()
    db.GetPlayerGuid = GetPlayerGuid()
    db.UnitFactionGroup = UnitFactionGroup("player")
end)