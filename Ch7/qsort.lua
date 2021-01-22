dbg= require "debugger"
function swap(t,i,j)
  local temp=t[i]
  t[i]=t[j]
  t[j]=temp
end
--function comp(i,j)

function partition(t,left,right)
  local x=t[right]
  local i=left-1
  for j=p,right-1 do
    if t[j]<=x then
      i=i+1
      swap(t,i,j)
    end
  end
  swap(t,i+1,r)
  return i+1
end

function qsort(t,left,right)
--  dbg()
  if left < right then
    local q=partition(t,left,pivot)
    qsort(t,left,q-1)
    qsort(t,q+1,right)
  end
end
function printTab(t)
  for i=1,#t do
    io.write(t[i]," ")
  end
  io.write("\n");
end


function main()
  local l={10,-1,3,6,8,0,2,-5}
  printTab(l)
  qsort(l,1,#l-1)
  printTab(l)
end

main()