Dictionary = {}

function Dictionary:new( location )
  local instance = {}

  if nil == location then
    location = "resources/dictionary.json"
  end

  local file = assert( io.open( location, "r" ) )
  instance._wordList = MOAIJsonParser.decode( file:read( "*all" ) )
  file:close()

  instance._wordMap = {}

  setmetatable( instance, { __index = Dictionary } )
  return instance
end


function Dictionary:getRandomWord()
  math.randomseed( os.time () )
  math.random()
  return self._wordList[ math.random ( #self._wordList ) ]
end


function Dictionary:getSubWords( word )
  return nil
end

function Dictionary:getSubWordsRecursive( word )
  if word:len() < 3 then
    return {}
  end

end

function Dictionary:createMap()
  local key, word = nil
  for i = 1, #self._wordList do
    print( self._wordList[i])
  end
end

function Dictionary:isWord( word )
  return lastIndexOf( self._wordList, word ) ~= -1
end

function uniqueArray( array )
  local newArray = {}
  for i = 1, #array do
    if ( lastIndexOf( newArray, array[i] ) == -1 ) then
        table.insert( newArray, array[i] )
    end
  end

  return newArray
end


-- Helper JavaScript functions.
function lastIndexOf( array, object )
  for i = #array, 1, -1 do
    if object == array[i] then
      return i
    end
  end

  return -1
end


function split( str )
  local array = {}

  for i = 1, #str do
    table.insert( array, str:sub( i, i ) )
  end

  return array
end

function join( array )
  return table.concat( array )
end
