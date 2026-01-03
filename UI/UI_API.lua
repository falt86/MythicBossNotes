-- MythicBossNotes/UI/UI_API.lua
local ADDON_NAME, MythicBossNotes = ...

MythicBossNotes.UI = MythicBossNotes.UI or {}
local UI = MythicBossNotes.UI

------------------------------------------------------------
-- Public API: handlers, title, text
------------------------------------------------------------
function UI:SetHandlers(handlers)
    self.handlers = handlers or self.handlers or {}
end

function UI:SetTitleFromState(instanceName, bossName)
    if not self.title then return end

    if not instanceName or instanceName == "" then
        self.title:SetText("Mythic Boss Notes")
        return
    end

    if not bossName or bossName == "" then
        self.title:SetText(instanceName)
        return
    end

    self.title:SetText(instanceName .. " - " .. bossName)
end

function UI:SetNoteText(text)
    if self.editBox then
        local pretty = MythicBossNotes.ReplaceMarkerKeywords
            and MythicBossNotes.ReplaceMarkerKeywords(text or "")
            or (text or "")
        self.editBox:SetText(pretty)
        self.editBox:SetCursorPosition(0)
    end
end

function UI:GetNoteText()
    return self.editBox and self.editBox:GetText() or ""
end

function UI:SetDungeonSelection(name)
    if self.dungeonDropdown then
        UIDropDownMenu_SetText(self.dungeonDropdown, name or "Select Dungeon")
    end
end

function UI:SetBossSelection(name)
    if self.bossDropdown then
        UIDropDownMenu_SetText(self.bossDropdown, name or "Select Boss")
    end
end

function UI:ClearBossSelection()
    if self.bossDropdown then
        UIDropDownMenu_SetText(self.bossDropdown, "Select Boss")
    end
end

function UI:IsShown()
    return self.frame and self.frame:IsShown()
end

function UI:Show()
    if not self.frame then
        self:Create()
    end
    self.frame:Show()
end

function UI:Hide()
    if self.frame then
        self.frame:Hide()
    end
end

------------------------------------------------------------
-- Orchestrated Create() entrypoint
------------------------------------------------------------
function UI:Create()
    if self.frame then return end

    -- These methods are defined in other modules:
    -- CreateFrame (UI_Frame)
    -- CreateDropdowns (UI_Dropdowns)
    -- CreateEditBox (UI_EditBox)
    -- CreateMarkerBar (UI_MarkerBar)

    self.mode = self.mode or "passive"

    self:CreateFrame()
    self:CreateDropdowns()
    self:CreateEditBox()
    self:CreateMarkerBar()

    -- Save button (lives here since it's simple and "global" to the frame)
    local save = CreateFrame("Button", nil, self.frame, "UIPanelButtonTemplate")
    self.saveButton = save
    save:SetSize(90, 22)
    save:SetPoint("BOTTOMRIGHT", -10, 10)
    save:SetText("Save Note")

    if MythicBossNotes.Skin then
        MythicBossNotes.Skin:Button(save)
    end

    save:SetScript("OnClick", function()
        if MythicBossNotes.SaveCurrentNote then
            MythicBossNotes.SaveCurrentNote()
            print("|cff00ff00MythicBossNotes: Note saved.|r")
        end
    end)

    -- Finalize
    if self.RestoreFramePosition then
        self:RestoreFramePosition()
    end

    if self.ApplyFont then
        self:ApplyFont()
    end

    if self.ApplyBackgroundOpacity then
        self:ApplyBackgroundOpacity()
    end

    local settings = MythicBossNotes.GetSettings()
    self:SetMode(settings.editMode and "edit" or "passive")

    if self.RefreshDungeonDropdown then
        self:RefreshDungeonDropdown()
    end

    self.frame:Hide()
end

------------------------------------------------------------
-- External helpers for other modules
------------------------------------------------------------
MythicBossNotes.ApplyFont = function()
    if MythicBossNotes.UI then
        MythicBossNotes.UI:ApplyFont()
    end
end

MythicBossNotes.ApplyBackgroundOpacity = function()
    if MythicBossNotes.UI then
        MythicBossNotes.UI:ApplyBackgroundOpacity()
    end
end
