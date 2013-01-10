Entity = {}

Entity.texture = MOAITexture.new()
Entity.texture:setFilter( MOAITexture.GL_LINEAR_MIPMAP_LINEAR )
Entity.texture:load( "resources/debug.png" )

-- Container class for a prop.
function Entity:new()
  local instance = {}

  instance._gfxQuad = MOAIGfxQuad2D.new()
  instance._gfxQuad:setTexture( Entity.texture )
  instance._gfxQuad:setRect( -64, -64, 64, 64 )

  instance._prop = MOAIProp2D.new()
  instance._prop:setDeck( instance._gfxQuad )

  setmetatable( instance, { __index = Entity } )
  return instance
end

function Entity:getProp()
  return self._prop
end

function Entity:setGfxQuad( gfxQuad )
  self:getProp():setDeck( gfxQuad )
end

function Entity:getX()
  return self:getProp():getAttr( MOAIProp2D.ATTR_X_LOC )
end

function Entity:setX()
end

function Entity:getPosition()
  return self._prop:getLoc()
end

function Entity:setPosition( position )
  self:setX( position.x )
  self:setY( position.y )
end
