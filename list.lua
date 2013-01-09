List = {}

function List:new()
  local instance = {}

  setmetatable( instance, { __index = List } )
  return instance
end
