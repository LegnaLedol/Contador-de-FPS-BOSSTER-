-- 😈 LEGNA ULTRA LOW INTELIGENTE V2

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--------------------------------------------------
-- 🎯 VARIABLES
--------------------------------------------------
local boosted = false
local lastTap = 0

--------------------------------------------------
-- 💀 OPTIMIZAR PERSONAJES (NPC / PLAYERS)
--------------------------------------------------
local function OptimizeCharacter(char)
    if char == player.Character then return end

    for _,v in pairs(char:GetDescendants()) do
        
        if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then
            v:Destroy()

        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1

        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false

        elseif v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Color = Color3.fromRGB(140,140,140)
            v.CastShadow = false
        end
    end
end

--------------------------------------------------
-- ⚡ ULTRA BOOST
--------------------------------------------------
local function UltraBoost()

    -- mundo
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1

    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)

    -- mapa
    for _,v in pairs(game:GetDescendants()) do
        
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false

        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1

        elseif v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
        end
    end

    -- personajes actuales
    for _,plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            OptimizeCharacter(plr.Character)
        end
    end

    -- nuevos personajes / NPC
    workspace.DescendantAdded:Connect(function(v)
        if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") then
            task.wait(0.3)
            OptimizeCharacter(v)
        end
    end)
end

--------------------------------------------------
-- 📱 OPTIMIZAR UI (BORROSO / CUADRADO)
--------------------------------------------------
local function OptimizeUI()

    for _,gui in pairs(player.PlayerGui:GetDescendants()) do
        
        if gui:IsA("ImageLabel") or gui:IsA("ImageButton") then
            gui.ImageTransparency = 0.4 -- borroso fake
        end

        if gui:IsA("Frame") then
            for _,c in pairs(gui:GetChildren()) do
                if c:IsA("UICorner") then
                    c:Destroy() -- lo hace cuadrado
                end
            end
        end

        if gui:IsA("TextLabel") or gui:IsA("TextButton") then
            gui.TextStrokeTransparency = 0.6
        end
    end
end

--------------------------------------------------
-- 🎯 HUD FPS (BOTÓN)
--------------------------------------------------
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 130, 0, 22)
frame.Position = UDim2.new(0, 8, 0, 70)
frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
frame.BackgroundTransparency = 0.25

local text = Instance.new("TextLabel", frame)
text.Size = UDim2.new(1,0,1,0)
text.BackgroundTransparency = 1
text.Font = Enum.Font.GothamSemibold
text.TextScaled = true

--------------------------------------------------
-- 📊 FPS + PING
--------------------------------------------------
local fps = 0
local frames = 0
local last = tick()

RunService.RenderStepped:Connect(function()
    frames += 1

    if tick() - last >= 1 then
        fps = frames
        frames = 0
        last = tick()
    end

    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

    text.Text = "L "..fps.." FPS | "..ping.." MS"
end)

--------------------------------------------------
-- 🖱️ DOBLE TAP EN EL HUD
--------------------------------------------------
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        
        local now = tick()

        if now - lastTap < 0.3 then
            boosted = not boosted

            if boosted then
                UltraBoost()
                OptimizeUI()
                print("😈 ULTRA LOW ACTIVADO")
            else
                print("❌ reinicia para volver a normal")
            end
        end

        lastTap = now
    end
end)

print("😈 toca 2 veces el contador para activar ULTRA LOW")
