local F, C = unpack(select(2, ...))

tinsert(C.themes["Aurora"], function()
	local r, g, b = C.r, C.g, C.b

	CharacterModelFrame:DisableDrawLayer("BACKGROUND")
	CharacterModelFrame:DisableDrawLayer("BORDER")
	CharacterModelFrame:DisableDrawLayer("OVERLAY")

	-- [[ Item buttons ]]

	local function colourPopout(self)
		local aR, aG, aB
		local glow = self:GetParent().IconBorder

		if glow:IsShown() then
			aR, aG, aB = glow:GetVertexColor()
		else
			aR, aG, aB = r, g, b
		end

		self.arrow:SetVertexColor(aR, aG, aB)
	end

	local function clearPopout(self)
		self.arrow:SetVertexColor(1, 1, 1)
	end

	local slots = {
		"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
		"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
		"SecondaryHand", "Tabard",
	}

	for i = 1, #slots do
		local slot = _G["Character"..slots[i].."Slot"]
		local border = slot.IconBorder

		_G["Character"..slots[i].."SlotFrame"]:Hide()

		slot:SetNormalTexture("")
		slot:SetPushedTexture("")
		slot.icon:SetTexCoord(.08, .92, .08, .92)

		border:SetPoint("TOPLEFT", -1, 1)
		border:SetPoint("BOTTOMRIGHT", 1, -1)
		border:SetDrawLayer("BACKGROUND")

		local popout = slot.popoutButton

		popout:SetNormalTexture("")
		popout:SetHighlightTexture("")

		local arrow = popout:CreateTexture(nil, "OVERLAY")

		if slot.verticalFlyout then
			arrow:SetSize(13, 8)
			arrow:SetTexture(C.media.arrowDown)
			arrow:SetPoint("TOP", slot, "BOTTOM", 0, 1)
		else
			arrow:SetSize(8, 14)
			arrow:SetTexture(C.media.arrowRight)
			arrow:SetPoint("LEFT", slot, "RIGHT", -1, 0)
		end

		popout.arrow = arrow

		popout:HookScript("OnEnter", clearPopout)
		popout:HookScript("OnLeave", colourPopout)
	end

	select(11, CharacterMainHandSlot:GetRegions()):Hide()
	select(11, CharacterSecondaryHandSlot:GetRegions()):Hide()

	hooksecurefunc("PaperDollItemSlotButton_Update", function(button)
		-- also fires for bag slots, we don't want that
		if button.popoutButton then
			button.IconBorder:SetTexture(C.media.backdrop)
			button.icon:SetShown(button.hasItem)
			colourPopout(button.popoutButton)
		end
	end)

	-- [[ Stats pane ]]

	CharacterStatsPane.ClassBackground:Hide()

	-- [[ Sidebar tabs ]]

	for i = 1, #PAPERDOLL_SIDEBARS do
		local tab = _G["PaperDollSidebarTab"..i]

		if i == 1 then
			for i = 1, 4 do
				local region = select(i, tab:GetRegions())
				region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
				region.SetTexCoord = F.dummy
			end
		end

		tab.Highlight:SetColorTexture(r, g, b, .2)
		tab.Highlight:SetPoint("TOPLEFT", 3, -4)
		tab.Highlight:SetPoint("BOTTOMRIGHT", -1, 0)
		tab.Hider:SetColorTexture(.3, .3, .3, .4)
		tab.TabBg:SetAlpha(0)

		select(2, tab:GetRegions()):ClearAllPoints()
		if i == 1 then
			select(2, tab:GetRegions()):SetPoint("TOPLEFT", 3, -4)
			select(2, tab:GetRegions()):SetPoint("BOTTOMRIGHT", -1, 0)
		else
			select(2, tab:GetRegions()):SetPoint("TOPLEFT", 2, -4)
			select(2, tab:GetRegions()):SetPoint("BOTTOMRIGHT", -1, -1)
		end

		tab.bg = CreateFrame("Frame", nil, tab)
		tab.bg:SetPoint("TOPLEFT", 2, -3)
		tab.bg:SetPoint("BOTTOMRIGHT", 0, -1)
		tab.bg:SetFrameLevel(0)
		F.CreateBD(tab.bg)

		tab.Hider:SetPoint("TOPLEFT", tab.bg, 1, -1)
		tab.Hider:SetPoint("BOTTOMRIGHT", tab.bg, -1, 1)
	end

	-- [[ Equipment manager ]]

	for i = 1, NUM_GEARSET_ICONS_SHOWN do
		local bu = _G["GearManagerDialogPopupButton"..i]
		local ic = _G["GearManagerDialogPopupButton"..i.."Icon"]

		bu:SetCheckedTexture(C.media.checked)
		select(2, bu:GetRegions()):Hide()
		ic:SetPoint("TOPLEFT", 1, -1)
		ic:SetPoint("BOTTOMRIGHT", -1, 1)
		ic:SetTexCoord(.08, .92, .08, .92)

		F.CreateBD(bu, .25)
	end

	local sets = false
	PaperDollSidebarTab3:HookScript("OnClick", function()
		if sets == false then
			for i = 1, 9 do
				local bu = _G["PaperDollEquipmentManagerPaneButton"..i]
				local bd = _G["PaperDollEquipmentManagerPaneButton"..i.."Stripe"]
				local ic = _G["PaperDollEquipmentManagerPaneButton"..i.."Icon"]
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgTop"]:SetAlpha(0)
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgMiddle"]:Hide()
				_G["PaperDollEquipmentManagerPaneButton"..i.."BgBottom"]:SetAlpha(0)

				bu.HighlightBar:SetColorTexture(r, g, b, .1)
				bu.HighlightBar:SetDrawLayer("BACKGROUND")
				bu.SelectedBar:SetColorTexture(r, g, b, .2)
				bu.SelectedBar:SetDrawLayer("BACKGROUND")

				bd:Hide()
				bd.Show = F.dummy
				ic:SetTexCoord(.08, .92, .08, .92)

				F.CreateBG(ic)
			end
			sets = true
		end
	end)
end)
