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

    -- Set text color method for the ListView
    function self:SetTextColor(color)
        self.textColor = color
    end
    self.highlightColor = Color(60, 60, 60) -- Highlight color
    self.multiSelect = false -- By default, multiSelect is false
    self.selectedRows = {} -- Table to store the selected rows
end

-- Add a column
function PANEL:AddColumn(name)
    local col = {
        name = name,
        textColor = Color(255, 255, 255),
        width = self:GetWide() / (#self.columns + 1) -- Example column width
    }
    table.insert(self.columns, col)

    function col:SetTextColor(color)
        self.textColor = color
    end

    return col
end

-- Add a row
function PANEL:AddLine(...)
    local line = {...}
    function line:SetTextColor(color)
        for _, cell in ipairs(self) do
            if isstring(cell) then
                -- Modify the cell value to include a color
                self[_] = {text = cell, color = color}
            elseif istable(cell) and cell.text then
                cell.color = color
            end
        end
    end
    table.insert(self.rows, line)
    return line
end

-- Set MultiSelect
function PANEL:SetMultiSelect(bool)
    self.multiSelect = bool
end

-- Get MultiSelect
function PANEL:GetMultiSelect()
    return self.multiSelect
end

-- Helper function to truncate text if it's too long
local function TruncateText(text, maxWidth)
    local textWidth, textHeight = surface.GetTextSize(text)
    if textWidth <= maxWidth then
        return text
    end

    local truncatedText = text
    while textWidth > maxWidth do
        truncatedText = string.sub(truncatedText, 1, -2) .. "..."
        textWidth, textHeight = surface.GetTextSize(truncatedText)
    end

    return truncatedText
end

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
            local cellText = TruncateText(cell, colWidth) -- Use the truncate function
            
            -- Highlighting rows (this can be expanded for multi-select)
            if self:IsHovered() then
                local mouseX, mouseY = self:CursorPos()
                if mouseX > (j - 1) * colWidth and mouseX < j * colWidth and mouseY > self.headerHeight + (i - 1) * self.headerHeight and mouseY < self.headerHeight + i * self.headerHeight then
                    draw.RoundedBox(0, (j - 1) * colWidth, self.headerHeight + (i - 1) * self.headerHeight, colWidth, self.headerHeight, self.highlightColor)
                end
            end
            draw.SimpleText(cellText, "DermaDefault", j * colWidth - colWidth / 2, self.headerHeight + (i - 0.5) * self.headerHeight, self.textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end

vgui.Register("Dlib.ListView", PANEL)

-- Set background color method for the ListView
function PANEL:SetBackgroundColor(color)
    self.BackgroundColor = color
end

-- Set header height method for the ListView
function PANEL:SetHeaderHeight(height)
    self.headerHeight = height
end
