-- Hotline Internal | v11 | Final Verified
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    Combat = {
        Enabled = false, Keybind = Enum.UserInputType.MouseButton2, Smoothness = 15,
        FOV = 150, WallCheck = true, TeamCheck = true, Hitpart = "Head",
        Prediction = 0.15, IgnoreDead = true, ShowFOV = true
    },
    ESP = {
        Box = false, Tracers = false, HealthBar = false, Name = false,
        ToolName = false, Skeleton = false, Chams = false, Glow = false,
        ESPTeamCheck = true, ESPWallCheck = false
    },
    Misc = {
        Speed = false, SpeedValue = 16,
        Jump = false, JumpValue = 50,
        Fly = false,
        Noclip = false
    }
}

local UI = {
    Toggled = true, Tab = "Combat", Elements = {},
    Pos = Vector2.new(200, 200), Size = Vector2.new(620, 500),
    Dragging = false, DragStart = Vector2.new(0, 0)
}

-- === МЕНЮ ===
local gui = {}
gui.Main = Drawing.new("Square"); gui.Main.Size = UI.Size; gui.Main.Color = Color3.fromRGB(10, 10, 10); gui.Main.Filled = true
gui.Outline = Drawing.new("Square"); gui.Outline.Size = UI.Size; gui.Outline.Color = Color3.fromRGB(50, 50, 50); gui.Outline.Thickness = 1; gui.Outline.Filled = false
gui.TopBar = Drawing.new("Square"); gui.TopBar.Size = Vector2.new(UI.Size.X, 45); gui.TopBar.Color = Color3.fromRGB(18, 18, 18); gui.TopBar.Filled = true
gui.TopLine = Drawing.new("Line"); gui.TopLine.Color = Color3.fromRGB(255, 30, 30); gui.TopLine.Thickness = 2
gui.Title = Drawing.new("Text"); gui.Title.Size = 22; gui.Title.Outline = true; gui.Title.Color = Color3.fromRGB(255, 255, 255); gui.Title.Text = "HOTLINE INTERNAL"

local tabs = {"Combat", "ESP", "Misc"}
gui.TabButtons = {}; gui.TabBackgrounds = {}
for i, tabName in ipairs(tabs) do
    local bg = Drawing.new("Square"); bg.Size = Vector2.new(100, 30); bg.Color = Color3.fromRGB(25, 25, 25); bg.Filled = true
    local btn = Drawing.new("Text"); btn.Text = tabName; btn.Size = 16; btn.Center = true; btn.Outline = true; btn.Color = Color3.fromRGB(150, 150, 150)
    gui.TabButtons[tabName] = btn; gui.TabBackgrounds[tabName] = bg
end

local fovCircle = Drawing.new("Circle"); fovCircle.Thickness = 1; fovCircle.Color = Color3.fromRGB(255, 30, 30); fovCircle.Filled = false

-- === ЭЛЕМЕНТЫ ===
local function AddCheckbox(text, x, y, tab, category, key)
    local box = Drawing.new("Square"); box.Size = Vector2.new(14, 14); box.Color = Color3.fromRGB(60, 60, 60); box.Filled = true
    local label = Drawing.new("Text"); label.Text = text; label.Size = 15; label.Outline = true; label.Color = Color3.fromRGB(180, 180, 180)
    table.insert(UI.Elements, {Tab = tab, Type = "Checkbox", Box = box, Label = label, Category = category, Key = key, Text = text, X = x, Y = y})
end
local function AddSlider(text, x, y, tab, category, key, min, max)
    local bg = Drawing.new("Square"); bg.Size = Vector2.new(160, 4); bg.Color = Color3.fromRGB(35, 35, 35); bg.Filled = true
    local fill = Drawing.new("Square"); fill.Size = Vector2.new(0, 4); fill.Color = Color3.fromRGB(255, 30, 30); fill.Filled = true
    local label = Drawing.new("Text"); label.Text = text .. ": " .. Config[category][key]; label.Size = 15; label.Outline = true; label.Color = Color3.fromRGB(180, 180, 180)
    table.insert(UI.Elements, {Tab = tab, Type = "Slider", Bg = bg, Fill = fill, Label = label, Category = category, Key = key, Min = min, Max = max, Text = text, X = x, Y = y})
