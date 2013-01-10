Entity = {}

-- Container class for a prop.
function Entity:new()
  local instance = {}

  instance._prop = MOAIProp2D.new()

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

function Entity:setX( x )
  self:getProp():setAttr( MOAIProp2D.ATTR_X_LOC, x )
end

function Entity:getY()
  return self:getProp():getAttr( MOAIProp2D.ATTR_Y_LOC )
end

function Entity:setY( y )
  self:getProp():setAttr( MOAIProp2D.ATTR_Y_LOC, y )
end

function Entity:getPosition()
  return self._prop:getLoc()
end

function Entity:setPosition( position )
  self:setX( position.x )
  self:setY( position.y )
end
