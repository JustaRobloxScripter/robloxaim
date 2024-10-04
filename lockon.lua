local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local localPlayer = Players.LocalPlayer
local cameraFocusEnabled = false

-- Function to find the closest character (player or dummy)
local function getClosestCharacter()
	local closestCharacter = nil
	local closestDistance = math.huge

	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("Model") and (obj:FindFirstChild("Humanoid") or obj:FindFirstChild("NPC")) and obj.Name ~= localPlayer.Name then
			local head = obj:FindFirstChild("Head")
			local humanoidRootPart = obj:FindFirstChild("HumanoidRootPart")
			if head and humanoidRootPart then
				local headPosition = head.Position
				local localPlayerPosition = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character.HumanoidRootPart.Position

				if localPlayerPosition then
					local distance = (headPosition - localPlayerPosition).magnitude
					if distance < closestDistance then
						closestDistance = distance
						closestCharacter = obj
					end
				end
			end
		end
	end

	return closestCharacter
end

-- Function to adjust camera
local function adjustCamera()
	while cameraFocusEnabled do
		local closestCharacter = getClosestCharacter()
		if closestCharacter then
			local head = closestCharacter:FindFirstChild("Head")
			if head then
				local headPosition = head.Position
				-- Move the camera to look at the target head directly
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPosition)
			end
		end
		RunService.RenderStepped:Wait()
	end
end

-- User input event listener
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.E then
		cameraFocusEnabled = true
		adjustCamera()
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.E then
		cameraFocusEnabled = false
	end
end)