end
local function AddDropdown(text, x, y, tab, category, key, options)
    local label = Drawing.new("Text"); label.Text = text .. ": " .. tostring(Config[category][key]); label.Size = 15; label.Outline = true; label.Color = Color3.fromRGB(180, 180, 180)
    table.insert(UI.Elements, {Tab = tab, Type = "Dropdown", Label = label, Category = category, Key = key, Options = options, Text = text, X = x, Y = y})
end
local function AddSection(text, x, y, tab)
    local label = Drawing.new("Text"); label.Text = text; label.Size = 14; label.Outline = true; label.Color = Color3.fromRGB(255, 30, 30)
    local line = Drawing.new("Line"); line.Thickness = 1; line.Color = Color3.fromRGB(50, 50, 50)
    table.insert(UI.Elements, {Tab = tab, Type = "Section", Label = label, Line = line, Text = text, X = x, Y = y})
end

-- COMBAT
AddSection("> AIMBOT SETTINGS", 20, 90, "Combat")
AddCheckbox("Enable Aimbot", 20, 120, "Combat", "Combat", "Enabled")
AddCheckbox("Wall Check", 20, 150, "Combat", "Combat", "WallCheck")
AddCheckbox("Team Check", 20, 180, "Combat", "Combat", "TeamCheck")
AddCheckbox("Ignore Dead", 20, 210, "Combat", "Combat", "IgnoreDead")
AddCheckbox("Show FOV", 20, 240, "Combat", "Combat", "ShowFOV")
AddSlider("Smoothness", 240, 120, "Combat", "Combat", "Smoothness", 1, 100)
AddSlider("FOV", 240, 170, "Combat", "Combat", "FOV", 10, 500)
AddSlider("Prediction", 240, 220, "Combat", "Combat", "Prediction", 0, 1)
AddDropdown("Hitpart", 240, 270, "Combat", "Combat", "Hitpart", {"Head", "Torso", "HumanoidRootPart"})

-- ESP
AddSection("> PLAYER ESP", 20, 90, "ESP")
AddCheckbox("Box", 20, 120, "ESP", "ESP", "Box")
AddCheckbox("Tracers", 20, 150, "ESP", "ESP", "Tracers")
AddCheckbox("Health Bar", 20, 180, "ESP", "ESP", "HealthBar")
AddCheckbox("Name", 20, 210, "ESP", "ESP", "Name")
AddCheckbox("Tool Name", 20, 240, "ESP", "ESP", "ToolName")
AddCheckbox("Skeleton", 240, 120, "ESP", "ESP", "Skeleton")
AddCheckbox("Chams", 240, 150, "ESP", "ESP", "Chams")
AddCheckbox("Glow", 240, 180, "ESP", "ESP", "Glow")
AddCheckbox("ESP Team Check", 240, 210, "ESP", "ESP", "ESPTeamCheck")
AddCheckbox("ESP Wall Check", 240, 240, "ESP", "ESP", "ESPWallCheck")

-- MISC
AddSection("> MOVEMENT", 20, 90, "Misc")
AddCheckbox("SpeedChanger", 20, 120, "Misc", "Misc", "Speed")
AddSlider("Speed", 20, 150, "Misc", "Misc", "SpeedValue", 16, 200)
AddCheckbox("JumpPowerChanger", 20, 200, "Misc", "Misc", "Jump")
AddSlider("Jump Power", 20, 230, "Misc", "Misc", "JumpValue", 50, 300)
AddCheckbox("Fly", 240, 120, "Misc", "Misc", "Fly")
AddCheckbox("Noclip", 240, 150, "Misc", "Misc", "Noclip")
AddSection("> INFO", 240, 190, "Misc")

