--//============================================================//
--// 🥚 EGG FPS MONITOR
--// FPS BOOST + GOD MODE + ADVANCED FLOAT
--// + BAT AUTO + FAR CAMERA + COSMIC BAT
--//============================================================//

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--//============================================================//
--// REMOVE OLD GUI
--//============================================================//

local OldGUI = PlayerGui:FindFirstChild("EggFPSMonitor")

if OldGUI then
    OldGUI:Destroy()
end

--//============================================================//
--// 🥚 KYOSH // STEAL A EGG UI
--// MOBILE-FIRST • RESPONSIVE • MINIMIZABLE
--//============================================================//

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EggFPSMonitor"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

--//============================================================//
--// MAIN WINDOW
--//============================================================//

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0,370,0,445)
Main.Position = UDim2.new(0.5,-185,0.5,-227)
Main.BackgroundColor3 = Color3.fromRGB(13,14,19)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,18)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255,205,70)
MainStroke.Thickness = 1.8
MainStroke.Transparency = 0.08
MainStroke.Parent = Main

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(22,23,31)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(10,11,15))
})
MainGradient.Rotation = 90
MainGradient.Parent = Main

--// Responsive scale for phones/tablets
local UIScale = Instance.new("UIScale")
UIScale.Scale = 1
UIScale.Parent = Main

local function UpdateResponsiveScale()
    local Camera = workspace.CurrentCamera
    if not Camera then return end

    local Viewport = Camera.ViewportSize
    local Scale = 1

    if Viewport.X < 500 then
        Scale = math.clamp((Viewport.X - 24) / 370,0.72,1)
    elseif Viewport.Y < 520 then
        Scale = math.clamp((Viewport.Y - 24) / 455,0.72,1)
    end

    UIScale.Scale = Scale
end

UpdateResponsiveScale()

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateResponsiveScale)
end

--//============================================================//
--// HEADER
--//============================================================//

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,68)
Header.BackgroundColor3 = Color3.fromRGB(25,26,34)
Header.BorderSizePixel = 0
Header.Active = true
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0,18)
HeaderCorner.Parent = Header

local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1,-28,0,1)
HeaderLine.Position = UDim2.new(0,14,1,-1)
HeaderLine.BackgroundColor3 = Color3.fromRGB(255,205,70)
HeaderLine.BackgroundTransparency = 0.55
HeaderLine.BorderSizePixel = 0
HeaderLine.Parent = Header

local EggIcon = Instance.new("TextLabel")
EggIcon.Size = UDim2.new(0,50,0,52)
EggIcon.Position = UDim2.new(0,8,0,7)
EggIcon.BackgroundTransparency = 1
EggIcon.Text = "🥚"
EggIcon.TextSize = 31
EggIcon.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-145,0,25)
Title.Position = UDim2.new(0,58,0,7)
Title.BackgroundTransparency = 1
Title.Text = "KYOSH // STEAL A EGG"
Title.TextColor3 = Color3.fromRGB(255,215,80)
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1,-145,0,18)
Subtitle.Position = UDim2.new(0,59,0,34)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "EGG MACRO"
Subtitle.TextColor3 = Color3.fromRGB(145,147,158)
Subtitle.TextSize = 10
Subtitle.Font = Enum.Font.GothamMedium
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

--//============================================================//
--// MINIMIZE / CLOSE
--//============================================================//

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0,30,0,30)
MinimizeButton.Position = UDim2.new(1,-76,0,19)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(48,49,59)
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(255,215,80)
MinimizeButton.TextSize = 17
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.BorderSizePixel = 0
MinimizeButton.AutoButtonColor = false
MinimizeButton.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0,9)
MinCorner.Parent = MinimizeButton

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0,30,0,30)
CloseButton.Position = UDim2.new(1,-40,0,19)
CloseButton.BackgroundColor3 = Color3.fromRGB(48,49,59)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255,115,115)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.AutoButtonColor = false
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0,9)
CloseCorner.Parent = CloseButton

--//============================================================//
--// CATEGORY BAR
--//============================================================//

local CategoryBar = Instance.new("Frame")
CategoryBar.Size = UDim2.new(1,-20,0,38)
CategoryBar.Position = UDim2.new(0,10,0,78)
CategoryBar.BackgroundTransparency = 1
CategoryBar.Parent = Main

local function MakeTab(Name,Text,Position)
    local Button = Instance.new("TextButton")
    Button.Name = Name
    Button.Size = UDim2.new(0.5,-4,1,0)
    Button.Position = Position
    Button.BackgroundColor3 = Color3.fromRGB(32,33,43)
    Button.Text = Text
    Button.TextColor3 = Color3.fromRGB(160,162,174)
    Button.TextSize = 11
    Button.Font = Enum.Font.GothamBold
    Button.BorderSizePixel = 0
    Button.AutoButtonColor = false
    Button.Parent = CategoryBar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0,10)
    Corner.Parent = Button

    return Button
end

local HomeButton = MakeTab("HomeButton","🏠  OVERVIEW",UDim2.new(0,0,0,0))
local FPSButton = MakeTab("FPSButton","⚡  FEATURES",UDim2.new(0.5,4,0,0))

FPSButton.BackgroundColor3 = Color3.fromRGB(255,195,60)
FPSButton.TextColor3 = Color3.fromRGB(25,25,25)

--//============================================================//
--// HOME PAGE
--//============================================================//

local HomePage = Instance.new("Frame")
HomePage.Size = UDim2.new(1,-20,0,315)
HomePage.Position = UDim2.new(0,10,0,128)
HomePage.BackgroundTransparency = 1
HomePage.Visible = false
HomePage.Parent = Main

local HomeTitle = Instance.new("TextLabel")
HomeTitle.Size = UDim2.new(1,0,0,30)
HomeTitle.BackgroundTransparency = 1
HomeTitle.Text = "🥚  STEAL A EGG // READY"
HomeTitle.TextColor3 = Color3.fromRGB(238,239,244)
HomeTitle.TextSize = 14
HomeTitle.Font = Enum.Font.GothamBold
HomeTitle.TextXAlignment = Enum.TextXAlignment.Left
HomeTitle.Parent = HomePage

local HomeInfo = Instance.new("TextLabel")
HomeInfo.Size = UDim2.new(1,0,0,225)
HomeInfo.Position = UDim2.new(0,0,0,42)
HomeInfo.BackgroundTransparency = 1
HomeInfo.Text =
    "KYOSH // STEAL A EGG\n\n" ..
    "A compact control panel for performance,\n" ..
    "protection, movement and Bat utilities.\n\n" ..
    "🛡  GOD MODE     Protect your Humanoid\n" ..
    "⚡  FPS BOOST    One-way visual optimization\n" ..
    "🪽  FLOAT        Ground-follow movement\n" ..
    "🦇  BAT AUTO     Automatic Bat interaction\n" ..
    "📷  FAR CAMERA   Extended camera distance\n" ..
    "🌌  COSMIC BAT   Visual Bat selector\n\n" ..
    "● SYSTEM STATUS: ONLINE"
