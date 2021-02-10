Node=require("node")

BST={
  root=false
  }

function BST:new()
  b={}
  setmetatable(b,self)
  self.__index=self
  return  b
end

function BST:insert(data)
   local N=Node
   local n=N:new(data)  --create node
   -- if root is null
   if self.root== false then
      --save node to root
      self.root=n
  else
    local curr=self.root
    local parent=false
    while true do
      parent=curr
      if data < curr.data then
        curr=curr.l
        if curr == false then
           parent.l=n
           break;
        end
      else
         curr=curr.r
         if curr == false then
            parent.r=n
            break;
         end
      end
    end
  end
end

function BST:inorder(node)
  if node ~= false then
    self:inorder(node.l)
    io.write(node:getData()," ")
    self:inorder(node.r)
  end
end


function BST:preorder(node)
  if node ~= false then
    io.write(node:getData()," ")
    self:preorder(node.l)
    self:preorder(node.r)
  end
end



function main()
  local num=BST:new()
  num:insert(23)
  num:insert(45)
  num:insert(37)
  num:insert(3)
  num:insert(99)
  num:insert(22)
  print("inorder traversal: \n")
  BST:inorder(num.root)
  print("\n")
  print("preorder traversal: \n")
  BST:preorder(num.root)
end
main()
