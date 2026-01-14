-- Safe Loader for Delta
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
repeat task.wait() until LP:FindFirstChild("PlayerGui")

-- Variables
local DesyncActive = false
local AnimlessActive = false
local DesyncTypes = {}

-- Cleanup
if LP.PlayerGui:FindFirstChild("MutagenUI") then
    LP.PlayerGui.MutagenUI:Destroy()
end

-- UI Setup
local SG = Instance.new("ScreenGui")
SG.Name = "MutagenUI"
SG.ResetOnSpawn = false
SG.Parent = LP.PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 200, 0, 150)
Main.Position = UDim2.new(0.5, -100, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true -- Mobile drag enabled
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
Title.Parent = Main

-- Ghost Part (55% Transparent, Green, 5x5x5, No Collision)
local Ghost = Instance.new("Part")
Ghost.Size = Vector3.new(5, 5, 5)
Ghost.Color = Color3.fromRGB(0, 255, 127)
Ghost.Transparency = 0.55
Ghost.CanCollide = false
Ghost.Anchored = true
Ghost.Material = Enum.Material.ForceField

-- Button Creator
local function MakeBtn(text, pos, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.8, 0, 0, 35)
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.Text = text .. ": OFF"
    b.TextColor3 = Color3.white
    b.Font = Enum.Font.SourceSansBold
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

-- Create The 2 Buttons
MakeBtn("DESYNC", UDim2.new(0.1, 0, 0.3, 0), function(v) 
    DesyncActive = v 
    Ghost.Parent = v and workspace or nil
end)

MakeBtn("ANIMLESS", UDim2.new(0.1, 0, 0.65, 0), function(v) 
    AnimlessActive = v 
end)

-- Main Logic Loop
game:GetService("RunService").Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if DesyncActive and hrp then
        -- Save original state
        DesyncTypes[1] = hrp.CFrame
        DesyncTypes[2] = hrp.AssemblyLinearVelocity

        -- Ghost Visualization
        Ghost.CFrame = hrp.CFrame

        -- P1000 Spoofing
        hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(math.random(180)), math.rad(math.random(180)), math.rad(math.random(180)))
        hrp.AssemblyLinearVelocity = Vector3.new(1, 1, 1) * 16384

        game:GetService("RunService").RenderStepped:Wait()

        -- Revert for Client view
        hrp.CFrame = DesyncTypes[1]
        hrp.AssemblyLinearVelocity = DesyncTypes[2]
    end

    if AnimlessActive and hum then
        for _, track in pairs(hum:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end
end)
