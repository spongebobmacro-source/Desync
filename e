local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("RunService")

-- // Cleanup
if LP.PlayerGui:FindFirstChild("MutagenSimple") then LP.PlayerGui.MutagenSimple:Destroy() end

-- // State
local DesyncOn = false
local AnimlessOn = false
local TempData = {}

-- // UI Root
local SG = Instance.new("ScreenGui")
SG.Name = "MutagenSimple"
SG.Parent = LP:WaitForChild("PlayerGui")
SG.ResetOnSpawn = false

-- // MINIMIZE BUTTON (Top Left)
local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(0, 45, 0, 45)
MiniBtn.Position = UDim2.new(0, 10, 0, 10)
MiniBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MiniBtn.Text = "M"
MiniBtn.TextColor3 = Color3.fromRGB(0, 255, 127)
MiniBtn.Font = Enum.Font.Code
MiniBtn.Parent = SG

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(0, 255, 127)
MiniStroke.Parent = MiniBtn

-- // MAIN FRAME
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 180, 0, 130)
Main.Position = UDim2.new(0.5, -90, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Active = true
Main.Draggable = true 
Main.Parent = SG

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 255, 127)
MainStroke.Thickness = 2
MainStroke.Parent = Main

-- // BUTTON 1: DESYNC
local B1 = Instance.new("TextButton")
B1.Size = UDim2.new(0, 140, 0, 35)
B1.Position = UDim2.new(0, 20, 0, 20)
B1.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
B1.Text = "DESYNC: OFF"
B1.TextColor3 = Color3.white
B1.Parent = Main

-- // BUTTON 2: ANIMLESS
local B2 = Instance.new("TextButton")
B2.Size = UDim2.new(0, 140, 0, 35)
B2.Position = UDim2.new(0, 20, 0, 70)
B2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
B2.Text = "ANIMLESS: OFF"
B2.TextColor3 = Color3.white
B2.Parent = Main

-- // THE GHOST (5x5x5 Green, 55% Transparent)
local Ghost = Instance.new("Part")
Ghost.Size = Vector3.new(5, 5, 5)
Ghost.Color = Color3.fromRGB(0, 255, 127)
Ghost.Transparency = 0.55
Ghost.CanCollide = false
Ghost.Anchored = true
Ghost.Material = Enum.Material.ForceField

-- // UI ACTIONS
MiniBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

B1.MouseButton1Click:Connect(function()
    DesyncOn = not DesyncOn
    B1.Text = "DESYNC: " .. (DesyncOn and "ON" or "OFF")
    B1.TextColor3 = DesyncOn and Color3.fromRGB(0, 255, 127) or Color3.white
    Ghost.Parent = DesyncOn and workspace or nil
end)

B2.MouseButton1Click:Connect(function()
    AnimlessOn = not AnimlessOn
    B2.Text = "ANIMLESS: " .. (AnimlessOn and "ON" or "OFF")
    B2.TextColor3 = AnimlessOn and Color3.fromRGB(0, 255, 127) or Color3.white
end)

-- // LOGIC LOOP
RS.Heartbeat:Connect(function()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if DesyncOn and hrp then
        TempData[1] = hrp.CFrame
        TempData[2] = hrp.AssemblyLinearVelocity
        Ghost.CFrame = hrp.CFrame

        -- P1000 Desync
        hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(math.random(180)), math.rad(math.random(180)), math.rad(math.random(180)))
        hrp.AssemblyLinearVelocity = Vector3.new(1, 1, 1) * 16384

        RS.RenderStepped:Wait()

        hrp.CFrame = TempData[1]
        hrp.AssemblyLinearVelocity = TempData[2]
    end

    if AnimlessOn and hum then
        for _, t in pairs(hum:GetPlayingAnimationTracks()) do t:Stop() end
    end
end)
