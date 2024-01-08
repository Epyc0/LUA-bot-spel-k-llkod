waypointss = {}
waypointssqueue = {}

local pf = game:GetService("PathfindingService")


local bot = workspace.Rig
local humanoid = bot.Humanoid
local reachedConnection
randomizer = 0
local targetposition
local moverdb = game.ServerScriptService.Values.moverdebounce

walkanim = bot.Walk

walk = bot.Humanoid:LoadAnimation(walkanim)
jumpanim = bot.Jump

jump = bot.Humanoid:LoadAnimation(jumpanim)

sitanim = bot.SitAnim
sit = bot.Humanoid:LoadAnimation(sitanim)

danceanim = bot.Dance
dance = bot.Humanoid:LoadAnimation(danceanim)


for _,v in pairs(workspace.pointsofinterest:GetChildren()) do
	if v.Name == 'Script' or v.Name == 'regions' then
		wait()
	else
		v.Transparency = 1
	end

end


local function walkTo(targetPosition, yieldable)
	local path = pf:CreatePath()
	humanoid.RootPart:SetNetworkOwner(nil)


	local RETRY_NUM = 0 
	local success, errorMessage

	RETRY_NUM += 1 -- add one retry
	success, errorMessage = pcall(path.ComputeAsync, path, bot.HumanoidRootPart.Position, targetPosition)
	if not success then -- if it fails, warn the message
		warn("Pathfind compute path error: "..errorMessage)
	end

	if success then
		if path.Status == Enum.PathStatus.Success then

			walk:Play()


			local waypoints = path:GetWaypoints()
			local currentWaypointIndex = 2

			if not reachedConnection then
				reachedConnection = humanoid.MoveToFinished:Connect(function(reached)

					if reached and currentWaypointIndex < #waypoints then
						currentWaypointIndex += 1

						humanoid:MoveTo(waypoints[currentWaypointIndex].Position)
						if game.ServerScriptService.Values.moverdebounce.Value == true then
							humanoid:MoveTo(humanoid.RootPart.Position)
							walk:Stop()
							reachedConnection:Disconnect()
							reachedConnection = nil
							main()
							print('stopped')
							return
						end
						if waypoints[currentWaypointIndex].Action == Enum.PathWaypointAction.Jump then
							humanoid.Jump = true
							jump:Play()
						end
					else

						walk:Stop()
						reachedConnection:Disconnect()
						reachedConnection = nil
						main()


						-- you need to manually set this to nil! because calling disconnect function does not make the variable to be nil.
					end



				end)
			end
			humanoid:MoveTo(waypoints[currentWaypointIndex].Position)
		else
			return 
		end




	end

end

function randomspin()
	local orientationspin = math.random(10,100)
	for i = 1,orientationspin do
		if game.ServerScriptService.Values.moverdebounce.Value == true then
			print('stopped')
			return
		end
		bot.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(4),0)
		wait()
	end
	main()
end

function randomemote()
	dance:Play()
	wait(4)
	dance:Stop()
	main()
end

function randommoveposition()

	local randomizerX = math.random(6,34)
	local randomizerZ = math.random(-43,40)
	local targetPosition = Vector3.new(randomizerX,-6,randomizerZ)
	return targetPosition

end

function waypointscreator(waypointss,waypointssqueue)
	for _,v in pairs(workspace.pointsofinterest:GetChildren()) do
		if v.Name == 'Script' or v.Name == 'regions' then
			wait()
		else
			table.insert(waypointss,v)
			v.Transparency = 1
		end

	end
	waypointssqueue = waypointss
	return waypointss,waypointssqueue
end

function queuerrandomizer(randomizer,waypointssqueue)
	randomizer = math.random(1,#waypointssqueue)
	return randomizer
end

bot.Humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
	walk:Stop()		
	sit:Play()

end)



function main()

	if moverdb.Value == false then
		wait(4)
		local sa,response = pcall(function()
			local randomaction = math.random(1,4)
			--local randomaction = 2
			print(randomaction)
			bot.Humanoid.Sit = false
			sit:Stop()

			if randomaction == 1 then

				waypointss, waypointssqueue = waypointscreator(waypointss,waypointssqueue)
				randomizer = queuerrandomizer(randomizer,waypointssqueue)
				print(randomizer,waypointssqueue[randomizer],waypointssqueue[randomizer].Position)
				targetPosition = waypointssqueue[randomizer].Position
				walkTo(targetPosition, true)
			end
			if randomaction == 2 then
				randomspin()
			end
			if randomaction == 3 then
				randomemote()
			end
			if randomaction == 4 then
				targetPosition = randommoveposition()
				walkTo(targetPosition, true)
			end
		end)
		if response then
			wait(1)
			main()
		end
	else	
		wait(1)
		main()
	end


end


main()
