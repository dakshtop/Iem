local lp = game:GetService("Players").LocalPlayer
local mt = getrawmetatable(game)
setreadonly(mt, false)

local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    if getnamecallmethod() == "Kick" and self == lp then
        return
    end
    return old(self, ...)
end)

local Scripts = {
    {
        PlacesIds = {2753915549, 4442272183, 7449423635},
        UrlPath = "BloxFruits.luau"
    },
    {
        PlacesIds = {10260193230},
        UrlPath = "MemeSea.luau"
    },
}

local fetcher, urls = {}, {}
local _ENV = (getgenv or getrenv or getfenv)()

urls.Owner = "https://raw.githubusercontent.com/tlredz/"
urls.Repository = urls.Owner .. "Scripts/1e7bace8136335f63820832fa1aed73b3bac2922/"
urls.Translator = urls.Repository .. "Translator/"
urls.Utils = urls.Repository .. "Utils/"

local function formatUrl(Url)
    for key, path in urls do
        if Url:find("{" .. key .. "}") then
            return (Url:gsub("{" .. key .. "}", path))
        end
    end
    return Url
end

function fetcher.get(Url)
    local success, response = pcall(function()
        return game:HttpGet(formatUrl(Url))
    end)
    if not success then
        error("[Locked Loader] Failed to get URL: " .. Url .. "\n>> " .. tostring(response) .. " <<", 2)
    end
    return response
end

function fetcher.load(Url: string, concat: string?)
    local raw = fetcher.get(Url) .. (concat or "")
    local fn, err = loadstring(raw)
    if not fn then
        error("[Locked Loader] Syntax error in: " .. Url .. "\n>> " .. tostring(err) .. " <<", 2)
    end
    return fn
end

local function IsPlace(Script)
    if Script.PlacesIds and table.find(Script.PlacesIds, game.PlaceId) then
        return true
    elseif Script.GameId and Script.GameId == game.GameId then
        return true
    end
end

for _, Script in Scripts do
    if IsPlace(Script) then
        return fetcher.load("{Repository}Games/" .. Script.UrlPath)(fetcher, ...)
    end
end