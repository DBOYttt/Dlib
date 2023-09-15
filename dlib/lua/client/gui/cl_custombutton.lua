local PANEL = {}

function PANEL:Init()
    self:SetText("") -- Usuń domyślny tekst przycisku
    self.customText = "Button"
    self.font = "DermaDefaultBold"
    self.textColor = Color(255, 255, 255)
    self.hoverColor = Color(50, 50, 50)
    self.defaultColor = Color(40, 40, 40)
end

function PANEL:SetCustomText(txt)
    self.customText = txt
end

function PANEL:GetCustomText()
    return self.customText
end

function PANEL:SetFontCustom(fontName)
    self.font = fontName
end

function PANEL:SetTextColorCustom(col)
    self.textColor = col
end

function PANEL:Paint(w, h)
    local col = self.defaultColor

    if self:IsHovered() then
        col = self.hoverColor
    end

    draw.RoundedBox(4, 0, 0, w, h, col)
    draw.SimpleText(self.customText, self.font, w / 2, h / 2, self.textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

vgui.Register("Dlib.Button", PANEL, "DButton")
