dbg=require "debugger"

--a weighted graph implementation
-- it just adds a weight map w: G.E -> N
-- a table is used to implement the map
-- this table 'w_map' contains pairs like this:
--    "vw",n
-- where e={v,w}

wgraph={
   edgelist={}, --list of edges in the form: 1: "2:3"
   v_labels={}, --list of vertex labels in form: 1: a
   edges={},  -- list of strings "vw"
   nedges=0,  --number of edges
   nverts=0,  --number of nodes
   adjlists={}, --list of adjacencylists
   marked={},  --auxiliary table 
   w_map={},  -- map from edges to numbers: "n:m" N
   dist={},  -- aux table for bfs; holds distance calculation
   pred={},  -- aux table for bfs; holds predecessor of each node
   }

function wgraph:new(n) --n is number of nodes
   self.edgelist={}
   self.v_labels={}
   self.w_map={}
   self.edges={}
   self.nedges=0
   self.nverts=n
   self.adjlists={}
   for i=1,n do
      self.adjlists[i]={}
   end
   for i=1,n do
      self.marked[i]=false
   end
   for i=1,n do
      self.dist[i]=false
   end
   for i=1,n do
      self.pred[i]=false
   end
   local wg = {
      self.edgelist,
      self.v_labels,
      self.nedges,
      self.nverts,
      self.adjlists,
      self.marked,
      self.dist,
      self.pred
   }
   setmetatable(wg,self)
   self.__index=self
   return wg
end


--this function:
-- adds two edges to the corresponding adjlists and
-- adds the edge "v:w" to the edge list
-- adds the pair {"v:w",N} to the weight map
function wgraph:addEdgeandWeight(v,w,N)
  local insert=table.insert --built in table function for insertion
  --if the adjlist for v and w do not exist, then exit 
  if not self.adjlists[v] then
     print("this should exist! something's wrong!",v)
     return false
  end
  if not self.adjlists[w] then
     print("this should exist! something's wrong!",w)
     return false
   end
   --add v and w to their respective adjlist
   insert(self.adjlists[v],w); insert(self.adjlists[w],v)
   --add {v,w} to edgelist
   local e=tostring(v)..":"..tostring(w)  --> e="v:w"
   local f=tostring(w)..":"..tostring(v)  --> e="w:v"
   insert(self.edgelist,e);insert(self.edgelist,f);
   --add {v,w},N to weight map
   --create string to represent edge v,w
    self.w_map[e]=N  --> w_map := ["v:w":N]
    self.nedges=self.nedges+1 --increment num of edges
   if self.adjlists[v] == w and self.adjlists[w]== v then
      return true
   else return false
   end
end

function wgraph:toString()
  local n=self.nverts
  local wg_str="the graph contains \n"
  local edge_str= tostring(self.nedges) .. " edges \n"
  local vert_str= tostring(self.nverts) .. " vertexes \n"
  local adjL_str="and the following adjacency lists: \n"
  local w_map_str="with the following weight map:...\n"
  for i=1,n do
    adjL_str= adjL_str .. tostring(i).." : "
    for j=1,n do
      if self.adjlists[i][j] then
        adjL_str=adjL_str .. tostring(self.adjlists[i][j]) ..", "
      end
      if j==n then adjL_str=adjL_str .."\n" end
    end
  end
  -- edge string formatting loop
  edge_str=edge_str.."with the following labels: \n"
  for i=1,#self.edgelist do
    edge_str= edge_str .. tostring(i).." : "
      if self.edgelist[i] then
        edge_str=edge_str .. tostring(self.edgelist[i]) ..", "
      end
      if i==#self.edgelist then edge_str=edge_str .."\n" end
   end
   -- weight map string formatting loop
  for k,v in pairs(self.w_map) do
    w_map_str= w_map_str .. k.." : "..tostring(v)..", "
  end
  w_map_str=w_map_str.."\n"
  wg_str=wg_str..edge_str..w_map_str..vert_str..adjL_str.."\n"
  return wg_str
end


--reads 2 files from given strings with the following format:
-- n m w\n n1 m1 w1\n ...
-- where n,m are edges in the graph
-- the number of vertices has to be known before any processing
-- begins. 
function wgraph:readGraph(fname1,mode1,fname2,mode2)
   --set file handle of first file
   local f1= io.open(fname1,mode1)
   --if f1 is nil 
   if not f1 then print("something's wrong!") return 
   else
      for line in f1:lines() do
         local n,l=string.match(line,"(%d+)%s(%w+)")
         if not (n and l) then goto skip
         else self.v_labels[n]=l
         end
         ::skip::
      end
   end
   local f2=io.open(fname2,mode2)
   if not f2 then print("file reading err!") return
   else
      for line in f2:lines() do
         local u,v,N=string.match(line,"(%d+)%s(%d+)%s(%d+)")
         u=tonumber(u); v=tonumber(v)
         self:addEdgeandWeight(u,v,N)
      end
   end
   return true
end

--
function wgraph:bfs(src)
   local Q={}  --queue
   local enqueue=table.insert --use builtin tablemethod for enqueueing
   local dequeue=table.remove  --use builtin tablemethod for dequ...
                                 --call with remove(Q,1) to rem 1st el
   self.marked[src]=true
   self.dist[src]=0
   self.pred[src]=false  --stays the same from new above
   enqueue(Q,src)
   --while queue is not empty
   while #Q > 0 do
      local u=dequeue(Q,1)
      --for every v in adjlist of u
      for i,v in ipairs(self.adjlists[u]) do
        --if marked is false
        if not self.marked[v] then
	  self.marked[v]=true
	  self.dist[v]=self.dist[u]+1
	  self.pred[v]=u
	  enqueue(Q,v)
	end
      end
    end
end

function wgraph:printBfsPath(src,dst)
  if src == dst then io.write(src," ") 
  elseif not self.pred[dst] then
     print("no path");return
  else 
     wgraph:printBfsPath(src,self.pred[dst]) 
     io.write(dst," ")
  end
  io.write("\n")
end


function main()
  local n=9
  local wg=wgraph:new(n)
  local fname1="wg.lbls";
  local mode1="r"
  local fname2="wg001.dat";
  local mode2="r";
  wg:readGraph(fname1,mode1,fname2,mode2)
  print(wg:toString())
  wg:bfs(1)
  print("the path from 1 to 9 is: ")
  wg:printBfsPath(1,9)
end

main() --start
