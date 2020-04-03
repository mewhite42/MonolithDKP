local _, core = ...;
local _G = _G;
local MonDKP = core.MonDKP;
local L = core.L;

function ImportDKP(MonDKP_Loot, CurFormat)
    SendChatMessage("importing" ,"RAID")
    if(CurFormat == "QDKP")
    then
        SendChatMessage("QDKP" ,"RAID")
        
        local text = MonDKPImportBoxEditBox:GetText()
        for i in string.gmatch(text, "<PLAYER.->") do
            local name = string.match(i, "playername=.-\-")
            name = name:sub(13,-2)
            SendChatMessage(name ,"RAID")
            local class = string.match(i, "class=.-\"%d-\"")
            class = class:sub(8,-2)
            SendChatMessage(class ,"RAID")
            --local rank = string.match(i, "rank=.-\"%.-\"")
            --rank = rank:sub(7,-2)
            --SendChatMessage(rank ,"RAID")
            --local net = string.match(i, "net=.-\"%.-\"")
           -- net = net:sub(6,-2)
            --SendChatMessage(net ,"RAID")
            local total = string.match(i, "total=.-\"%d-\"")
            total = total:sub(8,-2)
            SendChatMessage(total ,"RAID")
            local spent = string.match(i, "spent=.-\"%d-\"")
            spent = spent:sub(8,-2)
            SendChatMessage(spent ,"RAID")

            local spent = string.match(i, "spent=.-\"%d-\"")
            spent = spent:sub(8,-2)
            SendChatMessage(spent ,"RAID")

            tinsert(MonDKP_DKPTable, {
				player="Khabiji",
				class="Mage",
				dkp=10,
				previous_dkp=10,
				lifetime_gained = 10,
				lifetime_spent = 10,
				rank=20,
				rankName="None",
				spec = "No Spec Reported",
				role = "No Role Reported",
            })
            MonDKP:FilterDKPTable(core.currentSort, "reset")
            MonDKP:ClassGraph_Update()
            core.WorkingTable 		= MonDKP_DKPTable;
            SendChatMessage(MonDKP_DKPTable.getn() ,"RAID")


        end
    end
end

