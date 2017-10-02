CraftOrdering.Tests = {
  Serialisation = UnitTesting.Tests:Serialisation
}

function CraftOrdering:ExecuteUnitTests()
  for i in CraftOrdering.Tests do
    i()
  end
end

function CraftOrdering.Tests:Serialisation()
  local testObject = {one="one",two="two"}
  local outout = CraftOrdering:Serialisation(testObject)
  ECO.d(output)
  --local condition = output == "{\"one\",\"two\"}"
  return condition == true
end