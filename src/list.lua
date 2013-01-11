require "class"
require "entity"

List = inheritsFrom( Entity )

function List:new()
  local instance = {}

  setmetatable( instance, { __index = List } )
  return instance
end
