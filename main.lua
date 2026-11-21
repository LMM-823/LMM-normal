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

-- 整个内容区容器（Main 页 和 Fun 页都在这里整页切换）
local MainPageContainer = Instance.new("Frame")
MainPageContainer.Name = "MainPageContainer"
MainPageContainer.Size = UDim2.new(1, 0, 1, -37)
MainPageContainer.Position = UDim2.new(0, 0, 0, 37)
MainPageContainer.BackgroundTransparency = 1
MainPageContainer.BorderSizePixel = 0
MainPageContainer.Parent = MainFrame

local FunPageContainer = Instance.new("Frame")
FunPageContainer.Name = "FunPageContainer"
FunPageContainer.Size = UDim2.new(1, 0, 1, -37)
FunPageContainer.Position = UDim2.new(0, 0, 0, 37)
FunPageContainer.BackgroundTransparency = 1
FunPageContainer.BorderSizePixel = 0
FunPageContainer.Visible = false
FunPageContainer.Parent = MainFrame

-- 区块划分线 1
local Divider1 = Instance.new("Frame")
Divider1.Size = UDim2.new(0, 2, 0, 255)
Divider1.Position = UDim2.new(0.33, 0, 0, 8)
Divider1.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Divider1.BackgroundTransparency = 0.25
Divider1.BorderSizePixel = 0
Divider1.Parent = MainPageContainer

-- 区块划分线 2
local Divider2 = Instance.new("Frame")
Divider2.Size = UDim2.new(0, 2, 0, 255)
Divider2.Position = UDim2.new(0.66, 0, 0, 8)
Divider2.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Divider2.BackgroundTransparency = 0.25
Divider2.BorderSizePixel = 0
Divider2.Parent = MainPageContainer

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

local function setToggleVisual(track, knob, state)
    if state then
        track.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        knob.Position = UDim2.new(1, -14, 0.5, -6)
    else
        track.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        knob.Position = UDim2.new(0, 2, 0.5, -6)
    end
end

-- ==================== 左侧：两个主按钮（Main / Fun，样式固定不变） + ESP 开关 ====================
local MainTabBtn = Instance.new("TextButton")
MainTabBtn.Size = UDim2.new(0, 62, 0, 24)
MainTabBtn.Position = UDim2.new(0, 12, 0, 5)
MainTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainTabBtn.BackgroundTransparency = 0.25
MainTabBtn.BorderSizePixel = 0
MainTabBtn.Text = "Main"
MainTabBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
MainTabBtn.TextSize = 11
MainTabBtn.Font = Enum.Font.GothamBold
MainTabBtn.Parent = MainPageContainer

local FunTabBtn = Instance.new("TextButton")
FunTabBtn.Size = UDim2.new(0, 62, 0, 24)
FunTabBtn.Position = UDim2.new(0, 80, 0, 5)
FunTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
FunTabBtn.BackgroundTransparency = 0.25
FunTabBtn.BorderSizePixel = 0
FunTabBtn.Text = "Fun"
FunTabBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
FunTabBtn.TextSize = 11
FunTabBtn.Font = Enum.Font.GothamBold
FunTabBtn.Parent = MainPageContainer

local TracerBtn, TracerTrack, TracerKnob = createToggleSwitch(MainPageContainer, 12, 35, 130, 24, "Tracer ESP")
local BoxBtn, BoxTrack, BoxKnob = createToggleSwitch(MainPageContainer, 12, 62, 130, 24, "Box ESP")
local NameBtn, NameTrack, NameKnob = createToggleSwitch(MainPageContainer, 12, 89, 130, 24, "Name ESP")
local AtNameBtn, AtNameTrack, AtNameKnob = createToggleSwitch(MainPageContainer, 12, 116, 130, 24, "@Name ESP")
local DistBtn, DistTrack, DistKnob = createToggleSwitch(MainPageContainer, 12, 143, 130, 24, "Distance ESP")

local MobileNoticeLabel = Instance.new("TextLabel")
MobileNoticeLabel.Size = UDim2.new(0, 130, 0, 24)
MobileNoticeLabel.Position = UDim2.new(0, 12, 0, 171)
MobileNoticeLabel.BackgroundTransparency = 1
MobileNoticeLabel.Text = "PC Use Shift & Space"
MobileNoticeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
MobileNoticeLabel.TextSize = 10
MobileNoticeLabel.Font = Enum.Font.GothamBold
MobileNoticeLabel.TextWrapped = true
MobileNoticeLabel.TextXAlignment = Enum.TextXAlignment.Center
MobileNoticeLabel.Parent = MainPageContainer

