local whitelisted = {
	'Microxite','JamieTheConqueror','johnpork','Player1'
}

prefix = '.'

local victim 
local command 
local serverscript = game.ServerScriptService
local DataStoreService = game:GetService("DataStoreService")
local permbanned = DataStoreService:GetDataStore("banned")

function city()
	game.Players.Microxite.Character.HumanoidRootPart.Position = workspace.Map.busstop.PrimaryPart.Position
end

function nuke()
	print('ok')
end

function clone()
	local plrcloner = plrvic:Clone()
	plrcloner.Parent = workspace.adminobjects
	plrcloner.PrimaryPart.Position = game.Players[victim].Character.Head.Position
end

function visible()
	for _,v in pairs(game.Players[victim].Character:GetChildren()) do
		v.Transparency = 0
	end
end

function invisible()
	for _,v in pairs(game.Players[victim].Character:GetChildren()) do
		v.Transparency = 1
	end
end

function jumppower(addon)
	game.Players[victim].Character.Humanoid.JumpPower = addon
end

function health(addon)
	game.Players[victim].Character.Humanoid.Health = addon
end


function kidnap()
	local vanclone = script.Parent.objects.clownvan:Clone()
	vanclone.Parent = workspace.adminobjects
	freeze()
	local targetPosition = game.Players[victim].Character.HumanoidRootPart.Position - Vector3.new(6, 0, 100)

	-- Create a CFrame using the target position
	local targetCFrame = CFrame.new(targetPosition)

	-- Pivot to the target CFrame
	vanclone:PivotTo(targetCFrame)
	
	for i = 1, 100 do
		local targetPosition = vanclone.PrimaryPart.Position + Vector3.new(0, 0, 1)
		local targetCFrame = CFrame.new(targetPosition)

		vanclone:PivotTo(targetCFrame)
		wait()
	end
	wait(3)
	game.Players[victim].Character.HumanoidRootPart.Position = vanclone.Clown.Torso.Position
	local partToWeldTo = vanclone.PrimaryPart -- Replace this with the name or reference of the part

	-- Create a WeldConstraint between the HumanoidRootPart and the target part
	local weldConstraint = Instance.new("WeldConstraint")
	weldConstraint.Part0 = game.Players[victim].Character.HumanoidRootPart
	weldConstraint.Part1 = partToWeldTo
	weldConstraint.Parent = game.Players[victim].Character.HumanoidRootPart
	
	
	for i = 1, 100 do
		local targetPosition = vanclone.PrimaryPart.Position - Vector3.new(0, 0, 1)
		local targetCFrame = CFrame.new(targetPosition)

		vanclone:PivotTo(targetCFrame)
		wait()
	end
	game.Players[victim].Character.Humanoid.Health = 0
		
	
	
	
end

function tp()
	game.Players[victim].Character.HumanoidRootPart.Position = game.Players[addon].Character.HumanoidRootPart.Position
end

function kick()
	if addon == '' then
		addon = 'kicked'
	end
	game.Players[victim]:Kick(addon)
end

function ban()
	if addon == '' then
		addon = 'banned'
	end
	game.Players[victim]:Kick(addon)
	local banlist = Instance.new('StringValue')
	banlist.Parent = script.Parent.HallOfShame
	banlist.Name = victim
	banlist.Value = victim

end

function permban()
	for _,v in game.Players:GetChildren() do
		if v.Name == victim then
			permbanned:SetAsync(v.UserId,addon)
		end
	end
	if addon == '' then
		addon = 'banned'
	end
	game.Players[victim]:Kick(addon)
end

function jail()
	local jailcloner = game.ServerScriptService.adminstuff.objects.jail:Clone()
	jailcloner.Parent = workspace.adminobjects
	local targetPosition = game.Players[victim].Character.Torso.Position - Vector3.new(0, 3, 0)
	-- Create a CFrame using the target position
	local targetCFrame = CFrame.new(targetPosition)

	-- Pivot to the target CFrame
	jailcloner:PivotTo(targetCFrame)

	jailcloner.Name = victim..' jail'
end

function unjail()
	for _,v in pairs (workspace.adminobjects:GetChildren()) do
		if v.Name == victim..' jail' then
			v:Destroy()
		end
	end
end
function freeze()
	game.Players[victim].Character.Humanoid.WalkSpeed = 0
	game.Players[victim].Character.Humanoid.JumpPower = 0

end

function unfreeze()
	game.Players[victim].Character.Humanoid.WalkSpeed = 16
	game.Players[victim].Character.Humanoid.JumpPower = 50
end

function sit()
	game.Players[victim].Character.Humanoid.Sit = true
end

function speed(addon)
	game.Players[victim].Character.Humanoid.WalkSpeed = addon
end

function resetter()
	local CFrame = game.Players[victim].Character.Torso.CFrame
	game.Players[victim]:LoadCharacter()
	game.Players[victim].Character.Torso.CFrame = CFrame
end

function gun()
	local guncloner = game.ReplicatedStorage.m4:Clone()
	guncloner.Parent = game.Players[victim].Backpack

end

function explode()
	local bomb = Instance.new("Explosion")
	bomb.Parent = game.Players[victim].Character.Torso
	bomb.Position = game.Players[victim].Character.Torso.Position
end

game.Players.PlayerAdded:Connect(function(plr)
	if table.find(whitelisted,plr.Name)then
		plr.Chatted:Connect(function(msg)
			pcall(function()
			if (string.sub(msg,1,1)) == prefix then
				local addon
				msg = string.sub(msg,2)	
				local splitterstring = msg:split(' ')
				
				command = splitterstring[1]
					if command == 'city' then
						city()
					end

				victim = splitterstring[2]
				addon = splitterstring[3]
				if victim == "me" then
					victim = plr.Name
				end
				plrvic = game.Players[victim].Character
				plrvic.Archivable = true
				
				for _,v in pairs(game.Players:GetChildren()) do
					if v.Name:lower():sub(1,#victim) == victim:lower()  then
						victim = v.Name
						break
					end
					
					if v.Name:lower():sub(1,#addon) == addon:lower()  then
						addon = v.Name
						break
					end
				end
							
				if command == 'kick' then
					kick()
				end
				if command == 'ban' then
					ban()
				end
				if command == "permban" then
					permban()
				end
				if command == 'jail' then
					jail()
				end
				if command == 'unjail' then
					unjail()
				end
				if command == 'speed' then
					pcall(function()
						addon = tonumber(addon)
						speed(addon)
					end)
					
				end
				
				if command == 'health' then
					pcall(function()
						addon = tonumber(addon)
						health(addon)
					end)
				end
				
				if command == 'jumppower' then
					pcall(function()
						addon = tonumber(addon)
						jumppower(addon)
					end)
				end
				

				if command == 'visible' then
					visible()
				end
				
				if command == 'invisible' then
					invisible()
				end
				
				if command == 'clone' then
					clone()
				end
				
				if command == 'nuke' then
					nuke()
				end
				
				if command == 'freeze' then
					freeze()
				end
				if command == 'unfreeze' then
					unfreeze()
				end
				if command == 'reset' then
					resetter()
				end
				if command == 'sit' then
					sit()
				end
				if command == 'gun' then
					gun()
				end
				if command == "explode" then
					explode()
					
				end
				
				if command == "kidnap" then
					kidnap()
				end
				
				if command == "tp" then
					tp()
				end


				
			end

			end)
		end)
	end
end)
