local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
end)

pcall(function()
    local mt = getrawmetatable(game)
    if mt then
        setreadonly(mt, false)
        local oldIndex = mt.__index
        mt.__index = newcclosure(function(self, k)
            if k == "WalkSpeed" or k == "JumpPower" or k == "HipHeight" then
                return oldIndex(self, k)
            end
            return oldIndex(self, k)
        end)
        setreadonly(mt, true)
    end
end)

local Window = Library:CreateWindow({
    Title = 'Apex Hub | Universal',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Main'),
    Aimbot = Window:AddTab('Aimbot'),
    ESP = Window:AddTab('ESP'),
    Fling = Window:AddTab('Fling'),
    Misc = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local LeftMain = Tabs.Main:AddLeftGroupbox('Move and upgrade body')
local RightMain = Tabs.Main:AddRightGroupbox('Teleport')

LeftMain:AddSlider('WalkSpeedSlider', { Text = 'Walkspeed', Default = 16, Min = 16, Max = 1000, Rounding = 0, Compact = false })
LeftMain:AddSlider('CFrameSpeedSlider', { Text = 'Speed bypass', Default = 1, Min = 1, Max = 5, Rounding = 1, Compact = false })
LeftMain:AddSlider('JumpPowerSlider', { Text = 'Jump power', Default = 50, Min = 50, Max = 500, Rounding = 0, Compact = false })
LeftMain:AddToggle('InfiniteJumpToggle', { Text = 'Infinite Jump', Default = false })
LeftMain:AddToggle('NoClipToggle', { Text = 'Noclip', Default = false })
LeftMain:AddToggle('SpinToggle', { Text = 'Spin', Default = false })
LeftMain:AddSlider('SpinSpeedSlider', { Text = 'Spin speed', Default = 20, Min = 20, Max = 150, Rounding = 0, Compact = false })
LeftMain:AddToggle('FlyToggle', { Text = 'Fly', Default = false })
LeftMain:AddSlider('FlySpeedSlider', { Text = 'Fly speed', Default = 50, Min = 50, Max = 300, Rounding = 0, Compact = false })

LeftMain:AddToggle('ThirdPersonToggle', { Text = 'Third Person', Default = false })
LeftMain:AddSlider('ThirdPersonDist', { Text = 'Third person distance', Default = 10, Min = 2, Max = 30, Rounding = 0, Compact = false })

RightMain:AddInput('TPInput', {
    Default = '0, 0',
    Numeric = false,
    Finished = false,
    Text = 'Teleport coordinates (X, Y)',
    Tooltip = 'Please separate by commas when entering',
})

RightMain:AddButton('Teleport to coordinates', function()
    local text = Options.TPInput.Value
    local x, y = text:match("([^,]+),%s*(.+)")
    if x and y then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(tonumber(x) or 0, tonumber(y) or 0, char.HumanoidRootPart.Position.Z)
        end
    end
end)

local SavedCoords = nil
RightMain:AddButton('Now coordinates save', function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        SavedCoords = char.HumanoidRootPart.CFrame
        Library:Notify('The current coordinates have been saved.')
    end
end)

RightMain:AddButton('Teleport to saved coordinates.', function()
    if SavedCoords then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = SavedCoords
            Library:Notify('Teleported to the saved coordinates.')
        end
    else
        Library:Notify('No saved coordinates!')
    end
end)

local LeftAim = Tabs.Aimbot:AddLeftGroupbox('Aimbot setting')
local RightAim = Tabs.Aimbot:AddRightGroupbox('Target or filter')

LeftAim:AddToggle('AimbotToggle', { Text = 'On aimbot', Default = false })
LeftAim:AddSlider('AimbotSmoothness', { Text = 'Aim smooth', Default = 20, Min = 1, Max = 100, Rounding = 0, Compact = false })
LeftAim:AddSlider('AimbotRange', { Text = 'Targeting distance', Default = 100, Min = 10, Max = 500, Rounding = 0, Compact = false })
LeftAim:AddToggle('WallCheckToggle', { Text = 'Wall check', Default = true })
LeftAim:AddToggle('TriggerbotToggle', { Text = 'Triggerbot', Default = false })

RightAim:AddDropdown('AimPartDropdown', {
    Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftHand", "RightHand", "LeftFoot", "RightFoot"},
    Default = 1,
    Text = 'Targeting Part',
})

local LeftEsp = Tabs.ESP:AddLeftGroupbox('ESP')

LeftEsp:AddToggle('ESP_Highlight', { Text = 'Highlight', Default = false }):AddColorPicker('HighlightFillColor', {
    Default = Color3.fromRGB(255, 50, 50),
    Title = 'Fill Color',
}):AddColorPicker('HighlightOutlineColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Outline Color',
})

LeftEsp:AddToggle('ESP_Name', { Text = 'Name Tag', Default = false })
LeftEsp:AddToggle('ESP_Health', { Text = 'Health Bar', Default = false })
LeftEsp:AddToggle('ESP_Box', { Text = '2D Box ESP', Default = false })

local LeftFling = Tabs.Fling:AddLeftGroupbox('Target Fling')
local RightFling = Tabs.Fling:AddRightGroupbox('Protection')

local function GetPlayerNames()
    local names = {}
    local success, err = pcall(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(names, p.Name)
            end
        end
    end)
    if not success or #names == 0 then
        table.insert(names, "None")
    end
    return names
end

local TargetDropdown = LeftFling:AddDropdown('FlingTargetDropdown', {
    Values = GetPlayerNames(),
    Default = 1,
    Text = 'Target Player',
})

LeftFling:AddButton('Refresh Player List', function()
    TargetDropdown:SetValues(GetPlayerNames())
    TargetDropdown:SetValue(GetPlayerNames()[1])
end)

local Flinging = false
LeftFling:AddToggle('FlingToggle', { Text = 'Start Fling Target', Default = false }):OnChanged(function()
    Flinging = Toggles.FlingToggle.Value
    if not Flinging then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local bv = hrp and hrp:FindFirstChild("FlingVelocity")
        local bg = hrp and hrp:FindFirstChild("FlingGyro")
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end
end)

RightFling:AddToggle('AntiFlingToggle', { Text = 'Anti-Fling', Default = true })

local LeftMisc = Tabs.Misc:AddLeftGroupbox('Character Reset')
LeftMisc:AddButton('Respawn Character', function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").Health = 0
    end
end)

local RightMisc = Tabs.Misc:AddRightGroupbox('Server Hop')
RightMisc:AddToggle('AutoRejoinToggle', { Text = 'Auto Rejoin', Default = false })
RightMisc:AddButton('Hop to Another Server', function()
    Library:Notify('Searching for server...', 2)
    local success, err = pcall(function()
        local servers = {}
        local req = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Desc&limit=100'))
        if req and req.data then
            for _, s in ipairs(req.data) do
                if type(s) == "table" and s.id ~= game.JobId and s.playing < s.maxPlayers then
                    table.insert(servers, s.id)
                end
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            Library:Notify('No servers found!', 3)
        end
    end)
    if not success then
        Library:Notify('Failed to hop server.', 3)
    end
end)

TeleportService.TeleportInitFailed:Connect(function(player, result, errorMessage)
    if player == LocalPlayer and Toggles.AutoRejoinToggle.Value then
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu Control')

MenuGroup:AddButton('Unload Hub', function()
    Library:Unload()
end)

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', {
    Default = 'RightShift',
    NoUI = true,
    Text = 'Menu keybind'
})

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind', 'FlingTargetDropdown' })