-- Fun 整页内容（切到 Fun 时整个内容区变成 Fun 页）
local FunBackMainBtn = Instance.new("TextButton")
FunBackMainBtn.Size = UDim2.new(0, 74, 0, 24)
FunBackMainBtn.Position = UDim2.new(0, 12, 0, 8)
FunBackMainBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
FunBackMainBtn.BackgroundTransparency = 0.25
FunBackMainBtn.BorderSizePixel = 0
FunBackMainBtn.Text = "Back Main"
FunBackMainBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
FunBackMainBtn.TextSize = 11
FunBackMainBtn.Font = Enum.Font.GothamBold
FunBackMainBtn.Parent = FunPageContainer

local FunPageTitle = Instance.new("TextLabel")
FunPageTitle.Size = UDim2.new(1, -100, 0, 24)
FunPageTitle.Position = UDim2.new(0, 94, 0, 8)
FunPageTitle.BackgroundTransparency = 1
FunPageTitle.Text = "Fun Page"
FunPageTitle.TextColor3 = Color3.fromRGB(235, 235, 235)
FunPageTitle.TextSize = 13
FunPageTitle.Font = Enum.Font.GothamBold
FunPageTitle.TextXAlignment = Enum.TextXAlignment.Left
FunPageTitle.Parent = FunPageContainer

-- Fun 第一个按钮：Spin + 数值滑动
local SpinBtn, SpinTrack, SpinKnob = createToggleSwitch(FunPageContainer, 12, 44, 140, 32, "Spin")

local SpinSpeedLabel = Instance.new("TextLabel")
SpinSpeedLabel.Size = UDim2.new(0, 160, 0, 20)
SpinSpeedLabel.Position = UDim2.new(0, 166, 0, 42)
SpinSpeedLabel.BackgroundTransparency = 1
SpinSpeedLabel.Text = "Spin Speed: 10"
SpinSpeedLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
SpinSpeedLabel.TextSize = 11
SpinSpeedLabel.Font = Enum.Font.GothamBold
SpinSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpinSpeedLabel.Parent = FunPageContainer

local SpinTrackBar = Instance.new("Frame")
SpinTrackBar.Size = UDim2.new(0, 160, 0, 5)
SpinTrackBar.Position = UDim2.new(0, 166, 0, 67)
SpinTrackBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpinTrackBar.BorderSizePixel = 0
SpinTrackBar.Parent = FunPageContainer

local SpinThumb = Instance.new("TextButton")
SpinThumb.Size = UDim2.new(0, 14, 0, 14)
local currentSpinSpeed = 10
local minSpinSpeed, maxSpinSpeed = 1, 50
SpinThumb.Position = UDim2.new((currentSpinSpeed - minSpinSpeed) / (maxSpinSpeed - minSpinSpeed), -7, 0.5, -7)
SpinThumb.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
SpinThumb.Text = ""
SpinThumb.BorderSizePixel = 0
SpinThumb.Parent = SpinTrackBar

local currentPage = "Main"
local isMinimized = false

local function applyPageState()
    if isMinimized then
        MainPageContainer.Visible = false
        FunPageContainer.Visible = false
    else
        MainPageContainer.Visible = (currentPage == "Main")
        FunPageContainer.Visible = (currentPage == "Fun")
    end
end

MainTabBtn.MouseButton1Click:Connect(function()
    currentPage = "Main"
    applyPageState()
end)

FunTabBtn.MouseButton1Click:Connect(function()
    currentPage = "Fun"
    applyPageState()
end)

FunBackMainBtn.MouseButton1Click:Connect(function()
    currentPage = "Main"
    applyPageState()
end)

-- ==================== 中间：走路速度、穿墙、无限跳、冰冻与最下方的飞行模式 ====================
local WalkBtn, WalkTrack, WalkKnob = createToggleSwitch(MainPageContainer, 163, 8, 130, 32, "WalkSpeed")
local NoclipBtn, NoclipTrack, NoclipKnob = createToggleSwitch(MainPageContainer, 163, 45, 130, 32, "Noclip")
local InfJumpBtn, InfJumpTrack, InfJumpKnob = createToggleSwitch(MainPageContainer, 163, 82, 130, 32, "Infinite Jump")
local FreezeBtn, FreezeTrack, FreezeKnob = createToggleSwitch(MainPageContainer, 163, 119, 130, 32, "Freeze")

