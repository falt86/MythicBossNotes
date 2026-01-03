-- MythicBossNotes/UI/UI_MarkerBar.lua
local ADDON_NAME, MythicBossNotes = ...

MythicBossNotes.UI = MythicBossNotes.UI or {}
local UI   = MythicBossNotes.UI
local Skin = MythicBossNotes.Skin

------------------------------------------------------------
-- Marker bar
------------------------------------------------------------
local MARKERS = {
    { id = 1, key = "star" },
    { id = 2, key = "circle" },
    { id = 3, key = "diamond" },
    { id = 4, key = "triangle" },
    { id = 5, key = "moon" },
    { id = 6, key = "square" },
    { id = 7, key = "cross" },
    { id = 8, key = "skull" },
}

local function InsertMarkerToken(key)
    local editBox = UI.editBox
    if not editBox then return end

    local token  = "{" .. key .. "}"
    local cursor = editBox:GetCursorPosition()
    local text   = editBox:GetText() or ""
    local newText = text:sub(1, cursor) .. token .. text:sub(cursor + 1)
    editBox:SetText(newText)
    editBox:SetCursorPosition(cursor + #token)
end

function UI:CreateMarkerBar()
    if not self.frame or self.markerBar then return end
    if not self.scroll then return end

    local markerBar = CreateFrame("Frame", nil, self.frame, "BackdropTemplate")
    self.markerBar = markerBar
    markerBar:SetPoint("BOTTOMLEFT", self.scroll, "TOPLEFT", 0, 5)
    markerBar:SetSize(300, 22)

    Skin:Frame(markerBar)

    local x = 4
    for _, m in ipairs(MARKERS) do
        local btn = CreateFrame("Button", nil, markerBar)
        btn:SetSize(20, 20)
        btn:SetPoint("LEFT", x, 0)

        local tex = btn:CreateTexture(nil, "ARTWORK")
        tex:SetAllPoints()
        tex:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_" .. m.id)

        btn:SetScript("OnClick", function()
            InsertMarkerToken(m.key)
        end)

        x = x + 22
    end
end
