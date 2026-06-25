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

-- Main frame
local frame = Instance.new("Frame")
frame.Name = "SettingsFrame"
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0, 20, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Accessibility Settings"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

-- Buttons for each mode
local modes = {"None", "Deuteranopia", "Protanopia", "Tritanopia"}

for i, mode in ipairs(modes) do
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.9, 0, 0, 45)
	button.Position = UDim2.new(0.05, 0, 0, 40 + (i - 1) * 55)
	button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Text = mode
	button.Font = Enum.Font.Gotham
	button.TextSize = 14
	button.Parent = frame

	button.MouseButton1Click:Connect(function()
		ColorblindModule.applyFilter(mode)
	end)
end