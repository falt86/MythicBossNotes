-- MythicBossNotes/UI/UI_Skin.lua
local ADDON_NAME, MythicBossNotes = ...

local Skin = {}
MythicBossNotes.Skin = Skin

------------------------------------------------------------
-- Theme constants
------------------------------------------------------------
Skin.colors = {
    bg      = { 0.06, 0.06, 0.06, 0.92 },
    bgDark  = { 0.04, 0.04, 0.04, 0.85 },
    border  = { 0, 0, 0, 1 },
    shadow  = { 0, 0, 0, 0.6 },
    button  = { 0.10, 0.10, 0.10, 0.92 },
}

Skin.spacing = {
    small  = 4,
    medium = 8,
    large  = 12,
}

------------------------------------------------------------
-- Core frame skin
------------------------------------------------------------
function Skin:Frame(frame)
    frame:SetBackdrop({
        bgFile   = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets   = { left = 1, right = 1, top = 1, bottom = 1 },
    })

    frame:SetBackdropColor(unpack(self.colors.bg))
    frame:SetBackdropBorderColor(unpack(self.colors.border))

    if not frame.shadow then
        local shadow = CreateFrame("Frame", nil, frame, "BackdropTemplate")
        frame.shadow = shadow
        shadow:SetPoint("TOPLEFT", -3, 3)
        shadow:SetPoint("BOTTOMRIGHT", 3, -3)
        shadow:SetBackdrop({
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 3,
        })
        shadow:SetBackdropBorderColor(unpack(self.colors.shadow))
    end
end

------------------------------------------------------------
-- Buttons
------------------------------------------------------------
function Skin:Button(btn)
    self:Frame(btn)
    btn:SetBackdropColor(unpack(self.colors.button))

    btn:SetHighlightTexture("Interface\\Buttons\\WHITE8x8")
    btn:GetHighlightTexture():SetVertexColor(1, 1, 1, 0.1)
end

------------------------------------------------------------
-- Dropdowns
------------------------------------------------------------
function Skin:Dropdown(drop)
    self:Frame(drop)
    UIDropDownMenu_SetWidth(drop, 300)
end

------------------------------------------------------------
-- Dark content background (edit box)
------------------------------------------------------------
function Skin:ContentBackground(tex)
    tex:SetColorTexture(unpack(self.colors.bgDark))
end
