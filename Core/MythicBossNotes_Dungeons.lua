-- MythicBossNotes_Dungeons.lua
-- Contains dungeon + boss data for Mythic Boss Notes
local ADDON_NAME, MythicBossNotes = ... 

MythicBossNotes_DungeonList = {}

function MythicBossNotes.PopulateDungeonList()
    MythicBossNotes.Print("Populating the dungeon list")
    local count = 0
    for i= 1, 20 do 
        local iid, iname = EJ_GetInstanceByIndex(i,false) 
        if iid then
            count = count + 1
            EJ_SelectInstance(iid)
            MythicBossNotes_DungeonList[iid] = {}
            MythicBossNotes_DungeonList[iid].name = iname
            MythicBossNotes_DungeonList[iid].bosses = {}
            for j = 1, 20 do
                local ename, _, eid = EJ_GetEncounterInfoByIndex(j, iid)
                if ename then 
                    MythicBossNotes_DungeonList[iid].bosses[eid] = ename
                end
            end
        end
    end
    MythicBossNotes.Print("Dungeons populated:", count)
end
