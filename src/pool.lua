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

function Pool:getLetterByChar( char )
  local index = nil
  for i = 1, #self._letterIndices do
    index = self._letterIndices[i]
    if self._letterEntities[ index ]:getChar() == char and not self._isUsed[ index ] then
      self._isUsed[ index ] = true
      return self._letterEntities[ index ]
    end
  end
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
    table.insert( indices, i )
  end

  self._letters = letters
  self._letterIndices = fisherYates( indices )

  self:createLetterEntities()
end

function Pool:pushLetter( letter )
  local x, y = self:getPosition()
  local spacing = self:getSpacing()

  local xPos = 0
  local newIndices = {}
  local index = 0
  -- Rearrange unused letters in pool.
  for i = 1, #self._letterIndices do
    index = self._letterIndices[i]
    if not self._isUsed[ index ] then
      local newX = x + xPos * spacing
      local newY = y
      newX = newX - self._letterEntities[ index ]:getX()
      newY = newY - self._letterEntities[ index ]:getY()
      self._letterEntities[ index ]:getProp():moveLoc( newX, newY, 0.1 )

      -- self._letterEntities[ index ]:setPosition( x + xPos * spacing, y )
      table.insert( newIndices, index )
      xPos = xPos + 1
    end
  end

  -- Move letter to last available position in pool.
  local index = lastIndexOf( self._letterEntities, letter )
  if index then
    self._isUsed[ index ] = false

    local newX = x + xPos * spacing
    local newY = y
    newX = newX - self._letterEntities[ index ]:getX()
    newY = newY - self._letterEntities[ index ]:getY()
    self._letterEntities[ index ]:getProp():moveLoc( newX, newY, 0.1 )
    -- self._letterEntities[ index ]:setPosition( x + xPos * spacing, y )
    table.insert( newIndices, index )
  end

  self._letterIndices = newIndices
end

function Pool:createLetterEntities()
  local letter = nil
  for i = 1, #self._letters do
    letter = Letter:new()
    letter:setChar( self._letters[i] )

    table.insert( self._letterEntities, letter )
    table.insert( self._isUsed, false )
  end

  local x, y = self:getPosition()
  local spacing = self:getSpacing()
  -- Position letters in scrambled order.
  for i = 1, #self._letterIndices do
    self._letterEntities[ self._letterIndices[i] ]:setPosition( x + ( i - 1 ) * spacing, y )
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
