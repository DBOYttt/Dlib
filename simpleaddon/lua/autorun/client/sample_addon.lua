-- Funkcja, która tworzy i pokazuje nasze okno
local function ShowCustomUI()
    local frame = vgui.Create("Dlib.Frame")
    frame:SetSize(600, 400)
    frame:Center()
    frame:SetTitle("Testowy interfejs")
    frame:MakePopup()

    local circleSwitch = vgui.Create("Dlib.CircleSwitch", frame)
    circleSwitch:SetPos(250, 180)
end

-- Dodanie komendy "test", która wywoła naszą funkcję
concommand.Add("test", ShowCustomUI)