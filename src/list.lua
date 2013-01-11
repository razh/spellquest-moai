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

  setmetatable( instance, { __index = List } )
  return instance
end

function List:clear()
end

function List:addTo( layer )
end

function List:removeFrom( layer )
end
