-- Definiowanie niestandardowego Dlib.CircleSwitch panelu
local PANEL = {}

function PANEL:Init()
    self:SetSize(60, 30)
    self.isOn = false
    self.circleX = 5 + 10 -- 5 to odstęp, 10 to połowa szerokości koła
    self.targetX = self.circleX
end

function PANEL:SetValue(val)
    self.isOn = val
    self.targetX = self.isOn and (self:GetWide() - 15) or (5 + 10)
end

function PANEL:GetValue()
    return self.isOn
end

function PANEL:OnMousePressed()
    self:SetValue(not self:GetValue())
end

function PANEL:Think()
    self.circleX = Lerp(0.05, self.circleX, self.targetX) -- Zmniejszony współczynnik dla wolniejszej animacji
end

function PANEL:Paint(w, h)
    local bgColor = self.isOn and Color(50, 150, 50) or Color(150, 50, 50)
    draw.RoundedBox(15, 0, 0, w, h, bgColor)
    draw.RoundedBox(8, self.circleX - 10, 5, 20, 20, Color(200, 200, 200))
end

vgui.Register("Dlib.CircleSwitch", PANEL, "DPanel")
