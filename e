-- // Safe Loader
if not game:IsLoaded() then game.Loaded:Wait() end
local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")

-- Cleanup
if LP.PlayerGui:FindFirstChild("MutagenArctic") then
    LP.PlayerGui.MutagenArctic:Destroy()
end

-- // Variables
local DesyncActive = false
local AnimlessActive = false
local DesyncTypes = {}

-- // UI Container
local SG = Instance.new("ScreenGui")
SG.Name = "MutagenArctic"
SG.Parent = LP:WaitForChild("PlayerGui")
SG.ResetOnSpawn = false

-- // Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 200, 0, 160)
Main.Position = UDim2.new(0.5, -100, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true 
Main.Parent = SG

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 255, 127)
Stroke.Thickness = 2
Stroke.Parent = Main

-- // Layout Manager (Ensures buttons appear)
local Layout = Instance.new("UIListLayout")
Layout.Parent = Main
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Padding = UDim.new(0, 10)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "MUTAGEN ARCTIC"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Code
Title.TextSize = 18
Title.LayoutOrder = 1
Title.Parent = Main

-- // Ghost Part (5x5x5 Green 55% Transparent)
local Ghost = Instance.new("Part")
Ghost.Size = Vector3.new(5, 5, 5)
Ghost.Color = Color3.fromRGB(0, 255, 127)
Ghost.Transparency = 0.55
Ghost.CanCollide = false
Ghost.Anchored = true
Ghost.Material = Enum.Material.ForceField

-- // Button Function
local function AddToggle(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 170, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.Text = text .. ": OFF"
    b.TextColor3 = Color3.white
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    b.LayoutOrder = 10 -- Forces them below Title
    b.Parent = Main
    
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(50, 50, 50)
    s.Parent = b
    
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = text .. (state and ": ON" or ": OFF")
        b.TextColor3 = state and Color3.fromRGB(0, 255, 127) or Color3.white
        s.Color = state and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(50, 50, 50)
        callback(state)
    end)
end

-- // Creating Buttons
AddToggle("DESYNC", function(v) 
    DesyncActive = v 
    if v then Ghost.Parent = workspace else Ghost.Parent = nil end
end)

AddToggle("ANIMLESS", function(v) 
    AnimlessActive = v 
end)

-- // Logic Loop
RS.Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if DesyncActive and hrp then
        DesyncTypes[1] = hrp.CFrame
        DesyncTypes[2] = hrp.AssemblyLinearVelocity
        Ghost.CFrame = hrp.CFrame

        hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(math.random(180)), math.rad(math.random(180)), math.rad(math.random(180)))
        hrp.AssemblyLinearVelocity = Vector3.new(1, 1, 1) * 16384

        RS.RenderStepped:Wait()

        hrp.CFrame = DesyncTypes[1]
        hrp.AssemblyLinearVelocity = DesyncTypes[2]
    end

    if AnimlessActive and hum then
        for _, track in pairs(hum:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end
end)
