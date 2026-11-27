--!nonstrict
-- Moy X Hub | +1 Power Fruit Evolution
-- Consolidated release. Original UI: Moy X Hub.
-- Farming controls require the separately running Tora IsMe script in this session.
-- Tora source was obfuscated and is not included or auto-executed by this file.
-- Third-party source reference: https://raw.githubusercontent.com/gumanba/Scripts/main/1PowerFruitEvolution
-- Auto Sell All sells all eligible seeds. All Moy-added automatic systems start OFF.
-- Auto Upgrade still uses normal on-screen purchase input; Index and Sell use callbacks.
-- Runtime and mobile gameplay have not been fully verified.
if not game:IsLoaded() then game.Loaded:Wait() end
if game.PlaceId~=109238145423218 and game.GameId~=10767749891 then
    warn("Moy X Hub: this release is for +1 Power Fruit Evolution")
    return
end
local function install(name,fn)
    local ok,result=pcall(fn)
    if not ok then warn("[Moy X Hub] "..name..": "..tostring(result)) end
    return ok,result
end
local ok,controller=install("Dashboard",function()
--!nonstrict
-- MoyXHub | Dashboard UI concept 01
-- Standalone LocalScript. Original interface inspired by the four supplied reference images.
-- Dashboard with opt-in normal movement and loot collection; no remote calls or spending.
-- Install in StarterPlayerScripts for a Roblox Studio preview.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local Tween=game:GetService("TweenService")
local Run=game:GetService("RunService")
local Stats=game:GetService("Stats")
local P=Players.LocalPlayer
local parent=P:WaitForChild("PlayerGui")
local existing=parent:FindFirstChild("MoyXHub_Dashboard")
if existing then existing:Destroy() end
local theme={
    Background=Color3.fromRGB(19,16,21),
    Sidebar=Color3.fromRGB(30,24,33),
    Section=Color3.fromRGB(25,21,29),
    Header=Color3.fromRGB(23,19,26),
    Outline=Color3.fromRGB(47,39,52),
    Element=Color3.fromRGB(42,35,46),
    Input=Color3.fromRGB(21,17,24),
    Text=Color3.fromRGB(240,233,244),
    Muted=Color3.fromRGB(153,139,161),
    Accent=Color3.fromRGB(222,177,246)
}
local bindings={}
local function obj(class,holder,props)
    local v=Instance.new(class)
    for k,x in pairs(props or {}) do v[k]=x end
    v.Parent=holder
    return v
end
local function themed(v,prop,key)
    v[prop]=theme[key];table.insert(bindings,{v,prop,key});return v
end
local function corner(v,r) obj("UICorner",v,{CornerRadius=UDim.new(0,r or 6)}) end
local function stroke(v)
    -- Border mode keeps outlines off the text glyphs of TextButtons/TextBoxes.
    themed(obj("UIStroke",v,{Thickness=1,Transparency=.1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,LineJoinMode=Enum.LineJoinMode.Round}),"Color","Outline")
end
local function layout(v,gap,direction)
    return obj("UIListLayout",v,{Padding=UDim.new(0,gap or 6),SortOrder=Enum.SortOrder.LayoutOrder,FillDirection=direction or Enum.FillDirection.Vertical})
end
local function pad(v,l,t,r,b) obj("UIPadding",v,{PaddingLeft=UDim.new(0,l),PaddingTop=UDim.new(0,t),PaddingRight=UDim.new(0,r or l),PaddingBottom=UDim.new(0,b or t)}) end
local function frame(holder,props,key)
    local v=obj("Frame",holder,props);v.BorderSizePixel=0
    if key then themed(v,"BackgroundColor3",key) else v.BackgroundTransparency=1 end
    return v
end
local function readableSize(n)
    local sizes={[10]=12,[11]=14,[12]=14,[13]=15,[15]=17,[17]=19,[18]=19,[21]=23,[27]=30}
    return sizes[n] or n
end
local function label(holder,txt,size,props,key)
    local v=obj("TextLabel",holder,{BackgroundTransparency=1,Text=txt,Font=Enum.Font.SourceSansSemibold,TextSize=readableSize(size or 12),TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,BorderSizePixel=0})
    for k,x in pairs(props or {}) do v[k]=k=="TextSize" and readableSize(x) or x end
    return themed(v,"TextColor3",key or "Text")
end
local function button(holder,txt,props,key)
    local v=obj("TextButton",holder,{BorderSizePixel=0,AutoButtonColor=false,Text=txt,Font=Enum.Font.SourceSansSemibold,TextSize=14})
    for k,x in pairs(props or {}) do v[k]=k=="TextSize" and readableSize(x) or x end
    themed(v,"BackgroundColor3",key or "Element");themed(v,"TextColor3","Text");corner(v,6)
    return v
end
local function animate(v,p,time) Tween:Create(v,TweenInfo.new(time or .16,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),p):Play() end
local gui=obj("ScreenGui",parent,{Name="MoyXHub_Dashboard",ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=80,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
local window=frame(gui,{Name="Window",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(780,610),ClipsDescendants=true},"Background");corner(window,12);stroke(window)
local scale=obj("UIScale",window,{Scale=1})
-- Rounded root corners are not a true rounded mask in Roblox.
-- Draw a rounded sidebar with a square right-hand seam inside the root.
local sidebar=frame(window,{Size=UDim2.new(0,112,1,0)},"Sidebar")
corner(sidebar,12)
local seam=frame(sidebar,{Name="SidebarSeam",Position=UDim2.new(1,-13,0,0),Size=UDim2.new(0,13,1,0)},"Sidebar")
-- Moy monogram: editable native geometry, based on the brand's angular M/H.
local function moyMark(holder,position,factor)
    local mark=frame(holder,{Name="MoyMonogram",AnchorPoint=Vector2.new(.5,.5),Position=position,Size=UDim2.fromOffset(68,60)})
    obj("UIScale",mark,{Scale=factor or 1})
    local function segment(x1,y1,x2,y2,width,color,z)
        local dx,dy=x2-x1,y2-y1
        local v=frame(mark,{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromOffset((x1+x2)/2,(y1+y2)/2),Size=UDim2.fromOffset(math.sqrt(dx*dx+dy*dy)+width*.4,width),Rotation=math.deg(math.atan2(dy,dx)),ZIndex=z or 2})
        if typeof(color)=="Color3" then v.BackgroundTransparency=0;v.BackgroundColor3=color else v.BackgroundTransparency=0;themed(v,"BackgroundColor3",color) end
        return v
    end
    local lavender=Color3.fromRGB(229,205,246)
    -- Fine shield outline and angular white M above the purple H.
    local outline={{5,16,34,3},{34,3,63,16},{63,16,59,43},{59,43,34,57},{34,57,9,43},{9,43,5,16}}
    for _,p in ipairs(outline) do local v=segment(p[1],p[2],p[3],p[4],1.5,"Accent",2);v.BackgroundTransparency=.62 end
    segment(14,37,19,17,7,lavender,4)
    segment(19,17,34,29,7,lavender,4)
    segment(34,29,52,14,7,lavender,4)
    segment(52,14,47,34,7,lavender,4)
    segment(26,48,30,31,6,"Accent",5)
    segment(43,47,47,31,6,"Accent",5)
    segment(28,40,45,35,6,"Accent",5)
    return mark
end
local logo=moyMark(sidebar,UDim2.new(.5,0,0,42),.92)
local nav=frame(sidebar,{Position=UDim2.fromOffset(10,83),Size=UDim2.new(1,-20,1,-164)})
layout(nav,10)
local body=frame(window,{Position=UDim2.fromOffset(112,0),Size=UDim2.new(1,-112,1,0)})
local header=frame(body,{Size=UDim2.new(1,0,0,56)})
local title=label(header,"Home",18,{Position=UDim2.fromOffset(16,0),Size=UDim2.new(1,-245,1,0),Font=Enum.Font.SourceSansBold})
local search=obj("TextBox",header,{Position=UDim2.new(1,-202,0,14),Size=UDim2.fromOffset(156,28),BorderSizePixel=0,ClearTextOnFocus=false,Text="",PlaceholderText="ค้นหาเมนู...",Font=Enum.Font.SourceSans,TextSize=14})
themed(search,"BackgroundColor3","Input");themed(search,"TextColor3","Text");themed(search,"PlaceholderColor3","Muted");corner(search,6);stroke(search);pad(search,8,0)
local hide=button(header,"–",{Position=UDim2.new(1,-36,0,14),Size=UDim2.fromOffset(26,28)})
local status=label(body,"MoyXHub  •  UI Preview",{ } and 10,{Position=UDim2.new(0,14,1,-24),Size=UDim2.new(1,-28,0,18)},"Muted")
local function say(s) status.Text=tostring(s) end
local orb=button(gui,"",{Name="MoyOpen",Visible=false,Position=UDim2.new(0,18,.5,-22),Size=UDim2.fromOffset(46,46)},"Sidebar");stroke(orb)
moyMark(orb,UDim2.fromScale(.5,.5),.57)
local function visible(on) window.Visible=on;orb.Visible=not on end
hide.Activated:Connect(function() visible(false) end);orb.Activated:Connect(function() visible(true) end)
local key=Enum.KeyCode.LeftAlt
local connections={}
local function connect(signal,fn) local c=signal:Connect(fn);table.insert(connections,c);return c end
connect(UIS.InputBegan,function(i,processed) if not processed and not UIS:GetFocusedTextBox() and i.KeyCode==key then visible(not window.Visible) end end)
local dragging,dragStart,startPos=false,nil,nil
local requestedScale=1
local function clampCenter(x,y)
    local cam=workspace.CurrentCamera
    if not cam then return end
    local v=cam.ViewportSize
    local hw,hh=780*scale.Scale/2,610*scale.Scale/2
    local minX,maxX=hw+10,v.X-hw-10
    local minY,maxY=hh+10,v.Y-hh-10
    x=if maxX>=minX then math.clamp(x,minX,maxX) else v.X/2
    y=if maxY>=minY then math.clamp(y,minY,maxY) else v.Y/2
    -- Snap the visible top-left to the physical pixel grid.
    window.Position=UDim2.fromOffset(math.round(x-hw)+hw,math.round(y-hh)+hh)
end
local function center()
    local v=workspace.CurrentCamera.ViewportSize
    local p=window.Position
    return Vector2.new(p.X.Scale*v.X+p.X.Offset,p.Y.Scale*v.Y+p.Y.Offset)
end
title.Active=true
title.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragging=true;dragStart=i.Position;startPos=center()
    end
end)
connect(UIS.InputEnded,function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
connect(UIS.InputChanged,function(i)
    if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d=i.Position-dragStart;clampCenter(startPos.X+d.X,startPos.Y+d.Y)
    end
end)
local function fit()
    local cam=workspace.CurrentCamera
    if not cam then return end
    local v=cam.ViewportSize
    local available=math.min(requestedScale,(v.X-20)/780,(v.Y-20)/610)
    scale.Scale=math.max(.25,math.floor(available*100+1e-6)/100)
    local p=center();clampCenter(p.X,p.Y)
end
if workspace.CurrentCamera then connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"),fit) end;fit()
local avatar=obj("ImageLabel",sidebar,{AnchorPoint=Vector2.new(.5,1),Position=UDim2.new(.5,0,1,-34),Size=UDim2.fromOffset(39,39),BackgroundTransparency=1});corner(avatar,40);stroke(avatar)
local playerName=label(sidebar,P.DisplayName,11,{Position=UDim2.new(0,5,1,-30),Size=UDim2.new(1,-10,0,18),TextXAlignment=Enum.TextXAlignment.Center})
task.spawn(function() local ok,url=pcall(function() return Players:GetUserThumbnailAsync(P.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) end);if ok and avatar.Parent then avatar.Image=url end end)
-- Small native geometry icons: no unsupported Unicode glyphs or external assets.
local function icon(holder,kind)
    local root=frame(holder,{Name="NavIcon",AnchorPoint=Vector2.new(.5,0),Position=UDim2.new(.5,0,0,10),Size=UDim2.fromOffset(25,25)})
    local parts={}
    local function line(x,y,w,h,rot)
        local a=frame(root,{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),Rotation=rot or 0},"Muted")
        corner(a,2);table.insert(parts,{a,"BackgroundColor3"});return a
    end
    local function ring(x,y,w,h,r)
        local a=frame(root,{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h)})
        corner(a,r or 3)
        local st=themed(obj("UIStroke",a,{Thickness=2.3}),"Color","Muted");table.insert(parts,{st,"Color"})
        return a
    end
    if kind=="Home" then
        line(8,8,12,2.6,-42);line(17,8,12,2.6,42)
        line(5,16,2.6,12);line(20,16,2.6,12);line(12.5,22,17,2.6)
        line(10,18,2.2,8);line(15,18,2.2,8);line(12.5,14.3,6,2.2)
    elseif kind=="Farm" then
        line(12,12,25,3,45);line(12,12,25,3,-45)
        line(17,18,9,2.5,-45);line(8,18,9,2.5,45)
        line(21,21,5,3,45);line(4,21,5,3,-45)
    elseif kind=="Account" then
        ring(8,2,9,9,9);ring(3,14,19,10,5)
    else
        ring(6,6,13,13,13);ring(10,10,5,5,5)
        for i=0,7 do local angle=i*math.pi/4;line(12.5+math.cos(angle)*9.5,12.5+math.sin(angle)*9.5,5,3,i*45) end
    end
    return parts
end
local pages,navButtons,searchRows={},{},{}
local navIcons,navLabels={},{} 
local current="Home"
local function filter()
    local q=string.lower(search.Text)
    for _,r in ipairs(searchRows) do r.Row.Visible=q=="" or string.find(string.lower(r.Name),q,1,true)~=nil end
end
search:GetPropertyChangedSignal("Text"):Connect(filter)
local function show(name)
    current=name;title.Text=({Home="Home  /  ภาพรวม",Farm="Farm  /  ระบบฟาร์ม",Account="Account  /  จัดการบัญชี",Settings="Settings  /  การตั้งค่า"})[name]
    for k,v in pairs(pages) do v.Visible=k==name end
    for k,v in pairs(navButtons) do
        local col=k==name and theme.Accent or theme.Muted
        v.BackgroundTransparency=k==name and 0 or 1
        navLabels[k].TextColor3=col
        for _,p in ipairs(navIcons[k]) do p[1][p[2]]=col end
    end
    search.Text="";filter()
end
local function page(name,mark)
    local n=button(nav,"",{Size=UDim2.new(1,0,0,66),BackgroundTransparency=1});navButtons[name]=n
    navIcons[name]=icon(n,name)
    navLabels[name]=label(n,name,13,{Position=UDim2.fromOffset(0,37),Size=UDim2.new(1,0,0,20),TextXAlignment=Enum.TextXAlignment.Center},"Muted")
    n.Activated:Connect(function() show(name) end)
    local p=obj("ScrollingFrame",body,{Name=name,Position=UDim2.fromOffset(13,56),Size=UDim2.new(1,-26,1,-84),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.fromOffset(0,0),Visible=false,ScrollingDirection=Enum.ScrollingDirection.Y});themed(p,"ScrollBarImageColor3","Outline");pad(p,1,2,3,5)
    pages[name]=p
    return p
end
local home=page("Home","⌂")
local farm=page("Farm","✦")
local account=page("Account","♙")
local settings=page("Settings","⚙")
local state={}
local callbacks={}
-- UI state can later be connected using controller:SetCallback("farm.auto", function(value) ... end).
local controller={}
function controller:SetCallback(id,fn) callbacks[id]=fn end
function controller:GetState() return table.clone(state) end
local function change(id,v)
    state[id]=v
    local cb=callbacks[id]
    if cb then local ok,err=pcall(cb,v);if not ok then say("ผิดพลาด: "..tostring(err)) end
    else say(id.."  •  ตัวอย่าง UI เท่านั้น") end
end
local function columns(p)
    local wrap=frame(p,{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y})
    local l=frame(wrap,{Size=UDim2.new(.5,-5,0,0),AutomaticSize=Enum.AutomaticSize.Y})
    local r=frame(wrap,{Position=UDim2.new(.5,5,0,0),Size=UDim2.new(.5,-5,0,0),AutomaticSize=Enum.AutomaticSize.Y})
    local horizontal=layout(wrap,10,Enum.FillDirection.Horizontal);horizontal.VerticalAlignment=Enum.VerticalAlignment.Top
    layout(l,10);layout(r,10);return l,r
end
local function section(col,name,icon)
    local box=frame(col,{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y},"Section");corner(box,7);stroke(box);layout(box,0)
    local h=button(box,name,{Size=UDim2.new(1,0,0,34),TextXAlignment=Enum.TextXAlignment.Left,TextSize=13},"Header");pad(h,11,0)
    local fold=frame(h,{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-2,.5,0),Size=UDim2.fromOffset(10,2.5)},"Accent");corner(fold,2)
    local vertical=frame(h,{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-5.75,.5,0),Size=UDim2.fromOffset(2.5,10),Visible=false},"Accent");corner(vertical,2)
    local inner=frame(box,{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y});layout(inner,5);pad(inner,10,8,10,10)
    h.Activated:Connect(function() inner.Visible=not inner.Visible;vertical.Visible=not inner.Visible end)
    return inner