-- === ЛОГИКА ОТРИСОВКИ ===
RunService.RenderStepped:Connect(function()
    gui.Main.Position = UI.Pos; gui.Outline.Position = UI.Pos; gui.TopBar.Position = UI.Pos
    gui.Title.Position = UI.Pos + Vector2.new(20, 10); gui.TopLine.From = UI.Pos + Vector2.new(0, 45); gui.TopLine.To = UI.Pos + Vector2.new(UI.Size.X, 45)
    
    gui.Main.Visible = UI.Toggled; gui.Outline.Visible = UI.Toggled; gui.TopBar.Visible = UI.Toggled; gui.TopLine.Visible = UI.Toggled; gui.Title.Visible = UI.Toggled
    
    for i, tabName in ipairs(tabs) do
        local btn = gui.TabButtons[tabName]; local bg = gui.TabBackgrounds[tabName]
        local xPos = UI.Pos.X + 20 + (i - 1) * 110; local yPos = UI.Pos.Y + 50
        bg.Position = Vector2.new(xPos, yPos); btn.Position = Vector2.new(xPos + 50, yPos + 6)
        bg.Visible = UI.Toggled; btn.Visible = UI.Toggled
        if UI.Tab == tabName then btn.Color = Color3.fromRGB(255, 255, 255); bg.Color = Color3.fromRGB(255, 30, 30)
        else btn.Color = Color3.fromRGB(150, 150, 150); bg.Color = Color3.fromRGB(25, 25, 25) end
    end

    for _, el in ipairs(UI.Elements) do
        local isCurrent = (el.Tab == UI.Tab)
        el.Label.Visible = UI.Toggled and isCurrent
        if el.Type == "Slider" then el.Bg.Visible = UI.Toggled and isCurrent; el.Fill.Visible = UI.Toggled and isCurrent
        elseif el.Type == "Checkbox" then el.Box.Visible = UI.Toggled and isCurrent
        elseif el.Type == "Section" then el.Line.Visible = UI.Toggled and isCurrent end
        
        if isCurrent then
            local basePos = UI.Pos; local xPos = el.X; local yPos = el.Y
            if el.Type == "Slider" then
                el.Label.Position = basePos + Vector2.new(xPos, yPos); el.Bg.Position = basePos + Vector2.new(xPos, yPos + 22); el.Fill.Position = basePos + Vector2.new(xPos, yPos + 22)
                local val = Config[el.Category][el.Key]; local percent = (val - el.Min) / (el.Max - el.Min)
                el.Fill.Size = Vector2.new(160 * percent, 4)
            elseif el.Type == "Checkbox" then
                el.Box.Position = basePos + Vector2.new(xPos, yPos); el.Label.Position = basePos + Vector2.new(xPos + 22, yPos - 1)
                el.Box.Color = Config[el.Category][el.Key] and Color3.fromRGB(255, 30, 30) or Color3.fromRGB(60, 60, 60)
            elseif el.Type == "Dropdown" then
                el.Label.Position = basePos + Vector2.new(xPos, yPos)
            elseif el.Type == "Section" then
                el.Label.Position = basePos + Vector2.new(xPos, yPos); el.Line.From = basePos + Vector2.new(xPos + 130, yPos + 8); el.Line.To = basePos + Vector2.new(UI.Size.X - 20, yPos + 8)
            end
        end
    end

    -- FOV Circle
    if Config.Combat.Enabled and Config.Combat.ShowFOV and not UI.Toggled then
        fovCircle.Visible = true; fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2); fovCircle.Radius = Config.Combat.FOV / 2
    else fovCircle.Visible = false end
end)

