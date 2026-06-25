local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ColorblindModule = require(ReplicatedStorage.AccessibilityModule.ColorblindModule)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create the settings menu
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AccessibilityMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0.5, -25)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "CB"
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.MontserratBold
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleButton

-- Main frame
local frame = Instance.new("Frame")
frame.Name = "SettingsFrame"
frame.Size = UDim2.new(0, 260, 0, 310)
frame.Position = UDim2.new(0, 80, 0.5, -155)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = screenGui

-- Round main frame
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Title text
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Color Blind Options"
title.Font = Enum.Font.MontserratBold
title.TextSize = 16
title.Parent = titleBar

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -20, 0, 30)
subtitle.Position = UDim2.new(0, 10, 0, 55)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitle.Text = "Select a colorblind filter:"
subtitle.Font = Enum.Font.MontserratBold
subtitle.TextSize = 13
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = frame

-- Button colors
local buttonColors = {
	None = Color3.fromRGB(70, 70, 80),
	Deuteranopia = Color3.fromRGB(180, 100, 40),
	Protanopia = Color3.fromRGB(60, 80, 180),
	Tritanopia = Color3.fromRGB(180, 60, 80),
}

local selectedMode = "None"
local filterStrength = 1.0
local buttons = {}

-- Slider label
local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(1, -20, 0, 25)
sliderLabel.Position = UDim2.new(0, 10, 0, 315)
sliderLabel.BackgroundTransparency = 1
sliderLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
sliderLabel.Text = "Filter Strength: 100%"
sliderLabel.Font = Enum.Font.MontserratBold
sliderLabel.TextSize = 13
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.Visible = false
sliderLabel.Parent = frame

-- Slider track
local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(0.88, 0, 0, 8)
sliderTrack.Position = UDim2.new(0.06, 0, 0, 350)
sliderTrack.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
sliderTrack.BorderSizePixel = 0
sliderTrack.Visible = false
sliderTrack.Parent = frame

local trackCorner = Instance.new("UICorner")
trackCorner.CornerRadius = UDim.new(1, 0)
trackCorner.Parent = sliderTrack

-- Slider fill
local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(1, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = sliderFill

-- Slider knob
local sliderKnob = Instance.new("TextButton")
sliderKnob.Size = UDim2.new(0, 20, 0, 20)
sliderKnob.Position = UDim2.new(1, -10, 0.5, -10)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.Text = ""
sliderKnob.BorderSizePixel = 0
sliderKnob.Parent = sliderTrack

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = sliderKnob

local modes = {"None", "Deuteranopia", "Protanopia", "Tritanopia"}

for i, mode in ipairs(modes) do
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.88, 0, 0, 45)
	button.Position = UDim2.new(0.06, 0, 0, 85 + (i - 1) * 54)
	button.BackgroundColor3 = buttonColors[mode]
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Text = mode
	button.Font = Enum.Font.MontserratBold
	button.TextSize = 14
	button.Parent = frame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = button

	buttons[mode] = button

	button.MouseButton1Click:Connect(function()
		selectedMode = mode
		ColorblindModule.applyFilter(mode, filterStrength)

		-- Show/hide slider and resize frame
		if mode == "None" then
			sliderLabel.Visible = false
			sliderTrack.Visible = false
			frame.Size = UDim2.new(0, 260, 0, 310)
		else
			sliderLabel.Visible = true
			sliderTrack.Visible = true
			frame.Size = UDim2.new(0, 260, 0, 375)
		end

		-- Highlight selected button
		for m, btn in pairs(buttons) do
			if m == mode then
				btn.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
			else
				btn.BackgroundColor3 = buttonColors[m]
			end
		end
	end)
end

-- Slider logic
local dragging = false

sliderKnob.MouseButton1Down:Connect(function()
	dragging = true
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if dragging then
		local mouseX = game:GetService("UserInputService"):GetMouseLocation().X
		local trackPos = sliderTrack.AbsolutePosition.X
		local trackWidth = sliderTrack.AbsoluteSize.X

		local relative = math.clamp((mouseX - trackPos) / trackWidth, 0, 1)
		filterStrength = relative

		sliderFill.Size = UDim2.new(relative, 0, 1, 0)
		sliderKnob.Position = UDim2.new(relative, -10, 0.5, -10)
		sliderLabel.Text = "Filter Strength: " .. math.round(relative * 100) .. "%"

		if selectedMode ~= "None" then
			ColorblindModule.applyFilter(selectedMode, filterStrength)
		end
	end
end)

-- Toggle panel visibility
local panelOpen = false
toggleButton.MouseButton1Click:Connect(function()
	panelOpen = not panelOpen
	frame.Visible = panelOpen
end)