ThemeManager:SetFolder('ApexHub')
SaveManager:SetFolder('ApexHub/universal')

SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])

local ThemeCreateGroup = Tabs['UI Settings']:AddRightGroupbox('Theme Creator')
ThemeCreateGroup:AddButton('Create Custom Theme File', function()
    ThemeManager:SaveTheme('ApexHub_CustomTheme')
    Library:Notify('Custom theme created!', 3)
end)

local DrawBoxes = {}
local BillboardCache = {}

local function RemoveESP(player)
    if DrawBoxes[player] then
        pcall(function()
            DrawBoxes[player].Box.Visible = false
            DrawBoxes[player].Box:Remove()
        end)
        DrawBoxes[player] = nil
    end

    if BillboardCache[player] then
        pcall(function() BillboardCache[player].Gui:Destroy() end)
        BillboardCache[player] = nil
    end
end

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
    TargetDropdown:SetValues(GetPlayerNames())
end)

Players.PlayerAdded:Connect(function()
    TargetDropdown:SetValues(GetPlayerNames())
end)

local function GetBoundingBox(char)
    local minVec = Vector3.new(math.huge, math.huge, math.huge)
    local maxVec = Vector3.new(-math.huge, -math.huge, -math.huge)
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            local pos = part.Position
            local size = part.Size / 2
            minVec = Vector3.new(math.min(minVec.X, pos.X - size.X), math.min(minVec.Y, pos.Y - size.Y), math.min(minVec.Z, pos.Z - size.Z))
            maxVec = Vector3.new(math.max(maxVec.X, pos.X + size.X), math.max(maxVec.Y, pos.Y + size.Y), math.max(maxVec.Z, pos.Z + size.Z))
        end
    end
    return minVec, maxVec
