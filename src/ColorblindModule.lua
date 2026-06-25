local ColorblindModule = {}

-- Color correction settings for each colorblind type
local presets = {
	None = {
		TintColor = Color3.fromRGB(255, 255, 255),
		Contrast = 0,
		Saturation = 0,
		Brightness = 0
	},
	Deuteranopia = { -- red-green (most common)
		TintColor = Color3.fromRGB(255, 230, 180),
		Contrast = 0.1,
		Saturation = -0.5,
		Brightness = 0.05
	},
	Protanopia = { -- red deficiency
		TintColor = Color3.fromRGB(220, 220, 255),
		Contrast = 0.1,
		Saturation = -0.4,
		Brightness = 0.05
	},
	Tritanopia = { -- blue-yellow
		TintColor = Color3.fromRGB(255, 220, 220),
		Contrast = 0.05,
		Saturation = -0.3,
		Brightness = 0
	}
}

function ColorblindModule.applyFilter(filterName)
	local lighting = game:GetService("Lighting")
	
	-- Remove existing filter if any
	local existing = lighting:FindFirstChild("AccessibilityFilter")
	if existing then existing:Destroy() end

	-- Apply new filter
	if filterName ~= "None" then
		local correction = Instance.new("ColorCorrectionEffect")
		correction.Name = "AccessibilityFilter"
		correction.TintColor = presets[filterName].TintColor
		correction.Contrast = presets[filterName].Contrast
		correction.Saturation = presets[filterName].Saturation
		correction.Brightness = presets[filterName].Brightness
		correction.Parent = lighting
	end
end

function ColorblindModule.getPresets()
	return presets
end

return ColorblindModule