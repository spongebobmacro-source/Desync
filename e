local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // Variables
local DesyncActive = false
local AnimlessActive = false
local DesyncTypes = {}

-- // Ghost Part (5x5x5, 55% Transparent, Green)
local Ghost = Instance.new("Part")
Ghost.Name = "DesyncGhost"
Ghost.Size = Vector3.new(5, 5, 5)
Ghost.Color = Color3.fromRGB(0, 255, 127)
Ghost.Transparency = 0.55
Ghost.CanCollide = false
Ghost.Anchored = true
Ghost.Material = Enum.Material.ForceField

-- // UI Window
local Window = Rayfield:CreateWindow({
   Name = "MUTAGEN ARCTIC V1.0",
   LoadingTitle = "Mutagen Hub",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MutagenArctic",
      FileName = "Config"
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("P1000 Logic")

-- // Desync Toggle
MainTab:CreateToggle({
   Name = "Enable Desync",
   CurrentValue = false,
   Flag = "DesyncToggle", 
   Callback = function(Value)
      DesyncActive = Value
      if Value then
         Ghost.Parent = workspace
      else
         Ghost.Parent = nil
      end
   end,
})

-- // Animless Toggle
MainTab:CreateToggle({
   Name = "Animless (Freeze)",
   CurrentValue = false,
   Flag = "AnimlessToggle", 
   Callback = function(Value)
      AnimlessActive = Value
   end,
})

MainTab:CreateSection("Utilities")

MainTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
      game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
   end,
})

-- // Core Desync & Animless Loop
game:GetService("RunService").Heartbeat:Connect(function()
    local LP = game:GetService("Players").LocalPlayer
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if DesyncActive and hrp then
        -- Save actual pos
        DesyncTypes[1] = hrp.CFrame
        DesyncTypes[2] = hrp.AssemblyLinearVelocity

        -- Update Ghost position
        Ghost.CFrame = hrp.CFrame

        -- P1000 Spoofing (Hitbox trick)
        hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(math.random(180)), math.rad(math.random(180)), math.rad(math.random(180)))
        hrp.AssemblyLinearVelocity = Vector3.new(1, 1, 1) * 16384

        game:GetService("RunService").RenderStepped:Wait()

        -- Restore for local view
        hrp.CFrame = DesyncTypes[1]
        hrp.AssemblyLinearVelocity = DesyncTypes[2]
    end

    if AnimlessActive and hum then
        for _, track in pairs(hum:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end
end)

Rayfield:LoadConfiguration()
