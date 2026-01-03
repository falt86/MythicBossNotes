-- MythicBossNotes/UI/UI_Mode.lua
local ADDON_NAME, MythicBossNotes = ...

MythicBossNotes.UI = MythicBossNotes.UI or {}
local UI = MythicBossNotes.UI

------------------------------------------------------------
-- Mode switching
------------------------------------------------------------
function UI:ApplyPassiveMode()
    if not self.frame then return end

    self.frame:EnableMouse(false)
    self.frame:SetMovable(false)
    self.frame:SetResizable(false)

    if self.scroll then
        self.scroll:EnableMouse(false)
        self.scroll:EnableMouseWheel(false)
    end

    if self.editBox then
        self.editBox:EnableMouse(false)
        self.editBox:EnableKeyboard(false)
    end

    if self.markerBar then
        self.markerBar:Hide()
    end

    if self.dungeonDropdown then self.dungeonDropdown:Hide() end
    if self.bossDropdown then self.bossDropdown:Hide() end

    if self.resizeHandle then
        self.resizeHandle:Hide()
    end

    if self.saveButton then
        self.saveButton:Hide()
    end
end

function UI:ApplyEditMode()
    if not self.frame then return end
    local settings = MythicBossNotes.GetSettings()

    self.frame:EnableMouse(true)
    self.frame:SetMovable(not settings.locked)
    self.frame:SetResizable(true)

    if self.scroll then
        self.scroll:EnableMouse(true)
        self.scroll:EnableMouseWheel(true)
    end

    if self.editBox then
        self.editBox:EnableMouse(true)
        self.editBox:EnableKeyboard(true)
    end

    if self.resizeHandle then
        self.resizeHandle:Show()
    end

    if self.dungeonDropdown then self.dungeonDropdown:Show() end
    if self.bossDropdown then self.bossDropdown:Show() end
    if self.markerBar then self.markerBar:Show() end
    if self.saveButton then self.saveButton:Show() end
end

function UI:SetMode(mode)
    if mode ~= "passive" and mode ~= "edit" then
        mode = "passive"
    end

    self.mode = mode

    if mode == "passive" then
        self:ApplyPassiveMode()
    else
        self:ApplyEditMode()
    end
end

MythicBossNotes.UpdateLockState = function()
    local ui = MythicBossNotes.UI
    if not ui or not ui.frame then return end

    if ui.mode == "edit" then
        ui:ApplyEditMode()
    else
        ui:ApplyPassiveMode()
    end
end
