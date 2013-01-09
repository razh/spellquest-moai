Form = {}

function Form:new()
  local instance = {}

  setmetatable( instance, { __index = Form } )
  return instance
end
