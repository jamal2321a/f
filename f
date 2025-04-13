local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Bubble Gum Simulator Infinity",
    SubTitle = "~Exploit~",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

--Functions

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

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "gamepad-2" }),
    Settings = Window:AddTab({ Title = "Interface", Icon = "ethernet-port" })
}

-- Sections
local BubbleSection = Tabs.Main:AddSection("Bubble Options")

local Options = Fluent.Options


-- Toggles
local autoClaimDoggyJump = false
local autoClaimChests = false
local autoBubbleEnabled = false
local autoSellEnabled = false
local autoPickupEnabled = false
local autoClaimSpin = false
local AutoClaimPlaytime = false

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
                        if child and child:IsA("Model") then
                            local args = {
                                [1] = child.Name
                            }
                            game:GetService("ReplicatedStorage").Remotes.Pickups.CollectPickup:FireServer(unpack(args))
                            task.wait(0.1)
                            if child then
                                child:Destroy()
                            end
                        end
                    end
                else
                    warn("No suitable Chunker folder found.")
                end
                task.wait(2.5)
            end
        end)
    end
})


Fluent:Notify({
    Title = "Notification",
    Content = "This is a notification",
    SubContent = "SubContent",
    Duration = 5
})

-- Setup SaveManager and InterfaceManager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
