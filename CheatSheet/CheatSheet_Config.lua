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
local Tabs = {"Sheets & Modules", "Appearance", "Misc"}
local optionMap = {Sheets = "sheet", Appearance = "appearance", Misc = "misc"}


-- Frame Creation
local ConfigFrame = CheatSheet.SettingsFrame
local TitleFrame = CreateFrame("Frame")
local TabListFrame = CreateFrame("Frame", "CSHT_CFG_TabL_Frame")
local TabScrollFrame = CreateFrame("ScrollFrame")
local TabMainFrame = CreateFrame("Frame", "CSHT_CFG_TabM_Frame")
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
		-- ConfigFrame:SetDontSavePosition(true)
		ConfigFrame:Hide() 
		
		ConfigFrame:SetScript("OnSizeChanged", function(self, width, height)
			self:SetWidth(math.max(width, WidthMin))
			self:SetHeight(math.max(height, HeightMin))
		end)
		
		local background = ConfigFrame:CreateTexture(nil, "BACKGROUND")
		background:SetColorTexture(0.4, 0.4, 0.4, 0.5)
		background:SetAllPoints()
	end
	
	do -- Set up title frame
		TitleFrame:SetParent(ConfigFrame)
		TitleFrame:SetPoint("TOPLEFT")
		TitleFrame:SetPoint("BOTTOMRIGHT", ConfigFrame, "TOPRIGHT", -20, -20)
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
		texture:SetColorTexture(0.1, 0.1, 0.1, 0.5)
		texture:SetAllPoints()
	end
	
	do -- Set up tab list frame
		TabListFrame:SetParent(ConfigFrame)
		TabListFrame:SetPoint("TOPLEFT", 0, -20)
		TabListFrame:SetPoint("BOTTOMRIGHT", ConfigFrame, "TOPRIGHT" ,0 ,-50)
		
		function TabListFrame:Select(index)
			local name = ""
			for num, frame in ipairs(self.FrameList) do
				if num == index then
					self.FrameList[num]:Select(true)
					name = string.match(self.FrameList[num].fontString:GetText(), "(%S+)")
				else
					self.FrameList[num]:Select(false)
				end
			end
			local options = CheatSheet.Settings[optionMap[name]]
			TabMainFrame:UpdateOptions(optionMap[name], options)
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
					self.isSelected = true
				else
					self:SetNormalTexture(self.background)
					self.isSelected = false
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
			frame.background:SetColorTexture(0.1, 0.1, 0.1, 0.5)
			frame.background:SetAllPoints()
			frame:SetNormalTexture(frame.background)
			
			frame.pushed = frame:CreateTexture()
			frame.pushed:SetColorTexture(0.8, 0.8, 0.8, 0.5)
			frame.pushed:SetAllPoints()
			frame:SetPushedTexture(frame.pushed)
			
			frame.selected = frame:CreateTexture()
			frame.selected:SetColorTexture(0.5, 0.5, 0.5, 0.5)
			frame.selected:SetAllPoints()
			frame.selected:Hide()
			
			
			frame:Select(frame.isSelected)
		end
	end
	
	do -- Create Tab main frame
		function TabMainFrame:CreateOptionFrame(option)
			local frame = CreateFrame("Frame")
			
			frame:SetParent(self)
			frame:SetPoint("TOPLEFT")
			frame:SetWidth(self:GetWidth() - 10)
			frame:SetHeight(40)
			
			frame.nameString = frame:CreateFontString()
			frame.nameString:SetFontObject(ConfigFont1)
			frame.nameString:SetPoint("TOPLEFT", 2, -2)
			
			
			background = frame:CreateTexture()
			background:SetColorTexture(0.2, 0.2, 0.2, 0.5)
			background:SetAllPoints()
			
			self:UpdateOptionFrame(frame, option)
			return frame
		end
		
		function TabMainFrame:CreateBoolFrame(parent, option)
			local container = CreateFrame("Frame")
			container:SetParent(parent)
			container:SetPoint("TOPLEFT", 2, -15)
			container:SetPoint("BOTTOMRIGHT")
			
			container.checkButton = CreateFrame("CheckButton")
			local button = container.checkButton
			button:SetParent(container)
			button:SetPoint("TOPLEFT", 10, 0)
			button:SetSize(20, 20)
			
			button.unchecked = button:CreateTexture()
			button.unchecked:SetColorTexture(0.8, 0.5, 0.5, 0.5)
			button.unchecked:SetAllPoints()
			button:SetNormalTexture(button.unchecked)
			
			button.checked = button:CreateTexture()
			button.checked:SetColorTexture(0.5, 0.8, 0.5, 0.5)
			button.checked:SetAllPoints()
			button:SetCheckedTexture(button.checked)
			
			button:SetChecked(parent.value)
			
			button:SetScript("OnClick", function(self, button, down)
				local parFrame = self:GetParent():GetParent()
				parFrame.value = self:GetChecked()
				parFrame:GetParent():UpdateOption(parFrame)
			end)
			
			return container
		end
		
		function TabMainFrame:CreateIntFrame(parent, option)
			local container = CreateFrame("Frame")
			container:SetParent(parent)
			container:SetPoint("TOPLEFT", 2, -15)
			container:SetPoint("BOTTOMRIGHT")
			
			container.EditBox = CreateFrame("EditBox")
			local editBox = container.EditBox
			editBox:SetParent(container)
			editBox:SetPoint("TOPLEFT", 10, 0)
			editBox:SetSize(40, 20)
			editBox:SetNumeric(true)
			editBox:SetMaxLetters(5)
			editBox:SetFontObject(ConfigFont1)
			editBox:SetAutoFocus(false)
			
			editBox:SetNumber(parent.value)
			
			editBox.background = editBox:CreateTexture()
			editBox.background:SetColorTexture(0.5, 0.5, 0.5, 0.5)
			editBox.background:SetAllPoints()
			
			editBox:SetScript("OnEnterPressed", function(self)
				self:ClearFocus()
				local parFrame = self:GetParent():GetParent()
				parFrame.value = self:GetNumber()
				parFrame:GetParent():UpdateOption(parFrame)				
			end)
			
			return container
		end
		
		function TabMainFrame:UpdateOptionFrame(frame, option)
			frame.name = option.NAME
			frame.fName = option.FNAME
			frame.type = option.TYPE
			frame.value = option.VAL
			frame.min = option.MIN
			frame.max = option.MAX
			
			
			
			frame.nameString:SetText(frame.fName)
			frame.nameString:SetWidth(frame:GetWidth())
			frame.nameString:SetWidth(frame.nameString:GetStringWidth())
			frame.nameString:SetHeight(frame.nameString:GetStringHeight())
			
			if frame.optionFrame then
				frame.optionFrame:Hide()
				frame.optionFrame = nil
			end
			if frame.type == "bool" then
				frame.optionFrame = self:CreateBoolFrame(frame, option)
			elseif frame.type == "int" then
				frame.optionFrame = self:CreateIntFrame(frame, option)
			end
		end
		
		function TabMainFrame:UpdateOption(frame)
			CheatSheet.Settings[self.Category][frame.name].VAL = frame.value
		end
		
		function TabMainFrame:UpdateOptions(category, options)
			self.Category = category
			local index = 1
			local offset = 10
			for key, option in pairs(options) do
				if not self.OptionFrames[index] then
					self.OptionFrames[index] = TabMainFrame:CreateOptionFrame(option)
					self.NumFrames = self.NumFrames + 1
				else
					self:UpdateOptionFrame(self.OptionFrames[index], option)
				end				
				self.OptionFrames[index]:Show()
				self.OptionFrames[index]:SetPoint("TOPLEFT", 5, -offset)
				offset = offset + 10 + self.OptionFrames[index]:GetHeight()
				index = index + 1
			end
			while index <= self.NumFrames do
				self.OptionFrames[index]:Hide()
				self.OptionFrames[index]:SetPoint("TOPLEFT")
				index = index + 1
			end
			self:SetHeight(offset)
		end
		
		TabMainFrame.OptionFrames = {}
		TabMainFrame.NumFrames = 0
		TabMainFrame.Category = ""
	
		TabMainFrame:SetFrameStrata("MEDIUM")
		TabMainFrame:SetPoint("TOPLEFT")
		TabMainFrame:SetSize(600, 800)
		TabMainFrame:SetMovable(true)
		
		TabMainFrame:SetScript("OnSizeChanged", function(self, width, height)
			for key, frame in ipairs(self.OptionFrames) do
				frame:SetWidth(width - 10)
			end
		end)
	end
	
	do -- Set up tab scroll frame
		TabScrollFrame:SetFrameStrata("MEDIUM")
		TabScrollFrame:SetParent(ConfigFrame)
		TabScrollFrame:SetPoint("TOPLEFT", 0, -50)
		TabScrollFrame:SetPoint("BOTTOMRIGHT", -10, 0)
		TabScrollFrame:SetMovable(true)
		TabScrollFrame:EnableMouse(true)
		TabScrollFrame:EnableMouseWheel(true)
		TabScrollFrame:SetScrollChild(TabMainFrame)
		
		TabScrollFrame:SetScript("OnMouseWheel", function(self, delta)
			local scroll = math.max(math.min(self:GetVerticalScroll() + (-10 * delta), TabMainFrame:GetHeight() - TabScrollFrame:GetHeight()), 0)
			self:SetVerticalScroll(scroll)
			-- Set slider
		end)
		TabScrollFrame:SetScript("OnSizeChanged", function(self, width, height)
			local scroll = math.max(math.min(self:GetVerticalScroll(), TabMainFrame:GetHeight() - TabScrollFrame:GetHeight()), 0)
			self:SetVerticalScroll(scroll)
			-- Set slider
			TabMainFrame:SetWidth(width)
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
		background:SetColorTexture(0.1, 0.1, 0.1, 0.5)
		background:SetAllPoints()
		ResizeButton:SetNormalTexture(background)
		
		local pushed = ResizeButton:CreateTexture()
		pushed:SetColorTexture(0.8, 0.8, 0.8, 0.5)
		pushed:SetAllPoints()
		ResizeButton:SetPushedTexture(pushed)
	end
	
	do -- Set up close button
		CloseButton:SetParent(ConfigFrame)
		CloseButton:SetPoint("TOPRIGHT")
		CloseButton:SetPoint("BOTTOMLEFT", ConfigFrame, "TOPRIGHT", -20, -20)
		CloseButton:EnableMouse(true)
		CloseButton:RegisterForClicks("LeftButton")
		CloseButton:Enable()
		
		CloseButton:SetScript("OnMouseUp", function(self, button)
			CheatSheet.Settings.core.ConfigVisible.VAL = false
			self:GetParent():Hide()
		end)
		
		local background = CloseButton:CreateTexture()
		background:SetTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
		background:SetTexCoord(0.203125, 0.796875, 0.203125, 0.796875)
		background:SetAllPoints()
		CloseButton:SetNormalTexture(background)
		
		local pushed = CloseButton:CreateTexture()
		pushed:SetTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down.blp")
		pushed:SetTexCoord(0.203125, 0.796875, 0.203125, 0.796875)
		pushed:SetAllPoints()
		CloseButton:SetPushedTexture(pushed)
		
		local highlight = CloseButton:CreateTexture()
		highlight:SetTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp")
		highlight:SetTexCoord(0.203125, 0.796875, 0.203125, 0.796875)
		highlight:SetAllPoints()
		CloseButton:SetHighlightTexture(highlight)
	end
end

