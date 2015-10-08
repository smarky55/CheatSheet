-- Local variables
local WidthMin = 200
local HeightMin = 200
local Tabs = {"Sheets & Modules", "Appearence", "Misc"}


-- Frame Creation
local ConfigFrame = CheatSheet.SettingsFrame
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
		function ConfigFrame:Toggle()
			if ConfigFrame.Visible then
				ConfigFrame:Hide()
			else
				ConfigFrame:Show()
			end
			ConfigFrame.Visible = not ConfigFrame.Visible
		end		
	
		ConfigFrame:SetFrameStrata("MEDIUM")
		ConfigFrame:SetPoint("CENTER")
		ConfigFrame:SetSize(600, 400)
		ConfigFrame:EnableMouse(true)
		ConfigFrame:SetMovable(true)
		ConfigFrame:SetResizable(true)
		ConfigFrame:SetToplevel(true)
		ConfigFrame:SetClampedToScreen(true)
		
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
	
	do -- Create Tabs
		local frames = TabListFrame.FrameList
		for index, name in ipairs(Tabs) do
			if not frames[index] then
				frames[index] = CreateFrame("CheckButton")
			end
			frames[index]:SetParent(TabListFrame)
			frames[index]:SetPoint("BOTTOMLEFT", (-40 + 90 * index), 0)
			frames[index]:SetSize(85, 30)
			
			frames[index].fontString = frames[index]:CreateFontString()
			frames[index].fontString:SetFontObject(ConfigFont1)
			frames[index].fontString:SetPoint("TOPLEFT", 2, -5)
			frames[index].fontString:SetText(Tabs[index])
			frames[index].fontString:SetWidth(frames[index]:GetWidth()-10)
			frames[index].fontString:SetWordWrap(true)
			
			local background = frames[index]:CreateTexture()
			background:SetTexture(0.1, 0.1, 0.1, 0.5)
			background:SetAllPoints()
			frames[index]:SetNormalTexture(background)
			
			local pushed = frames[index]:CreateTexture()
			pushed:SetTexture(0.8, 0.8, 0.8, 0.5)
			pushed:SetAllPoints()
			frames[index]:SetPushedTexture(pushed)
			
			local checked = frames[index]:CreateTexture()
			checked:SetTexture(0.5, 0.5, 0.5, 0.5)
			checked:SetAllPoints()
			frames[index]:SetCheckedTexture(checked)
		end
	end
	
	do -- Set up resize button
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
	
	do -- Set up close button
		CloseButton:SetParent(ConfigFrame)
		CloseButton:SetPoint("TOPRIGHT")
		CloseButton:SetPoint("BOTTOMLEFT", ConfigFrame, "TOPRIGHT", -16, -16)
		CloseButton:EnableMouse(true)
		CloseButton:RegisterForClicks("LeftButton")
		CloseButton:Enable()
		
		CloseButton:SetScript("OnMouseUp", function(self, button)
			self:GetParent():Hide()
		end)
		
		local background = CloseButton:CreateTexture()
		background:SetTexture(0.5, 0.1, 0.1, 0.5)
		background:SetAllPoints()
		CloseButton:SetNormalTexture(background)
		
		local pushed = CloseButton:CreateTexture()
		pushed:SetTexture(0.8, 0.3, 0.3, 0.5)
		pushed:SetAllPoints()
		CloseButton:SetPushedTexture(pushed)
	end
end
