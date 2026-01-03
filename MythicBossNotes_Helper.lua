-- MythicBossNotes_Helper.lua
local ADDON_NAME, MythicBossNotes = ... 
MythicBossNotes.ADDON_NAME = ADDON_NAME

function MythicBossNotes.GetJournalInstanceIDs() 
    MythicBossNotes.Print("Getting Journal Instance IDs")
    local result = {}
    for i=1,20 do 
        local id,name=EJ_GetInstanceByIndex(i,false) 
        if id then result[id] = name end 
    end
    return result
end

function MythicBossNotes.GetEncounterIDs(journalInstanceID) 
    MythicBossNotes.Print("Getting the encounter IDs for", journalInstanceID)
    EJ_SelectInstance(journalInstanceID)
    local result = {}
    for i = 1, 20 do
        local name, _, id = EJ_GetEncounterInfoByIndex(i, journalInstanceID)
        if id then result[id] = name end
    end
    return result
end

function MythicBossNotes.FindJournalInstanceID(mapId)
    MythicBossNotes.Print('Getting instance for mapId', mapId)
    while mapId and mapId ~= 0 do
        local instanceID = EJ_GetInstanceForMap(mapId)
        if instanceID and instanceID ~= 0 then
            MythicBossNotes.Print('Found instance', instanceID)
            return instanceID
        end

        local info = C_Map.GetMapInfo(mapId)
        if not info or not info.parentMapID or info.parentMapID == 0 then
            MythicBossNotes.Print('No parent mapId found for mapId', mapId)
            break
        end

        mapId = info.parentMapID
    end
    MythicBossNotes.Print('No instance found for mapId', mapId)
    return nil
end

function MythicBossNotes.GetJournalIdFromEncounterId(journalInstanceID, dungeonEncounterID) 
    MythicBossNotes.Print("Getting the journal ID for", journalInstanceID, dungeonEncounterID)
    EJ_SelectInstance(journalInstanceID)
    for i = 1, 20 do
        local name, _, id, _,_,_, deid = EJ_GetEncounterInfoByIndex(i, journalInstanceID)
        if deid then 
            MythicBossNotes.Print('Encounter', dungeonEncounterID, "is journal", id)
            if deid == dungeonEncounterID then return id end 
        end
    end
    return dungeonEncounterID
end

function MythicBossNotes.Dump(o, indent)
    indent = indent or ""
    if type(o) == "table" then
        for k, v in pairs(o) do
            local key = tostring(k)
            if type(v) == "table" then
                MythicBossNotes.Print(indent .. key .. " = {")
                MythicBossNotes.Dump(v, indent .. "  ")
                MythicBossNotes.Print(indent .. "}")
            else
                MythicBossNotes.Print(indent .. key .. " = " .. tostring(v))
            end
        end
    else
        MythicBossNotes.Print(indent .. tostring(o))
    end
end
