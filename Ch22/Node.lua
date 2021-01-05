--parent will be reference to node above. but default is false
--rank is distance from roots
--data is obvious... 
--create single node
Node={
     parent,
     rank,
     data,
     }

function Node:new(x)
   local n={parent=false, rank=0, data=x}
   setmetatable(n,self)
   self.__index=self
   return n
end

function Node:toString()
  local data_str = "data: "..tostring(self.data).."\n"
  local parent_str="parent: "..tostring(self.parent).."\n"
  local rank_str="rank: "..tostring(self.rank).."\n"
  return data_str..parent_str..rank_str.."\n"
end

--function that copies the attributes of the arg to this node
function Node:copy(otherN)
   self.Node.parent=otherN.parent
   self.Node.rank=otherN.rank
   self.Node.data=otherN.data
end
-- function that returns true if this node equals otherN
function Node:equals(otherN)
   return self.Node.parent == otherN.parent and
      self.Node.rank == otherN.rank and
      self.Node.data == otherN.data
end

return Node