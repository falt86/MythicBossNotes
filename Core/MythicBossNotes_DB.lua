-- MythicBossNotes_DB.lua
local ADDON_NAME, MythicBossNotes = ...

------------------------------------------------------------
-- DB helpers
------------------------------------------------------------

local function EnsureNoteTable(dungeonID)
    MythicBossNotesDB = MythicBossNotesDB or {}
    MythicBossNotesDB.global = MythicBossNotesDB.global or {}
    MythicBossNotesDB.global.notes = MythicBossNotesDB.global.notes or {}
    MythicBossNotesDB.global.notes[dungeonID] = MythicBossNotesDB.global.notes[dungeonID] or {
        dungeon = "",
    }
end

------------------------------------------------------------
-- Token / texture normalization for storage
------------------------------------------------------------

-- Convert any textures in the text back into {key} tokens
function MythicBossNotes.NormalizeNoteTextForStorage(text)
    text = text or ""
    local mk = MythicBossNotes.MarkerKeywords

    if not mk then return text end

    for key, id in pairs(mk) do
        -- Match escaped texture paths like: |TInterface\TargetingFrame\UI-RaidTargetingIcon_1:0|t
        -- In Lua patterns, - must be escaped with %-
        local texPattern = "|TInterface\\TargetingFrame\\UI%-RaidTargetingIcon_" .. id .. ":[^|]+|t"
        text = text:gsub(texPattern, "{" .. key .. "}")
    end

    return text
end

------------------------------------------------------------
-- Save / load
------------------------------------------------------------

function MythicBossNotes.SaveDungeonNote(dungeonID, text)
    MythicBossNotes.Print('Saving note for', dungeonID, text)
    if not dungeonID then return end

    EnsureNoteTable(dungeonID)
    text = MythicBossNotes.NormalizeNoteTextForStorage(text)
    MythicBossNotesDB.global.notes[dungeonID].dungeon = text or ""
end

function MythicBossNotes.SaveBossNote(dungeonID, encounterID, text)
    MythicBossNotes.Print('Saving note for', dungeonID, encounterID, text)
    if not dungeonID or not encounterID then return end

    EnsureNoteTable(dungeonID)
    text = MythicBossNotes.NormalizeNoteTextForStorage(text)
    MythicBossNotesDB.global.notes[dungeonID][encounterID] = text or ""
end

function MythicBossNotes.LoadDungeonNote(dungeonID)
    if not dungeonID then return "" end

    EnsureNoteTable(dungeonID)
    return MythicBossNotesDB.global.notes[dungeonID].dungeon or ""
end

function MythicBossNotes.LoadBossNote(dungeonID, encounterID)
    MythicBossNotes.Print('Loading note for', dungeonID, encounterID)
    if not dungeonID or not encounterID then return "" end

    EnsureNoteTable(dungeonID)
    return MythicBossNotesDB.global.notes[dungeonID][encounterID] or ""
end

------------------------------------------------------------
-- Save current selection
------------------------------------------------------------

function MythicBossNotes.SaveCurrentNote()
    local ui = MythicBossNotes.UI
    if not ui or not MythicBossNotes.currentDungeon then return end

    local dungeonID = MythicBossNotes.currentDungeon
    local rawText   = ui:GetNoteText() or ""
    local text      = MythicBossNotes.NormalizeNoteTextForStorage(rawText)

    if not MythicBossNotes.currentBoss or MythicBossNotes.currentBoss == 0 then
        MythicBossNotes.SaveDungeonNote(dungeonID, text)
    else
        MythicBossNotes.SaveBossNote(dungeonID, MythicBossNotes.currentBoss, text)
    end
end