-- === ОБРАБОТКА ВВОДА ===
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then UI.Toggled = not UI.Toggled end
    if not UI.Toggled then return end
    local mousePos = UserInputService:GetMouseLocation()

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if mousePos.X >= UI.Pos.X and mousePos.X <= UI.Pos.X + UI.Size.X and mousePos.Y >= UI.Pos.Y and mousePos.Y <= UI.Pos.Y + 45 then
            UI.Dragging = true; UI.DragStart = mousePos - UI.Pos
        end
        for tabName, btn in pairs(gui.TabButtons) do
            local size = btn.TextBounds
            if mousePos.X >= btn.Position.X - size.X/2 and mousePos.X <= btn.Position.X + size.X/2 and mousePos.Y >= btn.Position.Y - size.Y/2 and mousePos.Y <= btn.Position.Y + size.Y/2 then
                UI.Tab = tabName
            end
        end
        for _, el in ipairs(UI.Elements) do
            if el.Tab == UI.Tab then
                if el.Type == "Checkbox" then
                    if mousePos.X >= el.Box.Position.X and mousePos.X <= el.Box.Position.X + 14 and mousePos.Y >= el.Box.Position.Y and mousePos.Y <= el.Box.Position.Y + 14 then
                        Config[el.Category][el.Key] = not Config[el.Category][el.Key]
                    end
                elseif el.Type == "Slider" then
                    if mousePos.X >= el.Bg.Position.X and mousePos.X <= el.Bg.Position.X + 160 and mousePos.Y >= el.Bg.Position.Y - 5 and mousePos.Y <= el.Bg.Position.Y + 10 then
                        local percent = math.clamp((mousePos.X - el.Bg.Position.X) / 160, 0, 1)
                        Config[el.Category][el.Key] = math.floor(el.Min + (el.Max - el.Min) * percent)
                        el.Label.Text = el.Text .. ": " .. Config[el.Category][el.Key]
                    end
                elseif el.Type == "Dropdown" then
                    local size = el.Label.TextBounds
                    if mousePos.X >= el.Label.Position.X and mousePos.X <= el.Label.Position.X + size.X and mousePos.Y >= el.Label.Position.Y and mousePos.Y <= el.Label.Position.Y + size.Y then
                        local currentIdx = table.find(el.Options, Config[el.Category][el.Key])
                        local nextIdx = (currentIdx or 1) + 1
                        if nextIdx > #el.Options then nextIdx = 1 end
                        Config[el.Category][el.Key] = el.Options[nextIdx]
                        el.Label.Text = el.Text .. ": " .. tostring(Config[el.Category][el.Key])
                    end
                end
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then UI.Dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if UI.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        UI.Pos = UserInputService:GetMouseLocation() - UI.DragStart
    end
end)

-- === ESP ===
local espCache = {}
local function ClearESP()
    for p, obj in pairs(espCache) do
        if obj.Box then obj.Box:Remove() end
        if obj.Name then obj.Name:Remove() end
        if obj.HealthBg then obj.HealthBg:Remove() end
        if obj.Health then obj.Health:Remove() end
        if obj.Tracer then obj.Tracer:Remove() end
        if obj.ToolName then obj.ToolName:Remove() end
        if obj.Glow then obj.Glow:Remove() end
        if obj.Skeleton then for _, line in pairs(obj.Skeleton) do line:Remove() end end
        if obj.Highlight then obj.Highlight:Destroy() end
    end
    espCache = {}
end