end

RunService.RenderStepped:Connect(function()
    local isBoxOn = Toggles.ESP_Box.Value
    local isNameOn = Toggles.ESP_Name.Value
    local isHealthOn = Toggles.ESP_Health.Value
    local isHighlightOn = Toggles.ESP_Highlight.Value
    local needsBillboard = isNameOn or isHealthOn

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            if char and hum and hum.Health > 0 and hrp then
                local highlight = char:FindFirstChild("HubHighlight")
                if isHighlightOn then
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "HubHighlight"
                        highlight.Parent = char
                    end
                    highlight.FillColor = Options.HighlightFillColor.Value
                    highlight.OutlineColor = Options.HighlightOutlineColor.Value
                else
                    if highlight then highlight:Destroy() end
                end

                if needsBillboard then
                    local cache = BillboardCache[player]
                    if not cache or not cache.Gui or not cache.Gui.Parent then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "ApexBillboardESP"
                        billboard.AlwaysOnTop = true
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 3.2, 0)
                        billboard.Adornee = hrp

                        pcall(function() billboard.Parent = CoreGui end)
                        if not billboard.Parent then billboard.Parent = char end

                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Name = "NameTag"
                        nameLabel.Size = UDim2.new(1, 0, 0, 20)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        nameLabel.TextStrokeTransparency = 0
                        nameLabel.TextSize = 14
                        nameLabel.Font = Enum.Font.SourceSansBold
                        nameLabel.Parent = billboard

                        local healthBg = Instance.new("Frame")
                        healthBg.Name = "HealthBg"
                        healthBg.Size = UDim2.new(0, 80, 0, 6)
                        healthBg.Position = UDim2.new(0.5, -40, 0, 22)
                        healthBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                        healthBg.BorderSizePixel = 0
                        healthBg.Parent = billboard

                        local healthBar = Instance.new("Frame")
                        healthBar.Name = "HealthBar"
                        healthBar.Size = UDim2.new(1, 0, 1, 0)
                        healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                        healthBar.BorderSizePixel = 0
                        healthBar.Parent = healthBg

                        cache = {
                            Gui = billboard,
                            Name = nameLabel,
                            HealthBg = healthBg,
                            HealthBar = healthBar
                        }
                        BillboardCache[player] = cache
                    end

                    cache.Name.Visible = isNameOn
                    cache.Name.Text = player.Name

                    cache.HealthBg.Visible = isHealthOn
                    if isHealthOn then
                        local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        cache.HealthBar.Size = UDim2.new(hp, 0, 1, 0)
                        cache.HealthBar.BackgroundColor3 = Color3.fromRGB(255 - (hp * 255), hp * 255, 0)
                    end
                else
                    if BillboardCache[player] then
                        pcall(function() BillboardCache[player].Gui:Destroy() end)
                        BillboardCache[player] = nil
                    end
                end

                if isBoxOn then
                    if not DrawBoxes[player] then
                        local box = Drawing.new("Square")
                        box.Color = Color3.fromRGB(255, 255, 255)
                        box.Thickness = 1
                        box.Filled = false
                        box.Transparency = 1
                        DrawBoxes[player] = { Box = box }
                    end

                    local minVec, maxVec = GetBoundingBox(char)
                    local corners = {
                        Vector3.new(minVec.X, minVec.Y, minVec.Z),
                        Vector3.new(minVec.X, maxVec.Y, minVec.Z),
                        Vector3.new(maxVec.X, maxVec.Y, minVec.Z),
                        Vector3.new(maxVec.X, minVec.Y, minVec.Z),
                        Vector3.new(minVec.X, minVec.Y, maxVec.Z),
                        Vector3.new(minVec.X, maxVec.Y, maxVec.Z),
                        Vector3.new(maxVec.X, maxVec.Y, maxVec.Z),
                        Vector3.new(maxVec.X, minVec.Y, maxVec.Z)
                    }

                    local xMin, yMin = math.huge, math.huge
                    local xMax, yMax = -math.huge, -math.huge
                    local onScreenAny = false

                    for _, corner in ipairs(corners) do
                        local screenPos, onScreen = Camera:WorldToViewportPoint(corner)
                        if onScreen then
                            onScreenAny = true
                        end
                        xMin = math.min(xMin, screenPos.X)
                        yMin = math.min(yMin, screenPos.Y)
                        xMax = math.max(xMax, screenPos.X)
                        yMax = math.max(yMax, screenPos.Y)
                    end

                    if onScreenAny then
                        DrawBoxes[player].Box.Position = Vector2.new(xMin, yMin)
                        DrawBoxes[player].Box.Size = Vector2.new(xMax - xMin, yMax - yMin)
                        DrawBoxes[player].Box.Visible = true
                    else
                        DrawBoxes[player].Box.Visible = false
                    end
                else
                    if DrawBoxes[player] then
                        pcall(function()
                            DrawBoxes[player].Box.Visible = false
                            DrawBoxes[player].Box:Remove()
                        end)
                        DrawBoxes[player] = nil
                    end
                end
            else
                RemoveESP(player)
            end
        else
            RemoveESP(player)
        end
    end