HomeInfo.TextColor3 = Color3.fromRGB(164,166,177)
HomeInfo.TextSize = 12
HomeInfo.Font = Enum.Font.Gotham
HomeInfo.TextXAlignment = Enum.TextXAlignment.Left
HomeInfo.TextYAlignment = Enum.TextYAlignment.Top
HomeInfo.Parent = HomePage

--//============================================================//
--// FEATURES PAGE
--//============================================================//

local FPSPage = Instance.new("Frame")
FPSPage.Size = UDim2.new(1,-20,0,315)
FPSPage.Position = UDim2.new(0,10,0,128)
FPSPage.BackgroundTransparency = 1
FPSPage.Visible = true
FPSPage.Parent = Main

local FPSBox = Instance.new("Frame")
FPSBox.Size = UDim2.new(0.48,0,0,62)
FPSBox.BackgroundColor3 = Color3.fromRGB(27,29,37)
FPSBox.BorderSizePixel = 0
FPSBox.Parent = FPSPage

local FPSBoxCorner = Instance.new("UICorner")
FPSBoxCorner.CornerRadius = UDim.new(0,11)
FPSBoxCorner.Parent = FPSBox

local FPSAccent = Instance.new("Frame")
FPSAccent.Size = UDim2.new(0,3,1,-20)
FPSAccent.Position = UDim2.new(0,8,0,10)
FPSAccent.BackgroundColor3 = Color3.fromRGB(100,255,130)
FPSAccent.BorderSizePixel = 0
FPSAccent.Parent = FPSBox

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(1,-24,1,0)
FPSLabel.Position = UDim2.new(0,18,0,0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: --"
FPSLabel.TextColor3 = Color3.fromRGB(100,255,130)
FPSLabel.TextSize = 20
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.Parent = FPSBox

local PingBox = Instance.new("Frame")
PingBox.Size = UDim2.new(0.48,0,0,62)
PingBox.Position = UDim2.new(0.52,0,0,0)
PingBox.BackgroundColor3 = Color3.fromRGB(27,29,37)
PingBox.BorderSizePixel = 0
PingBox.Parent = FPSPage

local PingCorner = Instance.new("UICorner")
PingCorner.CornerRadius = UDim.new(0,11)
PingCorner.Parent = PingBox

local PingAccent = Instance.new("Frame")
PingAccent.Size = UDim2.new(0,3,1,-20)
PingAccent.Position = UDim2.new(0,8,0,10)
PingAccent.BackgroundColor3 = Color3.fromRGB(255,205,70)
PingAccent.BorderSizePixel = 0
PingAccent.Parent = PingBox

local PingLabel = Instance.new("TextLabel")
PingLabel.Size = UDim2.new(1,-24,1,0)
PingLabel.Position = UDim2.new(0,18,0,0)
PingLabel.BackgroundTransparency = 1
PingLabel.Text = "PING: --"
PingLabel.TextColor3 = Color3.fromRGB(255,215,80)
PingLabel.TextSize = 20
PingLabel.Font = Enum.Font.GothamBold
PingLabel.Parent = PingBox

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1,0,0,22)
StatusLabel.Position = UDim2.new(0,0,0,73)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "● SYSTEM ONLINE"
StatusLabel.TextColor3 = Color3.fromRGB(100,255,130)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = FPSPage

--//============================================================//
--// BUTTON HELPER
--//============================================================//

local function MakeButton(Name,Text,Position,IsToggle)
    local Button = Instance.new("TextButton")
    Button.Name = Name
    Button.Size = UDim2.new(0.48,0,0,42)
    Button.Position = Position
    Button.BackgroundColor3 = Color3.fromRGB(35,36,46)
    Button.Text = Text
    Button.TextColor3 = Color3.fromRGB(238,239,244)
    Button.TextSize = 11
    Button.Font = Enum.Font.GothamBold
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.BorderSizePixel = 0
    Button.AutoButtonColor = false
    Button.Parent = FPSPage

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0,10)
    Corner.Parent = Button

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(65,66,78)
    Stroke.Thickness = 1
    Stroke.Transparency = 0.2
    Stroke.Parent = Button

    if IsToggle then
        Button.Text = Text
        Button.TextXAlignment = Enum.TextXAlignment.Left

        local ToggleTrack = Instance.new("Frame")
        ToggleTrack.Name = "ToggleTrack"
        ToggleTrack.Size = UDim2.new(0,62,0,30)
        ToggleTrack.Position = UDim2.new(1,-70,0.5,-15)
        ToggleTrack.BackgroundColor3 = Color3.fromRGB(18,19,25)
        ToggleTrack.BorderSizePixel = 0
        ToggleTrack.Parent = Button

        local TrackCorner = Instance.new("UICorner")
        TrackCorner.CornerRadius = UDim.new(1,0)
        TrackCorner.Parent = ToggleTrack

        local TrackStroke = Instance.new("UIStroke")
        TrackStroke.Name = "ToggleStroke"
        TrackStroke.Color = Color3.fromRGB(255,205,35)
        TrackStroke.Thickness = 1.5
        TrackStroke.Transparency = 0
        TrackStroke.Parent = ToggleTrack

        local ToggleKnob = Instance.new("Frame")
        ToggleKnob.Name = "ToggleKnob"
        ToggleKnob.Size = UDim2.new(0,24,0,24)
        ToggleKnob.Position = UDim2.new(0,3,0.5,-12)
        ToggleKnob.BackgroundColor3 = Color3.fromRGB(248,248,245)
        ToggleKnob.BorderSizePixel = 0
        ToggleKnob.Parent = ToggleTrack

        local KnobCorner = Instance.new("UICorner")
        KnobCorner.CornerRadius = UDim.new(1,0)
        KnobCorner.Parent = ToggleKnob

        local KnobStroke = Instance.new("UIStroke")
        KnobStroke.Color = Color3.fromRGB(255,220,120)
        KnobStroke.Thickness = 1
        KnobStroke.Transparency = 0.15
        KnobStroke.Parent = ToggleKnob

        local ToggleGlow = Instance.new("UIGradient")
        ToggleGlow.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(1,Color3.fromRGB(225,225,220))
        })
        ToggleGlow.Rotation = 90
        ToggleGlow.Parent = ToggleKnob
    end

    return Button
end

local function SetToggleVisual(Button,Enabled)
    local ToggleTrack = Button:FindFirstChild("ToggleTrack")
    local ToggleKnob = ToggleTrack and ToggleTrack:FindFirstChild("ToggleKnob")
    local ToggleStroke = ToggleTrack and ToggleTrack:FindFirstChild("ToggleStroke")

    if not ToggleTrack or not ToggleKnob then
        return
    end

    local TargetPosition
    if Enabled then
        TargetPosition = UDim2.new(1,-27,0.5,-12)
    else
        TargetPosition = UDim2.new(0,3,0.5,-12)
    end

    TweenService:Create(
        ToggleKnob,
        TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
        {Position = TargetPosition}
    ):Play()

    ToggleTrack.BackgroundColor3 =
        Enabled and Color3.fromRGB(28,31,24) or Color3.fromRGB(18,19,25)

    if ToggleStroke then
        ToggleStroke.Color =
            Enabled and Color3.fromRGB(255,205,35) or Color3.fromRGB(150,125,35)
        ToggleStroke.Thickness = Enabled and 1.8 or 1.5
    end
