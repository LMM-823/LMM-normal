--[[
    脚本名称: LMM normal script
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 创建 UI 主界面
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LMMNormalScriptGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 长方形主面板（半透明暗色风格）
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 310)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.25
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- 只有最上方的标题栏区域可以拖动整个UI
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundTransparency = 1
TopBar.Active = true
TopBar.Parent = MainFrame

local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- 标题文本（全英文）
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -70, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "LMM normal script"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- [ X ] 关闭按钮
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -32, 0, 2)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(180, 180, 180)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TopBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- [-] 最小化按钮（紧挨在X隔壁）
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -64, 0, 2)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.TextColor3 = Color3.fromRGB(180, 180, 180)
MinimizeButton.Text = "-"
MinimizeButton.TextSize, MinimizeButton.Font = 18, Enum.Font.GothamBold
MinimizeButton.Parent = TopBar

-- 标题栏下方的灰色水平分割线
local TopDivider = Instance.new("Frame")
TopDivider.Size = UDim2.new(1, 0, 0, 2)
TopDivider.Position = UDim2.new(0, 0, 0, 35)
TopDivider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TopDivider.BackgroundTransparency = 0.25
TopDivider.BorderSizePixel = 0
TopDivider.Parent = MainFrame

-- 区块划分线 1
local Divider1 = Instance.new("Frame")
Divider1.Size = UDim2.new(0, 2, 0, 255)
Divider1.Position = UDim2.new(0.33, 0, 0, 45)
Divider1.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Divider1.BackgroundTransparency = 0.25
Divider1.BorderSizePixel = 0
Divider1.Parent = MainFrame

-- 区块划分线 2
local Divider2 = Instance.new("Frame")
Divider2.Size = UDim2.new(0, 2, 0, 255)
Divider2.Position = UDim2.new(0.66, 0, 0, 45)
Divider2.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Divider2.BackgroundTransparency = 0.25
Divider2.BorderSizePixel = 0
Divider2.Parent = MainFrame

