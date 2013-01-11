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

function FormElement:getLetter()
  return self._letter
end

function FormElement:setLetter( letter )
  self._letter = letter
end

function FormElement:hasLetter()
  return self._letter ~= nil
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
  return self._spacing
end

function Form:setSpacing( spacing )
  self._spacing = spacing
end

function Form:createFormElements( letterCount )
  local x, y = self:getPosition()
  local spacing = self:getSpacing()

  local tempFormElement = nil
  for i = 1, letterCount do
    tempFormElement = FormElement:new()
    tempFormElement:setPosition( x + ( i - 1 ) * spacing, y )

    table.insert( self._formElements, tempFormElement )
  end
end

function Form:getFormElements()
  return self._formElements
end

function Form:getFirstEmptyFormElement( letter )
  for i = 1, #self._formElements do
    if not self._formElements[i]:hasLetter() or
      letter ~= nil and self._formElements[i]:getLetter() == letter then
      return self._formElements[i]
    end
  end
end

function Form:addTo( layer )
  Entity.addTo( self, layer )
  for i = 1, #self._formElements do
    self._formElements[i]:addTo( layer )
  end
end

function Form:removeFrom( layer )
  Entity.removeFrom( self, layer )
  for i = 1, #self._formElements do
    self._formElements[i]:removeFrom( layer )
  end
end
