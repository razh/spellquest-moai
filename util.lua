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