end

local GodModeButton = MakeButton("GodModeButton","  GOD MODE",UDim2.new(0,0,0,102),true)
local FPSBoostButton = MakeButton("FPSBoostButton","  FPS BOOST",UDim2.new(0.52,0,0,102),true)
local FloatButton = MakeButton("FloatButton","  FLOAT",UDim2.new(0,0,0,151),true)
local BatAutoButton = MakeButton("BatAutoButton","  BAT AUTO",UDim2.new(0.52,0,0,151),true)
local FarCameraButton = MakeButton("FarCameraButton","  FAR CAMERA",UDim2.new(0,0,0,200),true)
local BatVisualButton = MakeButton("BatVisualButton","  BAT VISUAL: OFF",UDim2.new(0.52,0,0,200))
local AntiRagdollButton = MakeButton("AntiRagdollButton","  ANTI RAGDOLL",UDim2.new(0,0,0,249), true)

SetToggleVisual(GodModeButton,false)
SetToggleVisual(FPSBoostButton,false)
SetToggleVisual(FloatButton,false)
SetToggleVisual(BatAutoButton,false)
SetToggleVisual(FarCameraButton,false)
SetToggleVisual(AntiRagdollButton,false)

--//============================================================//
--// MOBILE MINIMIZED BUTTON
--//============================================================//

local MiniButton = Instance.new("TextButton")
MiniButton.Name = "MiniButton"
MiniButton.Size = UDim2.new(0,58,0,58)
MiniButton.Position = UDim2.new(0,18,0.72,0)
MiniButton.BackgroundColor3 = Color3.fromRGB(20,21,28)
MiniButton.Text = "🥚"
MiniButton.TextSize = 29
MiniButton.TextColor3 = Color3.fromRGB(255,215,80)
MiniButton.BorderSizePixel = 0
MiniButton.AutoButtonColor = false
MiniButton.Visible = false
MiniButton.Active = true
MiniButton.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0,17)
MiniCorner.Parent = MiniButton

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(255,205,70)
MiniStroke.Thickness = 2
MiniStroke.Parent = MiniButton

--//============================================================//
--// MINIMIZE / RESTORE
--//============================================================//

local function SetMinimized(State)
    Main.Visible = not State
    MiniButton.Visible = State
end

MinimizeButton.MouseButton1Click:Connect(function()
    SetMinimized(true)
end)

MiniButton.MouseButton1Click:Connect(function()
    SetMinimized(false)
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

--//============================================================//
--// DRAG SUPPORT — MOUSE + TOUCH
--//============================================================//

local function MakeDraggable(Object,Handle)
    local Dragging = false
    local DragStart = nil
    local StartPosition = nil

    Handle.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = Input.Position
            StartPosition = Object.Position

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if not Dragging then return end
        if Input.UserInputType ~= Enum.UserInputType.MouseMovement
        and Input.UserInputType ~= Enum.UserInputType.Touch then return end

        local Delta = Input.Position - DragStart

        Object.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end)
end

MakeDraggable(Main,Header)
MakeDraggable(MiniButton,MiniButton)

--//============================================================//
--// TAB SWITCHING
--//============================================================//

local function SelectTab(Tab)
    if Tab == "Home" then
        HomePage.Visible = true
        FPSPage.Visible = false

        HomeButton.BackgroundColor3 = Color3.fromRGB(255,195,60)
        HomeButton.TextColor3 = Color3.fromRGB(25,25,25)

        FPSButton.BackgroundColor3 = Color3.fromRGB(32,33,43)
        FPSButton.TextColor3 = Color3.fromRGB(160,162,174)
    else
        HomePage.Visible = false
        FPSPage.Visible = true

        HomeButton.BackgroundColor3 = Color3.fromRGB(32,33,43)
        HomeButton.TextColor3 = Color3.fromRGB(160,162,174)

        FPSButton.BackgroundColor3 = Color3.fromRGB(255,195,60)
        FPSButton.TextColor3 = Color3.fromRGB(25,25,25)
    end
end

HomeButton.MouseButton1Click:Connect(function()
    SelectTab("Home")
end)

FPSButton.MouseButton1Click:Connect(function()
    SelectTab("FPS")
end)

SelectTab("FPS")

--//============================================================//
--// ADVANCED GOD MODE
--//============================================================//

local GodModeEnabled = false

local ProtectHealth = true
local ProtectDeath = true
local ProtectRagdoll = true
local ProtectFall = true

local FALL_LIMIT = -500
local RECOVERY_HEIGHT = 8

local GodCharacter = nil
local GodHumanoid = nil
local GodRootPart = nil
local LastSafeCFrame = nil
local CharacterConnections = {}

local function DisconnectGodConnections()

    for _,Connection in ipairs(CharacterConnections) do
        pcall(function()
            Connection:Disconnect()
        end)
    end

    table.clear(CharacterConnections)
end

local function SetupGodCharacter(Character)

    DisconnectGodConnections()

    GodCharacter = Character
    GodHumanoid = Character:WaitForChild("Humanoid",10)
    GodRootPart = Character:WaitForChild("HumanoidRootPart",10)

    if not GodHumanoid or not GodRootPart then
        return
    end

    LastSafeCFrame = GodRootPart.CFrame

    if GodModeEnabled and ProtectDeath then
        pcall(function()
            GodHumanoid:SetStateEnabled(
                Enum.HumanoidStateType.Dead,
                false
            )
        end)
    end

    table.insert(CharacterConnections,
        GodHumanoid.HealthChanged:Connect(function(Health)

            if not GodModeEnabled or not ProtectHealth then
                return
            end

            if Health < GodHumanoid.MaxHealth then
                pcall(function()
                    GodHumanoid.Health = GodHumanoid.MaxHealth
                end)
            end
        end)
    )

    table.insert(CharacterConnections,
        GodHumanoid.StateChanged:Connect(function(_,State)

            if not GodModeEnabled then
                return
            end

            if ProtectDeath and State == Enum.HumanoidStateType.Dead then
                pcall(function()
                    GodHumanoid:SetStateEnabled(
                        Enum.HumanoidStateType.Dead,
                        false
                    )
                    GodHumanoid.Health = GodHumanoid.MaxHealth
                    GodHumanoid:ChangeState(
                        Enum.HumanoidStateType.GettingUp
                    )
                end)
            end

            if ProtectRagdoll and
                (State == Enum.HumanoidStateType.Ragdoll or
                 State == Enum.HumanoidStateType.FallingDown)
            then
                pcall(function()
                    GodHumanoid.PlatformStand = false
                    GodHumanoid:ChangeState(
                        Enum.HumanoidStateType.GettingUp
                    )
                end)
            end
        end)
    )
end

local function EnableGodMode()

    GodModeEnabled = true

    if Player.Character then
        task.spawn(function()
            SetupGodCharacter(Player.Character)
        end)
    end

    GodModeButton.Text = "  GOD MODE"
    GodModeButton.TextColor3 =
        Color3.fromRGB(100,255,130)
    GodModeButton.BackgroundColor3 =
        Color3.fromRGB(35,36,46)
    SetToggleVisual(GodModeButton,true)
