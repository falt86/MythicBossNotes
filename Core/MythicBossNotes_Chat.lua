-- MythicBossNotes_Chat.lua
local ADDON_NAME, MythicBossNotes = ...

local HEADER = "*****Mythic Boss Notes*****"

------------------------------------------------------------
-- Post current note text to chat
------------------------------------------------------------

function MythicBossNotes.PostNoteToChat()
    local ui = MythicBossNotes.UI
    if not ui then return end

    local rawText = ui:GetNoteText()
    if not rawText or rawText == "" then return end

    -- Normalize any textures back to tokens first
    local tokenText = MythicBossNotes.NormalizeNoteTextForStorage(rawText)
    -- Then tokens -> {rtX} for chat
    local chatText  = MythicBossNotes.ConvertTokensToRaidIcons(tokenText)

    local channel
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        channel = "INSTANCE_CHAT"
    elseif IsInGroup() then
        channel = "PARTY"
    else
        channel = "SAY"
    end

    SendChatMessage(HEADER, channel)

    for line in chatText:gmatch("[^\r\n]+") do
        -- No leading *, keep it simple and safe
        SendChatMessage(line, channel)
    end

    SendChatMessage("*************************", channel)
end
