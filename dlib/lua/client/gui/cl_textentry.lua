-- Definiowanie niestandardowego ModernTextEntry panelu
local PANEL = {}

function PANEL:Init()
    -- Domyślne ustawienia
    self:SetSize(300, 30) -- Domyślny rozmiar
    self:SetFont("DermaDefault") -- Domyślna czcionka
    self:SetTextColor(Color(200, 200, 200)) -- Kolor tekstu
    self:SetText("") -- Domyślny tekst

    -- Tło
    self.bgColor = Color(50, 50, 50)

    -- Placeholder
    self.placeholderColor = Color(100, 100, 100)
    self.placeholderText = ""

    -- Kiedy panel jest aktywny
    self.OnGetFocus = function(self)
        self.bgColor = Color(60, 60, 60)
    end

    -- Kiedy panel traci fokus
    self.OnLoseFocus = function(self)
        self.bgColor = Color(50, 50, 50)
    end
end

-- Ustawienie tekstu placeholdera
function PANEL:SetPlaceholderText(text)
    self.placeholderText = text
end

-- Niestandardowe renderowanie
function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, self.bgColor) -- Tło z zaokrąglonymi rogami

    -- Jeśli pole jest puste i nie ma fokusu, wyświetl tekst placeholdera
    if self:GetValue() == "" and not self:HasFocus() then
        draw.SimpleText(self.placeholderText, "DermaDefault", 5, h/2, self.placeholderColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    -- Rysowanie wprowadzonego tekstu
    self:DrawTextEntryText(self:GetTextColor(), self:GetHighlightColor(), self:GetCursorColor())
end

-- Rejestracja niestandardowego ModernTextEntry
vgui.Register("Dlib.TextEntry", PANEL, "DTextEntry")
