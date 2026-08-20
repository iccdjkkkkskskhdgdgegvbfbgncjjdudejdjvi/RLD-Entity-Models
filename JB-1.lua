local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local url = "https://raw.githubusercontent.com/lynguyen26031993-design/-u/refs/heads/main/Place_17302962269_Model_JB-1_1787191826.txt"
local file = "JB-1.txt"

if not isfile(file) then
	writefile(file, game:HttpGet(url))
end

local objects = game:GetObjects(getcustomasset(file))
local model = objects[1]

if model then
	local alive = true
	local connections = {}
	local tweens = {}
	local instances = {}

	local function addConnection(connection)
		table.insert(connections, connection)
		return connection
	end

	local function addTween(tween)
		table.insert(tweens, tween)
		return tween
	end

	local function addInstance(instance)
		table.insert(instances, instance)
		return instance
	end

	local function cleanup()
		if not alive then
			return
		end

		alive = false

		for _, connection in ipairs(connections) do
			if connection and connection.Connected then
				connection:Disconnect()
			end
		end

		for _, tween in ipairs(tweens) do
			pcall(function()
				tween:Cancel()
			end)
		end

		for _, instance in ipairs(instances) do
			if instance and instance.Parent then
				instance:Destroy()
			end
		end

		table.clear(connections)
		table.clear(tweens)
		table.clear(instances)

		if model and model.Parent then
			model:Destroy()
		end
	end

	local gameData = ReplicatedStorage:WaitForChild("GameData")
	local latestRoom = gameData:WaitForChild("LatestRoom")
	local currentRooms = workspace:WaitForChild("CurrentRooms")

	local room = currentRooms:WaitForChild(tostring(latestRoom.Value))

	local floor

	for _, v in ipairs(room:GetDescendants()) do
		if v.Name == "Floor" and (v:IsA("BasePart") or v:IsA("Model")) then
			floor = v
			break
		end
	end

	if floor then
		model.Parent = workspace

		local floorCFrame, floorSize

		if floor:IsA("BasePart") then
			floorCFrame = floor.CFrame
			floorSize = floor.Size
		else
			floorCFrame, floorSize = floor:GetBoundingBox()
		end

		local randomX = (math.random() - 0.5) * floorSize.X
		local randomZ = (math.random() - 0.5) * floorSize.Z

		local spawnPosition = floorCFrame:PointToWorldSpace(
			Vector3.new(
				randomX,
				floorSize.Y / 2,
				randomZ
			)
		)

		local _, modelSize = model:GetBoundingBox()

		spawnPosition += Vector3.new(0, modelSize.Y / 2, 0)

		model:PivotTo(CFrame.new(spawnPosition))

		-- HITBOX
		local hitbox = Instance.new("Part")
		hitbox.Name = "EntityHitbox"
		hitbox.Size = Vector3.new(20, 20, 20)
		hitbox.Transparency = 1
		hitbox.CanCollide = false
		hitbox.CanTouch = true
		hitbox.CanQuery = true
		hitbox.Massless = true
		hitbox.Anchored = false
		hitbox.CFrame = model:GetPivot()
		hitbox.Parent = model

		addInstance(hitbox)

		local weldPart

		for _, v in ipairs(model:GetDescendants()) do
			if v:IsA("BasePart") and v ~= hitbox then
				weldPart = v
				break
			end
		end

		if weldPart then
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = hitbox
			weld.Part1 = weldPart
			weld.Parent = hitbox

			addInstance(weld)
		end

		local player = Players.LocalPlayer
		local touching = false
		local damageCooldown = 1.3
		local nextDamage = 0

		local function isPlayerPart(part)
			if not player.Character then
				return false
			end

			return part:IsDescendantOf(player.Character)
		end

		addConnection(hitbox.Touched:Connect(function(part)
			if not alive or not isPlayerPart(part) then
				return
			end

			touching = true
		end))

		addConnection(hitbox.TouchEnded:Connect(function(part)
			if not isPlayerPart(part) then
				return
			end

			task.defer(function()
				if not alive or not player.Character then
					touching = false
					return
				end

				local stillTouching = false

				for _, v in ipairs(player.Character:GetDescendants()) do
					if v:IsA("BasePart") then
						local touchingParts = v:GetTouchingParts()

						for _, touchingPart in ipairs(touchingParts) do
							if touchingPart == hitbox then
								stillTouching = true
								break
							end
						end

						if stillTouching then
							break
						end
					end
				end

				touching = stillTouching
			end)
		end))

		task.spawn(function()
			while alive and model.Parent do
				if touching then
					local now = os.clock()

					if now >= nextDamage then
						local character = player.Character
						local humanoid = character and character:FindFirstChildOfClass("Humanoid")

						if humanoid and humanoid.Health > 0 then
							humanoid:TakeDamage(20)
							
							local stats = game.ReplicatedStorage.GameStats:FindFirstChild(
						"Player_" .. game.Players.LocalPlayer.Name
					)

					if stats and stats:FindFirstChild("Total") then
						local deathCause = stats.Total:FindFirstChild("DeathCause")

						if deathCause then
							deathCause.Value = "JB-1"
						end
					end
						end

						nextDamage = now + damageCooldown
					end
				end

				task.wait(0.05)
			end
		end)

		-- LIFETIME 30S
		task.spawn(function()
			local remaining = 30

			while alive and remaining > 0 do
				task.wait(1)

				if not alive then
					break
				end

				remaining -= 1
			end

			if alive and remaining <= 0 then
				cleanup()
			end
		end)

		-- UIGradient
		for _, v in ipairs(model:GetDescendants()) do
			if v:IsA("UIGradient") and v.Parent:IsA("ImageLabel") then
				task.spawn(function()
					while alive and v.Parent and v:IsDescendantOf(model) do
						local tween = addTween(TweenService:Create(
							v,
							TweenInfo.new(2, Enum.EasingStyle.Linear),
							{Rotation = v.Rotation + 360}
						))

						tween:Play()
						tween.Completed:Wait()
					end
				end)
			end
		end

		-- BOUNCE + SHAKE
		for _, image in ipairs(model:GetDescendants()) do
			if image:IsA("ImageLabel") and image:FindFirstChildOfClass("UIGradient") then
				local billboard = image:FindFirstAncestorOfClass("BillboardGui")

				if billboard then
					task.spawn(function()
						local originalOffset = billboard.StudsOffset
						local loweredOffset = originalOffset + Vector3.new(0, -2, 0)

						while alive and billboard.Parent and billboard:IsDescendantOf(model) do
							local downTween = addTween(TweenService:Create(
								billboard,
								TweenInfo.new(
									0.4,
									Enum.EasingStyle.Quad,
									Enum.EasingDirection.In
								),
								{StudsOffset = loweredOffset}
							))

							downTween:Play()
							downTween.Completed:Wait()

							if not alive then
								break
							end

							for _, sound in ipairs(model:GetDescendants()) do
								if sound:IsA("Sound") and sound.Name:lower() == "boing" then
									local clone = sound:Clone()
									clone.Parent = sound.Parent
									addInstance(clone)
									clone:Play()

									addConnection(clone.Ended:Connect(function()
										if clone.Parent then
											clone:Destroy()
										end
									end))
								end
							end

							if not alive or not billboard.Parent or not billboard:IsDescendantOf(model) then
								break
							end

							local bounceTween = addTween(TweenService:Create(
								billboard,
								TweenInfo.new(
									0.3,
									Enum.EasingStyle.Quad,
									Enum.EasingDirection.Out
								),
								{StudsOffset = originalOffset}
							))

							bounceTween:Play()
							bounceTween.Completed:Wait()
						end
					end)

					task.spawn(function()
						local originalRotation = image.Rotation
						local rotation = 0

						while alive and image.Parent and image:IsDescendantOf(model) do
							local delta = math.random(-20, 20) / 10

							rotation += delta
							rotation = math.clamp(rotation, -3, 3)

							image.Rotation = originalRotation + rotation

							task.wait(0.03)
						end
					end)
				end
			end
		end

		-- VOICE
		local voices = {}

		for _, sound in ipairs(model:GetDescendants()) do
			if sound:IsA("Sound") and sound.Name:lower():find("voice", 1, true) then
				table.insert(voices, sound)
			end
		end

		if #voices > 0 then
			task.spawn(function()
				while alive and model.Parent do
					task.wait(math.random(3, 7))

					if not alive or not model.Parent then
						break
					end

					local sound = voices[math.random(1, #voices)]

					if sound and sound.Parent and sound:IsDescendantOf(model) then
						sound:Play()
					end
				end
			end)
		end

		-- RANDOM MOVEMENT
		task.spawn(function()
			local rayParams = RaycastParams.new()
			rayParams.FilterType = Enum.RaycastFilterType.Exclude
			rayParams.FilterDescendantsInstances = {model}
			rayParams.IgnoreWater = true

			while alive and model.Parent do
				task.wait(2)

				if not alive or not model.Parent then
					break
				end

				local startPivot = model:GetPivot()
				local startPosition = startPivot.Position

				local angle = math.rad(math.random(0, 359))
				local distance = math.random(10, 30)

				local direction = Vector3.new(
					math.cos(angle),
					0,
					math.sin(angle)
				).Unit

				local targetPosition = startPosition + direction * distance

				local targetCFrame =
					CFrame.new(targetPosition) * startPivot.Rotation

				local moveValue = addInstance(Instance.new("CFrameValue"))
				moveValue.Value = startPivot

				local stopped = false

				local moveConnection = addConnection(
					moveValue:GetPropertyChangedSignal("Value"):Connect(function()
						if alive and model.Parent and not stopped then
							model:PivotTo(moveValue.Value)
						end
					end)
				)

				local moveTween = addTween(TweenService:Create(
					moveValue,
					TweenInfo.new(1, Enum.EasingStyle.Linear),
					{Value = targetCFrame}
				))

				local rayConnection

				rayConnection = addConnection(
					RunService.Heartbeat:Connect(function()
						if not alive or stopped or not model.Parent then
							return
						end

						local currentPosition = model:GetPivot().Position

						local result = workspace:Raycast(
							currentPosition,
							direction * distance,
							rayParams
						)

						if result
							and result.Instance:IsA("BasePart")
							and result.Instance.Name:lower():find("wall", 1, true) then

							local wallDistance =
								(result.Position - currentPosition).Magnitude

							if wallDistance <= 2 then
								stopped = true
								moveTween:Cancel()

								if moveConnection.Connected then
									moveConnection:Disconnect()
								end

								if rayConnection.Connected then
									rayConnection:Disconnect()
								end
							end
						end
					end)
				)

				moveTween:Play()
				moveTween.Completed:Wait()

				if moveConnection.Connected then
					moveConnection:Disconnect()
				end

				if rayConnection.Connected then
					rayConnection:Disconnect()
				end

				if moveValue.Parent then
					moveValue:Destroy()
				end

				if not alive then
					break
				end
			end
		end)
	end
end
