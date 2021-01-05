DS=require("disjointset")

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
   self.ds=DS:new(N)  --will hold all nodes
   self.ds:initList(N)
   for k,w in pairs(self.edgelist) do
      local u,v= string.match(w,"(%d+):(%d+)")
      u=tonumber(u); v=tonumber(v)  --cast chars to num
      -- add nodes 
      self.ds:addNodes(u,v);                                   --
   end
   self.ds:PrintSets()
end--conncomps


function dgraph:SameComps(nu,nv)
   local N=self.nverts
   self.ds=DS:new(N)  --will hold all nodes
   self.ds:initList(N)
   for k,w in pairs(self.edgelist) do
      local u,v= string.match(w,"(%d+):(%d+)")
      u=tonumber(u); v=tonumber(v)  --cast chars to num
      -- add nodes 
      self.ds:addNodes(u,v);                                   --
   end

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