-- ==================== 辅助函数：创建开关按钮 ====================
local function createToggleSwitch(parent, posX, posY, width, height, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, width, 0, height)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize, label.Font = 11, Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 30, 0, 16)
    track.Position = UDim2.new(1, -36, 0.5, -8)
    track.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    track.BorderSizePixel = 0
    track.Parent = btn
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new(0, 2, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = track
    
    return btn, track, knob
end

-- ==================== 左侧：预留功能区（ESP 开关） ====================
local TracerBtn, TracerTrack, TracerKnob = createToggleSwitch(MainFrame, 12, 45, 130, 32, "Tracer ESP")
local BoxBtn, BoxTrack, BoxKnob = createToggleSwitch(MainFrame, 12, 85, 130, 32, "Box ESP")

-- ==================== 中间：走路速度、穿墙、无限跳、冰冻与最下方的飞行模式 ====================
local WalkBtn, WalkTrack, WalkKnob = createToggleSwitch(MainFrame, 163, 45, 130, 32, "WalkSpeed")
local NoclipBtn, NoclipTrack, NoclipKnob = createToggleSwitch(MainFrame, 163, 82, 130, 32, "Noclip")
local InfJumpBtn, InfJumpTrack, InfJumpKnob = createToggleSwitch(MainFrame, 163, 119, 130, 32, "Infinite Jump")
local FreezeBtn, FreezeTrack, FreezeKnob = createToggleSwitch(MainFrame, 163, 156, 130, 32, "Freeze")

-- 飞行模式放最下面
local FlyBtn, FlyTrackBarColor, FlyKnob = createToggleSwitch(MainFrame, 163, 193, 130, 32, "Fly Mode")

local UpButton = Instance.new("TextButton")
UpButton.Size = UDim2.new(0, 62, 0, 26)
UpButton.Position = UDim2.new(0.36, 0, 0, 230)
UpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
UpButton.BackgroundTransparency = 0.3
UpButton.TextColor3 = Color3.fromRGB(220, 220, 220)
UpButton.Text = "▲ Up"
UpButton.TextSize, UpButton.Font = 10, Enum.Font.GothamBold
UpButton.Parent = MainFrame

local DownButton = Instance.new("TextButton")
DownButton.Size = UDim2.new(0, 62, 0, 26)
DownButton.Position = UDim2.new(0.525, 0, 0, 230)
DownButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DownButton.BackgroundTransparency = 0.3
DownButton.TextColor3 = Color3.fromRGB(220, 220, 220)
DownButton.Text = "▼ Down"
DownButton.TextSize, DownButton.Font = 10, Enum.Font.GothamBold
DownButton.Parent = MainFrame

-- ==================== 右侧：走路速度滑块 + 飞行速度滑块 + 颜色盘 ====================
local WalkSpeedLabel = Instance.new("TextLabel")
WalkSpeedLabel.Size = UDim2.new(0, 135, 0, 20)
WalkSpeedLabel.Position = UDim2.new(0.69, 0, 0, 45)
WalkSpeedLabel.BackgroundTransparency = 1
WalkSpeedLabel.Text = "Walk Speed: 16"
WalkSpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
WalkSpeedLabel.TextSize, WalkSpeedLabel.Font = 11, Enum.Font.GothamBold
WalkSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
WalkSpeedLabel.Parent = MainFrame

local WalkTrackBar = Instance.new("Frame")
WalkTrackBar.Size = UDim2.new(0, 135, 0, 5)
WalkTrackBar.Position = UDim2.new(0.69, 0, 0, 70)
WalkTrackBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
WalkTrackBar.BorderSizePixel = 0
WalkTrackBar.Parent = MainFrame

local WalkThumb = Instance.new("TextButton")
WalkThumb.Size = UDim2.new(0, 14, 0, 14)
local currentWalkSpeed = 16
local minWalkSpeed, maxWalkSpeed = 16, 200
WalkThumb.Position = UDim2.new((currentWalkSpeed - minWalkSpeed) / (maxWalkSpeed - minWalkSpeed), -7, 0.5, -7)
WalkThumb.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
WalkThumb.Text = ""
WalkThumb.BorderSizePixel = 0
WalkThumb.Parent = WalkTrackBar

local FlySpeedLabel = Instance.new("TextLabel")
FlySpeedLabel.Size = UDim2.new(0, 135, 0, 20)
FlySpeedLabel.Position = UDim2.new(0.69, 0, 0, 85)
FlySpeedLabel.BackgroundTransparency = 1
FlySpeedLabel.Text = "Fly Speed: 50"
FlySpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
FlySpeedLabel.TextSize, FlySpeedLabel.Font = 11, Enum.Font.GothamBold
FlySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
FlySpeedLabel.Parent = MainFrame

local FlyTrackBar = Instance.new("Frame")
FlyTrackBar.Size = UDim2.new(0, 135, 0, 5)
FlyTrackBar.Position = UDim2.new(0.69, 0, 0, 110)
FlyTrackBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyTrackBar.BorderSizePixel = 0
FlyTrackBar.Parent = MainFrame

local FlyThumb = Instance.new("TextButton")
FlyThumb.Size = UDim2.new(0, 14, 0, 14)
local currentFlySpeed = 50
local minFlySpeed, maxFlySpeed = 10, 200
FlyThumb.Position = UDim2.new((currentFlySpeed - minFlySpeed) / (maxFlySpeed - minFlySpeed), -7, 0.5, -7)
FlyThumb.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
FlyThumb.Text = ""
FlyThumb.BorderSizePixel = 0
FlyThumb.Parent = FlyTrackBar

-- 射线颜色标签
local TracerColorLabel = Instance.new("TextLabel")
TracerColorLabel.Size = UDim2.new(0, 135, 0, 15)
TracerColorLabel.Position = UDim2.new(0.69, 0, 0, 125)
TracerColorLabel.BackgroundTransparency = 1
TracerColorLabel.Text = "Tracer Color"
TracerColorLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
TracerColorLabel.TextSize, TracerColorLabel.Font = 10, Enum.Font.GothamBold
TracerColorLabel.TextXAlignment = Enum.TextXAlignment.Left
TracerColorLabel.Parent = MainFrame

-- 射线颜色正方形色块
local TracerColorWhite = Instance.new("TextButton")
TracerColorWhite.Size = UDim2.new(0, 16, 0, 16)
TracerColorWhite.Position = UDim2.new(0.69, 0, 0, 142)
TracerColorWhite.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TracerColorWhite.Text = ""
TracerColorWhite.Parent = MainFrame

local TracerColorBlack = Instance.new("TextButton")
TracerColorBlack.Size = UDim2.new(0, 16, 0, 16)
TracerColorBlack.Position = UDim2.new(0.69, 20, 0, 142)
TracerColorBlack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TracerColorBlack.Text = ""
TracerColorBlack.Parent = MainFrame

local TracerColorRed = Instance.new("TextButton")
TracerColorRed.Size = UDim2.new(0, 16, 0, 16)
TracerColorRed.Position = UDim2.new(0.69, 40, 0, 142)
TracerColorRed.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
TracerColorRed.Text = ""
TracerColorRed.Parent = MainFrame

-- 方框颜色标签
local BoxColorLabel = Instance.new("TextLabel")
BoxColorLabel.Size = UDim2.new(0, 135, 0, 15)
BoxColorLabel.Position = UDim2.new(0.69, 0, 0, 165)
BoxColorLabel.BackgroundTransparency = 1
BoxColorLabel.Text = "Box Color"
BoxColorLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
BoxColorLabel.TextSize, BoxColorLabel.Font = 10, Enum.Font.GothamBold
BoxColorLabel.TextXAlignment = Enum.TextXAlignment.Left
BoxColorLabel.Parent = MainFrame

-- 方框颜色正方形色块
local BoxColorWhite = Instance.new("TextButton")
BoxColorWhite.Size = UDim2.new(0, 16, 0, 16)
BoxColorWhite.Position = UDim2.new(0.69, 0, 0, 182)
BoxColorWhite.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BoxColorWhite.Text = ""
BoxColorWhite.Parent = MainFrame

local BoxColorBlack = Instance.new("TextButton")
BoxColorBlack.Size = UDim2.new(0, 16, 0, 16)
BoxColorBlack.Position = UDim2.new(0.69, 20, 0, 182)
BoxColorBlack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BoxColorBlack.Text = ""
BoxColorBlack.Parent = MainFrame

local BoxColorRed = Instance.new("TextButton")
BoxColorRed.Size = UDim2.new(0, 16, 0, 16)
BoxColorRed.Position = UDim2.new(0.69, 40, 0, 182)
BoxColorRed.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
BoxColorRed.Text = ""
BoxColorRed.Parent = MainFrame

-- 最小化逻辑
local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 460, 0, 35)
        MinimizeButton.Text = "+"
        Divider1.Visible = false
        Divider2.Visible = false
        TopDivider.Visible = false
        TracerBtn.Visible = false
        BoxBtn.Visible = false
        WalkBtn.Visible = false
        NoclipBtn.Visible = false
        InfJumpBtn.Visible = false
        FreezeBtn.Visible = false
        FlyBtn.Visible = false
        UpButton.Visible = false
        DownButton.Visible = false
        WalkSpeedLabel.Visible = false
        WalkTrackBar.Visible = false
        FlySpeedLabel.Visible = false
        FlyTrackBar.Visible = false
        TracerColorLabel.Visible = false
        TracerColorWhite.Visible = false
        TracerColorBlack.Visible = false
        TracerColorRed.Visible = false
        BoxColorLabel.Visible = false
        BoxColorWhite.Visible = false
        BoxColorBlack.Visible = false
        BoxColorRed.Visible = false
    else
        MainFrame.Size = UDim2.new(0, 460, 0, 310)
        MinimizeButton.Text = "-"
        Divider1.Visible = true
        Divider2.Visible = true
        TopDivider.Visible = true
        TracerBtn.Visible = true
        BoxBtn.Visible = true
        WalkBtn.Visible = true
        NoclipBtn.Visible = true
        InfJumpBtn.Visible = true
        FreezeBtn.Visible = true
        FlyBtn.Visible = true
        UpButton.Visible = true
        DownButton.Visible = true
        WalkSpeedLabel.Visible = true
        WalkTrackBar.Visible = true
        FlySpeedLabel.Visible = true
        FlyTrackBar.Visible = true
        TracerColorLabel.Visible = true
        TracerColorWhite.Visible = true
        TracerColorBlack.Visible = true
        TracerColorRed.Visible = true
        BoxColorLabel.Visible = true
        BoxColorWhite.Visible = true
        BoxColorBlack.Visible = true
        BoxColorRed.Visible = true
    end
