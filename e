-- [[ MUTAGEN ARCTIC V1.0 - RAYFIELD LOADSTRING ]] --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MUTAGEN Desync V1.0",
   LoadingTitle = "Arctic Desync Loaded",
   LoadingSubtitle = "by Gemini AI",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MutagenConfigs",
      FileName = "Settings"
   },
   KeySystem = false
})

-- Variables
local DesyncEnabled = false
local DesyncVelocity = 500

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

local Section = MainTab:CreateSection("Desync Settings")

local Toggle = MainTab:CreateToggle({
   Name = "Enable Desync (Other players see ghost)",
   CurrentValue = false,
   Flag = "DesyncToggle", 
   Callback = function(Value)
      DesyncEnabled = Value
   end,
})

local Slider = MainTab:CreateSlider({
   Name = "Desync Multiplier",
   Range = {0, 5000},
   Increment = 100,
   Suffix = "Velocity",
   CurrentValue = 500,
   Flag = "VelSlider",
   Callback = function(Value)
      DesyncVelocity = Value
   end,
})

local Utils = MainTab:CreateSection("Utilities")

local Respawn = MainTab:CreateButton({
   Name = "Fast Respawn",
   Callback = function()
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("Humanoid") then
         char.Humanoid.Health = 0
      end
   end,
})

-- [[ THE DESYNC ENGINE ]] --
-- This handles the "Position you are" vs "Position people think you are"
game:GetService("RunService").Heartbeat:Connect(function()
    if DesyncEnabled then
        local char = game.Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Store current real velocity
            local oldVel = hrp.Velocity
            
            -- Inject massive velocity to break server-side interpolation
            hrp.Velocity = Vector3.new(DesyncVelocity, DesyncVelocity, DesyncVelocity)
            
            -- Wait for a physics frame then revert (Ghosting effect)
            game:GetService("RunService").RenderStepped:Wait()
            hrp.Velocity = oldVel
        end
    end
end)

Rayfield:Notify({
   Title = "Script Active",
   Content = "Mutagen Arctic is ready. Use the toggle to start desyncing.",
   Duration = 5,
   Image = 4483362458,
})
