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

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "gamepad-2" }),
    Settings = Window:AddTab({ Title = "Interface", Icon = "ethernet-port" })
}

local Options = Fluent.Options
local BubbleSection = Tabs.Main:AddSection("Bubble Stuff")

local autoBubbleEnabled = false

BubbleSection:AddToggle("autoBubbleEnabled", {
    Title = "Auto Bubble",
    Description = "Automatically Blows Bubbles!",
    Default = false,
    Callback = function(Value)
        autoBubbleEnabled = Value
        task.spawn(function()
            while autoBubbleEnabled do
                game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("BlowBubble")
                task.wait(0.1)
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
