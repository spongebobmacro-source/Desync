local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Create ScreenGui
local ArcticGui = Instance.new("ScreenGui")
ArcticGui.Name = "ArcticDesync"
ArcticGui.Parent = CoreGui
ArcticGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 1. THE TOGGLE CIRCLE (Ice Emoji)
local ToggleButton = Instance.new("Frame")
local IceLabel = Instance.new("TextLabel")
local UICorner_Toggle = Instance.new("UICorner")

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ArcticGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(240, 248, 255) -- AliceBlue
ToggleButton.Position = UDim2.new(0.1, 0, 0.2, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Active = true

UICorner_Toggle.CornerRadius = UDim.new(1, 0)
UICorner_Toggle.Parent = ToggleButton

IceLabel.Parent = ToggleButton
IceLabel.BackgroundTransparency = 1
IceLabel.Size = UDim2.new(1, 0, 1, 0)
IceLabel.Text = "❄️"
IceLabel.TextSize = 30

-- 2. THE MAIN PANEL (Arctic Design)
local MainFrame = Instance.new("Frame")
local UICorner_Main = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local Status = Instance.new("TextLabel")
local ExecuteBtn = Instance.new("TextButton")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ArcticGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Visible = false
MainFrame.ClipsDescendants = true

UICorner_Main.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ARCTIC DESYNC"
Title.TextColor3 = Color3.fromRGB(150, 200, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

ExecuteBtn.Parent = MainFrame
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(245, 250, 255)
ExecuteBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
ExecuteBtn.Size = UDim2.new(0.8, 0, 0, 40)
ExecuteBtn.Text = "Initialize Desync"
ExecuteBtn.Font = Enum.Font.Gotham
ExecuteBtn.TextColor3 = Color3.fromRGB(100, 100, 100)

-- 3. MOBILE DRAG SYSTEM
local function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

makeDraggable(ToggleButton)
makeDraggable(MainFrame)

-- 4. TOGGLE LOGIC
local isOpen = false
ToggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isOpen = not isOpen
		MainFrame.Visible = isOpen
		-- Simple Arctic animation
		MainFrame.Size = UDim2.new(0, 0, 0, 0)
		TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.QuadOut), {Size = UDim2.new(0, 200, 0, 150)}):Play()
	end
end)

-- 5. DESYNC INTEGRATION
ExecuteBtn.MouseButton1Click:Connect(function()
	ExecuteBtn.Text = "❄️ ACTIVE"
	-- THE OBFUSCATED CODE GOES HERE
	-- (Paste your long return(function(...) script below)
	print("Desync Loaded via Arctic GUI")
end)