end)

-- ==================== 功能实现逻辑 ====================

-- 1. 走路速度逻辑
local walkActive = false
WalkBtn.MouseButton1Click:Connect(function()
    walkActive = not walkActive
    if walkActive then
        WalkTrack.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        WalkKnob.Position = UDim2.new(1, -14, 0.5, -6)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = currentWalkSpeed
        end
    else
        WalkTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        WalkKnob.Position = UDim2.new(0, 2, 0.5, -6)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- 2. 穿墙逻辑
local noclipActive = false
NoclipBtn.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    if noclipActive then
        NoclipTrack.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        NoclipKnob.Position = UDim2.new(1, -14, 0.5, -6)
    else
        NoclipTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        NoclipKnob.Position = UDim2.new(0, 2, 0.5, -6)
    end
end)

RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 3. 无限跳逻辑
local infJumpActive = false
InfJumpBtn.MouseButton1Click:Connect(function()
    infJumpActive = not infJumpActive
    if infJumpActive then
        InfJumpTrack.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        InfJumpKnob.Position = UDim2.new(1, -14, 0.5, -6)
    else
        InfJumpTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        InfJumpKnob.Position = UDim2.new(0, 2, 0.5, -6)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 4. 冰冻逻辑 (完美彻底修复：锁死坐标和CFrame，绝无任何掉落或下坠动画)
local freezeActive = false
local freezeConnection = nil
local frozenCFrame = nil

FreezeBtn.MouseButton1Click:Connect(function()
    freezeActive = not freezeActive
    if freezeActive then
        FreezeTrack.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        FreezeKnob.Position = UDim2.new(1, -14, 0.5, -6)
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = LocalPlayer.Character.HumanoidRootPart
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            
            frozenCFrame = rootPart.CFrame
            rootPart.Anchored = true
            if humanoid then
                humanoid.PlatformStand = true
            end
            
            -- 每一帧强行把位置定格在开启瞬间的 CFrame 上，彻底消除任何掉落倾向
            freezeConnection = RunService.RenderStepped:Connect(function()
                if freezeActive and rootPart and rootPart.Parent and frozenCFrame then
                    rootPart.CFrame = frozenCFrame
                    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end)
        end
    else
        FreezeTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        FreezeKnob.Position = UDim2.new(0, 2, 0.5, -6)
        
        if freezeConnection then
            freezeConnection:Disconnect()
            freezeConnection = nil
        end
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = LocalPlayer.Character.HumanoidRootPart
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            
            rootPart.Anchored = false
            if humanoid then
                humanoid.PlatformStand = false
            end
            frozenCFrame = nil
        end
    end
end)

-- 5. 滑块拖动逻辑
local draggingFly, draggingWalk = false, false
FlyThumb.MouseButton1Down:Connect(function() draggingFly = true end)
WalkThumb.MouseButton1Down:Connect(function() draggingWalk = true end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFly = false
        draggingWalk = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local pos = input.Position.X
        
        if draggingFly then
            local tPos = FlyTrackBar.AbsolutePosition.X
            local tSize = FlyTrackBar.AbsoluteSize.X
            local scale = math.clamp((pos - tPos) / tSize, 0, 1)
            FlyThumb.Position = UDim2.new(scale, -7, 0.5, -7)
            currentFlySpeed = math.floor(minFlySpeed + (maxFlySpeed - minFlySpeed) * scale)
            FlySpeedLabel.Text = "Fly Speed: " .. currentFlySpeed
        end
        
        if draggingWalk then
            local tPos = WalkTrackBar.AbsolutePosition.X
            local tSize = WalkTrackBar.AbsoluteSize.X
            local scale = math.clamp((pos - tPos) / tSize, 0, 1)
            WalkThumb.Position = UDim2.new(scale, -7, 0.5, -7)
            currentWalkSpeed = math.floor(minWalkSpeed + (maxWalkSpeed - minWalkSpeed) * scale)
            WalkSpeedLabel.Text = "Walk Speed: " .. currentWalkSpeed
            
            if walkActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = currentWalkSpeed
            end
        end
    end
end)

-- 6. 飞行逻辑
local active = false
local bv, bodyGyroFly = nil, nil
local connection = nil
local isUpPressed, isDownPressed = false

UpButton.MouseButton1Down:Connect(function() isUpPressed = true end)
UpButton.MouseButton1Up:Connect(function() isUpPressed = false end)
DownButton.MouseButton1Down:Connect(function() isDownPressed = true end)
DownButton.MouseButton1Up:Connect(function() isDownPressed = false end)

local function toggleFlight()
    active = not active
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Humanoid") then return end
    local rootPart = char.HumanoidRootPart
    local humanoid = char.Humanoid
    
    if active then
        FlyTrackBarColor.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        FlyKnob.Position = UDim2.new(1, -14, 0.5, -6)
        humanoid.PlatformStand = true
        
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = rootPart
        
        bodyGyroFly = Instance.new("BodyGyro")
        bodyGyroFly.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyroFly.CFrame = rootPart.CFrame
        bodyGyroFly.Parent = rootPart
        
        connection = RunService.RenderStepped:Connect(function()
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local camera = workspace.CurrentCamera
            local moveDir = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) or isUpPressed then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or isDownPressed then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            bv.Velocity = moveDir * currentFlySpeed
            bodyGyroFly.CFrame = camera.CFrame
        end)
    else
        FlyTrackBarColor.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        FlyKnob.Position = UDim2.new(0, 2, 0.5, -6)
        if humanoid then humanoid.PlatformStand = false end
        if connection then connection:Disconnect() connection = nil end
        if bv then bv:Destroy() bv = nil end
        if bodyGyroFly then bodyGyroFly:Destroy() bodyGyroFly = nil end
        isUpPressed, isDownPressed = false, false
    end
