task.spawn(function()
    local HttpService = game:GetService("HttpService")
    local Hatching = true
    local hatches = player.leaderstats["🥚 Hatches"]
    
    task.wait(6)

    if hatches == player.leaderstats["🥚 Hatches"] then
        Hatching = false
    end

    http_request({
        Url = "https://discordapp.com/api/webhooks/...",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode({
            embeds = {
                {
                    title = "📊 STATUS UPDATE 📊",
                    description = player.Name.."'s Status Update",
                    fields = {
                        {
                            name = "🥚 Hatching?",
                            value = tostring(Hatching),
                            inline = true
                        },
                        {
                            name = "🎮 In Game?",
                            value = "true",
                            inline = true
                        }
                    },
                    color = 16426522
                }
            }
        })
    })

    task.wait(20)
end)
