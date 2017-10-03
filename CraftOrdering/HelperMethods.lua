------------------------------------------------------------------
--  Serialisation Helpers  --
------------------------------------------------------------------
function table.isArray(tbl)
  if tbl[0] ~= nil then
    local lastNumber = 0
    -- Check table indexes to see if array
    for i,v in tbl do
      local t = type(i)
      if t ~= "number" then return false end
      -- Maximum index spread of 100
      if i > (lastNumber + 100) then return false end
      lastNumber = i
    end
    return true
  end
  return false
end

function ECO.Serialize(t)
  local mark={}
  local assign={}

  local function table2str(t, parent)
    mark[t] = parent
    local ret = {}

    if table.isArray(t) then
      for i,v in pairs(t) do
        local k = tostring(i)
        local dotkey = parent.."["..k.."]"
        local t = type(v)
        if t == "userdata" or t == "function" or t == "thread" or t == "proto" or t == "upval" then
          --ignore
        elseif t == "table" then
          if mark[v] then
            table.insert(assign, dotkey.."="..mark[v])
          else
            table.insert(ret, table2str(v, dotkey))
          end
        elseif t == "string" then
          table.insert(ret, string.format("%q", v))
        elseif t == "number" then
          if v == math.huge then
            table.insert(ret, "math.huge")
          elseif v == -math.huge then
            table.insert(ret, "-math.huge")
          else
            table.insert(ret,  tostring(v))
          end
        else
          table.insert(ret,  tostring(v))
        end
      end
    else
      for f,v in pairs(t) do
        local k = type(f)=="number" and "["..f.."]" or f
        local dotkey = parent..(type(f)=="number" and k or "."..k)
        local t = type(v)
        if t == "userdata" or t == "function" or t == "thread" or t == "proto" or t == "upval" then
          --ignore
        elseif t == "table" then
          if mark[v] then
            table.insert(assign, dotkey.."="..mark[v])
          else
            table.insert(ret, string.format("%s=%s", k, table2str(v, dotkey)))
          end
        elseif t == "string" then
          table.insert(ret, string.format("%s=%q", k, v))
        elseif t == "number" then
          if v == math.huge then
            table.insert(ret, string.format("%s=%s", k, "math.huge"))
          elseif v == -math.huge then
            table.insert(ret, string.format("%s=%s", k, "-math.huge"))
          else
            table.insert(ret, string.format("%s=%s", k, tostring(v)))
          end
        else
          table.insert(ret, string.format("%s=%s", k, tostring(v)))
        end
      end
    end

    return "{"..table.concat(ret,",").."}"
  end

  if type(t) == "table" then
    return string.format("%s%s",  table2str(t,"_"), table.concat(assign," "))
  else
    return tostring(t)
  end
end

local EMPTY_TABLE = {}
 
function  ECO.Deserialize(str)
  if str == nil or str == "nil" then
    return nil
  elseif type(str) ~= "string" then
    EMPTY_TABLE = {}
    return EMPTY_TABLE
  elseif #str == 0 then
    EMPTY_TABLE = {}
    return EMPTY_TABLE
  end

  local code, ret = pcall(loadstring(string.format("do local _=%s return _ end", str)))

  if code then
    return ret
  else
    EMPTY_TABLE = {}
    return EMPTY_TABLE
  end
end
------------------------------------------------------------------
--  Debug mode output to chat  --
------------------------------------------------------------------
function ECO.d(t)
  if ECO.debug then
    d(t)
  end
end