-- Fixes applied, Auto Claim Chests left untouched

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Player Variables
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Window = Fluent:CreateWindow({
    Title = "Bubble Gum Simulator Infinity",
    SubTitle = "~Exploit~",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Workspace references
local Rendered = workspace:WaitForChild("Rendered")
local targetChunker = nil

for _, chunker in ipairs(Rendered:GetChildren()) do
    if chunker:IsA("Folder") and chunker.Name:find("Chunker") then
        local models = chunker:GetChildren()
        local uuidLikeCount = 0
        for _, model in ipairs(models) do
            if model:IsA("Model") and model.Name:match("^[%x%-]+$") and #model.Name > 10 then
                uuidLikeCount += 1
            end
        end
        if uuidLikeCount > 10 then
            targetChunker = chunker
            break
        end
    end
end

local function convertToSeconds(timeString)
    if string.match(timeString, "^%d+:%d+$") then
        local minutes, seconds = string.match(timeString, "(%d+):(%d+)")
        return tonumber(minutes) * 60 + tonumber(seconds)
    elseif string.match(timeString, "^%d+s$") then
        local seconds = string.match(timeString, "(%d+)s")
        return tonumber(seconds)
    else
        warn("Invalid time format: " .. timeString)
        return nil
    end
end

local function GetPetUUID(petName)
    local ui = playerGui:WaitForChild("ScreenGui"):WaitForChild("Inventory").Frame.Inner.Pets.Main.ScrollingFrame.Pets
    for _, child in ipairs(ui:GetChildren()) do
        if child:IsA("Frame") then
            local pet = child.Inner.Button.Inner.DisplayName.Text
            if pet == petName then
                return child.Name
            end
        end
    end
    return nil
end

-- Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "gamepad-2" }),
    More = Window:AddTab({ Title = "Quick Unlock", Icon = "clock" }),
    Settings = Window:AddTab({ Title = "Interface", Icon = "mouse-pointer-2" })
}

-- Sections
local BubbleSection = Tabs.Main:AddSection("Bubble Options")
local ClaimSection = Tabs.Main:AddSection("Auto Claim")
local EnchantSection = Tabs.More:AddSection("Enchant")

local Options = Fluent.Options

-- Toggles
local autoClaimDoggyJump = false
local autoClaimChests = false
local autoBubbleEnabled = false
local autoSellEnabled = false
local autoPickupEnabled = false
local autoClaimSpin = false
local AutoClaimPlaytime = false

local EnchantPetInput = ""
local SelectedEnchants = {"🫧 Bubbler I"}

-- Constants
local Chests = {
    ["Giant Chest"] = {
        Time = 900,
        TeleportDestination = "Workspace.Worlds.The Overworld.Islands.Outer Space.Island.Portal.Spawn"
    },
    ["Void Chest"] = {
        Time = 2400,
        TeleportDestination = "Workspace.Worlds.The Overworld.Islands.The Void.Island.Portal.Spawn"
    }
}

local EnchantTable = {
    "🫧 Bubbler I", "🫧 Bubbler II", "🫧 Bubbler III", "🫧 Bubbler IV", "🫧 Bubbler V",
    "💰 Looter I", "💰 Looter II", "💰 Looter III", "💰 Looter IV", "💰 Looter V",
    "✨ Gleaming I", "✨ Gleaming II", "✨ Gleaming III",
    "⚡ Team Up I", "⚡ Team Up II", "⚡ Team Up III", "⚡ Team Up IV", "⚡ Team Up V"
}

-- Bubble Section
BubbleSection:AddToggle("autoBubbleEnabled", {
    Title = "Auto Bubble",
    Description = "Automatically Blows Bubbles!",
    Default = false,
    Callback = function(Value)
        autoBubbleEnabled = Value
        task.spawn(function()
            while autoBubbleEnabled do
                game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("BlowBubble")
                task.wait(0.2)
            end
        end)
    end
})

BubbleSection:AddToggle("autoSellEnabled", {
    Title = "Auto Sell",
    Description = "Automatically Sells Bubbles!",
    Default = false,
    Callback = function(Value)
        autoSellEnabled = Value
        task.spawn(function()
            while autoSellEnabled do
                game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("SellBubble")
                task.wait(0.2)
            end
        end)
    end
})

BubbleSection:AddToggle("autoPickupEnabled", {
    Title = "Auto Pickup",
    Description = "Automatically Pick's up Breakables!",
    Default = false,
    Callback = function(Value)
        autoPickupEnabled = Value
        task.spawn(function()
            while autoPickupEnabled do
                if targetChunker then
                    for _, child in ipairs(targetChunker:GetChildren()) do
                        if child:IsA("Model") then
                            game:GetService("ReplicatedStorage").Remotes.Pickups.CollectPickup:FireServer(child.Name)
                            task.wait(0.1)
                            child:Destroy()
                        end
                    end
                else
                    warn("No suitable Chunker folder found.")
                end
                task.wait(1)
            end
        end)
    end
})

-- Auto Claim Section
ClaimSection:AddToggle("AutoClaimPlaytime", {
    Title = "Auto Claim Playtime Rewards!",
    Description = "
