-- 😈 LEGNA ULTRA LOW GOD MODE

local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

--------------------------------------------------
-- 📢 ALERTA
--------------------------------------------------
local function Alert(msg)
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 250, 0, 40)
    frame.Position = UDim2.new(1, 300, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
    frame.BackgroundTransparency = 0.2

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)

    local text = Instance.new("TextLabel", frame)
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.Font = Enum.Font.GothamBold
    text.TextScaled = true
    text.TextColor3 = Color3.fromRGB(0,255,120)
    text.Text = msg or "⚡ BOOST ACTIVADO"

    local enter = TweenService:Create(frame, TweenInfo.new(0.4), {
        Position = UDim2.new(1, -260, 0, 20)
    })

    local exit = TweenService:Create(frame, TweenInfo.new(0.4), {
        Position = UDim2.new(1, 300, 0, 20)
    })

    enter:Play()

    task.delay(5,function()
        exit:Play()
        exit.Completed:Wait()
        gui:Destroy()
    end)
end

--------------------------------------------------
-- ⚡ BOOST NIVELES
--------------------------------------------------
local level = 0

local function BoostLevel1()
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end
end

local function BoostLevel2()
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 0.7
        end
    end
end

local function BoostLevel3()
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
        end
    end
end

local function BoostLevel4()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9

    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
end

--------------------------------------------------
-- 🎯 HUD (MISMO DISEÑO)
--------------------------------------------------
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 125, 0, 20)
frame.Position = UDim2.new(0, 8, 0, 70)
frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
frame.BackgroundTransparency = 0.25
frame.BorderSizePixel = 0

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

local text = Instance.new("TextLabel", frame)
text.Size = UDim2.new(1, -6, 1, 0)
text.Position = UDim2.new(0, 6, 0, 0)
text.BackgroundTransparency = 1
text.Font = Enum.Font.GothamSemibold
text.TextScaled = true
text.TextXAlignment = Enum.TextXAlignment.Left

--------------------------------------------------
-- 📊 FPS + AUTO BOOST
--------------------------------------------------
local fps = 0
local frames = 0
local last = tick()
local hue = 0

RunService.RenderStepped:Connect(function()
    frames += 1

    if tick() - last >= 1 then
        fps = frames
        frames = 0
        last = tick()

        -- 😈 AUTO BOOST INTELIGENTE
        if fps < 50 and level < 1 then
            level = 1
            BoostLevel1()
            Alert("⚡ Nivel 1")
        elseif fps < 40 and level < 2 then
            level = 2
            BoostLevel2()
            Alert("⚡ Nivel 2")
        elseif fps < 30 and level < 3 then
            level = 3
            BoostLevel3()
            Alert("⚡ Nivel 3")
        elseif fps < 20 and level < 4 then
            level = 4
            BoostLevel4()
            Alert("💀 ULTRA LOW ACTIVADO")
        end
    end

    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

    local msColor = Color3.fromRGB(0,255,120)
    if ping > 180 then
        msColor = Color3.fromRGB(255,60,60)
    elseif ping > 100 then
        msColor = Color3.fromRGB(255,170,60)
    end

    hue = (hue + 0.008) % 1
    local rgb = Color3.fromHSV(hue,1,1)

    text.RichText = true
    text.Text =
        "<font color='rgb("..
        math.floor(rgb.R*255)..","..
        math.floor(rgb.G*255)..","..
        math.floor(rgb.B*255)..")'>L</font> "..
        "<font color='rgb(255,255,255)'>"..fps.." FPS</font> | "..
        "<font color='rgb("..
        math.floor(msColor.R*255)..","..
        math.floor(msColor.G*255)..","..
        math.floor(msColor.B*255)..")'>"..
        ping.." MS</font>"
end)

Alert("😈 LEGNA ULTRA LOW LISTO")
print("😈 ULTRA LOW GOD MODE ACTIVADO")
