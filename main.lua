require "letter"
require "dictionary"
require "pool"

MOAISim.openWindow( "SpellQuest", 640, 960 )
-- MOAISim.setLoopFlags( MOAISim.LOOP_FLAGS_MULTISTEP )

viewport = MOAIViewport.new()
viewport:setScale( 320, 480 )
viewport:setSize( 640, 960 )

layer = MOAILayer2D.new()
layer:setViewport( viewport )
MOAIRenderMgr.setRenderTable( { layer } )

running = true

letter = Letter:new()
letter:setChar( "b" )
print( letter:getChar() )
layer:insertProp( letter:getProp() )
-- letter:getTextBox():setString( "HELLO")
layer:insertProp( letter:getTextBox() )
-- letter:getProp():moveLoc( 20, 100, 3.0 )

function test()
  local action;

  action = letter:getProp():moveRot( 180, 1 )
  while action:isBusy() do coroutine:yield() end -- spin lock until action is done

  action = letter:getProp():moveLoc( 128, 0, 1 )
  while action:isBusy() do coroutine:yield() end

  action = letter:getProp():moveScl( -0.5, -0.5, 1 )
  while action:isBusy() do coroutine:yield() end

  action = letter:getProp():moveLoc( -128, 0, 1, 5 )
  while action:isBusy() do coroutine:yield() end

  action = letter:getProp():moveRot( 180, 1 )
  while action:isBusy() do coroutine:yield() end
end

testThread = MOAICoroutine.new()
-- testThread:run( test )

letters = {}

dictionary = Dictionary:new()

-- local transform = MOAITransform.new()
-- transform:setLoc( 0, 0 )
-- letter:getProp():setParent( transform )

print( letter:getProp():getAttr( MOAIProp2D.ATTR_X_LOC ) )

tempCharCode = 65
mainThread = MOAICoroutine.new()
mainThread:run(
  function()
    while running do
      -- print( dictionary:getRandomWord() )
      letter:setChar( string.char( tempCharCode ) )
      tempCharCode = tempCharCode + 1
      if tempCharCode > 90 then
        tempCharCode = 65
      end
      coroutine.yield()
    end
  end
)

-- test = {"arr","baggage", "mullet", "duck"}
--   table.sort( test, function( a, b )
--       if #a == #b then
--         return a < b
--       end

--       return #a < #b
--     end
--   )
-- test = dictionary:getSubWords("roosts")
-- tes = { 0, 1, 2, 3, 4, 5 }
-- test = fisherYates( tes )
-- print( "YO" )
-- for i = 1, #test do
--   print(test[i])
-- end
-- print( "OY" )


pos = {
  x = 56,
  y = 28
}

print( pos.x)

function onDraw()
  MOAIGfxDevice.setPenColor( 1, 0, 0, 1 )
  MOAIDraw.fillCircle( 0, 0, 20, 32 )
end

scriptDeck = MOAIScriptDeck.new()
scriptDeck:setRect( -64, -64, 64, 64 )
-- scriptDeck:setDrawCallback( onDraw )

prop = MOAIProp2D.new()
prop:setDeck( scriptDeck )
layer:insertProp( prop )

function inputDown()
end

local mouseX
local mouseY

function pointerCallback( x, y )
  -- print( x, y )
  letter:setPosition(x / 2 - 160, -y / 2 + 240 )
end

function clickCallback( down )
  if down then
    mouseX = x
    mouseY = y
  end
end

function onKeyDown( key, down )
  if down then
    if 65 <= key and key <= 90 then
      key = key + 32
    end

    if 97 <= key and key <= 122 then
      print( string.char(key) )
    end
  end
end

  -- instance._gfxQuad = MOAIGfxQuad2D.new()
  -- instance._gfxQuad:setTexture( Entity.texture )
  -- instance._gfxQuad:setRect( -64, -64, 64, 64 )

MOAIInputMgr.device.pointer:setCallback( pointerCallback )
MOAIInputMgr.device.mouseLeft:setCallback( clickCallback )
MOAIInputMgr.device.keyboard:setCallback ( onKeyDown )
