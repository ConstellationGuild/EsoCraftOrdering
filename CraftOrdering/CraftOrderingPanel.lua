function CraftOrderingPanelUpdate()
end

function CraftOrderingPanelInitialize()
end

local hidden = true;
function CraftOrderingPanelShow()
  hidden = not hidden;
  CraftOrderingPanel:SetHidden(hidden)
  SetGameCameraUIMode(not hidden)
end
