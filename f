-- Load Fluent and addons
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Create main window
local Window = Fluent:CreateWindow({
    Title = "Bubble Gum Simulator Infinity",
    SubTitle = "~Exploit~",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Set to false if blur causes detection
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Create tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "gamepad-2" }),
    Settings = Window:AddTab({ Title = "Interface", Icon = "ethernet-port" })
}

local Options = Fluent.Options

-- Auto Bubble toggle
local AutoBubbleToggle = Tabs.Main:AddToggle("AutoBubbleToggle", {
    Title = "Auto Bubble",
    Default = false
})

AutoBubbleToggle:OnChanged(function(Value)
    while Value and Options.AutoBubbleToggle.Value do
        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("BlowBubble")
        task.wait(0.1)
    end
end)

-- Optional: Reset toggle on script start
Options.AutoBubbleToggle:SetValue(false)

-- Initial notification
Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- Interface/Save Manager Setup
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Load any auto-load configs
SaveManager:LoadAutoloadConfig()

-- Select the default tab
Window:SelectTab(1)
