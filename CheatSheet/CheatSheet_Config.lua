-- CheatSheet: An addon for World of Warcraft that provides context sensitive info or guidlines
-- Copyright (C) 2015 Sam "smarky55" Kingdon

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
			local visible = CheatSheet.Settings.core.ConfigVisible.VAL
			if visible then
				ConfigFrame:Hide()
			else
				ConfigFrame:Show()
			end
			CheatSheet.Settings.core.ConfigVisible.VAL = not visible
		end		
	
		ConfigFrame:SetFrameStrata("MEDIUM")
		ConfigFrame:SetPoint("CENTER")
		ConfigFrame:SetSize(600, 400)
		ConfigFrame:EnableMouse(true)
		ConfigFrame:SetMovable(true)
		ConfigFrame:SetResizable(true)
		ConfigFrame:SetToplevel(true)
		ConfigFrame:SetClampedToScreen(true)
		-- ConfigFrame:Hide() 
		
		ConfigFrame:SetScript("OnSizeChanged", function(self, width, height)
			self:SetWidth(math.max(width, WidthMin))
			self:SetHeight(math.max(height, HeightMin))
		end)
		
		local background = ConfigFrame:CreateTexture(nil, "BACKGROUND")
		background:SetTexture(0.4, 0.4, 0.4, 0.3)
		background:SetAllPoints()
	end
	
	do -- Set up title frame
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
		
		function TabListFrame:Select(index)
			for num, frame in ipairs(self.FrameList) do
				if num == index then
					self.FrameList[num]:Select(true)
				else
					self.FrameList[num]:Select(false)
				end
			end
		end
		
		TabListFrame.FrameList = {}
	end
	
	do -- Create Tabs
		local frames = TabListFrame.FrameList
		for index, name in ipairs(Tabs) do
			if not frames[index] then
				frames[index] = CreateFrame("Button")
			end
			local frame = frames[index]
			frame.isSelected = false
			frame.index = index
			
			function frame:Select(enable)
				if enable then
					self:SetNormalTexture(self.selected)
				else
					self:SetNormalTexture(self.background)
				end
			end
			
			frame:SetParent(TabListFrame)
			frame:SetPoint("BOTTOMLEFT", (-80 + 90 * index), 0)
			frame:SetSize(85, 30)
			
			frame.fontString = frame:CreateFontString()
			frame.fontString:SetFontObject(ConfigFont1)
			frame.fontString:SetPoint("TOPLEFT", 2, -5)
			frame.fontString:SetText(Tabs[index])
			frame.fontString:SetWidth(frame:GetWidth()-10)
			frame.fontString:SetWordWrap(true)
			
			frame:SetScript("OnMouseUp", function(self, button)
				self:GetParent():Select(self.index)
			end)
			
			frame.background = frame:CreateTexture()
			frame.background:SetTexture(0.1, 0.1, 0.1, 0.5)
			frame.background:SetAllPoints()
			frame:SetNormalTexture(frame.background)
			
			frame.pushed = frame:CreateTexture()
			frame.pushed:SetTexture(0.8, 0.8, 0.8, 0.5)
			frame.pushed:SetAllPoints()
			frame:SetPushedTexture(frame.pushed)
			
			frame.selected = frame:CreateTexture()
			frame.selected:SetTexture(0.5, 0.5, 0.5, 0.5)
			frame.selected:SetAllPoints()
		end
		TabListFrame:Select(1)
	end
	
	do -- Create Tab main frame
		function CreateOptionFrame()
		
		end
		
		function TabMainFrame:UpdateOptions(options)
			for key, option in ipairs(options) do
				if not self.OptionFrames[key] then
					self.OptionFrames[key] = CreateOptionFrame()
				end
			end
		end
		
		TabMainFrame.OptionFrames = {}
	
		TabMainFrame:SetFrameStrata("MEDIUM")
		TabMainFrame:SetPoint("TOPLEFT")
		TabMainFrame:SetSize(600, 800)
		TabMainFrame:SetMovable(true)
	end
	
	do -- Set up tab scroll frame
		TabScrollFrame:SetFrameStrata("MEDIUM")
		TabScrollFrame:SetParent(ConfigFrame)
		TabScrollFrame:SetPoint("TOPLEFT", 0, -46)
		TabScrollFrame:SetPoint("BOTTOMRIGHT", -10)
		TabScrollFrame:SetMovable(true)
		TabScrollFrame:EnableMouse(true)
		TabScrollFrame:EnableMouseWheel(true)
		TabScrollFrame:SetScrollChild(TabMainFrame)
		
		TabScrollFrame:SetScript("OnMouseWheel", function(self, delta)
			local scroll = math.max(math.min(self:GetVerticalScroll() + (10 * delta), TabMainFrame:GetHeight() - TabScrollFrame:GetHeight()), 0)
			self:SetVerticalScroll(scroll)
			-- Set slider
		end)
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
