require "letter"

MOAISim.openWindow ( "SpellQuest", 640, 960 )

viewport = MOAIViewport.new ()
viewport:setScale ( 320, 480 )
viewport:setSize ( 320, 480 )

layer = MOAILayer2D.new ()
layer:setViewport ( viewport )
MOAISim.pushRenderPass ( layer )

running = true

letter = Letter:new()
layer:insertProp( letter:getProp () )

letters = {}

-- mainThread = MOAICoroutine.new ()
-- mainThread:run (
--   function ()
--     while running do
--       coroutine.yield ()
--     end
--   end
-- )

local file = assert ( io.open ( "resources/dictionary.json", "r" ) )
local dictionary = MOAIJsonParser.decode ( file:read( "*all" ) )
file:close()
print ( dictionary[1] )
