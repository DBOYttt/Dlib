Dlib = Dlib or {}

-- Load client-side resources
if CLIENT then
    -- Load resources from the gui folder
    include("client/gui/cl_frame.lua")

    -- Load resources from the memory folder
    include("client/memory/cl_debug.lua")
    
    -- ... include any other client-side files from the memory folder here
end

-- Load server-side resources
if SERVER then
    --include("server/some_server_file.lua") -- Jeśli masz jakiś inny plik serwera
    include("server/file_loader.lua") -- Include the file loader

    -- Use the function to load all client files
    LoadClientFiles()
end

print("Shared.lua loaded!")

