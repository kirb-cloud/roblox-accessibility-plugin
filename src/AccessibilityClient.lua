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
frame.Size = UDim2.new(0, 260, 0, 320)
frame.Position = UDim2.new(0, 80, 0.5, -160)
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
local buttons = {}

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
		ColorblindModule.applyFilter(mode)
		selectedMode = mode

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

-- Toggle panel visibility
local panelOpen = false
toggleButton.MouseButton1Click:Connect(function()
	panelOpen = not panelOpen
	frame.Visible = panelOpen
end)