function MonDKPImportBox_Show(text)
    if not MonDKPImportBox then
        local f = CreateFrame("Frame", "MonDKPImportBox", UIParent)
        f:SetPoint("CENTER")
        f:SetSize(700, 590)
        
        f:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
            edgeSize = 17,
            insets = { left = 8, right = 6, top = 8, bottom = 8 },
        })
        f:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
        
        -- Movable
        f:SetMovable(true)
        f:SetClampedToScreen(true)
        f:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                self:StartMoving()
            end
        end)
        f:SetScript("OnMouseUp", f.StopMovingOrSizing)

        -- Close Button
		f.closeContainer = CreateFrame("Frame", "MonDKPTitle", f)
		f.closeContainer:SetPoint("CENTER", f, "TOPRIGHT", -4, 0)
		f.closeContainer:SetBackdrop({
			bgFile   = "Textures\\white.blp", tile = true,
			edgeFile = "Interface\\AddOns\\MonolithDKP\\Media\\Textures\\edgefile.tga", tile = true, tileSize = 1, edgeSize = 3, 
		});
		f.closeContainer:SetBackdropColor(0,0,0,0.9)
		f.closeContainer:SetBackdropBorderColor(1,1,1,0.2)
		f.closeContainer:SetSize(28, 28)

		f.closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
		f.closeBtn:SetPoint("CENTER", f.closeContainer, "TOPRIGHT", -14, -14)
		tinsert(UISpecialFrames, f:GetName()); -- Sets frame to close on "Escape"
        
        -- ScrollFrame
        local sf = CreateFrame("ScrollFrame", "MonDKPImportBoxScrollFrame", MonDKPImportBox, "UIPanelScrollFrameTemplate")
        sf:SetPoint("LEFT", 20, 0)
        sf:SetPoint("RIGHT", -32, 0)
        sf:SetPoint("TOP", 0, -20)
        sf:SetPoint("BOTTOM", 0, 160)

        -- Description
        f.desc = f:CreateFontString(nil, "OVERLAY")
		f.desc:SetFontObject("MonDKPSmallLeft");
		f.desc:SetPoint("TOPLEFT", sf, "BOTTOMLEFT", 10, -10);
		f.desc:SetText("|CFFAEAEDDSelect a format for the import input|r");
		f.desc:SetWidth(sf:GetWidth()-30)
        
        -- EditBox
        local eb = CreateFrame("EditBox", "MonDKPImportBoxEditBox", MonDKPImportBoxScrollFrame)
        eb:SetSize(sf:GetSize())
        eb:SetMultiLine(true)
        eb:SetSize(600, 300)
        eb:SetAutoFocus(false) -- dont automatically focus
        eb:SetFontObject("ChatFontNormal")
        eb:SetScript("OnEscapePressed", function() f:Hide() end)
        eb:SetBackdrop({
            edgeFile = "Interface\\AddOns\\MonolithDKP\\Media\\Textures\\edgefile", tile = true, tileSize = 32, edgeSize = 2,
        })
        sf:SetScrollChild(eb)


        -- f.Bid = CreateFrame("EditBox", nil, f)
        -- f.Bid:SetPoint("LEFT", f.BidHeader, "RIGHT", 8, 0)   
        -- f.Bid:SetAutoFocus(false)
        -- f.Bid:SetMultiLine(false)
        -- f.Bid:SetSize(70, 28)
        -- f.Bid:SetBackdrop({
        --   bgFile   = "Textures\\white.blp", tile = true,
        --   edgeFile = "Interface\\AddOns\\MonolithDKP\\Media\\Textures\\edgefile", tile = true, tileSize = 32, edgeSize = 2,
        -- });
        -- f.Bid:SetBackdropColor(0,0,0,0.6)
        -- f.Bid:SetBackdropBorderColor(1,1,1,0.6)
        -- f.Bid:SetMaxLetters(8)
        -- f.Bid:SetTextColor(1, 1, 1, 1)
        -- f.Bid:SetFontObject("MonDKPSmallRight")
        -- f.Bid:SetTextInsets(10, 10, 5, 5)
        -- f.Bid:SetScript("OnEscapePressed", function(self)    -- clears focus on esc
        --   self:ClearFocus()
        -- end)
        
        -- Resizable
        f:SetResizable(true)
        f:SetMinResize(650, 500)
        
        local rb = CreateFrame("Button", "MonDKPImportBoxResizeButton", MonDKPImportBox)
        rb:SetPoint("BOTTOMRIGHT", -6, 7)
        rb:SetSize(16, 16)
        
        rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
        rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
        rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
        
        rb:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                f:StartSizing("BOTTOMRIGHT")
            end
        end)
        rb:SetScript("OnMouseUp", function(self, button)
            f:StopMovingOrSizing()
            self:GetHighlightTexture():Show()
            eb:SetWidth(sf:GetWidth())
            desc:SetWidth(sf:GetWidth()-30)
        end)
        f:Show()

        -- Format DROPDOWN box 
        local CurFormat;

		f.FormatDropDown = CreateFrame("FRAME", "MonDKPModeSelectDropDown", f, "MonolithDKPUIDropDownMenuTemplate")
		f.FormatDropDown:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 20, 55)
		UIDropDownMenu_SetWidth(f.FormatDropDown, 100)
		UIDropDownMenu_SetText(f.FormatDropDown, "Select Format")

		-- Create and bind the initialization function to the dropdown menu
		UIDropDownMenu_Initialize(f.FormatDropDown, function(self, level, menuList)
		local Format = UIDropDownMenu_CreateInfo()
			Format.func = self.SetValue
			Format.fontObject = "MonDKPSmallCenter"
			Format.text, Format.arg1, Format.checked, Format.isNotRadio = "QDKP", "QDKP", "QDKP" == CurFormat, false
			UIDropDownMenu_AddButton(Format)
		end)

		-- Dropdown Menu Function
		function f.FormatDropDown:SetValue(arg1)
			CurFormat = arg1;
			if arg1 == "QDKP" then
                ImportDefinition = "|CFFAEAEDDImport an xml file exported from Quick DKP|r"
            end

			f.desc:SetText(ImportDefinition);
			UIDropDownMenu_SetText(f.FormatDropDown, CurFormat)
			CloseDropDownMenus()
		end

		f.FormatDropDown:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			GameTooltip:SetText("Import Format", 0.25, 0.75, 0.90, 1, true);
			GameTooltip:AddLine("Select the format you wish to Import data from.  This will overwrite any existing DKP values.", 1.0, 1.0, 1.0, true);
			GameTooltip:Show();
		end)
		f.FormatDropDown:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)

		StaticPopupDialogs["NO_FORMAT"] = {
			text = "You do not have a format selected.",
			button1 = "Ok",
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}

		f.SelectAllButton = MonDKP:CreateButton("BOTTOMLEFT", f, "BOTTOMLEFT", 45, 20, L["IMPORTDKP"]);
		f.SelectAllButton:SetSize(100, 20)
		f.SelectAllButton:SetScript("OnClick", function()
            if CurFormat then
				ImportDKP(MonDKP_Loot, CurFormat)
			else
                StaticPopup_Show ("NO_FORMAT")
			end

		end)
    end
    
    if text then
        MonDKPImportBoxEditBox:SetText(text)
    end
    MonDKPImportBox:Show()
end

function MonDKP:ToggleImportWindow()
	MonDKPImportBox_Show()
end