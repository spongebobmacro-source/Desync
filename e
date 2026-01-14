-- [[ CUSTOM ARCTIC UI - P1000 + ANIMLESS ]] --

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variables
local DesyncEnabled = false
local AnimlessEnabled = false
local DesyncTypes = {}

-- [[ UI CONSTRUCTION ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArcticCustom"
ScreenGui.Parent = (gethui and gethui()) or game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 180)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 127)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "MUTAGEN V1.0"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Code
Title.Parent = MainFrame

-- [[ VISUAL GHOST SETUP ]] --
local Ghost = Instance.new("Part")
Ghost.Name = "DesyncGhost"
Ghost.Size = Vector3.new(5, 5, 5)
Ghost.Color = Color3.fromRGB(0, 255, 127)
Ghost.Transparency = 0.55
Ghost.CanCollide = false
Ghost.Anchored = true
Ghost.Material = Enum.Material.ForceField
Ghost.Parent = workspace
Ghost.Position = Vector3.new(0, -100, 0) -- Hide initially

-- [[ TOGGLE COMPONENT FUNCTION ]] --
local function CreateToggle(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = name .. ": [OFF]"
    btn.TextColor3 = Color3.white
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = MainFrame
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = name .. (active and ": [ON]" or ": [OFF]")
        btn.TextColor3 = active and Color3.fromRGB(0, 255, 127) or Color3.white
        callback(active)
    end)
end

-- [[ BUTTON ACTIONS ]] --
CreateToggle("DESYNC", UDim2.new(0.05, 0, 0.25, 0), function(val)
    DesyncEnabled = val
    if not val then Ghost.Position = Vector3.new(0, -100, 0) end
end)

CreateToggle("ANIMLESS", UDim2.new(0.05, 0, 0.55, 0), function(val)
    AnimlessEnabled = val
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then
        for _, track in pairs(hum:GetPlayingAnimationTracks()) do
            if AnimlessEnabled then track:Stop() else track:Play() end
        end
    end
end)

-- [[ MINIMIZE FOR PHONE ]] --
local Mini = Instance.new("TextButton")
Mini.Size = UDim2.new(0, 30, 0, 30)
Mini.Position = UDim2.new(1, -30, 0, 0)
Mini.Text = "-"
Mini.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Mini.TextColor3 = Color3.white
Mini.Parent = MainFrame

local minimized = false
Mini.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame:TweenSize(minimized and UDim2.new(0, 200, 0, 30) or UDim2.new(0, 200, 0, 180), "Out", "Quad", 0.2, true)
end)

-- [[ DRAG LOGIC ]] --
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) dragging = false end)

-- [[ ENGINE ]] --
RunService.Heartbeat:Connect(function()
    if DesyncEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = LocalPlayer.Character.HumanoidRootPart
        
        DesyncTypes[1] = HRP.CFrame
        DesyncTypes[2] = HRP.AssemblyLinearVelocity

        -- Show where people see you
        Ghost.CFrame = HRP.CFrame * CFrame.new(0, 0, 2) -- Offset visual slightly

        -- P1000 Method
        HRP.CFrame = HRP.CFrame * CFrame.Angles(math.rad(math.random(180)), math.rad(math.random(180)), math.rad(math.random(180)))
        HRP.AssemblyLinearVelocity = Vector3.new(1, 1, 1) * 16384

        RunService.RenderStepped:Wait()

        HRP.CFrame = DesyncTypes[1]
        HRP.AssemblyLinearVelocity = DesyncTypes[2]
    end
    
    if AnimlessEnabled and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            for _, v in pairs(hum:GetPlayingAnimationTracks()) do v:Stop() end
        end
    end
end)
