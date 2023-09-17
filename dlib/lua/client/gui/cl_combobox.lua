local COMBO = {}

function COMBO:Init()
    self:SetTall(30)
    self:SetTextColor(Color(255, 255, 255))
    self:SetFont("DermaDefault")
end

function COMBO:OpenMenu(pControlOpener)
    if pControlOpener and pControlOpener == self.TextEntry then
        return
    end

    -- Jeśli menu już istnieje, usuń je
    if IsValid(self.Menu) then
        self.Menu:Remove()
        self.Menu = nil
    end

    self.Menu = DermaMenu(self)

    -- Ustawienie koloru tła dla całego menu
    self.Menu.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
    end

    for k, v in pairs(self.Choices) do
        local option = self.Menu:AddOption(v, function() self:ChooseOption(v, k) end)
        option:SetTextColor(Color(255, 255, 255))

        -- Ustawienie koloru tła dla każdej opcji w menu
        option.Paint = function(s, w, h)
            if s:IsHovered() then
                draw.RoundedBox(0, 0, 0, w, h, Color(80, 80, 80))
            else
                draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
            end
        end
    end

    local x, y = self:LocalToScreen(0, self:GetTall())

    self.Menu:SetMinimumWidth(self:GetWide())
    self.Menu:Open(x, y, false, self)
end

function COMBO:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
    draw.RoundedBox(0, 0, 0, 3, h, Color(255, 100, 100))
end

vgui.Register("Dlib.ComboBox", COMBO, "DComboBox")