-- 飞行模式放最下面
local FlyBtn, FlyTrackBarColor, FlyKnob = createToggleSwitch(MainPageContainer, 163, 156, 130, 32, "Fly Mode")

local UpButton = Instance.new("TextButton")
UpButton.Size = UDim2.new(0, 62, 0, 26)
UpButton.Position = UDim2.new(0.36, 0, 0, 193)
UpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
UpButton.BackgroundTransparency = 0.3
UpButton.TextColor3 = Color3.fromRGB(220, 220, 220)
UpButton.Text = "▲ Up"
UpButton.TextSize, UpButton.Font = 10, Enum.Font.GothamBold
UpButton.Parent = MainPageContainer

local DownButton = Instance.new("TextButton")
DownButton.Size = UDim2.new(0, 62, 0, 26)
DownButton.Position = UDim2.new(0.525, 0, 0, 193)
DownButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DownButton.BackgroundTransparency = 0.3
DownButton.TextColor3 = Color3.fromRGB(220, 220, 220)
DownButton.Text = "▼ Down"
DownButton.TextSize, DownButton.Font = 10, Enum.Font.GothamBold
DownButton.Parent = MainPageContainer

-- ==================== 右侧：走路速度滑块 + 飞行速度滑块 + 颜色盘 ====================
local WalkSpeedLabel = Instance.new("TextLabel")
WalkSpeedLabel.Size = UDim2.new(0, 135, 0, 20)
WalkSpeedLabel.Position = UDim2.new(0.69, 0, 0, 8)
WalkSpeedLabel.BackgroundTransparency = 1
WalkSpeedLabel.Text = "Walk Speed: 16"
WalkSpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
WalkSpeedLabel.TextSize, WalkSpeedLabel.Font = 11, Enum.Font.GothamBold
WalkSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
WalkSpeedLabel.Parent = MainPageContainer

local WalkTrackBar = Instance.new("Frame")
WalkTrackBar.Size = UDim2.new(0, 135, 0, 5)
WalkTrackBar.Position = UDim2.new(0.69, 0, 0, 33)
WalkTrackBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
WalkTrackBar.BorderSizePixel = 0
WalkTrackBar.Parent = MainPageContainer

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
FlySpeedLabel.Position = UDim2.new(0.69, 0, 0, 48)
FlySpeedLabel.BackgroundTransparency = 1
FlySpeedLabel.Text = "Fly Speed: 50"
FlySpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
FlySpeedLabel.TextSize, FlySpeedLabel.Font = 11, Enum.Font.GothamBold
FlySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
FlySpeedLabel.Parent = MainPageContainer

local FlyTrackBar = Instance.new("Frame")
FlyTrackBar.Size = UDim2.new(0, 135, 0, 5)
FlyTrackBar.Position = UDim2.new(0.69, 0, 0, 73)
FlyTrackBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyTrackBar.BorderSizePixel = 0
FlyTrackBar.Parent = MainPageContainer

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
TracerColorLabel.Position = UDim2.new(0.69, 0, 0, 88)
TracerColorLabel.BackgroundTransparency = 1
TracerColorLabel.Text = "Tracer Color"
TracerColorLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
TracerColorLabel.TextSize, TracerColorLabel.Font = 10, Enum.Font.GothamBold
TracerColorLabel.TextXAlignment = Enum.TextXAlignment.Left
TracerColorLabel.Parent = MainPageContainer

-- 射线颜色正方形色块
local TracerColorWhite = Instance.new("TextButton")
TracerColorWhite.Size = UDim2.new(0, 16, 0, 16)
TracerColorWhite.Position = UDim2.new(0.69, 0, 0, 105)
TracerColorWhite.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TracerColorWhite.Text = ""
TracerColorWhite.Parent = MainPageContainer

local TracerColorBlack = Instance.new("TextButton")
TracerColorBlack.Size = UDim2.new(0, 16, 0, 16)
TracerColorBlack.Position = UDim2.new(0.69, 20, 0, 105)
TracerColorBlack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TracerColorBlack.Text = ""
TracerColorBlack.Parent = MainPageContainer

local TracerColorRed = Instance.new("TextButton")
TracerColorRed.Size = UDim2.new(0, 16, 0, 16)
TracerColorRed.Position = UDim2.new(0.69, 40, 0, 105)
TracerColorRed.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
TracerColorRed.Text = ""
TracerColorRed.Parent = MainPageContainer

