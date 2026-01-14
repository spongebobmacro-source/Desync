local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // Services & Variables
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local DesyncEnabled = false
local DesyncTypes = {}
local ToggleKey = "x"

-- // Desync Functions (From your source)
local function RandomNumberRange(a)
    return math.random(-a * 100, a * 100) / 100
end

-- // UI Window
local Window = Rayfield:CreateWindow({
   Name = "MUTAGEN Desync V1.0 | P1000",
   LoadingTitle = "Arctic Desync Suite",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = true, FolderName = "MutagenArctic" },
   KeySystem = false 
})

local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("P1000 Logic")

local DesyncToggle = MainTab:CreateToggle({
   Name = "Enable P1000 Desync",
   CurrentValue = false,
   Flag = "P1000Toggle", 
   Callback = function(Value)
      DesyncEnabled = Value
      print(DesyncEnabled and "Enabled P1000" or "Disabled P1000")
   end,
})

MainTab:CreateKeybind({
   Name = "Desync Keybind",
   CurrentKeybind = "X",
   HoldToInteract = false,
   Flag = "Keybind1",
   Callback = function(Keybind)
      DesyncEnabled = not DesyncEnabled
      DesyncToggle:Set(DesyncEnabled) -- Sync toggle with keybind
   end,
})

MainTab:CreateSection("Utilities")

MainTab:CreateButton({
   Name = "Rejoin / Server Reset (=)",
   Callback = function()
      game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
   end,
})

-- // THE CORE DESYNC ENGINE (Your Logic)
RunService.Heartbeat:Connect(function()
    if DesyncEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = LocalPlayer.Character.HumanoidRootPart
        
        DesyncTypes[1] = HRP.CFrame
        DesyncTypes[2] = HRP.AssemblyLinearVelocity

        local SpoofThis = HRP.CFrame
        SpoofThis = SpoofThis * CFrame.new(Vector3.new(0, 0, 0))
        SpoofThis = SpoofThis * CFrame.Angles(math.rad(RandomNumberRange(180)), math.rad(RandomNumberRange(180)), math.rad(RandomNumberRange(180)))

        HRP.CFrame = SpoofThis
        HRP.AssemblyLinearVelocity = Vector3.new(1, 1, 1) * 16384

        RunService.RenderStepped:Wait()

        HRP.CFrame = DesyncTypes[1]
        HRP.AssemblyLinearVelocity = DesyncTypes[2]
    end
end)

-- // Hook_CFrame (Prevents client-side glitching)
local XDDDDDD = nil
XDDDDDD = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if DesyncEnabled and not checkcaller() then
        if key == "CFrame" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if self == LocalPlayer.Character.HumanoidRootPart then
                return DesyncTypes[1] or CFrame.new()
            elseif self == LocalPlayer.Character:FindFirstChild("Head") then
                return DesyncTypes[1] and DesyncTypes[1] + Vector3.new(0, LocalPlayer.Character.HumanoidRootPart.Size.Y / 2 + 0.5, 0) or CFrame.new()
            end
        end
    end
    return XDDDDDD(self, key)
end))

Rayfield:LoadConfiguration()
