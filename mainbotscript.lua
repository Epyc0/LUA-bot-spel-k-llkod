local HTTP = game:GetService("HttpService")
local textSrv = game:GetService("TextService")
local badgeserv = game:GetService('BadgeService')
local url = "https://api.openai.com/v1/chat/completions" 
local headers = { 
	["Authorization"] = "Bearer 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",
}
local webhook = "https://webhook.lewisakura.moe/api/webhooks/592661736708898826/HFW27qS0HRux1oUNx5Mbqi3OQe1apivHsWkQXQKwjbm9hTyGxwarVNtcpo25akeEWdhQ"
local HTTP = game:GetService("HttpService")
local previousmessage = " "
local previousswitcher = 0
local tokensize
local cooldowntimer = game.ReplicatedStorage.msgcooldown
local moverdb = game.ServerScriptService.Values.moverdebounce
local msgdb = false
local badges = {
	2152565418,
	2152565430,
	2152565443,
	2152565458,
}

local faces = {
	7221082667,
	
}

local DataStoreService = game:GetService("DataStoreService")
local badgehandler = DataStoreService:GetDataStore("badgehandler")

local givefoodremote = game.ReplicatedStorage.GiveFood

local imporantplayers = {
	'Microxite',
	'JamieTheConqueror'
}


botname = workspace.Rig
local partilcler = botname.Head.ParticleEmitter
local botface = botname.Head.Decal

jumpanim = botname.Jump
jump = botname.Humanoid:LoadAnimation(jumpanim)

idleanim = botname.Idle
idle = botname.Humanoid:LoadAnimation(idleanim)


dancenaim = botname.Dance
dance = botname.Humanoid:LoadAnimation(dancenaim)

sitanim = botname.SitAnim
sit = botname.Humanoid:LoadAnimation(sitanim)

huganim = botname.Hug
hug = botname.Humanoid:LoadAnimation(huganim)

msgdb = false
fooddb = false
tajmer = game.ServerScriptService.Values.timer

idle:Play()

messagetoserver = ""

function createparticleeffect()
	partilcler.Enabled = true
	wait(3)
	partilcler.Enabled = false
end

function facechanger()
	botface.Texture = 'http://www.roblox.com/asset/?id='..faces[0]
end

givefoodremote.OnServerEvent:Connect(function(_,plr,foodname)
	
	
	if fooddb == false then
	fooddb = true
	moverdb.Value = true

	local founditem = false
	for _,v in pairs(plr.Character:GetChildren()) do
		if v == foodname then
			founditem = true
			foodname:Destroy()
			break
		end	
	end
	
	if founditem == false then
		moverdb.Value = false

		return
	end
	
	local foodmessagetobot = "ddHere is some tasty "..foodname.Name.. " for you"
	messagetoserver = foodmessagetobot
	tokensize = 49
	
	sendmessagetoserver(plr,messagetoserver,tokensize)
	createparticleeffect()
	fooddb=false
	moverdb.Value = false

	else
		if msgdb == false then
		msgdb = true
		local message = 'One at a time.'
		game.ReplicatedStorage.clientmessage:FireClient(plr,message) 
		end
		msgdb = false
	end
end)


function notopenaicommands(plr,messagetoserver)
	if messagetoserver == 'follow me' and game.ServerScriptService.Values.Value.Value == '' then
		moverdb.Value = true
		tajmer.Value = 0
		local chatgptmessage = 'I will follow you, '..plr.Name..'!'
		idle:Stop()
		local chat = game:GetService("Chat")
		chat:Chat(workspace.Rig.Head, chatgptmessage, "Red")
		game.ServerScriptService.Values.Value.Value = plr.Name
	end


	if messagetoserver == 'stop following' and plr.Name == game.ServerScriptService.Values.Value.Value then
		moverdb.Value = false

		game.ServerScriptService.Values.Value.Value = ''
		local chatgptmessage = 'As you wish, I will stop following you, '..plr.Name..'!'
		local chat = game:GetService("Chat")
		chat:Chat(workspace.Rig.Head, chatgptmessage, "Red")
		idle:Play()
	end

	if messagetoserver == 'dance' and game.ServerScriptService.Values.Value.Value == '' then
		moverdb.Value = true
		workspace.Rig.Humanoid.Sit = false
		idle:Stop()
		sit:Stop()
		dance:Play()

	end

	if messagetoserver == 'undance' and game.ServerScriptService.Values.Value.Value == '' then
		dance:Stop()
		idle:Play()
		moverdb.Value = false
	end

