local addonName, addon = ...

-- Adds a button and confirmation dialog to clear out the entire database

local clearDatabaseButton = CreateFrame("Button", "ArchivePVPMatchResultsClearDatabaseButton", ArchivePVPMatchResults)
clearDatabaseButton:SetSize(30, 30)
clearDatabaseButton:SetPoint("BOTTOMRIGHT", ArchivePVPMatchResults, "BOTTOMRIGHT", -30, 30)
clearDatabaseButton:SetNormalTexture("transfer-log-button-up")
clearDatabaseButton:SetPushedTexture("transfer-log-button-down")
clearDatabaseButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine("Clear the addon's database")
    GameTooltip:Show()
end)
clearDatabaseButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)
clearDatabaseButton:SetScript("OnClick", function(self)
    addon.ClearDatabasePrompt()
end)

local confirmationNum = 0
function addon.ClearDatabasePrompt()
    local text = "This will clear the entire database, then reload your UI.\nAre you "
    for _ = 1, confirmationNum do
        text = text.."really "
    end
    text = text.."sure?"
    
    confirmationNum = confirmationNum + 1
    
    StaticPopupDialogs["PVPMATCHARCHIVES_DELETE_CONFIRMATION"] = {
    	text = text,
    	button1 = "Yes",
    	button2 = "No",
    	OnAccept = function()
            if confirmationNum > 6 then
                PvPMatchArchiveDB2 = nil
                C_UI.Reload()
                return
            end
            RunNextFrame(addon.ClearDatabasePrompt)
     	end,
        OnCancel = function()
            confirmationNum = 0
        end,
    	timeout = 0,
    	whileDead = true,
    	hideOnEscape = true,
    }
    StaticPopup_Show("PVPMATCHARCHIVES_DELETE_CONFIRMATION")
end
