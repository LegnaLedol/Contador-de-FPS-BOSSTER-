-- 😈 LEGNA FPS+ FULL FIX

-- 📊 CARGAR CONTADOR ORIGINAL
pcall(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/LegnaLedol/Contador-de-FPS-BOSSTER-/refs/heads/main/script.lua"))()
end)

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local function UltraLowON()

	------------------------------------------------
	-- 🌫️ CIELO GRIS
	------------------------------------------------
	pcall(function()
		Lighting.TimeOfDay = "12:00:00"
		Lighting.Ambient = Color3.fromRGB(130,130,130)
		Lighting.OutdoorAmbient = Color3.fromRGB(130,130,130)
		Lighting.FogColor = Color3.fromRGB(160,160,160)
		Lighting.FogEnd = 1e10
		Lighting.Brightness = 0.8
		Lighting.GlobalShadows = false
	end)

	for _,v in ipairs(Lighting:GetChildren()) do
		if v:IsA("Sky") then
			v:Destroy()
		end
	end

	------------------------------------------------
	-- 💧 AGUA SIMPLE
	------------------------------------------------
	local t = workspace:FindFirstChildOfClass("Terrain")
	if t then
		pcall(function()
			t.WaterWaveSize = 0
			t.WaterWaveSpeed = 0
			t.WaterReflectance = 0
			t.WaterTransparency = 0
		end)
	end

	------------------------------------------------
	-- ⚙️ OPTIMIZACIÓN (NO TOCAR GUI)
	------------------------------------------------
	for _,v in ipairs(game:GetDescendants()) do
		
		if v:IsDescendantOf(CoreGui) then
			continue
		end

		if v:IsA("ScreenGui") or v:IsA("TextLabel") then
			continue
		end

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

	------------------------------------------------
	-- 🧱 JUGADORES (SIN CAERSE)
	------------------------------------------------
	for _,plr in ipairs(Players:GetPlayers()) do
		local char = plr.Character
		if char then

			-- quitar accesorios
			for _,v in ipairs(char:GetChildren()) do
				if v:IsA("Accessory") then
					v:Destroy()
				end
			end

			for _,v in ipairs(char:GetDescendants()) do

				if v:IsA("MeshPart") then
					v.TextureID = ""
					v.Material = Enum.Material.Plastic
				end

				if v:IsA("BasePart") then
					v.Material = Enum.Material.Plastic
					v.CastShadow = false
				end

				-- ❌ NO BORRAR Animator completamente
			end

			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				pcall(function()
					hum:ChangeState(Enum.HumanoidStateType.Running)
				end)
			end
		end
	end

	print("😈 LEGNA FPS+ ACTIVADO (FPS OK)")
end

-- 🚀 AUTO RUN
task.spawn(function()
	wait(1)
	UltraLowON()
end)
