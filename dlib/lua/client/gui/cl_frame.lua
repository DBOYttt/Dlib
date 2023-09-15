-- Define the custom ModernFrame panel
local PANEL = {}

function PANEL:Init()
    -- Default settings
    self:SetSize(500, 300)
    self:Center()
    self:SetTitle("")
    self:ShowCloseButton(false) -- Hide the default close button
    self:SetDraggable(true)
    self:MakePopup()
    self.useAnimation = true -- By default, use the animation
    self.startAnim = SysTime()
    self.animDuration = 0.5 -- Animation duration in seconds

    -- Custom close button
    self.closeBtn = vgui.Create("DButton", self)
    self.closeBtn:SetSize(32, 32)
    self.closeBtn:SetText("") -- Remove default button text

    -- Custom paint function for the close button
    self.closeBtn.Paint = function(s, w, h)
        -- Darker red square with rounded corners
        draw.RoundedBox(4, 0, 0, w, h, Color(60, 20, 20))
        -- Subtle white "X"
        draw.SimpleText("X", "DermaDefaultBold", w / 2, h / 2, Color(200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    -- Function to close the frame when the button is clicked
    self.closeBtn.DoClick = function()
        self:Close()    
    end
end

-- Set whether to use the entrance animation or not
function PANEL:SetUseAnimation(useAnim)
    self.useAnimation = useAnim
end

-- Custom rendering
function PANEL:Paint(w, h)
    local alpha = 255
    local headerHeight = 35 -- Increased header height

    if self.useAnimation then
        local elapsed = SysTime() - self.startAnim
        alpha = Lerp(elapsed / self.animDuration, 0, 255)
    end

    draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40, alpha)) -- Background with animation
    draw.RoundedBox(0, 0, 0, w, headerHeight, Color(30, 30, 30, alpha)) -- Header with animation

    -- Update the position of the close button to the top right corner
    self.closeBtn:SetPos(self:GetWide() - 34, 2)
end

-- Register the custom ModernFrame
vgui.Register("Dlib.Frame", PANEL, "DFrame")
