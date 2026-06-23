-- ✅ ESPERAR JUEGO
if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- ✅ CARGAR TU RAW (CONTADOR)
local success, err = pcall(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/LegnaLedol/Contador-de-FPS-BOSSTER-/refs/heads/main/script.lua"))()
end)

if not success then
	warn("❌ Error cargando RAW:", err)
end

task.wait(3)

local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

------------------------------------------------
-- 🔎 DETECTAR CONTADOR (MEJOR PARA MÓVIL)
------------------------------------------------
local contador

for _,v in pairs(gui:GetDescendants()) do
	if (v:IsA("TextLabel") or v:IsA("TextButton")) then
		if v.Text and (#v.Text <= 10) then
			if string.find(string.lower(v.Text), "fps") or string.find(v.Text, "%d+") then
				contador = v
				break
			end
		end
	end
end

if not contador then
	warn("❌ No se encontró el contador")
	return
end

print("✅ Contador detectado:", contador:GetFullName())

------------------------------------------------
-- 🔥 ULTRA LOW (FULL OPTIMIZADO)
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
			v.Reflectance = 0
			v.CastShadow = false
		end
	end

	local lighting = game:GetService("Lighting")

	-- quitar cielo
	local sky = lighting:FindFirstChildOfClass("Sky")
	if sky then sky:Destroy() end

	-- ambiente plano gris
	lighting.GlobalShadows = false
	lighting.FogEnd = 9e9
	lighting.OutdoorAmbient = Color3.fromRGB(120,120,120)
	lighting.Brightness = 1

	print("🔥 ULTRA LOW ACTIVADO")
end

------------------------------------------------
-- 📱 DOBLE TAP (MÓVIL)
------------------------------------------------
local lastTap = 0

contador.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then

		local now = tick()

		if now - lastTap <= 0.35 then
			UltraLow()
		end

		lastTap = now
	end
end)

------------------------------------------------
-- 📱 DRAG PARA MOVER (MÓVIL FIX)
------------------------------------------------
local UIS = game:GetService("UserInputService")

local dragging = false
local dragStart
local startPos

contador.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
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
