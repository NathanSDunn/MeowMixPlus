function UseByName_OnLoad()
	if not Print then Print = function (x)
    ChatFrame1:AddMessage(x, 1.0, 1.0, 1.0);
  	end
  end

  if not SlashCmdList["USEBYNAME"] then
  	SlashCmdList["USEBYNAME"] = UseByName_Execute;
    SLASH_USEBYNAME1 = "/usebyname";
  end
end

function UseByName_Execute(msg)
	if not msg or (msg == "")  then Print("Usage: /UseByName <itemname>"); return; end

  local item = string.lower(msg);
  
  for i=0, NUM_BAG_FRAMES do
    for j=1, GetContainerNumSlots(i) do
    	if string.find(string.lower(UseByName_GetItemName(i,j)), item) then
    	  -- Print("Using item "..i..","..j);
				UseContainerItem(i,j);
				return;
			end
    end
  end

  -- Also check inventory
	for i=0,19 do
  	if string.find(string.lower(UseByName_GetItemName(-1,i)), item) then
			UseInventoryItem(i);
			return;
		end
	end
	
  Print("Item "..msg.." not found");
end

function UseByName_GetItemName(bag, slot)
  local linktext = nil;
  
  if (bag == -1) then
  	linktext = GetInventoryItemLink("player", slot);
  else
  	linktext = GetContainerItemLink(bag, slot);
  end

  if linktext then
    local _,_,name = string.find(linktext, "^.*%[(.*)%].*$");
    return name;
  else
    return "";
  end
end
