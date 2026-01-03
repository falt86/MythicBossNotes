-- MythicBossNotes/UI/UI_Dropdowns.lua
local ADDON_NAME, MythicBossNotes = ...

MythicBossNotes.UI = MythicBossNotes.UI or {}
local UI   = MythicBossNotes.UI
local Skin = MythicBossNotes.Skin

UI.handlers = UI.handlers or {
    OnDungeonSelected = nil,
    OnBossSelected    = nil,
}

------------------------------------------------------------
-- Click handlers
------------------------------------------------------------
local function Dungeon_OnClick(self)
    if UI.handlers.OnDungeonSelected then
        UI.handlers.OnDungeonSelected(self.value)
    end
end

local function Boss_OnClick(self)
    if UI.handlers.OnBossSelected then
        UI.handlers.OnBossSelected(nil, self.value, self:GetText())
    end
end

------------------------------------------------------------
-- Creation
------------------------------------------------------------
function UI:CreateDropdowns()
    if not self.frame or self.dungeonDropdown then return end

    local frame = self.frame

    -- Dungeon dropdown
    local dungeon = CreateFrame("Frame", "MythicBossNotes_DungeonDropdown", frame, "UIDropDownMenuTemplate")
    self.dungeonDropdown = dungeon
    dungeon:SetPoint("TOPLEFT", 0, -25)
    Skin:Dropdown(dungeon)
    UIDropDownMenu_SetText(dungeon, "Select Dungeon")

    -- Boss dropdown
    local boss = CreateFrame("Frame", "MythicBossNotes_BossDropdown", frame, "UIDropDownMenuTemplate")
    self.bossDropdown = boss
    boss:SetPoint("TOPLEFT", 0, -65)
    Skin:Dropdown(boss)
    UIDropDownMenu_SetText(boss, "Select Boss")
end

------------------------------------------------------------
-- Population
------------------------------------------------------------
function UI:RefreshDungeonDropdown()
    if not self.dungeonDropdown then return end

    UIDropDownMenu_Initialize(self.dungeonDropdown, function(_, level)
        level = level or 1
        if level ~= 1 then return end
        if not MythicBossNotes_DungeonList then return end

        for instanceKey, data in pairs(MythicBossNotes_DungeonList) do
            local info = UIDropDownMenu_CreateInfo()
            info.text  = data.name or instanceKey
            info.value = instanceKey
            info.func  = Dungeon_OnClick
            UIDropDownMenu_AddButton(info, level)
        end
    end)
end

function UI:RefreshBossDropdown(instanceKey)
    if not self.bossDropdown then return end

    UIDropDownMenu_Initialize(self.bossDropdown, function(_, level)
        level = level or 1
        if level ~= 1 then return end
        if not instanceKey or not MythicBossNotes_DungeonList then return end

        local data = MythicBossNotes_DungeonList[instanceKey]
        if not data or not data.bosses then return end

        local info = UIDropDownMenu_CreateInfo()
        info.text  = "Dungeon Note"
        info.value = 0
        info.func  = Boss_OnClick
        UIDropDownMenu_AddButton(info, level)

        local keys = {}
        for id in pairs(data.bosses) do
            table.insert(keys, id)
        end
        table.sort(keys)

        for _, id in ipairs(keys) do
            local name = data.bosses[id]
            local info2 = UIDropDownMenu_CreateInfo()
            info2.text  = name
            info2.value = id
            info2.func  = Boss_OnClick
            UIDropDownMenu_AddButton(info2, level)
        end
    end)
end
