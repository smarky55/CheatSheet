-- Local variables
local WidthMin = 200
local HeightMin = 200


-- Frame Creation
local ConfigFrame = CreateFrame("Frame", "CSHT_ConfigFrame")
local TitleFrame = CreateFrame("Frame")
local TabListFrame = CreateFrame("Frame")
local TabScrollFrame = CreateFrame("ScrollFrame")
local TabMainFrame = CreateFrame("Frame")
local SaveButton = CreateFrame("Button")
local CloseButton = CreateFrame("Button")
local ResizeButton = CreateFrame("Button")

-- Font Creation
local ConfigFont1 = CreateFont("CSHT_FONT_CFG1")
local ConfigFont2 = CreateFont("CSHT_FONT_CFG2")

do -- Fonts
	do
		ConfigFont1:SetFont("Fonts\\FRIZQT__.TTF", 10)
		ConfigFont1:SetTextColor(1, 1, 1)
		ConfigFont1:SetJustifyH("LEFT")
	end
	
	do
		ConfigFont2:SetFont("Fonts\\FRIZQT__.TTF", 14)
		ConfigFont2:SetTextColor(0.8, 0.8, 0.5)
	end
end

do -- Frame Setup
	do	-- Set up main container frame
		ConfigFrame:SetFrameStrata("MEDIUM")
		ConfigFrame:SetPoint("CENTER")
		ConfigFrame:SetSize(600, 400)
		ConfigFrame:EnableMouse(true)
		ConfigFrame:SetMovable(true)
		ConfigFrame:SetResizable(true)
		ConfigFrame:SetToplevel(true)
		
		ConfigFrame:SetScript("OnSizeChanged", function(self, width, height)
			self:SetWidth(math.max(width, WidthMin))
			self:SetHeight(math.max(height, HeightMin))
		end)
		
		local background = ConfigFrame:CreateTexture(nil, "BACKGROUND")
		background:SetTexture(0.4, 0.4, 0.4, 0.3)
		background:SetAllPoints()
	end
	
	do
		TitleFrame:SetParent(ConfigFrame)
		TitleFrame:SetPoint("TOPLEFT")
		TitleFrame:SetPoint("BOTTOMRIGHT", ConfigFrame, "TOPRIGHT", -16, -16)
		TitleFrame:EnableMouse(true)
		TitleFrame:RegisterForDrag("LeftButton")
		
		TitleFrame:SetScript("OnDragStart", function(self)
			self:GetParent():StartMoving()
		end)
		TitleFrame:SetScript("OnDragStop", function(self)
			self:GetParent():StopMovingOrSizing()
		end)
		
		TitleFrame.fontString = TitleFrame:CreateFontString()
		TitleFrame.fontString:SetFontObject(ConfigFont2)
		TitleFrame.fontString:SetPoint("TOPLEFT", 10, -1)
		TitleFrame.fontString:SetText("CheatSheet Configuration")
		TitleFrame.fontString:SetWidth(TitleFrame.fontString:GetStringWidth() + 10)
		
		local texture = TitleFrame:CreateTexture()
		texture:SetTexture(0.1, 0.1, 0.1, 0.5)
		texture:SetAllPoints()
	end
	
	do -- Set up tab list frame
		TabListFrame:SetParent(ConfigFrame)
		TabListFrame:SetPoint("TOPLEFT", 0, -16)
		TabListFrame:SetPoint("BOTTOMRIGHT", ConfigFrame, "TOPRIGHT" ,0 ,-46)
		
		TabListFrame.FrameList = {}
	end
	
	do
		ResizeButton:SetParent(ConfigFrame)
		ResizeButton:SetPoint("BOTTOMRIGHT")
		ResizeButton:SetSize(10, 10)
		ResizeButton:EnableMouse(true)
		ResizeButton:RegisterForClicks("LeftButton")
		ResizeButton:Enable()
		
		ResizeButton:SetScript("OnMouseDown", function(self, button)
			self:GetParent():StartSizing()
		end)
		ResizeButton:SetScript("OnMouseUp", function(self, button)
			self:GetParent():StopMovingOrSizing()
		end)
		
		local background = ResizeButton:CreateTexture()
		background:SetTexture(0.1, 0.1, 0.1, 0.5)
		background:SetAllPoints()
		ResizeButton:SetNormalTexture(background)
		
		local pushed = ResizeButton:CreateTexture()
		pushed:SetTexture(0.8, 0.8, 0.8, 0.5)
		pushed:SetAllPoints()
		ResizeButton:SetPushedTexture(pushed)
	end
end
