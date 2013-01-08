print ( "hello, moai!" )

MOAISim.openWindow ( "SpellQuest", 320, 480 )

viewport = MOAIViewport.new ()
viewport:setScale ( 320, 480 )
viewport:setSize ( 320, 480 )

layer = MOAILayer2D.new ()
layer:setViewport ( viewport )
MOAISim.pushRenderPass ( layer )
