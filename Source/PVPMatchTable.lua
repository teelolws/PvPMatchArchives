local addonName, addon = ...

local C_PvP = addon.C_PvP
local IsArenaSkirmish = C_PvP.IsArenaSkirmish
local PVPMatchUtil = addon.PVPMatchUtil

local function ShouldShowRatingColumns()
	-- Ignore Solo Shuffle/Battleground Blitz brawls which use rating for matchmaking purposes
	if C_PvP.IsBrawlSoloShuffle() or C_PvP.IsBrawlSoloRBG() then
		return false;
	end

	return C_PvP.DoesMatchOutcomeAffectRating();
end

function addon.ConstructPVPMatchTable(tableBuilder, useAlternateColor)
	local iconPadding = 2;
	local textPadding = 15;
	
	tableBuilder:Reset();
	tableBuilder:SetDataProvider(C_PvP.GetScoreInfo);
	tableBuilder:SetTableMargins(5);

	local column = tableBuilder:AddColumn();
	column:ConstructHeader("BUTTON", "PVPHeaderIconTemplate", [[Interface/PVPFrame/Icons/prestige-icon-3]], "honorLevel");
	column:ConstrainToHeader();
	column:ConstructCells("FRAME", "PVPCellHonorLevelTemplate");

	column = tableBuilder:AddColumn();
	column:ConstructHeader("BUTTON", "PVPHeaderIconTemplate", [[Interface/PvPRankBadges/PvPRank06]], "class");
	column:ConstrainToHeader(iconPadding);
	column:ConstructCells("FRAME", "PVPCellClassTemplate");

	column = tableBuilder:AddColumn();
	column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", NAME, "LEFT", "name");
	local fillCoefficient = 1.0;
	local namePadding = 4;
	
	local isSoloShuffle = C_PvP.IsSoloShuffle();
	if isSoloShuffle then
		column:ConstructCells("BUTTON", "PVPSoloShuffleCellNameTemplate", useAlternateColor);
	else
		column:ConstructCells("BUTTON", "PVPCellNameTemplate", useAlternateColor);
	end
	column:SetFillConstraints(fillCoefficient, namePadding);

	local function AddPVPStatColumns(cellStatTemplate)
		local statColumns = C_PvP.GetMatchPVPStatColumns();
		table.sort(statColumns, function(lhs,rhs)
			return lhs.orderIndex < rhs.orderIndex;
		end);

		for columnIndex, statColumn in ipairs(statColumns) do
			if strlen(statColumn.name) > 0 then
				column = tableBuilder:AddColumn();
				local sortType = "stat"..columnIndex;
				column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", statColumn.name, "CENTER", sortType, statColumn.tooltipTitle, statColumn.tooltip);
				column:ConstrainToHeader(textPadding);
				column:ConstructCells("FRAME", cellStatTemplate, statColumn.pvpStatID, useAlternateColor);
			end
		end
	end

	if isSoloShuffle then
		local cellStatTemplate = "PVPSoloShuffleCellStatTemplate";
		AddPVPStatColumns(cellStatTemplate);
	end

	if C_PvP.CanDisplayKillingBlows() then
		column = tableBuilder:AddColumn();
		column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", SCORE_KILLING_BLOWS, "CENTER", "kills", KILLING_BLOW_TOOLTIP_TITLE, KILLING_BLOW_TOOLTIP);
		column:ConstrainToHeader(textPadding);
		column:ConstructCells("FRAME", "PVPCellStringTemplate", "killingBlows", useAlternateColor);
	end
	
	if C_PvP.CanDisplayHonorableKills() then
		column = tableBuilder:AddColumn();
		column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", SCORE_HONORABLE_KILLS, "CENTER", "hk", HONORABLE_KILLS_TOOLTIP_TITLE, HONORABLE_KILLS_TOOLTIP);
		column:ConstrainToHeader(textPadding);
		column:ConstructCells("FRAME", "PVPCellStringTemplate", "honorableKills", useAlternateColor);
	end
	 
	if  C_PvP.CanDisplayDeaths() then
		column = tableBuilder:AddColumn();
		column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", DEATHS, "CENTER", "deaths", DEATHS_TOOLTIP_TITLE, DEATHS_TOOLTIP);
		column:ConstrainToHeader(textPadding);
		column:ConstructCells("FRAME", "PVPCellStringTemplate", "deaths", useAlternateColor);
	end

	local isAbbreviated = true;
	local hasTooltip = true;

	if C_PvP.CanDisplayDamage() then
		column = tableBuilder:AddColumn();
		column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", SCORE_DAMAGE_DONE, "CENTER", "damage", DAMAGE_DONE_TOOLTIP_TITLE, DAMAGE_DONE_TOOLTIP);
		column:ConstrainToHeader(textPadding);
		column:ConstructCells("FRAME", "PVPCellStringTemplate", "damageDone", useAlternateColor, isAbbreviated, hasTooltip);
	end

	if C_PvP.CanDisplayHealing() then
		column = tableBuilder:AddColumn();
		column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", SCORE_HEALING_DONE, "CENTER", "healing", HEALING_DONE_TOOLTIP_TITLE, HEALING_DONE_TOOLTIP);
		column:ConstrainToHeader(textPadding);
		column:ConstructCells("FRAME", "PVPCellStringTemplate", "healingDone", useAlternateColor, isAbbreviated, hasTooltip);
	end

	if not isSoloShuffle then
		local cellStatTemplate = "PVPCellStatTemplate";
		AddPVPStatColumns(cellStatTemplate);
	end
	
	local mmrPre = false;
	local ratingPre = false;
	local ratingPost = false;
	local ratingChange = false;
	if ShouldShowRatingColumns() then
		if PVPMatchUtil.IsActiveMatchComplete() then
			-- Skirmish is considered rated for matchmaking reasons.
			ratingChange = not IsArenaSkirmish();
			ratingPost = true;
			mmrPre = C_PvP.IsRatedSoloShuffle() or C_PvP.IsRatedSoloRBG();
		else
			ratingPre = true;
		end
	end

	if mmrPre then
		column = tableBuilder:AddColumn();
		column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", BATTLEGROUND_MATCHMAKING_VALUE, "CENTER", "mmrPre", BATTLEGROUND_MATCHMAKING_VALUE_TOOLTIP_TITLE, BATTLEGROUND_MATCHMAKING_VALUE_TOOLTIP);
		column:ConstrainToHeader(textPadding);
		column:ConstructCells("FRAME", "PVPCellStringTemplate", "prematchMMR", useAlternateColor);
	end

	if ratingPre then
		column = tableBuilder:AddColumn();
		column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", BATTLEGROUND_RATING, "CENTER", "bgratingPre", BATTLEGROUND_RATING_TOOLTIP_TITLE);
		column:ConstrainToHeader(textPadding);
		column:ConstructCells("FRAME", "PVPCellStringTemplate", "rating", useAlternateColor);
	end
	
	if ratingPost then
		column = tableBuilder:AddColumn();
		column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", BATTLEGROUND_NEW_RATING, "CENTER", "bgratingPost", BATTLEGROUND_NEW_RATING_TOOLTIP_TITLE, BATTLEGROUND_NEW_RATING_TOOLTIP);
		column:ConstrainToHeader(textPadding);
		column:ConstructCells("FRAME", "PVPNewRatingTemplate", useAlternateColor);
	end

	local ratingChangeTooltip = isSoloShuffle and RATING_CHANGE_TOOLTIP_SOLO_SHUFFLE or RATING_CHANGE_TOOLTIP;
	if ratingChange then
		column = tableBuilder:AddColumn();
		column:ConstructHeader("BUTTON", "PVPHeaderStringTemplate", SCORE_RATING_CHANGE, "CENTER", "bgratingChange", RATING_CHANGE_TOOLTIP_TITLE, ratingChangeTooltip);
		column:ConstrainToHeader(textPadding);
		column:ConstructCells("FRAME", "PVPCellStringTemplate", "ratingChange", useAlternateColor);
	end

	tableBuilder:Arrange();
end