-- // FORCE LOADER
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")

-- Ensure we have a place to put the UI
local TargetParent = LP:WaitForChild("PlayerGui")

-- Cleanup
if TargetParent:FindFirstChild("MutagenV1") then
    TargetParent.MutagenV1:Destroy()
end

-- // VARIABLES
local DesyncActive = false
local AnimlessActive = false
local DesyncTypes = {}

-- // UI SETUP
local SG = Instance.new("ScreenGui")
SG.Name = "MutagenV1"
SG.IgnoreGuiInset = true
SG.Parent = TargetParent

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 220, 0, 150)
Main.Position = UDim2.new(0.5, -110, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true -- Delta Mobile Support
Main.Parent = SG

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 255, 127) -- Arctic Green
Stroke.Thickness = 2
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "MUTAGEN ARCTIC V1"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Code
Title.TextSize = 18
Title.Parent = Main

-- // THE GHOST (55% Transparent, Green, 5x5x5, No Collide)
local Ghost = Instance.new("Part")
Ghost.Name = "DesyncGhost"
Ghost.Size = Vector3.new(5, 5, 5)
Ghost.Color = Color3.fromRGB(0, 255, 127)
Ghost.Transparency = 0.55
Ghost.CanCollide = false
Ghost.Anchored = true
Ghost.Material = Enum.Material.ForceField

-- // BUTTON CREATOR (With visual check)
local function CreateButton(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Button"
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Position = UDim2.new(0.1, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.white
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = Main
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(60, 60, 60)
    btnStroke.Parent = btn
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = name .. (active and ": ON" or ": OFF")
        btn.TextColor3 = active and Color3.fromRGB(0, 255, 127) or Color3.white
        btnStroke.Color = active and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(60, 60, 60)
        callback(active)
    end)
end

-- // CREATE THE 2 BUTTONS
CreateButton("DESYNC", 45, function(v) 
    DesyncActive = v 
    Ghost.Parent = v and workspace or nil
end)

CreateButton("ANIMLESS", 90, function(v) 
    AnimlessActive = v 
end)

-- // CORE LOGIC LOOP
RS.Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if DesyncActive and hrp then
        -- Desync logic from your P1000 source
        DesyncTypes[1] = hrp.CFrame
        DesyncTypes[2] = hrp.AssemblyLinearVelocity

        Ghost.CFrame = hrp.CFrame -- Show ghost where people think you are

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
