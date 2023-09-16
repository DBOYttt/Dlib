local BLOCK = {}


function BLOCK:Init()
    self:SetSize(200, 200)
    self.isDragging = false
    self.dragOffsetX = 0
    self.dragOffsetY = 0
    self.color = Color(255, 100, 100)
    self.connectorLength = 30
    self.connectedBlock = nil -- przechowuje informacje o połączonym bloczku
end
function BLOCK:SetBlockColor(col)
    self.color = col
end

function BLOCK:CheckCollision(other)
    local x, y = self:GetPos()
    local ox, oy = other:GetPos()
    local w, h = self:GetSize()
    local ow, oh = other:GetSize()

    return x < ox + ow and x + w > ox and y < oy + oh and y + h > oy
end

function BLOCK:SetBarSide(side)
    if side == "left" or side == "right" then
        self.barSide = side
    end
end

function BLOCK:Disconnect()
    if self.connectedBlock then
        self.connectedBlock.connectedBlock = nil
        self.connectedBlock = nil
    end
end


function BLOCK:OnMousePressed()
    self.isDragging = true
    local x, y = self:CursorPos()
    self.dragOffsetX = x
    self.dragOffsetY = y
    self:Disconnect() -- Rozłącz bloczki, gdy jeden z nich jest przeciągany
end

function BLOCK:OnMouseReleased()
    self.isDragging = false
end

function BLOCK:Think()
    if self.isDragging then
        local px, py = self:GetParent():CursorPos()
        local newX = math.Clamp(px - self.dragOffsetX, 0, self:GetParent():GetWide() - self:GetWide())
        local newY = math.Clamp(py - self.dragOffsetY, 0, self:GetParent():GetTall() - self:GetTall())
        
        -- Jeśli bloczki są połączone, sprawdź, czy nie wychodzą poza lewą krawędź
        if self.connectedBlock then
            local combinedWidth = self:GetWide() + self.connectedBlock:GetWide()
            if newX + combinedWidth > self:GetParent():GetWide() then
                newX = self:GetParent():GetWide() - combinedWidth
            end
        end
        
        -- Sprawdzanie kolizji z innymi bloczkami tylko wtedy, gdy bloczki nie są połączone
        if not self.connectedBlock then
            for _, v in pairs(self:GetParent():GetChildren()) do
                if v != self and v:GetName() == "Dlib.Block" then
                    if self:CheckCollision(v) then
                        self.connectedBlock = v
                        v.connectedBlock = self -- Dodajemy tę linię, aby określić, który bloczek jest "pierwszym" bloczkiem w połączeniu
                        isConnected = true
                        break
                    end
                end
            end
        end

        self:SetPos(newX, newY)
        
        -- Jeśli bloczki są połączone, przesuwaj je razem
        if self.connectedBlock then
            self.connectedBlock:SetPos(newX + self:GetWide(), newY)
        end
    end
end

-- Ustaw szerokość bloczka
function BLOCK:SetBlockWidth(width)
    local currentW, currentH = self:GetSize()
    self:SetSize(width, currentH)
end

-- Ustaw wysokość bloczka
function BLOCK:SetBlockHeight(height)
    local currentW, currentH = self:GetSize()
    self:SetSize(currentW, height)
end

function BLOCK:Paint(w, h)
    -- Ciemne tło
    surface.SetDrawColor(60, 60, 60)
    surface.DrawRect(0, 0, w, h)

    -- Jasny pasek po lewej lub prawej stronie
    surface.SetDrawColor(self.color)
    local barWidth = 3 -- Ustawiamy szerokość paska na 3 piksele
    
    if self.connectedBlock then
        if self.connectedBlock == self then
            surface.DrawRect(0, 0, barWidth, h) -- Jeśli ten bloczek jest głównym bloczkiem połączenia, rysuj pasek po lewej stronie
        else
            surface.DrawRect(w - barWidth, 0, barWidth, h) -- Jeśli ten bloczek jest drugim bloczkiem połączenia, rysuj pasek po prawej stronie
        end
    else
        surface.DrawRect(w - barWidth, 0, barWidth, h) -- Jeśli bloczek nie jest połączony, rysuj pasek po prawej stronie
    end
    

    surface.SetDrawColor(self.color)

    if self.connectedBlock then
        if self.connectedBlock.connectedBlock == self then
            surface.DrawRect(0, 0, barWidth, h) -- Jeśli ten bloczek jest "pierwszym" bloczkiem w połączeniu, rysuj pasek po lewej stronie
        else
            surface.DrawRect(w - barWidth, 0, barWidth, h) -- Jeśli ten bloczek jest "drugim" bloczkiem w połączeniu, rysuj pasek po prawej stronie
        end
    else
        surface.DrawRect(w - barWidth, 0, barWidth, h) -- Jeśli bloczek nie jest połączony, rysuj pasek po prawej stronie
    end

    -- Rysowanie zaczepu
    surface.DrawRect(w/2 - 5, h, 10, self.connectorLength)

    -- Jeśli bloczki są połączone, rysuj łączenie
    if self.connectedBlock then
        surface.SetDrawColor(255, 255, 255)
        surface.DrawRect(w/2 - 5, h + self.connectorLength, 10, 10)
    end
end

vgui.Register("Dlib.Block", BLOCK, "DPanel")
