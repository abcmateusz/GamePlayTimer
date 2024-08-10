local DataStoreService = game:GetService("DataStoreService")
local myDataStore = DataStoreService:GetDataStore("myDataStore")

game.Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local Time = Instance.new("IntValue")
	Time.Name = "Time"
	Time.Parent = leaderstats

	local playerId = "Player" .. player.UserId

	local data
	local success, errorMessage = pcall(function()
		data = myDataStore:GetAsync(playerId)
	end)

	if success then
		if data then
			Time.Value = data
		else
			Time.Value = 0
		end
	else
		warn("Failed to retrieve data: " .. errorMessage)
	end

	spawn(function()
		while wait(60) do
			if player and player.leaderstats and player.leaderstats.Time then
				player.leaderstats.Time.Value = player.leaderstats.Time.Value + 1
			end
		end
	end)
end)

game.Players.PlayerRemoving:Connect(function(player)
	local playerId = "Player" .. player.UserId
	local data = player.leaderstats.Time.Value

	local success, errorMessage = pcall(function()
		myDataStore:SetAsync(playerId, data)
	end)

	if not success then
		warn("Failed to save data: " .. errorMessage)
	end
end)