end

function sendmessagetoserver(plr,messagetoserver)
	msgdb = true
	messagetoserver = string.sub(messagetoserver,3)	
	
	local body = HTTP:JSONEncode({ messages
		model = "gpt-3.5-turbo",
		max_tokens = tokensize,
		messages = {
			{
				role = "user",
				content = "last message: "..previousmessage
			},
			{
				role = "user",
				content = 'Respond to me like a teenager friend, be realistic: ' .. messagetoserver,
			}

		}})



	local sa, response = pcall(function()
		return HTTP:PostAsync(url, body, Enum.HttpContentType.ApplicationJson, nil, headers)
	end) 		

	local decoded = HTTP:JSONDecode(response) 
	local chatgptmessage = decoded["choices"][1]["message"]["content"]


	if string.find(chatgptmessage,"teenage") or string.find(chatgptmessage,"answer like a") then
		chatgptmessage = "Write a normal sentence for godssake"
	end

	local yes,ok = pcall(function()
		badgehandler:IncrementAsync(plr.UserId,1)
		print(chatgptmessage)


		if badgehandler:GetAsync(plr.UserId) > 0 then
			badgeserv:AwardBadge(plr.UserId,badges[1])
		end
		if badgehandler:GetAsync(plr.UserId) > 10 then
			badgeserv:AwardBadge(plr.UserId,badges[2])
		end
		if badgehandler:GetAsync(plr.UserId) > 50 then
			badgeserv:AwardBadge(plr.UserId,badges[3])
		end



	end)

	previousmessage = messagetoserver --lagrar meddelandet f r att botten ska veta vad de snackade om

	chatgptmessage = plr.Name .. ', ' .. chatgptmessage


	local payloadplayer = HTTP:JSONEncode({
		content = messagetoserver,
		username = plr.Name.." - (#"..plr.UserId..")"
	})
	local payloadbot = HTTP:JSONEncode({
		content = chatgptmessage,
		username = "bot"
	})


	local worksfine,error = pcall(function()
		HTTP:PostAsync(webhook, payloadplayer)
		HTTP:PostAsync(webhook, payloadbot)
	end)

	if not worksfine then
		print(error)
	end



	local chat = game:GetService("Chat")
	chat:Chat(workspace.Rig.Head, chatgptmessage, "Red")
	game.ReplicatedStorage.SystemMessage:FireAllClients(_,chatgptmessage)
	msgdb = false
end


game.Players.PlayerAdded:Connect(function(plr)

	
	plr.Chatted:Connect(function(messagetoserver)

		
		pcall(function()
		botname = workspace.Rig
		end)	
		if moverdb.Value == false and msgdb == false then
			moverdb.Value = true

			if table.find(imporantplayers,plr.Name) then
				tokensize = 200
				
			else if game.PrivateServerId ~= "" then
					tokensize = 110
				else
					tokensize = 50
				end
			end
			
			pcall(function()
			messagetoserver = textSrv:FilterStringAsync(messagetoserver,plr.UserId):GetChatForUserAsync(plr.UserId)
			end)
			
			if (string.sub(messagetoserver,1,2)) == 'ai' and botname.Humanoid.Health ~= 0 and messagetoserver ~= " " and messagetoserver ~= "" then
				
				for _,v in pairs(game.ServerScriptService.playerdata:GetChildren()) do
					 if v.Name == plr.Name.. ' msgcooldown' then
							local message = v.Value .. ' Seconds cooldown'
							game.ReplicatedStorage.clientmessage:FireClient(plr,message)
						moverdb.Value = false
						return
					end
				end
					
					
					local cloner = game.ReplicatedStorage.msgcooldown:Clone()
					cloner.Parent = game.ServerScriptService.playerdata
					cloner.Name = plr.Name.. ' msgcooldown'
				
				
				local success,problem = pcall(function()
					sendmessagetoserver(plr,messagetoserver)
					moverdb.Value = false
				end)
				
				if problem then
					msgdb = false
					moverdb.Value = false
					return
				end
									
				if (plr.Character.alreadyunderstood.Value == false)then
					plr.Character.alreadyunderstood.Value = true
					local message = "Messages getting cut off? Buy the increase token size gamepass or a private server!"
				game.ReplicatedStorage.clientmessage:FireClient(plr,message)
				end
			end

			notopenaicommands(plr,messagetoserver)

		end

	end) 
end) 