end)

RunService.Stepped:Connect(function()
    if Toggles.AntiFlingToggle.Value then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                for _, part in ipairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait()
        if Flinging then
            local targetName = Options.FlingTargetDropdown.Value
            local targetPlayer = Players:FindFirstChild(targetName)
            
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = LocalPlayer.Character
                local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local targetHrp = targetPlayer.Character.HumanoidRootPart
                local hum = myChar and myChar:FindFirstChildOfClass("Humanoid")

                if myHrp and targetHrp then
                    if hum then hum.PlatformStand = true end

                    local bv = myHrp:FindFirstChild("FlingVelocity")
                    if not bv then
                        bv = Instance.new("BodyVelocity")
                        bv.Name = "FlingVelocity"
                        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                        bv.Parent = myHrp
                    end

                    local bg = myHrp:FindFirstChild("FlingGyro")
                    if not bg then
                        bg = Instance.new("BodyGyro")
                        bg.Name = "FlingGyro"
                        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                        bg.P = 9e4
                        bg.Parent = myHrp
                    end

                    bv.Velocity = Vector3.new(100000, 100000, 100000)
                    myHrp.CFrame = targetHrp.CFrame * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360)))

                    for _, part in ipairs(myChar:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            else
                Library:Notify('Target player not found or dead.', 2)
                Toggles.FlingToggle:SetValue(false)
            end
        end
    end
end)

local BodyVelocity = nil
local BodyGyro = nil

