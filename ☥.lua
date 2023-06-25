-- // haunts#0001 | .gg/cfgs \\ --
local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/ekitteny/streamable/main/%F0%9F%9C%8F.lua"))()

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CurrentCamera = Workspace.CurrentCamera

local Settings = {
    SilentAim = true,
    Lock = false,
    Prediction = 0.13873,
    LockKey = Enum.KeyCode.C
    }

getgenv().Settings = Settings

function Aiming.Check()
    if not (Aiming.Enabled == true and Aiming.Selected ~= LocalPlayer and Aiming.SelectedPart ~= nil) then
        return false
    end
    local Character = Aiming.Character(Aiming.Selected)
    local KOd = Character:WaitForChild("BodyEffects")["K.O"].Value
    local Grabbed = Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
    if (KOd or Grabbed) then
        return false
    end
        return true
    end

local __index
__index = hookmetamethod(game, "__index", function(t, k)
    if (t:IsA("Mouse") and (k == "Hit" or k == "Target") and Aiming.Check()) then
        local SelectedPart = Aiming.SelectedPart
        if (Settings.SilentAim and (k == "Hit" or k == "Target")) then
            local Hit = SelectedPart.CFrame + (SelectedPart.Velocity * Settings.Prediction)
            return (k == "Hit" and Hit or SelectedPart)
        end
    end
    return __index(t, k)
end)

RunService:BindToRenderStep("Lock", 0, function()
    if (Settings.Lock and Aiming.Check() and UserInputService:IsKeyDown(Settings.LockKey)) then
        local SelectedPart = Aiming.SelectedPart
        local Hit = SelectedPart.CFrame + (SelectedPart.Velocity * Settings.Prediction)
        CurrentCamera.CFrame = CFrame.lookAt(CurrentCamera.CFrame.Position, Hit.Position)
    end
 end)