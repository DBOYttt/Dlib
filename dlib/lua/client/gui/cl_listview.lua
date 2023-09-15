local PANEL = {}

-- Initialize the panel
function PANEL:Init()
    self.columns = {}
    self.rows = {}
    self:SetSize(550, 300)
    self.BackgroundColor = Color(40, 40, 40) -- Background color
    self.headerHeight = 30 -- Header height
    self.headerColor = Color(30, 30, 30) -- Header color
    self.textColor = Color(200, 200, 200) -- Text color
    self.highlightColor = Color(60, 60, 60) -- Highlight color
end

-- Add a column
function PANEL:AddColumn(name)
    local col = {
        name = name,
        width = self:GetWide() / (#self.columns + 1) -- Example column width
    }
    table.insert(self.columns, col)
end

-- Add a row
function PANEL:AddLine(...)
    local line = {...}
    table.insert(self.rows, line)
end

-- Paint the panel
function PANEL:Paint(w, h)
    -- Paint the header
    if self.headerColor then
        draw.RoundedBox(0, 0, 0, w, self.headerHeight, self.headerColor)
    end

    -- Paint column names
    local colWidth = w / #self.columns
    for i, col in ipairs(self.columns) do
        draw.SimpleText(col.name, "DermaDefaultBold", (i - 0.5) * colWidth, self.headerHeight / 2, self.textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    -- Paint rows
    for i, row in ipairs(self.rows) do
        for j, cell in ipairs(row) do
            draw.SimpleText(cell, "DermaDefault", j * colWidth - colWidth / 2, self.headerHeight + (i - 0.5) * self.headerHeight, self.textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end

vgui.Register("Dlib.ListView", PANEL)
