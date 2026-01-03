-- MythicBossNotes/UI/UI_EditBox.lua
local ADDON_NAME, MythicBossNotes = ...

MythicBossNotes.UI = MythicBossNotes.UI or {}
local UI   = MythicBossNotes.UI
local Skin = MythicBossNotes.Skin

local LSM = LibStub("LibSharedMedia-3.0")

------------------------------------------------------------
-- Creation
------------------------------------------------------------
function UI:CreateEditBox()
    if not self.frame or self.scroll then return end

    local frame = self.frame

    local scroll = CreateFrame("ScrollFrame", nil, frame)
    self.scroll = scroll
    scroll:SetPoint("TOPLEFT", 10, -125)
    scroll:SetPoint("BOTTOMRIGHT", -30, 40)
    scroll:EnableMouse(true)
    scroll:EnableMouseWheel(true)

    local edit = CreateFrame("EditBox", nil, scroll)
    self.editBox = edit
    edit:SetMultiLine(true)
    edit:SetAutoFocus(false)
    edit:SetFontObject(ChatFontNormal)
    edit:SetScript("OnEscapePressed", edit.ClearFocus)

    scroll:SetScrollChild(edit)

    edit:ClearAllPoints()
    edit:SetPoint("TOPLEFT", 0, 0)
    edit:SetPoint("TOPRIGHT", 0, 0)
    edit:SetPoint("BOTTOMLEFT", 0, 0)
    edit:SetPoint("BOTTOMRIGHT", 0, 0)

    scroll:SetScript("OnSizeChanged", function(_, w)
        edit:SetWidth(w)
    end)

    -- Background
    local bg = frame:CreateTexture(nil, "BACKGROUND")
    self.editBG = bg
    bg:SetPoint("TOPLEFT", scroll, -4, 4)
    bg:SetPoint("BOTTOMRIGHT", scroll, 4, -4)
    Skin:ContentBackground(bg)
end

------------------------------------------------------------
-- Font / background
------------------------------------------------------------
function UI:ApplyFont()
    if not self.editBox then return end
    local settings = MythicBossNotes.GetSettings()

    local fontPath = LSM:Fetch("font", settings.fontFamily)
        or LSM:Fetch("font", "Friz Quadrata TT")

    self.editBox:SetFont(fontPath, settings.fontSize or 14, "")
    if self.title then
        self.title:SetFont(fontPath, (settings.fontSize or 14) + 2, "OUTLINE")
    end
end

function UI:ApplyBackgroundOpacity()
    if not self.frame then return end
    local settings = MythicBossNotes.GetSettings()
    local alpha = settings.bgOpacity or 0.9

    self.frame:SetBackdropColor(0.06, 0.06, 0.06, alpha)
    self.frame:SetBackdropBorderColor(0, 0, 0, 1)

    if self.editBG then
        self.editBG:SetColorTexture(0.04, 0.04, 0.04, alpha * 0.85)
    end
end