end

local function DisableGodMode()

    GodModeEnabled = false
    DisconnectGodConnections()

    if GodHumanoid and GodHumanoid.Parent then
        pcall(function()
            GodHumanoid:SetStateEnabled(
                Enum.HumanoidStateType.Dead,
                true
            )
        end)
    end

    GodCharacter = nil
    GodHumanoid = nil
    GodRootPart = nil
    LastSafeCFrame = nil

    GodModeButton.Text = "  GOD MODE"
    GodModeButton.TextColor3 =
        Color3.fromRGB(238,239,244)
    GodModeButton.BackgroundColor3 =
        Color3.fromRGB(35,36,46)
    SetToggleVisual(GodModeButton,false)
end

GodModeButton.MouseButton1Click:Connect(function()

    if GodModeEnabled then
        DisableGodMode()
    else
        EnableGodMode()
    end

end)

--//============================================================//
--// 🛡 ANTI RAGDOLL + ANTI KNOCKBACK
--//============================================================//

local AntiRagdollEnabled = false

local ANTI_RAGDOLL_DELAY = 0.01

local AntiRagdollConnections = {}
local AntiRagdollCharacter = nil

local function DisconnectAntiRagdoll()
    for _, Connection in ipairs(AntiRagdollConnections) do
        pcall(function()
            Connection:Disconnect()
        end)
    end

    table.clear(AntiRagdollConnections)
end

local function IsRagdollState(State)
    return State == Enum.HumanoidStateType.Physics
        or State == Enum.HumanoidStateType.Ragdoll
        or State == Enum.HumanoidStateType.FallingDown
        or State == Enum.HumanoidStateType.PlatformStanding
end

local function RestoreCharacter(Character)
    if not AntiRagdollEnabled then
        return
    end

    if not Character or not Character.Parent then
        return
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    if not Humanoid or not Root then
        return
    end

    if Humanoid.Health <= 0 then
        return
    end

    -- Restore Motor6D joints
    for _, Object in ipairs(Character:GetDescendants()) do
        if Object:IsA("Motor6D") then
            pcall(function()
                Object.Enabled = true
            end)
        end
    end

    -- Remove temporary ragdoll constraints.
    -- Only remove constraints that are inside a ragdoll-named
    -- object/folder so normal character constraints aren't touched.
    for _, Object in ipairs(Character:GetDescendants()) do

        if Object:IsA("BallSocketConstraint")
            or Object:IsA("HingeConstraint") then

            local Parent = Object.Parent

            if Parent
                and (
                    Parent.Name:lower():find("ragdoll")
                    or Object.Name:lower():find("ragdoll")
                )
            then
                pcall(function()
                    Object:Destroy()
                end)
            end
        end
    end

    -- Stop knockback and spinning
    pcall(function()
        Root.AssemblyLinearVelocity = Vector3.zero
        Root.AssemblyAngularVelocity = Vector3.zero
    end)

    -- Restore Humanoid
    pcall(function()
        Humanoid.PlatformStand = false
        Humanoid.AutoRotate = true
    end)

    -- Get back up
    pcall(function()
        Humanoid:ChangeState(
            Enum.HumanoidStateType.GettingUp
        )
    end)
end

local function SetupAntiRagdoll(Character)

    DisconnectAntiRagdoll()

    AntiRagdollCharacter = Character

    local Humanoid =
        Character:WaitForChild("Humanoid",10)

    local Root =
        Character:WaitForChild("HumanoidRootPart",10)

    if not Humanoid or not Root then
        return
    end

    -- Detect ragdoll immediately
    table.insert(
        AntiRagdollConnections,

        Humanoid.StateChanged:Connect(
            function(_,State)

                if not AntiRagdollEnabled then
                    return
                end

                if IsRagdollState(State) then

                    RestoreCharacter(Character)

                    -- Second recovery attempt after 0.01 sec
                    task.delay(
                        ANTI_RAGDOLL_DELAY,
                        function()

                            if AntiRagdollEnabled
                                and Character.Parent
                            then
                                RestoreCharacter(Character)
                            end

                        end
                    )
                end
            end
        )
    )

    -- Continuous protection
    table.insert(
        AntiRagdollConnections,

        RunService.Heartbeat:Connect(
            function()

                if not AntiRagdollEnabled then
                    return
                end

                if not Character.Parent then
                    return
                end

                if Humanoid.Health <= 0 then
                    return
                end

                local State =
                    Humanoid:GetState()

                if IsRagdollState(State) then
                    RestoreCharacter(Character)
                end

                -- Kill knockback
                pcall(function()
                    Root.AssemblyLinearVelocity =
                        Vector3.zero

                    Root.AssemblyAngularVelocity =
                        Vector3.zero
                end)

            end
        )
    )
end

local function EnableAntiRagdoll()

    AntiRagdollEnabled = true

    if Player.Character then
        task.spawn(function()
            SetupAntiRagdoll(Player.Character)
        end)
    end

    AntiRagdollButton.Text =
        "  ANTI RAGDOLL"

    AntiRagdollButton.TextColor3 =
        Color3.fromRGB(100,255,130)

    AntiRagdollButton.BackgroundColor3 =
        Color3.fromRGB(35,36,46)

    SetToggleVisual(
        AntiRagdollButton,
        true
    )

    StatusLabel.Text =
        "● ANTI RAGDOLL + KNOCKBACK ACTIVE"

    StatusLabel.TextColor3 =
        Color3.fromRGB(100,255,130)
end

local function DisableAntiRagdoll()

    AntiRagdollEnabled = false

    DisconnectAntiRagdoll()

    AntiRagdollCharacter = nil

    AntiRagdollButton.Text =
        "  ANTI RAGDOLL"

    AntiRagdollButton.TextColor3 =
        Color3.fromRGB(238,239,244)

    AntiRagdollButton.BackgroundColor3 =
        Color3.fromRGB(35,36,46)

    SetToggleVisual(
        AntiRagdollButton,
        false
    )

    StatusLabel.Text =
        "● SYSTEM ONLINE"

    StatusLabel.TextColor3 =
        Color3.fromRGB(100,255,130)
end

AntiRagdollButton.MouseButton1Click:Connect(
    function()

        if AntiRagdollEnabled then
            DisableAntiRagdoll()
        else
            EnableAntiRagdoll()
        end

    end
)

--//============================================================//
--// ADVANCED FLOAT
--//============================================================//

local FloatEnabled = false
local FloatHeight = 0.5
local FloatConnection = nil

local FLOAT_RAY_DISTANCE = 15
local FLOAT_STRENGTH = 8
local FLOAT_MAX_VERTICAL_SPEED = 15

local function StopFloat()

    if FloatConnection then
        FloatConnection:Disconnect()
        FloatConnection = nil
    end
end

