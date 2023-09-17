local PANEL = {}

-- Initialize the custom DPropertySheet
function PANEL:Init()
    self.Navigation = vgui.Create("DPanel", self)
    self.Navigation:Dock(LEFT)
    self.Navigation:SetWide(60)
    self.Navigation:SetBackgroundColor(Color(40, 40, 40))

    self.Content = vgui.Create("DPanel", self)
    self.Content:Dock(FILL)
    self.Content:SetBackgroundColor(Color(30, 30, 30))

    self.Tabs = {}
end

-- Add a sheet (tab) to the custom DPropertySheet
function PANEL:AddSheet(label, panel, material)
    local button = vgui.Create("DButton", self.Navigation)
    button:Dock(TOP)
    button:SetSize(50, 50)
    button:SetText(label)
    button.DoClick = function()
        self:SetActiveTab(panel)
    end

    table.insert(self.Tabs, {
        Button = button,
        Panel = panel,
    })

    panel:SetParent(self.Content)
    panel:Dock(FILL)
    panel:SetVisible(false)

    -- If this is the first tab, make it active
    if not self.ActiveTab then
        self:SetActiveTab(panel)
    end
end

-- Set the active tab for the custom DPropertySheet
function PANEL:SetActiveTab(active)
    if self.ActiveTab == active then return end

    if self.ActiveTab and self.ActiveTab:IsValid() then
        self.ActiveTab:SetVisible(false)
    end

    self.ActiveTab = active
    self.ActiveTab:SetVisible(true)
    self.ActiveTab:Dock(FILL)
end

vgui.Register("DLib.PropertySheet", PANEL, "DPanel")
