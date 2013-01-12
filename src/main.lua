require "letter"
require "list"
require "dictionary"
require "form"
require "pool"

local WIDTH = MOAIEnvironment.horizontalResolution or 640
local HEIGHT = MOAIEnvironment.verticalResolution or 960
if WIDTH >= 640 and HEIGHT >= 960 then
  WIDTH = 640
  HEIGHT = 960
  MOAISim.openWindow( "SpellQuest", 640, 960 )
else
  WIDTH = 320
  HEIGHT = 480
  MOAISim.openWindow( "SpellQuest", 320, 480 )
end

-- MOAISim.setLoopFlags( MOAISim.LOOP_FLAGS_MULTISTEP )

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
-- test = {"arr","baggage", "mullet", "duck"}
--   table.sort( test, function( a, b )
--       if #a == #b then
--         return a < b
--       end

--       return #a < #b
--     end
--   )



dict = Dictionary:new()
word = dict:getRandomWord()
while #word < 5 do
  word = dict:getRandomWord()
end

word = "absurd"
pool = Pool:new()
pool:setSpacing( 48 )
pool:setPosition( -120, 160 )
pool:setLetters( split( word ) )
pool:addTo( layer )

form = Form:new()
form:setPosition( -120, 100 )
form:setSpacing( 48 )
form:createFormElements( #word )
form:addTo( layer )



list = List:new()
list:setPosition( -120, 56 )
list:setHorizontalSpacing( 16 )
list:setVerticalSpacing( 16 )
list:setColumnSpacing( 16 )
list:setPadding( 12 )
list:setMaxHeight( -SCALE_HEIGHT / 2 )
list:setWords( dict:getSubWords( word ) )
list:addTo( layer )

list:markWord( "bad")



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
  -- pool:update()
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

local selected = nil
local mouseX
local mouseY

function pointerCallback( x, y )
  -- print( x, y )
  mouseX = scale * ( x - WIDTH / 2 )
  mouseY = scale * ( -y + HEIGHT / 2 )
  -- if nil ~= selected then
  --   selected:setPosition( mouseX, mouseY )
  -- end
  -- pool:setPosition( scale * ( x - WIDTH / 2 ), scale * ( -y + HEIGHT / 2 ) )
end

function clickCallback( down )
  if down then
    if nil == selected then
      for i = 1, #pool._letterEntities do
        if pool._letterEntities[i]:getProp():inside( mouseX, mouseY ) then
          selected = pool._letterEntities[i]
          break
        end
      end
    else
      selected = nil
    end
  else
    if selected ~= nil then
      local index = lastIndexOf( pool._letterEntities, selected )
      if not pool._isUsed[ index ] then
        local formElement = form:getFirstEmptyFormElement( selected )
        if formElement ~= nil then
          local newX, newY = formElement:getPosition()
          newX = newX - selected:getX()
          newY = newY - selected:getY()
          selected:getProp():moveLoc( newX, newY, 0.1 )

          formElement:setLetter( selected )
          pool._isUsed[ index ] = true
        end
      else
        pool:pushLetter( selected )
      end
    end
  end
end

function onKeyDown( key, down )
  if down then
    print( key )
    -- Escape.
    if 27 == key then
      os.exit()
    end

    -- Enter.
    if 13 == key then
      local word = form:getWord()
      print( word )
      if list:isWord( word ) then
        list:markWord( word )
      end

      pool:reset()
    end

    -- Backspace.
    if 127 == key then
      if #form:getWord() ~= 0 then
        local formElement = form:getLastUsedFormElement()
        pool:pushLetter( formElement:getLetter() )
        formElement:setLetter( nil )
      end
    end

    -- `.
    if 96 == key then
      print( MOAISim.getMemoryUsage().lua )
    end

    if 97 <= key and key <= 122 then
      key = key - 32
    end

    if 65 <= key and key <= 90 then
      local letter = pool:getLetterByChar( string.char( key ) )
      if letter ~= nil then
        local formElement = form:getFirstEmptyFormElement()
        if formElement ~= nil then
          formElement:setLetter( letter )

          local x, y = formElement:getPosition()
          x = x - letter:getX()
          y = y - letter:getY()
          letter:getProp():moveLoc( x, y, 0.1 )
        end
      end
    end
  end
end

  -- instance._gfxQuad = MOAIGfxQuad2D.new()
  -- instance._gfxQuad:setTexture( Entity.texture )
  -- instance._gfxQuad:setRect( -64, -64, 64, 64 )

-- Mouse
if MOAIInputMgr.device.pointer then
  MOAIInputMgr.device.pointer:setCallback( pointerCallback )
  MOAIInputMgr.device.mouseLeft:setCallback( clickCallback )
-- Touch
else
  MOAIInputMgr.device.touch:setCallback(
    function( eventType, idx, x, y, tapCount )
      pointerCallback( x, y )
      if eventType == MOAITouchSensor.TOUCH_DOWN then
        clickCallback( true )
      elseif eventType == MOAITouchSensor.TOUCH_UP then
        clickCallback( false )
      end
    end
  )
end
-- MOAIInputMgr.device.mouseLeft:setCallback( clickCallback )
if MOAIInputMgr.device.keyboard then
  MOAIInputMgr.device.keyboard:setCallback ( onKeyDown )
end
