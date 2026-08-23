local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local GameData = ReplicatedStorage:WaitForChild("GameData")
local LatestRoom = GameData:WaitForChild("LatestRoom")

local player = Players.LocalPlayer

local url = "https://raw.githubusercontent.com/iccdjkkkkskskhdgdgegvbfbgncjjdudejdjvi/RLD-Entity-Models/refs/heads/main/Place_17302962269_Model_SP-1_1787465482.txt"

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
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/SP-1_Split.mp3.mpeg.mp3?raw=true",
	"kcjhjkalolokx"
)

hit.Volume = 2
hit.Name = "hit"
hit.PlaybackSpeed = 1.3
hit.RollOffMaxDistance = 120

local split = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/SP-1_Split.mp3.mpeg.mp3?raw=true",
	"kcjhjkalolokx"
)

split.Volume = 3
split.Name = "split"
split.PlaybackSpeed = 1
split.RollOffMaxDistance = 120

local path = "SP1Model.rbxm"
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
	split.Parent = mainPart

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
		hitbox.Size = Vector3.new(15, 15, 15)
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
		
		local redSplitHitbox
local blueSplitHitbox

local splitHitboxDamageCooldown = 0
local splitHitboxInside = false
local splitHitboxesActive = false

local function destroySplitHitboxes()
	splitHitboxesActive = false
	splitHitboxInside = false
	splitHitboxDamageCooldown = 0

	if redSplitHitbox then
		redSplitHitbox:Destroy()
		redSplitHitbox = nil
	end

	if blueSplitHitbox then
		blueSplitHitbox:Destroy()
		blueSplitHitbox = nil
	end

	if hitbox and hitbox.Parent then
		hitbox.CanQuery = true
	end
end

local function createSplitHitboxes()
	destroySplitHitboxes()

	splitHitboxesActive = true

	if hitbox and hitbox.Parent then
		hitbox.CanQuery = false
	end

	redSplitHitbox = Instance.new("Part")
	redSplitHitbox.Name = "RedSplitHitbox"
	redSplitHitbox.Size = Vector3.new(7, 7, 7)
	redSplitHitbox.Transparency = 1
	redSplitHitbox.CanCollide = false
	redSplitHitbox.CanTouch = false
	redSplitHitbox.CanQuery = true
	redSplitHitbox.Anchored = true
	redSplitHitbox.Parent = model

	blueSplitHitbox = Instance.new("Part")
	blueSplitHitbox.Name = "BlueSplitHitbox"
	blueSplitHitbox.Size = Vector3.new(7, 7, 7)
	blueSplitHitbox.Transparency = 1
	blueSplitHitbox.CanCollide = false
	blueSplitHitbox.CanTouch = false
	blueSplitHitbox.CanQuery = true
	blueSplitHitbox.Anchored = true
	blueSplitHitbox.Parent = model
end

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
		
		local spotlights = {}

for _, obj in ipairs(model:GetDescendants()) do
	if obj:IsA("SpotLight") then
		local parent = obj.Parent

		if parent and parent:IsA("Attachment") then
			spotlights[#spotlights + 1] = {
				attachment = parent,
				cframe = parent.CFrame
			}
		end
	end
end

local redSpotlight
local blueSpotlight

for _, obj in ipairs(model:GetDescendants()) do
	if obj:IsA("SpotLight") then
		if obj.Name == "red" then
			redSpotlight = obj
		elseif obj.Name == "blue" then
			blueSpotlight = obj
		end
	end
end

local spotlightRotation = 0

		local t = 0
		local connection
		local tween
		local destroyed = false
		local rotationTime = 0
local currentRotation = 0
local targetRotation = 0

		local entityMoving = false
local insideHitbox = false
local damageCooldown = 0

local effectCooldown = 0
local effectTriggered = false

local redGui
local blueGui

local redParticleAttachment
local blueParticleAttachment

local redStartOffset
local blueStartOffset

local splitMergeCooldown = 0
local splitMerging = false
local splitMergeFinished = false

local splitMergeDistance = 0.05

local splitFollowSpeed = 8
local mergeFollowSpeed = 5
local splitDistance = 7

local redStartWorldY
local blueStartWorldY

local splitCooldownTime = 3
local splitMergeTime = 8
splitMergeFinished = false

local function playDropParticles()
	if destroyed or not model or not model.Parent then
		return
	end

split:Play() 

	for _, obj in ipairs(model:GetDescendants()) do
		if obj:IsA("ParticleEmitter")
			and string.find(obj.Name:lower(), "drop", 1, true) then

			obj.Enabled = true

			task.delay(0.5, function()
				if obj and obj.Parent then
					obj.Enabled = false
				end
			end)
		end
	end
end

		local function cleanup()
			if destroyed then
				return
			end

