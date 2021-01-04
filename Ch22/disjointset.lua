disjointset={
   list={}, --to hold roots of all trees in the forest

-- inner node class for the disjointset forest
   Node ={parent,rank,data}
}

--parent will be reference to node above. but default is false
--rank is distance from roots
--data is obvious... 
--create single node

function disjointset.Node:new(x)
   local n={parent=false, rank=0, data=x}
   setmetatable(n,self)
   self.__index=self
   return n
end

function disjointset.Node:toString()
  local data_str = "data: "..tostring(self.Node.data).."\n"
  local parent_str="parent: "..tostring(self.Node.parent).."\n"
  local rank_str="rank: "..tostring(self.Node.rank).."\n"
  return data_str..parent_str..rank_str.."\n"
end

--function that copies the attributes of the arg to this node
function disjointset.Node:copy(otherN)
   self.Node.parent=otherN.parent
   self.Node.rank=otherN.rank
   self.Node.data=otherN.data
end
-- function that returns true if this node equals otherN
function disjointset.Node:equals(otherN)
   return self.Node.parent == otherN.parent and
      self.Node.rank == otherN.rank and
      self.Node.data == otherN.data
end


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


--function that goes through every find path and
-- makes all nonroots point to roots
function disjointset:CompressPaths()
--   for i in ipairs(self.list) do
      
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


-- graph data structure
dgraph={
   edgelist={},
   nedges=0,nverts=0,adjlists={},marked={},
   dsc={},  -- aux table for dfs; holds discovery calculation
   pred={}, --aux table for dfs; holds predecessor of each node
   fin={}, --aux table for dfs; holds finish time calculation
   v_labels={},
   ds={} -- to hold master list of disjoint sets
}


function dgraph:new(n) --n is number of nodes
  self.ds={}
  self.v_labels={}
  self.nedges=0
  self.nverts=n
  self.adjlists={}
  self.edgelist={} --will contain k,v pairs like: 2,"12"
  for i=1,n do
    self.adjlists[i]={}
  end
  for i=1,n do
     self.marked[i]=false
  end
  for i=1,n do
     self.dsc[i]=false
  end
  for i=1,n do
     self.fin[i]=false
  end
  for i=1,n do
     self.pred[i]=false
  end
  local dg = {
    self.edgelist,
    self.nedges,
    self.nverts,
    self.adjlists,
    self.marked,
    self.pred,
    self.dsc,
    self.fin,
    self.v_labels,
    self.ds
  }
  setmetatable(dg,self)
  self.__index=self
  return dg
end
 
function dgraph:addEdge(v,w)
  local insert=table.insert --built in table function for insertion
  --if the adjlist for v and w do not exist, then exit 
  if not self.adjlists[v] then
     print("this should exist! something's wrong!")
     return false
  end
  if not self.adjlists[w] then
     print("this should exist! something's wrong!")
     return false
   end
   --add v and w to their respective adjlist
   insert(self.adjlists[v],w);insert(self.adjlists[w],v)
   --create string representing edge (v,w)
   local e=tostring(v)..":"..tostring(w)  --> e="v:w"
   local f=tostring(w)..":"..tostring(v)  --> e="w:v"
   insert(self.edgelist,e); insert(self.edgelist,f)
   --increment num of edges
   self.nedges=self.nedges+1 
   if self.adjlists[v] == w or self.adjlists[w]== v then
      return true
   else return false
   end
end

function dgraph:toString()
  local n=self.nverts
  local dg_str="the graph contains \n"
  local edge_str= tostring(self.nedges) .. " edges \n"
  local vert_str= tostring(self.nverts) .. " vertexes \n"
  local adjL_str="and the following adjacency lists: \n"
  for i=1,n do
    adjL_str= adjL_str .. tostring(i).." "
    for j=1,n do
      if self.adjlists[i][j] then
        adjL_str=adjL_str .. tostring(self.adjlists[i][j]) .." "
      end
      if j==n then adjL_str=adjL_str .."\n" end
    end
  end
  -- edge string formatting loop
  local len=#self.edgelist
  edge_str=edge_str.."with the following labels: \n"
  for i=1,len do
    edge_str= edge_str .. tostring(i).." : "
      if self.edgelist[i] then
        edge_str=edge_str .. tostring(self.edgelist[i]) ..", "
      end
      if i==self.nedges then edge_str=edge_str .."\n" end
   end
  vert_str=vert_str.."with the following v labels: \n"
  for k,v in pairs(self.v_labels) do
     vert_str=vert_str..tostring(k).." "..tostring(v).."; "
  end
  vert_str=vert_str.."\n"
  dg_str=dg_str..edge_str..vert_str..adjL_str
  return dg_str
end

--reads 2 files; the first with the following format:
-- n m \n n m \n ...
-- where n,m are edges in the graph
-- the second file has format
--  n l\n where n is num and l is letter
-- the number of vertices has to be known before any processing
-- begins.
function dgraph:readGraph(fname1,mode1,fname2,mode2)
   --set file handle of first file
   local err= io.open(fname1,mode1)
   --if err is nil 
   if not err then print("something's wrong!") return 
   else
      for line in err:lines() do
         local n,l=string.match(line,"(%d+)%s(%w+)")
         if not (n and l) then goto skip
         else self.v_labels[n]=l
         end
         ::skip::
      end
   end
   local f=io.open(fname2,mode2)
   if not f then print("file reading err!") return
   else
      for line in f:lines() do
         local u,v=string.match(line,"(%d+)%s(%d+)")
         u=tonumber(u); v=tonumber(v)
         self:addEdge(u,v)
      end
   end
   
  return true
end



-- function that use the disjoint set data structure
-- to compute the Connected components of the graph
function dgraph:ConnComps()
   local N=self.nverts
   self.ds=disjointset:new(N)  --will hold all nodes
   self.ds:initList(N)
   for k,w in pairs(self.edgelist) do
      local u,v= string.match(w,"(%d+):(%d+)")
      u=tonumber(u); v=tonumber(v)  --cast chars to num
      -- add nodes 
      self.ds:addNodes(u,v);                                   --
   end
   self.ds:PrintSets()
end--conncomps


function dgraph:SameComps(ds,nu,nv)
      return self.ds:FindSet(u) == self.ds:FindSet(v)
end


function main()
   local n=10 -- number of nodes in graph
   local g=dgraph:new(n)
   local f2="g001.dat"
   local mode2="r"
   local f1="g001.lbls"
   local mode1="r"
   g:readGraph(f1,mode2,f2,mode1)
   print(g:toString())
   g:ConnComps()
   
end

main() --start
