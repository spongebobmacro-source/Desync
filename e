-- // Setup
local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")
local UI = LP:WaitForChild("PlayerGui")

-- // Cleanup
if UI:FindFirstChild("MutagenSimple") then UI.MutagenSimple:Destroy() end

-- // State
local Desync = false
local Animless = false
local Data = {}

-- // Screen Container
local SG = Instance.new("ScreenGui")
SG.Name = "MutagenSimple"
SG.ResetOnSpawn = false
SG.Parent = UI

-- // Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 200, 0, 150)
Main.Position = UDim2.new(0.5, -100, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true -- Delta Mobile Drag
Main.Parent = SG

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 255, 127)
Stroke.Thickness = 2
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "MUTAGEN ARCTIC"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Code
Title.TextSize = 16
Title.Parent = Main

-- // MINIMIZE BUTTON (Small floating toggle)
local Mini = Instance.new("TextButton")
Mini.Size = UDim2.new(0, 40, 0, 40)
Mini.Position = UDim2.new(0, 10, 0, 10) -- Top left of screen
Mini.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Mini.Text = "OPEN"
Mini.TextColor3 = Color3.fromRGB(0, 255, 127)
Mini.Parent = SG

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(0, 255, 127)
MiniStroke.Parent = Mini

Mini.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    Mini.Text = Main.Visible and "CLOSE" or "OPEN"
end)

-- // GHOST (5x5x5 Green, 55% Transparent)
local Ghost = Instance.new("Part")
Ghost.Size = Vector3.new(5, 5, 5)
Ghost.Color = Color3.fromRGB(0, 255, 127)
Ghost.Transparency = 0.55
Ghost.CanCollide = false
Ghost.Anchored = true
Ghost.Material = Enum.Material.ForceField

-- // BUTTON 1: DESYNC
local Btn1 = Instance.new("TextButton")
Btn1.Size = UDim2.new(0, 160, 0, 35)
Btn1.Position = UDim2.new(0, 20, 0, 45) -- Hard-coded position
Btn1.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Btn1.Text = "DESYNC: OFF"
Btn1.TextColor3 = Color3.white
Btn1.Font = Enum.Font.SourceSansBold
Btn1.Parent = Main

Btn1.MouseButton1Click:Connect(function()
    Desync = not Desync
    Btn1.Text = "DESYNC: " .. (Desync and "ON" or "OFF")
    Btn1.TextColor3 = Desync and Color3.fromRGB(0, 255, 127) or Color3.white
    Ghost.Parent = Desync and workspace or nil
end)

-- // BUTTON 2: ANIMLESS
local Btn2 = Instance.new("TextButton")
Btn2.Size = UDim2.new(0, 160, 0, 35)
Btn2.Position = UDim2.new(0, 20, 0, 95) -- Hard-coded position
Btn2.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Btn2.Text = "ANIMLESS: OFF"
Btn2.TextColor3 = Color3.white
Btn2.Font = Enum.Font.SourceSansBold
Btn2.Parent = Main

Btn2.MouseButton1Click:Connect(function()
    Animless = not Animless
    Btn2.Text = "ANIMLESS: " .. (Animless and "ON" or "OFF")
    Btn2.TextColor3 = Animless and Color3.fromRGB(0, 255, 127) or Color3.white
end)

-- // Logic Engine
RS.Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if Desync and hrp then
        Data[1] = hrp.CFrame
        Data[2] = hrp.AssemblyLinearVelocity
        Ghost.CFrame = hrp.CFrame

        -- P1000 Spoofing
        hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(math.random(180)), math.rad(math.random(180)), math.rad(math.random(180)))
        hrp.AssemblyLinearVelocity = Vector3.new(1, 1, 1) * 16384

        RS.RenderStepped:Wait()

        hrp.CFrame = Data[1]
        hrp.AssemblyLinearVelocity = Data[2]
    end

    if Animless and hum then
        for _, t in pairs(hum:GetPlayingAnimationTracks()) do t:Stop() end
    end
end)
