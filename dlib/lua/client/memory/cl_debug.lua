
-- Create the debug window
concommand.Add("debug-ui", function()
    if not LocalPlayer():IsAdmin() then
        chat.AddText(Color(255, 0, 0), "You do not have permission to use this command.")
        return
    end

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

    -- Request the server for the addon details
    net.Start("RequestAddonDetailsFromServer")
    net.SendToServer()

    net.Receive("SendAddonDetailsToClient", function()
        local addonDetails = net.ReadTable()
        for _, details in ipairs(addonDetails) do
            list:AddLine(details.name, tostring(details.loadOnStart), details.side, table.concat(details.functions, ", "))
        end
    end)
end)

print("Client-side Debug initialized.")