-- 方框颜色标签
local BoxColorLabel = Instance.new("TextLabel")
BoxColorLabel.Size = UDim2.new(0, 135, 0, 15)
BoxColorLabel.Position = UDim2.new(0.69, 0, 0, 128)
BoxColorLabel.BackgroundTransparency = 1
BoxColorLabel.Text = "Box Color"
BoxColorLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
BoxColorLabel.TextSize, BoxColorLabel.Font = 10, Enum.Font.GothamBold
BoxColorLabel.TextXAlignment = Enum.TextXAlignment.Left
BoxColorLabel.Parent = MainPageContainer

-- 方框颜色正方形色块
local BoxColorWhite = Instance.new("TextButton")
BoxColorWhite.Size = UDim2.new(0, 16, 0, 16)
BoxColorWhite.Position = UDim2.new(0.69, 0, 0, 145)
BoxColorWhite.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BoxColorWhite.Text = ""
BoxColorWhite.Parent = MainPageContainer

local BoxColorBlack = Instance.new("TextButton")
BoxColorBlack.Size = UDim2.new(0, 16, 0, 16)
BoxColorBlack.Position = UDim2.new(0.69, 20, 0, 145)
BoxColorBlack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BoxColorBlack.Text = ""
BoxColorBlack.Parent = MainPageContainer

local BoxColorRed = Instance.new("TextButton")
BoxColorRed.Size = UDim2.new(0, 16, 0, 16)
BoxColorRed.Position = UDim2.new(0.69, 40, 0, 145)
BoxColorRed.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
BoxColorRed.Text = ""
BoxColorRed.Parent = MainPageContainer

-- ==================== 飞行开启时显示的专属操控 UI（圆形方向盘往下移 + 右边稳固上下拉杆） ====================
local FlyWheelOuter = Instance.new("Frame")
FlyWheelOuter.Name = "FlyWheelOuter"
FlyWheelOuter.Size = UDim2.new(0, 112, 0, 112)
FlyWheelOuter.Position = UDim2.new(0, 28, 1, -225)
FlyWheelOuter.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FlyWheelOuter.BackgroundTransparency = 0.25
FlyWheelOuter.BorderSizePixel = 0
FlyWheelOuter.Active = true
FlyWheelOuter.Visible = false
FlyWheelOuter.Parent = ScreenGui

local wheelCorner = Instance.new("UICorner")
wheelCorner.CornerRadius = UDim.new(1, 0)
wheelCorner.Parent = FlyWheelOuter

local wheelStroke = Instance.new("UIStroke")
wheelStroke.Color = Color3.fromRGB(90, 90, 90)
wheelStroke.Thickness = 2
wheelStroke.Parent = FlyWheelOuter

local FlyWheelKnob = Instance.new("Frame")
FlyWheelKnob.Name = "FlyWheelKnob"
FlyWheelKnob.Size = UDim2.new(0, 40, 0, 40)
FlyWheelKnob.Position = UDim2.new(0.5, -20, 0.5, -20)
FlyWheelKnob.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
FlyWheelKnob.BackgroundTransparency = 0.15
FlyWheelKnob.BorderSizePixel = 0
FlyWheelKnob.Active = true
FlyWheelKnob.Parent = FlyWheelOuter

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = FlyWheelKnob

-- 右侧上下拉杆容器
local FlyVertPanel = Instance.new("Frame")
FlyVertPanel.Name = "FlyVertPanel"
FlyVertPanel.Size = UDim2.new(0, 48, 0, 160)
FlyVertPanel.Position = UDim2.new(1, -72, 0.5, -80)
FlyVertPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FlyVertPanel.BackgroundTransparency = 0.25
FlyVertPanel.BorderSizePixel = 0
FlyVertPanel.Active = true
FlyVertPanel.Visible = false
FlyVertPanel.Parent = ScreenGui

local VertTitle = Instance.new("TextLabel")
VertTitle.Size = UDim2.new(1, 0, 0, 18)
VertTitle.Position = UDim2.new(0, 0, 0, 2)
VertTitle.BackgroundTransparency = 1
VertTitle.Text = "U / D"
VertTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
VertTitle.TextSize = 10
VertTitle.Font = Enum.Font.GothamBold
VertTitle.Parent = FlyVertPanel

local VertTrack = Instance.new("Frame")
VertTrack.Size = UDim2.new(0, 6, 0, 122)
VertTrack.Position = UDim2.new(0.5, -3, 0, 26)
VertTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
VertTrack.BorderSizePixel = 0
VertTrack.Parent = FlyVertPanel

