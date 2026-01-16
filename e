--[[
    ARCTIC DESYNC V2
    Developed and Owned by Arctic
    Strictly for private use.
]]

local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local Workspace = game:GetService('Workspace')
local LocalPlayer = game:GetService('Players').LocalPlayer

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild('Humanoid')
local HumanoidRootPart = Character:WaitForChild('HumanoidRootPart')
local CurrentCamera = Workspace.CurrentCamera

-- Arctic Color Palette
local bgColor = Color3.fromRGB(15, 15, 20)
local frameColor = Color3.fromRGB(25, 30, 40)
local accentColor = Color3.fromRGB(160, 210, 255) -- Arctic Blue
local accentDark = Color3.fromRGB(100, 150, 200)
local textColor = Color3.fromRGB(255, 255, 255)
local textDim = Color3.fromRGB(180, 180, 190)
local successColor = Color3.fromRGB(100, 255, 150)

local ScreenGui = Instance.new('ScreenGui')
ScreenGui.Name = "Arctic_Core"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService('CoreGui'):FindFirstChild("RobloxGui") or game:GetService('Players').LocalPlayer.PlayerGui

local MainFrame = Instance.new('Frame')
MainFrame.Name = 'ArcticMain'
MainFrame.BackgroundColor3 = bgColor
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
MainFrame.Size = UDim2.new(0, 450, 0, 400)
MainFrame.ZIndex = 9000
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new('UICorner')
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new('UIStroke')
MainStroke.Name = 'ArcticStroke'
MainStroke.Color = accentColor
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

-- Branding Header
local HeaderFrame = Instance.new('Frame')
HeaderFrame.Name = 'Header'
HeaderFrame.BackgroundColor3 = frameColor
HeaderFrame.BorderSizePixel = 0
HeaderFrame.Size = UDim2.new(1, 0, 0, 60)
HeaderFrame.ZIndex = 9001
HeaderFrame.Parent = MainFrame

local HeaderCorner = Instance.new('UICorner')
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = HeaderFrame

local TitleLabel = Instance.new('TextLabel')
TitleLabel.Name = 'ArcticTitle'
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 15, 0, 10)
TitleLabel.Size = UDim2.new(0, 200, 0, 24)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = 'ARCTIC DESYNC'
TitleLabel.TextColor3 = accentColor
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 9002
TitleLabel.Parent = HeaderFrame

local VersionLabel = Instance.new('TextLabel')
VersionLabel.Name = 'ArcticVersion'
VersionLabel.BackgroundTransparency = 1
VersionLabel.Position = UDim2.new(0, 15, 0, 36)
VersionLabel.Size = UDim2.new(0, 200, 0, 16)
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.Text = 'v2.0.1 | Arctic Private Edition'
VersionLabel.TextColor3 = textDim
VersionLabel.TextSize = 10
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.ZIndex = 9002
VersionLabel.Parent = HeaderFrame

local SyncStatusFrame = Instance.new('Frame')
SyncStatusFrame.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
SyncStatusFrame.Position = UDim2.new(1, -155, 0.5, -16)
SyncStatusFrame.Size = UDim2.new(0, 95, 0, 32)
SyncStatusFrame.ZIndex = 9002
SyncStatusFrame.Parent = HeaderFrame

local SyncCorner = Instance.new('UICorner')
SyncCorner.CornerRadius = UDim.new(0, 8)
SyncCorner.Parent = SyncStatusFrame

local StatusLabel = Instance.new('TextLabel')
StatusLabel.BackgroundTransparency = 1
StatusLabel.Size = UDim2.new(1, 0, 1, 0)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = 'STANDBY'
StatusLabel.TextColor3 = textColor
StatusLabel.TextSize = 11
StatusLabel.ZIndex = 9003
StatusLabel.Parent = SyncStatusFrame

local CloseButton = Instance.new('TextButton')
CloseButton.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
CloseButton.Position = UDim2.new(1, -45, 0.5, -16)
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = 'X'
CloseButton.TextColor3 = textColor
CloseButton.TextSize = 14
CloseButton.ZIndex = 9003
CloseButton.AutoButtonColor = false
CloseButton.Parent = HeaderFrame

