require "utils"

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
  instance:createMap()
  return instance
end

function Dictionary:getRandomWord( word )
  math.randomseed( os.time () )
  math.random()
  return self._wordList[ math.random ( #self._wordList ) ]
end

function Dictionary:getSubWords( word )
  local array = uniqueArray( self:getSubWordsRecursive( word ) )
  table.sort( array, function( a, b )
      if #a == #b then
        return a < b
      end

      return #a < #b
    end
  )
  return array;
end

function Dictionary:getSubWordsRecursive( word )
  if word:len() < 3 then
    return {}
  end

  local sortedWordArray = split( word )
  table.sort( sortedWordArray )
  local sortedWord = join( sortedWordArray )

  local subWordsArray = self._wordMap[ sortedWord ]
  if nil == subWordsArray then
    subWordsArray = {}
  end

  local tempWord, tempWordArray = nil
  for i = 1, #sortedWordArray do
    tempWord = sortedWord
    tempWordArray = split( tempWord )
    table.remove( tempWordArray, i )

    tempWordArray = self:getSubWordsRecursive( join( tempWordArray ) )
    for j = 1, #tempWordArray do
      table.insert( subWordsArray, tempWordArray[j] )
    end
  end

  return subWordsArray
end

function Dictionary:createMap()
  local array, key, word = nil
  for i = 1, #self._wordList do
    array = split( self._wordList[i] )
    table.sort( array )

    word = join( array )
    key = self._wordMap[ word ]

    if nil == key then
      key = {}
    end

    table.insert( key, self._wordList[i] )
    self._wordMap[ word ] = key
  end
end

function Dictionary:isWord( word )
  return lastIndexOf( self._wordList, word ) ~= nil
end
