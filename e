local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Variables
local DesyncActive = false
local AnimlessActive = false
local DesyncTypes = {}

-- [[ THE GHOST (55% Transparent, Green, 5x5x5, No Collide) ]] --
local Ghost = Instance.new("Part")
Ghost.Name = "DesyncGhost"
Ghost.Size = Vector3.new(5, 5, 5)
Ghost.Color = Color3.fromRGB(0, 255, 127) -- Arctic Green
Ghost.Transparency = 0.55
Ghost.CanCollide = false
Ghost.Anchored = true
Ghost.Material = Enum.Material.ForceField

-- [[ UI WINDOW ]] --
local Window = OrionLib:MakeWindow({
    Name = "MUTAGEN ARCTIC V1.0", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "MutagenArctic",
    IntroEnabled = true,
    IntroText = "Mutagen Arctic Loading..."
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

MainTab:AddSection({
    Name = "Desync & Hitbox"
})

-- [[ DESYNC TOGGLE ]] --
MainTab:AddToggle({
    Name = "Enable P1000 Desync",
    Default = false,
    Callback = function(Value)
        DesyncActive = Value
        if Value then
            Ghost.Parent = workspace
            OrionLib:MakeNotification({
                Name = "Mutagen",
                Content = "Desync Activated",
                Image = "rbxassetid://4483362458",
                Time = 2
            })
        else
            Ghost.Parent = nil
        end
    end    
})

-- [[ ANIMLESS TOGGLE ]] --
MainTab:AddToggle({
    Name = "Animless (Freeze Animations)",
    Default = false,
    Callback = function(Value)
        AnimlessActive = Value
    end    
})

MainTab:AddSection({
    Name = "Misc"
})

MainTab:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
    end
})

-- [[ CORE ENGINE LOOP ]] --
game:GetService("RunService").Heartbeat:Connect(function()
    local LP = game:GetService("Players").LocalPlayer
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if DesyncActive and hrp then
        -- Desync logic from your source
        DesyncTypes[1] = hrp.CFrame
        DesyncTypes[2] = hrp.AssemblyLinearVelocity

        Ghost.CFrame = hrp.CFrame -- Show ghost where server thinks you are

        -- P1000 Method: Spams angles and velocity
        hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(math.random(180)), math.rad(math.random(180)), math.rad(math.random(180)))
        hrp.AssemblyLinearVelocity = Vector3.new(1, 1, 1) * 16384

        game:GetService("RunService").RenderStepped:Wait()

        -- Snap back for your screen
        hrp.CFrame = DesyncTypes[1]
        hrp.AssemblyLinearVelocity = DesyncTypes[2]
    end

    if AnimlessActive and hum then
        for _, track in pairs(hum:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end
end)

OrionLib:Init()
