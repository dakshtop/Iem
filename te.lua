queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/dakshtop/Iem/refs/heads/main/te.lua'))()")
loadstring(game:HttpGet('https://raw.githubusercontent.com/dakshtop/Iem/refs/heads/main/te.lua'))()
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function serverhop()
    local success, servers = pcall(function()
        local req = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local body = game:HttpGet(req)
        return HttpService:JSONDecode(body).data
    end)

    if success and servers then
        for _, v in pairs(servers) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                break
            end
        end
    end
end

LocalPlayer.Kick = function()
    serverhop()
    task.wait(9e9)
end