-- file_loader.lua

-- Funkcja do rekursywnego dodawania plików .lua do listy pobierania
local function AddFilesFromFolder(folder)
    local files, folders = file.Find(folder .. "/*", "LUA")

    for _, v in ipairs(files) do
        if string.EndsWith(v, ".lua") then
            AddCSLuaFile(folder .. "/" .. v)
        end
    end

    for _, dir in ipairs(folders) do
        AddFilesFromFolder(folder .. "/" .. dir)
    end
end

-- Funkcja do wywołania z zewnątrz
function LoadClientFiles()
    AddFilesFromFolder("dlib/lua/client")
end
