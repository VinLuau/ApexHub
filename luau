-- [[ Linoria Library Universal Script Hub (Definitive Mouse Fix Version) ]]
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- 윈도우 생성
local Window = Library:CreateWindow({
    Title = 'Apex Hub | Linoria',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- 탭 생성
local Tabs = {
    Main = Window:AddTab('Main'),
    Aimbot = Window:AddTab('Aimbot'),
    ESP = Window:AddTab('ESP'),
    ['UI setting'] = Window:AddTab('UI close'),
}

-- [1. 메인 탭 그룹박스]
local LeftMain = Tabs.Main:AddLeftGroupbox('Move and upgrade body')
local RightMain = Tabs.Main:AddRightGroupbox('Teleport')

LeftMain:AddSlider('WalkSpeedSlider', {
    Text = 'Walkspeed',
    Default = 16,
    Min = 16,
    Max = 1000,
    Rounding = 0,
    Compact = false,
})

LeftMain:AddSlider('CFrameSpeedSlider', {
    Text = 'Speed bypass',
    Default = 1,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Compact = false,
})

LeftMain:AddSlider('JumpPowerSlider', {
    Text = 'Jump power',
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Compact = false,
})

LeftMain:AddToggle('InfiniteJumpToggle', {
    Text = 'Infinite Jump',
    Default = false,
})

LeftMain:AddToggle('NoClipToggle', {
    Text = 'Noclip',
    Default = false,
})

LeftMain:AddToggle('SpinToggle', {
    Text = 'Spin',
    Default = false,
})
LeftMain:AddSlider('SpinSpeedSlider', {
    Text = 'Spin speed',
    Default = 20,
    Min = 20,
    Max = 150,
    Rounding = 0,
    Compact = false,
})

LeftMain:AddToggle('FlyToggle', {
    Text = 'Fly',
    Default = false,
})
LeftMain:AddSlider('FlySpeedSlider', {
    Text = 'Fly speed',
    Default = 50,
    Min = 50,
    Max = 300,
    Rounding = 0,
    Compact = false,
})

RightMain:AddInput('TPInput', {
    Default = '0, 0',
    Numeric = false,
    Finished = false,
    Text = 'Teleport coordinates (X, Y)',
    Tooltip = 'Please separate by commas (,) when entering (ex., 100, 200)',
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

-- [2. 에임봇 탭 그룹박스]
local LeftAim = Tabs.Aimbot:AddLeftGroupbox('Aimbot setting')
local RightAim = Tabs.Aimbot:AddRightGroupbox('Target or filter')

LeftAim:AddToggle('AimbotToggle', {
    Text = 'On aimbot',
    Default = false,
})

LeftAim:AddSlider('AimbotSmoothness', {
    Text = 'Aim smooth',
    Default = 20,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Compact = false,
})

LeftAim:AddSlider('AimbotRange', {
    Text = 'Targeting distance',
    Default = 100,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Compact = false,
})

LeftAim:AddToggle('WallCheckToggle', {
    Text = 'Wall check',
    Default = true,
})

RightAim:AddDropdown('AimPartDropdown', {
    Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftHand", "RightHand", "LeftFoot", "RightFoot"},
    Default = 1,
    Text = 'Targeting Part',
})

-- [3. ESP 탭 그룹박스]
local LeftEsp = Tabs.ESP:AddLeftGroupbox('ESP')

LeftEsp:AddToggle('ESP_Highlight', { Text = 'Highlight', Default = false })
LeftEsp:AddToggle('ESP_Name', { Text = 'Name Tag', Default = false })
LeftEsp:AddToggle('ESP_Health', { Text = 'Health Bar', Default = false })
LeftEsp:AddToggle('ESP_Box', { Text = 'Box', Default = false })

-- [4. UI 설정 탭]
local MenuGroup = Tabs['UI setting']:AddLeftGroupbox('Menu control')
MenuGroup:AddButton('Close menu panel', function()
    Library:Toggle()
end)

Library:SetWatermark('Universal Hub | v1.4')
Library.ToggleKeybind = Enum.KeyCode.RightShift

-- [마우스 강제 표시 핸들러]
-- Linoria UI 메인 프레임의 가시성 상태를 감지하여 마우스 커서를 강제로 해제합니다.
RunService.RenderStepped:Connect(function()
    pcall(function()
        if Window and Window.Holder then
            -- 창이 켜져 있으면 마우스를 자유롭게 풀고 커서가 보이도록 설정
            if Window.Holder.Visible then
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                UserInputService.MouseIconEnabled = true
            end
        end
    end)
end)

-- =========================================================================
-- 기능 로직 제어부
-- =========================================================================

local FlyConnection
local function ToggleFly(state)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    if state then
        if hum then hum.PlatformStand = true end
        FlyConnection = RunService.RenderStepped:Connect(function()
            if not Toggles.FlyToggle.Value then return end
            local camCF = Camera.CFrame
            local moveDir = Vector3.new()
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
            
            local speed = Options.FlySpeedSlider.Value
            hrp.AssemblyLinearVelocity = moveDir * speed
        end)
    else
        if hum then hum.PlatformStand = false end
        if FlyConnection then FlyConnection:Disconnect() end
        hrp.AssemblyLinearVelocity = Vector3.zero
    end
end

Toggles.FlyToggle:OnChanged(function()
    ToggleFly(Toggles.FlyToggle.Value)
end)

UserInputService.JumpRequest:Connect(function()
    if Toggles.InfiniteJumpToggle.Value then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if hum and hrp then
        if Options.WalkSpeedSlider and Options.WalkSpeedSlider.Value > 16 and not Toggles.FlyToggle.Value then
            hum.WalkSpeed = Options.WalkSpeedSlider.Value
        end

        if Options.JumpPowerSlider and Options.JumpPowerSlider.Value > 50 then
            hum.UseJumpPower = true
            hum.JumpPower = Options.JumpPowerSlider.Value
        end

        if Options.CFrameSpeedSlider and Options.CFrameSpeedSlider.Value > 1 and hum.MoveDirection.Magnitude > 0 and not Toggles.FlyToggle.Value then
            local mult = Options.CFrameSpeedSlider.Value
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (mult * 0.3))
        end

        if Toggles.NoClipToggle.Value then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end

        if Toggles.SpinToggle.Value then
            local spinSpeed = Options.SpinSpeedSlider.Value or 20
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not Toggles.AimbotToggle.Value then return end
    
    local closestTarget = nil
    local shortestDist = Options.AimbotRange.Value
    local targetPartName = Options.AimPartDropdown.Value
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local targetPart = player.Character:FindFirstChild(targetPartName) or player.Character:FindFirstChild("Head")
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                local mousePos = UserInputService:GetMouseLocation()
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                
                if dist < shortestDist then
                    if Toggles.WallCheckToggle.Value then
                        local origin = Camera.CFrame.Position
                        local direction = (targetPart.Position - origin)
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
                        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                        
                        local result = Workspace:Raycast(origin, direction, raycastParams)
                        if not result then
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
    
    if closestTarget then
        local smooth = math.clamp(Options.AimbotSmoothness.Value, 1, 100)
        local targetCF = CFrame.lookAt(Camera.CFrame.Position, closestTarget.Position)
        Camera.CFrame = Camera.CFrame:Lerp(targetCF, smooth / 100)
    end
end)

RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            
            if root and head then
                local highlight = char:FindFirstChild("HubHighlight")
                if Toggles.ESP_Highlight.Value then
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "HubHighlight"
                        highlight.FillColor = Color3.fromRGB(255, 50, 50)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.Parent = char
                    end
                else
                    if highlight then highlight:Destroy() end
                end

                local billboard = head:FindFirstChild("HubESPBillboard")
                local needsESP = Toggles.ESP_Name.Value or Toggles.ESP_Health.Value or Toggles.ESP_Box.Value

                if needsESP then
                    if not billboard then
                        billboard = Instance.new("BillboardGui")
                        billboard.Name = "HubESPBillboard"
                        billboard.Size = UDim2.new(0, 120, 0, 60)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Adornee = head
                        billboard.Parent = head

                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Name = "NameLabel"
                        nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        nameLabel.TextStrokeTransparency = 0
                        nameLabel.TextSize = 13
                        nameLabel.Font = Enum.Font.SourceSansBold
                        nameLabel.Parent = billboard

                        local healthBg = Instance.new("Frame")
                        healthBg.Name = "HealthBg"
                        healthBg.Size = UDim2.new(0.8, 0, 0.15, 0)
                        healthBg.Position = UDim2.new(0.1, 0, 0.45, 0)
                        healthBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        healthBg.BorderSizePixel = 0
                        healthBg.Parent = billboard

                        local healthBar = Instance.new("Frame")
                        healthBar.Name = "HealthBar"
                        healthBar.Size = UDim2.new(1, 0, 1, 0)
                        healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                        healthBar.BorderSizePixel = 0
                        healthBar.Parent = healthBg

                        local boxFrame = Instance.new("Frame")
                        boxFrame.Name = "BoxFrame"
                        boxFrame.Size = UDim2.new(0.8, 0, 1.8, 0)
                        boxFrame.Position = UDim2.new(0.1, 0, -0.4, 0)
                        boxFrame.BackgroundTransparency = 1
                        boxFrame.BorderSizePixel = 1
                        boxFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
                        boxFrame.Parent = billboard
                    end

                    local nameLabel = billboard:FindFirstChild("NameLabel")
                    local healthBg = billboard:FindFirstChild("HealthBg")
                    local healthBar = healthBg and healthBg:FindFirstChild("HealthBar")
                    local boxFrame = billboard:FindFirstChild("BoxFrame")

                    if nameLabel then
                        nameLabel.Visible = Toggles.ESP_Name.Value
                        nameLabel.Text = player.Name
                    end

                    if healthBg and healthBar then
                        healthBg.Visible = Toggles.ESP_Health.Value
                        if humanoid then
                            local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                            healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
                        end
                    end

                    if boxFrame then
                        boxFrame.Visible = Toggles.ESP_Box.Value
                    end
                else
                    if billboard then billboard:Destroy() end
                end
            end
        end
    end
end)

Library:Notify('Successfully loaded.', 3)
