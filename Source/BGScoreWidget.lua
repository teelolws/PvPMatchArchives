local addonName, addon = ...

local C_PvP = addon.C_PvP

ArchivePVPScoreWidgetMixin = CreateFromMixins(UIWidgetTopCenterContainerMixin)

function ArchivePVPScoreWidgetMixin:OnLoad()
	UIWidgetContainerMixin.OnLoad(self);
	--local setID = C_UIWidgetManager.GetTopCenterWidgetSetID();
	self:RegisterForWidgetSet(1);
end

function ArchivePVPScoreWidgetMixin:OnEvent()
end

function ArchivePVPScoreWidgetMixin:UpdateData()
    local lastKnownWidgets = C_PvP.lastKnownWidgets()
    self:RemoveAllWidgets()
    if not lastKnownWidgets then return end
    for _, widgetInfo in pairs(lastKnownWidgets) do
        self:ProcessWidget(widgetInfo)
    end
end

function ArchivePVPScoreWidgetMixin:ProcessWidget(widgetInfo)
    if type(widgetInfo) ~= "table" then return end
    local widgetID, widgetType = widgetInfo.widgetID, widgetInfo.widgetType
	local widgetTypeInfo = UIWidgetManager:GetWidgetTypeInfo(widgetType);
	if not widgetTypeInfo then
		-- This WidgetType is not supported (nothing called RegisterWidgetVisTypeTemplate for it)
		return;
	end

	--UIWidgetManager:UpdateProcessingUnit(self.attachedUnit, self.attachedUnitIsGuid);

	--local widgetInfo = widgetTypeInfo.visInfoDataFunction(widgetID);
    widgetInfo = widgetInfo.visInfo

	local widgetFrame = self.widgetFrames[widgetID];
	local widgetAlreadyExisted = (widgetFrame ~= nil);

	if widgetAlreadyExisted and widgetFrame.widgetType ~= widgetType then
		-- This widget existed already but the type has changed, so release the old widget frame and treat it as a brand new widget
		self:RemoveWidget(widgetID);
		widgetAlreadyExisted = false;
	end

	local oldOrderIndex;
	local oldLayoutDirection;
	local isNewWidget = false;

	if widgetAlreadyExisted then
		-- Widget already existed
		if not widgetInfo then
			-- widgetInfo is nil, indicating it should no longer be shown...animate it out (RemoveWidget will be called once that is done)
			widgetFrame:AnimOut();
			widgetFrame.markedForRemove = nil;
			return;
		end

		-- Otherwise the widget should still show...save the current orderIndex and layoutDirection so we can determine if they change after Setup is run
		oldOrderIndex = widgetFrame.orderIndex;
		oldLayoutDirection = widgetFrame.layoutDirection;

		-- Remove markedForRemove because it is still showing
		widgetFrame.markedForRemove = nil;
	else
		-- Widget did not already exist
		if widgetInfo then
			-- And it should be shown...create it
			widgetFrame = self:CreateWidget(widgetID, widgetType, widgetTypeInfo, widgetInfo);
			isNewWidget = true;
		else
			-- Widget should not be shown. It didn't already exist so there is nothing to do
			return;
		end
	end

	-- Ok we are now SURE that this widget should be shown and we have a frame for it

	-- Run the Setup function on the widget (could change the orderIndex and/or layoutDirection)
	widgetFrame:Setup(widgetInfo, self);
	if isNewWidget then 
		--Only Apply the effects when the widget is first added.
		widgetFrame:ApplyEffects(widgetInfo); 
	end		

	if isNewWidget and widgetFrame.OnAcquired then
		widgetFrame:OnAcquired(widgetInfo)
	end

	-- Determine if we need to run layout again
	local needsLayout = (oldOrderIndex ~= widgetFrame.orderIndex) or (oldLayoutDirection ~= widgetFrame.layoutDirection);
	if needsLayout then
		-- Either this is a new widget or either orderIndex or layoutDirection changed. In either case layout needs to be run
		self:MarkDirtyLayout();
	end
end

function ArchivePVPScoreWidgetMixin:RegisterForWidgetSet(widgetSetID, widgetLayoutFunction, widgetInitFunction, attachedUnitInfo)
	if self.widgetSetID then
		-- We are already registered to a WidgetSet
		if self.widgetSetID == widgetSetID then
			-- And it's the same WidgetSet we are trying to register again...nothing to do
			return;
		else
			-- We are already registered for a different WidgetSet...unregister it
			self:UnregisterForWidgetSet();
		end
	end

	if not widgetSetID then
		return;
	end

	local widgetSetInfo = C_UIWidgetManager.GetWidgetSetInfo(widgetSetID);
	if not widgetSetInfo then
		return;
	end

	self.widgetSetID = widgetSetID;
	self.layoutFunc = widgetLayoutFunction or DefaultWidgetLayout;
	self.initFunc = widgetInitFunction;
	self.widgetFrames = {};
	self.timerWidgets = {};
	self.numTimers = 0;
	self.numWidgetsShowing = 0;
	self:SetAttachedUnitAndType(attachedUnitInfo)

	self.widgetSetLayoutDirection = self.forceWidgetSetLayoutDirection or widgetSetInfo.layoutDirection;
	self.verticalAnchorYOffset = widgetSetInfo.verticalPadding;

	self:ProcessAllWidgets();
	self:Show();
end