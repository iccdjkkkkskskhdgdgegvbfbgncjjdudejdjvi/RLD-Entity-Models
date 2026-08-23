local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local url = "https://raw.githubusercontent.com/iccdjkkkkskskhdgdgegvbfbgncjjdudejdjvi/RLD-Entity-Models/refs/heads/main/Place_17302962269_Model_B-1_1787464205.txt"

local data = game:HttpGet(url)

local path = "B1Model.rbxm"
writefile(path, data)

local model = game:GetObjects(getcustomasset(path))[1]

if model then
	model.Parent = workspace
	
		local entityHitbox
	local hitboxConnection

	do
		local weldPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)

		if weldPart then
			if not model.PrimaryPart then
				model.PrimaryPart = weldPart
			end

			entityHitbox = Instance.new("Part")
			entityHitbox.Name = "EntityHitbox"
			entityHitbox.Size = Vector3.new(10, 10, 10)
			entityHitbox.Transparency = 1
			entityHitbox.Anchored = false
			entityHitbox.CanCollide = false
			entityHitbox.CanQuery = false
			entityHitbox.CanTouch = true
			entityHitbox.Massless = true
			entityHitbox.CFrame = model:GetPivot()
			entityHitbox.Parent = model

			local weld = Instance.new("WeldConstraint")
			weld.Part0 = weldPart
			weld.Part1 = entityHitbox
			weld.Parent = entityHitbox

			hitboxConnection = entityHitbox.Touched:Connect(function(hit)
	if not entityHitbox or not entityHitbox.Parent then
		return
	end

	if not hit:IsDescendantOf(char) then
		return
	end

	if char:GetAttribute("Hiding") == true then
		return
	end

	if humanoid and humanoid.Parent and humanoid.Health > 0 then
		humanoid.Health = 0
		game.ReplicatedStorage.GameStats[
			"Player_" .. game.Players.LocalPlayer.Name
		].Total.DeathCause.Value = "B-1"
	end
end)
		end
	end

	if model:IsA("Model") then
		local latestRoom = ReplicatedStorage:WaitForChild("GameData"):WaitForChild("LatestRoom")
		local currentRooms = workspace:WaitForChild("CurrentRooms")

		local room = currentRooms:FindFirstChild(tostring(latestRoom.Value))

		if room then
			local roomExit = room:FindFirstChild("RoomExit", true)

			if roomExit and roomExit:IsA("BasePart") then
				local cf = roomExit.CFrame * CFrame.new(0, -1, 3)

				if model.PrimaryPart then
					model:PivotTo(cf)
				else
					local part = model:FindFirstChildWhichIsA("BasePart", true)

					if part then
						model.PrimaryPart = part
						model:PivotTo(cf)
					end
				end
			end
		end
	end

	local firstBasePart = model:FindFirstChildWhichIsA("BasePart", true)

	local acidParts = {}

	local function createAcid()
		if not model.Parent or not firstBasePart or not firstBasePart.Parent then
			return
		end

		local acid = Instance.new("Part")
		acid.Name = "Acid"
		acid.Anchored = true
		acid.CanCollide = false
		acid.CanQuery = false
		acid.CanTouch = false
		acid.Shape = Enum.PartType.Cylinder
		acid.Material = Enum.Material.Glass
		acid.Color = Color3.fromRGB(35, 120, 25)
		acid.Reflectance = 0.05
		acid.Transparency = 1
		acid.Size = Vector3.new(0.05, 0.05, 0.05)

		local bottomY = firstBasePart.Size.Y / 2 + 0.4

		local acidCFrame =
			firstBasePart.CFrame
			* CFrame.new(0, -bottomY - 0.025, 0)
			* CFrame.Angles(0, 0, math.rad(90))

		acid.CFrame = acidCFrame
		acid.Parent = workspace

		local damagePart = acid:Clone()
		damagePart.Name = "AcidDamage"
		damagePart.Transparency = 1
		damagePart.CanCollide = false
		damagePart.CanQuery = false
		damagePart.CanTouch = true
		damagePart.CFrame = acidCFrame + Vector3.new(0, 2, 0)
		damagePart.Parent = workspace

		local acidData = {
			part = acid,
			damagePart = damagePart,
			touching = false,
			connections = {},
			fading = false
		}

		acidParts[acid] = acidData

		local touchConnection
		local leaveConnection

		touchConnection = damagePart.Touched:Connect(function(hit)
			if not damagePart.Parent then
				return
			end

			if hit:IsDescendantOf(char) then
				if not acidData.touching then
					acidData.touching = true

					if humanoid and humanoid.Parent and humanoid.Health > 0 then
						humanoid:TakeDamage(math.random(5, 10))
						game.ReplicatedStorage.GameStats["Player_" .. game.Players.LocalPlayer.Name].Total.DeathCause.Value = "B-1"
					end
				end
			end
		end)

		leaveConnection = damagePart.TouchEnded:Connect(function(hit)
			if hit:IsDescendantOf(char) then
				task.defer(function()
					if not damagePart.Parent then
						return
					end

					local touching = false

					for _, bodyPart in ipairs(char:GetDescendants()) do
						if bodyPart:IsA("BasePart") then
							for _, touchingPart in ipairs(bodyPart:GetTouchingParts()) do
								if touchingPart == damagePart then
									touching = true
									break
								end
							end

							if touching then
								break
							end
						end
					end

					acidData.touching = touching
				end)
			end
		end)

		acidData.connections[#acidData.connections + 1] = touchConnection
		acidData.connections[#acidData.connections + 1] = leaveConnection

		local spawnTween = TweenService:Create(
			acid,
			TweenInfo.new(
				0.3,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			),
			{
				Size = Vector3.new(0.15, 8, 8),
				Transparency = 0
			}
		)

		spawnTween:Play()

		spawnTween.Completed:Once(function()
			if not acid.Parent then
				return
			end

			task.delay(7, function()
				if not acid.Parent or acidData.fading then
					return
				end

				acidData.fading = true
				acidData.touching = false

				for _, connection in ipairs(acidData.connections) do
					if connection then
						connection:Disconnect()
					end
				end

				table.clear(acidData.connections)

				local fadeTween = TweenService:Create(
					acid,
					TweenInfo.new(
						0.5,
						Enum.EasingStyle.Quad,
						Enum.EasingDirection.In
					),
					{
						Size = Vector3.new(0.05, 0.05, 0.05),
						Transparency = 1
					}
				)

				fadeTween:Play()

				fadeTween.Completed:Once(function()
					acidParts[acid] = nil

					if damagePart.Parent then
						damagePart:Destroy()
					end

					if acid.Parent then
						acid:Destroy()
					end
				end)
			end)
		end)
	end

	local acidTimer = 0
	local acidConnection

	acidConnection = RunService.Heartbeat:Connect(function(dt)
		if not model.Parent then
			if acidConnection then
				acidConnection:Disconnect()
				acidConnection = nil
			end

			return
		end

		acidTimer += dt

		while acidTimer >= 0.08 do
			acidTimer -= 0.1
			createAcid()
		end
	end)

	local images = {}

	for _, obj in ipairs(model:GetDescendants()) do
		if obj:IsA("ImageLabel") then
			images[#images + 1] = {
				object = obj,
				position = obj.Position,
				rotation = obj.Rotation
			}
		end
	end

	local t = 0
	local emitTimer = 0

	local connection

	connection = RunService.RenderStepped:Connect(function(dt)
		if not model.Parent then
			connection:Disconnect()
			connection = nil
			return
		end

		t += dt
		emitTimer += dt

		local shakeX = math.noise(t * 55, 0, 0) * 0.025 * 1.5
		local shakeY = math.noise(0, t * 55, 0) * 0.025 * 1.5
		local rotate = math.noise(t * 55, t * 55, 0) * 4

		for _, info in ipairs(images) do
			local image = info.object
			local pos = info.position

			if image and image.Parent then
				image.Position = UDim2.new(
					pos.X.Scale + shakeX,
					pos.X.Offset,
					pos.Y.Scale + shakeY,
					pos.Y.Offset
				)

				image.Rotation = info.rotation + rotate
			end
		end
	end)

	local initialPivot = model:GetPivot()

		local function cleanupEntity()
		if connection then
			connection:Disconnect()
			connection = nil
		end

		if acidConnection then
			acidConnection:Disconnect()
			acidConnection = nil
		end

		if hitboxConnection then
			hitboxConnection:Disconnect()
			hitboxConnection = nil
		end

		if entityHitbox then
			entityHitbox:Destroy()
			entityHitbox = nil
		end

		if model and model.Parent then
			model:Destroy()
		end
	end

	task.spawn(function()
		task.wait(4)

		if not model.Parent then
			return
		end

		local latestRoom = ReplicatedStorage:WaitForChild("GameData"):WaitForChild("LatestRoom")
		local currentRooms = workspace:WaitForChild("CurrentRooms")

		local room = currentRooms:FindFirstChild(tostring(latestRoom.Value))

		if not room then
			cleanupEntity()
			return
		end

		local roomEntrance = room:FindFirstChild("RoomEntrance", true)

		if not roomEntrance or not roomEntrance:IsA("BasePart") then
			cleanupEntity()
			return
		end

		local entranceCF = roomEntrance.CFrame

		local firstTargetPosition = Vector3.new(
	entranceCF.Position.X,
	entranceCF.Position.Y - 1,
	entranceCF.Position.Z
)

		local firstTargetCF =
			CFrame.new(firstTargetPosition)
			* (entranceCF - entranceCF.Position)

		local moveValue = Instance.new("CFrameValue")
		moveValue.Value = model:GetPivot()

		local moveConnection = moveValue:GetPropertyChangedSignal("Value"):Connect(function()
			if model and model.Parent then
				model:PivotTo(moveValue.Value)
			end
		end)

		local firstTween = TweenService:Create(
			moveValue,
			TweenInfo.new(
				2,
				Enum.EasingStyle.Linear,
				Enum.EasingDirection.Out
			),
			{
				Value = firstTargetCF
			}
		)

		firstTween:Play()
		firstTween.Completed:Wait()

		moveConnection:Disconnect()
		moveConnection = nil
		moveValue:Destroy()

		if not model.Parent then
			return
		end

		local exitDirection = -entranceCF.LookVector

		local finalPosition =
			firstTargetPosition + exitDirection * 200

		local finalCF =
			CFrame.new(finalPosition)
			* (entranceCF - entranceCF.Position)

		local moveValue2 = Instance.new("CFrameValue")
		moveValue2.Value = model:GetPivot()

		local moveConnection2 = moveValue2:GetPropertyChangedSignal("Value"):Connect(function()
			if model and model.Parent then
				model:PivotTo(moveValue2.Value)
			end
		end)

		local travelTime = 200 / 35

		local secondTween = TweenService:Create(
			moveValue2,
			TweenInfo.new(
				travelTime,
				Enum.EasingStyle.Linear,
				Enum.EasingDirection.Out
			),
			{
				Value = finalCF
			}
		)

		secondTween:Play()
		secondTween.Completed:Wait()

		moveConnection2:Disconnect()
		moveConnection2 = nil
		moveValue2:Destroy()

		cleanupEntity()
	end)
end
