-- Funkcja, która tworzy i pokazuje nasze okno
local function ShowCustomUI()
    local frame = vgui.Create("Dlib.Frame")
    frame:SetSize(600, 400)
    frame:Center()
    frame:SetTitle("Testowy interfejs")

    local textEntry = vgui.Create("Dlib.TextEntry", frame)
    textEntry:SetPos(150, 180)
    textEntry:SetSize(300, 30)
    textEntry:SetPlaceholderText("Wpisz coś tutaj...")
end

-- Dodanie komendy "test", która wywoła naszą funkcję
concommand.Add("test", ShowCustomUI)
