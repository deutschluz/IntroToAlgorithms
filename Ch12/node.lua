Node={data,l,r}

function Node:new(d)
  local n={data=d,l=false,r=false}
  setmetatable(n,self)
  self.__index=self
  return n
end

function Node:getData()
  return self.data
end

function Node:toString()
  local data_str="data: "..tostring(self.data).."\n"
  local LandR_str="l: "..tostring(self.l).."; r: "..tostring(self.r).."\n"
  return data_str..LandR_str
end

return Node