local VertThumb = Instance.new("Frame")
VertThumb.Size = UDim2.new(0, 26, 0, 18)
VertThumb.Position = UDim2.new(0.5, -13, 0.5, -9)
VertThumb.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
VertThumb.BorderSizePixel = 0
VertThumb.Active = true
VertThumb.Parent = VertTrack

-- 最小化逻辑
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 460, 0, 35)
        MinimizeButton.Text = "+"
        TopDivider.Visible = false
    else
        MainFrame.Size = UDim2.new(0, 460, 0, 310)
        MinimizeButton.Text = "-"
        TopDivider.Visible = true
    end
    applyPageState()
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

-- 4. 冰冻逻辑
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

-- 5. 速度滑块拖动逻辑（Walk / Fly / Spin）
local draggingFly, draggingWalk, draggingSpin = false, false, false
FlyThumb.MouseButton1Down:Connect(function() draggingFly = true end)
WalkThumb.MouseButton1Down:Connect(function() draggingWalk = true end)
SpinThumb.MouseButton1Down:Connect(function() draggingSpin = true end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFly = false
        draggingWalk = false
        draggingSpin = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local posX = input.Position.X
        
        if draggingFly then
            local tPos = FlyTrackBar.AbsolutePosition.X
            local tSize = FlyTrackBar.AbsoluteSize.X
            if tSize > 0 then
                local scale = math.clamp((posX - tPos) / tSize, 0, 1)
                FlyThumb.Position = UDim2.new(scale, -7, 0.5, -7)
                currentFlySpeed = math.floor(minFlySpeed + (maxFlySpeed - minFlySpeed) * scale)
                FlySpeedLabel.Text = "Fly Speed: " .. currentFlySpeed
            end
        end
        
        if draggingWalk then
            local tPos = WalkTrackBar.AbsolutePosition.X
            local tSize = WalkTrackBar.AbsoluteSize.X
            if tSize > 0 then
                local scale = math.clamp((posX - tPos) / tSize, 0, 1)
                WalkThumb.Position = UDim2.new(scale, -7, 0.5, -7)
                currentWalkSpeed = math.floor(minWalkSpeed + (maxWalkSpeed - minWalkSpeed) * scale)
                WalkSpeedLabel.Text = "Walk Speed: " .. currentWalkSpeed
                
                if walkActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = currentWalkSpeed
                end
            end
        end

        if draggingSpin then
            local tPos = SpinTrackBar.AbsolutePosition.X
            local tSize = SpinTrackBar.AbsoluteSize.X
            if tSize > 0 then
                local scale = math.clamp((posX - tPos) / tSize, 0, 1)
                SpinThumb.Position = UDim2.new(scale, -7, 0.5, -7)
                currentSpinSpeed = math.floor(minSpinSpeed + (maxSpinSpeed - minSpinSpeed) * scale)
                SpinSpeedLabel.Text = "Spin Speed: " .. currentSpinSpeed
            end
        end
    end
end)

-- Fun 旋转逻辑
local spinActive = false
SpinBtn.MouseButton1Click:Connect(function()
    spinActive = not spinActive
    setToggleVisual(SpinTrack, SpinKnob, spinActive)
end)

RunService.RenderStepped:Connect(function(dt)
    if spinActive and not active then
        local char = LocalPlayer.Character
        local rp = char and char:FindFirstChild("HumanoidRootPart")
        if rp then
            rp.CFrame = rp.CFrame * CFrame.Angles(0, currentSpinSpeed * dt, 0)
        end
    end
end)

-- 6. 飞行逻辑（电脑端严格按当前摄像机视角方向飞）
local active = false
local bv, bodyGyroFly = nil, nil
local connection = nil
local isUpPressed, isDownPressed = false, false

local wheelTouch = nil
local wheelVec = Vector2.new(0, 0)

local function updateWheel(screenPos)
    local center = FlyWheelOuter.AbsolutePosition + (FlyWheelOuter.AbsoluteSize * 0.5)
    local maxRadius = (FlyWheelOuter.AbsoluteSize.X * 0.5) - 18
    local offset = Vector2.new(screenPos.X - center.X, screenPos.Y - center.Y)
    local dist = offset.Magnitude
    if dist > maxRadius and dist > 0 then
        offset = offset.Unit * maxRadius
    end
    FlyWheelKnob.Position = UDim2.new(0.5, offset.X - (FlyWheelKnob.AbsoluteSize.X * 0.5), 0.5, offset.Y - (FlyWheelKnob.AbsoluteSize.Y * 0.5))
    if maxRadius > 0 then
        wheelVec = Vector2.new(offset.X / maxRadius, -offset.Y / maxRadius)
    end