local function FindGround(Character,Root)

    local Params = RaycastParams.new()

    Params.FilterType =
        Enum.RaycastFilterType.Exclude

    Params.FilterDescendantsInstances = {
        Character
    }

    Params.IgnoreWater = false

    return workspace:Raycast(
        Root.Position + Vector3.new(0,2,0),
        Vector3.new(0,-FLOAT_RAY_DISTANCE,0),
        Params
    )
end

local function StartFloat()

    StopFloat()

    FloatConnection =
        RunService.Heartbeat:Connect(function()

            if not FloatEnabled then
                return
            end

            local Character = Player.Character

            if not Character then
                return
            end

            local Humanoid =
                Character:FindFirstChildOfClass("Humanoid")

            local Root =
                Character:FindFirstChild("HumanoidRootPart")

            if not Humanoid or not Root then
                return
            end

            local Ground =
                FindGround(Character,Root)

            if not Ground then
                return
            end

            local RootHalfHeight =
                math.max(Root.Size.Y * 1,1)

            local TargetY =
                Ground.Position.Y +
                RootHalfHeight +
                FloatHeight

            local Difference =
                TargetY - Root.Position.Y

            local VerticalVelocity =
                math.clamp(
                    Difference * FLOAT_STRENGTH,
                    -FLOAT_MAX_VERTICAL_SPEED,
                    FLOAT_MAX_VERTICAL_SPEED
                )

            local CurrentVelocity =
                Root.AssemblyLinearVelocity

            Root.AssemblyLinearVelocity =
                Vector3.new(
                    CurrentVelocity.X,
                    VerticalVelocity,
                    CurrentVelocity.Z
                )

        end)
end

local function EnableFloat()

    FloatEnabled = true

    FloatButton.Text = "  FLOAT"
    FloatButton.TextColor3 =
        Color3.fromRGB(100,255,130)

    FloatButton.BackgroundColor3 =
        Color3.fromRGB(35,36,46)
    SetToggleVisual(FloatButton,true)

    StartFloat()
end

local function DisableFloat()

    FloatEnabled = false

    StopFloat()

    FloatButton.Text = "  FLOAT"
    FloatButton.TextColor3 =
        Color3.fromRGB(238,239,244)

    FloatButton.BackgroundColor3 =
        Color3.fromRGB(35,36,46)
    SetToggleVisual(FloatButton,false)
end

FloatButton.MouseButton1Click:Connect(function()

    if FloatEnabled then
        DisableFloat()
    else
        EnableFloat()
    end

end)

--//============================================================//
--// FPS BOOST — ONE-WAY / NO RESTORE
--//============================================================//

local FPSBoostEnabled = false

local RenderFolderNames = {
    ["ClientRenderedAssets"] = true,
    ["PlacedEggRenders"] = true,
    ["Stands"] = true,
    ["__ClientTreadmillRenders"] = true
}

local ObjectFolderNames = {
    ["AREAS"] = true,
    ["LEADERBOARDS"] = true,
    ["MACHINES"] = true
}

local function IsPlayerCharacter(Object)
    local Character = Player.Character

    if not Character then
        return false
    end

    return Object:IsDescendantOf(Character)
end

local function IsRenderFolder(Object)
    return Object
        and RenderFolderNames[Object.Name] == true
end

local function IsObjectFolder(Object)
    return Object
        and Object.Parent
        and Object.Parent.Name == "__OBJECTS"
        and ObjectFolderNames[Object.Name] == true
end

local function RemoveRenderFolder(Object)
    if not Object or not IsRenderFolder(Object) then
        return
    end

    pcall(function()
        Object:Destroy()
    end)
end

local function RemoveRenderFolders()
    for _,Object in ipairs(workspace:GetDescendants()) do
        if IsRenderFolder(Object) then
            RemoveRenderFolder(Object)
        end
    end
end

local function RemoveObjectFolder(Object)
    if not IsObjectFolder(Object) then
        return
    end

    pcall(function()
        Object:Destroy()
    end)
end

local function RemoveObjectFolders()
    local ObjectsFolder = workspace:FindFirstChild("__OBJECTS")

    if not ObjectsFolder then
        return
    end

    for _,Object in ipairs(ObjectsFolder:GetChildren()) do
        if ObjectFolderNames[Object.Name] then
            RemoveObjectFolder(Object)
        end
    end
end

--------------------------------------------------
--// PLOT OBJECTS THAT MUST STAY VISIBLE
--------------------------------------------------

local KeepPlotObjectsVisible = {
    ["TreadmillBottom"] = true,
    ["TreadmillUpgrade"] = true,
    ["PlotUpgrade"] = true,
    ["Multiplier"] = true
}

local function IsKeepPlotObject(Object)

    if not Object then
        return false
    end

    -- Object itself
    if KeepPlotObjectsVisible[Object.Name] then
        return true
    end

    -- Anything inside the protected object
    local Current = Object.Parent

    while Current and Current ~= workspace do

        if KeepPlotObjectsVisible[Current.Name] then
            return true
        end

        Current = Current.Parent
    end

    return false
end

local function RemoveVisualObject(Object)

    if not Object or IsPlayerCharacter(Object) then
        return
    end

    -- NEVER modify the important plot objects
    if IsKeepPlotObject(Object) then
        if Object:IsA("BasePart") then
            pcall(function()
                Object.LocalTransparencyModifier = 0
                Object.CastShadow = false
            end)
        end

        return
    end

    -- Remove heavy visual effects
    if Object:IsA("ParticleEmitter")
        or Object:IsA("Trail")
        or Object:IsA("Beam")
        or Object:IsA("Fire")
        or Object:IsA("Smoke")
        or Object:IsA("Sparkles")
        or Object:IsA("PostEffect")
        or Object:IsA("Decal")
        or Object:IsA("Texture")
        or Object:IsA("SurfaceAppearance")
    then

        pcall(function()
            Object:Destroy()
        end)

        return
    end

    -- Hide other unnecessary geometry
    if Object:IsA("BasePart") then
        pcall(function()
            Object.LocalTransparencyModifier = 1
            Object.CastShadow = false
            Object.Reflectance = 0
        end)
    end
end

local function ApplyFPSBoost()
    FPSBoostEnabled = true

    FPSBoostButton.Text = "  FPS BOOST"
    FPSBoostButton.TextColor3 =
        Color3.fromRGB(255,215,80)
    SetToggleVisual(FPSBoostButton,true)

    -- Aggressive local lighting reduction.
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.ShadowSoftness = 0
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.FogEnd = 1000000
    end)

    -- Delete known heavy render/object containers locally.
    RemoveRenderFolders()
    RemoveObjectFolders()

    -- Remove/hide everything that is safe to optimize locally.
    for _,Object in ipairs(workspace:GetDescendants()) do
        if IsRenderFolder(Object) then
            RemoveRenderFolder(Object)
        elseif IsObjectFolder(Object) then
            RemoveObjectFolder(Object)
        else
            RemoveVisualObject(Object)
        end
    end

    -- Also remove post-processing effects currently under Lighting.
    for _,Object in ipairs(Lighting:GetChildren()) do
        if Object:IsA("PostEffect") then
            pcall(function()
                Object:Destroy()
            end)
        end
    end

    StatusLabel.Text = "● FPS BOOST ACTIVE — NO RESTORE"
    StatusLabel.TextColor3 =
        Color3.fromRGB(100,255,130)
