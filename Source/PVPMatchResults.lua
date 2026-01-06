local addonName, addon = ...

local C_PvP = addon.C_PvP
local GetBattlefieldArenaFaction = C_PvP.GetBattlefieldArenaFaction
local PVPMatchUtil = addon.PVPMatchUtil
local PVPMatchStyle = addon.PVPMatchStyle 

ArchivePVPMatchResultsMixin = {};
local PVPMatchResultsMixin = ArchivePVPMatchResultsMixin
function PVPMatchResultsMixin:OnLoad()
	local tabContainer = self.content.tabContainer;
	self.scrollBox = self.content.scrollBox;
	self.scrollBar = self.content.scrollBar;
	self.scrollCategories = self.content.scrollCategories;
	self.tabGroup = tabContainer.tabGroup;
	self.tab1 = self.tabGroup.tab1;
	self.tab2 = self.tabGroup.tab2;
	self.tab3 = self.tabGroup.tab3;
	self.matchmakingText = tabContainer.matchmakingText;
	self.earningsContainer = self.content.earningsContainer;
	self.rewardsContainer = self.earningsContainer.rewardsContainer;
	self.rewardsHeader = self.rewardsContainer.header;
	self.itemContainer = self.rewardsContainer.items;
	self.progressContainer = self.earningsContainer.progressContainer;
	self.progressHeader = self.progressContainer.header;
	self.honorFrame = self.progressContainer.honor;
	self.honorText = self.honorFrame.text;
	self.honorButton = self.honorFrame.button;
	self.legacyHonorButton = self.honorFrame.legacyButton;
	self.conquestFrame = self.progressContainer.conquest;
	self.conquestText = self.conquestFrame.text;
	self.conquestButton = self.conquestFrame.button;
	self.legacyConquestButton = self.conquestFrame.legacyButton;
	self.ratingFrame = self.progressContainer.rating;
	self.ratingText = self.progressContainer.rating.text;
	self.ratingButton = self.progressContainer.rating.button;
	self.earningsArt = self.content.earningsArt;
	self.earningsBackground = self.earningsArt.background;
	self.tintFrames = {self.glowTop, self.earningsBackground, self.scrollBox.background};
	self.progressFrames = {self.honorFrame, self.conquestFrame, self.ratingFrame};

	self.header:SetShadowOffset(1,-1);

	self.earningsContainer:Hide();
	self.progressHeader:SetText(PVP_PROGRESS_REWARDS_HEADER);
	self.rewardsHeader:SetText(PVP_ITEM_REWARDS_HEADER);

	self.legacyConquestButton:SetTooltipAnchor("ANCHOR_RIGHT");

	self.tab1:SetText(ALL);
	self.Tabs = {self.tab1, self.tab2, self.tab3};
	PanelTemplates_SetNumTabs(self, #self.Tabs);
	for _, tab in pairs(self.Tabs) do
		tab:SetScript("OnClick", function() self:OnTabGroupClicked(tab) end);
	end
	PanelTemplates_SetTab(self, 1);

	UIPanelCloseButton_SetBorderAtlas(self.CloseButton, "UI-Frame-GenericMetal-ExitButtonBorder", -1, 1);

	self.itemPool = CreateFramePool("BUTTON", self.itemContainer, "PVPMatchResultsLoot");
	
	self.tableBuilder = CreateTableBuilder();
	self.tableBuilder:SetHeaderContainer(self.scrollCategories);

	PVPMatchUtil.InitScrollBox(self.scrollBox, self.scrollBar, self.tableBuilder);
end

function PVPMatchResultsMixin:Init()
	if self.isInitialized then
		return;
	end
	self.isInitialized = true;

	-- Custom victory stat id being used for Solo Shuffle brawl.
	local factionIndex = GetBattlefieldArenaFaction();
	local victoryStatID = C_PvP.GetCustomVictoryStatID();
	local hasCustomVictoryStatID = victoryStatID > 0;
	local useGenericText = hasCustomVictoryStatID and not C_PvP.IsRatedSoloShuffle();
	if useGenericText then
		self.header:SetText(PVP_SCOREBOARD_MATCH_COMPLETE);
	else
		local function GetOutcomeText(matchState, winner)
            if matchState ~= Enum.PvPMatchState.Complete then
                return WINTERGRASP_IN_PROGRESS
            end
            
			local enemyFactionIndex = (factionIndex + 1) % 2;
			if winner == factionIndex then
				return PVP_MATCH_VICTORY;
			elseif winner == enemyFactionIndex then
				return PVP_MATCH_DEFEAT;		
			end
			return PVP_MATCH_DRAW;
		end

		self.header:SetText(GetOutcomeText(C_PvP.GetActiveMatchState(), C_PvP.GetActiveMatchWinner()));
	end
	
	self.buttonContainer:MarkDirty();

	local isFactionalMatch = C_PvP.IsMatchFactional();
	if isFactionalMatch then
		local teamInfos = { 
			C_PvP.GetTeamInfo()[0],
			C_PvP.GetTeamInfo()[1], 
		};
		self.tab2:SetText(PVP_TAB_FILTER_COUNTED:format(FACTION_ALLIANCE, teamInfos[2].size));
		self.tab3:SetText(PVP_TAB_FILTER_COUNTED:format(FACTION_HORDE, teamInfos[1].size));
		PanelTemplates_ResizeTabsToFit(self, 600);
	end
	self.tabGroup:SetShown(isFactionalMatch);

	PVPMatchUtil.UpdateMatchmakingText(self.matchmakingText);

	-- For Solo Shuffle brawl.
	if hasCustomVictoryStatID then
		addon.SetSortType("stat1");

		factionIndex = 0;
	end
	self:SetupArtwork(factionIndex, isFactionalMatch);

	addon.ConstructPVPMatchTable(self.tableBuilder, not isFactionalMatch);
end

function PVPMatchResultsMixin:Shutdown()
	self.isInitialized = false;
	self.hasRewardTimerElapsed = false;
	self.rewardTimer = false;
	self.haveConquestData = false;
	self.hasDisplayedRewards = false;
	self.earningsContainer:Hide();
	HideUIPanel(self);
end

function PVPMatchResultsMixin:OnEvent()
end

function PVPMatchResultsMixin:BeginShow()
	-- Get the conquest information if necessary. This will normally be cached
	-- at the beginning of the match, but this is to deal with any rare cases
	-- where the sparse item or treasure picker db's have been flushed on us.
	self.haveConquestData = self:HaveConquestData();

	-- See POST_MATCH_ITEM_REWARD_UPDATE
	if not self.hasRewardTimerElapsed and not self.rewardTimer then
		self.rewardTimer = C_Timer.NewTimer(1.0, 
			function()
				self.rewardTimer = nil;
				self.hasRewardTimerElapsed = true;
				self:DisplayRewards();
			end
		);
	end

	self:Init();
	ShowUIPanel(self);
end

function PVPMatchResultsMixin:DisplayRewards()
	if self.hasDisplayedRewards or not self.hasRewardTimerElapsed then
		return;
	end

	local conquestQuestID = select(3, PVPGetConquestLevelInfo());
	if conquestQuestID ~= 0 and not self.haveConquestData then
		return;
	end
	self.hasDisplayedRewards = true;
	
	self.itemPool:ReleaseAll();

	for _, item in pairs(C_PvP.GetPostMatchItemRewards()) do
		-- Conquest is displayed in the progress section, so ignore it if found.
		if not (item.type == "currency" and C_CurrencyInfo.GetCurrencyIDFromLink(item.link) == Constants.CurrencyConsts.CONQUEST_CURRENCY_ID) then
			self:AddItemReward(item);
		end
	end

	for _, frame in pairs(self.progressFrames) do
		frame:Hide();
	end

	for _, currency in pairs(C_PvP.GetPostMatchCurrencyRewards()) do
		if currency.currencyType == Constants.CurrencyConsts.HONOR_CURRENCY_ID then
			self:InitHonorFrame(currency);
		elseif currency.currencyType == Constants.CurrencyConsts.CONQUEST_CURRENCY_ID then
			self:InitConquestFrame(currency);
		end
	end
	
	if PVPMatchUtil.ModeUsesPvpRatingTiers() then
		self:InitRatingFrame();
	end

	local previousItemFrame;
	for itemFrame in self.itemPool:EnumerateActive() do
		if previousItemFrame then
			itemFrame:SetPoint("TOPLEFT", previousItemFrame, "TOPRIGHT", 17, 0);
		else
			itemFrame:SetPoint("TOPLEFT");
		end

		itemFrame:Show();
		previousItemFrame = itemFrame;
	end
	
	local showItems = previousItemFrame ~= nil;
	self.rewardsContainer:SetShown(showItems);

	-- Visibility of the progress elements can be mixed, but are expected to be in the order of
	-- honor, then conquest, then rating.
	local progressFramesShown = {};
	for _, frame in pairs(self.progressFrames) do
		if frame:IsShown() then
			tinsert(progressFramesShown, frame);
		end

		-- Want assurance that all points are cleared and cannot affect
		-- the result of the anchoring to follow.
		frame:ClearAllPoints();
	end

	local previousProgressFrame;
	for _, progressFrame in ipairs(progressFramesShown) do
		if previousProgressFrame then
			progressFrame:SetPoint("LEFT", previousProgressFrame, "RIGHT", 22, 0);
		else
			progressFrame:SetPoint("TOPLEFT", self.progressHeader, "BOTTOMLEFT", 3, -11);
		end

		progressFrame:MarkDirty();
		previousProgressFrame = progressFrame;
	end
	
	local showProgress = previousProgressFrame ~= nil;
	self.progressContainer:SetShown(showProgress);
	if showProgress then
		if previousItemFrame then
			-- Anchor the progress rewards container to the item rewards container if items are present present, otherwise,
			-- the progress rewards will be centered when arranged by the resize layout frame.
			self.progressContainer:SetPoint("TOPLEFT", self.rewardsContainer, "TOPRIGHT", 50, 0);
		else
			self.progressContainer:SetPoint("TOPLEFT");
		end
	end
	
	if showItems or showProgress then
		self.earningsContainer:Show();
		self.earningsContainer:MarkDirty();
		self.earningsContainer.FadeInAnim:Play();
		self.earningsArt.BurstBgAnim:Play();

		local AddDelayToAnimations = function(delay, ...)
			for animIndex = 1, select("#", ...) do
				local anim = select(animIndex, ...);
				if not anim.initialStartDelay then
					anim.initialStartDelay = anim:GetStartDelay() or 0;
				end
				anim:SetStartDelay(anim.initialStartDelay + delay);
			end
		end

		local itemStartDelay = .35;
		for itemFrame in self.itemPool:EnumerateActive() do
			local animGroup = itemFrame.IconAnim;
			AddDelayToAnimations(itemStartDelay, animGroup:GetAnimations());
			animGroup:Play();
		end
	end
end

-- If this function returns false, it also comes with the side-effect of assigning
-- a callback and signalling QUEST_LOG_UPDATE. Unfortunately, this function needs to be called
-- until it succeeds, which occurs after every QUEST_LOG_UPDATE event.
function PVPMatchResultsMixin:HaveConquestData()
	local conquestQuestID = select(3, PVPGetConquestLevelInfo());
	return HaveQuestRewardData(conquestQuestID);
end

function PVPMatchResultsMixin:OnUpdate()
	if addon.isDirty then
		self:Shutdown()
        self:BeginShow()
        local forceNewDataProvider = true;
		PVPMatchUtil.UpdateDataProvider(self.scrollBox, forceNewDataProvider);
        addon.isDirty = false
	end
end

local scoreWidgetSetID = 249;
function PVPMatchResultsMixin:OnShow()
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB);
	self.Score:RegisterForWidgetSet(scoreWidgetSetID);
    self:BeginShow()
