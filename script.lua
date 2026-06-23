-- CARGAR TU CONTADOR ORIGINAL (LEGNA FPS+)
loadstring(game:HttpGet("https://raw.githubusercontent.com/LegnaLedol/Contador-de-FPS-BOSSTER-/refs/heads/main/script.lua"))()

repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")
task.wait(2)

local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

------------------------------------------------
-- 🔎 BUSCAR TU CONTADOR
------------------------------------------------
local contador = nil

for _,v in pairs(gui:GetDescendants()) do
	if v:IsA("TextLabel") then
		if string.find(string.lower(v.Text), "fps") then
			contador = v
			break
		end
	end
end

if not contador then
	warn("❌ No se detectó el contador FPS")
	return
end

print("✅ Contador detectado")

------------------------------------------------
-- 🔥 ULTRA LOW 9/10 (OPTIMIZADO BLOX FRUITS)
------------------------------------------------
local function UltraLow()

	for _,v in pairs(workspace:GetDescendants()) do

		-- ❌ partículas
		if v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Enabled = false
		end

		-- ❌ luces
		if v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
			v.Enabled = false
		end

		-- ✔ optimizar partes SIN borrar mapa
		if v:IsA("BasePart") then
			v.CastShadow = false
			v.Material = Enum.Material.Plastic
			v.Reflectance = 0
		end

	end

	-- 🌫️ cielo gris
	local sky = game.Lighting:FindFirstChildOfClass("Sky")
	if sky then sky:Destroy() end

	game.Lighting.GlobalShadows = false
	game.Lighting.Brightness = 1
	game.Lighting.FogEnd = 9e9
	game.Lighting.OutdoorAmbient = Color3.fromRGB(120,120,120)

	print("🔥 ULTRA LOW ACTIVADO")
end

------------------------------------------------
-- 🖱️ DOBLE CLICK (ACTIVA ULTRA LOW)
------------------------------------------------
local lastClick = 0
local delay = 0.3

contador.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local now = tick()

		if now - lastClick <= delay then
			UltraLow()
		end

		lastClick = now
	end
end)

------------------------------------------------
-- 🖱️ ARRASTRAR CONTADOR (SUAVE)
------------------------------------------------
local dragging = false
local dragInput, dragStart, startPos

contador.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = contador.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

contador.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart

		contador.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
