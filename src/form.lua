FormElement = {}

function FormElement:new()
end

Form = {}

function Form:new()
  local instance = {}

  instance._spacing = 0
  instance._formElements = {}

  setmetatable( instance, { __index = Form } )
  return instance
end
