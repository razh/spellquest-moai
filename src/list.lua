require "class"
require "entity"
require "utils"

--- Tile
Tile = inheritsFrom( Entity )

local fontSize = 18
local scale = 2

Tile.font = MOAIFont.new()

Tile.font:load( 'resources/LibreBaskerville-Regular.ttf' )
Tile.font:preloadGlyphs( "ABCDEFGHIJKLMNOPQRSTUVWXYZ", fontSize * scale )

Tile.style = MOAITextStyle.new()
Tile.style:setColor( 1, 1, 1, 1 )
Tile.style:setFont( Tile.font )
Tile.style:setSize( fontSize )
Tile.style:setScale( 1 / scale )

local width = 6
local height = 6

Tile.emptyTexture = MOAITexture.new()
Tile.emptyTexture:setFilter( MOAITexture.GL_LINEAR_MIPMAP_LINEAR )
Tile.emptyTexture:load( "resources/debugBackground.png" )

Tile.emptyGfxQuad = MOAIGfxQuad2D.new()
Tile.emptyGfxQuad:setTexture( Tile.emptyTexture )
Tile.emptyGfxQuad:setRect( -width, -height, width, height )

Tile.usedTexture = MOAITexture.new()
Tile.usedTexture:setFilter( MOAITexture.GL_LINEAR_MIPMAP_LINEAR )
Tile.usedTexture:load( "resources/debug.png" )

Tile.usedGfxQuad = MOAIGfxQuad2D.new()
Tile.usedGfxQuad:setTexture( Tile.usedTexture )
Tile.usedGfxQuad:setRect( -width, -height, width, height )

function Tile:new()
  local instance = Entity:new()

  instance._char = ""
  instance._textBox = MOAITextBox.new()
  instance._textBox:setAttrLink( MOAIProp2D.ATTR_X_LOC, instance:getProp() )
  instance._textBox:setAttrLink( MOAIProp2D.ATTR_Y_LOC, instance:getProp() )
  instance._textBox:setAttrLink( MOAIProp2D.ATTR_Z_ROT, instance:getProp() )
  instance._textBox:setStyle( Tile.style )
  instance._textBox:setRect( -32 * scale, -32 * scale, 32 * scale, 32 * scale )
  instance._textBox:setYFlip( true )
  instance._textBox:setAlignment( MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY )

  instance:getProp():setDeck( Tile.emptyGfxQuad )

  setmetatable( instance, { __index = Tile } )
  return instance
end

function Tile:getChar()
  return self._char
end

function Tile:setChar( char )
  self._char = char:sub( 1, 1 ):upper()
end

function Tile:getTextBox()
  return self._textBox
end

function Tile:toggle()
  self:getProp():setDeck( Tile.usedGfxQuad )
  self:getTextBox():setString( self:getChar() )
end

function Tile:addTo( layer )
  Entity.addTo( self, layer )
  layer:insertProp( self:getTextBox() )
end

function Tile:removeFrom( layer )
  Tile.removeFrom( self, layer )
  layer:removeProp( self:getTextBox() )
end

--- Word
Word = inheritsFrom( Entity )

function Word:new()
  local instance = Entity:new()

  instance._letters = {}
  instance._letterTiles = {}
  -- Horizontal spacing between individual letters.
  instance._spacing = 0

  setmetatable( instance, { __index = Word } )
  return instance
end

function Word:getLetters()
  return self._letters
end

function Word:setLetters( letters )
  self._letters = letters
  -- self:calculateLetterPositions()
  self:createLetterTiles()
end

function Word:getSpacing()
  return self._spacing
end

function Word:setSpacing( spacing )
  self._spacing = spacing
end

function Word:createLetterTiles()
  local x, y = self:getPosition()
  local spacing = self:getSpacing()

  local tile = nil
  for i = 1, #self._letters do
    tile = Tile:new()
    tile:setChar( self._letters[i] )

    table.insert( self._letterTiles, tile )
    self._letterTiles[i]:setPosition( x + ( i - 1 ) * spacing, y )
  end
end

-- function Word:calculateLetterPositions()
--   local x, y = self:getPosition()
--   local spacing = self:getSpacing()

--   local xPos = 0
--   for i = 1, #self._letterEntities do
--   end
-- end