redGui = nil
blueGui = nil
redStartOffset = nil
blueStartOffset = nil
redParticleAttachment = nil
blueParticleAttachment = nil

splitMergeCooldown = 0
splitMerging = false


			destroyed = true
			entityMoving = false
			effectCooldown = 0
effectTriggered = false
redStartWorldY = nil
blueStartWorldY = nil

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if tween then
				tween:Cancel()
				tween = nil
			end
			
			destroySplitHitboxes()

			table.clear(images)
			table.clear(spotlights)

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
	rotationTime += dt

	local shakeX = math.noise(t * 55, 0, 0) * 0.05
	local shakeY = math.noise(0, t * 55, 0) * 0.05

	if rotationTime >= 0.12 then
		rotationTime = 0
		targetRotation = math.random(-4, 4)
	end

	currentRotation +=
		(targetRotation - currentRotation) *
		math.clamp(dt * 10, 0, 1)

	for _, info in ipairs(images) do
		if info.object and info.object.Parent then
			info.object.Position = UDim2.new(
				info.position.X.Scale + shakeX,
				info.position.X.Offset,
				info.position.Y.Scale + shakeY,
				info.position.Y.Offset
			)

			info.object.Rotation = currentRotation
		end
	end
	
	spotlightRotation += dt * (math.pi * 2 / 10)

if spotlightRotation >= math.pi * 2 then
	spotlightRotation -= math.pi * 2
end

local spotlightAngle = -spotlightRotation

for _, info in ipairs(spotlights) do
	if info.attachment and info.attachment.Parent then
		info.attachment.CFrame =
			info.cframe * CFrame.Angles(0, spotlightAngle, 0)
	end
end

	if not entityMoving then
	insideHitbox = false
	damageCooldown = 0
	return
end

if not effectTriggered then
	effectCooldown += dt

	if effectCooldown >= splitCooldownTime then
	effectCooldown = 0
	effectTriggered = true

createSplitHitboxes()

task.spawn(function() 
	playDropParticles()
end)

	splitMergeCooldown = 0
	splitMerging = false
	splitMergeFinished = false

		for _, obj in ipairs(model:GetDescendants()) do
			if obj:IsA("ImageLabel") then
				local gui = obj:FindFirstAncestorOfClass("BillboardGui")

				if gui then
					if gui.Name == "MonsterGui" then
						obj.Visible = false

					elseif gui.Name == "RedSplit" then
						gui.Enabled = true
						obj.Visible = true
						redGui = gui

					elseif gui.Name == "BlueSplit" then
						gui.Enabled = true
						obj.Visible = true
						blueGui = gui
					end
				end

			elseif obj:IsA("ParticleEmitter") then
	local attachment = obj.Parent

	if attachment and attachment:IsA("Attachment") then
		if attachment.Name == "Rings" then
			obj.Enabled = false

		elseif attachment.Name == "RedSplitParticle" then
			obj.Enabled = true
			redParticleAttachment = attachment

		elseif attachment.Name == "BlueSplitParticle" then
			obj.Enabled = true
			blueParticleAttachment = attachment
		end
	end
end
		end

		if redGui then
	redStartOffset = redGui.StudsOffsetWorldSpace

	local parent = redGui.Adornee or redGui.Parent
	if parent and parent:IsA("BasePart") then
		redStartWorldY = parent.Position.Y + redGui.StudsOffsetWorldSpace.Y
	end
end

if blueGui then
	blueStartOffset = blueGui.StudsOffsetWorldSpace

	local parent = blueGui.Adornee or blueGui.Parent
	if parent and parent:IsA("BasePart") then
		blueStartWorldY = parent.Position.Y + blueGui.StudsOffsetWorldSpace.Y
	end
end
	end
end

