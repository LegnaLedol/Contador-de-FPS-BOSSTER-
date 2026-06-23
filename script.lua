-- 😈 LEGNA FPS+ FINAL (ESTABLE REAL)

-- 📊 CARGAR TU CONTADOR ORIGINAL
local success = pcall(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/LegnaLedol/Contador-de-FPS-BOSSTER-/refs/heads/main/script.lua"))()
end)

print("FPS COUNTER:", success and "OK" or "ERROR")

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local UltraActivo = false

------------------------------------------------
-- ⚙️ FUNCIÓN ULTRA LOW
------------------------------------------------
local function UltraLowON()
	if UltraActivo then return end
	UltraActivo = true

	-- 🌫️ CIELO GRIS
	pcall(function()
		Lighting.TimeOfDay = "12:00:00"
		Lighting.Ambient = Color3.fromRGB(120,120,120)
		Lighting.OutdoorAmbient = Color3.fromRGB(120,120,120)
		Lighting.FogColor = Color3.fromRGB(150,150,150)
		Lighting.GlobalShadows = false
	end)

	for _,v in ipairs(Lighting:GetChildren()) do
		if v:IsA("Sky") then
			v:Destroy()
		end
	end

	-- 💧 AGUA SIMPLE
	local t = workspace:FindFirstChildOfClass("Terrain")
	if t then
		pcall(function()
			t.WaterWaveSize = 0
			t.WaterWaveSpeed = 0
			t.WaterReflectance = 0
			t.WaterTransparency = 0
		end)
	end

	-- ⚙️ OPTIMIZACIÓN (SIN TOCAR GUI NI PLAYER)
	for _,v in ipairs(game:GetDescendants()) do
		
		if v:IsDescendantOf(CoreGui) then continue end

		if v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Enabled = false

		elseif v:IsA("PostEffect") then
			v.Enabled = false

		elseif v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
			v.Enabled = false

		elseif v:IsA("Texture") or v:IsA("Decal") then
			v:Destroy()

		elseif v:IsA("BasePart") then
			v.Material = Enum.Material.Plastic
			v.CastShadow = false
			v.Reflectance = 0
		end
	end

	print("😈 LEGNA FPS+ ACTIVADO")
end

------------------------------------------------
-- 🖱️ DOBLE CLICK EN CONTADOR
------------------------------------------------
task.spawn(function()
	repeat task.wait() until game:IsLoaded()

	local lastClick = 0

	while true do
		task.wait()

		for _,gui in ipairs(CoreGui:GetDescendants()) do
			if gui:IsA("TextLabel") and string.find(gui.Text, "FPS") then
				
				gui.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						
						local now = tick()
						if now - lastClick < 0.3 then
							UltraLowON()
						end
						lastClick = now
					end
				end)

				print("FPS COUNTER DETECTADO ✔")
				return
			end
		end
	end
end)
