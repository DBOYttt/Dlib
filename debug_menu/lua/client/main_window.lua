local function CreateDebugWindow()
    local frame = vgui.Create("Dlib.Frame")
    frame:SetSize(800, 600) -- Setting the size of the window
    frame:Center() -- Center the window on the screen
    frame:SetTitle("Debug Menu") -- Set the window title

    -- Create a tab panel
    local tabs = vgui.Create("DLib.PropertySheet", frame)
    tabs:Dock(FILL)

    -- Adding the "Editor" tab
    local editorPanel = vgui.Create("DPanel", tabs)
    editorPanel:SetBackgroundColor(Color(255, 255, 255)) -- Set a white background for the editor panel
    tabs:AddSheet("Editor", editorPanel, "icon16/page_white_text.png")

    -- Populate the Editor tab with addon contents
    PopulateEditorWithAddonContents(editorPanel)
end

-- We can bind this function to a console command or a key to open the debug window
concommand.Add("open_debug_menu", CreateDebugWindow)

-- This function will populate the editorPanel with a list of files/folders from the 'addon' directory
function PopulateEditorWithAddonContents(panel)
    local listView = vgui.Create("Dlib.ListView", panel)
    listView:Dock(FILL)
    listView:SetMultiSelect(false)
    local col1 = listView:AddColumn("Name")
    col1:SetTextColor(Color(212, 212, 212))
    local col2 = listView:AddColumn("Type")
    col2:SetTextColor(Color(212, 212, 212))
    local col3 = listView:AddColumn("Path")
    col3:SetTextColor(Color(212, 212, 212))
    listView:SetBackgroundColor(Color(37, 37, 38))
    listView:SetHeaderHeight(25)
    listView.Paint = function(self, w, h)
        surface.SetDrawColor(Color(60, 60, 60))
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    -- Fetch the contents of the 'addon' directory
    local files, folders = file.Find("addons/*", "GAME")
    for _, folderName in pairs(folders) do
        listView:AddLine(folderName, "Folder", "addons/" .. folderName):SetTextColor(Color(212, 212, 212))
    end
    for _, fileName in pairs(files) do
        listView:AddLine(fileName, "File", "addons/" .. fileName):SetTextColor(Color(212, 212, 212))
    end
end
