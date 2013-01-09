require "letter"
require "dictionary"

MOAISim.openWindow( "SpellQuest", 640, 960 )

viewport = MOAIViewport.new()
viewport:setScale( 320, 480 )
viewport:setSize( 640, 960 )

layer = MOAILayer2D.new()
layer:setViewport( viewport )
MOAIRenderMgr.setRenderTable( { layer } )

running = true

letter = Letter:new()
letter:setChar( "h" )
print( letter:getChar() )
layer:insertProp( letter:getProp() )

letters = {}

dictionary = Dictionary:new()

local transform = MOAITransform.new()
transform:setLoc( 0, 0 )
letter:getProp():setParent( transform)

mainThread = MOAICoroutine.new()
mainThread:run(
  function()
    while running do
      -- print( dictionary:getRandomWord() )

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
test = dictionary:getSubWords("roosts")
for i = 1, #test do
  print(test[i])
end


pos = {
  x = 56,
  y = 28
}

print( pos.x)
