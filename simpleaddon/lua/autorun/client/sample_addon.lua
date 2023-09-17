concommand.Add("test", function()
    -- Tworzenie głównego okna
    local frame = vgui.Create("Dlib.Frame")
    frame:SetSize(400, 300)
    frame:Center()
    frame:SetTitle("Test Dlib.ComboBox")
    frame:MakePopup()

    -- Tworzenie Dlib.ComboBox
    local combo = vgui.Create("Dlib.ComboBox", frame)
    combo:SetPos(50, 50)
    combo:SetSize(300, 30)
    combo:AddChoice("Opcja 1")
    combo:AddChoice("Opcja 2")
    combo:AddChoice("Opcja 3")
    combo.OnSelect = function(panel, index, value)
        print("Wybrano:", value)
    end
end)