if effectTriggered and not splitMergeFinished then
	local alpha = math.clamp(dt * splitFollowSpeed, 0, 1)

	splitMergeCooldown += dt
	
		if splitHitboxesActive then
		if redSplitHitbox
			and redSplitHitbox.Parent
			and redGui
			and redGui.Parent then

			local parent = redGui.Adornee or redGui.Parent

			if parent and parent:IsA("BasePart") then
				local worldPos =
					parent.Position + redGui.StudsOffsetWorldSpace

				redSplitHitbox.CFrame =
					CFrame.new(worldPos)
			end
		end

		if blueSplitHitbox
			and blueSplitHitbox.Parent
			and blueGui
			and blueGui.Parent then

			local parent = blueGui.Adornee or blueGui.Parent

			if parent and parent:IsA("BasePart") then
				local worldPos =
					parent.Position + blueGui.StudsOffsetWorldSpace

				blueSplitHitbox.CFrame =
					CFrame.new(worldPos)
			end
		end
	end

	if splitMergeCooldown < splitMergeTime then

		if redGui and redGui.Parent and redSpotlight and redSpotlight.Parent then
			local attachment = redSpotlight.Parent

			if attachment:IsA("Attachment") then
				local right = attachment.WorldCFrame.RightVector
				local targetWorldPos =
					attachment.WorldPosition + right * splitDistance

				local parent = redGui.Adornee or redGui.Parent

				if parent and parent:IsA("BasePart") and redStartWorldY then
					local currentWorldPos =
						parent.Position + redGui.StudsOffsetWorldSpace

					local targetPos = Vector3.new(
						targetWorldPos.X,
						redStartWorldY,
						targetWorldPos.Z
					)

					local newWorldPos = currentWorldPos:Lerp(
						targetPos,
						alpha
					)

					redGui.StudsOffsetWorldSpace =
						newWorldPos - parent.Position
				end
			end
		end

		if blueGui and blueGui.Parent and blueSpotlight and blueSpotlight.Parent then
			local attachment = blueSpotlight.Parent

			if attachment:IsA("Attachment") then
				local right = attachment.WorldCFrame.RightVector
				local targetWorldPos =
					attachment.WorldPosition - right * splitDistance

				local parent = blueGui.Adornee or blueGui.Parent

				if parent and parent:IsA("BasePart") and blueStartWorldY then
					local currentWorldPos =
						parent.Position + blueGui.StudsOffsetWorldSpace

					local targetPos = Vector3.new(
						targetWorldPos.X,
						blueStartWorldY,
						targetWorldPos.Z
					)

					local newWorldPos = currentWorldPos:Lerp(
						targetPos,
						alpha
					)

					blueGui.StudsOffsetWorldSpace =
						newWorldPos - parent.Position
				end
			end
		end

	else
		splitMerging = true
	end

	if splitMerging then
		local redParent = redGui and (redGui.Adornee or redGui.Parent)
		local blueParent = blueGui and (blueGui.Adornee or blueGui.Parent)

		if redParent
			and blueParent
			and redParent:IsA("BasePart")
			and blueParent:IsA("BasePart") then

			local redWorldPos =
				redParent.Position + redGui.StudsOffsetWorldSpace

			local blueWorldPos =
				blueParent.Position + blueGui.StudsOffsetWorldSpace

			local distance =
				(redWorldPos - blueWorldPos).Magnitude

			if distance <= splitMergeDistance then
				local midpoint =
					(redWorldPos + blueWorldPos) / 2

				redGui.StudsOffsetWorldSpace =
					midpoint - redParent.Position

				blueGui.StudsOffsetWorldSpace =
					midpoint - blueParent.Position

				splitMerging = false
				splitMergeFinished = true
				
				destroySplitHitboxes()

				if redParticleAttachment then
					redParticleAttachment.WorldPosition = midpoint
				end

				if blueParticleAttachment then
					blueParticleAttachment.WorldPosition = midpoint
				end
				
				task.spawn(function() 
	playDropParticles()
	end) 
				
				effectTriggered = false
effectCooldown = 0
splitMergeCooldown = 0
splitMerging = false
splitMergeFinished = false

				for _, obj in ipairs(model:GetDescendants()) do
					if obj:IsA("ImageLabel") then
						local gui =
							obj:FindFirstAncestorOfClass("BillboardGui")

						if gui then
							if gui.Name == "MonsterGui" then
								obj.Visible = true

							elseif gui.Name == "RedSplit" then
								gui.Enabled = false
								obj.Visible = true
								redGui = gui

							elseif gui.Name == "BlueSplit" then
								gui.Enabled = false
								obj.Visible = true
								blueGui = gui
							end
						end

					elseif obj:IsA("ParticleEmitter") then
						local attachment = obj.Parent

						if attachment and attachment:IsA("Attachment") then
							if attachment.Name == "Rings" then
								obj.Enabled = true

							elseif attachment.Name == "RedSplitParticle" then
								obj.Enabled = false
								redParticleAttachment = attachment

							elseif attachment.Name == "BlueSplitParticle" then
								obj.Enabled = false
								blueParticleAttachment = attachment
							end
						end
					end
				end
			else
				local distance = (redWorldPos - blueWorldPos).Magnitude

local minMergeSpeed = 5
local maxMergeSpeed = 18

local distanceAlpha = math.clamp(
	1 - (distance / splitDistance),
	0,
	1
)

local mergeSpeed = minMergeSpeed + (maxMergeSpeed - minMergeSpeed) * distanceAlpha

local mergeAlpha = math.clamp(
	dt * mergeSpeed,
	0,
	1
)

local newRedWorldPos = redWorldPos:Lerp(
	blueWorldPos,
	mergeAlpha
)

