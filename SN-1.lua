local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Players = game:GetService("Players")

local GameData = ReplicatedStorage:WaitForChild("GameData")
local LatestRoom = GameData:WaitForChild("LatestRoom")
local CurrentRooms = workspace:WaitForChild("CurrentRooms")

local LocalPlayer = Players.LocalPlayer

local function GetGitSound(GithubSnd, SoundName)
	if not isfile(SoundName .. ".mp3") then
		writefile(SoundName .. ".mp3", game:HttpGet(GithubSnd))
	end

	local sound = Instance.new("Sound")
	sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".mp3")
	return sound
end

local hit = GetGitSound(
	"https://github.com/lynguyen26031993-design/-u/raw/refs/heads/main/SN-1_Hit.mp3.mpeg.mp3?raw=true",
	"jjvjjdjjsjkaakx"
)

hit.Volume = 1
hit.Name = "hit"
hit.PlaybackSpeed = 1
hit.RollOffMaxDistance = 120

local url = "https://raw.githubusercontent.com/lynguyen26031993-design/-u/refs/heads/main/Place_17302962269_Model_SN-1_1787159371.txt"
local file = "SN-1.rbxm"

if not isfile(file) then
	writefile(file, game:HttpGet(url))
end

local room = CurrentRooms:WaitForChild(tostring(LatestRoom.Value))
local parts = room:WaitForChild("Parts")

local floor
local biggest = -math.huge

for _, obj in ipairs(parts:GetChildren()) do
	if obj:IsA("BasePart") and obj.Name == "Floor" then
		local size = obj.Size
		local area = size.X + size.Z

		if area > biggest then
			biggest = area
			floor = obj
		end
	end
end

if not floor then
	return
end

local cf = floor.CFrame
local size = floor.Size
local inset = 4

local corners = {
	Vector3.new(-size.X / 2 + inset, 4, -size.Z / 2 + inset),
	Vector3.new(size.X / 2 - inset, 4, -size.Z / 2 + inset),
	Vector3.new(size.X / 2 - inset, 4, size.Z / 2 - inset),
	Vector3.new(-size.X / 2 + inset, 4, size.Z / 2 - inset)
}

local cornerParts = {}
local connections = {}

local model
local pivotValue
local currentTween
local hitbox

local cleaned = false
local currentIndex

local DESPAWN_TIME = 8 * 60
local DAMAGE = 40
local DAMAGE_COOLDOWN = 3
local HITBOX_SIZE = Vector3.new(10, 10, 10)

local nextDamageTime = 0

local function cleanup()
	if cleaned then
		return
	end

	cleaned = true

	if currentTween then
		pcall(function()
			currentTween:Cancel()
		end)

		currentTween = nil
	end

	for _, connection in ipairs(connections) do
		if connection and connection.Connected then
			connection:Disconnect()
		end
	end

	table.clear(connections)

	if pivotValue then
		pcall(function()
			pivotValue:Destroy()
		end)

		pivotValue = nil
	end

	if hitbox then
		pcall(function()
			hitbox:Destroy()
		end)

		hitbox = nil
	end

	for _, part in ipairs(cornerParts) do
		if part and part.Parent then
			part:Destroy()
		end
	end

	table.clear(cornerParts)

	if model and model.Parent then
		model:Destroy()
	end
end

for _, offset in ipairs(corners) do
	local part = Instance.new("Part")

	part.Name = "RoomCorner"
	part.Size = Vector3.new(2, 2, 2)
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Transparency = 1
	part.Color = Color3.fromRGB(255, 0, 0)
	part.CFrame = cf * CFrame.new(offset)
	part.Parent = workspace

	table.insert(cornerParts, part)

	local highlight = Instance.new("Highlight")

	highlight.Name = "CornerHighlight"
	highlight.Adornee = part
	highlight.FillColor = Color3.fromRGB(255, 0, 0)
	highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
	highlight.FillTransparency = 0
	highlight.OutlineTransparency = 0
	highlight.Parent = part
end

local objects = game:GetObjects(getcustomasset(file))
model = objects[1]

if not model then
	cleanup()
	return
end

model.Parent = workspace
hit.Parent = model:FindFirstChildWhichIsA("BasePart") 

local images = {}

for _, obj in ipairs(model:GetDescendants()) do
	if obj:IsA("ImageLabel") then
		images[#images + 1] = {
			obj,
			obj.Position,
			obj.Rotation
		}
	end
end

local entityPart

for _, obj in ipairs(model:GetDescendants()) do
	if obj:IsA("BasePart") then
		entityPart = obj
		break
	end
end

if not entityPart then
	cleanup()
	return
end

hitbox = Instance.new("Part")
hitbox.Name = "SN1Hitbox"
hitbox.Size = HITBOX_SIZE
hitbox.Anchored = false
hitbox.CanCollide = false
hitbox.CanTouch = false
hitbox.CanQuery = true
hitbox.Massless = true
hitbox.Transparency = 1
hitbox.CFrame = model:GetPivot()
hitbox.Parent = model

