require "class"
require "entity"

List = inheritsFrom( Entity )

function List:new()
  local instance = {}

  instance._words = {}
  -- Where the words are drawn.
  instance._wordPositions = {}
  -- Whether or not the player has found the word.
  instance._wasFound = {}

  -- Spacing between columns.
  instance._horizontalSpacing = 0
  -- Spacing between words in a column.
  instance._verticalSpacing = 0
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
end

function List:calculateWordPositions()
  local x, y = self:getPosition()
  local horizontalSpacing = self:getHorizontalSpacing()
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

function List:getPadding()
  return self._padding
end

function List:setPadding( padding )
  self._padding = padding
end

function List:getFontSize()
  return self._fontSize
end

function List:setFontSize( fontSize )
  self._fontSize = fontSize
end
