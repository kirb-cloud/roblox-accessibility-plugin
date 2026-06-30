# CB Filter — Colorblind Accessibility Module for Roblox

A Roblox in-experience accessibility module that applies colorblind simulation filters to help players with color vision deficiencies enjoy games more comfortably.

---

## Motivation

I built this project to make gaming more accessible, productive, and enjoyable for players with color vision deficiencies. This was heavily motivated by my own experience as a Roblox player — I love the platform, but game creators often do not include accessibility settings, partly because Roblox Studio's built-in tools make it difficult to implement them without significant time and technical knowledge.

CB Filter aims to lower that barrier by giving any Roblox developer a ready-made accessibility module they can drop into their game with minimal setup, so players who need colorblind support do not have to go without it.

---

## Features

- 6 colorblind filter modes:
  - None — default, no filter
  - Deuteranopia — red-green color blindness (green deficiency)
  - Protanopia — red-green color blindness (red deficiency)
  - Tritanopia — blue-yellow color blindness
  - Achromatopsia — full color blindness (greyscale)
  - Anomalous Trichromacy — mild color deficiency
- Adjustable filter strength via vertical slider (0-100%)
- Persistent preferences — settings save on respawn via Roblox DataStore
- Clean, semi-transparent dark teal UI with rounded corners
- Toggle menu via a CB button on the left side of the screen

---

## How to Install

1. Open Roblox Studio
2. Copy the AccessibilityModule folder into your game's ReplicatedStorage
3. Copy AccessibilityClient into StarterPlayer > StarterPlayerScripts
4. Copy DataManager into ServerScriptService
5. Enable API Services under File > Game Settings > Security
6. Publish your game and play

---

## How to Use

1. Join the game
2. Click the CB button on the left side of the screen
3. Select a colorblind filter from the menu
4. Use the Strength slider to adjust the intensity
5. Your settings will be remembered on respawn

---

## How It Works

### ColorblindModule.lua

This module stores filter presets and applies them to the game's Lighting service.

```lua
local presets = {
	None = {
		TintColor = Color3.fromRGB(255, 255, 255),
		Contrast = 0,
		Saturation = 0,
		Brightness = 0
	},
	Deuteranopia = {
		TintColor = Color3.fromRGB(255, 230, 180),
		Contrast = 0.1,
		Saturation = -0.5,
		Brightness = 0.05
	},
	-- additional presets...
}
```

The applyFilter function takes a filter name and a strength value (0 to 1), removes any existing filter, then creates a new ColorCorrectionEffect. The strength value blends each property between full effect and neutral using Lerp:

```lua
function ColorblindModule.applyFilter(filterName, strength)
	local lighting = game:GetService("Lighting")
	strength = strength or 1.0

	local existing = lighting:FindFirstChild("AccessibilityFilter")
	if existing then existing:Destroy() end

	if filterName ~= "None" then
		local preset = presets[filterName]
		local correction = Instance.new("ColorCorrectionEffect")
		correction.Name = "AccessibilityFilter"
		correction.TintColor = preset.TintColor:Lerp(Color3.fromRGB(255, 255, 255), 1 - strength)
		correction.Contrast = preset.Contrast * strength
		correction.Saturation = preset.Saturation * strength
		correction.Brightness = preset.Brightness * strength
		correction.Parent = lighting
	end
end
```

### AccessibilityClient.lua

The slider tracks mouse position during a drag and converts it into a strength value:

```lua
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

		if selectedMode ~= "None" then
			ColorblindModule.applyFilter(selectedMode, filterStrength)
		end
	end
end)
```

Filter buttons are generated in a loop rather than created individually:

```lua
local modes = {"None", "Deuteranopia", "Protanopia", "Tritanopia", "Achromatopsia", "Anomalous"}

for i, mode in ipairs(modes) do
	local button = Instance.new("TextButton")
	button.Position = UDim2.new(0.06, 0, 0, 85 + (i - 1) * 54)
	button.Text = mode
	button.Parent = frame

	button.MouseButton1Click:Connect(function()
		selectedMode = mode
		ColorblindModule.applyFilter(mode, filterStrength)
		savedMode.Value = mode
	end)
end
```

### DataManager.lua

Player preferences are saved and loaded using DataStoreService, keyed by the player's UserId:

```lua
local function saveData(player)
	local data = player:FindFirstChild("ColorblindData")
	if data then
		local success, err = pcall(function()
			dataStore:SetAsync(tostring(player.UserId), {
				mode = data.Mode.Value,
				strength = data.Strength.Value
			})
		end)
	end
end

local function loadData(player)
	local data = Instance.new("Folder")
	data.Name = "ColorblindData"
	data.Parent = player

	local success, saved = pcall(function()
		return dataStore:GetAsync(tostring(player.UserId))
	end)

	if success and saved then
		-- apply saved values
	end
end

Players.PlayerAdded:Connect(loadData)
Players.PlayerRemoving:Connect(saveData)
```

---

## The Science Behind It

Color blindness affects approximately 8% of men and 0.5% of women worldwide. It is caused by missing or malfunctioning cone cells in the eye that detect red, green, or blue light.

This module simulates the visual experience of different types of color blindness using Roblox's ColorCorrectionEffect, adjusting:
- TintColor — shifts the overall color temperature
- Saturation — reduces color vividness
- Contrast — adjusts color distinction
- Brightness — compensates for perceived lightness changes

The color values are inspired by research from:
- Brettel, Vienot and Mollon (1997) — Computerized simulation of color appearance for dichromats
- Vienot, Brettel and Mollon (1999) — Digital video colourmaps for checking the legibility of displays by dichromats
- Machado, Oliveira and Fernandes (2009) — A Physiologically-based Model for Simulation of Color Vision Deficiency

---

## Known Limitations and Future Work

### Current Limitations
- Roblox's ColorCorrectionEffect does not support full RGB color transformation matrices, limiting simulation accuracy
- A truly accurate colorblind simulation requires per-pixel color transformation, for example Deuteranopia's transformation matrix is:
  - R' = 0.625R + 0.375G + 0.000B
  - G' = 0.700R + 0.300G + 0.000B
  - B' = 0.000R + 0.300G + 0.700B
- Settings currently only persist on respawn, not between separate game sessions

### Future Work
- Implement proper RGB transformation matrices via custom shaders when Roblox expands its PostEffect API
- Add full cross-session DataStore persistence
- Add texture pattern overlays as a secondary accessibility layer so color is not the only visual signal
- Publish to the Roblox Creator Marketplace for wider adoption

---

## References

- Brettel, H., Vienot, F., and Mollon, J. D. (1997). Computerized simulation of color appearance for dichromats. Journal of the Optical Society of America A, 14(10), 2647-2655.
- Machado, G. M., Oliveira, M. M., and Fernandes, L. A. (2009). A physiologically-based model for simulation of color vision deficiency. IEEE Transactions on Visualization and Computer Graphics, 15(6), 1291-1298.
- Coblis Color Blindness Simulator: https://www.color-blindness.com/coblis-color-blindness-simulator/

---

## Author

Made by kirb-cloud (https://github.com/kirb-cloud) as a CS accessibility project.