local function ToggleFly(state)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    if state then
        if hum then hum.PlatformStand = true end

        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        BodyVelocity.Velocity = Vector3.zero
        BodyVelocity.Parent = hrp

        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        BodyGyro.P = 9e4
        BodyGyro.CFrame = hrp.CFrame
        BodyGyro.Parent = hrp
    else
        if hum then hum.PlatformStand = false end
        if BodyVelocity then BodyVelocity:Destroy() end
        if BodyGyro then BodyGyro:Destroy() end
    end
end

Toggles.FlyToggle:OnChanged(function()
    ToggleFly(Toggles.FlyToggle.Value)
end)

UserInputService.JumpRequest:Connect(function()
    if Toggles.InfiniteJumpToggle.Value then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if hum and hrp then
        local ws = Options.WalkSpeedSlider.Value
        if not Toggles.FlyToggle.Value then
            pcall(function()
                hum.WalkSpeed = ws
            end)
        end

        local jp = Options.JumpPowerSlider.Value
        if jp > 50 then
            pcall(function()
                hum.UseJumpPower = true
                hum.JumpPower = jp
            end)
        end

        local cf = Options.CFrameSpeedSlider.Value
        if cf > 1 and hum.MoveDirection.Magnitude > 0 and not Toggles.FlyToggle.Value then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (cf * 0.3))
        end

        if Toggles.NoClipToggle.Value then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end

        if Toggles.SpinToggle.Value and not Flinging then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Options.SpinSpeedSlider.Value or 20), 0)
        end

        if Toggles.FlyToggle.Value and BodyVelocity and BodyGyro then
            local camCF = Camera.CFrame
            local moveDir = Vector3.zero

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

            BodyVelocity.Velocity = moveDir * Options.FlySpeedSlider.Value
            BodyGyro.CFrame = camCF
        end

        if Toggles.ThirdPersonToggle.Value then
            Camera.CameraType = Enum.CameraType.Scriptable
            local dist = Options.ThirdPersonDist.Value
            local camPos = hrp.Position + Vector3.new(0, 2, 0) - (Camera.CFrame.LookVector * dist)
            Camera.CFrame = CFrame.new(camPos, hrp.Position + Vector3.new(0, 2, 0))
        else
            if Camera.CameraType == Enum.CameraType.Scriptable then
                Camera.CameraType = Enum.CameraType.Custom
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if Toggles.AimbotToggle.Value then
        local closestTarget = nil
        local shortestDist = Options.AimbotRange.Value
        local targetPartName = Options.AimPartDropdown.Value
        local mousePos = UserInputService:GetMouseLocation()

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local targetPart = char:FindFirstChild(targetPartName) or char:FindFirstChild("Head")
                        if targetPart then
                            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

                            if dist < shortestDist then
                                if Toggles.WallCheckToggle.Value then
                                    local origin = Camera.CFrame.Position
                                    local raycastParams = RaycastParams.new()
                                    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, char}
                                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

                                    if not Workspace:Raycast(origin, targetPart.Position - origin, raycastParams) then
                                        closestTarget = targetPart
                                        shortestDist = dist
                                    end
                                else
                                    closestTarget = targetPart
                                    shortestDist = dist
                                end
                            end
                        end
                    end
                end
            end
        end

        if closestTarget then
            local smooth = math.clamp(Options.AimbotSmoothness.Value, 1, 100)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, closestTarget.Position), smooth / 100)
        end
    end
end)

pcall(function()
    local cfgs = SaveManager:GetConfigList()
    if #cfgs > 0 then
        local targetConfig = "default"
        for _, name in ipairs(cfgs) do
            if name:lower() == "default" then
                targetConfig = name
                break
            end
        end
        if targetConfig == "default" and not table.find(cfgs, "default") then
            targetConfig = cfgs[1]
        end
        SaveManager:Load(targetConfig)
    else
        SaveManager:Save('default')
    end
end)

Library:Notify('Successfully loaded!', 3)
