Node=require("Node")
disjointset={
   list={}, --to hold roots of all trees in the forest

-- inner node class for the disjointset forest
   Node =Node:new()
}

-- disjoint set implementation that uses a master list to hold
-- hold all root nodes;
-- now every method must operate on the list
-- the arg N is the number of nodes
function disjointset:new(N)
   for i=1,N do
      self.list[i]=false
   end
   local d={self.list}
  setmetatable(d,self)
  self.__index=self
  return d
end

-- function that initializes nodes with default values
--  and adds them to the setlist
function disjointset:initList(N)
   for i=1,N do
      self.list[i]=self.Node:new(0)  --create and add default nodes
                              --  to disjointset list
   end
   return self.list[1] ~= nil
end


--function that takes two edge nodes and creates and links them
function disjointset:addNodes(n,m)
   if self.list[n].data ~= n then
      self.list[n].data=n
   end

   if self.list[m].data ~= m then
      self.list[m].data=m
   end
   self:Link(self.list[n],self.list[m])
end


function disjointset:Union(n,m)
   return  self:Link(self:FindSet(n),self:FindSet(m))
end


-- function that links the two nodes
function disjointset:Link(x,y)
   -- if rank of y is greater
   if x.rank < y.rank then
      --make it your parent
     x.parent = y
  else  --otherwise make yourself y's parent
     y.parent=self
     --if ranks are equal 
     if x.rank==y.rank then
        x.rank=x.rank+1
     end
  end
end


-- function that finds the leading representative of the
-- set; the arg x is a node reference
-- 
function disjointset:FindSet(x)
   --if x is not root
   if x.parent ~= false then
      x=x.parent
      --go up the findpath
      return self:FindSet(x)
    --if x is root return x
   else return x
   end
end



--function that dumps out everything in the ds
function disjointset:toString()
   local length = #self.list 
   local list_str="there are "..tostring(length).." nodes"
   list_str=list_str.." with the following attributes: \n"
   for i in ipairs(self.list) do
   --   io.write(i," ",tostring(w));io.write(" ",w:toString())
      list_str=list_str..tostring(i)..": "..self.list[i]:toString().."\n"
   end
   return list_str.."\n"
end



--function that prints out members of the same set
-- need algorithm for this.
-- a naive algorithm that prints all findpaths
-- should suffice for now
-- it seems that the leading reps have rank 1
--   for every node with rank 1 print the edges it belongs to
function disjointset:PrintSets()
   local set_str="here are the disjoint sets: \n"
   local res={}
   print(set_str)
   --for each node
   for i in ipairs(self.list) do
      for j in ipairs(self.list) do
         --add current node to string
         local m = self:FindSet(self.list[j])
         if i == m.data then 
           table.insert(res,j)
         end
      end
      print(table.unpack(res))
      res={}  --reset
   end
end

return disjointset