end

-- FPS Boost is intentionally one-way.
-- Clicking the button again only reapplies the boost.
FPSBoostButton.MouseButton1Click:Connect(function()
    ApplyFPSBoost()
end)

--//============================================================//
--// FPS BOOST — NEW OBJECT DETECTION
--//============================================================//

workspace.DescendantAdded:Connect(function(Object)
    if not FPSBoostEnabled then
        return
    end

    task.defer(function()
        if not FPSBoostEnabled or not Object.Parent then
            return
        end

        -- Check the object and its ancestors for known render containers.
        local Current = Object

        while Current and Current ~= workspace do
            if IsRenderFolder(Current) then
                RemoveRenderFolder(Current)
                return
            end

            if IsObjectFolder(Current) then
                RemoveObjectFolder(Current)
                return
            end

            Current = Current.Parent
        end

        RemoveVisualObject(Object)
    end)
end)

--//============================================================//
--// BAT AUTO
--//============================================================//

local BatAutoEnabled = false
local BatDetectionDistance = 1000
local BatCooldown = 0.01
local LastBatActivation = 0

local function GetBat()

    local Character = Player.Character

    if not Character then
        return nil
    end

    for _,Object in ipairs(Character:GetChildren()) do

        if Object:IsA("Tool")
            and string.lower(Object.Name):find("bat")
        then

            return Object

        end
    end

    local Backpack =
        Player:FindFirstChildOfClass("Backpack")

    if Backpack then

        for _,Object in ipairs(Backpack:GetChildren()) do

            if Object:IsA("Tool")
                and string.lower(Object.Name):find("bat")
            then

                return Object

            end
        end
    end

    return nil
end

local function EquipBat()

    local Character = Player.Character

    if not Character then
        return nil
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid then
        return nil
    end

    for _,Object in ipairs(Character:GetChildren()) do

        if Object:IsA("Tool")
            and string.lower(Object.Name):find("bat")
        then

            return Object

        end
    end

    local Backpack =
        Player:FindFirstChildOfClass("Backpack")

    if not Backpack then
        return nil
    end

    for _,Object in ipairs(Backpack:GetChildren()) do

        if Object:IsA("Tool")
            and string.lower(Object.Name):find("bat")
        then

            pcall(function()
                Humanoid:EquipTool(Object)
            end)

            return Object
        end
    end

    return nil
end

local function GetNearbyTarget()

    local Character = Player.Character

    if not Character then
        return nil
    end

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return nil
    end

    local ClosestTarget = nil
    local ClosestDistance = BatDetectionDistance

    for _,OtherPlayer in ipairs(Players:GetPlayers()) do

        if OtherPlayer ~= Player then

            local TargetCharacter =
                OtherPlayer.Character

            if TargetCharacter then

                local TargetHumanoid =
                    TargetCharacter:FindFirstChildOfClass(
                        "Humanoid"
                    )

                local TargetRoot =
                    TargetCharacter:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if TargetHumanoid
                    and TargetRoot
                    and TargetHumanoid.Health > 0
                then

                    local Distance =
                        (
                            Root.Position -
                            TargetRoot.Position
                        ).Magnitude

                    if Distance <= ClosestDistance then

                        ClosestDistance = Distance
                        ClosestTarget = TargetCharacter

                    end
                end
            end
        end
    end

    return ClosestTarget
end

local function ActivateBat()

    if not BatAutoEnabled then
        return
    end

    if os.clock() - LastBatActivation < BatCooldown then
        return
    end

    local Target = GetNearbyTarget()

    if not Target then
        return
    end

    local Bat = EquipBat()

    if not Bat then
        return
    end

    LastBatActivation = os.clock()

    pcall(function()
        Bat:Activate()
    end)

    StatusLabel.Text = "● Bat activated"
    StatusLabel.TextColor3 =
        Color3.fromRGB(100,255,130)
end

BatAutoButton.MouseButton1Click:Connect(function()

    BatAutoEnabled = not BatAutoEnabled

    if BatAutoEnabled then

        BatAutoButton.Text =
            "  BAT AUTO"

        BatAutoButton.TextColor3 =
            Color3.fromRGB(100,255,130)

        BatAutoButton.BackgroundColor3 =
            Color3.fromRGB(35,36,46)

        SetToggleVisual(BatAutoButton,true)

    else

        BatAutoButton.Text =
            "  BAT AUTO"

        BatAutoButton.TextColor3 =
            Color3.fromRGB(238,239,244)

        BatAutoButton.BackgroundColor3 =
            Color3.fromRGB(35,36,46)

        SetToggleVisual(BatAutoButton,false)

    end
end)

task.spawn(function()

    while ScreenGui.Parent do

        task.wait(0.01)

        if BatAutoEnabled then
            ActivateBat()
        end

    end
end)

--//============================================================//
--// BAT VISUAL
--//============================================================//

local BatVisualEnabled = false
local BatVisualIndex = 0
local BatVisualHandle = nil
local BatVisualWeld = nil

local BatVisualNames = {

    "Bat",
    "Desert Bat",
    "Snow Bat",
    "Jungle Bat",
    "Volcano Bat",
    "Lake Bat",
    "Cosmic Bat",
    "Prehistoric Bat",
    "Titan Axe",
    "Katana",
    "Flyswatter",
    "RainbowWrath",
    "Abyss Ocean Bat"

}

local function GetRealBat()

    local Character = Player.Character

    if not Character then
        return nil
    end

    local Bat =
        Character:FindFirstChild("Bat")

    if Bat and Bat:IsA("Tool") then
        return Bat
    end

    for _,Object in ipairs(Character:GetChildren()) do

        if Object:IsA("Tool")
            and string.find(
                string.lower(Object.Name),
                "bat"
            )
        then

            return Object

        end
    end

    return nil
end

local function ClearBatVisual()

    if BatVisualWeld then

        pcall(function()
            BatVisualWeld:Destroy()
        end)

        BatVisualWeld = nil
    end

    if BatVisualHandle then

        pcall(function()
            BatVisualHandle:Destroy()
        end)

        BatVisualHandle = nil
    end

    local RealBat = GetRealBat()

    if RealBat then

        local RealHandle =
            RealBat:FindFirstChild("Handle")

        if RealHandle
            and RealHandle:IsA("BasePart")
        then

            pcall(function()
                RealHandle.LocalTransparencyModifier = 0
            end)

        end
    end
end

