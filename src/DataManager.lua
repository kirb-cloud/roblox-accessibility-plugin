local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local dataStore = DataStoreService:GetDataStore("ColorblindPreferences")

local function saveData(player)
	local data = player:FindFirstChild("ColorblindData")
	if data then
		local mode = data:FindFirstChild("Mode") and data.Mode.Value or "None"
		local strength = data:FindFirstChild("Strength") and data.Strength.Value or 1.0
		print("Saving data for " .. player.Name .. ": " .. mode .. " " .. tostring(strength))
		local success, err = pcall(function()
			dataStore:SetAsync(tostring(player.UserId), {
				mode = mode,
				strength = strength
			})
		end)
		if success then
			print("Data saved successfully!")
		else
			warn("Failed to save: " .. err)
		end
	else
		warn("No ColorblindData found for " .. player.Name)
	end
end

local function loadData(player)
	local data = Instance.new("Folder")
	data.Name = "ColorblindData"
	data.Parent = player

	local mode = Instance.new("StringValue")
	mode.Name = "Mode"
	mode.Value = "None"
	mode.Parent = data

	local strength = Instance.new("NumberValue")
	strength.Name = "Strength"
	strength.Value = 1.0
	strength.Parent = data

	local success, saved = pcall(function()
		return dataStore:GetAsync(tostring(player.UserId))
	end)

	if success and saved then
		print("Loaded data for " .. player.Name .. ": " .. saved.mode .. " " .. tostring(saved.strength))
		mode.Value = saved.mode or "None"
		strength.Value = saved.strength or 1.0
	else
		print("No saved data found for " .. player.Name)
	end
end

Players.PlayerAdded:Connect(loadData)

Players.PlayerRemoving:Connect(function(player)
	saveData(player)
	task.wait(2)
end)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		saveData(player)
	end
	task.wait(3)
end)