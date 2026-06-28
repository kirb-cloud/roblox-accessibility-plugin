local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local ColorblindModule = require(ReplicatedStorage.AccessibilityModule.ColorblindModule)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for saved data from server
local colorblindData = player:WaitForChild("ColorblindData")
local savedMode = colorblindData:WaitForChild("Mode")
local savedStrength = colorblindData:WaitForChild("Strength")

-- Create the settings menu
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AccessibilityMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0.5, -25)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 136)
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
frame.Size = UDim2.new(0, 260, 0, 420)
frame.Position = UDim2.new(0, 80, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(15, 35, 40)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 150, 136)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Color Blind Options"
title.Font = Enum.Font.MontserratBold
title.TextSize = 16
title.Parent = titleBar

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -20, 0, 30)
subtitle.Position = UDim2.new(0, 10, 0, 55)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.fromRGB(150, 200, 195)
subtitle.Text = "Select a colorblind filter:"
subtitle.Font = Enum.Font.MontserratBold
subtitle.TextSize = 13
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = frame

-- Slider panel
local sliderPanel = Instance.new("Frame")
sliderPanel.Size = UDim2.new(0, 160, 0, 420)
sliderPanel.Position = UDim2.new(1, 10, 0, 0)
sliderPanel.BackgroundColor3 = Color3.fromRGB(15, 35, 40)
sliderPanel.BackgroundTransparency = 0.3
sliderPanel.BorderSizePixel = 0
sliderPanel.Visible = false
sliderPanel.Parent = frame

local sliderPanelCorner = Instance.new("UICorner")
sliderPanelCorner.CornerRadius = UDim.new(0, 12)
sliderPanelCorner.Parent = sliderPanel

-- Slider panel title bar
local sliderTitleBar = Instance.new("Frame")
sliderTitleBar.Size = UDim2.new(1, 0, 0, 50)
sliderTitleBar.BackgroundColor3 = Color3.fromRGB(0, 150, 136)
sliderTitleBar.BorderSizePixel = 0
sliderTitleBar.Parent = sliderPanel

local sliderTitleCorner = Instance.new("UICorner")
sliderTitleCorner.CornerRadius = UDim.new(0, 12)
sliderTitleCorner.Parent = sliderTitleBar

local sliderTitle = Instance.new("TextLabel")
sliderTitle.Size = UDim2.new(1, 0, 1, 0)
sliderTitle.BackgroundTransparency = 1
sliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderTitle.Text = "Strength"
sliderTitle.Font = Enum.Font.MontserratBold
sliderTitle.TextSize = 14
sliderTitle.Parent = sliderTitleBar

-- Slider label
local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(1, -10, 0, 25)
sliderLabel.Position = UDim2.new(0, 10, 0, 70)
sliderLabel.BackgroundTransparency = 1
sliderLabel.TextColor3 = Color3.fromRGB(150, 200, 195)
sliderLabel.Text = "100%"
sliderLabel.Font = Enum.Font.MontserratBold
sliderLabel.TextSize = 20
sliderLabel.TextXAlignment = Enum.TextXAlignment.Center
sliderLabel.Parent = sliderPanel

-- Slider track
local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(0, 8, 0.6, 0)
sliderTrack.Position = UDim2.new(0.5, -4, 0, 110)
sliderTrack.BackgroundColor3 = Color3.fromRGB(30, 70, 75)
sliderTrack.BorderSizePixel = 0
sliderTrack.Parent = sliderPanel

local trackCorner = Instance.new("UICorner")
trackCorner.CornerRadius = UDim.new(1, 0)
trackCorner.Parent = sliderTrack

-- Slider fill
local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(1, 0, 1, 0)
sliderFill.AnchorPoint = Vector2.new(0, 1)
sliderFill.Position = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 180)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = sliderFill

-- Slider knob
local sliderKnob = Instance.new("TextButton")
sliderKnob.Size = UDim2.new(0, 20, 0, 20)
sliderKnob.Position = UDim2.new(0.5, -10, 0, -10)
sliderKnob.BackgroundColor3 = Color3.fromRGB(0, 200, 180)
sliderKnob.Text = ""
sliderKnob.BorderSizePixel = 0
sliderKnob.Parent = sliderTrack

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = sliderKnob

-- Button colors
local buttonColors = {
	None = Color3.fromRGB(30, 70, 75),
	Deuteranopia = Color3.fromRGB(180, 100, 40),
	Protanopia = Color3.fromRGB(40, 80, 160),
	Tritanopia = Color3.fromRGB(160, 50, 70),
	Achromatopsia = Color3.fromRGB(60, 60, 70),
	Anomalous = Color3.fromRGB(140, 90, 40),
}

local selectedMode = savedMode.Value
local filterStrength = savedStrength.Value
local buttons = {}

local modes = {"None", "Deuteranopia", "Protanopia", "Tritanopia", "Achromatopsia", "Anomalous"}

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
		filterStrength = filterStrength
		ColorblindModule.applyFilter(mode, filterStrength)

		-- Save to server
		savedMode.Value = mode
		savedStrength.Value = filterStrength

		if mode == "None" then
			sliderPanel.Visible = false
		else
			sliderPanel.Visible = true
		end

		for m, btn in pairs(buttons) do
			if m == mode then
				btn.BackgroundColor3 = Color3.fromRGB(0, 200, 180)
			else
				btn.BackgroundColor3 = buttonColors[m]
			end
		end
	end)
end

-- Apply saved filter on load
if selectedMode ~= "None" then
	ColorblindModule.applyFilter(selectedMode, filterStrength)
	sliderPanel.Visible = true
	sliderLabel.Text = math.round(filterStrength * 100) .. "%"
	sliderFill.Size = UDim2.new(1, 0, filterStrength, 0)
	sliderKnob.Position = UDim2.new(0.5, -10, 1 - filterStrength, -10)
	if buttons[selectedMode] then
		buttons[selectedMode].BackgroundColor3 = Color3.fromRGB(0, 200, 180)
	end
end

-- Slider logic
local dragging = false

sliderKnob.MouseButton1Down:Connect(function()
	dragging = true
end)

sliderTrack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

RunService.RenderStepped:Connect(function()
	if dragging then
		local mouseY = UserInputService:GetMouseLocation().Y
		local inset = GuiService:GetGuiInset().Y
		local trackPos = sliderTrack.AbsolutePosition.Y + inset
		local trackHeight = sliderTrack.AbsoluteSize.Y

		local relative = math.clamp((mouseY - trackPos) / trackHeight, 0, 1)
		filterStrength = 1 - relative

		sliderFill.Size = UDim2.new(1, 0, filterStrength, 0)
		sliderKnob.Position = UDim2.new(0.5, -10, relative, -10)
		sliderLabel.Text = math.round(filterStrength * 100) .. "%"

		-- Save strength to server
		savedStrength.Value = filterStrength

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
	if not panelOpen then
		sliderPanel.Visible = false
	end
end)