concommand.Add("test", function()
    -- Tworzenie ramki Dlib.Frame
    local frame = vgui.Create("Dlib.Frame")
    frame:SetSize(500, 500)
    frame:Center()

    -- Dodawanie pierwszego Dlib.Block do ramki
    local block1 = vgui.Create("Dlib.Block", frame)
    block1:SetPos(50, 50)
    block1:SetBlockWidth(50)
    block1:SetBlockHeight(100)
    block1:SetBlockColor(Color(255, 0, 0))
    block1:SetBarSide("left") -- Ustawienie paska po lewej stronie

    -- Dodawanie drugiego Dlib.Block do ramki
    local block2 = vgui.Create("Dlib.Block", frame)
    block2:SetPos(200, 200)
    block2:SetBlockWidth(50)
    block2:SetBlockHeight(100)
    block2:SetBlockColor(Color(0, 255, 0))
    block2:SetBarSide("right") -- Ustawienie paska po prawej stronie
end)
