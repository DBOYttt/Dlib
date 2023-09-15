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

local function CreateDynamicWindow(text)
    if IsValid(currentDetailWindow) then
        currentDetailWindow:Close() -- Close the existing window if it's open
    end

    local textWidth, textHeight = surface.GetTextSize(text)
    
    -- Ensure a minimum width and height for readability
    local minWidth, minHeight = 200, 100
    local finalWidth = math.max(textWidth + 40, minWidth)
    local finalHeight = math.max(textHeight + 60, minHeight) -- Added some padding for better appearance

    currentDetailWindow = vgui.Create("Dlib.Frame")
    currentDetailWindow:SetSize(finalWidth, finalHeight)
    currentDetailWindow:Center()
    currentDetailWindow:SetTitle("Details")
    currentDetailWindow:MakePopup()

    local label = vgui.Create("DLabel", currentDetailWindow)
    label:SetPos(20, 60)
    label:SetSize(finalWidth - 40, finalHeight - 80) -- Adjusting for padding
    label:SetText(text)
    label:SetWrap(true)
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

    local cellText = cell
    if cellText == "none" then
    draw.SimpleText(cellText, "DermaDefault", j * colWidth - colWidth / 2, self.headerHeight + (i - 0.5) * self.headerHeight, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) -- Red color for "none"
    end
    
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
            local cellText = cell
            surface.SetFont("DermaDefault")
            local textW, textH = surface.GetTextSize(cellText)
            
            -- Trim the text if it's too long for the cell
            while textW > colWidth and #cellText > 0 do
                cellText = cellText:sub(1, -2) -- remove the last character
                textW, textH = surface.GetTextSize(cellText)
            end

            if self:IsHovered() then
                local mouseX, mouseY = self:CursorPos()
                if mouseX > (j - 1) * colWidth and mouseX < j * colWidth and mouseY > self.headerHeight + (i - 1) * self.headerHeight and mouseY < self.headerHeight + i * self.headerHeight then
                    draw.RoundedBox(0, (j - 1) * colWidth, self.headerHeight + (i - 1) * self.headerHeight, colWidth, self.headerHeight, self.highlightColor)
                    if input.IsMouseDown(MOUSE_LEFT) then
                        CreateDynamicWindow(cell)
                    end
                end
            end
            draw.SimpleText(cellText, "DermaDefault", j * colWidth - colWidth / 2, self.headerHeight + (i - 0.5) * self.headerHeight, self.textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end



vgui.Register("Dlib.ListView", PANEL)
