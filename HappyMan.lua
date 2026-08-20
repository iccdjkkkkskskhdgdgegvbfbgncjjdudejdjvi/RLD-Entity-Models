local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local url = "https://raw.githubusercontent.com/lynguyen26031993-design/-u/refs/heads/main/Place_17302962269_Model_Happyman_1787197229.txt"
local file = "Happyman.txt"

local function GetGitSound(GithubSnd, SoundName)
	if not isfile(SoundName .. ".mp3") then
		writefile(SoundName .. ".mp3", game:HttpGet(GithubSnd))
	end

	local sound = Instance.new("Sound")
	sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".mp3")
	return sound
end

local voice1 = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/Follow_happyman_accurate.mp3?raw=true",
	"kckhshhxjka"
)

voice1.Volume = 3
voice1.Name = "Voice1"
voice1.PlaybackSpeed = 1
voice1.RollOffMaxDistance = 50

local voice2 = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/Are_you_his_friend_.mp3?raw=true",
	"jjcjjdjkkkajhcyd"
)

voice2.Volume = 3
voice2.Name = "Voice2"
voice2.PlaybackSpeed = 1
voice2.RollOffMaxDistance = 50

local voice3 = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/Friend_him_now.mp3?raw=true",
	"kckjsjjhhhjahj"
)

voice3.Volume = 1.5
voice3.Name = "Voice3"
voice3.PlaybackSpeed = 1
voice3.RollOffMaxDistance = 50

local voice4 = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/Funny_times_accurate.mp3?raw=true",
	"kvjjdjjkakllxjj"
)

voice4.Volume = 2
voice4.Name = "Voice4"
voice4.PlaybackSpeed = 1
voice4.RollOffMaxDistance = 50

local voice5 = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/For_what.mp3?raw=true",
	"jvjhsjjkkjjc"
)

voice5.Volume = 2
voice5.Name = "Voice5"
voice5.PlaybackSpeed = 1
voice5.RollOffMaxDistance = 50

local voice6 = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/Happyman_dies_accurate.mp3?raw=true",
	"kcjhsjjzjicjd"
)

voice6.Volume = 2
voice6.Name = "Voice6"
voice6.PlaybackSpeed = 1
voice6.RollOffMaxDistance = 50

local despawn = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/Dies.mp3.mpeg.mp3?raw=true",
	"vkjdjhjjskkjxdf"
)

despawn.Volume = 4
despawn.Name = "Despawn"
despawn.PlaybackSpeed = 1
despawn.RollOffMaxDistance = 200

if not isfile(file) then
	writefile(file, game:HttpGet(url))
end

local objs = game:GetObjects(getcustomasset(file))