local newBlueWorldPos = blueWorldPos:Lerp(
	redWorldPos,
	mergeAlpha
)

				newRedWorldPos = Vector3.new(
					newRedWorldPos.X,
					redStartWorldY,
					newRedWorldPos.Z
				)

				newBlueWorldPos = Vector3.new(
					newBlueWorldPos.X,
					blueStartWorldY,
					newBlueWorldPos.Z
				)

				redGui.StudsOffsetWorldSpace =
					newRedWorldPos - redParent.Position

				blueGui.StudsOffsetWorldSpace =
					newBlueWorldPos - blueParent.Position
			end
		end
	end

	if not splitMergeFinished then
	if redParticleAttachment
		and redParticleAttachment.Parent
		and redGui
		and redGui.Parent then

		local parent = redGui.Adornee or redGui.Parent

		if parent and parent:IsA("BasePart") then
			local billboardWorldPos =
				parent.Position + redGui.StudsOffsetWorldSpace

			redParticleAttachment.WorldPosition =
				billboardWorldPos
		end
	end

	if blueParticleAttachment
		and blueParticleAttachment.Parent
		and blueGui
		and blueGui.Parent then

		local parent = blueGui.Adornee or blueGui.Parent

		if parent and parent:IsA("BasePart") then
			local billboardWorldPos =
				parent.Position + blueGui.StudsOffsetWorldSpace

			blueParticleAttachment.WorldPosition =
				billboardWorldPos
		end
	end
end
end

	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local hrp = character and character:FindFirstChild("HumanoidRootPart")

if splitHitboxesActive then
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if not character or not humanoid or humanoid.Health <= 0 then
		splitHitboxInside = false
		splitHitboxDamageCooldown = 0
	else
		overlapParams.FilterDescendantsInstances = {character}

		local touchingRed = false
		local touchingBlue = false

		if redSplitHitbox and redSplitHitbox.Parent then
			touchingRed =
				#workspace:GetPartBoundsInBox(
					redSplitHitbox.CFrame,
					redSplitHitbox.Size,
					overlapParams
				) > 0
		end

		if blueSplitHitbox and blueSplitHitbox.Parent then
			touchingBlue =
				#workspace:GetPartBoundsInBox(
					blueSplitHitbox.CFrame,
					blueSplitHitbox.Size,
					overlapParams
				) > 0
		end

		local touchingSplitHitbox =
			touchingRed or touchingBlue

		local hiding =
			character:GetAttribute("Hiding") == true

		if not touchingSplitHitbox then
			splitHitboxInside = false
			splitHitboxDamageCooldown = 0
		else
			if not splitHitboxInside then
				splitHitboxInside = true
				splitHitboxDamageCooldown = 3

				if not hiding then
					humanoid:TakeDamage(15)
					hit:Play()

					game.ReplicatedStorage.GameStats[
						"Player_" .. game.Players.LocalPlayer.Name
					].Total.DeathCause.Value = "SP-1"
				end
			else
				if splitHitboxDamageCooldown > 0 then
					splitHitboxDamageCooldown -= dt
				end

				if splitHitboxDamageCooldown <= 0 then
					splitHitboxDamageCooldown = 3

					if not hiding then
						humanoid:TakeDamage(15)
						hit:Play()

						game.ReplicatedStorage.GameStats[
							"Player_" .. game.Players.LocalPlayer.Name
						].Total.DeathCause.Value = "SP-1"
					end
				end
			end
		end
	end
end

	if not character or not humanoid or not hrp or humanoid.Health <= 0 then
		insideHitbox = false
		damageCooldown = 0
		return
	end

	overlapParams.FilterDescendantsInstances = {character}

local touching = {}

if hitbox.CanQuery then
	touching = workspace:GetPartBoundsInBox(
		hitbox.CFrame,
		hitbox.Size,
		overlapParams
	)
end

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
		damageCooldown = 3

		if not hiding then
			humanoid:TakeDamage(30)
			hit:Play()

			game.ReplicatedStorage.GameStats[
				"Player_" .. game.Players.LocalPlayer.Name
			].Total.DeathCause.Value = "SP-1"
		end

		return
	end

	if damageCooldown > 0 then
		damageCooldown -= dt
	end

	if damageCooldown <= 0 then
		damageCooldown = 3

		if not hiding then
			humanoid:TakeDamage(30)
			hit:Play()

			game.ReplicatedStorage.GameStats[
				"Player_" .. game.Players.LocalPlayer.Name
			].Total.DeathCause.Value = "SP-1"
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
			local backward = -startCFrame.LookVector

			local distance = 200
			local speed = 6
			local duration = distance / speed

			local targetPosition = startCFrame.Position + backward * distance

			local targetCFrame = CFrame.new(
				targetPosition
			) * startCFrame.Rotation

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

			tween.Completed:Once(function()
				cleanup()
			end)

			effectCooldown = 0
effectTriggered = false
entityMoving = true
tween:Play()
		end)
	else
		warn("Không tìm thấy RoomEntrance hợp lệ trong CurrentRooms!")
		model:Destroy()
	end
end
