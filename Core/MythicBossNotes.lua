-- MythicBossNotes.lua
local ADDON_NAME, MythicBossNotes = ... 
MythicBossNotes.ADDON_NAME = ADDON_NAME

MythicBossNotes.Debug = true

------------------------------------------------------------
-- Defaults / settings
------------------------------------------------------------
local DEFAULT_SETTINGS = {
    locked          = false,
    fontSize        = 14,
    fontFamily      = "Friz Quadrata TT",
    bgOpacity       = 0.8,
    framePoint      = { "CENTER", nil, "CENTER", 0, 0 },
    width           = 450,
    height          = 260,
    autoShowDungeon = true,
autoShowBoss        = true,
    LoadDungeonNote = true,
    LoadBossNote    = true,
    editMode        = true,
    showWindow      = true,
}

function MythicBossNotes.GetDefaultSettings()
    local copy = {}
    for k, v in pairs(DEFAULT_SETTINGS) do
        copy[k] = v
    end
    return copy
end

function MythicBossNotes.GetSettings()
    MythicBossNotesDB = MythicBossNotesDB or {}
    local settings = MythicBossNotesDB.settings or {}
    MythicBossNotesDB.settings = settings

    for k, v in pairs(DEFAULT_SETTINGS) do
        if settings[k] == nil then
            settings[k] = v
        end
    end

    return settings
end

------------------------------------------------------------
-- Debug print
------------------------------------------------------------
function MythicBossNotes.Print(...)
    if MythicBossNotes.Debug then
        print("|cff00ff00[MythicBossNotes]|r", ...)
    end
end

------------------------------------------------------------
-- Current selection
------------------------------------------------------------
MythicBossNotes.currentDungeon = 0
MythicBossNotes.currentBoss    = 0

------------------------------------------------------------
-- Marker keywords
------------------------------------------------------------
MythicBossNotes.MarkerKeywords = {
    star     = 1,
    circle   = 2,
    diamond  = 3,
    triangle = 4,
    moon     = 5,
    square   = 6,
    cross    = 7,
    skull    = 8,
}

------------------------------------------------------------
-- Selection handlers (called by UI)
------------------------------------------------------------
function MythicBossNotes.OnDungeonSelected(dungeonID)
    if not dungeonID then return end

    if MythicBossNotes.SaveCurrentNote then
        MythicBossNotes.SaveCurrentNote()
    end

    MythicBossNotes.currentDungeon = dungeonID
    MythicBossNotes.currentBoss    = 0

    local ui = MythicBossNotes.UI
    local dungeon = MythicBossNotes_DungeonList and MythicBossNotes_DungeonList[dungeonID]
    if not ui or not dungeon then return end

    local text = MythicBossNotes.LoadDungeonNote(dungeonID) or ""
    ui:SetDungeonSelection(dungeon.name)
    ui:RefreshBossDropdown(dungeonID)
    ui:SetBossSelection("Dungeon Note")
    ui:SetTitleFromState(dungeon.name, "Dungeon Note")
    ui:SetNoteText(text)
  
   
end

function MythicBossNotes.OnBossSelected(dungeonID, encounterID, bossName)
    dungeonID = dungeonID or MythicBossNotes.currentDungeon
    MythicBossNotes.Print("Boss Selected", dungeonID, encounterID)
    if not dungeonID then return end

    if MythicBossNotes.SaveCurrentNote then
        MythicBossNotes.SaveCurrentNote()
    end

    MythicBossNotes.currentDungeon = dungeonID
    MythicBossNotes.currentBoss    = encounterID

    local ui = MythicBossNotes.UI
    local dungeon = MythicBossNotes_DungeonList and MythicBossNotes_DungeonList[dungeonID]
    if not ui or not dungeon then return end

    if encounterID == 0 then
        ui:SetBossSelection("Dungeon Note")
        ui:SetTitleFromState(dungeon.name, "Dungeon Note")
        local text = MythicBossNotes.LoadDungeonNote and MythicBossNotes.LoadDungeonNote(dungeonID) or ""
        ui:SetNoteText(text)
        return
    end

    local text = MythicBossNotes.LoadBossNote(dungeonID, encounterID) or ""
    ui:SetBossSelection(bossName)
    ui:SetTitleFromState(dungeon.name, bossName)
    ui:SetNoteText(text)
end