end

function PVPMatchResultsMixin:OnHide()
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE);
	self.Score:UnregisterForWidgetSet(scoreWidgetSetID);
end

function PVPMatchResultsMixin:AddItemReward(item)
	local frame = self.itemPool:Acquire();

	local unusedSpecID = nil;
	local isCurrency = item.type == "currency";
	local isIconBorderShown = true;
	local isIconBorderDropShadowShown = true;
	frame:Init(item.link, item.quantity, unusedSpecID, isCurrency, item.isUpgraded, isIconBorderShown, isIconBorderDropShadowShown);
	frame:SetScale(.7931);
end

function PVPMatchResultsMixin:InitHonorFrame(currency)
	local deltaString = FormatValueWithSign(math.floor(currency.quantityChanged));
	self.honorText:SetText(PVP_HONOR_CHANGE:format(deltaString));
	self.honorButton:Show();
	self.legacyHonorButton:Hide();
	self.honorFrame:Show();
end

function PVPMatchResultsMixin:InitConquestFrame(currency)
	local deltaString = FormatValueWithSign(math.floor(currency.quantityChanged / 100));
	self.conquestText:SetText(PVP_CONQUEST_CHANGE:format(deltaString));
	self.conquestButton:Show();
	self.legacyConquestButton:Hide();
	self.conquestFrame:Show();
