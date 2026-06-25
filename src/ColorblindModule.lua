local ColorblindModule = {}

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
	Protanopia = {
		TintColor = Color3.fromRGB(220, 220, 255),
		Contrast = 0.1,
		Saturation = -0.4,
		Brightness = 0.05
	},
	Tritanopia = {
		TintColor = Color3.fromRGB(255, 220, 220),
		Contrast = 0.05,
		Saturation = -0.3,
		Brightness = 0
	},
	Achromatopsia = {
		TintColor = Color3.fromRGB(255, 255, 255),
		Contrast = 0.1,
		Saturation = -1,
		Brightness = 0
	},
	Anomalous = {
		TintColor = Color3.fromRGB(255, 240, 200),
		Contrast = 0.05,
		Saturation = -0.2,
		Brightness = 0.02
	}
}

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

function ColorblindModule.getPresets()
	return presets
end

return ColorblindModule