require "class"
require "utils"
require "letter"

Pool = inheritsFrom( Entity )

function Pool:new()
  local instance = Entity:new()

  instance._spacing = 0;
  -- Actual letters, in order.
  instance._letters = {}
  -- Letter entities, in order.
  instance._letterEntities = {}
  -- Order of the letter entities in the pool.
  instance._letterIndices = {};
  -- Whether the letter has been used, in order.
  instance._isUsed = {};

  instance._textColor = MOAIColor.new()
  instance._fontSize = 12;

  setmetatable( instance, { __index = Pool } )
  return instance
end

function Pool:getLetterByChar()
end

function Pool:getSpacing()
  return self._spacing
end

function Pool:setSpacing( spacing )
  self._spacing = spacing
end

function Pool:getTextColor()
  return self._textColor
end

function Pool:setTextColor( textColor )
  self._textColor = textColor
end

function Pool:getFontSize()
  return self._fontSize
end

function Pool:setFontSize( fontSize )
  self._fontSize = fontSize
end

function Pool:clear()
  self._letters = {}
  self._letterEntities = {}
  self._letterIndices = {}
  self._isUsed = {}
end

function Pool:getLetters()
  return self._letters
end

function Pool:setLetters( letters )
  local indices = {}
  for i = 1, #letters do
    indices[i] = i
  end

  self._letters = letters
  self._letterIndices = fisherYates( indices )

  self:createLetterEntities()
end

function Pool:createLetterEntities()
  local letter = nil
  for i = 1, #self:getLetters() do
    letter = Letter:new()
    letter:setChar( self:getLetters()[i] )
    -- letter:setPosition( i * 24, 0 )
    local x, y = self:getPosition()
    letter:setPosition( x + ( i - 1 ) * 48, y )
    -- letter:getProp():setPos( MOAIProp2D.ATTR_Y_LOC, self:getProp() )
    -- letter:getProp():setPos( MOAIProp2D.ATTR_Z_ROT, self:getProp() )

    table.insert( self._letterEntities, letter )
    table.insert( self._isUsed, false )
  end
end

function Pool:reset()
  -- Remember to use clearAttrLink()
end


function Pool:addTo( layer )
  Entity.addTo( self, layer )
  for i = 1, #self._letterEntities do
    self._letterEntities[i]:addTo( layer )
  end
end

function Pool:removeFrom( layer )
  Entity.removeFrom( self, layer )
  for i = 1, #self._letterEntities do
    self._letterEntities[i]:removeFrom( layer )
  end
end

function Pool:shuffle()
  local index = lastIndexOf( self._isUsed, true )

  -- Only shuffle if ALL letters are not used.
  if nil == index then
    local x, y = self:getPosition()
    local spacing = self:getSpacing()

    local xPos = 0
    self._letterIndices = fisherYates( array )
    for i = 1, #self._letterIndices do
      self._letterEntities[ self._letterIndices[i] ]:setPosition({
        x = x + xPos * spacing,
        y = y
      })
      xPos = xPos + 1
    end
  end
end

function Pool:update()
  local x, y
  local letter
  for i = 1, #self._letterEntities do
    letter = self._letterEntities[i]

    x, y = self:getPosition()
    letter:setPosition( x + ( i - 1 ) * 48, y )
    -- letter:getProp():setPos( MOAIProp2D.ATTR_Y_LOC, self:getProp() )
    -- letter:getProp():setPos( MOAIProp2D.ATTR_Z_ROT, self:getProp() )
  end
end

-- Modified form http://developer.coronalabs.com/code/shufflerandomize-tables
function fisherYates( array )
  local newArray = copy( array )

  math.randomseed( os.time() )
  local iterations = #array
  local j
  for i = iterations, 2, -1 do
    j = math.random(i)
    newArray[i], newArray[j] = newArray[j], newArray[i]
  end

  return newArray
end
