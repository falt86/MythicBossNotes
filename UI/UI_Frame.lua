-- MythicBossNotes/UI/UI_Frame.lua
local ADDON_NAME, MythicBossNotes = ...

MythicBossNotes.UI = MythicBossNotes.UI or {}
local UI   = MythicBossNotes.UI
local Skin = MythicBossNotes.Skin

------------------------------------------------------------
-- Settings helpers
------------------------------------------------------------
local function GetSettings()
    return MythicBossNotes.GetSettings()
end

local function SaveFramePosition()
    if not UI.frame then return end
    local settings = GetSettings()

    local point, relativeTo, relativePoint, xOfs, yOfs = UI.frame:GetPoint()
    settings.framePoint = {
        point,
        relativeTo and relativeTo:GetName() or nil,
        relativePoint,
        xOfs,
        yOfs,
    }
    settings.width  = UI.frame:GetWidth()
    settings.height = UI.frame:GetHeight()
end

local function RestoreFramePosition()
    if not UI.frame then return end
    local settings = GetSettings()

    local fp = settings.framePoint or { "CENTER", nil, "CENTER", 0, 0 }
    local point, relName, relPoint, x, y = fp[1], fp[2], fp[3], fp[4], fp[5]

    UI.frame:ClearAllPoints()
    UI.frame:SetPoint(
        point or "CENTER",
        relName and _G[relName] or UIParent,
        relPoint or "CENTER",
        x or 0,
        y or 0
    )

    UI.frame:SetSize(settings.width or 450, settings.height or 260)
end

UI.SaveFramePosition    = SaveFramePosition
UI.RestoreFramePosition = RestoreFramePosition

------------------------------------------------------------
-- Frame + resize handle + title
------------------------------------------------------------
function UI:CreateFrame()
    if self.frame then return end

    local frame = CreateFrame("Frame", "MythicBossNotesFrame", UIParent, "BackdropTemplate")
    self.frame = frame

    frame:SetSize(450, 260)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("BACKGROUND")
    frame:SetFrameLevel(10)
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:SetResizable(true)

    Skin:Frame(frame)

    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(selfFrame)
        local settings = GetSettings()
        if UI.mode == "edit" and not settings.locked then
            selfFrame:StartMoving()
        end
    end)
    frame:SetScript("OnDragStop", function(selfFrame)
        selfFrame:StopMovingOrSizing()
        SaveFramePosition()
    end)

    frame:SetResizeBounds(350, 200, 900, 700)

    -- Resize handle
    local resize = CreateFrame("Frame", nil, frame)
    self.resizeHandle = resize
    resize:SetPoint("BOTTOMRIGHT", -3, 3)
    resize:SetSize(16, 16)
    resize:EnableMouse(true)

    local resizeTex = resize:CreateTexture(nil, "OVERLAY")
    resizeTex:SetAllPoints()
    resizeTex:SetTexture("Interface\\Buttons\\WHITE8x8")
    resizeTex:SetVertexColor(0.6, 0.6, 0.6)

    resize:SetScript("OnMouseDown", function()
        local settings = GetSettings()
        if UI.mode == "edit" and not settings.locked then
            frame:StartSizing("BOTTOMRIGHT")
        end
    end)
    resize:SetScript("OnMouseUp", function()
        frame:StopMovingOrSizing()
        SaveFramePosition()
    end)

    -- Title
    local title = frame:CreateFontString(nil, "OVERLAY")
    self.title = title
    title:SetPoint("TOPLEFT", 10, -8)
    title:SetText("Mythic Boss Notes")
end