local function ApplyBatVisual(BatName)

    ClearBatVisual()

    local RealBat = GetRealBat()

    if not RealBat then
        return false
    end

    local RealHandle =
        RealBat:FindFirstChild("Handle")

    if not RealHandle
        or not RealHandle:IsA("BasePart")
    then
        return false
    end

    local GearTools =
        ReplicatedStorage:FindFirstChild("GearTools")

    if not GearTools then
        return false
    end

    local ShopItems =
        GearTools:FindFirstChild("ShopItems")

    if not ShopItems then
        return false
    end

    local SourceBat =
        ShopItems:FindFirstChild(BatName)

    if not SourceBat then
        return false
    end

    local SourceHandle =
        SourceBat:FindFirstChild("Handle")

    if not SourceHandle
        or not SourceHandle:IsA("BasePart")
    then
        return false
    end

    local VisualHandle =
        SourceHandle:Clone()

    VisualHandle.Name =
        "KYOSH_BatVisual"

    VisualHandle.Anchored = false
    VisualHandle.CanCollide = false
    VisualHandle.CanTouch = false
    VisualHandle.CanQuery = false
    VisualHandle.Massless = true

    for _,Object in ipairs(
        VisualHandle:GetDescendants()
    ) do

        if Object:IsA("Sound")
            or Object:IsA("Script")
            or Object:IsA("LocalScript")
        then

            Object:Destroy()

        end
    end

    VisualHandle.CFrame =
        RealHandle.CFrame

    VisualHandle.Parent =
        RealBat

    local Weld =
        Instance.new("WeldConstraint")

    Weld.Name =
        "KYOSH_BatVisualWeld"

    Weld.Part0 =
        RealHandle

    Weld.Part1 =
        VisualHandle

    Weld.Parent =
        VisualHandle

    RealHandle.LocalTransparencyModifier = 1

    BatVisualHandle =
        VisualHandle

    BatVisualWeld =
        Weld

    StatusLabel.Text =
        "● BAT VISUAL: " .. BatName

    StatusLabel.TextColor3 =
        Color3.fromRGB(100,255,130)

    return true
end

local function SetBatVisual(Index)

    BatVisualIndex = Index

    if Index == 0 then

        BatVisualEnabled = false

        ClearBatVisual()

        BatVisualButton.Text =
            "  BAT VISUAL: OFF"

        return
    end

    BatVisualEnabled = true

    local BatName =
        BatVisualNames[Index]

    if not BatName then

        BatVisualIndex = 0
        BatVisualEnabled = false

        ClearBatVisual()

        BatVisualButton.Text =
            "  BAT VISUAL: OFF"

        return
    end

    local Success =
        ApplyBatVisual(BatName)

    if Success then

        BatVisualButton.Text =
            "  BAT: " .. BatName

    else

        BatVisualButton.Text =
            "  BAT VISUAL: " .. BatName

    end
end

BatVisualButton.MouseButton1Click:Connect(function()

    local NextIndex =
        BatVisualIndex + 1

    if NextIndex > #BatVisualNames then
        NextIndex = 0
    end

    SetBatVisual(NextIndex)

end)

--//============================================================//
--// AUTOMATIC COSMIC BAT RETRY
--//============================================================//

task.spawn(function()

    while ScreenGui.Parent do

        task.wait(0.75)

        if BatVisualEnabled
            and BatVisualIndex == 7
            and not BatVisualHandle
        then

            pcall(function()
                ApplyBatVisual("Cosmic Bat")
            end)

            BatVisualButton.Text =
                "  BAT: Cosmic Bat"

        end
    end
end)

--//============================================================//
--// FAR CAMERA
--//============================================================//

local FarCameraEnabled = false
local FarCameraDistance = 50
local FarCameraConnection = nil
local SavedMinZoomDistance = nil
local SavedMaxZoomDistance = nil

local function StartFarCamera()

    if FarCameraConnection then

        FarCameraConnection:Disconnect()
        FarCameraConnection = nil

    end

    local Camera =
        workspace.CurrentCamera

    if not Camera then
        return
    end

    SavedMinZoomDistance =
        Player.CameraMinZoomDistance

    SavedMaxZoomDistance =
        Player.CameraMaxZoomDistance

    Player.CameraMinZoomDistance =
        FarCameraDistance

    Player.CameraMaxZoomDistance =
        FarCameraDistance

    Player.CameraMode =
        Enum.CameraMode.Classic

    FarCameraConnection =
        RunService.RenderStepped:Connect(function()

            if not FarCameraEnabled then
                return
            end

            Player.CameraMode =
                Enum.CameraMode.Classic

            Player.CameraMinZoomDistance =
                FarCameraDistance

            Player.CameraMaxZoomDistance =
                FarCameraDistance

        end)
end

local function StopFarCamera()

    if FarCameraConnection then

        FarCameraConnection:Disconnect()
        FarCameraConnection = nil

    end

    if SavedMinZoomDistance ~= nil then

        Player.CameraMinZoomDistance =
            SavedMinZoomDistance

    end

    if SavedMaxZoomDistance ~= nil then

        Player.CameraMaxZoomDistance =
            SavedMaxZoomDistance

    end

    SavedMinZoomDistance = nil
    SavedMaxZoomDistance = nil
end

FarCameraButton.MouseButton1Click:Connect(function()

    FarCameraEnabled =
        not FarCameraEnabled

    if FarCameraEnabled then

        FarCameraButton.Text =
            "  FAR CAMERA"

        FarCameraButton.TextColor3 =
            Color3.fromRGB(100,255,130)

        FarCameraButton.BackgroundColor3 =
            Color3.fromRGB(35,36,46)

        SetToggleVisual(FarCameraButton,true)

        StartFarCamera()

    else

        FarCameraButton.Text =
            "  FAR CAMERA"

        FarCameraButton.TextColor3 =
            Color3.fromRGB(238,239,244)

        FarCameraButton.BackgroundColor3 =
            Color3.fromRGB(35,36,46)

        SetToggleVisual(FarCameraButton,false)

        StopFarCamera()

    end
end)

--//============================================================//
--// CHARACTER RESPAWN
--//============================================================//

Player.CharacterAdded:Connect(function(Character)

    task.wait(0.75)

    if GodModeEnabled then
        task.spawn(function()
            SetupGodCharacter(Character)
        end)
    else
        GodCharacter = Character
        GodHumanoid = nil
        GodRootPart = nil
        LastSafeCFrame = nil
    end

    if FloatEnabled then
        task.wait(0.15)
        StartFloat()
    end

    if FarCameraEnabled then
        task.wait(0.1)
        StartFarCamera()
    end

    if AntiRagdollEnabled then
        task.wait(0.1)
    task.spawn(function()
        SetupAntiRagdoll(Character)
        end)
    end

    if BatVisualEnabled
        and BatVisualIndex == 7
    then
        task.spawn(function()
            for i = 1,20 do
                if not ScreenGui.Parent then
                    break
                end

                if ApplyBatVisual("Cosmic Bat") then
                    BatVisualButton.Text =
                        "BAT: Cosmic Bat"
                    break
                end

                task.wait(0.5)
            end
        end)
    end
end)

--//============================================================//
--// GOD MODE SAFETY
--//============================================================//