local CloseCorner = Instance.new('UICorner')
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Logic Hooks
local originalCFrame = nil

local function Notify(title, desc)
    local Notification = Instance.new('Frame')
    Notification.BackgroundColor3 = bgColor
    Notification.Position = UDim2.new(1, 20, 0.95, 0)
    Notification.Size = UDim2.new(0, 280, 0, 70)
    Notification.AnchorPoint = Vector2.new(0, 1)
    Notification.ZIndex = 10000
    Notification.Parent = ScreenGui

    local NotifCorner = Instance.new('UICorner')
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = Notification

    local NotifStroke = Instance.new('UIStroke')
    NotifStroke.Color = accentColor
    NotifStroke.Thickness = 2
    NotifStroke.Parent = Notification

    local T = Instance.new("TextLabel")
    T.Text = title:upper()
    T.Font = Enum.Font.GothamBold
    T.TextColor3 = accentColor
    T.Position = UDim2.new(0,10,0,10)
    T.Size = UDim2.new(1,-20,0,20)
    T.BackgroundTransparency = 1
    T.TextXAlignment = "Left"
    T.Parent = Notification

    local D = Instance.new("TextLabel")
    D.Text = desc
    D.Font = Enum.Font.Gotham
    D.TextColor3 = textDim
    D.Position = UDim2.new(0,10,0,30)
    D.Size = UDim2.new(1,-20,0,30)
    D.BackgroundTransparency = 1
    D.TextXAlignment = "Left"
    D.TextWrapped = true
    D.TextSize = 11
    D.Parent = Notification

    TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(1, -300, 0.95, 0)}):Play()
    task.delay(3, function()
        TweenService:Create(Notification, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Position = UDim2.new(1, 20, 0.95, 0)}):Play()
        task.wait(0.4)
        Notification:Destroy()
    end)
end

-- Core Interaction
local ContentFrame = Instance.new('Frame')
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 15, 0, 75)
ContentFrame.Size = UDim2.new(1, -30, 1, -90)
ContentFrame.ZIndex = 9001
ContentFrame.Parent = MainFrame

local DesyncToggle = Instance.new('TextButton')
DesyncToggle.Size = UDim2.new(1, 0, 0, 50)
DesyncToggle.BackgroundColor3 = frameColor
DesyncToggle.Text = "ENABLE ARCTIC DESYNC"
DesyncToggle.Font = Enum.Font.GothamBold
DesyncToggle.TextColor3 = textColor
DesyncToggle.TextSize = 14
DesyncToggle.Parent = ContentFrame

local DCorner = Instance.new("UICorner")
DCorner.CornerRadius = UDim.new(0,8)
DCorner.Parent = DesyncToggle

DesyncToggle.MouseButton1Click:Connect(function()
    originalCFrame = HumanoidRootPart.CFrame
    local dummyPart = Instance.new('Part', Workspace)
    dummyPart.Size = Vector3.new(2, 2, 2)
    dummyPart.Transparency = 1
    dummyPart.CanCollide = false
    dummyPart.Anchored = true
    dummyPart.CFrame = HumanoidRootPart.CFrame

    RunService.RenderStepped:Connect(function() dummyPart.CFrame = HumanoidRootPart.CFrame end)
    CurrentCamera.CameraSubject = dummyPart

    HumanoidRootPart:SetNetworkOwner(nil)

    RunService.Heartbeat:Connect(function()
        HumanoidRootPart.CFrame = originalCFrame
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        RunService.RenderStepped:Wait()
    end)

    StatusLabel.Text = 'DESYNCED'
    StatusLabel.TextColor3 = successColor
    Notify("Arctic Desync", "Desync successfully activated. Character position locked.")
end)

CloseButton.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Initial Startup Animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 450, 0, 400), Position = UDim2.new(0.5, -225, 0.5, -200)}):Play()
