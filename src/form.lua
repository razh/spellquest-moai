require "class"
require "entity"

FormElement = inheritsFrom( Entity )

local width = 24
local height = 24

FormElement.texture = MOAITexture.new()
FormElement.texture:setFilter( MOAITexture.GL_LINEAR_MIPMAP_LINEAR )
FormElement.texture:load( "resources/debugBackground.png" )

FormElement.gfxQuad = MOAIGfxQuad2D.new()
FormElement.gfxQuad:setTexture( FormElement.texture )
FormElement.gfxQuad:setRect( -width, -height, width, height )

function FormElement:new()
  local instance = Entity:new()

  instance._letter = nil

  instance:getProp():setDeck( FormElement.gfxQuad )

  setmetatable( instance, { __index = FormElement } )
  return instance
end

Form = inheritsFrom( Entity )

function Form:new()
  local instance = Entity:new()

  instance._spacing = 0
  instance._formElements = {}

  setmetatable( instance, { __index = Form } )
  return instance
end

function Form:getSpacing()
end

function Form:setSpacing( spacing )
end

function Form:createFormElements()
end
