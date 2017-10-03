
------------------------------------------------------------------
--  Tests  --
------------------------------------------------------------------
function Serialisation()
  local testObject = {["one"]="one", ["two"]="two"}
  local outout = CraftOrdering:Serialize(testObject)
  ECO.d(output)
  --local condition = output == "{\"one\",\"two\"}"
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
  d(ECO.green.."Initiating unit tests")
  for i,v in pairs(CraftOrdering.Tests) do
    d(ECO.orange..i)
    v()
  end
  d(ECO.green.."Unit Testing Complete")
end