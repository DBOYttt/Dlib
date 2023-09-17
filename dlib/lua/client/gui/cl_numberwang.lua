local NUMBERWANG = {}

function NUMBERWANG:Init()
    self:SetTextColor(Color(255, 255, 255))
    self:SetFont("DermaDefault")
end

function NUMBERWANG:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
    draw.RoundedBox(0, 0, 0, 3, h, Color(255, 100, 100))
    
    -- Dodajemy wyświetlanie tekstu
    draw.SimpleText(self:GetValue(), "DermaDefault", w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

-- Dostosowanie przycisków do zwiększania i zmniejszania wartości
function NUMBERWANG:PaintUpButton(w, h)
    if self:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(80, 80, 80))
    else
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
    end
    draw.SimpleText("+", "DermaDefault", w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function NUMBERWANG:PaintDownButton(w, h)
    if self:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(80, 80, 80))
    else
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
    end
    draw.SimpleText("-", "DermaDefault", w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

vgui.Register("Dlib.NumberWang", NUMBERWANG, "DNumberWang")
