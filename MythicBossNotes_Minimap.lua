-- MythicBossNotes_Minimap.lua
local ADDON_NAME, MythicBossNotes = ...

local ICON_NAME = "MythicBossNotesMinimapIcon"

local LDB     = LibStub and LibStub("LibDataBroker-1.1", true)
local LDBIcon = LibStub and LibStub("LibDBIcon-1.0", true)

MythicBossNotesDB = MythicBossNotesDB or {}
MythicBossNotesDB.minimap = MythicBossNotesDB.minimap or { hide = false }

if LDB and LDBIcon then
    local dataObject = LDB:NewDataObject(ICON_NAME, {
        type = "launcher",
        text = "Mythic Boss Notes",
        icon = "Interface\\MINIMAP\\TRACKING\\QuestBlob",

        OnClick = function(_, button)
            if button == "LeftButton" then
                -- Post current note to PARTY
                if MythicBossNotes.PostNoteToChat then
                    MythicBossNotes.PostNoteToChat("PARTY")
                end
                return
            end

            if button == "RightButton" then
                if MythicBossNotes.OpenOptions then
                    MythicBossNotes.OpenOptions()
                end
                return
            end
        end,

        OnTooltipShow = function(tooltip)
            tooltip:AddLine("Mythic Boss Notes")
            tooltip:AddLine("|cffffff00Left-click|r to post note to party")
            tooltip:AddLine("|cffffff00Right-click|r to open settings")
        end,
    })

    LDBIcon:Register(ICON_NAME, dataObject, MythicBossNotesDB.minimap)
end

function MythicBossNotes.ToggleMinimapIcon()
    if not LDBIcon then return end
    local minimap = MythicBossNotesDB.minimap
    minimap.hide = not minimap.hide

    if minimap.hide then
        LDBIcon:Hide(ICON_NAME)
    else
        LDBIcon:Show(ICON_NAME)
    end
end
