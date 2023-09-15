-- debug.lua

-- Ensure Dlib is available
if not Dlib then
    print("Dlib not found! Debug functionality will not be available.")
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
        print("Failed to read content from:", filePath)
        return 
    elseif content == "" then
        print("Failed to read content from:", filePath)
        return 
    end

    print("Content of the file:", filePath)
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


-- Create the debug window
concommand.Add("debug", function()
    local frame = vgui.Create("Dlib.Frame")
    frame:SetSize(600, 400)
    frame:Center()
    frame:SetTitle("Debug Window")
    frame:MakePopup()

    local list = vgui.Create("DListView", frame)
    list:SetSize(550, 300)
    list:SetPos(25, 50)
    list:AddColumn("Addon Name")
    list:AddColumn("Load on Start")
    list:AddColumn("Side")
    list:AddColumn("Functions")

    local foundAddons = ScanForAddons()
    for _, addonPath in ipairs(foundAddons) do
        local details = ExtractAddonDetails(addonPath)
        if details then
            list:AddLine(details.name, tostring(details.loadOnStart), details.side, table.concat(details.functions, ", "))
        else
            print("Failed to extract details for:", addonPath)
        end
    end        
end)

print("Debug initialized.")
