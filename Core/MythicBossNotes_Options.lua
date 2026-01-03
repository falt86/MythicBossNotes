-- MythicBossNotes_Options.lua
local ADDON_NAME, MythicBossNotes = ...

local function GetSettings()
    return MythicBossNotes.GetSettings()
end

------------------------------------------------------------
-- Options panel
------------------------------------------------------------
local panel = CreateFrame("Frame")
panel.name = "MythicBossNotes"

panel:SetScript("OnShow", function(self)
    if self.built then return end
    self.built = true

    local settings = GetSettings()

    --------------------------------------------------------
    -- Title
    --------------------------------------------------------
    local title = self:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Mythic Boss Notes Settings")

    --------------------------------------------------------
    -- Enable Edit Mode
    --------------------------------------------------------
    local editMode = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
    editMode:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -20)
    editMode.Text:SetText("Enable Edit Mode")
    editMode:SetChecked(settings.editMode)

    editMode:SetScript("OnClick", function(btn)
        settings.editMode = btn:GetChecked()
        local ui = MythicBossNotes.UI
        if ui and ui:IsShown() then
            ui:SetMode(settings.editMode and "edit" or "passive")
        end
    end)

    --------------------------------------------------------
    -- Show Notes Window
    --------------------------------------------------------
    local showWindow = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
    showWindow:SetPoint("TOPLEFT", editMode, "BOTTOMLEFT", 0, -8)
    showWindow.Text:SetText("Show Notes Window")
    showWindow:SetChecked(settings.showWindow)

    showWindow:SetScript("OnClick", function(btn)
        settings.showWindow = btn:GetChecked()
        local ui = MythicBossNotes.UI
        if not ui then return end

        if settings.showWindow then
            ui:Show()
            ui:SetMode(settings.editMode and "edit" or "passive")
        else
            ui:Hide()
        end
    end)

    --------------------------------------------------------
    -- Background Opacity
    --------------------------------------------------------
    local opacity = CreateFrame("Slider", nil, self, "OptionsSliderTemplate")
    opacity:SetPoint("TOPLEFT", showWindow, "BOTTOMLEFT", 0, -40)
    opacity:SetMinMaxValues(0, 1)
    opacity:SetValueStep(0.05)
    opacity:SetObeyStepOnDrag(true)

    opacity.Text:SetText("Background Opacity")
    opacity.Low:SetText("0")
    opacity.High:SetText("1")
    opacity:SetValue(settings.bgOpacity or 0.8)

    opacity:SetScript("OnValueChanged", function(_, value)
        settings.bgOpacity = value
        MythicBossNotes.ApplyBackgroundOpacity()
        opacity.Text:SetFormattedText("Background Opacity: %.2f", value)
    end)

    --------------------------------------------------------
    -- Font Size
    --------------------------------------------------------
    local fontSize = CreateFrame("Slider", nil, self, "OptionsSliderTemplate")
    fontSize:SetPoint("TOPLEFT", opacity, "BOTTOMLEFT", 0, -40)
    fontSize:SetMinMaxValues(10, 32)
    fontSize:SetValueStep(1)
    fontSize:SetObeyStepOnDrag(true)

    fontSize.Text:SetText("Font Size")
    fontSize.Low:SetText("10")
    fontSize.High:SetText("32")
    fontSize:SetValue(settings.fontSize or 14)

    fontSize:SetScript("OnValueChanged", function(_, value)
        settings.fontSize = value
        MythicBossNotes.ApplyFont()
        fontSize.Text:SetFormattedText("Font Size: %d", value)
    end)

        --------------------------------------------------------
    -- Font Family
    --------------------------------------------------------
    local LSM = LibStub("LibSharedMedia-3.0")
    local fontList = LSM:List("font")
    table.sort(fontList)

    local fontDropdown = CreateFrame("Frame", "MBN_FontFamilyDropdown", self, "UIDropDownMenuTemplate")
    fontDropdown:SetPoint("TOPLEFT", fontSize, "BOTTOMLEFT", -16, -30)

    local function FontDropdown_Initialize()
        local current = settings.fontFamily

        for _, fontName in ipairs(fontList) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = fontName
            info.func = function()
                settings.fontFamily = fontName
                UIDropDownMenu_SetText(fontDropdown, fontName)
                MythicBossNotes.ApplyFont()
            end
            info.checked = (current == fontName)
            UIDropDownMenu_AddButton(info)
        end
    end

    UIDropDownMenu_SetWidth(fontDropdown, 200)
    UIDropDownMenu_SetText(fontDropdown, settings.fontFamily or "Friz Quadrata TT")
    UIDropDownMenu_Initialize(fontDropdown, FontDropdown_Initialize)


    --------------------------------------------------------
    -- Auto-show Dungeon Notes
    --------------------------------------------------------
    local autoDungeon = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
    autoDungeon:SetPoint("TOPLEFT", fontDropdown, "BOTTOMLEFT", 0, -30)
    autoDungeon.Text:SetText("Auto-show Dungeon Notes")
    autoDungeon:SetChecked(settings.autoShowDungeon ~= false)

    autoDungeon:SetScript("OnClick", function(btn)
        settings.autoShowDungeon = btn:GetChecked()
    end)

    --------------------------------------------------------
    -- Auto-show Boss Notes
    --------------------------------------------------------
    local autoBoss = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
    autoBoss:SetPoint("TOPLEFT", autoDungeon, "BOTTOMLEFT", 0, -8)
    autoBoss.Text:SetText("Auto-show Boss Notes")
    autoBoss:SetChecked(settings.autoShowBoss ~= false)

    autoDungeon:SetScript("OnClick", function(btn)
        settings.autoShowBoss = btn:GetChecked()
    end)

    --------------------------------------------------------
    -- Lock Window
    --------------------------------------------------------
    local lockFrame = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
    lockFrame:SetPoint("TOPLEFT", autoBoss, "BOTTOMLEFT", 0, -8)
    lockFrame.Text:SetText("Lock Notes Window")
    lockFrame:SetChecked(settings.locked == true)

    lockFrame:SetScript("OnClick", function(btn)
        settings.locked = btn:GetChecked()
        MythicBossNotes.UpdateLockState()
    end)
end)

------------------------------------------------------------
-- Register with Settings
------------------------------------------------------------
local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
category.ID = ADDON_NAME
Settings.RegisterAddOnCategory(category)

function MythicBossNotes.OpenOptions()
    if Settings and Settings.OpenToCategory and category and category.ID then
        Settings.OpenToCategory(category.ID)
    else
        InterfaceOptionsFrame_OpenToCategory(panel)
        InterfaceOptionsFrame_OpenToCategory(panel)
    end
end
