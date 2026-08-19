local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local GameData = ReplicatedStorage:WaitForChild("GameData")
local LatestRoom = GameData:WaitForChild("LatestRoom")

local player = Players.LocalPlayer

local url = "https://raw.githubusercontent.com/lynguyen26031993-design/-u/refs/heads/main/Place_17302962269_Model_1-A_1787159440.txt"

local success, data = pcall(function()
	return game:HttpGet(url)
end)

if not success or not data then
	warn("Không thể tải model!")
	return
end

local function GetGitSound(GithubSnd, SoundName)
	if not isfile(SoundName .. ".mp3") then
		writefile(SoundName .. ".mp3", game:HttpGet(GithubSnd))
	end

	local sound = Instance.new("Sound")
	sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".mp3")
	return sound
end

local hit = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/CB-1_audio_2.mp3.mpeg.mp3?raw=true",
	"fdujfghjjkkkkj"
)

hit.Volume = 1
hit.Name = "hit"
hit.PlaybackSpeed = 1
hit.RollOffMaxDistance = 120

local path = "1AModel.rbxm"
writefile(path, data)

local model = game:GetObjects(getcustomasset(path))[1]

if model then
	model.Parent = workspace

	local mainPart = model:FindFirstChildWhichIsA("BasePart", true)

	if not mainPart then
		model:Destroy()
		return
	end

	hit.Parent = mainPart

	local val = LatestRoom.Value
	local currentRoom = nil
	local currentRoomsFolder = workspace:FindFirstChild("CurrentRooms")

	if currentRoomsFolder then
		local targetStr = tostring(val)
		currentRoom = currentRoomsFolder:FindFirstChild(targetStr)

		if not currentRoom then
			for _, child in ipairs(currentRoomsFolder:GetChildren()) do
				if child:FindFirstChild("RoomEntrance") then
					currentRoom = child
					break
				end
			end
		end
	else
		warn("Không tìm thấy thư mục CurrentRooms trong Workspace!")
	end

	local spawnCFrame = nil
	local backwardDirection = nil

	if currentRoom then
		local entrance = currentRoom:FindFirstChild("RoomEntrance")

		if entrance then
			local pos = entrance.Position + entrance.CFrame.LookVector * 25

			spawnCFrame = CFrame.lookAt(
				pos,
				pos + entrance.CFrame.LookVector
			)

			backwardDirection = -entrance.CFrame.LookVector
		end
	end

	if spawnCFrame then
		if not model.PrimaryPart then
			model.PrimaryPart = mainPart
		end

		model:PivotTo(spawnCFrame)

		mainPart.CanQuery = true
		mainPart.CanTouch = true

		local overlapParams = OverlapParams.new()
		overlapParams.FilterType = Enum.RaycastFilterType.Include

		local images = {}
		local gradients = {}
		local glitchObjects = {}

		for _, obj in ipairs(model:GetDescendants()) do
			if obj:IsA("ImageLabel") then
				images[#images + 1] = {
					object = obj,
					position = obj.Position
				}
			end
		end

		for _, obj in ipairs(model:GetDescendants()) do
			if obj:IsA("UIGradient") and obj.Parent:IsA("ImageLabel") then
				gradients[#gradients + 1] = {
					object = obj
				}
			end
		end

		local t = 0
		local glitchTimer = 0.3

		local connection
		local tween
		local destroyed = false

		local entityMoving = false
		local retreating = false
		local damageTimer = 0

		local CHASE_SPEED = 20
		local DAMAGE_INTERVAL = 0.08
		local RETREAT_DISTANCE = 200
		local RETREAT_SPEED = 30

		local function clearGlitch()
			for i = #glitchObjects, 1, -1 do
				local obj = glitchObjects[i]

				if obj and obj.Parent then
					obj:Destroy()
				end

				table.remove(glitchObjects, i)
			end
		end

		local function createGlitch(image)
			if not image or not image.Parent then
				return
			end

			local absSize = image.AbsoluteSize

			if absSize.X <= 1 or absSize.Y <= 2 then
				return
			end

			local parent = image.Parent

			local minSplit = math.max(1, math.floor(absSize.Y * 0.25))
			local maxSplit = math.max(minSplit, math.floor(absSize.Y * 0.75))

			local splitY = math.random(minSplit, maxSplit)

			local topHeight = splitY
			local bottomHeight = absSize.Y - splitY

			local offset = math.random(3, 10)

			local topFrame = Instance.new("Frame")
			topFrame.Name = "GlitchTop"
			topFrame.BackgroundTransparency = 1
			topFrame.BorderSizePixel = 0
			topFrame.ClipsDescendants = true
			topFrame.ZIndex = image.ZIndex + 5
			topFrame.AnchorPoint = image.AnchorPoint
			topFrame.Position = image.Position
			topFrame.Size = UDim2.fromOffset(
				absSize.X,
				topHeight
			)
			topFrame.Parent = parent

			local topImage = image:Clone()
			topImage.Name = "GlitchImage"
			topImage.AnchorPoint = Vector2.zero
			topImage.Position = UDim2.fromOffset(
				-offset,
				0
			)
			topImage.Size = UDim2.fromOffset(
				absSize.X,
				absSize.Y
			)
			topImage.ZIndex = topFrame.ZIndex
			topImage.Parent = topFrame

			local bottomFrame = Instance.new("Frame")
			bottomFrame.Name = "GlitchBottom"
			bottomFrame.BackgroundTransparency = 1
			bottomFrame.BorderSizePixel = 0
			bottomFrame.ClipsDescendants = true
			bottomFrame.ZIndex = image.ZIndex + 5
			bottomFrame.AnchorPoint = image.AnchorPoint
			bottomFrame.Position = UDim2.new(
				image.Position.X.Scale,
				image.Position.X.Offset,
				image.Position.Y.Scale,
				image.Position.Y.Offset + splitY
			)
			bottomFrame.Size = UDim2.fromOffset(
				absSize.X,
				bottomHeight
			)
			bottomFrame.Parent = parent

			local bottomImage = image:Clone()
			bottomImage.Name = "GlitchImage"
			bottomImage.AnchorPoint = Vector2.zero
			bottomImage.Position = UDim2.fromOffset(
				offset,
				-splitY
			)
			bottomImage.Size = UDim2.fromOffset(
				absSize.X,
				absSize.Y
			)
			bottomImage.ZIndex = bottomFrame.ZIndex
			bottomImage.Parent = bottomFrame

			glitchObjects[#glitchObjects + 1] = topFrame
			glitchObjects[#glitchObjects + 1] = bottomFrame

			task.delay(math.random(3, 8) / 100, function()
				if topFrame and topFrame.Parent then
					topFrame:Destroy()
				end

				if bottomFrame and bottomFrame.Parent then
					bottomFrame:Destroy()
				end
			end)
		end

		local function doGlitch()
			if destroyed or retreating then
				return
			end

			if #images == 0 then
				return
			end

			local amount = math.random(
				1,
				math.min(3, #images)
			)

			for _ = 1, amount do
				local info = images[math.random(1, #images)]

				if info.object and info.object.Parent then
					createGlitch(info.object)
				end
			end
		end

		local function setDeathCause()
			local stats = ReplicatedStorage.GameStats:FindFirstChild(
				"Player_" .. player.Name
			)

			if stats and stats:FindFirstChild("Total") then
				local deathCause = stats.Total:FindFirstChild("DeathCause")

				if deathCause then
					deathCause.Value = "1-A"
				end
			end
		end

		local function cleanup()
			if destroyed then
				return
			end

			destroyed = true
			entityMoving = false
			retreating = true

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if tween then
				tween:Cancel()
				tween = nil
			end

			clearGlitch()

			table.clear(images)
			table.clear(gradients)
			table.clear(glitchObjects)

			if model and model.Parent then
				model:Destroy()
			end

			model = nil
			currentRoom = nil
			currentRoomsFolder = nil
			spawnCFrame = nil
			backwardDirection = nil
		end

		local function startRetreat()
			if destroyed or retreating then
				return
			end

			retreating = true
			entityMoving = false
			damageTimer = 0

			if not mainPart or not mainPart.Parent then
				cleanup()
				return
			end

			local startCFrame = mainPart.CFrame

			local targetPosition =
				startCFrame.Position
				+ backwardDirection * RETREAT_DISTANCE

			local targetCFrame = CFrame.new(
				targetPosition
			) * startCFrame.Rotation

			local duration = RETREAT_DISTANCE / RETREAT_SPEED

			tween = TweenService:Create(
				mainPart,
				TweenInfo.new(
					duration,
					Enum.EasingStyle.Linear,
					Enum.EasingDirection.Out
				),
				{
					CFrame = targetCFrame
				}
			)

			tween.Completed:Once(function()
				cleanup()
			end)

			tween:Play()
		end

		connection = RunService.RenderStepped:Connect(function(dt)
			if destroyed or not model or not model.Parent then
				cleanup()
				return
			end

			t += dt

			if not retreating then
				glitchTimer -= dt

				if glitchTimer <= 0 then
					doGlitch()
					glitchTimer = 0.03
				end
			end

			for _, info in ipairs(gradients) do
				if info.object and info.object.Parent then
					info.object.Rotation = (
						info.object.Rotation + dt * 280
					) % 360
				end
			end

			local shakeX = math.noise(t * 100, 0, 0) * 0.15
			local shakeY = math.noise(0, t * 100, 0) * 0.15

			for _, info in ipairs(images) do
				if info.object and info.object.Parent then
					info.object.Position = UDim2.new(
						info.position.X.Scale + shakeX,
						info.position.X.Offset,
						info.position.Y.Scale + shakeY,
						info.position.Y.Offset
					)
				end
			end

			if retreating then
				return
			end

			local character = player.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			local hrp = character and character:FindFirstChild("HumanoidRootPart")

			if not character or not humanoid or not hrp or humanoid.Health <= 0 then
				return
			end

			local hiding = character:GetAttribute("Hiding") == true

			if entityMoving and hiding then
				startRetreat()
				return
			end

			if not entityMoving then
				return
			end

			local targetPosition = hrp.Position
			local currentPosition = mainPart.Position

			local direction = targetPosition - currentPosition
			local distance = direction.Magnitude

			if distance > 0.001 then
				local movement = math.min(
					CHASE_SPEED * dt,
					distance
				)

				local newPosition =
					currentPosition
					+ direction.Unit * movement

				local lookDirection = direction.Unit

				mainPart.CFrame = CFrame.lookAt(
					newPosition,
					newPosition + lookDirection
				)
			end

			overlapParams.FilterDescendantsInstances = {
				character
			}

			local touching = workspace:GetPartBoundsInBox(
				mainPart.CFrame,
				mainPart.Size,
				overlapParams
			)

			local touchingNow = #touching > 0

			if not touchingNow then
				damageTimer = 0
				return
			end

			if damageTimer > 0 then
				damageTimer -= dt
			end

			if damageTimer <= 0 then
				damageTimer = DAMAGE_INTERVAL

				if not hiding then
					humanoid:TakeDamage(1)
					local hitClone = hit:Clone()
hitClone.Parent = mainPart
hitClone:Play()

task.delay(1, function()
	if hitClone and hitClone.Parent then
		hitClone:Destroy()
	end
end)
					setDeathCause()
				end
			end
		end)

		task.delay(6, function()
			if destroyed or not model or not model.Parent then
				cleanup()
				return
			end

			if not mainPart or not mainPart.Parent then
				cleanup()
				return
			end

			entityMoving = true
			retreating = false
		end)
	else
		warn("Không tìm thấy RoomEntrance hợp lệ trong CurrentRooms!")
		model:Destroy()
	end
end
