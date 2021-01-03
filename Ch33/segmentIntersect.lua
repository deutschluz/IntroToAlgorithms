-- lua implementation of the Segments-Intersect
-- algorithm in the book
dbg=require("debugger")

point={x,y}

function point:new(i,j)
  local p={x=i,y=j}
  setmetatable(p,self)
  self.__index=self
  return p
end

function point:tostring()
  return tostring(self.x)..","..tostring(self.y)
end
local i=1;local j=-1;
local q2=point:new(i,j)
print("defined a point at: ",q2:tostring())

function crossProduct(p,q)
  return p.x*q.y - p.y * q.x
end


function onSegment(pi,pj,pk)
  local min=math.min
  local max=math.max
  if min(pi.x,pj.x) <= pk.x and pk.x<= max(pi.x,pj.x) and min(pi.y,pj.y) <= pk.y and pk.y <= max(pi.y,pj.y) then
     return true
  else return false
  end
end

function direction(pi,pj,pk)
  return  (pj.x-pi.x)*(pk.y-pi.y) - (pk.x - pi.x)*(pj.y - pi.y)
end

function segmentsIntersect(pi,pj,pk,pl)
  local d1= direction(pk,pl,pi)
  local d2= direction(pk,pl,pj)
  local d3= direction(pi,pj,pk)
  local d4= direction(pi,pj,pl)

  if((d1 > 0 and d2 < 0) or (d1 < 0 and d2 > 0)) and
     ((d3>0 and d4<0) or (d3 < 0 and d4)) then
     return true
  elseif d1==0 and onSegment(pk,pl,pi) then
    return true
  elseif d2==0 and onSegment(pk,pl,pj) then
    return true
  elseif d3==0 and onSegment(pi,pj,pk) then
    return true
  elseif d4==0 and onSegment(pi,pj,pl) then
    return true
  else return false
  end
end
i=point:new(1,1)
j=point:new(3,2)
k=point:new(3,0)
l=point:new(0,3)
print("line l1 goes from (1,1) to (3,2)\n")
print("line l2 goes from (3,0) to (0,3)\n")
print("do they intersect?",segmentsIntersect(i,j,k,l))
print("the tangent of 45 degrees is ", math.tan(math.rad(45)))
print("the arctan of 1.0 is",math.deg(math.atan(1)))
function pAngle(p,q)
--  dbg()
  local o=q or point:new(0,0)
  local res=point:new(p.x - o.x,p.y - o.y)
  local radius=math.sqrt(res.x*res.x + res.y*res.y)
  if res.y >= 0  and radius ~= 0 then
    return math.acos(res.x/radius)
  elseif res.y<0 then
    return -math.acos(res.x/radius)
  else return nil
  end
end
local p1=point:new(3,3)
local q1=point:new(2,4)
print("the polar angle of (3,3) is ", math.deg(pAngle(p1)))
print("the polar angle of (3,3) and (2,4) is ",math.deg(pAngle(p1,q1))) 
--function polarSort(list) end
    