for _, obj in ipairs(objs) do
	obj.Parent = workspace

	if obj:IsA("Model") then
		for _, descendant in ipairs(obj:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.CanCollide = false
			end
		end
	elseif obj:IsA("BasePart") then
		obj.CanCollide = false
	end

	local basePart = obj:FindFirstChildWhichIsA("BasePart", true)

	if basePart then
		voice1.Parent = basePart
		voice2.Parent = basePart
		voice3.Parent = basePart
		voice4.Parent = basePart
		voice5.Parent = basePart
		voice6.Parent = basePart
		despawn.Parent = basePart
	end

local alive = true

local function addThread(thread)
			table.insert(threads, thread)
			return thread
		end

		if obj:IsA("Model") then
	local GameData = ReplicatedStorage:WaitForChild("GameData")
	local LatestRoom = GameData:WaitForChild("LatestRoom")
	local CurrentRooms = workspace:WaitForChild("CurrentRooms")

	local alive = true
	local finalPhase = false
	local movementLocked = false
	local prompt

	local connections = {}
	local tweens = {}
	local threads = {}

	local function addConnection(connection)
		table.insert(connections, connection)
		return connection
	end

	local function addTween(tween)
		table.insert(tweens, tween)
		return tween
	end

	local function addThread(thread)
		table.insert(threads, thread)
		return thread
	end

		local room = CurrentRooms:FindFirstChild(tostring(LatestRoom.Value))
		local floor = room
			and room:FindFirstChild("Parts")
			and room.Parts:FindFirstChild("Floor")

		if floor and floor:IsA("BasePart") then
			local _, modelSize = obj:GetBoundingBox()

			local halfX = modelSize.X / 2
			local halfZ = modelSize.Z / 2

			local minX = -floor.Size.X / 2 + halfX
			local maxX = floor.Size.X / 2 - halfX

			local minZ = -floor.Size.Z / 2 + halfZ
			local maxZ = floor.Size.Z / 2 - halfZ

			local randomX = minX <= maxX
				and math.random() * (maxX - minX) + minX
				or 0

			local randomZ = minZ <= maxZ
				and math.random() * (maxZ - minZ) + minZ
				or 0

			local localPosition = Vector3.new(
				randomX,
				floor.Size.Y / 2 + modelSize.Y / 2,
				randomZ
			)

			local spawnCFrame =
				floor.CFrame
				* CFrame.new(localPosition)
				* CFrame.Angles(0, math.rad(math.random(0, 359)), 0)

			obj:PivotTo(spawnCFrame)

			local WALL_DISTANCE = 3
local WALL_COOLDOWN = 4

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.FilterDescendantsInstances = {obj}
rayParams.IgnoreWater = true

local moveThread = task.spawn(function()
	while alive and not movementLocked and obj and obj.Parent do
		local currentCFrame = obj:GetPivot()
		local currentPosition = currentCFrame.Position

		local angle = math.random() * math.pi * 2
		local distance = math.random(8, 14)

		local direction = Vector3.new(
			math.cos(angle),
			0,
			math.sin(angle)
		).Unit

		local targetPosition =
			currentPosition + direction * distance

		local moveValue = Instance.new("CFrameValue")
		moveValue.Value = currentCFrame

		local moveConnection =
			moveValue:GetPropertyChangedSignal("Value"):Connect(function()
				if alive and not movementLocked and obj and obj.Parent then
					obj:PivotTo(moveValue.Value)
				end
			end)

		local moveTween = TweenService:Create(
			moveValue,
			TweenInfo.new(
				2,
				Enum.EasingStyle.Linear,
				Enum.EasingDirection.InOut
			),
			{
				Value =
					CFrame.new(targetPosition)
					* currentCFrame.Rotation
			}
		)

		addTween(moveTween)

		moveTween:Play()

		local blockedByWall = false

		while moveTween.PlaybackState == Enum.PlaybackState.Playing
			and alive
			and not movementLocked
			and obj
			and obj.Parent do

			local currentPivot = obj:GetPivot()
			local currentPos = currentPivot.Position

			local currentDirection =
				(targetPosition - currentPos)

			if currentDirection.Magnitude > 0 then
				currentDirection = currentDirection.Unit

				local result = workspace:Raycast(
					currentPos,
					currentDirection * (WALL_DISTANCE + 1),
					rayParams
				)

				if result
					and result.Instance
					and result.Instance:IsA("BasePart")
					and string.find(
						string.lower(result.Instance.Name),
						"wall",
						1,
						true
					)
					and result.Distance <= WALL_DISTANCE then

					blockedByWall = true
					break
				end
			end

			task.wait()
		end

		if blockedByWall then
	moveTween:Cancel()

	if moveConnection then
		moveConnection:Disconnect()
	end

	moveValue:Destroy()

	task.wait(WALL_COOLDOWN)

	if not alive or movementLocked or not obj.Parent then
		break
	end
else
	if movementLocked then
		moveTween:Cancel()
	end

	if moveConnection then
		moveConnection:Disconnect()
	end

	moveValue:Destroy()

	if not alive or movementLocked or not obj.Parent then
		break
	end

	task.wait(math.random(2, 6))
end
	end
end)

addThread(moveThread)
		end
		
		local finalPhase = false
		local prompt

		local connections = {}
		local tweens = {}
		local threads = {}

		local function addConnection(connection)
			table.insert(connections, connection)
			return connection
		end

		local function addTween(tween)
			table.insert(tweens, tween)
			return tween
		end

		local function cleanup(keepDespawn)
			if not alive then
				return
			end

			alive = false

			for _, connection in ipairs(connections) do
				pcall(function()
					connection:Disconnect()
				end)
			end

			table.clear(connections)

			for _, tween in ipairs(tweens) do
				pcall(function()
					tween:Cancel()
				end)
			end

			table.clear(tweens)

			for _, thread in ipairs(threads) do
				pcall(function()
					task.cancel(thread)
				end)
			end

			table.clear(threads)

			if prompt then
				pcall(function()
					prompt:Destroy()
				end)

				prompt = nil
			end

			for _, sound in ipairs({
				voice1,
				voice2,
				voice3,
				voice4,
				voice5,
				voice6
			}) do
				pcall(function()
					sound:Stop()
				end)
			end

			if not keepDespawn then
				pcall(function()
					despawn:Stop()
				end)
			end

			for _, sound in ipairs({
				voice1,
				voice2,
				voice3,
				voice4,
				voice5,
				voice6
			}) do
				pcall(function()
					sound:Destroy()
				end)
			end

			if not keepDespawn then
				pcall(function()
					despawn:Destroy()
				end)
			end

			if obj and obj.Parent then
				pcall(function()
					obj:Destroy()
				end)
			end
		end

		local gui

		for _, descendant in ipairs(obj:GetDescendants()) do
			if descendant:IsA("BillboardGui") and descendant.Name == "MonsterGui" then
				gui = descendant
				break
			end
		end

		if gui then
			local images = {}

			local image1 = gui:FindFirstChild("Image1", true)
			local image2 = gui:FindFirstChild("Image2", true)

			for _, descendant in ipairs(gui:GetDescendants()) do
				if descendant:IsA("ImageLabel") then
					table.insert(images, {
						object = descendant,
						original = descendant.Rotation,
						position = descendant.Position
					})
				end
			end

			local shakePower = 2

			for _, data in ipairs(images) do
				local thread = task.spawn(function()
					local image = data.object
					local original = data.position

					while alive and image and image.Parent do
						local offsetX = math.random(-shakePower, shakePower)
						local offsetY = math.random(-shakePower, shakePower)

						local target = UDim2.new(
							original.X.Scale,
							original.X.Offset + offsetX,
							original.Y.Scale,
							original.Y.Offset + offsetY
						)

						local shake = TweenService:Create(
							image,
							TweenInfo.new(
								0.08,
								Enum.EasingStyle.Linear,
								Enum.EasingDirection.InOut
							),
							{
								Position = target
							}
						)

						addTween(shake)

						shake:Play()

						local completed = false
						local connection

						connection = shake.Completed:Connect(function()
							completed = true

							if connection then
								connection:Disconnect()
							end
						end)

						while alive and not completed and image.Parent do
							task.wait()
						end

						pcall(function()
							shake:Cancel()
						end)
					end
				end)

				addThread(thread)
			end

			local rotationThread = task.spawn(function()
				local tweenInfo = TweenInfo.new(
					1.5,
					Enum.EasingStyle.Quad,
					Enum.EasingDirection.InOut
				)

				while alive and gui and gui.Parent do
					for _, data in ipairs(images) do
						if alive and data.object and data.object.Parent then
							local tween = TweenService:Create(
								data.object,
								tweenInfo,
								{
									Rotation = data.original - 25
								}
							)

							addTween(tween)
							tween:Play()
						end
					end

					task.wait(1.5)

					if not alive then
						break
					end

					for _, data in ipairs(images) do
						if alive and data.object and data.object.Parent then
							local tween = TweenService:Create(
								data.object,
								tweenInfo,
								{
									Rotation = data.original
								}
							)

							addTween(tween)
							tween:Play()
						end
					end

					task.wait(1.5)
				end
			end)

			addThread(rotationThread)

			local textLabels = {}

			for _, descendant in ipairs(obj:GetDescendants()) do
				if descendant:IsA("TextLabel") then
					table.insert(textLabels, descendant)
				end
			end

			for _, textLabel in ipairs(textLabels) do
				textLabel.Text = ""
			end

			local textGeneration = 0

			local function AnimateImages(text, singleImage)
				if not alive then
					return
				end

				textGeneration += 1

				local myGeneration = textGeneration

				if image1 then
					image1.Visible = true
				end

				if image2 then
					image2.Visible = false
				end

				for _, textLabel in ipairs(textLabels) do
					if textLabel and textLabel.Parent then
						textLabel.TextTransparency = 0
						textLabel.Text = ""
					end
				end

				local running = true

				if not singleImage then
					local imageThread = task.spawn(function()
						while alive
							and running
							and myGeneration == textGeneration
							and gui
							and gui.Parent do

							if image1 then
								image1.Visible = false
							end

							if image2 then
								image2.Visible = true
							end

							task.wait(0.08)

							if not alive
								or not running
								or myGeneration ~= textGeneration then
								break
							end

							if image1 then
								image1.Visible = true
							end

							if image2 then
								image2.Visible = false
							end

							task.wait(0.08)
						end
					end)

					addThread(imageThread)
				else
					task.wait(0.08)

					if not alive or myGeneration ~= textGeneration then
						return
					end

					if image1 then
						image1.Visible = false
					end

					if image2 then
						image2.Visible = true
					end
				end

				for i = 1, #text do
					if not alive
						or not gui
						or not gui.Parent
						or myGeneration ~= textGeneration then
						return
					end

					local currentText = string.sub(text, 1, i)

					for _, textLabel in ipairs(textLabels) do
						if textLabel and textLabel.Parent then
							textLabel.TextTransparency = 0
							textLabel.Text = currentText
						end
					end

					task.wait(0.1)
				end

				if not alive or myGeneration ~= textGeneration then
					return
				end

				running = false

				if singleImage then
					if image1 then
						image1.Visible = false
					end

					if image2 then
						image2.Visible = true
					end
				else
					if image1 then
						image1.Visible = true
					end

					if image2 then
						image2.Visible = false
					end
				end

				task.wait(2)

				if not alive
					or not gui
					or not gui.Parent
					or myGeneration ~= textGeneration then
					return
				end

				local fadeInfo = TweenInfo.new(
					2,
					Enum.EasingStyle.Quad,
					Enum.EasingDirection.InOut
				)

				for _, textLabel in ipairs(textLabels) do
					if alive and textLabel and textLabel.Parent then
						local fade = TweenService:Create(
							textLabel,
							fadeInfo,
							{
								TextTransparency = 1
							}
						)

						addTween(fade)
						fade:Play()
					end
				end
			end

			local sequenceThread = task.spawn(function()
				task.wait(4)

				if not alive or not gui or not gui.Parent then
					return
				end

				voice1:Play()

				task.spawn(function()
					AnimateImages("Follow me and you will get something COOuel!")
				end)

				voice1.Ended:Wait()

				if not alive then
					return
				end

				task.wait(5)

				if not alive or not gui or not gui.Parent then
					return
				end

				voice2:Play()

				task.spawn(function()
					AnimateImages("Are you my friend?")
				end)

				task.wait(3.5)

				if not alive then
					return
				end

				voice3:Play()

				prompt = Instance.new("ProximityPrompt")
				prompt.Name = "FriendPrompt"
				prompt.Style = Enum.ProximityPromptStyle.Custom
				prompt.ActionText = "Friend Him"
				prompt.ObjectText = "Friend Him"
				prompt.MaxActivationDistance = 10
				prompt.RequiresLineOfSight = false
				prompt.Parent = basePart

				addConnection(prompt.Triggered:Connect(function()
					if not alive or finalPhase then
						return
					end

					if prompt then
						prompt:Destroy()
						prompt = nil
					end

					voice5:Play()

					task.spawn(function()
						AnimateImages("Thanks!")
					end)
				end))

				task.spawn(function()
					AnimateImages("Friend me now!")
				end)

				task.wait(5)

				if not alive then
					return
				end

				voice4:Play()

				task.spawn(function()
					AnimateImages("Funny times!")
				end)
			end)

			addThread(sequenceThread)

			local cooldownThread = task.spawn(function()
				local startTime = os.clock()

				while alive and os.clock() - startTime < 30 do
					task.wait(0.5)
				end

				if not alive then
					return
				end

				finalPhase = true

task.spawn(function()
	AnimateImages("NOOOOOOOOOOOAAAAAAAAAAAA", true)
end)

shakePower = 4

for _, descendant in ipairs(obj:GetDescendants()) do
	if descendant:IsA("ParticleEmitter") then
		descendant.Enabled = true
	end
end

movementLocked = true

if prompt then
	pcall(function()
		prompt:Destroy()
	end)

	prompt = nil
end

for _, descendant in ipairs(obj:GetDescendants()) do
	if descendant:IsA("BasePart") then
		descendant.Anchored = true
		descendant.AssemblyLinearVelocity = Vector3.zero
		descendant.AssemblyAngularVelocity = Vector3.zero
	end
end

voice6:Play()

local voice6Thread = task.spawn(function()
	while alive and finalPhase and voice6.IsPlaying do
		if voice6.TimePosition >= 4 then
			voice6:Stop()

			despawn:Play()

			cleanup(true)

			local despawnEnded

			despawnEnded = despawn.Ended:Connect(function()
				if despawnEnded then
					despawnEnded:Disconnect()
					despawnEnded = nil
				end

				pcall(function()
					despawn:Destroy()
				end)
			end)

			return
		end

		task.wait()
	end
end)

addThread(voice6Thread)
			end)

			addThread(cooldownThread)

			addConnection(obj.AncestryChanged:Connect(function(_, parent)
				if not parent and alive then
					cleanup(false)
				end
			end))
		end

	elseif obj:IsA("BasePart") then
		local GameData = ReplicatedStorage:WaitForChild("GameData")
		local LatestRoom = GameData:WaitForChild("LatestRoom")
		local CurrentRooms = workspace:WaitForChild("CurrentRooms")

		local room = CurrentRooms:FindFirstChild(tostring(LatestRoom.Value))
		local floor = room and room:FindFirstChild("Parts") and room.Parts:FindFirstChild("Floor")

		if floor and floor:IsA("BasePart") then
			local halfX = obj.Size.X / 2
			local halfZ = obj.Size.Z / 2

			local minX = -floor.Size.X / 2 + halfX
			local maxX = floor.Size.X / 2 - halfX

			local minZ = -floor.Size.Z / 2 + halfZ
			local maxZ = floor.Size.Z / 2 - halfZ

			local randomX = minX <= maxX
				and math.random() * (maxX - minX) + minX
				or 0

			local randomZ = minZ <= maxZ
				and math.random() * (maxZ - minZ) + minZ
				or 0

			obj.CFrame =
				floor.CFrame
				* CFrame.new(
					randomX,
					floor.Size.Y / 2 + obj.Size.Y / 2,
					randomZ
				)
		end
	end
end