end

FlyBtn.MouseButton1Click:Connect(toggleFlight)

-- 7. ESP 颜色与逻辑
local tracerActive = false
local boxActive = false
local tracerColor = Color3.fromRGB(255, 255, 255)
local boxColor = Color3.fromRGB(255, 255, 255)

TracerBtn.MouseButton1Click:Connect(function()
    tracerActive = not tracerActive
    if tracerActive then
        TracerTrack.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        TracerKnob.Position = UDim2.new(1, -14, 0.5, -6)
    else
        TracerTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        TracerKnob.Position = UDim2.new(0, 2, 0.5, -6)
    end
end)

TracerColorWhite.MouseButton1Click:Connect(function() tracerColor = Color3.fromRGB(255, 255, 255) end)
TracerColorBlack.MouseButton1Click:Connect(function() tracerColor = Color3.fromRGB(0, 0, 0) end)
TracerColorRed.MouseButton1Click:Connect(function() tracerColor = Color3.fromRGB(255, 50, 50) end)

BoxBtn.MouseButton1Click:Connect(function()
    boxActive = not boxActive
    if boxActive then
        BoxTrack.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        BoxKnob.Position = UDim2.new(1, -14, 0.5, -6)
    else
        BoxTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        BoxKnob.Position = UDim2.new(0, 2, 0.5, -6)
    end
end)

