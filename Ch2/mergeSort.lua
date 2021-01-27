dbg=require("debugger")

function arrayInit(Arr,lim)
  for i=1,lim do
    Arr[i]=0
  end
  return Arr
end

--copies contents of array A1 to A2
--optional 3rd argument: lim
--controls how much of A1 to copy to A2
function arrayCopy(A1,A2,lim)
  lim=lim or #A1
  for i=1,lim do
    table.insert(A2,A1[i])
  end
end



function mergeSort(list)
--  dbg()
  firstHalf={}
  secondHalf={}
  if #list > 1 then
    arrayCopy(list, firstHalf, (#list)/2)
    mergeSort(firstHalf)

--merge sort the second half
    
    secondHalfLength=#list - (#list)/2
    arrayCopy(list, secondHalf, secondHalfLength)
    mergeSort(secondHalf)
    merge(list,firstHalf,secondHalf)
  end
  return
end

function merge(list1,list2,temp)
  temp=temp or {}
  local current1 = 1 --current index in list1
  local current2 = 1 --current index in list2
  local current3 = 1 --current index in temp
		
  while current1< #list1 and current2 < #list2 do
    if  list1[current1] < list2[current2] then
	temp[current3] = list1[current1];
	current3=current3+1
	current1=current1+1
    else
        temp[current3]=list2[current2];
	current3=current3+1
	current2=current2+1
    end
  end
  while current1 < #list1 do
	temp[current3] = list1[current1]
	current3=current3+1
	current1=current1+1
  end
  while current2 < #list2 do
	temp[current3] = list2[current2];
        current3=current3+1
	current2=current2+1
  end	
end

function printArray(Arr)
  for i,v in ipairs(Arr) do
    io.write(v," ")
  end
  io.write("\n")
end



function main()
   local list={350, 223, 445, -45, 56, 234, -99, 498, 428, -990, 56, 78, 88, -999};		
   local s1 = "Before invoking the Merge Sort algorithm:\n";
   local s2 = "After invoking the Merge Sort algorithm:\n";
   local s3 = "Merge Sort runs in O(n lg n) time!\n";

    print(s1)
    printArray(list);
    print("\n");
    mergeSort(list);
    print(s2);
    printArray(list);
    print("\n");
    print(s3);
end

main()
