local DataStoreService = game:GetService("DataStoreService")

local money = DataStoreService:GetDataStore("kewlmoney")
local loggedinfirsttime = DataStoreService:GetDataStore("firsttime")
local permbanned = DataStoreService:GetDataStore("banned")
local cooldowner = DataStoreService:GetDataStore("cooldown")
local badgehandler = DataStoreService:GetDataStore("badgehandler")
local localization = game:GetService("LocalizationService")

local bannedregions = {}--add banned regions
banlist = game.ServerScriptService.adminstuff.HallOfShame



game.Players.PlayerRemoving:Connect(function(plr)
	pcall(function()
	for _,v in pairs (game.ServerScriptService.playerdata:GetChildren()) do
			if v.Name == plr.Name..' money timer' then
				v:Destroy()
			end
			if v.Name == plr.Name..' on cooldown' then
				v:Destroy()
			end
		end
	end)
end)

game.Players.PlayerAdded:Connect(function(plr)
	--local DataStoreService = game:GetService("DataStoreService")
	--local m = DataStoreService:GetDataStore("kewlmoney") 
	--m:SetAsync(49112532,99999999)
	
	if permbanned:GetAsync(plr.UserId) == nil then
		wait()
	else
		plr:Kick("Perm banned")
	end
	
	for _, bannedPlayer in pairs(banlist:GetChildren()) do
		if bannedPlayer.Name == plr.Name then
			plr:Kick('Bruh, you have been BANNED xD')
		end
	end
	
	
	pcall(function()
	--if plr.AccountAge < 30 then
		--plr:Kick('Your account age is too young (under 30 days)')
	--end
	
	
		local region = localization:GetCountryRegionForPlayerAsync(plr)
		
		if table.find(bannedregions,region) then
			permbanned:SetAsync(plr.UserId,"banned")
			plr:Kick("Banned. From: "..region)
	
	end
	end)
	
	pcall(function()
	if (cooldowner:GetAsync(plr.UserId) ~= nil) then
		local coloner = game.ReplicatedStorage.votekickcool:Clone()
		coloner.Parent = game.ServerScriptService.playerdata
		coloner.Name = plr.Name..' on cooldown'
	end
	end)
	
	local success, errorMessage = pcall(function()
		loggedinfirsttime:GetAsync(plr.UserId)
	end)
	if success then
		
		if loggedinfirsttime:GetAsync(plr.UserId) == nil then --körs bara ifall det är en ny spelare
			money:SetAsync(plr.UserId, 50)
			loggedinfirsttime:SetAsync(plr.UserId,"Played before")
		end
		
		
		
		
		local stringvalue = Instance.new('StringValue')
		stringvalue.Parent = game.ServerScriptService.playerdata
		stringvalue.Name = plr.Name.." wallet"
		stringvalue.Value = money:GetAsync(plr.UserId)
		
		local timer = game.ReplicatedStorage.timuh
		timer = timer:Clone()
		timer.Parent = stringvalue
		
		
		print(money:GetAsync(plr.UserId))
		
	else
		print("error with database")
		plr:Kick('database error')
	end
end)