BoxColorWhite.MouseButton1Click:Connect(function() boxColor = Color3.fromRGB(255, 255, 255) end)
BoxColorBlack.MouseButton1Click:Connect(function() boxColor = Color3.fromRGB(0, 0, 0) end)
BoxColorRed.MouseButton1Click:Connect(function() boxColor = Color3.fromRGB(255, 50, 50) end)

local espDrawings = {}

RunService.RenderStepped:Connect(function()
    for plr, drawings in pairs(espDrawings) do
        if not plr or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") or plr == LocalPlayer then
            if drawings.tracer then drawings.tracer:Remove() end
            if drawings.box then drawings.box:Remove() end
            espDrawings[plr] = nil
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character.Humanoid.Health > 0 then
            if not espDrawings[plr] then
                espDrawings[plr] = {}
            end
            
            local rootPart = plr.Character.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if tracerActive and onScreen then
                if not espDrawings[plr].tracer then
                    local line = Drawing.new("Line")
                    line.Thickness = 1.5
                    line.Visible = false
                    espDrawings[plr].tracer = line
                end
                local tracer = espDrawings[plr].tracer
                tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                tracer.To = Vector2.new(vector.X, vector.Y)
                tracer.Color = tracerColor
                tracer.Visible = true
            else
                if espDrawings[plr].tracer then
                    espDrawings[plr].tracer.Visible = false
                end
            end
            
            if boxActive and onScreen then
                if not espDrawings[plr].box then
                    local box = Drawing.new("Square")
                    box.Thickness = 1.5
                    box.Filled = false
                    box.Visible = false
                    espDrawings[plr].box = box
                end
                local box = espDrawings[plr].box
                local head = plr.Character:FindFirstChild("Head")
                if head then
                    local headVector = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local legVector = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                    local height = math.abs(headVector.Y - legVector.Y)
                    local width = height / 2
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(vector.X - width / 2, headVector.Y)
                    box.Color = boxColor
                    box.Visible = true
                else
                    box.Visible = false
                end
            else
                if espDrawings[plr].box then
                    espDrawings[plr].box.Visible = false
                end
            end
        end
    end
end)