task.spawn(function()

    while ScreenGui.Parent do

        task.wait(0.1)

        if GodModeEnabled then

            if not GodCharacter
                or not GodHumanoid
                or not GodRootPart
                or not GodCharacter.Parent
            then
                local Character = Player.Character
                if Character then
                    task.spawn(function()
                        SetupGodCharacter(Character)
                    end)
                end
            end

            if GodHumanoid and GodRootPart and GodCharacter and GodCharacter.Parent then

                if ProtectHealth and
                    GodHumanoid.Health < GodHumanoid.MaxHealth
                then
                    pcall(function()
                        GodHumanoid.Health = GodHumanoid.MaxHealth
                    end)
                end

                if ProtectDeath then
                    pcall(function()
                        GodHumanoid:SetStateEnabled(
                            Enum.HumanoidStateType.Dead,
                            false
                        )
                    end)
                end

                if ProtectRagdoll and GodHumanoid.PlatformStand then
                    pcall(function()
                        GodHumanoid.PlatformStand = false
                    end)
                end

                local State = GodHumanoid:GetState()

                if State ~= Enum.HumanoidStateType.Freefall
                    and State ~= Enum.HumanoidStateType.FallingDown
                    and State ~= Enum.HumanoidStateType.Ragdoll
                    and GodRootPart.Position.Y > FALL_LIMIT + 50
                then
                    LastSafeCFrame = GodRootPart.CFrame
                end

                if ProtectFall and
                    GodRootPart.Position.Y <= FALL_LIMIT and
                    LastSafeCFrame
                then
                    pcall(function()
                        GodRootPart.AssemblyLinearVelocity = Vector3.zero
                        GodRootPart.AssemblyAngularVelocity = Vector3.zero
                        GodRootPart.CFrame =
                            LastSafeCFrame + Vector3.new(0,RECOVERY_HEIGHT,0)
                    end)
                end
            end
        end
    end
end)

--//============================================================//
--// MOBILE UI
--// Minimize/restore is handled by MiniButton above.
--//============================================================//

--//============================================================//
--// FPS MONITOR
--//============================================================//

local Frames = 0
local LastTime = os.clock()

RunService.RenderStepped:Connect(function()

    Frames += 1

    local CurrentTime =
        os.clock()

    if CurrentTime - LastTime >= 1 then

        local FPS =
            math.floor(
                Frames /
                (CurrentTime - LastTime)
            )

        Frames = 0
        LastTime = CurrentTime

        FPSLabel.Text =
            "FPS: " .. FPS

        if FPS >= 55 then

            FPSLabel.TextColor3 =
                Color3.fromRGB(100,255,130)

        elseif FPS >= 30 then

            FPSLabel.TextColor3 =
                Color3.fromRGB(255,215,80)

        else

            FPSLabel.TextColor3 =
                Color3.fromRGB(255,80,80)

        end
    end
end)

--//============================================================//
--// PING MONITOR
--//============================================================//

task.spawn(function()

    while ScreenGui.Parent do

        task.wait(1)

        local Ping = 0

        pcall(function()

            Ping =
                math.floor(
                    Player:GetNetworkPing() * 1000
                )

        end)

        PingLabel.Text =
            "PING: " .. Ping .. " ms"

        if Ping <= 80 then

            PingLabel.TextColor3 =
                Color3.fromRGB(100,255,130)

        elseif Ping <= 150 then

            PingLabel.TextColor3 =
                Color3.fromRGB(255,215,80)

        else

            PingLabel.TextColor3 =
                Color3.fromRGB(255,80,80)

        end
    end
end)

--//============================================================//
--// ⭐ AUTO START
--//============================================================//

task.spawn(function()

    --// Make sure FPS page opens immediately
    HomePage.Visible = false
    FPSPage.Visible = true

    HomeButton.BackgroundColor3 =
        Color3.fromRGB(35,35,45)

    HomeButton.TextColor3 =
        Color3.fromRGB(170,170,180)

    FPSButton.BackgroundColor3 =
        Color3.fromRGB(255,195,60)

    FPSButton.TextColor3 =
        Color3.fromRGB(25,25,25)

    StatusLabel.Text =
        "● Starting all features..."

    StatusLabel.TextColor3 =
        Color3.fromRGB(255,215,80)

    --// GOD MODE
    task.wait(0.2)

    EnableGodMode()

    --// FPS BOOST
    task.wait(0.15)

    ApplyFPSBoost()

    --// FLOAT
    task.wait(0.15)

    EnableFloat()

    --// ANTI RAGDOLL
    task.wait(0.15)

    EnableAntiRagdoll()

    --// BAT AUTO
    task.wait(0.15)

    BatAutoEnabled = true

    BatAutoButton.Text =
        "  BAT AUTO"

    BatAutoButton.TextColor3 =
        Color3.fromRGB(100,255,130)

    BatAutoButton.BackgroundColor3 =
        Color3.fromRGB(35,36,46)

    SetToggleVisual(BatAutoButton,true)

    --// FAR CAMERA
    task.wait(0.15)

    FarCameraEnabled = true

    FarCameraButton.Text =
        "  FAR CAMERA"

    FarCameraButton.TextColor3 =
        Color3.fromRGB(100,255,130)

    FarCameraButton.BackgroundColor3 =
        Color3.fromRGB(35,36,46)

    SetToggleVisual(FarCameraButton,true)

    StartFarCamera()

    --// COSMIC BAT
    task.wait(0.15)

    BatVisualEnabled = true
    BatVisualIndex = 7

    BatVisualButton.Text =
        "  BAT: Cosmic Bat"

    --// Try immediately
    ApplyBatVisual("Cosmic Bat")

    --// Retry until the Bat exists
    task.spawn(function()

        for i = 1,30 do

            if not ScreenGui.Parent then
                break
            end

            if BatVisualHandle
                and BatVisualHandle.Parent
            then
                break
            end

            ApplyBatVisual("Cosmic Bat")

            task.wait(0.5)

        end

    end)

    --// ALL DONE
    task.wait(0.25)

    StatusLabel.Text =
        "● ALL FEATURES ENABLED • FPS BOOST NO RESTORE"

    StatusLabel.TextColor3 =
        Color3.fromRGB(100,255,130)

    print(
        "🥚 KYOSH [SAE] AUTO START COMPLETE"
    )

    print(
        "✓ GOD MODE"
    )

    print(
        "✓ FPS BOOST"
    )

    print(
        "✓ FLOAT"
    )



    print(
        "✓ BAT AUTO"
    )

    print(
        "✓ FAR CAMERA"
    )

    print(
        "✓ COSMIC BAT"
    )

end)

--//============================================================//
--// CLEANUP
--//============================================================//

ScreenGui.Destroying:Connect(function()

    FloatEnabled = false
    StopFloat()

    GodModeEnabled = false
    DisconnectGodConnections()

    BatAutoEnabled = false

    FarCameraEnabled = false
    StopFarCamera()

    BatVisualEnabled = false
    BatVisualIndex = 0

    ClearBatVisual()

    --// FIXED: GetRealBat() instead of undefined GetEquippedRealBat()
    local RealBat = GetRealBat()

    if RealBat then

        for _,Object in ipairs(
            RealBat:GetDescendants()
        ) do

            if Object:IsA("BasePart") then

                pcall(function()
                    Object.LocalTransparencyModifier = 0
                end)

            end
        end
    end
end)

--//============================================================//
--// LOADED
--//============================================================//

print(
    "🥚 EGG FPS MONITOR LOADED - FPS BOOST ACTIVE"
)

print(
    "🌌 COSMIC BAT SELECTED AUTOMATICALLY"
)