------------------------------------------------------------
-- Slash command (manual open)
------------------------------------------------------------
SLASH_MYTHICBOSSNOTES1 = "/mbn"
SlashCmdList["MYTHICBOSSNOTES"] = function(msg)
    local ui = MythicBossNotes.UI
    local settings = MythicBossNotes.GetSettings()
    msg = msg and msg:lower() or ""

    -- /mbn help
    if msg == "help" then
        print("|cff00ff00MythicBossNotes Commands:|r")
        print("|cffffff00/mbn load|r  - Attempt to load the note for the current instance")
        print("|cffffff00/mbn show|r  - Show the notes window")
        print("|cffffff00/mbn hide|r  - Hide the notes window")
        print("|cffffff00/mbn edit|r  - Switch to edit mode")
        print("|cffffff00/mbn passive|r - Switch to passive mode")
        print("|cffffff00/mbn help|r - Show this help menu")
        return
    end

    --load
    if msg == "load" then
        MythicBossNotes.UpdateVisibility()
        return
    end

    -- /mbn show
    if msg == "show" then
        settings.showWindow = true
        ui:Show()
        ui:SetMode(settings.editMode and "edit" or "passive")
        MythicBossNotes.Print("Window shown.")
        return
    end

    -- /mbn hide
    if msg == "hide" then
        settings.showWindow = false
        ui:Hide()
        MythicBossNotes.Print("Window hidden.")
        return
    end

    -- /mbn edit
    if msg == "edit" then
        settings.editMode = true
        settings.showWindow = true
        ui:Show()
        ui:SetMode("edit")
        MythicBossNotes.Print("Edit mode enabled.")
        return
    end

    -- /mbn passive
    if msg == "passive" then
        settings.editMode = false
        settings.showWindow = true
        ui:Show()
        ui:SetMode("passive")
        MythicBossNotes.Print("Passive mode enabled.")
        return
    end

    if msg == "dungeons" then
        local ids = MythicBossNotes.GetJournalInstanceIDs()
        MythicBossNotes.Dump(ids)
        return
    end
    
    if msg == "encounters" then
        local ids = MythicBossNotes.GetJournalInstanceIDs()
        for key, value in pairs(ids) do 
            local encounters = MythicBossNotes.GetEncounterIDs(key) 
            MythicBossNotes.Dump(encounters)
        end
        return
    end

    -- Default: toggle
    settings.showWindow = not settings.showWindow
    if settings.showWindow then
        ui:Show()
        ui:SetMode(settings.editMode and "edit" or "passive")
        MythicBossNotes.Print("Window shown.")
    else
        ui:Hide()
        MythicBossNotes.Print("Window hidden.")
    end
end

------------------------------------------------------------
-- Auto-show / visibility logic
------------------------------------------------------------
local lastAutoCheck = 0

function MythicBossNotes.UpdateVisibility()
    local now = GetTime()
    if now - lastAutoCheck < 3 then return end
    lastAutoCheck = now

    MythicBossNotes.Print("Checking to see if we should show the notes")
    local settings = MythicBossNotes.GetSettings()
    local ui = MythicBossNotes.UI
    if not ui then return end

    local inInstance, instanceType = IsInInstance()
    local isDungeon = inInstance and (instanceType == "party" or instanceType == "raid")

    if isDungeon and settings.autoShowDungeon then
        -- Auto-show in dungeons in passive mode
        MythicBossNotes.Print("We are in a dungeon")
        local mapID = C_Map.GetBestMapForUnit("player")
        local journalInstanceID = MythicBossNotes.FindJournalInstanceID(mapID)
        if not journalInstanceID then return end
        ui:Show()
        ui:SetMode("passive")
        MythicBossNotes.OnDungeonSelected(journalInstanceID)
    else
        MythicBossNotes.Print("We are not in a dungeon")
        -- Outside dungeons: respect showWindow + editMode
        if settings.showWindow then
            ui:Show()
            ui:SetMode(settings.editMode and "edit" or "passive")
        else
            ui:Hide()
        end
    end
end

local autoFrame = CreateFrame("Frame")
autoFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
autoFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
autoFrame:SetScript("OnEvent", function()
    C_Timer.After(1, MythicBossNotes.UpdateVisibility)
end)

------------------------------------------------------------
-- Boss Detection
------------------------------------------------------------
local encounterFrame = CreateFrame("Frame")
encounterFrame:RegisterEvent("ENCOUNTER_START")
encounterFrame:SetScript("OnEvent", function(_, _, encounterID, encounterName)
    MythicBossNotes.Print("Encounter started", encounterID, encounterName)
    local settings = MythicBossNotes.GetSettings()
    if settings.autoShowBoss then
        local journalId = MythicBossNotes.GetJournalIdFromEncounterId(MythicBossNotes.currentDungeon, encounterID)
        MythicBossNotes.OnBossSelected(nil, journalId, encounterName)
    end
end)

------------------------------------------------------------
-- Boss Ended Detection
------------------------------------------------------------
local encounterEndFrame = CreateFrame("Frame")
encounterEndFrame:RegisterEvent("ENCOUNTER_END")
encounterEndFrame:SetScript("OnEvent", function(_, _, _, encounterName, _, _, success)
    MythicBossNotes.Print("Encounter ended against ", encounterName)
    if success == 0 then return end
    local settings = MythicBossNotes.GetSettings()
    if settings.autoShowBoss then
        MythicBossNotes.OnDungeonSelected(MythicBossNotes.currentDungeon)
    end
end)

------------------------------------------------------------
-- Init / wiring
------------------------------------------------------------
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:SetScript("OnEvent", function(self, event, addon)
    if addon ~= ADDON_NAME then return end

    MythicBossNotes.Print("ADDON_LOADED:", addon)

    MythicBossNotes.GetSettings()
    MythicBossNotes.PopulateDungeonList()

    local ui = MythicBossNotes.UI
    if ui and ui.SetHandlers then
        ui:SetHandlers({
            OnDungeonSelected = MythicBossNotes.OnDungeonSelected,
            OnBossSelected    = MythicBossNotes.OnBossSelected,
        })
    end

    -- Initial visibility (will be refined by PLAYER_ENTERING_WORLD)
    C_Timer.After(1, MythicBossNotes.UpdateVisibility)

    self:UnregisterEvent("ADDON_LOADED")
end)

------------------------------------------------------------
-- External helper stubs (implemented in UI)
------------------------------------------------------------
MythicBossNotes.ApplyFont              = MythicBossNotes.ApplyFont              or function() end
MythicBossNotes.ApplyBackgroundOpacity = MythicBossNotes.ApplyBackgroundOpacity or function() end
MythicBossNotes.UpdateLockState        = MythicBossNotes.UpdateLockState        or function() end
