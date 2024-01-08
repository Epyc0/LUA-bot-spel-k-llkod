local votedkickplayer
local db = false
local DataStoreService = game:GetService("DataStoreService")
local cooldowner = DataStoreService:GetDataStore("cooldown")
local clientmessage = game.ReplicatedStorage.clientmessage
local message = "You are on a 5 minute cooldown."

function deleteplayergui()
	for _,v in pairs (game.Players:GetChildren()) do
		if v.PlayerGui:FindFirstChild("kickergui") then
			v.PlayerGui.kickergui:Destroy()
		end

	end
end


game.Players.PlayerAdded:Connect(function(plr)

	plr.Chatted:Connect(function(messagetoserver)

		
			local splitter = messagetoserver:split(' ')


			if splitter[1] == '!votekick' and db == false then
			local sa, response = pcall(function()
				if plr.Name ~= 'Microxite' then
					if (cooldowner:GetAsync(plr.UserId) ~= nil) then
						clientmessage:FireClient(plr,message)
						db = false
						return
					end		
				end

				db = true
				game.ServerScriptService.kickresults.alreadyvoted:Destroy()
				local newfolder = Instance.new("Folder")
				newfolder.Name = "alreadyvoted"

				newfolder.Parent = game.ServerScriptService.kickresults
				game.ServerScriptService.kickresults.votekickcountertotal.Value = 0
				game.ServerScriptService.kickresults.votekickcounteryes.Value = 0
				votedkickplayer = splitter[2]
				for _,v in pairs(game.Players:GetChildren()) do
					if v.Name:lower():sub(1,#votedkickplayer) == votedkickplayer:lower() or v.Name == votedkickplayer then
						votedkickplayer = v.Name
						local cooler = game.ReplicatedStorage.votekickcool:Clone()
						cooler.Name = plr.Name..' on cooldown'
						cooler.Parent = game.ServerScriptService.playerdata

						cooldowner:SetAsync(plr.UserId,"a")

						game.ServerScriptService.votekick.Value = votedkickplayer

					end
				end

				for _,v in pairs (game.Players:GetChildren()) do
					local kickers = game.ReplicatedStorage.kickergui:Clone()
					kickers.Parent = v.PlayerGui
				end
				
			end)
			if response then
				db = false
				print(response)
				game.ServerScriptService.votekick.Value = ''
				deleteplayergui()
			end
			end
			
			
			wait(10)

			deleteplayergui()
			local sa, response = pcall(function()
			if game.ServerScriptService.kickresults.votekickcountertotal.Value/1.5 <= game.ServerScriptService.kickresults.votekickcounteryes.Value then
				local explosion = Instance.new("Explosion")
				explosion.Position = game.Players[votedkickplayer].Character.Torso.Position
				explosion.Parent = game.Players[votedkickplayer].Character.Torso
				wait(.5)
				game.Players[votedkickplayer]:kick('voted out')

			end
			game.ServerScriptService.votekick.Value = ''
			db = false
			
			end)
			if response then
				db = false
			end

			


	end)

end)

