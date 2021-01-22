function swap(t,i,j)
  local temp=t[i]
  t[i]=t[j]
  t[j]=temp
end
--function comp(i,j)
  


function qsort(t,left,right)
  local last;
  if left>=right then
    return
  end
  swap(t,left,(left+right)/2)
  last = left;
  for i=left+1,right do
    if t[i]<t[left] then
      swap(t,last+1,i)
    end
  end
  swap(t,left,last)
  qsort(t,left,last-1)
  qsort(t,last+1,right)
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