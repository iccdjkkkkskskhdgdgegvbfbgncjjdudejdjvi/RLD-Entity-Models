local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local url = "https://raw.githubusercontent.com/lynguyen26031993-design/-u/refs/heads/main/Place_17302962269_Model_G-1_1787124665.txt"

local data = game:HttpGet(url)

local path = "G1Model.rbxm"
writefile(path, data)

local model = game:GetObjects(getcustomasset(path))[1]

if model then
	model.Parent = workspace

	local textureId = "rbxassetid://136801519834400"

	local connections = {}
	local tweens = {}
	local loops = {}
	local destroyed = false

	local function addConnection(connection)
		connections[#connections + 1] = connection
		return connection
	end

	local function addTween(tween)
		tweens[#tweens + 1] = tween
		return tween
	end

	local floor

	if model:IsA("Model") then
		local latestRoom = ReplicatedStorage.GameData.LatestRoom.Value
		local currentRooms = workspace:FindFirstChild("CurrentRooms")
		local room = currentRooms and currentRooms:FindFirstChild(tostring(latestRoom))
		local parts = room and room:FindFirstChild("Parts")

		floor = parts and parts:FindFirstChild("Floor")

		if floor and floor:IsA("BasePart") then
			local size = floor.Size

			local randomX = (math.random() - 0.5) * size.X
			local randomZ = (math.random() - 0.5) * size.Z

			local pos = floor.CFrame:PointToWorldSpace(Vector3.new(
				randomX,
				size.Y / 2 + 3,
				randomZ
			))

			local cf = CFrame.new(pos)

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

	for _, obj in ipairs(model:GetDescendants()) do
		if obj:IsA("ImageLabel") then
			if obj.Parent:IsA("BillboardGui") then
				obj.Image = textureId
			end

		elseif obj:IsA("ParticleEmitter") then
			local parent = obj.Parent

			if parent and parent:IsA("Attachment") and parent.Name == "Rings" then
				obj.Texture = textureId
			end
		end
	end

	local function greenColor(color)
		local _, s, v = color:ToHSV()
		return Color3.fromHSV(1 / 3, s, v)
	end

	for _, obj in ipairs(model:GetDescendants()) do
		if obj:IsA("ParticleEmitter") then
			local keypoints = obj.Color.Keypoints
			local newKeypoints = {}

			for _, keypoint in ipairs(keypoints) do
				newKeypoints[#newKeypoints + 1] = ColorSequenceKeypoint.new(
					keypoint.Time,
					greenColor(keypoint.Value)
				)
			end

			obj.Color = ColorSequence.new(newKeypoints)

		elseif obj:IsA("PointLight")
			or obj:IsA("SpotLight")
			or obj:IsA("SurfaceLight") then

			obj.Color = greenColor(obj.Color)

		elseif obj:IsA("BasePart") then
			obj.Color = greenColor(obj.Color)

		elseif obj:IsA("Beam") then
			local keypoints = obj.Color.Keypoints
			local newKeypoints = {}

			for _, keypoint in ipairs(keypoints) do
				newKeypoints[#newKeypoints + 1] = ColorSequenceKeypoint.new(
					keypoint.Time,
					greenColor(keypoint.Value)
				)
			end

			obj.Color = ColorSequence.new(newKeypoints)

		elseif obj:IsA("ImageLabel") then
			obj.ImageColor3 = greenColor(obj.ImageColor3)
		end
	end

	local hitbox

	if model.PrimaryPart then
		hitbox = Instance.new("Part")
		hitbox.Name = "DamageHitbox"
		hitbox.Size = Vector3.new(20, 20, 20)
		hitbox.Transparency = 1
		hitbox.CanCollide = false
		hitbox.CanQuery = false
		hitbox.CanTouch = true
		hitbox.Massless = true
		hitbox.Anchored = false
		hitbox.CFrame = model.PrimaryPart.CFrame
		hitbox.Parent = model

		local weld = Instance.new("WeldConstraint")
		weld.Part0 = model.PrimaryPart
		weld.Part1 = hitbox
		weld.Parent = hitbox

		local touching = false

		addConnection(hitbox.Touched:Connect(function(part)
			if destroyed or touching then
				return
			end

			local character = player.Character

			if not character or not part:IsDescendantOf(character) then
				return
			end

			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if not humanoid or humanoid.Health <= 0 then
				return
			end

			touching = true

			humanoid:TakeDamage(math.random(10, 20))

			local stats = game.ReplicatedStorage.GameStats:FindFirstChild(
				"Player_" .. player.Name
			)

			if stats then
				local total = stats:FindFirstChild("Total")

				if total then
					local deathCause = total:FindFirstChild("DeathCause")

					if deathCause then
						deathCause.Value = "G-1"
					end
				end
			end
		end))

		addConnection(hitbox.TouchEnded:Connect(function(part)
			if destroyed then
				return
			end

			local character = player.Character

			if character and part:IsDescendantOf(character) then
				task.defer(function()
					if destroyed or not hitbox.Parent then
						return
					end

					local touchingCharacter = false

					for _, touchingPart in ipairs(hitbox:GetTouchingParts()) do
						if touchingPart:IsDescendantOf(character) then
							touchingCharacter = true
							break
						end
					end

					if not touchingCharacter then
						touching = false
					end
				end)
			end
		end))
	end

	local images = {}

	for _, obj in ipairs(model:GetDescendants()) do
		if obj:IsA("ImageLabel") then
			images[#images + 1] = {
				object = obj,
				position = obj.Position
			}
		end
	end

	local t = 0

	addConnection(RunService.RenderStepped:Connect(function(dt)
		if destroyed or not model.Parent then
			return
		end

		t += dt

		local shakeX = math.noise(t * 35, 0, 0) * 0.025
		local shakeY = math.noise(0, t * 35, 0) * 0.025

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
			end
		end
	end))

	local function cleanup()
		if destroyed then
			return
		end

		destroyed = true

		for _, connection in ipairs(connections) do
			if connection and connection.Connected then
				connection:Disconnect()
			end
		end

		table.clear(connections)

		for _, tween in ipairs(tweens) do
			pcall(function()
				tween:Cancel()
			end)
		end

		table.clear(tweens)

		for _, loopThread in ipairs(loops) do
			pcall(function()
				task.cancel(loopThread)
			end)
		end

		table.clear(loops)

		local tp

		for _, obj in ipairs(model:GetDescendants()) do
			if obj:IsA("Sound") and obj.Name == "Tp" then
				tp = obj
				break
			end
		end

		for _, obj in ipairs(model:GetDescendants()) do
			if obj:IsA("Sound") then
				obj:Stop()

				if obj.Name ~= "Tp" then
					obj.Volume = 0
				end

			elseif obj:IsA("ParticleEmitter")
				or obj:IsA("Beam")
				or obj:IsA("Trail")
				or obj:IsA("Smoke")
				or obj:IsA("Fire")
				or obj:IsA("Sparkles")
				or obj:IsA("Light") then

				pcall(function()
					obj.Enabled = false
				end)

			elseif obj:IsA("PointLight")
				or obj:IsA("SpotLight")
				or obj:IsA("SurfaceLight") then

				obj.Enabled = false

			elseif obj:IsA("GuiObject") then
				obj.Visible = false

			elseif obj:IsA("BasePart") then
				obj.Transparency = 1
				obj.CanCollide = false
				obj.CanTouch = false
				obj.CanQuery = false

			elseif obj:IsA("Decal") or obj:IsA("Texture") then
				obj.Transparency = 1
			end
		end

		if tp and tp.Parent then
			tp.Volume = 1
			tp:Play()

			local ended = false

			local tpConnection
			tpConnection = tp.Ended:Connect(function()
				ended = true

				if tpConnection and tpConnection.Connected then
					tpConnection:Disconnect()
				end
			end)

			while not ended and tp.Parent and model.Parent do
				task.wait()
			end
		end

		if model and model.Parent then
			model:Destroy()
		end

		table.clear(images)
	end

	loops[#loops + 1] = task.spawn(function()
		while not destroyed and model.Parent and floor and floor.Parent do
			task.wait(math.random(5, 7))

			if destroyed or not model.Parent or not floor.Parent then
				break
			end

			local tpBall

			for _, obj in ipairs(model:GetDescendants()) do
				if obj:IsA("BasePart") and obj.Name == "TpBall" then
					tpBall = obj
					break
				end
			end

			if not tpBall then
				continue
			end

			local fadeIn = addTween(TweenService:Create(
				tpBall,
				TweenInfo.new(0.5, Enum.EasingStyle.Linear),
				{Transparency = 0}
			))

			fadeIn:Play()
			fadeIn.Completed:Wait()

			if destroyed or not model.Parent then
				break
			end

			local tp2

			for _, obj in ipairs(model:GetDescendants()) do
				if obj:IsA("Sound") and obj.Name == "Tp2" then
					tp2 = obj
					break
				end
			end

			if tp2 then
				tp2:Play()
			end

			local pivot = model:GetPivot()
			local currentPos = pivot.Position
			local targetPos

			local floorSize = floor.Size

			for _ = 1, 100 do
				if destroyed then
					break
				end

				local randomX = (math.random() - 0.5) * floorSize.X
				local randomZ = (math.random() - 0.5) * floorSize.Z

				local candidate = floor.CFrame:PointToWorldSpace(Vector3.new(
					randomX,
					floorSize.Y / 2 + 3,
					randomZ
				))

				local distance = (candidate - currentPos).Magnitude

				if distance >= 15 and distance <= 40 then
					targetPos = candidate
					break
				end
			end

			if targetPos and not destroyed then
				local targetCF = CFrame.new(targetPos) * pivot.Rotation

				local cfValue = Instance.new("CFrameValue")
				cfValue.Value = pivot
				cfValue.Parent = model

				local moveConnection = addConnection(
					cfValue:GetPropertyChangedSignal("Value"):Connect(function()
						if not destroyed and model.Parent then
							model:PivotTo(cfValue.Value)
						end
					end)
				)

				local moveTween = addTween(TweenService:Create(
					cfValue,
					TweenInfo.new(0.5, Enum.EasingStyle.Linear),
					{Value = targetCF}
				))

				moveTween:Play()
				moveTween.Completed:Wait()

				if moveConnection and moveConnection.Connected then
					moveConnection:Disconnect()
				end

				if cfValue and cfValue.Parent then
					cfValue:Destroy()
				end
			end

			if destroyed or not model.Parent then
				break
			end

			local fadeOut = addTween(TweenService:Create(
				tpBall,
				TweenInfo.new(0.5, Enum.EasingStyle.Linear),
				{Transparency = 1}
			))

			fadeOut:Play()
			fadeOut.Completed:Wait()
		end
	end)

	task.delay(10, function()
		if model and model.Parent and not destroyed then
			cleanup()
		end
	end)
end
