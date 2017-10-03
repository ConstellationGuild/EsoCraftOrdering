
------------------------------------------------------------------
--  Tests  --
------------------------------------------------------------------
function Serialisation()
  local testObject = {["one"]="one", ["two"]="two"}
  local outout = ECO.Serialize(testObject)
  if output ~= nil then
    ECO.d(ECO.red..output)
  end
  local condition = output == "{\"one\",\"two\"}"
  return condition == true
end

------------------------------------------------------------------
--  Register Tests  --
------------------------------------------------------------------
CraftOrdering.Tests = {
  ['Serialisation'] = Serialisation
}

------------------------------------------------------------------
--  Control / Helper methods  --
------------------------------------------------------------------
function CraftOrdering:ExecuteUnitTests()
  ECO.d(ECO.green.."Initiating unit tests")
  for i,v in pairs(CraftOrdering.Tests) do
    local result = v()
    if result == nil then result = false end

    if result then
      ECO.d(ECO.green.."Unit test " .. i .. " passed")
    else
      ECO.d(ECO.red.."Unit test " .. i .. " failed")
    end
    
  end
  d(ECO.green.."Unit Testing Complete")
end