local weld = Instance.new("WeldConstraint")
weld.Part0 = entityPart
weld.Part1 = hitbox
weld.Parent = hitbox

local overlapParams = OverlapParams.new()
overlapParams.FilterType = Enum.RaycastFilterType.Include

local character = LocalPlayer.Character
if character then
	overlapParams.FilterDescendantsInstances = {character}
end

table.insert(connections, LocalPlayer.CharacterAdded:Connect(function(char)
	character = char
	overlapParams.FilterDescendantsInstances = {char}
end))

local t = 0

table.insert(connections, RunService.RenderStepped:Connect(function(dt)
	if cleaned then
		return
	end

	if not model or not model.Parent then
		cleanup()
		return
	end

	if not room.Parent or room.Parent ~= CurrentRooms then
		cleanup()
		return
	end

	t += dt

	local shakeX = math.noise(t * 35, 0, 0) * 0.05
	local shakeY = math.noise(0, t * 35, 0) * 0.05
	local rotation = math.noise(t * 40, 100, 0) * 5

	for _, info in ipairs(images) do
		local image = info[1]
		local pos = info[2]
		local rot = info[3]

		if image and image.Parent then
			image.Position = UDim2.new(
				pos.X.Scale + shakeX,
				pos.X.Offset,
				pos.Y.Scale + shakeY,
				pos.Y.Offset
			)

			image.Rotation = rot + rotation
		end
	end
end))

local startIndex = math.random(1, #cornerParts)

currentIndex = startIndex

model:PivotTo(cornerParts[startIndex].CFrame)

hitbox.CFrame = model:GetPivot()

pivotValue = Instance.new("CFrameValue")
pivotValue.Value = model:GetPivot()

table.insert(connections, pivotValue:GetPropertyChangedSignal("Value"):Connect(function()
	if cleaned then
		return
	end

	if model and model.Parent then
		model:PivotTo(pivotValue.Value)
	end
end))

table.insert(connections, room.AncestryChanged:Connect(function()
	if cleaned then
		return
	end

	if room.Parent ~= CurrentRooms then
		cleanup()
	end
end))

task.spawn(function()
	while not cleaned do
		if not room.Parent or room.Parent ~= CurrentRooms then
			cleanup()
			break
		end

		if not model or not model.Parent then
			cleanup()
			break
		end

		if os.clock() - (nextDamageTime - DAMAGE_COOLDOWN) >= DESPAWN_TIME then
			break
		end

		task.wait(0.1)
	end
end)

task.spawn(function()
	local startTime = os.clock()

	while not cleaned do
		if not room.Parent or room.Parent ~= CurrentRooms then
			cleanup()
			break
		end

		if not model or not model.Parent then
			cleanup()
			break
		end

		if os.clock() - startTime >= DESPAWN_TIME then
			cleanup()
			break
		end

		task.wait(0.1)
	end
end)

task.spawn(function()
	while not cleaned do
		if not hitbox or not hitbox.Parent then
			break
		end

		if not character or not character.Parent then
			task.wait(0.1)
			continue
		end

		local touching = false

		local success, result = pcall(function()
			return workspace:GetPartsInPart(hitbox, overlapParams)
		end)

		if success and result then
			touching = #result > 0
		end

		if touching then
			local now = os.clock()

			if now >= nextDamageTime then
				local humanoid = character:FindFirstChildOfClass("Humanoid")

				if humanoid and humanoid.Health > 0 then
					humanoid:TakeDamage(DAMAGE)
					hit:Play() 
					
					local stats = game.ReplicatedStorage.GameStats:FindFirstChild(
						"Player_" .. game.Players.LocalPlayer.Name
					)

					if stats and stats:FindFirstChild("Total") then
						local deathCause = stats.Total:FindFirstChild("DeathCause")

						if deathCause then
							deathCause.Value = "SN-1"
						end
					end
					
					nextDamageTime = now + DAMAGE_COOLDOWN
				end
			end
		end

		task.wait(0.1)
	end
end)

task.spawn(function()
	while not cleaned do
		if not room.Parent or room.Parent ~= CurrentRooms then
			cleanup()
			break
		end

		if not model or not model.Parent then
			cleanup()
			break
		end

		local nextIndex = (currentIndex % #cornerParts) + 1
		local target = cornerParts[nextIndex].CFrame
		local current = model:GetPivot()

		local distance = (current.Position - target.Position).Magnitude
		local duration = distance / 10

		currentTween = TweenService:Create(
			pivotValue,
			TweenInfo.new(duration, Enum.EasingStyle.Linear),
			{
				Value = target
			}
		)

		currentTween:Play()

		local state = currentTween.Completed:Wait()

		currentTween = nil

		if cleaned then
			break
		end

		if state ~= Enum.PlaybackState.Completed then
			break
		end

		if not room.Parent or room.Parent ~= CurrentRooms then
			cleanup()
			break
		end

		if not model or not model.Parent then
			cleanup()
			break
		end

		currentIndex = nextIndex
	end
end)
