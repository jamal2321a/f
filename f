local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

--Player Variables
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
	print(petName)
	local ui = playerGui.ScreenGui.Inventory.Frame.Inner.Pets.Main.ScrollingFrame.Pets
	for _, child in ipairs(ui:GetChildren()) do
 		if child.Name == "Frame" then
   		return
     end
		if child:IsA("Frame") then
			local pet = child.Inner.Button.Inner.DisplayName.Text
   print("Checking pet:", pet and pet or "N/A", "against", petName)

			if pet == petName then
				return child.Name
			end
		end
	end
end




--Tavs

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
local EnchantsNeeded = ""

--Variables

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

local Codes = {
    ["release"] = true,
    ["lucky"] = true,
    ["thanks"] = true
}

local EnchantTable = {
    "🫧 Bubbler I",
    "🫧 Bubbler II",
    "🫧 Bubbler III",
    "🫧 Bubbler IV",
    "🫧 Bubbler V",
    "💰 Looter I",
    "💰 Looter II",
    "💰 Looter III",
    "💰 Looter IV",
    "💰 Looter V",
    "✨ Gleaming I",
    "✨ Gleaming II",
    "✨ Gleaming III",
    "⚡ Team Up I",
    "⚡ Team Up II",
    "⚡ Team Up III",
    "⚡ Team Up IV",
    "⚡ Team Up V"
}




--bubble section

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
                task.wait(1)
            end
        end)
    end
})

--auto claim section

ClaimSection:AddToggle("AutoClaimPlaytime", {
    Title = "Auto Claim Playtime Rewards!",
    Description = "Automatically Claims Playtime Rewards!",
    Default = false,
    Callback = function(Value)
        AutoClaimPlaytime = Value
        task.spawn(function()
            while AutoClaimPlaytime do
                for i = 1, 9 do
                    local args = {
                        [1] = "ClaimPlaytime",
                        [2] = i
                    }
                    game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Function:InvokeServer(unpack(args))
                end
                task.wait(60)
            end
        end)
    end
})

ClaimSection:AddToggle("autoClaimSpin", {
    Title = "Auto Claim Spin",
    Description = "Automatically Claims spin ticket!",
    Default = false,
    Callback = function(Value)
        autoClaimSpin = Value
        task.spawn(function()
            while autoClaimSpin do
                local args = {
                    [1] = "ClaimFreeWheelSpin"
                }
                game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer(unpack(args))
                task.wait(60)
            end
        end)
    end
})

ClaimSection:AddToggle("autoClaimDoggyJump", {
    Title = "Auto Claim Doggy Jump Rewards",
    Description = "Automatically Claims Doggy Jump rewards 30m cooldown",
    Default = false,
    Callback = function(Value)
        autoClaimDoggyJump = Value
        task.spawn(function()
            while autoClaimDoggyJump do
                for i = 1, 3 do
                    local args = {
                        [1] = "DoggyJumpWin",
                        [2] = i
                    }
                    game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer(unpack(args))
                end
                task.wait(60)
            end
        end)
    end
})

ClaimSection:AddToggle("autoClaimChests", {
    Title = "Auto Claim Chests",
    Description = "Automatically Claims Chests (Will teleport you)",
    Default = false,
    Callback = function(Value)
        autoClaimChests = Value
        task.spawn(function()
    
        end)
    end
})

--Quick section

EnchantSection:AddInput("Input", {
    Title = "Pet Name",
    Default = "",
    Placeholder = "Enter Pet Name",
    Numeric = false, -- Only allows numbers
    Finished = false, -- Only calls callback when you press enter
    Callback = function(Value)
       EnchantPetInput = Value
    end
})

EnchantSection:AddDropdown("MultiDropdown", {
    Title = "Choose Enchants",
    Description = "Select one or more enchants to auto roll for",
    Values = EnchantTable,
    Multi = true,
    Default = {"🫧 Bubbler I"},
})

EnchantSection:AddButton({
    Title = "Auto Enchant Start",
    Description = "Automatically enchants pets until wanted enchant is rolled",
    Callback = function()
        Window:Dialog({
            Title = "Are you sure you want to roll for enchants?",
            Content = "(Rolling will stop after 100 tries without success just start it again!)",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        local petuuid = GetPetUUID(EnchantPetInput)
                        print(petuuid)
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the dialog.")
                    end
                }
            }
        })
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