RunService.RenderStepped:Connect(function()
    if not LocalPlayer.Character then ClearESP() return end
    
    -- Очистка от вышедших игроков (БАГ-ФИКС: убрал проверку p.Parent)
    for p, obj in pairs(espCache) do
        if not Players:FindFirstChild(p.Name) then
            if obj.Box then obj.Box:Remove() end
            if obj.Name then obj.Name:Remove() end
            if obj.HealthBg then obj.HealthBg:Remove() end
            if obj.Health then obj.Health:Remove() end
            if obj.Tracer then obj.Tracer:Remove() end
            if obj.ToolName then obj.ToolName:Remove() end
            if obj.Glow then obj.Glow:Remove() end
            if obj.Skeleton then for _, line in pairs(obj.Skeleton) do line:Remove() end end
            if obj.Highlight then obj.Highlight:Destroy() end
            espCache[p] = nil
        end
    end

    local allESPDisabled = not (Config.ESP.Box or Config.ESP.Name or Config.ESP.HealthBar or Config.ESP.Tracers or Config.ESP.Chams or Config.ESP.Glow or Config.ESP.ToolName or Config.ESP.Skeleton)
    if allESPDisabled then ClearESP() return end
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if Config.ESP.ESPTeamCheck and player.Team == LocalPlayer.Team then continue end
        
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local humanoid = char and char:FindFirstChild("Humanoid")
        
        -- БАГ-ФИКС: Пересоздание при респавне
        if espCache[player] and espCache[player].Character ~= char then
            if espCache[player].Box then espCache[player].Box:Remove() end
            if espCache[player].Name then espCache[player].Name:Remove() end
            if espCache[player].HealthBg then espCache[player].HealthBg:Remove() end
            if espCache[player].Health then espCache[player].Health:Remove() end
            if espCache[player].Tracer then espCache[player].Tracer:Remove() end
            if espCache[player].ToolName then espCache[player].ToolName:Remove() end
            if espCache[player].Glow then espCache[player].Glow:Remove() end
            if espCache[player].Skeleton then for _, line in pairs(espCache[player].Skeleton) do line:Remove() end end
            if espCache[player].Highlight then espCache[player].Highlight:Destroy() end
            espCache[player] = nil
        end

        if not hrp or not head or not humanoid or humanoid.Health <= 0 then 
            if espCache[player] then
                local obj = espCache[player]
                obj.Box.Visible = false; obj.Name.Visible = false; obj.HealthBg.Visible = false; obj.Health.Visible = false; obj.Tracer.Visible = false; obj.ToolName.Visible = false; obj.Glow.Visible = false
                for _, line in ipairs(obj.Skeleton) do line.Visible = false end
                if obj.Highlight then obj.Highlight.Enabled = false end
            end
            continue 
        end
        
        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        local hPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        
        if onScreen then
            if Config.ESP.ESPWallCheck then
                local ray = Ray.new(Camera.CFrame.Position, (hrp.Position - Camera.CFrame.Position).Unit * (hrp.Position - Camera.CFrame.Position).Magnitude)
                local hit, _ = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, Camera})
                if hit and not hit:IsDescendantOf(char) then
                    if espCache[player] then
                        local obj = espCache[player]
                        obj.Box.Visible = false; obj.Name.Visible = false; obj.HealthBg.Visible = false; obj.Health.Visible = false; obj.Tracer.Visible = false; obj.ToolName.Visible = false; obj.Glow.Visible = false
                        for _, line in ipairs(obj.Skeleton) do line.Visible = false end
                        if obj.Highlight then obj.Highlight.Enabled = false end
                    end
                    continue
                end
            end

            if not espCache[player] then
                local obj = {}
                obj.Character = char
                obj.Box = Drawing.new("Square"); obj.Box.Thickness = 1; obj.Box.Filled = false; obj.Box.Color = Color3.fromRGB(255, 255, 255)
                obj.Name = Drawing.new("Text"); obj.Name.Size = 14; obj.Name.Center = true; obj.Name.Outline = true; obj.Name.Color = Color3.new(1, 1, 1)
                obj.HealthBg = Drawing.new("Square"); obj.HealthBg.Thickness = 1; obj.HealthBg.Filled = true; obj.HealthBg.Color = Color3.new(0, 0, 0)
                obj.Health = Drawing.new("Square"); obj.Health.Thickness = 1; obj.Health.Filled = true
                obj.Tracer = Drawing.new("Line"); obj.Tracer.Thickness = 1; obj.Tracer.Color = Color3.fromRGB(255, 255, 255)
                obj.ToolName = Drawing.new("Text"); obj.ToolName.Size = 12; obj.ToolName.Center = true; obj.ToolName.Outline = true; obj.ToolName.Color = Color3.fromRGB(200, 200, 200)
                obj.Glow = Drawing.new("Square"); obj.Glow.Thickness = 3; obj.Glow.Filled = false; obj.Glow.Color = Color3.fromRGB(255, 0, 0)
                obj.Skeleton = {}
                for i = 1, 10 do local line = Drawing.new("Line"); line.Thickness = 1; line.Color = Color3.fromRGB(255, 255, 255); table.insert(obj.Skeleton, line) end
                local hl = Instance.new("Highlight"); hl.FillColor = Color3.fromRGB(255, 0, 0); hl.FillTransparency = 0.5; hl.OutlineColor = Color3.fromRGB(255, 255, 255); hl.OutlineTransparency = 0; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent = char; obj.Highlight = hl
                espCache[player] = obj
            end
            local obj = espCache[player]
            local h = math.abs(hPos.Y - pos.Y) * 2; local w = h / 2
            obj.Box.Visible = Config.ESP.Box; obj.Box.Size = Vector2.new(w, h); obj.Box.Position = Vector2.new(pos.X - w/2, pos.Y - h/2)
            obj.Name.Visible = Config.ESP.Name; obj.Name.Text = player.Name; obj.Name.Position = Vector2.new(pos.X, pos.Y - h/2 - 16)
            obj.HealthBg.Visible = Config.ESP.HealthBar; obj.Health.Visible = Config.ESP.HealthBar
            local hp = humanoid.Health / humanoid.MaxHealth
            obj.HealthBg.Size = Vector2.new(3, h); obj.HealthBg.Position = Vector2.new(pos.X - w/2 - 6, pos.Y - h/2)
            obj.Health.Size = Vector2.new(3, h * hp); obj.Health.Position = Vector2.new(pos.X - w/2 - 6, pos.Y - h/2 + (h - h * hp))
            obj.Health.Color = Color3.fromRGB(255 * (1 - hp), 255 * hp, 0)
            obj.Tracer.Visible = Config.ESP.Tracers; obj.Tracer.From = center; obj.Tracer.To = Vector2.new(pos.X, pos.Y + h/2)
            if Config.ESP.ToolName then
                local tool = char:FindFirstChildOfClass("Tool")
                obj.ToolName.Visible = tool ~= nil
                if tool then obj.ToolName.Text = tool.Name; obj.ToolName.Position = Vector2.new(pos.X, pos.Y + h/2 + 2) end
            else obj.ToolName.Visible = false end
            obj.Glow.Visible = Config.ESP.Glow; obj.Glow.Size = Vector2.new(w + 4, h + 4); obj.Glow.Position = Vector2.new(pos.X - w/2 - 2, pos.Y - h/2 - 2)
            for _, line in ipairs(obj.Skeleton) do line.Visible = false end
            if Config.ESP.Skeleton then
                local function drawLine(p1, p2, index)
                    local v1, on1 = Camera:WorldToViewportPoint(p1); local v2, on2 = Camera:WorldToViewportPoint(p2)
                    if on1 and on2 and obj.Skeleton[index] then obj.Skeleton[index].From = Vector2.new(v1.X, v1.Y); obj.Skeleton[index].To = Vector2.new(v2.X, v2.Y); obj.Skeleton[index].Visible = true end
                end
                if char:FindFirstChild("UpperTorso") then
                    drawLine(head.Position, char.UpperTorso.Position, 1); drawLine(char.UpperTorso.Position, char.LowerTorso.Position, 2)
                    drawLine(char.LowerTorso.Position, char.LeftUpperLeg.Position, 3); drawLine(char.LowerTorso.Position, char.RightUpperLeg.Position, 4)
                    drawLine(char.UpperTorso.Position, char.LeftUpperArm.Position, 5); drawLine(char.UpperTorso.Position, char.RightUpperArm.Position, 6)
                elseif char:FindFirstChild("Torso") then
                    drawLine(head.Position, char.Torso.Position, 1); drawLine(char.Torso.Position, char["Left Leg"].Position, 2)
                    drawLine(char.Torso.Position, char["Right Leg"].Position, 3); drawLine(char.Torso.Position, char["Left Arm"].Position, 4); drawLine(char.Torso.Position, char["Right Arm"].Position, 5)
                end
            end
            obj.Highlight.Enabled = Config.ESP.Chams
            if obj.Highlight.Parent ~= char then obj.Highlight.Parent = char end
        else
            if espCache[player] then
                local obj = espCache[player]
                obj.Box.Visible = false; obj.Name.Visible = false; obj.HealthBg.Visible = false; obj.Health.Visible = false; obj.Tracer.Visible = false; obj.ToolName.Visible = false; obj.Glow.Visible = false
                for _, line in ipairs(obj.Skeleton) do line.Visible = false end
                if obj.Highlight then obj.Highlight.Enabled = false end
            end
        end
    end