end

function PVPMatchResultsMixin:InitRatingFrame()
	local localPlayerScoreInfo = C_PvP.GetScoreInfoByPlayerGuid(GetPlayerGuid());
	if localPlayerScoreInfo then
		local ratingChange = localPlayerScoreInfo.ratingChange;
		local rating = localPlayerScoreInfo.rating;
		self.ratingButton:Init(rating, ratingChange);

		local personalRatedInfo = C_PvP.GetPVPActiveMatchPersonalRatedInfo();
		if personalRatedInfo then
			local tierInfo = C_PvP.GetPvpTierInfo(personalRatedInfo.tier);
			self.ratingButton:Setup(tierInfo, ranking);
		end

		if ratingChange and ratingChange ~= 0 then
			local deltaString = FormatValueWithSign(ratingChange);
			self.ratingText:SetText(PVP_RATING_CHANGE:format(deltaString));
		else
			self.ratingText:SetText(PVP_RATING_UNCHANGED);
		end
		
		self.ratingFrame:Show();
	end
end

function PVPMatchResultsMixin:SetupArtwork(factionIndex, isFactionalMatch)
	local themeDecoration = self.overlay.decorator;
	local theme;
	if isFactionalMatch then
		theme = PVPMatchStyle.GetFactionPanelThemeByIndex(factionIndex);
		themeDecoration:SetPoint("BOTTOM", self, "TOP", 0, theme.decoratorOffsetY);
		themeDecoration:SetAtlas(theme.decoratorTexture, true);
	else
		theme = PVPMatchStyle.GetNeutralPanelTheme();
	end

	themeDecoration:SetShown(isFactionalMatch);
	
	local color;
	if C_PvP.GetCustomVictoryStatID() > 0 then
		color = PVPMatchStyle.PurpleColor;
	else
		local useAlternateColor = not isFactionalMatch;
		color = PVPMatchStyle.GetTeamColor(factionIndex, useAlternateColor);
	end

	local r, g, b = color:GetRGB();
	for _, frame in pairs(self.tintFrames) do
		frame:SetVertexColor(r, g, b);
	end

	NineSliceUtil.ApplyLayoutByName(self, theme.nineSliceLayout);
end

function PVPMatchResultsMixin:OnTabGroupClicked(tab)
	PanelTemplates_SetTab(self, tab:GetID());
	addon.SetFactionFilter(tab.factionEnum);
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB);

	local forceNewDataProvider = true;
	PVPMatchUtil.UpdateDataProvider(self.scrollBox, forceNewDataProvider);
end