end

local function resetWheel()
    wheelTouch = nil
    wheelVec = Vector2.new(0, 0)
    FlyWheelKnob.Position = UDim2.new(0.5, -20, 0.5, -20)
end

local function onWheelInputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not wheelTouch then
            wheelTouch = input
            updateWheel(input.Position)
        end
    end
end

FlyWheelOuter.InputBegan:Connect(onWheelInputBegan)
FlyWheelKnob.InputBegan:Connect(onWheelInputBegan)

local vertTouch = nil
local vertAxis = 0

local function updateVert(screenY)
    local vPos = VertTrack.AbsolutePosition.Y
    local vSize = VertTrack.AbsoluteSize.Y
    if vSize <= 0 then return end
    local scaleY = math.clamp((screenY - vPos) / vSize, 0, 1)
    VertThumb.Position = UDim2.new(0.5, -13, scaleY, -9)
    vertAxis = math.clamp((0.5 - scaleY) * 2, -1, 1)
end

local function resetVert()
    vertTouch = nil
    vertAxis = 0
    VertThumb.Position = UDim2.new(0.5, -13, 0.5, -9)
end

local function onVertInputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if not vertTouch then
            vertTouch = input
            updateVert(input.Position.Y)
        end
    end
end

FlyVertPanel.InputBegan:Connect(onVertInputBegan)
VertThumb.InputBegan:Connect(onVertInputBegan)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if wheelTouch and input == wheelTouch then
            updateWheel(input.Position)
        end
        if vertTouch and input == vertTouch then
            updateVert(input.Position.Y)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if wheelTouch and input == wheelTouch then
        resetWheel()
    end
    if vertTouch and input == vertTouch then
        resetVert()
    end
