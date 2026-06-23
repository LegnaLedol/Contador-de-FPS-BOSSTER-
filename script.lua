-- esperar juego
if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- cargar RAW
pcall(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/LegnaLedol/Contador-de-FPS-BOSSTER-/refs/heads/main/script.lua"))()
end)

local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

------------------------------------------------
-- 🔎 ESPERAR CONTADOR REAL
------------------------------------------------
local contador

task.spawn(function()
	repeat
		for _,v in pairs(gui:GetDescendants()) do
			if v:IsA("TextLabel") then
				if v.Text and string.match(v.Text, "^%d+$") then
					contador = v
					break
				end
			end
		end
		task.wait(0.5)
	until contador
end)

repeat task.wait() until contador

print("✅ Contador encontrado:", contador)

------------------------------------------------
-- 🔥 ULTRA LOW
------------------------------------------------
local function UltraLow()
	for _,v in pairs(workspace:GetDescendants()) do

		if v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Enabled = false
		end

		if v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
			v.Enabled = false
		end

		if v:IsA("BasePart") then
			v.Material = Enum.Material.Plastic
			v.CastShadow = false
			v.Reflectance = 0
		end
	end

	local lighting = game:GetService("Lighting")

	local sky = lighting:FindFirstChildOfClass("Sky")
	if sky then sky:Destroy() end

	lighting.GlobalShadows = false
	lighting.OutdoorAmbient = Color3.fromRGB(120,120,120)

	print("🔥 ULTRA LOW ON")
end

------------------------------------------------
-- 📱 DOBLE TAP + DRAG FIX
------------------------------------------------
local UIS = game:GetService("UserInputService")

local lastTap = 0
local dragging = false
local dragStart
local startPos

contador.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.Touch then
		
		-- doble tap
		local now = tick()
		if now - lastTap <= 0.3 then
			UltraLow()
		end
		lastTap = now

		-- drag start
		dragging = true
		dragStart = input.Position
		startPos = contador.Position
	end
end)

contador.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - dragStart

		contador.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
