Letter = {}

function Letter:new()
  local instance = {}

  instance._gfxQuad = MOAIGfxQuad2D.new()
  instance._gfxQuad:setTexture( "resources/letterBackground.png" )
  instance._gfxQuad:setRect( -64, -64, 64, 64 )

  instance._prop = MOAIProp2D.new()
  instance._prop:setDeck( instance._gfxQuad )

  instance._char = ""

  setmetatable( instance, { __index = Letter } )
  return instance
end

function Letter:getProp()
  return self._prop
end

function Letter:getChar()
  return self._char
end

function Letter:setChar( char )
  self._char = char:sub( 1, 1 )
end