end
local function row(s,name,height)
    local r=frame(s,{Size=UDim2.new(1,0,0,height or 28)})
    table.insert(searchRows,{Row=r,Name=name})
    return r
end
local function toggle(s,name,id,default)
    local r=row(s,name);label(r,name,11,{Size=UDim2.new(1,-47,1,0)})
    local b=button(r,"",{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,0,.5,0),Size=UDim2.fromOffset(35,18)})
    corner(b,20)
    local knob=frame(b,{AnchorPoint=Vector2.new(0,.5),Size=UDim2.fromOffset(13,13),Position=UDim2.new(0,3,.5,0)},"Text");corner(knob,20)
    state[id]=default==true
    local function render()
        animate(b,{BackgroundColor3=state[id] and theme.Accent or theme.Element})
        animate(knob,{Position=UDim2.new(0,state[id] and 19 or 3,.5,0),BackgroundColor3=state[id] and theme.Background or theme.Text})
    end
    b.Activated:Connect(function() change(id,not state[id]);render() end);render()
end
local function dropdown(s,name,id,options,default)
    local r=row(s,name,28)
    label(r,name,11,{Size=UDim2.new(.51,0,0,26)})
    local b=button(r,"",{Position=UDim2.new(.52,0,0,2),Size=UDim2.new(.48,0,0,24),TextSize=11},"Input");stroke(b)
    local list=frame(r,{Position=UDim2.fromOffset(0,30),Size=UDim2.new(1,0,0,#options*26+5),Visible=false},"Header");corner(list,5);stroke(list);layout(list,2);pad(list,4,3)
    local chevron=frame(b,{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,-6,.5,0),Size=UDim2.fromOffset(10,10)})
    for i=1,2 do
        local line=frame(chevron,{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromOffset(i==1 and 3.5 or 7,5),Size=UDim2.fromOffset(6,1.7),Rotation=i==1 and 42 or -42},"Muted");corner(line,2)
    end
    pad(b,5,0,17,0);b.TextXAlignment=Enum.TextXAlignment.Left;b.TextTruncate=Enum.TextTruncate.AtEnd
    state[id]=default or options[1];local function render() b.Text=tostring(state[id]) end
    local function close() list.Visible=false;r.Size=UDim2.new(1,0,0,28) end
    for _,opt in ipairs(options) do
        local x=button(list,opt,{Size=UDim2.new(1,0,0,23),TextSize=10});x.Activated:Connect(function()change(id,opt);render();close()end)
    end
    b.Activated:Connect(function() if list.Visible then close() else list.Visible=true;r.Size=UDim2.new(1,0,0,35+#options*26) end end);render()
end
local function action(s,name,id)
    local r=row(s,name,28);local b=button(r,name,{Size=UDim2.fromScale(1,1),TextSize=11})
    b.Activated:Connect(function() change(id,true) end);return b
end
local function input(s,name,id,hint,initial)
    local r=row(s,name);label(r,name,11,{Size=UDim2.new(.46,0,1,0)})
    local x=obj("TextBox",r,{Position=UDim2.new(.48,0,0,2),Size=UDim2.new(.52,0,0,24),BorderSizePixel=0,Text=initial or "",PlaceholderText=hint or "",ClearTextOnFocus=false,Font=Enum.Font.SourceSans,TextSize=14});corner(x,5);themed(x,"BackgroundColor3","Input");themed(x,"TextColor3","Text");themed(x,"PlaceholderColor3","Muted");state[id]=x.Text;x.FocusLost:Connect(function()change(id,x.Text)end)
end
local function slider(s,name,id,min,max,default)
    local r=row(s,name,42);local t=label(r,name,11,{Size=UDim2.new(1,0,0,20)})
    local track=button(r,"",{Position=UDim2.fromOffset(0,26),Size=UDim2.new(1,0,0,8)},"Input");local fill=frame(track,{Size=UDim2.fromScale(0,1)},"Accent");corner(fill,5)
    state[id]=default
    local function render() fill.Size=UDim2.fromScale((state[id]-min)/(max-min),1);t.Text=name.."  •  "..tostring(state[id]) end
    local active=false
    local function update(px) change(id,math.floor(min+math.clamp((px-track.AbsolutePosition.X)/math.max(1,track.AbsoluteSize.X),0,1)*(max-min)+.5));render() end
    track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then active=true;update(i.Position.X) end end)
    connect(UIS.InputChanged,function(i) if active and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then update(i.Position.X) end end)
    connect(UIS.InputEnded,function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then active=false end end);render()
end
-- HOME
layout(home,10)
local profile=frame(home,{Size=UDim2.new(1,0,0,96)},"Section");corner(profile,8);stroke(profile)
local portrait=obj("ImageLabel",profile,{Position=UDim2.fromOffset(15,15),Size=UDim2.fromOffset(66,66),BackgroundTransparency=1});corner(portrait,40);stroke(portrait)
task.spawn(function() local ok,url=pcall(function() return Players:GetUserThumbnailAsync(P.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150) end);if ok and portrait.Parent then portrait.Image=url end end)
label(profile,"ยินดีต้อนรับกลับมา",11,{Position=UDim2.fromOffset(93,14),Size=UDim2.new(1,-200,0,18)},"Muted")
label(profile,P.DisplayName,21,{Position=UDim2.fromOffset(93,32),Size=UDim2.new(1,-190,0,30),Font=Enum.Font.SourceSansBold})
label(profile,"@"..P.Name,11,{Position=UDim2.fromOffset(93,65),Size=UDim2.new(1,-190,0,17)},"Muted")
local chip=label(profile,"MOY  •  PREVIEW",10,{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-14,0,16),Size=UDim2.fromOffset(110,28),TextXAlignment=Enum.TextXAlignment.Center},"Accent")
local statsRow=frame(home,{Size=UDim2.new(1,0,0,65)});layout(statsRow,5,Enum.FillDirection.Horizontal)
local metrics={}
for _,name in ipairs({"Players","Session","FPS","Ping","Place","UI"}) do
    local card=frame(statsRow,{Size=UDim2.new(1/6,-5,1,0)},"Section");corner(card,6);stroke(card)
    label(card,name,10,{Position=UDim2.fromOffset(8,8),Size=UDim2.new(1,-16,0,17)},"Muted")
    metrics[name]=label(card,"—",15,{Position=UDim2.fromOffset(8,28),Size=UDim2.new(1,-16,0,27),Font=Enum.Font.SourceSansBold})
end
local info=frame(home,{Size=UDim2.new(1,0,0,142)},"Section");corner(info,7);stroke(info);pad(info,12,9);layout(info,5)
label(info,"ข้อมูลเกมและเซิร์ฟเวอร์",13,{Size=UDim2.new(1,0,0,22)},"Accent")
label(info,"Place  "..tostring(game.PlaceId).."    |    Universe  "..tostring(game.GameId),11,{Size=UDim2.new(1,0,0,20)},"Muted")
label(info,"Job  "..(game.JobId~="" and game.JobId or "Studio"),11,{Size=UDim2.new(1,0,0,20)},"Muted")
local ir=frame(info,{Size=UDim2.new(1,0,0,26)});layout(ir,6,Enum.FillDirection.Horizontal)
for _,n in ipairs({"Rejoin","Server Hop","Join Lowest Server"}) do local b=button(ir,n,{Size=UDim2.new(1/3,-4,1,0),TextSize=10});b.Activated:Connect(function()change("home."..n,true)end) end
local about=section(home,"MoyXHub  •  สถานะ UI","◆");label(about,"ต้นแบบ Dashboard • ใช้งานได้โดยไม่โหลดโค้ดภายนอก",11,{Size=UDim2.new(1,0,0,28)},"Muted")
-- FARM: native Moy controls connected to the existing session's callbacks.
layout(farm,10)
local tools=section(farm,"ระบบฟาร์ม +1 Power Fruit","")
local notice=label(tools,"กำลังตรวจสอบการเชื่อมต่อ",11,{Size=UDim2.new(1,0,0,34),TextWrapped=true},"Muted")
local tora=game:GetService("CoreGui"):FindFirstChild("ToraScript")
local restoreTora=function()end
local function findText(s)
    if not tora then return nil end
    for _,v in ipairs(tora:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text:lower():find(s,1,true) then return v end
    end
    return nil
end
local function callback(v,name)
    if not v then return nil end
    local ok,cs=pcall(function()return getconnections(v[name])end)
    if not ok or #cs~=1 then return nil end
    local f=cs[1].Function
    return type(f)=="function" and f or nil
end
local function invoke(f,...)
    if not f or not tora or not tora.Parent then say("ไม่พบ Callback ของสคริปต์เดิม");return end
    local ok,err=pcall(f,...)
    if not ok then say("Callback ผิดพลาด: "..tostring(err)) end
end
if tora and tora:IsA("ScreenGui") then
    local originalEnabled=tora.Enabled
    tora.Enabled=false
    restoreTora=function() if tora.Parent then tora.Enabled=originalEnabled end end
    gui.Destroying:Connect(restoreTora)
    notice.Text="ปุ่ม Moy X Hub • เชื่อมกับสคริปต์เดิมในเซสชันนี้"
else
    notice.Text="ไม่พบสคริปต์ Tora ที่กำลังรัน • ยังใช้งานฟังก์ชันไม่ได้"
end
local stageLabel=findText("stage farm")
local oldBox=stageLabel and stageLabel.Parent:FindFirstChildWhichIsA("TextBox")
local stageFn=callback(oldBox,"FocusLost")
local stageRow=row(tools,"เลือกด่านฟาร์ม",40)
label(stageRow,"เลือกด่านฟาร์ม",12,{Size=UDim2.new(.48,0,1,0)})
local stageInput=obj("TextBox",stageRow,{Position=UDim2.new(.5,0,0,5),Size=UDim2.new(.5,0,0,30),BorderSizePixel=0,Text=oldBox and oldBox.Text or "",PlaceholderText="กรอกด่าน",ClearTextOnFocus=false,TextEditable=stageFn~=nil,Font=Enum.Font.SourceSans,TextSize=16})
themed(stageInput,"BackgroundColor3","Input");themed(stageInput,"TextColor3","Text");themed(stageInput,"PlaceholderColor3","Muted");corner(stageInput,6);stroke(stageInput)
stageInput.FocusLost:Connect(function(enter,inputObject)
    if oldBox and oldBox.Parent and stageFn then
        oldBox.Text=stageInput.Text
        invoke(stageFn,enter,inputObject)
    end
end)
local count=0
for _,entry in ipairs({{"auto stage","ฟาร์มด่านอัตโนมัติ"},{"insta kill","กำจัดทันที (HP < 80%)"},{"fast train","ฝึกพลังรวดเร็ว"},{"auto rebirth","เกิดใหม่อัตโนมัติ"}}) do
    local old=findText(entry[1])
    local beginFn=callback(old,"InputBegan")
    local endFn=callback(old,"InputEnded")
    local ready=beginFn~=nil and endFn~=nil
    local r=row(tools,entry[2],44)
    label(r,entry[2],12,{Size=UDim2.new(1,-130,1,0)})
    local b=button(r,ready and "เชื่อมแล้ว" or "ไม่พร้อม",{AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,0,.5,0),Size=UDim2.fromOffset(110,30),TextSize=12})
    b.Active=ready
    if ready then count+=1 end
    local indicator=nil
    if old then
        for _,v in ipairs(old:GetDescendants()) do
            if v:IsA("Frame") and v.Parent and v.Parent:IsA("ImageLabel") then indicator=v;break end
        end
    end
    local function refresh()
        if not ready then return end
        if indicator and indicator.Parent then
            local on=indicator.Size.X.Scale>0 or indicator.Size.X.Offset>0
            b.Text=on and "เปิด" or "ปิด"
            b.BackgroundColor3=on and theme.Accent or theme.Element
            b.TextColor3=on and theme.Background or theme.Text
        else b.Text="เชื่อมแล้ว" end
    end
    local function pointer(i) return i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch end
    if ready then
        b.InputBegan:Connect(function(i) if pointer(i) then invoke(beginFn,i) end end)
        b.InputEnded:Connect(function(i) if pointer(i) then invoke(endFn,i);refresh() end end)
        if indicator then connect(indicator:GetPropertyChangedSignal("Size"),refresh) end
        refresh()
    end
end
label(tools,"Callback ที่พบ: "..count.."/4 • ช่องด่าน: "..(stageFn and "เชื่อมแล้ว" or "ไม่พร้อม"),11,{Size=UDim2.new(1,0,0,30),TextWrapped=true},"Muted")
label(tools,"ต้องให้สคริปต์ต้นฉบับทำงานในเซสชันเดิม • ยังไม่ได้ยืนยันผล Gameplay",10,{Size=UDim2.new(1,0,0,34),TextWrapped=true},"Muted")
-- ACCOUNT
local al,ar=columns(account)
local a1=section(al,"รับรางวัล","◆")
toggle(a1,"รับเควสต์","claims.quests",false);toggle(a1,"รับรางวัลรายวัน","claims.daily",false);toggle(a1,"รับ Battle Pass","claims.pass",false);toggle(a1,"รับ Milestones และ Index","claims.index",false);action(a1,"รับโค้ด","claims.codes")
local a2=section(al,"จัดทีม","♙")
toggle(a2,"จัดทีมที่ดีที่สุด","team.best",false);toggle(a2,"เพิ่มเลเวลตัวละคร","team.feed",false)
local a3=section(ar,"สุ่มตัวละคร","✧")
toggle(a3,"สุ่มอัตโนมัติ","summon.auto",false);dropdown(a3,"ตู้สุ่ม","summon.banner",{"EventClover","Standard"},"EventClover");slider(a3,"เพชรขั้นต่ำ","summon.reserve",0,50000,0);dropdown(a3,"ขายอัตโนมัติ","summon.sell",{"None","Rare","Epic"},"None")
local a4=section(ar,"ร้านค้า","▣")
dropdown(a4,"ร้านทอง","shop.gold",{"None","เลือกเอง"},"None");dropdown(a4,"ร้านกิจกรรม","shop.event",{"Off","เลือกเอง"},"Off");toggle(a4,"ซื้อร้านค้าเร่","shop.merchant",false)
-- SETTINGS
local sl,sr=columns(settings)
local s1=section(sl,"เมนู","⚙")
local r=row(s1,"Menu Keybind");label(r,"ปุ่มเปิด–ปิด",11,{Size=UDim2.new(.55,0,1,0)})
local kb=button(r,"LeftAlt",{Position=UDim2.new(.55,0,0,2),Size=UDim2.new(.45,0,0,24)})
local listening=false
kb.Activated:Connect(function() listening=true;kb.Text="กดปุ่ม..." end)
connect(UIS.InputBegan,function(i,processed) if listening and not processed and i.KeyCode~=Enum.KeyCode.Unknown then key=i.KeyCode;listening=false;kb.Text=key.Name;visible(true) end end)
slider(s1,"ขนาดเมนู (%)","ui.scale",70,120,100)
controller:SetCallback("ui.scale",function(v) requestedScale=v/100;fit() end)
local palettes={Color3.fromRGB(222,177,246),Color3.fromRGB(117,209,241),Color3.fromRGB(185,155,255),Color3.fromRGB(248,177,199)}
local function repaint()
    for _,b in ipairs(bindings) do if b[1].Parent then b[1][b[2]]=theme[b[3]] end end;show(current)
end
for _,n in ipairs({"Accent","Background","Sidebar","Section","Header","Outline","Element","Text","Muted"}) do
    local rr=row(s1,n)
    label(rr,n,11,{Size=UDim2.new(.72,0,1,0)})
    local sw=button(rr,"",{Position=UDim2.new(1,-33,0,5),Size=UDim2.fromOffset(33,18)});themed(sw,"BackgroundColor3",n)
    local j=0
    sw.Activated:Connect(function() j=j%#palettes+1;theme[n]=palettes[j];repaint() end)
end
action(s1,"Unload UI","ui.unload")
controller:SetCallback("ui.unload",function()gui:Destroy()end)
local s2=section(sr,"Configs","▣")
input(s2,"ชื่อ Config","config.name","ชื่อไฟล์");action(s2,"สร้าง Config","config.create");dropdown(s2,"Config","config.current",{"ไม่มี Config"},"ไม่มี Config");action(s2,"บันทึก","config.save");action(s2,"โหลด","config.load");action(s2,"ลบ Config","config.delete");toggle(s2,"Autoload","config.autoload",false)
local s3=section(sr,"Themes","◈")
dropdown(s3,"Preset","theme.preset",{"Moy Dark","Moy Cyan","Moy Purple"},"Moy Dark")
controller:SetCallback("theme.preset",function(v)theme.Accent=v=="Moy Cyan" and palettes[2] or v=="Moy Purple" and palettes[3] or palettes[1];repaint()end)
input(s3,"ชื่อ Theme","theme.name","ชื่อธีม");action(s3,"สร้าง Theme","theme.create");dropdown(s3,"Theme","theme.current",{"ไม่มี Theme"},"ไม่มี Theme");action(s3,"บันทึกธีม","theme.save");action(s3,"โหลดธีม","theme.load");action(s3,"ลบธีม","theme.delete");action(s3,"ตั้งเป็นค่าเริ่มต้น","theme.default")
-- Read-only live metrics; no game actions.
local started=os.clock();local elapsed,frames=0,0
connect(Run.RenderStepped,function(dt)
    elapsed+=dt;frames+=1
    if elapsed>=1 then
        metrics.Players.Text=tostring(#Players:GetPlayers()).."/"..tostring(Players.MaxPlayers)
        local secs=math.floor(os.clock()-started);metrics.Session.Text=string.format("%dm %02ds",math.floor(secs/60),secs%60)
        metrics.FPS.Text=tostring(math.floor(frames/elapsed+.5))
        local ok,ping=pcall(function()return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
        metrics.Ping.Text=ok and tostring(math.floor(ping+.5)).."ms" or "—"
        metrics.Place.Text=tostring(game.PlaceId);metrics.UI.Text="Ready";frames=0;elapsed=0
    end
end)
gui.Destroying:Connect(function() for _,c in ipairs(connections) do c:Disconnect() end end)
controller.Gui=gui
controller.Show=visible
controller.Destroy=function() gui:Destroy() end
show("Farm")
visible(true)
return controller
end)
if not ok then return end

install("MoyXHub_ToggleStyle.lua",function()
-- Moy X Hub: restore the original compact toggle appearance, without changing callbacks.
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local gui=Players.LocalPlayer.PlayerGui:FindFirstChild("MoyXHub_Dashboard")
local farm=gui and gui:FindFirstChild("Farm",true)
if not farm then return end
local names={
    ["ฟาร์มด่านอัตโนมัติ"]=true,
    ["กำจัดทันที (HP < 80%)"]=true,
    ["ฝึกพลังรวดเร็ว"]=true,
    ["เกิดใหม่อัตโนมัติ"]=true,
}
local count=0
for _,v in ipairs(farm:GetDescendants()) do
    if v:IsA("TextButton") and v.Parent then
        local matched=false
        for _,c in ipairs(v.Parent:GetChildren()) do
            if c:IsA("TextLabel") and names[c.Text] then matched=true;break end
        end
        if matched and not v:FindFirstChild("MoyToggleKnob") then
            v.Size=UDim2.fromOffset(35,18)
            v.TextTransparency=1
            local corner=v:FindFirstChildOfClass("UICorner") or Instance.new("UICorner",v)
            corner.CornerRadius=UDim.new(0,20)
            local knob=Instance.new("Frame")
            knob.Name="MoyToggleKnob"
            knob.AnchorPoint=Vector2.new(0,.5)
            knob.Size=UDim2.fromOffset(13,13)
            knob.BorderSizePixel=0
            knob.Active=false
            knob.Parent=v
            local kc=Instance.new("UICorner",knob);kc.CornerRadius=UDim.new(0,20)
            local function refresh()
                local on=v.Text=="เปิด"
                local available=v.Text=="เปิด" or v.Text=="ปิด"
                knob.Visible=available
                TweenService:Create(knob,TweenInfo.new(.16,Enum.EasingStyle.Quad),{
                    Position=UDim2.new(0,on and 19 or 3,.5,0),
                    BackgroundColor3=on and Color3.fromRGB(19,16,21) or Color3.fromRGB(240,233,244)
                }):Play()
                v.TextTransparency=available and 1 or 0
                if not available then v.Size=UDim2.fromOffset(110,30) else v.Size=UDim2.fromOffset(35,18) end
            end
            knob.Position=UDim2.new(0,3,.5,0)
            v:GetPropertyChangedSignal("Text"):Connect(refresh)
            refresh()
            count+=1
        end
    end
end
print("Moy toggle style updated: "..count)
end)

install("MoyXHub_StageDropdown.lua",function()
-- Moy X Hub: Stage dropdown, preserving the existing stage selection callback.
local P=game:GetService("Players").LocalPlayer
local gui=P.PlayerGui:FindFirstChild("MoyXHub_Dashboard")
local farm=gui and gui:FindFirstChild("Farm",true)
local input=farm and farm:FindFirstChildWhichIsA("TextBox",true)
if not input then warn("Moy stage field missing");return end
local row=input.Parent
local previous=row:FindFirstChild("MoyStageDropdown")
if previous then previous:Destroy() end
local previousList=row:FindFirstChild("MoyStageList")
if previousList then previousList:Destroy() end
local ok,connections=pcall(function() return getconnections(input.FocusLost) end)
local callback=ok and #connections==1 and connections[1].Function or nil
if type(callback)~="function" then warn("Stage callback unavailable");return end
local gates=workspace:FindFirstChild("_LocalGates")
local options={"Auto"}
local stages={}
if gates then for _,gate in ipairs(gates:GetChildren()) do
    local n=gate.Name:match("^Reco_(%d+)$")
    if n and gates:FindFirstChild("Defeat_"..n) then table.insert(stages,tonumber(n)) end
end end
table.sort(stages)
for _,n in ipairs(stages) do table.insert(options,tostring(n)) end
local function make(class,parent,props)
    local v=Instance.new(class)
    for k,x in pairs(props) do v[k]=x end
    v.Parent=parent
    return v
end
local bg=Color3.fromRGB(21,17,24)
local fg=Color3.fromRGB(240,233,244)
local accent=Color3.fromRGB(222,177,246)
local outline=Color3.fromRGB(47,39,52)
local function round(v) make("UICorner",v,{CornerRadius=UDim.new(0,6)});make("UIStroke",v,{Color=outline,Thickness=1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border}) end
input.Visible=false
local selected=input.Text=="" and "Auto" or input.Text
local button=make("TextButton",row,{Name="MoyStageDropdown",Position=input.Position,Size=input.Size,BackgroundColor3=bg,TextColor3=fg,Text=selected.."    ▾",Font=Enum.Font.SourceSansSemibold,TextSize=15,AutoButtonColor=true,BorderSizePixel=0})
round(button)
local list=make("ScrollingFrame",row,{Name="MoyStageList",Position=UDim2.fromOffset(0,40),Size=UDim2.new(1,0,0,175),BackgroundColor3=bg,BorderSizePixel=0,ScrollBarThickness=4,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),Visible=false,ScrollingDirection=Enum.ScrollingDirection.Y})
round(list)
make("UIPadding",list,{PaddingTop=UDim.new(0,5),PaddingBottom=UDim.new(0,5),PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6)})
make("UIGridLayout",list,{CellSize=UDim2.new(.2,-5,0,32),CellPadding=UDim2.fromOffset(4,5),SortOrder=Enum.SortOrder.LayoutOrder})
local buttons={}
local function close()
    list.Visible=false;row.Size=UDim2.new(1,0,0,40);button.Text=selected.."    ▾"
end
local function paint()
    for name,b in pairs(buttons) do b.BackgroundColor3=name==selected and accent or Color3.fromRGB(42,35,46);b.TextColor3=name==selected and bg or fg end
end
for i,value in ipairs(options) do
    local b=make("TextButton",list,{Text=value,LayoutOrder=i,Font=Enum.Font.SourceSansSemibold,TextSize=15,BackgroundColor3=bg,TextColor3=fg,BorderSizePixel=0})
    make("UICorner",b,{CornerRadius=UDim.new(0,5)})
    buttons[value]=b
    b.Activated:Connect(function()
        local old=input.Text
        input.Text=value=="Auto" and "" or value
        local success,err=pcall(callback,true,nil)
        if success then selected=value else input.Text=old;warn("Stage selection: "..tostring(err)) end
        paint();close()
    end)
end
button.Activated:Connect(function()
    if list.Visible then close() else list.Visible=true;row.Size=UDim2.new(1,0,0,220);button.Text=selected.."    ▴" end
end)
paint()
print("Moy stage dropdown: "..#stages.." stages plus Auto (blank/default)")
end)

install("MoyXHub_AutoUpgrade.lua",function()
-- Moy X Hub: Auto Upgrade using the game's visible, gold-only purchase buttons.
-- Starts OFF. It never opens a shop, invokes a remote, or clicks a Robux offer.
local P=game:GetService("Players").LocalPlayer
local UIS=game:GetService("UserInputService")
local GS=game:GetService("GuiService")
local Tween=game:GetService("TweenService")
local gui=P.PlayerGui:FindFirstChild("MoyXHub_Dashboard")
local farm=gui and gui:FindFirstChild("Farm",true)
if not farm then return end
local existing=farm:FindFirstChild("MoyAutoUpgrade",true)
if existing then existing:Destroy() end
local container
for _,v in ipairs(farm:GetDescendants()) do
    if v:IsA("TextLabel") and v.Text=="ฟาร์มด่านอัตโนมัติ" then container=v.Parent.Parent;break end
end
if not container then warn("Moy farm container missing");return end
local function make(class,parent,props)
    local v=Instance.new(class)
    for k,x in pairs(props) do v[k]=x end
    v.Parent=parent
    return v
end
local bg=Color3.fromRGB(42,35,46)
local accent=Color3.fromRGB(222,177,246)
local fg=Color3.fromRGB(240,233,244)
local mute=Color3.fromRGB(153,139,161)
local box=make("Frame",container,{Name="MoyAutoUpgrade",Size=UDim2.new(1,0,0,105),BackgroundTransparency=1,LayoutOrder=100})
local function text(name,pos,size,color)
    return make("TextLabel",box,{Text=name,Position=pos,Size=size,Font=Enum.Font.SourceSansSemibold,TextSize=14,BackgroundTransparency=1,TextColor3=color,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true})
end
text("อัปเกรดอัตโนมัติ (ทอง)",UDim2.fromOffset(0,0),UDim2.new(1,-48,0,30),fg)
local b=make("TextButton",box,{Text="",Size=UDim2.fromOffset(35,18),Position=UDim2.new(1,0,0,15),AnchorPoint=Vector2.new(1,.5),BackgroundColor3=bg,BorderSizePixel=0,AutoButtonColor=false})
make("UICorner",b,{CornerRadius=UDim.new(0,20)})
local knob=make("Frame",b,{Size=UDim2.fromOffset(13,13),AnchorPoint=Vector2.new(0,.5),Position=UDim2.new(0,3,.5,0),BorderSizePixel=0,BackgroundColor3=fg})
make("UICorner",knob,{CornerRadius=UDim.new(0,20)})
local status=text("ปิด • ซื้อรายการถูกที่สุดที่เงินพอ",UDim2.fromOffset(0,30),UDim2.new(1,0,0,37),mute)
text("เปิดเมนู UPGRADES ของเกมและซ่อน Moy ด้วย Left ALT",UDim2.fromOffset(0,67),UDim2.new(1,0,0,34),mute)
local enabled=false
local lastClick=0
local goldAsset="rbxassetid://112051628056654"
local ids={"Row_SeedCap","Row_Luck","Row_Train","Row_Gold"}
local names={Row_SeedCap="จำนวนเมล็ด",Row_Luck="โชค",Row_Train="พลังฝึก",Row_Gold="โบนัสทอง"}
local function showStatus(s) if status.Parent then status.Text=s end end
local function visible(v)
    while v and v~=P.PlayerGui do
        if v:IsA("GuiObject") and not v.Visible then return false end
        if v:IsA("ScreenGui") and not v.Enabled then return false end
        v=v.Parent
    end
    return v==P.PlayerGui
end
local function number(s)
    s=s:gsub(",",""):gsub("%s",""):upper()
    local n,suffix=s:match("^(%d+%.?%d*)([KMBT]?)$")
    local val=tonumber(n)
    if not val then return nil end
    local factor=({K=1e3,M=1e6,B=1e9,T=1e12})[suffix] or 1
    return val*factor
end
local function getContent()
    local fusion=P.PlayerGui:FindFirstChild("FusionUI")
    local root=fusion and fusion:FindFirstChild("UpgradeRoot")
    local canvas=root and root:FindFirstChild("Canvas")
    local main=canvas and canvas:FindFirstChild("MainFrame")
    return root,main and main:FindFirstChild("Content")
end
local function getCandidate(content)
    local gold=content and content:FindFirstChild("Gold")
    local amount=gold and gold:FindFirstChild("Amount")
    local icon=gold and gold:FindFirstChild("Icon")
    if not amount or not amount:IsA("TextLabel") or not icon or not icon:IsA("ImageLabel") or icon.Image~=goldAsset then return nil,nil end
    local balance=number(amount.Text)
    if not balance then return nil,nil end
    local list=content:FindFirstChild("List")
    local cheapest=nil
    for _,id in ipairs(ids) do
        local row=list and list:FindFirstChild(id)
        local slot=row and row:FindFirstChild("BuySlot")
        local host=slot and slot:FindFirstChild("_FeelHost")
        local buy=host and host:FindFirstChild("Buy")
        local price=buy and buy:FindFirstChild("PriceContent")
        local amt=price and price:FindFirstChild("Amount")
        local coin=price and price:FindFirstChild("Coin")
        if buy and buy:IsA("TextButton") and buy.Active and visible(buy) and amt and amt:IsA("TextLabel") and coin and coin:IsA("ImageLabel") and coin.Image==goldAsset then
            local cost=number(amt.Text)
            if cost and cost>0 and cost<=balance and (not cheapest or cost<cheapest.cost) then
                cheapest={button=buy,cost=cost,id=id}
            end
        end
    end
    return cheapest,balance
end
local function step()
    local root,content=getContent()
    if not content then showStatus("รอเมนู UPGRADES");return end
    local gold=content:FindFirstChild("Gold")
    local amt=gold and gold:FindFirstChild("Amount")
    if not root or not visible(root) then showStatus("ทอง: "..(amt and amt.Text or "?").." • รอเปิด UPGRADES");return end
    local chosen,balance=getCandidate(content)
    if not balance then showStatus("พัก: อ่านยอดทองไม่ได้");return end
    if not chosen then showStatus("ทอง: "..tostring(balance).." • ยังไม่มีรายการที่ซื้อได้");return end
    if not isrbxactive() or UIS:GetFocusedTextBox() then showStatus("พัก: เกมไม่ได้โฟกัส");return end
    if os.clock()-lastClick<1.5 then return end
    local window=gui:FindFirstChild("Window")
    if window and window.Visible then showStatus("พร้อมอัป "..names[chosen.id].." • ซ่อน Moy ด้วย ALT");return end
    local btn=chosen.button
    local inset=GS:GetGuiInset()
    local centre=btn.AbsolutePosition+btn.AbsoluteSize/2
    if btn.AbsoluteSize.X<12 or btn.AbsoluteSize.Y<12 then return end
    local target=centre+inset
    mousemoveabs(math.round(target.X),math.round(target.Y))
    task.wait(.07)
    if not enabled or not box.Parent or not isrbxactive() or UIS:GetFocusedTextBox() then return end
    local _,currentContent=getContent()
    local nextChoice=getCandidate(currentContent)
    if not nextChoice or nextChoice.button~=btn or not visible(btn) then return end
    local cursor=UIS:GetMouseLocation()-inset
    local pos,size=btn.AbsolutePosition,btn.AbsoluteSize
    if cursor.X<pos.X or cursor.X>pos.X+size.X or cursor.Y<pos.Y or cursor.Y>pos.Y+size.Y then return end
    local hits=P.PlayerGui:GetGuiObjectsAtPosition(math.floor(cursor.X),math.floor(cursor.Y))
    local top=hits[1]
    if not top or (top~=btn and not top:IsDescendantOf(btn)) then showStatus("พัก: ปุ่มอัปเกรดถูกบัง");return end
    lastClick=os.clock()
    mouse1click()
    showStatus("ส่งคำสั่งอัป "..names[chosen.id].." • ตรวจราคาใหม่")
end
b.Activated:Connect(function()
    enabled=not enabled
    Tween:Create(b,TweenInfo.new(.16),{BackgroundColor3=enabled and accent or bg}):Play()
    Tween:Create(knob,TweenInfo.new(.16),{Position=UDim2.new(0,enabled and 19 or 3,.5,0),BackgroundColor3=enabled and Color3.fromRGB(19,16,21) or fg}):Play()
    showStatus(enabled and "เปิด • กำลังตรวจยอดทอง" or "ปิด • ซื้อรายการถูกที่สุดที่เงินพอ")
end)
box.Destroying:Connect(function() enabled=false end)
task.spawn(function()
    while box.Parent and gui.Parent do
        if enabled then
            local ok,err=pcall(step)
            if not ok then showStatus("พัก: "..tostring(err)) end
        end
        task.wait(.65)
    end
end)
print("Moy Auto Upgrade added (OFF)")
end)

install("MoyXHub_IndexClaim.lua",function()
-- Moy X Hub: Index Auto Claim All through the verified game callback. No synthetic mouse input.
local P=game:GetService("Players").LocalPlayer
local Tween=game:GetService("TweenService")
local gui=P.PlayerGui:FindFirstChild("MoyXHub_Dashboard")
local farm=gui and gui:FindFirstChild("Farm",true)
if not farm then return end
local parent
for _,v in ipairs(farm:GetDescendants()) do
    if v:IsA("TextLabel") and v.Text=="ฟาร์มด่านอัตโนมัติ" then parent=v.Parent.Parent;break end
end
if not parent then return end
local existing=parent:FindFirstChild("MoyIndexClaim")
if existing then existing:Destroy() end
local function make(class,holder,props)
    local v=Instance.new(class);for k,x in pairs(props) do v[k]=x end;v.Parent=holder;return v
end
local bg=Color3.fromRGB(42,35,46)
local fg=Color3.fromRGB(240,233,244)
local accent=Color3.fromRGB(222,177,246)
local mute=Color3.fromRGB(153,139,161)
local box=make("Frame",parent,{Name="MoyIndexClaim",Size=UDim2.new(1,0,0,102),BackgroundTransparency=1,LayoutOrder=101})
local function label(t,y,h,color)
    return make("TextLabel",box,{Text=t,Position=UDim2.fromOffset(0,y),Size=UDim2.new(1,y==0 and -60 or 0,0,h),Font=Enum.Font.SourceSansSemibold,TextSize=14,TextColor3=color,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1})
end
label("รับรางวัล Index ทั้งหมด",0,34,fg)
local button=make("TextButton",box,{Name="MoyIndexClaimToggle",Text="",AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,0,0,17),Size=UDim2.fromOffset(35,18),BackgroundColor3=bg,BorderSizePixel=0,AutoButtonColor=false})
make("UICorner",button,{CornerRadius=UDim.new(0,20)})
local knob=make("Frame",button,{Name="Knob",AnchorPoint=Vector2.new(0,.5),Position=UDim2.new(0,3,.5,0),Size=UDim2.fromOffset(13,13),BackgroundColor3=fg,BorderSizePixel=0})
make("UICorner",knob,{CornerRadius=UDim.new(0,20)})
local status=label("ปิด • Seeds / Fruit / Haki / Special",34,34,mute)
label("เรียก Callback ของเกมโดยตรง • ไม่ใช้เมาส์",68,34,mute)
local enabled=false
local lastAction=0
local lastRequest=nil
local function say(t) if status.Parent then status.Text=t end end
local function getPath(v,...)
    for _,n in ipairs({...}) do v=v and v:FindFirstChild(n) end
    return v
end
local function callAction(btn)
    if not enabled or not box.Parent or not btn or not btn:IsA("GuiButton") or not btn.Active then return false end
    if os.clock()-lastAction<1.5 then return false end
    if type(getconnections)~="function" then say("ตัวรันนี้ไม่รองรับ Callback");return false end
    local ok,cs=pcall(function()return getconnections(btn.Activated)end)
    if not ok then say("อ่าน Callback ไม่สำเร็จ");return false end
    local found={}
    for _,x in ipairs(cs) do
        local f=x.Function
        if type(f)=="function" and debug.info(f,"s")=="ReplicatedStorage.Shared.Client.UI.BaseSimComponents" then table.insert(found,f) end
    end
    if #found~=1 then say("ไม่พบ Callback ที่ยืนยันไว้");return false end
    lastAction=os.clock()
    local success,err=pcall(found[1])
    if not success then say("พัก: "..tostring(err));return false end
    return true
end
local function step()
    local root=getPath(P.PlayerGui,"FusionUI","IndexRoot")
    local c=getPath(root,"Canvas","MainFrame","Content")
    if not c then say("รอโหลดข้อมูล Index");return end
    local claim=getPath(c,"ClaimAll","_FeelHost","ClaimAllBtn")
    local caption=getPath(claim,"Title")
    local count=caption and caption:IsA("TextLabel") and tonumber(caption.Text:match("^CLAIM ALL%s*%((%d+)%)"))
    local rewardBox=getPath(c,"PlayerCard","RewardBox")
    local claimBox=getPath(rewardBox,"Claim")
    local lockedBox=getPath(rewardBox,"Locked")
    local reward=getPath(claimBox,"_FeelHost","ClaimBtn")
    local rewardKey=nil
    if claimBox and claimBox.Visible and lockedBox and not lockedBox.Visible and reward then
        for _,v in ipairs(rewardBox:GetDescendants()) do
            if v:IsA("TextLabel") and v.Text:match("^LV %d+ REWARD$") then rewardKey=v.Text;break end
        end
    end
    if count and count>0 and claim and claim.Visible then
        local key="items:"..count
        if lastRequest==key and os.clock()-lastAction<8 then return end
        if callAction(claim) then lastRequest=key;say("เรียกรับทั้งหมด "..count.." รายการ • รอยืนยัน") end
        return
    end
    if rewardKey then
        local key="level:"..rewardKey
        if lastRequest==key and os.clock()-lastAction<8 then return end
        if callAction(reward) then lastRequest=key;say("เรียกรับรางวัล "..rewardKey.." • รอยืนยัน") end
        return
    end
    lastRequest=nil
    say(count==0 and "รับครบแล้ว • ตรวจรางวัลใหม่อัตโนมัติ" or "รอตรวจสถานะ Index")
end
button.Activated:Connect(function()
    enabled=not enabled;lastRequest=nil;lastAction=0
    Tween:Create(button,TweenInfo.new(.16),{BackgroundColor3=enabled and accent or bg}):Play()
    Tween:Create(knob,TweenInfo.new(.16),{Position=UDim2.new(0,enabled and 19 or 3,.5,0),BackgroundColor3=enabled and Color3.fromRGB(19,16,21) or fg}):Play()
    say(enabled and "เปิด • ตรวจรางวัล Index" or "ปิด • Seeds / Fruit / Haki / Special")
end)
box.Destroying:Connect(function()enabled=false end)
task.spawn(function()
    while box.Parent and gui.Parent do
        if enabled then local ok,err=pcall(step);if not ok then say("พัก: "..tostring(err)) end end
        task.wait(.65)
    end
end)
print("Moy Index Claim All added (OFF)")
end)

install("MoyXHub_AccountCleanup.lua",function()
-- Moy X Hub: replace unrelated Account placeholders with confirmed game systems.
local P=game:GetService("Players").LocalPlayer
local gui=P.PlayerGui:FindFirstChild("MoyXHub_Dashboard")
local account=gui and gui:FindFirstChild("Account",true)
if not account then return end
for _,v in ipairs(account:GetChildren()) do
    if v:IsA("GuiObject") or v:IsA("UIListLayout") then v:Destroy() end
end
local function make(class,parent,props)
    local v=Instance.new(class);for k,x in pairs(props) do v[k]=x end;v.Parent=parent;return v
end
local text=Color3.fromRGB(240,233,244)
local mute=Color3.fromRGB(153,139,161)
local accent=Color3.fromRGB(222,177,246)
make("UIListLayout",account,{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder})
local function card(order,title,desc,status)
    local f=make("Frame",account,{Name="AccountInfo"..order,Size=UDim2.new(1,0,0,98),BackgroundColor3=Color3.fromRGB(25,21,29),BorderSizePixel=0,LayoutOrder=order})
    make("UICorner",f,{CornerRadius=UDim.new(0,7)})
    make("UIStroke",f,{Color=Color3.fromRGB(47,39,52),Thickness=1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border})
    local function line(t,y,h,color,size)
        make("TextLabel",f,{Text=t,Position=UDim2.fromOffset(10,y),Size=UDim2.new(1,-20,0,h),BackgroundTransparency=1,TextColor3=color,Font=Enum.Font.SourceSansSemibold,TextSize=size,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left})
    end
    line(title,4,24,accent,16)
    line(desc,30,38,text,14)
    line(status,70,22,mute,13)
end
card(1,"Daily Rewards","รับรางวัลประจำวันตามวันที่เข้าเกม","มีในเกม • ยังไม่เชื่อม Auto")
card(2,"Free Gifts","รับของขวัญตามเวลาเล่น ทุก 5 นาที","มีในเกม • ยังไม่เชื่อม Auto")
card(3,"Index Rewards","รับ EXP จากสิ่งที่ค้นพบและรางวัลเลเวล Index","มีสวิตช์ในแท็บ Farm • ยังไม่ทดสอบรับจริง")
card(4,"Offline Rewards","รับรางวัลสะสมระหว่างออกเกม","มีในเกม • ยังไม่เชื่อม Auto")
card(5,"Community Rewards","รับรางวัลเมื่อผ่านเงื่อนไขชุมชนของเกม","มีในเกม • ผู้เล่นต้องทำเงื่อนไขเอง")
card(6,"Season 1","ติดตามกิจกรรมและรางวัลตามฤดูกาล","พบเมนู Season • ยังไม่ได้ตรวจรายละเอียด")
card(7,"Summon","เมนูสุ่มของหรือพลังของเกม","พบเมนู Summon • ยังไม่ยืนยันราคาและชนิดรางวัล")
print("Moy Account cleaned: confirmed systems only")
end)

install("MoyXHub_AutoSell.lua",function()
-- Moy X Hub: global Sell All via the existing game UI callback; starts OFF, no mouse simulation.
local P=game:GetService("Players").LocalPlayer
local Tween=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local gui=P.PlayerGui:FindFirstChild("MoyXHub_Dashboard")
local farm=gui and gui:FindFirstChild("Farm",true)
if not farm then return end
local parent
for _,v in ipairs(farm:GetDescendants()) do
    if v:IsA("TextLabel") and v.Text=="ฟาร์มด่านอัตโนมัติ" then parent=v.Parent.Parent;break end
end
if not parent then return end
local old=parent:FindFirstChild("MoyAutoSell")
if old then old:Destroy() end
local function make(class,holder,props)
    local v=Instance.new(class);for k,x in pairs(props) do v[k]=x end;v.Parent=holder;return v
end
local bg=Color3.fromRGB(42,35,46)
local fg=Color3.fromRGB(240,233,244)
local accent=Color3.fromRGB(222,177,246)
local mute=Color3.fromRGB(153,139,161)
local dark=Color3.fromRGB(19,16,21)
local box=make("Frame",parent,{Name="MoyAutoSell",Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,LayoutOrder=102})
make("UIListLayout",box,{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder})
local function label(holder,t,size,order)
    return make("TextLabel",holder,{Text=t,Size=size,LayoutOrder=order or 0,Font=Enum.Font.SourceSansSemibold,TextSize=14,TextColor3=fg,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1})
end
local head=make("Frame",box,{Size=UDim2.new(1,0,0,34),BackgroundTransparency=1,LayoutOrder=1})
label(head,"ขายเมล็ดทั้งหมดอัตโนมัติ",UDim2.new(1,-60,1,0))
local b=make("TextButton",head,{Name="MoyAutoSellToggle",Text="",AnchorPoint=Vector2.new(1,.5),Position=UDim2.new(1,0,.5,0),Size=UDim2.fromOffset(35,18),BackgroundColor3=bg,BorderSizePixel=0,AutoButtonColor=false})
make("UICorner",b,{CornerRadius=UDim.new(0,20)})
local knob=make("Frame",b,{Name="MoyToggleKnob",AnchorPoint=Vector2.new(0,.5),Position=UDim2.new(0,3,.5,0),Size=UDim2.fromOffset(13,13),BackgroundColor3=fg,BorderSizePixel=0})
make("UICorner",knob,{CornerRadius=UDim.new(0,20)})
local status=label(box,"ปิด • เปิดแล้วจะขายเมล็ดทั้งหมด",UDim2.new(1,0,0,30),2);status.TextColor3=mute
local enabled=false
local lastAction=0
local pending=nil
local function say(t) if status.Parent then status.Text=t end end
local function path(v,...)
    for _,n in ipairs({...}) do v=v and v:FindFirstChild(n) end
    return v
end
local function snapshot()
    local content=path(P.PlayerGui,"FusionUI","SellRoot","Canvas","MainFrame","Content")
    local list=path(content,"List")
    local btn=path(content,"Footer","SellAll")
    if not list or not btn then return nil,nil end
    local total=0
    for _,row in ipairs(list:GetChildren()) do
        if row:IsA("GuiObject") and row.Visible and row.Name:match("^Seed_%d+$") then
            local name=row:FindFirstChild("Name")
            if name and name:IsA("TextLabel") then
                local raw=name.Text:gsub("<[^>]+>",""):gsub(",","")
                local q=tonumber(raw:match("[xX](%d+)%s*$"))
                if q then total+=q end
            end
        end
    end
    return total,btn
end
local function callSell(btn)
    if not btn or not btn:IsA("GuiButton") or not btn.Active or not btn.Visible then return false,"ปุ่มขายไม่พร้อม" end
    local title=btn:FindFirstChild("Title")
    if not title or not title:IsA("TextLabel") or title.Text:upper()~="SELL ALL" then return false,"ไม่พบปุ่ม SELL ALL" end
    local ok,cs=pcall(function()return getconnections(btn.Activated)end)
    if not ok then return false,"ตัวรันไม่รองรับ Callback" end
    local funcs={}
    for _,c in ipairs(cs) do
        local f=c.Function
        if type(f)=="function" and debug.info(f,"s")=="ReplicatedStorage.Shared.Client.UI.BaseSimComponents" then table.insert(funcs,f) end
    end
    if #funcs~=1 then return false,"ไม่พบ Callback ที่ตรวจสอบไว้" end
    local success,err=pcall(funcs[1])
    return success,success and "" or tostring(err)
end
local function step()
    local total,btn=snapshot()
    if total==nil then say("รอข้อมูลร้านขายเมล็ด");return end
    if pending then
        if total<pending.quantity then
            say("จำนวนเมล็ดลดลง "..(pending.quantity-total).." • ยืนยันแล้ว")
            pending=nil
        elseif os.clock()-pending.time>6 then
            say("พัก: ยังไม่ยืนยันผล SELL ALL • ปิดแล้วเปิดใหม่เพื่อลองอีกครั้ง");return
        else return end
    end
    if total<=0 then say("เปิด • รอเมล็ดใหม่");return end
    if os.clock()-lastAction<2 then return end
    if not enabled or not box.Parent then return end
    lastAction=os.clock()
    local ok,err=callSell(btn)
    if ok then pending={quantity=total,time=os.clock()};say("ส่ง SELL ALL • "..total.." เมล็ด • รอยืนยัน")
    else say("พัก: "..err) end
end
local function paintToggle()
    local mobile=UIS.TouchEnabled and not UIS.KeyboardEnabled
    local view=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
    mobile=mobile or (view and (view.X<850 or view.Y<450)) or false
    b.Size=UDim2.fromOffset(mobile and 44 or 35,mobile and 30 or 18)
    knob.Size=UDim2.fromOffset(mobile and 21 or 13,mobile and 21 or 13)
    Tween:Create(b,TweenInfo.new(.16),{BackgroundColor3=enabled and accent or bg}):Play()
    Tween:Create(knob,TweenInfo.new(.16),{Position=UDim2.new(0,enabled and 19 or (mobile and 4 or 3),.5,0),BackgroundColor3=enabled and dark or fg}):Play()
end
b.Activated:Connect(function()
    enabled=not enabled;pending=nil;paintToggle()
    say(enabled and "เปิด • ขายเมล็ดทั้งหมด" or "ปิด • เปิดแล้วจะขายเมล็ดทั้งหมด")
end)
box.Destroying:Connect(function()enabled=false end)
paintToggle()
task.spawn(function()
    while box.Parent and gui.Parent do
        if enabled then
            local ok,err=pcall(step)
            if not ok then say("พัก: "..tostring(err)) end
        end
        task.wait(1)
    end
end)
print("Moy Auto Sell All added (OFF)")
end)

install("MoyXHub_MobileLayout.lua",function()
-- Moy X Hub: responsive UI and text-only stage dropdown caption.
-- Layout only: existing gameplay callbacks and selection values are unchanged.
local P=game:GetService("Players").LocalPlayer
local UIS=game:GetService("UserInputService")
local gui=P.PlayerGui:FindFirstChild("MoyXHub_Dashboard")
local w=gui and gui:FindFirstChild("Window")
local farm=w and w:FindFirstChild("Farm",true)
if not farm then return end
if gui:FindFirstChild("MoyResponsiveLayout") then return end
local marker=Instance.new("Folder");marker.Name="MoyResponsiveLayout";marker.Parent=gui
local connections={}
local function watch(signal,fn) local c=signal:Connect(fn);table.insert(connections,c) end
local body=farm.Parent
local sidebar
for _,v in ipairs(w:GetChildren()) do if v:IsA("Frame") and v~=body and v:FindFirstChild("SidebarSeam") then sidebar=v;break end end
local scale=w:FindFirstChildOfClass("UIScale")
local header
for _,v in ipairs(body:GetChildren()) do if v:IsA("Frame") and v:FindFirstChildWhichIsA("TextBox") then header=v;break end end
local search=header and header:FindFirstChildWhichIsA("TextBox")
local title=header and header:FindFirstChildWhichIsA("TextLabel")
local hide=header and header:FindFirstChildWhichIsA("TextButton")
local orb=gui:FindFirstChild("MoyOpen")
local dropdown=farm:FindFirstChild("MoyStageDropdown",true)
local list=farm:FindFirstChild("MoyStageList",true)
local stageGrid=list and list:FindFirstChildOfClass("UIGridLayout")
local editing=false
local function textCaption()
    if not dropdown or editing then return end
    local val=dropdown.Text:match("^%s*(%S+)") or "Auto"
    local display=val.." | "..(list and list.Visible and "ปิด" or "เลือก")
    if dropdown.Text~=display then editing=true;dropdown.Text=display;editing=false end
end
if dropdown then watch(dropdown:GetPropertyChangedSignal("Text"),textCaption) end
if list then watch(list:GetPropertyChangedSignal("Visible"),textCaption) end
textCaption()
local original={}
local function set(v,k,value)
    if not v then return end
    original[v]=original[v] or {}
    if original[v][k]==nil then original[v][k]=v[k] end
    if v[k]~=value then v[k]=value end
end
local function restore()
    for v,props in pairs(original) do if v.Parent then for k,value in pairs(props) do pcall(function()v[k]=value end) end end end
    table.clear(original)
end
local mobile=false
local function mobileFit(view)
    return math.max(280,view.X-12),math.max(200,view.Y-12)
end
local function biggerSwitch(v)
    if not mobile or not v.Parent then return end
    local knob=v:FindFirstChild("MoyToggleKnob")
    if not knob and v.Parent.Name=="MoyAutoUpgrade" then knob=v:FindFirstChildWhichIsA("Frame") end
    if not knob then return end
    set(v,"Size",UDim2.fromOffset(44,30))
    set(knob,"Size",UDim2.fromOffset(21,21))
end
for _,v in ipairs(farm:GetDescendants()) do
    if v:IsA("TextButton") and v:FindFirstChild("MoyToggleKnob") then
        watch(v:GetPropertyChangedSignal("Text"),function()task.defer(function()biggerSwitch(v)end)end)
    end
end
local function adapt()
    if not w.Parent or not workspace.CurrentCamera then return end
    local view=workspace.CurrentCamera.ViewportSize
    local small=view.X<850 or view.Y<450 or (UIS.TouchEnabled and not UIS.KeyboardEnabled)
    if not small then
        if mobile then mobile=false;restore() end
        textCaption();return
    end
    mobile=true
    local width,height=mobileFit(view)
    local sidebarWidth=view.X<500 and 64 or 84
    set(scale,"Scale",1)
    set(w,"Size",UDim2.fromOffset(width,height))
    set(w,"Position",UDim2.fromScale(.5,.5))
    set(sidebar,"Size",UDim2.new(0,sidebarWidth,1,0))
    set(body,"Position",UDim2.fromOffset(sidebarWidth,0))
    set(body,"Size",UDim2.new(1,-sidebarWidth,1,0))
    set(header,"Size",UDim2.new(1,0,0,52))
    set(search,"Visible",false)
    set(title,"Position",UDim2.fromOffset(9,0));set(title,"Size",UDim2.new(1,-66,1,0));set(title,"TextSize",16)
    set(hide,"Text","ปิด");set(hide,"Size",UDim2.fromOffset(48,40));set(hide,"Position",UDim2.new(1,-53,0,6))
    set(orb,"Size",UDim2.fromOffset(54,54))
    if sidebar then
        for _,v in ipairs(sidebar:GetChildren()) do
            if v.Name=="MoyMonogram" then set(v,"Position",UDim2.new(.5,0,0,28))
            elseif v:IsA("Frame") and v:FindFirstChildWhichIsA("UIListLayout") then
                set(v,"Position",UDim2.fromOffset(4,57));set(v,"Size",UDim2.new(1,-8,1,-65))
                local l=v:FindFirstChildWhichIsA("UIListLayout");set(l,"Padding",UDim.new(0,3))
                for _,b in ipairs(v:GetChildren()) do if b:IsA("TextButton") then
                    set(b,"Size",UDim2.new(1,0,0,48))
                    for _,child in ipairs(b:GetChildren()) do
                        if child.Name=="NavIcon" then set(child,"Position",UDim2.new(.5,0,0,2))
                        elseif child:IsA("TextLabel") then set(child,"Position",UDim2.fromOffset(0,26));set(child,"TextSize",12) end
                    end
                end end
            elseif v:IsA("ImageLabel") or v:IsA("TextLabel") then set(v,"Visible",false) end
        end
    end
    for _,page in ipairs(body:GetChildren()) do if page:IsA("ScrollingFrame") then
        set(page,"Position",UDim2.fromOffset(6,52));set(page,"Size",UDim2.new(1,-12,1,-76));set(page,"ScrollBarThickness",5)
        if page.Name=="Account" or page.Name=="Settings" then
            local wrap=page:FindFirstChildWhichIsA("Frame")
            local l=wrap and wrap:FindFirstChildOfClass("UIListLayout")
            if l then set(l,"FillDirection",Enum.FillDirection.Vertical);for _,col in ipairs(wrap:GetChildren()) do if col:IsA("Frame") then set(col,"Size",UDim2.new(1,0,0,0));set(col,"Position",UDim2.new()) end end end
        end
    end end
    if dropdown then set(dropdown,"Size",UDim2.new(.5,0,0,34));set(dropdown,"TextSize",14) end
    if stageGrid then set(stageGrid,"CellSize",UDim2.new(view.X<500 and .25 or .2,-5,0,40)) end
    if list then set(list,"ScrollBarThickness",6) end
    for _,v in ipairs(farm:GetDescendants()) do if v:IsA("TextButton") then biggerSwitch(v) end end
    textCaption()
end
if workspace.CurrentCamera then watch(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"),function()task.defer(adapt)end) end
watch(gui.Destroying,function()for _,c in ipairs(connections) do c:Disconnect()end end)
adapt()
print("Moy responsive layout ready; desktop and compact breakpoint")
end)

return controller
