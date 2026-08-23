local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local GameData = ReplicatedStorage:WaitForChild("GameData")
local LatestRoom = GameData:WaitForChild("LatestRoom")

local player = Players.LocalPlayer

local url = "https://raw.githubusercontent.com/iccdjkkkkskskhdgdgegvbfbgncjjdudejdjvi/RLD-Entity-Models/refs/heads/main/Place_17302962269_Model_GL-1_1787484675.txt"

local success, data = pcall(function()
	return game:HttpGet(url)
end)

if not success or not data then
	warn("Không thể tải model!")
	return
end

local function GetGitSound(GithubSnd, SoundName)
	local url = GithubSnd

	if not isfile(SoundName .. ".mp3") then
		writefile(SoundName .. ".mp3", game:HttpGet(url))
	end

	local sound = Instance.new("Sound")
	sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".mp3")
	return sound
end

local hit = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/A1NewestHit.mp3.mpeg.mp3?raw=true",
	"kcjjjkkcc"
)

hit.Volume = 1
hit.Name = "hit"
hit.PlaybackSpeed = 0.7
hit.Pitch = 0.9
hit.RollOffMaxDistance = 120

local path = "GL1Model.rbxm"
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

	if currentRoom then
		local entrance = currentRoom:FindFirstChild("RoomEntrance")

		if entrance then
			local pos = entrance.Position + entrance.CFrame.LookVector * 25

			spawnCFrame = CFrame.lookAt(
				pos,
				pos + entrance.CFrame.LookVector
			)
		end
	end

	if spawnCFrame then
		if not model.PrimaryPart then
			model.PrimaryPart = mainPart
		end

		model:PivotTo(spawnCFrame)

		local hitbox = Instance.new("Part")
		hitbox.Name = "DamageHitbox"
		hitbox.Size = Vector3.new(20, 20, 20)
		hitbox.Transparency = 1
		hitbox.CanCollide = false
		hitbox.CanTouch = false
		hitbox.CanQuery = true
		hitbox.Anchored = false
		hitbox.Massless = true
		hitbox.CFrame = mainPart.CFrame
		hitbox.Parent = model

		local weld = Instance.new("WeldConstraint")
		weld.Part0 = hitbox
		weld.Part1 = mainPart
		weld.Parent = hitbox

		local overlapParams = OverlapParams.new()
		overlapParams.FilterType = Enum.RaycastFilterType.Include

		local rayParams = RaycastParams.new()
		rayParams.FilterType = Enum.RaycastFilterType.Exclude
		rayParams.IgnoreWater = true

		local images = {}

		for _, obj in ipairs(model:GetDescendants()) do
			if obj:IsA("ImageLabel") then
				images[#images + 1] = {
					object = obj,
					position = obj.Position
				}
			end
		end

		local staticSounds = {}

		for _, obj in ipairs(model:GetDescendants()) do
			if obj:IsA("Sound") and obj.Name == "Static" then
				staticSounds[#staticSounds + 1] = obj
			end
		end
		
		local glitchParticles = {}

for _, obj in ipairs(model:GetDescendants()) do
	if obj:IsA("ParticleEmitter") and obj.Name == "Glitch" then
		glitchParticles[#glitchParticles + 1] = obj
	end
end

local monsterImage
local originalImageId
local originalImageSize
local originalImagePosition
local originalAnchorPoint

local particleEmitters = {}

for _, obj in ipairs(model:GetDescendants()) do
	if obj:IsA("BillboardGui") and obj.Name == "MonsterGui" then
		local image = obj:FindFirstChildWhichIsA("ImageLabel", true)

		if image then
			monsterImage = image
			originalImageId = image.Image
			originalImageSize = image.Size
			originalImagePosition = image.Position
			originalAnchorPoint = image.AnchorPoint
			break
		end
	end
end

for _, obj in ipairs(model:GetDescendants()) do
	if obj:IsA("Attachment") and obj.Name == "Particles" then
		for _, child in ipairs(obj:GetDescendants()) do
			if child:IsA("ParticleEmitter") then
				particleEmitters[#particleEmitters + 1] = {
					object = child,
					texture = child.Texture
				}
			end
		end
	end
end

local glitchImageIds = {
	"102015926629006",
	"103461735497312",
	"80787637924081",
	"137683325314229",
	"86865648013781",
	"71396457363539",
	"133969765809290",
	"105722016962947",
	"134145910233866",
	"79158971867084",
	"100271044614291",
	"123721882441865",
	"90259853185430",
	"71809806302496",
	"118023415365146"
}

local imageGlitching = false
local imageGlitchThread

local function getImageCenter()
	if not monsterImage then
		return nil
	end

	local pos = monsterImage.Position
	local size = monsterImage.Size
	local anchor = monsterImage.AnchorPoint

	return UDim2.new(
		pos.X.Scale + size.X.Scale * (0.5 - anchor.X),
		pos.X.Offset + size.X.Offset * (0.5 - anchor.X),
		pos.Y.Scale + size.Y.Scale * (0.5 - anchor.Y),
		pos.Y.Offset + size.Y.Offset * (0.5 - anchor.Y)
	)
end

local originalCenter = getImageCenter()

local function setImageScale(scale)
	if not monsterImage or not monsterImage.Parent then
		return
	end

	local newSize = UDim2.new(
		originalImageSize.X.Scale * scale,
		originalImageSize.X.Offset * scale,
		originalImageSize.Y.Scale * scale,
		originalImageSize.Y.Offset * scale
	)

	monsterImage.Size = newSize

	if originalCenter then
		monsterImage.Position = UDim2.new(
			originalCenter.X.Scale - newSize.X.Scale * (0.5 - originalAnchorPoint.X),
			originalCenter.X.Offset - newSize.X.Offset * (0.5 - originalAnchorPoint.X),
			originalCenter.Y.Scale - newSize.Y.Scale * (0.5 - originalAnchorPoint.Y),
			originalCenter.Y.Offset - newSize.Y.Offset * (0.5 - originalAnchorPoint.Y)
		)
	end
end

local function startImageGlitch()
	if imageGlitching then
		return
	end

	if not monsterImage and #particleEmitters == 0 then
		return
	end

	imageGlitching = true

	imageGlitchThread = task.spawn(function()
		while imageGlitching and not destroyed do
			local imageId =
				"rbxassetid://" ..
				glitchImageIds[math.random(1, #glitchImageIds)]

			if monsterImage and monsterImage.Parent then
				monsterImage.Image = imageId

				local scale = math.random(100, 200) / 100
				setImageScale(scale)
			end

			for _, info in ipairs(particleEmitters) do
				if info.object and info.object.Parent then
					info.object.Texture = imageId
				end
			end

			task.wait(0.05)
		end
	end)
end

local function stopImageGlitch()
	imageGlitching = false

	if monsterImage and monsterImage.Parent then
		monsterImage.Image = originalImageId
		monsterImage.Size = originalImageSize
		monsterImage.Position = originalImagePosition
		monsterImage.AnchorPoint = originalAnchorPoint
	end

	for _, info in ipairs(particleEmitters) do
		if info.object and info.object.Parent then
			info.object.Texture = info.texture
		end
	end

	imageGlitchThread = nil
end

		local t = 0
		local connection
		local tween
		local reverseTween

		local destroyed = false
		local entityMoving = false
		local reversing = false

		local insideHitbox = false
		local damageCooldown = 0

		local forwardDirection
		local finalPosition

		local function playStatic()
			for _, sound in ipairs(staticSounds) do
				if sound and sound.Parent then
					sound:Play()
				end
			end
		end

		local function stopStatic()
			for _, sound in ipairs(staticSounds) do
				if sound and sound.Parent then
					sound:Stop()
				end
			end
		end

		local function cleanup()
			if destroyed then
				return
			end

			destroyed = true
			entityMoving = false
			reversing = false

			stopStatic()

			if connection then
				connection:Disconnect()
				connection = nil
			end
			
			stopImageGlitch()
			
			for _, particle in ipairs(glitchParticles) do
	if particle and particle.Parent then
		particle.Enabled = false
	end
end

table.clear(glitchParticles)

			if tween then
				tween:Cancel()
				tween = nil
			end

			if reverseTween then
				reverseTween:Cancel()
				reverseTween = nil
			end

			table.clear(images)
			table.clear(staticSounds)

			if model and model.Parent then
				model:Destroy()
			end

			model = nil
			currentRoom = nil
			currentRoomsFolder = nil
			spawnCFrame = nil
		end

		connection = RunService.RenderStepped:Connect(function(dt)
			if destroyed or not model or not model.Parent then
				cleanup()
				return
			end

			t += dt

			local shakeX = math.noise(t * 55, 0, 0) * 0.025
			local shakeY = math.noise(0, t * 55, 0) * 0.025

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

			if not entityMoving or reversing then
				insideHitbox = false
				damageCooldown = 0
				return
			end

			local character = player.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			local hrp = character and character:FindFirstChild("HumanoidRootPart")

			if not character or not humanoid or not hrp or humanoid.Health <= 0 then
				insideHitbox = false
				damageCooldown = 0
				return
			end

			overlapParams.FilterDescendantsInstances = {character}

			local touching = workspace:GetPartBoundsInBox(
				hitbox.CFrame,
				hitbox.Size,
				overlapParams
			)

			local touchingNow = #touching > 0
			local hiding = character:GetAttribute("Hiding") == true

			if not touchingNow then
				insideHitbox = false
				damageCooldown = 0
				return
			end

			rayParams.FilterDescendantsInstances = {
				model,
				character
			}

			local direction = hrp.Position - hitbox.Position

			local result = workspace:Raycast(
				hitbox.Position,
				direction,
				rayParams
			)

			local visible = result == nil

			if not visible then
				return
			end

			if not insideHitbox then
				insideHitbox = true
				damageCooldown = 1

				if not hiding then
					humanoid:TakeDamage(30)
					hit:Play()

					game.ReplicatedStorage.GameStats[
						"Player_" .. game.Players.LocalPlayer.Name
					].Total.DeathCause.Value = "GL-1"
				end

				return
			end

			if damageCooldown > 0 then
				damageCooldown -= dt
			end

			if damageCooldown <= 0 then
				damageCooldown = 1

				if not hiding then
					humanoid:TakeDamage(30)
					hit:Play()

					game.ReplicatedStorage.GameStats[
						"Player_" .. game.Players.LocalPlayer.Name
					].Total.DeathCause.Value = "GL-1"
				end
			end
		end)

		task.delay(3, function()
			if destroyed or not model or not model.Parent then
				cleanup()
				return
			end

			local part = mainPart

			if not part or not part.Parent then
				cleanup()
				return
			end

			local startCFrame = part.CFrame

			forwardDirection = -startCFrame.LookVector

			local distance = 200
			local speed = 16

			finalPosition =
				startCFrame.Position +
				forwardDirection * distance

			local function createForwardTween()
				if destroyed or not part or not part.Parent then
					return
				end

				local currentPosition = part.Position

				local remainingDistance =
					(finalPosition - currentPosition):Dot(forwardDirection)

				if remainingDistance <= 0 then
					cleanup()
					return
				end

				local duration = remainingDistance / speed

				local targetCFrame =
					CFrame.new(finalPosition) *
					part.CFrame.Rotation

				tween = TweenService:Create(
					part,
					TweenInfo.new(
						duration,
						Enum.EasingStyle.Linear,
						Enum.EasingDirection.Out
					),
					{
						CFrame = targetCFrame
					}
				)

				tween.Completed:Once(function(state)
					if state == Enum.PlaybackState.Completed then
						cleanup()
					end
				end)

				tween:Play()
			end

			entityMoving = true
			createForwardTween()

			task.spawn(function()
				while not destroyed and model and model.Parent and entityMoving do
					task.wait(math.random(10, 20) / 10)

					if destroyed or not model or not model.Parent or not entityMoving then
						break
					end

					if reversing then
						continue
					end

					reversing = true

					if tween then
						tween:Cancel()
						tween = nil
					end

					playStatic()
					
					task.spawn(function() 
					startImageGlitch()
					end) 
					
					for _, particle in ipairs(glitchParticles) do
	if particle and particle.Parent then
		particle.Enabled = true
	end
end

					local currentCFrame = part.CFrame

					local backwardDirection = -forwardDirection

					local distanceBack = math.random(8, 15)
					local reverseDuration = math.random(2, 5) / 10

					local reversePosition =
						currentCFrame.Position +
						backwardDirection * distanceBack

					local reverseCFrame =
						CFrame.new(reversePosition) *
						currentCFrame.Rotation

					reverseTween = TweenService:Create(
						part,
						TweenInfo.new(
							reverseDuration,
							Enum.EasingStyle.Linear,
							Enum.EasingDirection.Out
						),
						{
							CFrame = reverseCFrame
						}
					)

					reverseTween.Completed:Once(function(state)
						reverseTween = nil

						if state ~= Enum.PlaybackState.Completed then
							return
						end

						if destroyed or not model or not model.Parent then
							return
						end

						stopStatic()

for _, particle in ipairs(glitchParticles) do
	if particle and particle.Parent then
		particle.Enabled = false
	end
end

stopImageGlitch()

reversing = false

createForwardTween()
					end)

					reverseTween:Play()

					while reversing and not destroyed and model and model.Parent do
						task.wait()
					end
				end
			end)
		end)
	else
		warn("Không tìm thấy RoomEntrance hợp lệ trong CurrentRooms!")
		model:Destroy()
	end
end
