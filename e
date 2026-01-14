-- // Prevent multiple loads
if game.Players.LocalPlayer.PlayerGui:FindFirstChild("MutagenCustom") then
    game.Players.LocalPlayer.PlayerGui.MutagenCustom:Destroy()
end

local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // Variables
local DesyncActive = false
local AnimlessActive = false
local DesyncTypes = {}

-- // UI Container
local SG = Instance.new("ScreenGui")
SG.Name = "MutagenCustom"
SG.Parent = LocalPlayer:WaitForChild("PlayerGui")
SG.ResetOnSpawn = false

-- // Floating Toggle Button (Because you are on Mobile)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenBtn.Text = "M"
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 127)
OpenBtn.Font = Enum.Font.Code
OpenBtn.Parent = SG

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(0, 255, 127)
BtnStroke.Parent = OpenBtn

-- // Main Panel
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 200, 0, 150)
Main.Position = UDim2.new(0.5, -100, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Visible = true
Main.Active = true
Main.Draggable = true -- Native Mobile Drag
Main.Parent = SG

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 255, 127)
MainStroke.Thickness = 2
MainStroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "MUTAGEN ARCTIC"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Code
Title.TextSize = 16
Title.Parent = Main

-- // Ghost Visual (55% Trans, Green, 5x5x5)
local Ghost = Instance.new("Part")
Ghost.Size = Vector3.new(5, 5, 5)
Ghost.Color = Color3.fromRGB(0, 255, 127)
Ghost.Transparency = 0.55
Ghost.CanCollide = false
Ghost.Anchored = true
Ghost.Material = Enum.Material.ForceField

-- // Button Logic
local function CreateButton(name, yPos, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.8, 0, 0, 35)
    b.Position = UDim2.new(0.1, 0, 0, yPos)
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    b.Text = name .. ": OFF"
    b.TextColor3 = Color3.white
    b.Font = Enum.Font.SourceSansBold
    b.Parent = Main
    
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(50, 50, 50)
    s.Parent = b
    
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = name .. (state and ": ON" or ": OFF")
        b.TextColor3 = state and Color3.fromRGB(0, 255, 127) or Color3.white
        s.Color = state and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(50, 50, 50)
        callback(state)
    end)
end

-- // Toggle UI Visibility
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- // Create Buttons
CreateButton("DESYNC", 45, function(v) 
    DesyncActive = v 
    Ghost.Parent = v and workspace or nil
end)

CreateButton("ANIMLESS", 90, function(v) 
    AnimlessActive = v 
end)

-- // Heartbeat Loop
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if DesyncActive and hrp then
        DesyncTypes[1] = hrp.CFrame
        DesyncTypes[2] = hrp.AssemblyLinearVelocity
        Ghost.CFrame = hrp.CFrame

        -- P1000 Desync Logic
        hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(math.random(180)), math.rad(math.random(180)), math.rad(math.random(180)))
        hrp.AssemblyLinearVelocity = Vector3.new(1, 1, 1) * 16384

        RunService.RenderStepped:Wait()

        hrp.CFrame = DesyncTypes[1]
        hrp.AssemblyLinearVelocity = DesyncTypes[2]
    end

    if AnimlessActive and hum then
        for _, track in pairs(hum:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end
end)
