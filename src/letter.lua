require "class"
require "entity"

Letter = inheritsFrom( Entity )

local charCode = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

local fontSize = 144
local scale = 2

Letter.font = MOAIFont.new()
Letter.font:load( '../resources/LibreBaskerville-Regular.ttf' )
Letter.font:preloadGlyphs( charCode, fontSize * scale )

Letter.style = MOAITextStyle.new()
Letter.style:setColor( 1, 1, 1, 1 )
Letter.style:setFont( Letter.font )
Letter.style:setSize( fontSize )
Letter.style:setScale( 1 / scale )

local width = 48
local height = 48

Letter.texture = MOAITexture.new()
Letter.texture:setFilter( MOAITexture.GL_LINEAR_MIPMAP_LINEAR )
Letter.texture:load( "../resources/debug.png" )

Letter.gfxQuad = MOAIGfxQuad2D.new()
Letter.gfxQuad:setTexture( Letter.texture )
Letter.gfxQuad:setRect( -width, -height, width, height )


function Letter:new()
  local instance = Entity:new()

  instance._char = ""
  instance._textBox = MOAITextBox.new()
  instance._textBox:setAttrLink( MOAIProp2D.ATTR_X_LOC, instance:getProp() )
  instance._textBox:setAttrLink( MOAIProp2D.ATTR_Y_LOC, instance:getProp() )
  instance._textBox:setAttrLink( MOAIProp2D.ATTR_Z_ROT, instance:getProp() )
  instance._textBox:setStyle( Letter.style )
  instance._textBox:setRect( -32 * scale, -32 * scale, 32 * scale, 32 * scale )
  instance._textBox:setYFlip( true )
  instance._textBox:setAlignment( MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY )

  instance:getProp():setDeck( Letter.gfxQuad )

  setmetatable( instance, { __index = Letter } )
  return instance
end

function Letter:getChar()
  return self._char
end

function Letter:setChar( char )
  self._char = char:sub( 1, 1 ):upper()
  self:getTextBox():setString( self:getChar() )
end

function Letter:getTextBox()
  return self._textBox
end