function Word:addTo( layer )
  Entity.addTo( self, layer )
  for i = 1, #self._letterTiles do
    self._letterTiles[i]:addTo( layer )
  end
end

function Word:removeFrom( layer )
  Entity.removeFrom( self, layer )
  for i = 1, #self._letterTiles do
    self._letterTiles[i]:removeFrom( layer )
  end
end

function Word:toggle()
  for i = 1, #self._letterTiles do
    self._letterTiles[i]:toggle()
  end
end

--- List
List = inheritsFrom( Entity )

function List:new()
  local instance = Entity:new()

  instance._words = {}
  -- Entities for each word.
  instance._wordEntities = {}
  -- Where the words are drawn.
  instance._wordPositions = {}
  -- Whether or not the player has found the word.
  instance._wasFound = {}

  -- Spacing between letters in a word.
  instance._horizontalSpacing = 0
  -- Spacing between words in a column.
  instance._verticalSpacing = 0
  -- Spacing between columns.
  instance._columnSpacing = 0
  -- Spacing from the maxHeight.
  instance._padding = 0

  instance._maxWidth = 0
  instance._maxHeight = 0

  instance._fontSize = 12

  setmetatable( instance, { __index = List } )
  return instance
end

function List:clear()
end

function List:addTo( layer )
  Entity.addTo( self, layer )
  for i = 1, #self._wordEntities do
    self._wordEntities[i]:addTo( layer )
  end
end

function List:removeFrom( layer )
end

function List:getWords()
  return self._words
end

function List:setWords( words )
  self._words = words
  for i = 1, #self._words do
    table.insert( self._wasFound, false )
  end

  self:calculateWordPositions()
  self:createWordEntities()
end

function List:calculateWordPositions()
  local x, y = self:getPosition()
  local padding = self:getPadding()
  local verticalSpacing = self:getVerticalSpacing()
  local horizontalSpacing = self:getHorizontalSpacing()
  local columnSpacing = self:getColumnSpacing()
  local maxHeight = self:getMaxHeight()

  local xPos = 0
  local yPos = 0
  for i = 1, #self._words do
    table.insert( self._wordPositions, {
      x = x + xPos,
      y = y + yPos
    })

    yPos = yPos - verticalSpacing
    -- maxHeight in MOAI world space is reversed.
    if y + yPos - padding < maxHeight then
      xPos = xPos + #self._words[i] * horizontalSpacing + columnSpacing
      yPos = 0
    end
  end
end

function List:createWordEntities()
  local horizontalSpacing = self:getHorizontalSpacing()
  local word = nil
  for i = 1, #self._words do
    word = Word:new()
    word:setSpacing( horizontalSpacing )
    word:setPosition( self._wordPositions[i] )
    word:setLetters( split( self._words[i] ) )

    table.insert( self._wordEntities, word )
    table.insert( self._wasFound, false )
  end
end

function List:isWord( word )
  return lastIndexOf( self:getWords(), word )
end

function List:wasWordFound( word )
  local index = lastIndexOf( self.getWords(), word )
  return index ~= nil and self._wasFound[ index ]
end

function List:markWord( word )
  local index = lastIndexOf( self:getWords(), word )
  if index ~= nil and not self._wasFound[ index ] then
    self._wordEntities[ index ]:toggle()
  end
end

function List:getHorizontalSpacing()
  return self._horizontalSpacing
end

function List:setHorizontalSpacing( horizontalSpacing )
  self._horizontalSpacing = horizontalSpacing
end

function List:getVerticalSpacing()
  return self._verticalSpacing
end

function List:setVerticalSpacing( verticalSpacing )
  self._verticalSpacing = verticalSpacing
end

function List:getColumnSpacing()
  return self._columnSpacing
end

function List:setColumnSpacing( columnSpacing )
  self._columnSpacing = columnSpacing
end

function List:getPadding()
  return self._padding
end

function List:setPadding( padding )
  self._padding = padding
end

function List:getMaxHeight()
  return self._maxHeight
end

function List:setMaxHeight( maxHeight )
  self._maxHeight = maxHeight
end

function List:getFontSize()
  return self._fontSize
end

function List:setFontSize( fontSize )
  self._fontSize = fontSize
end
