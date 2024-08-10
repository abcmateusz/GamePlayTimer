# Game Time Save Script

## Description

This script allows you to save the playtime of each player in Roblox using DataStore. When a player joins the game, their playtime is retrieved from the DataStore and then updated every minute. When the player leaves the game, their playtime is saved back to the DataStore.

## Installation

1. Place the script in a `Script` object in Roblox Studio.
2. Ensure you have permission to use DataStore in your game.
3. The script will automatically create and update a `Time` value within the `leaderstats` folder for each player.

## How It Works

- When a player joins the game, a `leaderstats` folder is created, containing a `Time` value.
- The script retrieves the saved playtime from the DataStore using a unique player identifier (`Player[UserId]`).
- If data exists, it is assigned to the `Time` value; otherwise, the value is set to 0.
- The playtime is updated every minute.
- When a player leaves the game, their playtime is saved back to the DataStore.

## Features

- **Saving and Retrieving Data**: The script uses `DataStoreService` to save and retrieve the player's playtime.
- **Automatic Time Update**: The `Time` value within the `leaderstats` folder is automatically incremented every 60 seconds.

## Requirements

- Roblox Studio
- Permission to use DataStore in your game
- A `Script` object placed in `ServerScriptService`

## Example

Here is the script code that can be placed in Roblox Studio:

```lua
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
Author
abcMateusz
