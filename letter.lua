require "class"
require "entity"

Letter = inheritsFrom( Entity )

local charCode = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

local fontSize = 144
local scale = 2

Letter.font = MOAIFont.new()
Letter.font:load( 'resources/Helvetica.ttf' )
Letter.font:preloadGlyphs( charCode, fontSize * scale )

Letter.style = MOAITextStyle.new()
Letter.style:setColor( 1, 1, 1, 1 )
Letter.style:setFont( Letter.font )
Letter.style:setSize( fontSize )
Letter.style:setScale( 1 / scale )

function Letter:new()
  local instance = Entity:new()

  instance._char = ""
  instance._textBox = MOAITextBox.new()
  instance._textBox:setParent( instance:getProp() )

  instance._textBox:setStyle( Letter.style )
  instance._textBox:setRect( -128 * scale, -128 * scale, 128 * scale, 128 * scale )
  instance._textBox:setYFlip( true )
  instance._textBox:setAlignment( MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY )

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