end)

-- === AIMBOT ===
local aimbotActive = false
UserInputService.InputBegan:Connect(function(input, gp) if gp then return end; if input.UserInputType == Config.Combat.Keybind and not UI.Toggled then aimbotActive = true; Camera.CameraType = Enum.CameraType.Scriptable end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Config.Combat.Keybind then aimbotActive = false; Camera.CameraType = Enum.CameraType.Custom end end)

RunService.RenderStepped:Connect(function()
    if not Config.Combat.Enabled or not aimbotActive or not LocalPlayer.Character then return end
    local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closest = nil; local minDist = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if Config.Combat.TeamCheck and player.Team == LocalPlayer.Team then continue end
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChild("Humanoid")
        if not hrp or not humanoid or humanoid.Health <= 0 then if Config.Combat.IgnoreDead then continue end end
        local targetPart = char:FindFirstChild(Config.Combat.Hitpart) or char:FindFirstChild("Head") or hrp
        local targetPos = targetPart.Position
        if Config.Combat.Prediction > 0 then local vel = targetPart.AssemblyLinearVelocity or targetPart.Velocity; targetPos = targetPos + (vel * Config.Combat.Prediction) end
        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
        if onScreen then
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
            if dist <= Config.Combat.FOV and dist < minDist then
                if Config.Combat.WallCheck then
                    local ray = Ray.new(Camera.CFrame.Position, (targetPos - Camera.CFrame.Position).Unit * (targetPos - Camera.CFrame.Position).Magnitude)
                    local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, Camera})
                    if hit and not hit:IsDescendantOf(char) then continue end
                end
                minDist = dist; closest = targetPos
            end
        end
    end
    if closest then
        local currentCFrame = Camera.CFrame
        local targetCFrame = CFrame.new(currentCFrame.Position, closest)
        local smoothFactor = 1 - (Config.Combat.Smoothness / 100)
        Camera.CFrame = currentCFrame:Lerp(targetCFrame, smoothFactor)
    end
end)

-- === MISC FUNCTIONS ===
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if humanoid then
        humanoid.WalkSpeed = Config.Misc.Speed and Config.Misc.SpeedValue or 16
        humanoid.UseJumpPower = true
        humanoid.JumpPower = Config.Misc.Jump and Config.Misc.JumpValue or 50
    end

    if Config.Misc.Fly and hrp then
        local moveDir = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        
        if moveDir.Magnitude > 0 then hrp.Velocity = moveDir.Unit * 50
        else hrp.Velocity = Vector3.new(0, 0, 0) end
    end

    if Config.Misc.Noclip then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
        end
    end
end)

print("Hotline Internal v11 Loaded. Press RightShift to toggle menu.")
