require "letter"
require "dictionary"
require "form"
require "pool"

MOAISim.openWindow( "SpellQuest", 640, 960 )
-- MOAISim.openWindow( "SpellQuest", 320, 480 )

-- MOAISim.setLoopFlags( MOAISim.LOOP_FLAGS_MULTISTEP )

WIDTH, HEIGHT = MOAIGfxDevice.getViewSize()
SCALE_WIDTH = 320
SCALE_HEIGHT = 480
scale = SCALE_WIDTH / WIDTH
viewport = MOAIViewport.new()
viewport:setScale( SCALE_WIDTH, SCALE_HEIGHT )
viewport:setSize( WIDTH, HEIGHT )

layer = MOAILayer2D.new()
layer:setViewport( viewport )
MOAIRenderMgr.setRenderTable({ layer } )

running = true

pool = Pool:new()
pool:setPosition( -120, 160 )
pool:setLetters( split( "absurd" ) )
pool:addTo( layer )

fE = FormElement:new()
fE:setPosition( -120, 100 )
fE:addTo( layer )
function test()
  -- local action;

  -- action = letter2:getProp():moveLoc( 20, 100, 1.0 )
  -- while action:isBusy() do coroutine:yield() end

  -- action = letter2:getProp():moveLoc( -20, -100, 1.0 )
  -- while action:isBusy() do coroutine:yield() end

  -- -- action = letter:getProp():moveRot( 180, 1 )
  -- -- while action:isBusy() do coroutine:yield() end -- spin lock until action is done

  -- -- action = letter:getProp():moveLoc( 128, 0, 1 )
  -- -- while action:isBusy() do coroutine:yield() end

  -- -- action = letter:getProp():moveScl( -0.5, -0.5, 1 )
  -- -- while action:isBusy() do coroutine:yield() end

  -- -- action = letter:getProp():moveLoc( -128, 0, 1, 5 )
  -- -- while action:isBusy() do coroutine:yield() end

  -- action = letter:getProp():moveRot( 180, 1 )
  -- while action:isBusy() do coroutine:yield() end

  -- action = letter:getProp():moveRot( 180, 1 )
  -- while action:isBusy() do coroutine:yield() end
end

testThread = MOAICoroutine.new()
testThread:run( function()
               while running do
               test()
               coroutine.yield()
             end
             end
)


function update()
  pool:update()
end

updateThread = MOAICoroutine.new()
updateThread:run(
  function()
    while running do
      update()
      coroutine.yield()
    end
  end
)
letters = {}

dictionary = Dictionary:new()

-- local transform = MOAITransform.new()
-- transform:setLoc( 0, 0 )
-- letter:getProp():setParent( transform )

-- print( letter:getProp():getAttr( MOAIProp2D.ATTR_X_LOC ) )

tempCharCode = 65
mainThread = MOAICoroutine.new()
mainThread:run(
  function()
    while running do
      -- print( dictionary:getRandomWord() )
      -- letter:setChar( string.char( tempCharCode ) )
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
-- test2 = dictionary:getSubWords("roosts")
-- -- tes = { 0, 1, 2, 3, 4, 5 }
-- -- test2 = fisherYates( tes )
-- print( "YO" )
-- for i = 1, #test2 do
--   print(test2[i])
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
  -- pool:setPosition( scale * ( x - WIDTH / 2 ), scale * ( -y + HEIGHT / 2 ) )
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
      letter:setChar( string.char( key ) )
      print( string.char(key) )
    end
  end
end

  -- instance._gfxQuad = MOAIGfxQuad2D.new()
  -- instance._gfxQuad:setTexture( Entity.texture )
  -- instance._gfxQuad:setRect( -64, -64, 64, 64 )

-- Mouse
if MOAIInputMgr.device.pointer then
  MOAIInputMgr.device.pointer:setCallback( pointerCallback )
-- Touch
else
  MOAIInputMgr.device.touch:setCallback (
      function ( eventType, idx, x, y, tapCount )
        pointerCallback( x, y )
      end
  )
end
-- MOAIInputMgr.device.mouseLeft:setCallback( clickCallback )
MOAIInputMgr.device.keyboard:setCallback ( onKeyDown )
