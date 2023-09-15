-- sv_debug.lua
util.AddNetworkString("RequestAddonDetailsFromServer")
util.AddNetworkString("SendAddonDetailsToClient")

-- Ensure Dlib is available
if not Dlib then
    print("[Server] Dlib not found! Debug functionality will not be available.")
    return
end



-- Function to scan for addons using Dlib
local function ScanForAddons()
    local foundAddons = {}

    local _, directories = file.Find("addons/*", "GAME")
    for _, dir in ipairs(directories) do
        local luaFiles, _ = file.Find("addons/" .. dir .. "/lua/*.lua", "GAME")
        for _, luaFile in ipairs(luaFiles) do
            local content = file.Read("addons/" .. dir .. "/lua/" .. luaFile, "GAME")
            if content and string.match(content, "Dlib%.RegisterAddon") then
                table.insert(foundAddons, "addons/" .. dir .. "/lua/" .. luaFile)
                break
            end
        end
    end

    return foundAddons
end

-- Function to extract addon details from the file content
local function ExtractAddonDetails(filePath)
    local content = file.Read(filePath, "GAME")
    if not content then
        print("[Server] Failed to read content from:", filePath)
        return 
    elseif content == "" then
        print("[Server] Failed to read content from:", filePath)
        return 
    end

    print("[Server] Content of the file:", filePath)
    print(content)

    local addonName = string.match(content, 'Dlib%.RegisterAddon%("(.-)"')
    local loadOnStart = string.match(content, 'Dlib%.RegisterAddon%([^,]+, (%a+)')
    local side = string.match(content, 'Dlib%.RegisterAddon%([^,]+, [^,]+, "(.-)"')
    local functionsStr = string.match(content, 'Dlib%.RegisterAddon%([^,]+, [^,]+, [^,]+, {(.-)}')
    local functions = {}
    if functionsStr then
        for func in string.gmatch(functionsStr, '"(.-)"') do
            table.insert(functions, func)
        end
    end

    return {
        name = addonName,
        loadOnStart = loadOnStart == "true",
        side = side,
        functions = functions
    }
end

local function SendAddonDetailsToPlayer(ply)
    local foundAddons = ScanForAddons()
    local addonDetails = {}
    
    for _, addonPath in ipairs(foundAddons) do
        local details = ExtractAddonDetails(addonPath)
        if details then
            table.insert(addonDetails, details)
        end
    end

    net.Start("SendAddonDetailsToClient")
    net.WriteTable(addonDetails)
    net.Send(ply)
end

-- Listen for a request from the client
net.Receive("RequestAddonDetailsFromServer", function(len, ply)
    -- You can add additional checks here, e.g., if ply is an admin
    SendAddonDetailsToPlayer(ply)
end)

-- Create the debug command
concommand.Add("debug", function(ply)
    if not ply:IsAdmin() then
        ply:PrintMessage(HUD_PRINTCONSOLE, "You do not have permission to use this command.")
        return
    end

    local foundAddons = ScanForAddons()
    for _, addonPath in ipairs(foundAddons) do
        local details = ExtractAddonDetails(addonPath)
        if details then
            ply:PrintMessage(HUD_PRINTCONSOLE, "Addon Name: " .. details.name .. ", Load on Start: " .. tostring(details.loadOnStart) .. ", Side: " .. details.side .. ", Functions: " .. table.concat(details.functions, ", "))
        else
            ply:PrintMessage(HUD_PRINTCONSOLE, "Failed to extract details for: " .. addonPath)
        end
    end        
end)

print("[Server] Debug initialized.")