end)

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
        FlyWheelOuter.Visible = true
        FlyVertPanel.Visible = true
        humanoid.PlatformStand = true
        
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = rootPart
        
        bodyGyroFly = Instance.new("BodyGyro")
        bodyGyroFly.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyroFly.P = 6000
        bodyGyroFly.D = 400
        bodyGyroFly.CFrame = rootPart.CFrame
        bodyGyroFly.Parent = rootPart
        
        connection = RunService.RenderStepped:Connect(function(dt)
            local c = LocalPlayer.Character
            local rp = c and c:FindFirstChild("HumanoidRootPart")
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            local cam = workspace.CurrentCamera
            if not rp or not hum or not cam then return end
            if not hum.PlatformStand then hum.PlatformStand = true end

            local camCF = cam.CFrame
            local moveLocal = Vector3.new(0, 0, 0)

            -- 电脑端：直接按当前视角方向（前/后/左/右）
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveLocal = moveLocal + Vector3.new(0, 0, -1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveLocal = moveLocal + Vector3.new(0, 0, 1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveLocal = moveLocal + Vector3.new(-1, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveLocal = moveLocal + Vector3.new(1, 0, 0) end

            -- 圆形方向盘控制
            if wheelVec.Magnitude > 0.08 then
                moveLocal = moveLocal + Vector3.new(wheelVec.X, 0, -wheelVec.Y)
            end

            local worldDir = Vector3.new(0, 0, 0)
            if moveLocal.Magnitude > 0.001 then
                worldDir = camCF:VectorToWorldSpace(moveLocal)
            end

            -- 手机端摇杆控制
            local joyDir = hum.MoveDirection
            if joyDir.Magnitude > 0.05 then
                worldDir = worldDir + Vector3.new(joyDir.X, 0, joyDir.Z)
            end

            if worldDir.Magnitude > 1 then
                worldDir = worldDir.Unit
            end

            local vel = worldDir * currentFlySpeed

            local upDown = vertAxis
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) or isUpPressed then
                upDown = upDown + 1
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or isDownPressed then
                upDown = upDown - 1
            end
            upDown = math.clamp(upDown, -1, 1)

            bv.Velocity = Vector3.new(vel.X, math.clamp(vel.Y + upDown * currentFlySpeed, -currentFlySpeed, currentFlySpeed), vel.Z)
            local baseGyro = CFrame.lookAt(rp.Position, rp.Position + camCF.LookVector)
            if spinActive then
                baseGyro = baseGyro * CFrame.Angles(0, currentSpinSpeed * dt * 15, 0)
            end
            bodyGyroFly.CFrame = baseGyro
        end)
    else
        FlyTrackBarColor.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        FlyKnob.Position = UDim2.new(0, 2, 0.5, -6)
        FlyWheelOuter.Visible = false
        FlyVertPanel.Visible = false
        resetWheel()
        resetVert()
        isUpPressed, isDownPressed = false, false
        if humanoid then humanoid.PlatformStand = false end
        if connection then connection:Disconnect() connection = nil end
        if bv then bv:Destroy() bv = nil end
        if bodyGyroFly then bodyGyroFly:Destroy() bodyGyroFly = nil end
    end
end

FlyBtn.MouseButton1Click:Connect(toggleFlight)

-- 7. ESP 颜色与逻辑（方框 + 射线 + 头顶 Name / @Name / Distance）
local tracerActive = false
local boxActive = false
local nameActive = false
local atNameActive = false
local distActive = false
local tracerColor = Color3.fromRGB(255, 255, 255)
local boxColor = Color3.fromRGB(255, 255, 255)

TracerBtn.MouseButton1Click:Connect(function()
    tracerActive = not tracerActive
    setToggleVisual(TracerTrack, TracerKnob, tracerActive)
end)

TracerColorWhite.MouseButton1Click:Connect(function() tracerColor = Color3.fromRGB(255, 255, 255) end)
TracerColorBlack.MouseButton1Click:Connect(function() tracerColor = Color3.fromRGB(0, 0, 0) end)
TracerColorRed.MouseButton1Click:Connect(function() tracerColor = Color3.fromRGB(255, 50, 50) end)

BoxBtn.MouseButton1Click:Connect(function()
    boxActive = not boxActive
    setToggleVisual(BoxTrack, BoxKnob, boxActive)
end)

NameBtn.MouseButton1Click:Connect(function()
    nameActive = not nameActive
    setToggleVisual(NameTrack, NameKnob, nameActive)
end)

AtNameBtn.MouseButton1Click:Connect(function()
    atNameActive = not atNameActive
    setToggleVisual(AtNameTrack, AtNameKnob, atNameActive)
end)

DistBtn.MouseButton1Click:Connect(function()
    distActive = not distActive
    setToggleVisual(DistTrack, DistKnob, distActive)
end)

BoxColorWhite.MouseButton1Click:Connect(function() boxColor = Color3.fromRGB(255, 255, 255) end)
BoxColorBlack.MouseButton1Click:Connect(function() boxColor = Color3.fromRGB(0, 0, 0) end)
BoxColorRed.MouseButton1Click:Connect(function() boxColor = Color3.fromRGB(255, 50, 50) end)

local TracerGui = Instance.new("ScreenGui")
TracerGui.Name = "LMMTracerLineGui"
TracerGui.ResetOnSpawn = false
TracerGui.IgnoreGuiInset = true
TracerGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local espBoxes = {}
local espTags = {}
local tracerLines = {}

local function removeBoxForPlayer(plr)
    local gui = espBoxes[plr]
    if gui then
        pcall(function() gui:Destroy() end)
        espBoxes[plr] = nil
    end
end

local function removeTagForPlayer(plr)
    local tag = espTags[plr]
    if tag then
        pcall(function() tag.gui:Destroy() end)
        espTags[plr] = nil
    end
end

local function removeLineForPlayer(plr)
    local line = tracerLines[plr]
    if line then
        pcall(function() line:Destroy() end)
        tracerLines[plr] = nil
    end
end

RunService.RenderStepped:Connect(function()
    Camera = workspace.CurrentCamera
    if not Camera then return end

    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    for plr, _ in pairs(espBoxes) do
        if not plr or not plr.Parent or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") or plr == LocalPlayer then
            removeBoxForPlayer(plr)
        end
    end

    for plr, _ in pairs(espTags) do
        if not plr or not plr.Parent or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") or plr == LocalPlayer then
            removeTagForPlayer(plr)
        end
    end

    for plr, _ in pairs(tracerLines) do
        if not plr or not plr.Parent or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") or plr == LocalPlayer then
            removeLineForPlayer(plr)
        end
    end

    local origin = Vector2.new(Camera.ViewportSize.X * 0.5, Camera.ViewportSize.Y)

    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")

        if plr ~= LocalPlayer and char and rootPart and hum and hum.Health > 0 then
            -- 1) 方框 ESP
            local boxData = espBoxes[plr]
            if not boxData or boxData.rootPart ~= rootPart then
                removeBoxForPlayer(plr)
                local boxGui = Instance.new("BillboardGui")
                boxGui.Name = "LMMBoxESP"
                boxGui.Adornee = rootPart
                boxGui.Size = UDim2.new(4, 0, 5.5, 0)
                boxGui.AlwaysOnTop = true
                boxGui.Enabled = false
                boxGui.Parent = ScreenGui

                local boxFrame = Instance.new("Frame")
                boxFrame.Size = UDim2.new(1, 0, 1, 0)
                boxFrame.BackgroundTransparency = 1
                boxFrame.BorderSizePixel = 0
                boxFrame.Parent = boxGui

                local stroke = Instance.new("UIStroke")
                stroke.Thickness = 2
                stroke.Parent = boxFrame

                boxData = {rootPart = rootPart, gui = boxGui, stroke = stroke}
                espBoxes[plr] = boxData
            end
            boxData.gui.Enabled = boxActive
            boxData.stroke.Color = boxColor

            -- 2) 头顶文字 ESP（Name / @Name / Distance）
            local tagAdornee = head or rootPart
            local tagData = espTags[plr]
            if not tagData or tagData.adornee ~= tagAdornee then
                removeTagForPlayer(plr)
                local tagGui = Instance.new("BillboardGui")
                tagGui.Name = "LMMHeadTagESP"
                tagGui.Adornee = tagAdornee
                tagGui.StudsOffset = Vector3.new(0, 2.2, 0)
                tagGui.Size = UDim2.new(0, 160, 0, 54)
                tagGui.AlwaysOnTop = true
                tagGui.Enabled = false
                tagGui.Parent = ScreenGui

                local listLayout = Instance.new("UIListLayout")
                listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                listLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
                listLayout.Padding = UDim.new(0, 1)
                listLayout.Parent = tagGui

                local function makeTagLabel(name)
                    local lbl = Instance.new("TextLabel")
                    lbl.Name = name
                    lbl.Size = UDim2.new(1, 0, 0, 16)
                    lbl.BackgroundTransparency = 1
                    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                    lbl.TextStrokeTransparency = 0.25
                    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    lbl.TextSize = 12
                    lbl.Font = Enum.Font.GothamBold
                    lbl.Visible = false
                    lbl.Parent = tagGui
                    return lbl
                end

                local nameLbl = makeTagLabel("NameLabel")
                local atNameLbl = makeTagLabel("AtNameLabel")
                local distLbl = makeTagLabel("DistLabel")

                tagData = {
                    adornee = tagAdornee,
                    gui = tagGui,
                    nameLbl = nameLbl,
                    atNameLbl = atNameLbl,
                    distLbl = distLbl
                }
                espTags[plr] = tagData
            end

            local anyTagEnabled = nameActive or atNameActive or distActive
            tagData.gui.Enabled = anyTagEnabled

            tagData.nameLbl.Visible = nameActive
            if nameActive then
                tagData.nameLbl.Text = plr.DisplayName
            end

            tagData.atNameLbl.Visible = atNameActive
            if atNameActive then
                tagData.atNameLbl.Text = "@" .. plr.Name
            end

            tagData.distLbl.Visible = distActive
            if distActive then
                if myRoot then
                    local studs = math.floor((rootPart.Position - myRoot.Position).Magnitude)
                    tagData.distLbl.Text = tostring(studs) .. "m"
                else
                    tagData.distLbl.Text = "0m"
                end
            end

            -- 3) 射线 ESP
            local lineFrame = tracerLines[plr]
            if not lineFrame then
                lineFrame = Instance.new("Frame")
                lineFrame.Name = "LMMTracerSegment"
                lineFrame.BorderSizePixel = 0
                lineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                lineFrame.Visible = false
                lineFrame.Parent = TracerGui
                tracerLines[plr] = lineFrame
            end

            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            if tracerActive and onScreen then
                local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                local delta = targetPos - origin
                local dist = delta.Magnitude
                lineFrame.Size = UDim2.new(0, math.max(1, dist), 0, 2)
                lineFrame.Position = UDim2.new(0, (origin.X + targetPos.X) * 0.5, 0, (origin.Y + targetPos.Y) * 0.5)
                lineFrame.Rotation = math.deg(math.atan2(delta.Y, delta.X))
                lineFrame.BackgroundColor3 = tracerColor
                lineFrame.Visible = true
            else
                lineFrame.Visible = false
            end
        else
            if espBoxes[plr] then espBoxes[plr].gui.Enabled = false end
            if espTags[plr] then espTags[plr].gui.Enabled = false end
            if tracerLines[plr] then tracerLines[plr].Visible = false end
        end
    end
end)
