local function UltraLowON()

	------------------------------------------------
	-- 🌫️ CIELO GRIS
	------------------------------------------------
	Lighting.TimeOfDay = "12:00:00"
	Lighting.Ambient = Color3.fromRGB(130,130,130)
	Lighting.OutdoorAmbient = Color3.fromRGB(130,130,130)
	Lighting.FogColor = Color3.fromRGB(160,160,160)
	Lighting.FogEnd = 1e10
	Lighting.Brightness = 0.8
	Lighting.GlobalShadows = false
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0

	for _,v in pairs(Lighting:GetChildren()) do
		if v:IsA("Sky") then
			v:Destroy()
		end
	end

	------------------------------------------------
	-- 💧 AGUA MUERTA
	------------------------------------------------
	local t = workspace:FindFirstChildOfClass("Terrain")
	if t then
		t.WaterWaveSize = 0
		t.WaterWaveSpeed = 0
		t.WaterReflectance = 0
		t.WaterTransparency = 0
	end

	------------------------------------------------
	-- ⚙️ OPTIMIZACIÓN GLOBAL (SIN DESTRUIR MAPA)
	------------------------------------------------
	for _,v in pairs(game:GetDescendants()) do

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
			v.Reflectance = 0
			v.CastShadow = false
		end
	end

	------------------------------------------------
	-- 🌳 LIMPIAR SOLO DECORACIÓN (NO MAPA)
	------------------------------------------------
	for _,v in pairs(workspace:GetDescendants()) do

		-- eliminar props típicos de lag
		if v:IsA("Model") and not Players:GetPlayerFromCharacter(v) then
			
			local name = v.Name:lower()

			if string.find(name, "tree")
			or string.find(name, "grass")
			or string.find(name, "bush")
			or string.find(name, "flower")
			or string.find(name, "rock")
			or string.find(name, "detail") then

				v:Destroy()
			end
		end
	end

	------------------------------------------------
	-- 🧱 JUGADORES COMO BLOQUES
	------------------------------------------------
	for _,plr in pairs(Players:GetPlayers()) do
		if plr.Character then

			local char = plr.Character

			-- ❌ accesorios
			for _,v in pairs(char:GetChildren()) do
				if v:IsA("Accessory") then
					v:Destroy()
				end
			end

			for _,v in pairs(char:GetDescendants()) do

				if v:IsA("MeshPart") then
					v.TextureID = ""
					v.Material = Enum.Material.Plastic
				end

				if v:IsA("BasePart") then
					v.Material = Enum.Material.Plastic
					v.CastShadow = false
				end

				-- ❌ animaciones
				if v:IsA("Animator") or v:IsA("AnimationController") then
					v:Destroy()
				end
			end

			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:ChangeState(Enum.HumanoidStateType.Physics)
			end
		end
	end

	------------------------------------------------
	-- 🚫 OCULTAR GUIS PESADAS
	------------------------------------------------
	for _,v in pairs(game:GetDescendants()) do
		if v:IsA("BillboardGui") then
			v.Enabled = false
		end
	end

	print("😈 LEGNA FPS+ ACTIVADO (BALANCEADO)")
end
