local dry=(...=="dry")
if not dry and game.PlaceId~=93898234979111 then return {ready=false,reason="สคริปต์นี้ใช้สำหรับแมพจับปลาเท่านั้น"} end
local function makeBase():any
-- MoyXHub | Prism UI Base
-- Reusable interface only.
-- No gameplay callbacks, no remotes, no character movement, no place restriction.
local env=getgenv()
local UI: any = (function()
    local TS=game:GetService("TweenService")
    local Core=game:GetService("CoreGui")
    local preview=env.__MoyXHubUIOnly
    if preview then pcall(function() preview:Destroy() end);env.__MoyXHubUIOnly=nil end
    local loader,err=loadstring(game:HttpGet("https://ai.zeinstore.xyz/prism.luau"))
    assert(loader,tostring(err))
    local u:any=loader()
    local root=Core:WaitForChild("TwoKPrism",5)
    assert(root,"Prism UI root unavailable")
    local c=root:WaitForChild("Container") :: Frame
    local orb=root:WaitForChild("PrismOrb") :: Frame
    local purple=Color3.fromRGB(177,91,255)
    local cyan=Color3.fromRGB(66,220,255)
    local white=Color3.fromRGB(247,239,255)
    local con:{RBXScriptConnection}={}
    local function bind(signal:RBXScriptSignal,fn:any) table.insert(con,signal:Connect(fn)) end
    local function gradient(obj:Instance)
        local gr=Instance.new("UIGradient");gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,white),ColorSequenceKeypoint.new(.48,purple),ColorSequenceKeypoint.new(1,cyan)});gr.Rotation=25;gr.Parent=obj
    end
    local function mark(parent:GuiObject,name:string,n:number,z:number)
        local l=Instance.new("TextLabel");l.Name=name;l.BackgroundTransparency=1;l.Size=UDim2.fromScale(1,1);l.Text="MH";l.Font=Enum.Font.GothamBlack;l.TextSize=n;l.TextColor3=Color3.new(1,1,1);l.ZIndex=z;l.Parent=parent;gradient(l)
    end
    local function style(v:Instance)
        if v:IsA("GuiObject") and (v.Name=="Sheen" or v.Name=="Specular" or v.Name=="Noise") then v.Visible=false
        elseif v:IsA("Frame") and v.Name=="Surface" then v.BackgroundColor3=Color3.fromRGB(22,14,39);v.BackgroundTransparency=.09
        elseif v:IsA("UIGradient") and (v.Parent and (v.Parent:IsA("UIStroke") or v.Parent.Name=="Title")) then v.Color=ColorSequence.new(purple,cyan)
        elseif v:IsA("TextLabel") or v:IsA("TextButton") then
            local v:any=v
            if v.Font==Enum.Font.Michroma or v.Name=="SecLabel" then v.Font=Enum.Font.SourceSansSemibold end
            if v.Name=="SecLabel" then v.TextSize=16 end
            if v.Name=="Desc" then v.Font=Enum.Font.SourceSans;v.TextSize=13 end
            if v.Name=="Title" and v.Parent and v.Parent.Name=="Inner" then v.Font=Enum.Font.SourceSansSemibold;v.TextSize=15 end
        end
    end
    u:SetAccent(purple);u.Parallax=false;u.ToggleKey=Enum.KeyCode.LeftAlt
    local title=root:FindFirstChild("Title",true) :: TextLabel
    local hdr=title.Parent :: Frame
    local prismMark=hdr:FindFirstChild("PrismMark") :: Frame
    for _,v in ipairs(prismMark:GetChildren()) do if v:IsA("GuiObject") then v.Visible=false end end
    mark(prismMark,"MoyMark",19,prismMark.ZIndex+4)
    for _,name in ipairs({"SplitA","SplitB","Face","Orbit","OrbNoise","Shine"}) do local v=orb:FindFirstChild(name);if v and v:IsA("GuiObject") then v.Visible=false end end
    mark(orb,"MoyOrbLogo",25,orb.ZIndex+12)
    local setTitle=u.SetTitle
    u.SetTitle=function(self:any,_name:string)
        setTitle(self,_name)
        title.Font=Enum.Font.SourceSansBold;title.TextSize=20;title.TextColor3=white;title.TextScaled=false;title.TextTruncate=Enum.TextTruncate.AtEnd
    end
    u:SetTitle("MoyXHub")
    local effects=root:FindFirstChild("SplinterLayer")
    if effects then
        local function quiet(v:Instance) if v:IsA("GuiObject") then v.Visible=false end end
        for _,v in ipairs(effects:GetDescendants()) do quiet(v) end;bind(effects.DescendantAdded,quiet)
    end
    local rc=hdr:FindFirstChild("RightControls") :: Frame
    local ll=rc:FindFirstChildOfClass("UIListLayout")
    if ll then ll.Padding=UDim.new(0,6) end
    rc.Size=UDim2.fromOffset(330,38)
    local function line(parent:GuiObject,x:number,y:number,w:number,h:number,rot:number,col:Color3)
        local a=Instance.new("Frame");a.BackgroundColor3=col;a.BorderSizePixel=0;a.AnchorPoint=Vector2.new(.5,.5);a.Position=UDim2.fromOffset(x,y);a.Size=UDim2.fromOffset(w,h);a.Rotation=rot;a.ZIndex=parent.ZIndex+2;a.Parent=parent;local cr=Instance.new("UICorner");cr.CornerRadius=UDim.new(0,2);cr.Parent=a
    end
    local minus=rc:FindFirstChild("Button_−") :: GuiObject;local plus=rc:FindFirstChild("Button_+") :: GuiObject;minus.Visible=false;plus.Visible=false
    local defs:any={{"Button_▁","ย่อ","min",Color3.fromRGB(191,175,255)},{"Button_▾","ซ่อน","hide",Color3.fromRGB(110,226,255)},{"Button_✕","ปิด UI","close",Color3.fromRGB(255,145,175)}}
    for _,d in ipairs(defs) do
        local b=rc:FindFirstChild(d[1]) :: TextButton
        b.Size=UDim2.fromOffset(54,36);b.Text="";b.BackgroundColor3=Color3.fromRGB(39,28,62);b.BackgroundTransparency=.08;b.AutoButtonColor=false
        local f=Instance.new("Frame");f.Name="MoyControlDesign";f.Size=UDim2.fromScale(1,1);f.BackgroundTransparency=1;f.ZIndex=b.ZIndex+1;f.Active=false;f.Parent=b
        local col=d[4];local l=Instance.new("TextLabel");l.BackgroundTransparency=1;l.Size=UDim2.new(1,0,0,15);l.Position=UDim2.new(0,0,1,-17);l.Text=d[2];l.Font=Enum.Font.SourceSansSemibold;l.TextSize=13;l.TextColor3=col;l.ZIndex=f.ZIndex+2;l.Parent=f
        if d[3]=="min" then line(f,27,10,13,2,0,col) elseif d[3]=="hide" then line(f,23.5,9,10,2,45,col);line(f,30.5,9,10,2,-45,col) else line(f,27,10,13,2,45,col);line(f,27,10,13,2,-45,col) end
        local st=b:FindFirstChildOfClass("UIStroke");if st then st.Color=col;st.Transparency=.55 end
        bind(b.MouseEnter,function() if b.Parent then TS:Create(b,TweenInfo.new(.15),{BackgroundColor3=Color3.fromRGB(72,43,98)}):Play() end end)
        bind(b.MouseLeave,function() if b.Parent then TS:Create(b,TweenInfo.new(.15),{BackgroundColor3=Color3.fromRGB(39,28,62)}):Play() end end)
    end
    for _,v in ipairs(root:GetDescendants()) do style(v) end
    bind(root.DescendantAdded,function(v) task.defer(function() if v.Parent then style(v) end end) end)
    local base=c.Position
    local tween:Tween?=nil
    local opening=false
    u.Toggle=function(self:any,show:boolean?)
        local yes=if show==nil then not self.Visible else show
        if tween then tween:Cancel();tween=nil end
        if yes then
            if c.Visible and self.Visible and not opening then return end
            self.Visible=true;c.Visible=true
            for _,v in ipairs(c:GetChildren()) do local x=v:FindFirstChild("Content");if x and x:IsA("GuiObject") then x.Visible=true end end
            opening=true;c.Position=base+UDim2.fromOffset(0,42)
            local t=TS:Create(c,TweenInfo.new(.42,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=base});tween=t;t:Play()
            t.Completed:Once(function() if tween==t then opening=false;tween=nil end end)
        else
            if not opening then base=c.Position end
            opening=false;self.Visible=false;c.Visible=false;c.Position=base
        end
    end
    u.Root=root
    local oldDestroy=u.Destroy
    u.Destroy=function(self:any)
        for _,v in ipairs(con) do v:Disconnect() end
        if tween then tween:Cancel() end
        oldDestroy(self)
    end
    -- Keep the library's responsive settings; fit smaller displays when possible.
    local cam=workspace.CurrentCamera
    local function fit()
        if not cam then return end
        local v=cam.ViewportSize
        if v.X<760 or v.Y<500 then pcall(function() u:SetScale(math.max(.48,math.min(.95,(v.X-20)/680,(v.Y-20)/440))) end) end
    end
    if cam then bind(cam:GetPropertyChangedSignal("ViewportSize"),fit);fit() end
    u.Visible=false;c.Visible=false
    return u
end)()

env.__MoyXHubUIOnly=UI


return UI
end
local manifest:any={tabs={},controls={}}
local mock:any={}
function mock:Tab(n:string):any
 table.insert(manifest.tabs,n)
 local tab:any={}
 function tab:Section(_n:string):any
  local s:any={}
  function s:Button(v:any) table.insert(manifest.controls,{tab=n,title=v.Title,kind="button",callback=type(v.Callback)=="function"}) end
  function s:Toggle(v:any) table.insert(manifest.controls,{tab=n,title=v.Title,kind="toggle",callback=type(v.Callback)=="function"}) end
  function s:Slider(v:any) table.insert(manifest.controls,{tab=n,title=v.Title or v.Name,kind="slider",callback=type(v.Callback)=="function"});return {} end
  function s:Dropdown(v:any) table.insert(manifest.controls,{tab=n,title=v.Title or v.Name,kind="dropdown",callback=type(v.Callback)=="function"}) end
  function s:Label(v:any) table.insert(manifest.controls,{tab=n,title=type(v)=="string" and v or (v.Title or v.Text),kind="label",callback=true}) end
  return s
 end
 return tab
end
function mock:AddSettingsTab() table.insert(manifest.tabs,"SETTINGS") end
function mock:SetTitle(_s:string) end
function mock:SetStatus(_s:string) end
function mock:Toggle(_b:boolean) end
local e=getgenv()
local UI:any=if dry then mock else makeBase()
local a:any={actionBusy=false}
local p:any=game:GetService("Players").LocalPlayer
local rs:any=game:GetService("ReplicatedStorage")
local r:any=rs:WaitForChild("Remotes")
local f:any=require(rs:WaitForChild("FishingShared") :: any)
local bus:any=require(p.PlayerScripts:WaitForChild("StandBus") :: any)
local job:any={running=false,token=0,runs=0,spent=0,kind="",reason=""}
local refresh:any={enabled=false,token=0,ticks=0}
local reward:any={enabled=false,token=0,checks=0,claimed=0}
local nav:any={busy=false,token=0,result=""}
local function data():any return r.GetData:InvokeServer() end
local function base():any
 for _,b in ipairs(workspace:WaitForChild("Map"):WaitForChild("Bases"):GetChildren()) do if b:GetAttribute("OwnerUserId")==p.UserId then return b end end
 return nil
end
local function count(t:any):number local n=0;for _ in pairs(t or {}) do n+=1 end;return n end
local function money():string local d=data();return ("ปลา %s | เงิน $%s"):format(tostring(d.TotalCaught),tostring(d.Cash)) end
a.stats=money
a.netStatus=function()
 local b=base();return b and ("ตาข่าย %s | %s/%s ตัว"):format(tostring(b:GetAttribute("NetState")),tostring(b:GetAttribute("NetCount")),tostring(b:GetAttribute("NetCap"))) or "ไม่พบฐาน"
end
a.quests=function() local q:any=r.Contracts:InvokeServer("state");return "เควสสำเร็จ "..tostring(q.done).." | รายการ "..tostring(count(q.list)) end
a.rewards=function()local s:any=r.Rewards:InvokeServer("state");local n=0;for _,v in ipairs(s.gifts or {})do if v.ready and not v.claimed then n+=1 end end;return "รางวัลพร้อมรับ "..tostring(n).." | รายวัน "..(s.daily.claimable and "พร้อม" or "ไม่พร้อม")end
a.inventory=function()local d=data();local n=0;for _,v in pairs(d.Cooler or {})do n+=v.n or 0 end;return "คลังปลา "..tostring(n).." ตัว | "..tostring(count(d.Cooler)).." ชนิด" end
a.progress=function()local d=data();return "Rebirth "..tostring(d.Rebirths).." | ตาข่าย "..tostring(d.NetTier).." | ช่อง "..tostring(count(d.Showcase)).."/"..tostring(f.SlotCount(d))end
a.claimQuest=function()
 local q:any=r.Contracts:InvokeServer("state")
 for i,v in ipairs(q.list or {})do if v.done and v.k~="wait" and v.p>=v.goal then r.Contracts:InvokeServer("claim",i);local z:any=r.Contracts:InvokeServer("state");return z.done>q.done,"เควสสำเร็จ "..tostring(z.done)end end
 return false,"ไม่มีเควสพร้อมรับ"
end
a.claimDaily=function()
 local s:any=r.Rewards:InvokeServer("state")
 if not s.daily.claimable then return false,"รายวันยังไม่พร้อม" end
 r.Rewards:InvokeServer("claimDaily");local z:any=r.Rewards:InvokeServer("state");return not z.daily.claimable,"รางวัลรายวัน "..tostring(z.daily.streak)
end
a.claimCashGift=function()
 local s:any=r.Rewards:InvokeServer("state")
 for i,v in ipairs(s.gifts or {})do if v.ready and not v.claimed and v.kind=="Cash" then r.Rewards:InvokeServer("claimGift",i);local z:any=r.Rewards:InvokeServer("state");return z.gifts[i].claimed==true,"รับรางวัลเงิน" end end
 return false,"ไม่มีรางวัลเงินพร้อมรับ"
end
local function visible(x:any,root:any):boolean
 if not x or not root or not root.Enabled then return false end
 while x and x~=root do if x:IsA("GuiObject")and not x.Visible then return false end;x=x.Parent end
 return true
end
local function waitFor(fn:any,seconds:number):boolean
 local t=os.clock()+seconds;repeat if fn()then return true end;task.wait(.1)until os.clock()>t;return false
end
local function signal(b:any):boolean
 if not b or not b:IsA("GuiButton")then return false end
 local c:any=getconnections(b.MouseButton1Click)[1]
 if not c then return false end;c:Fire();return true
end
a.cooler=function()
 local g:any=p.PlayerGui:FindFirstChild("CoolerUI")
 if not g then return false,"ไม่พบคลัง" end
 if not visible(g:FindFirstChild("Window"),g)then bus.fire("Inventory")end
 return waitFor(function()return visible(g:FindFirstChild("Window"),g)end,4),"เปิดคลังปลา"
end
a.castOnce=function(continueFn:any?)
 local function canContinue()return not continueFn or continueFn()end
 if not canContinue()then return false,"หยุดแล้ว"end
 local b=base();local ch=p.Character;local hr=ch and ch:FindFirstChild("HumanoidRootPart")
 if not b or not hr or not f.OnOwnDock(b,hr.Position)then return false,"ต้องอยู่ท่าของตัวเอง"end
 if b:GetAttribute("NetState")~="Idle"then return false,"ตาข่ายกำลังทำงาน"end
 local g:any=p.PlayerGui:FindFirstChild("CoolerUI")
 if g and visible(g:FindFirstChild("Window"),g)then return false,"ปิดคลังปลาก่อน"end
 local function label(t:string):boolean
  local h:any=p.PlayerGui:FindFirstChild("CastHUD");local btn=h and h:FindFirstChild("ThrowNet",true)
  if not btn then return false end
  for _,x in ipairs(btn:GetDescendants())do if x:IsA("TextLabel")and x.Text==t and x.Visible then return true end end
  return false
 end
 if not waitFor(function()return label("THROW NET")or label("THROW!")end,3)then return false,"ปุ่มโยนยังไม่พร้อม"end
 if not canContinue()then return false,"หยุดแล้ว"end
 if label("THROW NET")then bus.fire("ThrowNetPress")end
 if not waitFor(function()return label("THROW!")end,3)then return false,"เล็งตาข่ายไม่สำเร็จ"end
 if not canContinue()then return false,"หยุดแล้ว"end
 bus.fire("ThrowNetPress")
 return waitFor(function()return b:GetAttribute("NetState")~="Idle"end,3),"ส่งคำสั่งโยนหนึ่งครั้ง"
end
local function common(d:any): (string?,any)
 local key:string?=nil;local best:any=nil;local rank=math.huge
 for k,v in pairs(d.Cooler or {})do local sp=f.SpeciesById[v.s]
  if type(k)=="string"and sp and sp.Rarity<=2 and(not v.mu or v.mu=="")and v.n>2 and f.CoolerFree(v)>2 then
   if sp.Rarity<rank or(sp.Rarity==rank and(not best or v.n>best.n))then key=k;best=v;rank=sp.Rarity end
  end
 end
 return key,best
end
a.commonInfo=function()local k,v=common(data());return k and "ปลาที่เลือก "..tostring(v.s).." | เหลือ "..tostring(v.n) or "ไม่มีปลาที่ผ่านเงื่อนไข"end
a.slotInfo=function()local d=data();return "ช่องวางปลา "..tostring(count(d.Showcase)).."/"..tostring(f.SlotCount(d))end
a.placeCommon=function()
 local d=data();local free=false
 for _,i in ipairs(f.OpenSlots(d))do if not d.Showcase[i]and not d.Showcase[tostring(i)]then free=true;break end end
 if not free then return false,"ไม่มีช่องว่าง"end
 local k=common(d);if not k then return false,"ไม่มีปลาธรรมดาที่เหลือพอ"end
 r.CoolerAction:InvokeServer("place",k);local z=data();return count(z.Showcase)==count(d.Showcase)+1,a.slotInfo()
end
a.sellCommon=function()
 local d=data();local k,v=common(d);if not k then return false,"ไม่มีปลาที่ขายได้"end
 r.CoolerAction:InvokeServer("release",k,1);local z=data();local n=z.Cooler[k]and z.Cooler[k].n or 0
 return n==v.n-1 and z.Cash>d.Cash,"ขาย "..tostring(v.s).." | คงเหลือ "..tostring(n)
end
a.netUpgradeInfo=function()local d=data();local n=f.Nets[d.NetTier+1];return n and tostring(n.Name).." | ราคา "..tostring(n.Cost)or "ระดับสูงสุด"end
a.upgradeNet=function()
 local d=data();local id=d.NetTier+1;local n=f.Nets[id]
 if not n or not f.NetRebirthOk(d,id)or d.Cash-n.Cost<50000 then return false,"ไม่ผ่านเงื่อนไข"end
 r.BuyItem:FireServer("Net",id);local ok=waitFor(function()return data().NetTier==id end,3);return ok,"ตาข่ายระดับ "..tostring(data().NetTier)
end
a.helperRod=function()
 local d=data();local id="Rod";local lv=d.Helper[id]or 0;local def=f.HelperById[id];local cost=f.HelperCost(id,lv)
 if not def or lv>=def.Max or not f.HelperLevelOk(d,def,lv+1)or d.Cash-cost<50000 then return false,"ไม่ผ่านเงื่อนไข"end
 r.HelperAction:InvokeServer("buy",id);local z=data();return z.Helper[id]==lv+1,"เบ็ดผู้ช่วย "..tostring(z.Helper[id])
end
a.boatEngine=function()
 local d=data();local lv=d.Boat.Engine or 0;local cost=f.BoatCost("Engine",lv)
 if d.Boat.Hull<=0 or lv>=f.BoatMaxLevel(d.Boat.Hull)or d.Cash-cost<50000 then return false,"เครื่องยนต์เต็มระดับหรือเงินไม่พอ"end
 r.BoatAction:InvokeServer("buy","Engine");local z=data();return z.Boat.Engine==lv+1,"เครื่องยนต์ "..tostring(z.Boat.Engine)
end
a.hullInfo=function()local d=data();local id=d.Boat.Hull+1;local h=f.Boat.Hulls[id];return h and ("%s | ราคา %s | Rebirth %s | %s"):format(tostring(h.Name),tostring(h.Cost),tostring(h.Rebirth or 0),f.BoatHullOk(d,id)and "ปลดล็อกแล้ว"or "ยังไม่ปลดล็อก")or "ตัวเรือระดับสูงสุด"end
a.upgradeHull=function()
 local d=data();local id=d.Boat.Hull+1;local h=f.Boat.Hulls[id]
 if not h or not f.BoatHullOk(d,id)or d.Cash-h.Cost<50000 then return false,"ยังไม่ปลดล็อกหรือเงินไม่พอ"end
 r.BoatAction:InvokeServer("buy","Hull");local z=data();return z.Boat.Hull==id,"ตัวเรือ "..tostring(z.Boat.Hull)
end
local function buyBait(id:string): (boolean,string,number)
 local d=data();local s:any=r.Tackle:InvokeServer("state");local cost=s.prices[id];local n=s.baits[id]or 0
 if not f.BaitUnlocked(d,id)or not cost or s.cash-cost<50000 then return false,"ไม่ผ่านเงื่อนไข",0 end
 r.Tackle:InvokeServer("buyBait",id,1);local z:any=r.Tackle:InvokeServer("state");local ok=(z.baits[id]or 0)==n+1
 return ok,"จำนวนเหยื่อ "..tostring(z.baits[id]),ok and cost or 0
end
a.buyBait=function()return buyBait("Crumbs")end
a.equipBait=function(id:string)
 local d=data();local s:any=r.Tackle:InvokeServer("state")
 if s.bait==id then return true,"ใช้เหยื่อนี้อยู่แล้ว"end
 if not f.BaitUnlocked(d,id)or(s.baits[id]or 0)<=0 then return false,"ไม่มีเหยื่อหรือยังไม่ปลดล็อก"end
 r.Tackle:InvokeServer("equipBait",id);local z:any=r.Tackle:InvokeServer("state");return z.bait==id,"เหยื่อปัจจุบัน "..tostring(z.bait)
end
a.petReady=function()local d=data();local s:any=r.Pets:InvokeServer("state");return "สัตว์เลี้ยง "..tostring(f.PetCount(d)).." | ช่อง "..tostring(s.slots)..(s.restricted and " | จำกัดสิทธิ์"or "")end
a.petInfo=a.petReady
a.crateInfo=function()local d=data();return "ไข่มุก "..tostring(d.Pearls).."/1000 | สัตว์เลี้ยง "..tostring(f.PetCount(d))end
a.rebirthInfo=function()local d=data();local ok,n=f.CanRebirth(d);return ("Rebirth %s | เงิน %s/%s | ปลา %s/%s | %s"):format(tostring(d.Rebirths),tostring(d.Cash),tostring(n and n.Cash or "?"),tostring(d.TotalCaught),tostring(n and n.Caught or "?"),ok and "พร้อม"or "ยังไม่พร้อม")end
a.preflight=function()return a.rebirthInfo().." | "..a.crateInfo().." | Auto Throw "..(p:GetAttribute("Pass_AutoThrow")==true and "พร้อม"or "ยังไม่มีสิทธิ์")end
a.openNativeSell=function()
 local ok=a.cooler();if not ok then return false,"เปิดคลังไม่สำเร็จ"end
 local g:any=p.PlayerGui.CoolerUI
 if not visible(g:FindFirstChild("UpMore",true),g)then signal(g:FindFirstChild("AutoSell",true))end
 return waitFor(function()return visible(g:FindFirstChild("UpMore",true),g)end,3),"เปิดเมนูขายอัตโนมัติ"
end
a.nativeSellProtect=function()
 local d=data();local cap=0;for i=1,2 do if d.CoolerSkip and d.CoolerSkip[tostring(i)]then cap=i else break end end
 if cap==0 then return false,"ยังไม่ได้เปิดขายอัตโนมัติ"end
 local x:any=r.CoolerAction:InvokeServer("simpleSet",cap,{keepMut=true,shuck=false});if not x or not x.ok then return false,"เกมไม่ยืนยัน"end
 local z=data();for i=1,cap do local t=z.SkipTypesR and z.SkipTypesR[tostring(i)]or z.SkipTypes or {};if not t.Normal then return false,"ไม่ยืนยันปลาปกติ"end;for k,v in pairs(t)do if k~="Normal"and v then return false,"ยังมี Mutation ที่ถูกขาย"end end end
 return true,"ขายเฉพาะปลาปกติระดับ 1–"..tostring(cap)
end
a.nativeAFK=function(on:boolean)
 local g:any=p.PlayerGui:FindFirstChild("AFKModeScreen");if not g then return false,"ไม่พบโหมด AFK"end
 if(p:GetAttribute("AFKScreen")==true)==on and g.Enabled==on then return true,"อยู่ในสถานะที่เลือกแล้ว"end
 if on then
  if(tonumber(p:GetAttribute("Rebirths"))or 0)<3 and(tonumber(p:GetAttribute("Ascensions"))or 0)<=0 then return false,"เปิด AFK เองได้เมื่อ Rebirth 3 หรือมี Ascension"end
  local bar=p.PlayerGui:FindFirstChild("AFKModeUI");local b=bar and bar:FindFirstChild("AFKBar")
  if not b or not b.Visible then return false,"ปุ่ม AFK ยังไม่พร้อม"end;bus.fire("AFKMode")
 else signal(g:FindFirstChild("AFKBack",true))end
 return waitFor(function()return(p:GetAttribute("AFKScreen")==true)==on and g.Enabled==on end,3),"สถานะ AFK"
end
a.openPetMenu=function()
 local g:any=p.PlayerGui:FindFirstChild("CoolerUI");if not g then return false,"ไม่พบคลัง"end
 if not visible(g:FindFirstChild("PetsView",true),g)then bus.fire("OpenPets")end
 return waitFor(function()return visible(g:FindFirstChild("PetsView",true),g)end,4),"เปิดหน้าสัตว์เลี้ยง"
end
local function setRebirthMenu(on:boolean)
 local g:any=p.PlayerGui:FindFirstChild("RebirthUI")
 local w=g and g:FindFirstChild("Window")
 if not w then return false,"ไม่พบหน้า Rebirth" end
 local function isOpen()return g.Enabled and w.Visible end
 if isOpen()~=on then
  local dock=p.PlayerGui:FindFirstChild("HudDock")
  local holder=dock and dock:FindFirstChild("RebirthButton",true)
  if not signal(holder and holder:FindFirstChild("Hit"))then return false,"ไม่พบปุ่มเปิดปิดของเกม" end
 end
 local ok=waitFor(function()return isOpen()==on end,4)
 return ok,ok and (on and "เปิดหน้า Rebirth เท่านั้น" or "ปิดหน้า Rebirth แล้ว") or "หน้า Rebirth ยังไม่ตอบสนอง"
end
a.openRebirthMenu=function()return setRebirthMenu(true)end
a.closeRebirthMenu=function()return setRebirthMenu(false)end
local runtimeAlive=true
local function alive():boolean return not dry and runtimeAlive and e.__MoyXHubUIOnly==UI end
a.refreshMain=function()
 local d=data();local msg=("ปลา %s | เงิน $%s | %s"):format(tostring(d.TotalCaught),tostring(d.Cash),a.netStatus())
 if not dry then local main=UI.Root:FindFirstChild("Page_MAIN",true);if main then for _,v in ipairs(main:GetDescendants())do if v:IsA("TextLabel")and v.Name=="Title"and v.Text:find("ปลา ",1,true)and v.Text:find("ตาข่าย",1,true)then v.Text=msg;break end end end end
 return true,msg
end
a.rewardCycle=function()
 local n=0;local ok=a.claimQuest();if ok then n+=1 end
 local s:any=r.Rewards:InvokeServer("state");local d=s.daily;local nextDay=d.days and d.days[d.day]
 if d.claimable and nextDay and nextDay.kind=="Cash"then if a.claimDaily()then n+=1 end end
 if a.claimCashGift()then n+=1 end;return n
end
local refreshSeconds=5
local function periodic(state:any,on:boolean,seconds:any,fn:any)
 if state.enabled==on then return end;state.enabled=on;state.token+=1;local token=state.token
 if not on then return end
 task.spawn(function()
  while state.enabled and state.token==token and alive()do
   if not a.actionBusy and not (a.autoPlayState and a.autoPlayState.enabled) then a.actionBusy=true;local ok,n=pcall(fn);a.actionBusy=false
    if ok then if state==reward then state.checks+=1;state.claimed+=n else state.ticks+=1 end end
   end;task.wait(type(seconds)=="function" and seconds() or seconds)
  end
 end)
end
a.setRefresh=function(on:boolean)periodic(refresh,on,function()return refreshSeconds end,a.refreshMain)end
a.setRewardLoop=function(on:boolean)periodic(reward,on,15,a.rewardCycle)end
a.stopJob=function()job.token+=1;job.running=false;job.reason="หยุดโดยผู้ใช้"end
a.jobInfo=function()return ("งาน %s | %s | %s ครั้ง | ใช้เงิน %s"):format(tostring(job.kind),tostring(job.reason),tostring(job.runs),tostring(job.spent))end
a.startJob=function(kind:string,limit:number,budget:number)
 if not alive() then return false,"UI ไม่พร้อม" end
 if type(limit)~="number" or limit~=math.floor(limit) or limit<1 or limit>(kind=="place" and 7 or 3) or type(budget)~="number" or budget<0 or budget>10000 or budget~=budget then return false,"ค่าตั้งงานไม่ถูกต้อง" end
 if job.running or a.actionBusy or (a.autoPlayState and a.autoPlayState.enabled) then return false,"มีงานกำลังทำงาน"end
 if kind~="place"and kind~="net"and kind~="helper"and kind~="boat"and kind~="bait"then return false,"ไม่รองรับ"end
 job.token+=1;local token=job.token;job.running=true;job.kind=kind;job.runs=0;job.spent=0;job.reason=""
 task.spawn(function()
  while job.running and job.token==token and alive()do
   if job.runs>=limit then job.reason="ครบจำนวนที่กำหนด";break end
   if not a.actionBusy then
    a.actionBusy=true
    local ok,yes,msg,cost=pcall(function()
     local d=data();local price=0;local fn:any=nil
     if kind=="place"then fn=a.placeCommon
     elseif kind=="net"then local id=d.NetTier+1;local n=f.Nets[id];if not n or not f.NetRebirthOk(d,id)then return false,"ยังไม่ปลดล็อก",0 end;price=n.Cost;fn=a.upgradeNet
     elseif kind=="helper"then local lv=d.Helper.Rod or 0;local def=f.HelperById.Rod;if lv>=def.Max or not f.HelperLevelOk(d,def,lv+1)then return false,"ผู้ช่วยยังไม่ผ่านเงื่อนไข",0 end;price=f.HelperCost("Rod",lv);fn=a.helperRod
     elseif kind=="boat"then local lv=d.Boat.Engine or 0;if d.Boat.Hull<=0 or lv>=f.BoatMaxLevel(d.Boat.Hull)then return false,"เครื่องยนต์เต็มระดับ",0 end;price=f.BoatCost("Engine",lv);fn=a.boatEngine
     else local s:any=r.Tackle:InvokeServer("state");local id=s.bait;if type(id)~="string"or id==""or not f.BaitUnlocked(d,id)then return false,"ไม่มีเหยื่อที่เลือก",0 end;if(s.baits[id]or 0)>=10 then return false,"เหยื่อครบ 10 ชิ้น",0 end;price=s.prices[id];fn=function()return buyBait(id)end end
     if type(price)~="number"or job.spent+price>budget or d.Cash-price<50000 then return false,"ถึงขีดจำกัดงบ",0 end
     if not job.running or job.token~=token or not alive() then return false,"หยุดก่อนส่งคำสั่ง",0 end
     local success,message=fn();return success,message,success and price or 0
    end)
    a.actionBusy=false;if job.token~=token then break end
    if not ok or not yes then job.reason=ok and tostring(msg)or "คำสั่งผิดพลาด";break end
    job.runs+=1;job.spent+=cost
   end;task.wait(1)
  end
  if job.token==token then job.running=false;if job.reason==""then job.reason="จบงาน"end;UI:SetStatus(a.jobInfo())end
 end)
 return true,"เริ่มงาน"
end
nav.stop=function()nav.token+=1;nav.busy=false;local c=p.Character;local h=c and c:FindFirstChildOfClass("Humanoid");local hr=c and c:FindFirstChild("HumanoidRootPart");if h and hr then h:MoveTo(hr.Position)end end
nav.nearest=function(action:string):any
 local b=base();if not b then return nil end
 local ch=p.Character;local hr=ch and ch:FindFirstChild("HumanoidRootPart");if not hr then return nil end
 local nearest:any=nil;local dist=math.huge
 for _,v in ipairs(b:GetDescendants())do if v:IsA("ProximityPrompt")and v.ActionText==action and v.Enabled then local parent=v.Parent;local pos:any=nil;if parent:IsA("BasePart")then pos=parent.Position elseif parent:IsA("Attachment")then pos=parent.WorldPosition end;if pos then local d=(pos-hr.Position).Magnitude;if d<dist then dist=d;nearest=pos end end end end
 return nearest
end
nav.navigate=function(action:string)
 local pos=nav.nearest(action);if not pos then return false,"ไม่พบจุดหมายที่เปิดใช้งาน"end
 local radius=4
 local own=base()
 if own then
  for _,v in ipairs(own:GetDescendants())do
   if v:IsA("ProximityPrompt") and v.ActionText==action and v.Enabled then
    local par=v.Parent;local pt:any=nil
    if par:IsA("BasePart")then pt=par.Position elseif par:IsA("Attachment")then pt=par.WorldPosition end
    if pt and (pt-pos).Magnitude<.1 then radius=math.max(2,v.MaxActivationDistance-.5);break end
   end
  end
 end
 nav.stop();local token=nav.token;nav.busy=true
 task.spawn(function()
  local ok,err=pcall(function()
   local ch=p.Character;local h=ch and ch:FindFirstChildOfClass("Humanoid");local hr=ch and ch:FindFirstChild("HumanoidRootPart");if not h or not hr then error("ตัวละครไม่พร้อม")end
   local function arrived():boolean return (hr.Position-pos).Magnitude<=radius end
   if arrived()then return end
   local path=game:GetService("PathfindingService"):CreatePath();path:ComputeAsync(hr.Position,pos)
   if path.Status~=Enum.PathStatus.Success then error("ไม่พบเส้นทาง")end
   for _,w in ipairs(path:GetWaypoints())do
    if nav.token~=token or not alive()then return end
    if arrived()then break end
    if w.Action==Enum.PathWaypointAction.Jump then h.Jump=true end;h:MoveTo(w.Position)
    local reached=waitFor(function()
     local delta=hr.Position-w.Position
     return nav.token~=token or arrived() or Vector2.new(delta.X,delta.Z).Magnitude<2.5
    end,5)
    if not reached then error("เดินไม่ถึงจุดหมาย")end
   end
   if nav.token==token then h:MoveTo(hr.Position);if not arrived()then error("อยู่นอกระยะใช้งาน")end end
  end)
  if nav.token==token then nav.busy=false;nav.result=ok and "ถึงจุดหมาย"or tostring(err);UI:SetStatus(nav.result)end
 end)
 return true,"เริ่มเดินไป "..action
end
nav.stats=a.stats
local function autoBuyStep(state:any,quote:any,purchase:any,active:any)
 local keys=state.order
 for offset=1,#keys do
  local i=(state.cursor+offset-1)%#keys+1
  local key=keys[i]
  if state.enabled[key] and active(key) then
   local q=quote(key)
   if q and q.allowed and type(q.cost)=="number" and q.cost>=0 and q.cost==q.cost and type(q.cash)=="number" and q.cost<=state.cap and q.cash-q.cost>=state.reserve then
    if not active(key) then return "cancelled",key end
    state.cursor=i
    local ok,msg=purchase(key,q)
    if ok then state.spent+=q.cost;state.runs+=1;return "bought",key,msg end
    return "uncertain",key,msg
   end
  end
 end
 return "waiting"
end
local buyState:any={order={"net","Rod","Speed","Line","Range","Tackle","Shiny","Bait","Hull","Engine","Trawl","bait"},enabled={},cursor=0,cap=100000,reserve=50000,target=10,interval=10,running=false,token=0,runs=0,spent=0,status="ปิด",widgets={}}
local function autoQuote(key:string):any
 local d=data()
 if type(d)~="table" or type(d.Cash)~="number" then return nil end
 if key=="net" then
  local id=d.NetTier+1;local n=f.Nets[id];if not n then return nil end
  return {allowed=f.NetRebirthOk(d,id),cash=d.Cash,cost=n.Cost,next=id}
 elseif key=="Hull" then
  local id=d.Boat.Hull+1;local h=f.Boat.Hulls[id];if not h then return nil end
  return {allowed=f.BoatHullOk(d,id),cash=d.Cash,cost=h.Cost,next=id}
 elseif key=="Engine" or key=="Trawl" then
  local lv=d.Boat[key] or 0
  return {allowed=d.Boat.Hull>0 and lv<f.BoatMaxLevel(d.Boat.Hull),cash=d.Cash,cost=f.BoatCost(key,lv),next=lv+1}
 elseif key=="bait" then
  local t:any=r.Tackle:InvokeServer("state")
  local id=t and t.bait
  if type(id)~="string" or id=="" or type(t.baits)~="table" or type(t.prices)~="table" or type(t.cash)~="number" then return nil end
  local n=t.baits[id] or 0
  return {allowed=n<buyState.target and f.BaitUnlocked(d,id),cash=math.min(t.cash,d.Cash),cost=t.prices[id],next=n+1,id=id}
 else
  local def=f.HelperById[key];if not def then return nil end
  local lv=d.Helper[key] or 0
  return {allowed=lv<def.Max and f.HelperLevelOk(d,def,lv+1),cash=d.Cash,cost=f.HelperCost(key,lv),next=lv+1}
 end
end
local function autoPurchase(key:string,q:any)
 if key=="net" then r.BuyItem:FireServer("Net",q.next)
 elseif key=="Hull" or key=="Engine" or key=="Trawl" then r.BoatAction:InvokeServer("buy",key)
 elseif key=="bait" then r.Tackle:InvokeServer("buyBait",q.id,1)
 else r.HelperAction:InvokeServer("buy",key) end
 local ok=waitFor(function()
  if key=="bait" then local t:any=r.Tackle:InvokeServer("state");return type(t)=="table" and type(t.baits)=="table" and (t.baits[q.id] or 0)>=q.next end
  local d=data()
  if key=="net" then return d.NetTier==q.next end
  if key=="Hull" or key=="Engine" or key=="Trawl" then return d.Boat[key]==q.next end
  return d.Helper[key]==q.next
 end,3)
 return ok,ok and ("ซื้อสำเร็จ "..key) or ("ยังไม่ยืนยัน "..key)
end
a.stopPurchases=function()
 buyState.token+=1;buyState.running=false
 for _,k in ipairs(buyState.order)do buyState.enabled[k]=false;local w=buyState.widgets[k];if w then pcall(function()w:Set(false,true)end)end end
 buyState.status="ปิด"
end
a.autoBuyInfo=function()return ("ซื้ออัตโนมัติ | %s | %s ครั้ง | ใช้ $%s"):format(buyState.status,tostring(buyState.runs),tostring(buyState.spent))end
a.setAutoPurchase=function(key:string,on:boolean)
 if not table.find(buyState.order,key) or not alive()then return end
 buyState.enabled[key]=on
 local any=false;for _,k in ipairs(buyState.order)do if buyState.enabled[k] then any=true;break end end
 if not any then a.stopPurchases();return end
 if buyState.running then return end
 buyState.token+=1;local token=buyState.token;buyState.running=true;buyState.status="รอเงินและเงื่อนไข"
 task.spawn(function()
  while alive() and buyState.running and buyState.token==token do
   if not a.actionBusy and not job.running and not (a.autoPlayState and a.autoPlayState.enabled) then
    a.actionBusy=true
    local ok,result,keyName,msg=pcall(autoBuyStep,buyState,autoQuote,autoPurchase,function(k:string)return alive() and buyState.running and buyState.token==token and buyState.enabled[k]==true and not job.running end)
    a.actionBusy=false
    if buyState.token~=token then break end
    if not ok or result=="uncertain" then a.stopPurchases();buyState.status="หยุด: คำสั่งไม่ยืนยัน";if alive()then UI:SetStatus(a.autoBuyInfo())end;break
    elseif result=="bought" then buyState.status=tostring(msg);if alive()then UI:SetStatus(a.autoBuyInfo())end
    elseif result=="waiting" then buyState.status="รอเงินและเงื่อนไข" end
   end
   task.wait(buyState.interval)
  end
 end)
end
a.autoBuyState=buyState
local function autoToggle(sec:any,key:string,name:string)
 buyState.widgets[key]=sec:Toggle({Title=name,Name=name,Default=false,Callback=function(on:boolean)a.setAutoPurchase(key,on)end})
end
local function playRound(active:any,steps:any,report:any)
 for i=1,7 do
  if not active() then return "cancelled",i end
  report(i)
  local result=steps[i]()
  if result=="uncertain" or result=="waiting" or result=="cancelled" then return result,i end
 end
 return "complete",7
end
local function bestPetPlan(st:any,defs:any,metric:any)
 if type(st)~="table"or type(st.pets)~="table"or type(st.equipN)~="table"or st.restricted then return nil,nil,nil,"ข้อมูลไม่พร้อมหรือจำกัดสิทธิ์"end
 local slots=tonumber(st.slots)
 if not slots or slots<1 or slots>4 or slots~=math.floor(slots)then return nil,nil,nil,"จำนวนช่องไม่ถูกต้อง"end
 local used:any={};local weak:any=nil;local weakSlot:number?=nil;local empty:number?=nil
 local function better(x:any,y:any):boolean
  if x.mult~=y.mult then return x.mult>y.mult end
  if x.trip~=y.trip then return x.trip<y.trip end
  return x.cap>y.cap
 end
 for i=1,slots do
  local id=st.equipN[i]
  if id then
   if not defs[id]then return nil,nil,nil,"ไม่รู้จักสัตว์ที่สวมใส่"end
   used[id]=(used[id]or 0)+1
   local m=metric(defs[id],st)
   if not weak or better(weak,m)then weak=m;weakSlot=i end
  elseif not empty then empty=i end
 end
 local best:any=nil;local bestId:string?=nil
 for id,n in pairs(st.pets)do
  if defs[id]and type(n)=="number"and n>(used[id]or 0)then
   local m=metric(defs[id],st)
   if not best or better(m,best)or(not better(best,m)and not better(m,best)and id<(bestId or ""))then best=m;bestId=id end
  end
 end
 if not bestId then return nil,nil,nil,"ไม่มีสัตว์สำรอง"end
 local slot=empty or weakSlot
 if not slot or(not empty and not better(best,weak))then return nil,nil,nil,"สวมใส่ตัวที่ดีที่สุดแล้ว"end
 return bestId,slot,st.equipN[slot]or false,"พร้อมสวมใส่ "..bestId
end
local function bestPetStep(read:any,equip:any,active:any,defs:any,metric:any)
 local id,slot,old,msg=bestPetPlan(read(),defs,metric)
 if not id or not slot then return "skip",msg end
 if not active()then return "cancelled","หยุดแล้ว"end
 local nextId,nextSlot,nextOld=bestPetPlan(read(),defs,metric)
 if nextId~=id or nextSlot~=slot or nextOld~=old then return "skip","ข้อมูลเปลี่ยน รอตรวจใหม่"end
 if not active()then return "cancelled","หยุดแล้ว"end
 local sent=pcall(equip,id,slot)
 if not sent then return "uncertain","ส่งคำสั่งไม่สำเร็จ"end
 local st=read()
 if type(st)=="table"and type(st.equipN)=="table"and st.equipN[slot]==id then return "equipped","สวมใส่ "..id.." ช่อง "..tostring(slot)end
 return "uncertain","เซิร์ฟเวอร์ยังไม่ยืนยัน"
end
local petAuto:any={enabled=false,token=0,checks=0,changed=0,status="ปิด",widget=nil}
a.petAutoState=petAuto
local function petMetric(def:any,st:any)
 local lv=math.clamp(tonumber(type(st.lv)=="table"and st.lv[def.Id])or 1,1,f.PetMaxLevel)
 return {mult=f.PetMultAt(def,lv),trip=f.PetTripAt(def,lv),cap=def.Count or def.Cap or 0}
end
local function petAutoTick(active:any)
 local status,msg=bestPetStep(function()return r.Pets:InvokeServer("state")end,function(id:string,slot:number)return r.Pets:InvokeServer("equip",id,slot)end,active,f.PetById,petMetric)
 petAuto.checks+=1;petAuto.status=msg
 if status=="equipped"then petAuto.changed+=1 end
 if status=="uncertain"then a.setBestPet(false);petAuto.status=msg end
 return status
end
a.bestPetInfo=function()return ("สัตว์เลี้ยง | %s | ตรวจ %s | เปลี่ยน %s"):format(petAuto.status,tostring(petAuto.checks),tostring(petAuto.changed))end
a.setBestPet=function(on:boolean)
 if petAuto.enabled==on then return end
 petAuto.enabled=on;petAuto.token+=1;local token=petAuto.token
 if not on then petAuto.status="ปิด";if petAuto.widget then petAuto.widget:Set(false,true)end;return end
 petAuto.status="รอตรวจ"
 task.spawn(function()
  while alive()and petAuto.enabled and petAuto.token==token do
   if not a.actionBusy and not job.running and not nav.busy and not(a.autoPlayState and a.autoPlayState.enabled)then
    a.actionBusy=true;local ok=pcall(petAutoTick,function()return alive()and petAuto.enabled and petAuto.token==token end);a.actionBusy=false
    if not ok then a.setBestPet(false);petAuto.status="หยุด: ตรวจไม่สำเร็จ"end
    if alive()then pcall(function()UI:SetStatus(a.bestPetInfo())end)end
   end
   task.wait(15)
  end
 end)
end
local playState:any={enabled=false,token=0,running=false,rounds=0,successful=0,lastActions=0,casts=0,fishCaught=0,step=0,interval=10,status="ปิด",mode="เน้นหาเงิน",widget=nil}
local playNames={"รีเฟรชข้อมูล","รับรางวัลและเควส","ตรวจเติมเหยื่อ","โยนตาข่ายเมื่อพร้อม","รอรอบจับปลาจบ","จัดการปลาธรรมดา","ตรวจอัปเกรด"}
a.autoPlayState=playState
a.autoPlayInfo=function()
 return ("Auto Play | %s | ตรวจ %s รอบ | สำเร็จ %s งาน"):format(playState.status,tostring(playState.rounds),tostring(playState.successful))
end
a.setAutoPlay=function(on:boolean)
 if playState.enabled==on then return end
 if not on then
  playState.enabled=false;playState.running=false;playState.token+=1;playState.status="ปิด"
  if playState.widget then playState.widget:Set(false,true)end
  return
 end
 if not alive()or job.running or nav.busy then if playState.widget then playState.widget:Set(false,true)end;return end
 playState.enabled=true;playState.running=true;playState.token+=1;playState.status="กำลังทำงาน"
 local token=playState.token
 local function active()return alive()and playState.enabled and playState.token==token end
 local function guarded(fn:any)
  if not active()then return "cancelled"end
  if a.actionBusy or job.running or nav.busy then return "waiting"end
  a.actionBusy=true;local ok,res=pcall(fn);a.actionBusy=false
  if not ok then return "uncertain"end
  return res
 end
 local actions=0
 local needsCast=false
 local castStarted=false
 local caughtBefore=0
 local castNote=""
 local function buyOne(baitOnly:boolean)
  if playState.mode~="อัปเกรดตามงบ"then return "skip" end
  local result=autoBuyStep(buyState,autoQuote,autoPurchase,function(k:string)
   return active()and buyState.enabled[k]==true and ((k=="bait")==baitOnly)and not job.running
  end)
  if result=="uncertain"then return result end
  if result=="bought"then actions+=1 end
  return "done"
 end
 local steps:any={
  function()return guarded(function()a.refreshMain()end)end,
  function()return guarded(function()local n=a.rewardCycle();reward.checks+=1;reward.claimed+=n;actions+=n end)end,
  function()return guarded(function()return buyOne(true)end)end,
  function()return guarded(function()
   local b=base();if not b then castNote="ไม่พบฐาน";return "waiting"end
   if b:GetAttribute("NetState")~="Idle" then return "done"end
   caughtBefore=tonumber(data().TotalCaught) or 0
   if not active()then return "cancelled"end
   local ok,msg=a.castOnce(active)
   if not active()then return "cancelled"end
   if not ok then needsCast=true;castNote=tostring(msg);return "done"end
   castStarted=true;playState.casts+=1
   return "done"
  end)end,
  function()
   local b=base();if not b then return "waiting"end
   local deadline=os.clock()+25
   while active()and b.Parent and b:GetAttribute("NetState")~="Idle"and os.clock()<deadline do task.wait(.25)end
   if not active()then return "cancelled"end
   if not b.Parent or b:GetAttribute("NetState")~="Idle"then return "waiting"end
   if castStarted then local n=math.max(0,(tonumber(data().TotalCaught)or 0)-caughtBefore);playState.fishCaught+=n;if n>0 then actions+=1 end end
   return "done"
  end,
  function()return guarded(function()if a.placeCommon()then actions+=1 end;if active()and a.sellCommon()then actions+=1 end end)end,
  function()return guarded(function()if petAuto.enabled then local result=petAutoTick(function()return active()and petAuto.enabled end);if result=="equipped"then actions+=1 end;if result=="uncertain"then return "done"end end;if not active()then return "cancelled"end;return buyOne(false)end)end
 }
 task.spawn(function()
  while active()do
   actions=0;needsCast=false;castStarted=false;castNote=""
   local ok,result=pcall(playRound,active,steps,function(i:number)playState.step=i;playState.status="กำลังตรวจขั้น "..tostring(i);if alive()then UI:SetStatus(a.autoPlayInfo())end end)
   if not active()then break end
   if not ok or result=="uncertain"then a.setAutoPlay(false);a.stopPurchases();playState.status="หยุด: คำสั่งไม่ยืนยัน";if alive()then UI:SetStatus(a.autoPlayInfo())end;break
   elseif result=="complete"then playState.rounds+=1;playState.lastActions=actions;playState.successful+=actions;playState.status=if actions>0 then "ทำสำเร็จ "..tostring(actions).." งาน" elseif needsCast then castNote else "ยังไม่มีงานที่พร้อม"
   elseif result=="waiting"then playState.status="รอระบบพร้อม" end
   if alive()then UI:SetStatus(a.autoPlayInfo())end
   task.wait(playState.interval)
  end
 end)
end
local function cleanup()
 a.setBestPet(false);a.setAutoPlay(false);a.stopJob();a.stopPurchases();a.setRewardLoop(false);a.setRefresh(false);nav.stop()
end
a.stopAll=function()
 cleanup()
 if not dry then
  for _,v in ipairs(UI.Root:GetDescendants())do if v:IsA("TextLabel")and(v.Text=="รีเฟรชข้อมูลอัตโนมัติ"or v.Text=="รับรางวัลที่พร้อมอัตโนมัติ")then local b=v.Parent:FindFirstChild("Bead",true);if b and b:IsA("GuiObject")and b.Position.X.Scale>.5 then signal(v.Parent:FindFirstChildWhichIsA("GuiButton",true))end end end
 end
 return true,"หยุดทุกงานแล้ว"
end
local function button(s:any,n:string,desc:string,fn:any)
 assert(type(fn)=="function","Missing callback: "..n)
 s:Button({Title=n,Name=n,Description=desc,Callback=function()
  if not alive()or a.actionBusy then return end;a.actionBusy=true
  local ok,x,y=pcall(fn);a.actionBusy=false;UI:SetStatus(ok and tostring(y or x)or "เกิดข้อผิดพลาด")
 end})
end
UI:SetTitle("MoyXHub | จับปลา!")
local main:any=UI:Tab("MAIN")
local fishTab:any=UI:Tab("FISHING")
local invTab:any=UI:Tab("INVENTORY")
local upTab:any=UI:Tab("UPGRADE")
local questTab:any=UI:Tab("QUESTS")
local progressTab:any=UI:Tab("PROGRESS")
local travelTab:any=UI:Tab("TRAVEL")
local autoTab:any=UI:Tab("AUTO")
UI:AddSettingsTab()
local function group(tab:any,n:string,defs:any):any
 local sec:any=tab:Section(n)
 for _,v in ipairs(defs)do button(sec,v[1],v[2]or "ตรวจเงื่อนไขก่อนทำงาน",a[v[3]])end
 return sec
end
local m:any=main:Section("ภาพรวมผู้เล่น")
m:Label("ปลา 0 | เงิน $0 | ตาข่าย Idle")
button(m,"ตรวจสอบสถิติล่าสุด","อ่านข้อมูลจริง",a.refreshMain)
local info:any=main:Section("อัปเดตข้อมูล")
info:Toggle({Title="รีเฟรชข้อมูลอัตโนมัติ",Name="รีเฟรชข้อมูลอัตโนมัติ",Default=false,Callback=a.setRefresh})
a.uiSliders={}
a.uiSliders.refresh=info:Slider({Name="ช่วงรีเฟรชข้อมูล",Min=5,Max=30,Step=5,Default=5,Suffix=" วินาที",Callback=function(v:number)refreshSeconds=math.clamp(math.floor(v/5+.5)*5,5,30)end})
a.getRefreshInterval=function()return refreshSeconds end

group(fishTab,"จับปลา",{{"โยนตาข่ายหนึ่งครั้ง",nil,"castOnce"},{"ตรวจสอบสถานะตาข่าย",nil,"netStatus"}})
local baitSection:any=group(fishTab,"เหยื่อ",{{"ซื้อเหยื่อขนมปัง 1 ชิ้น",nil,"buyBait"}})
local baitChoice="ไส้เดือน"
if not dry then local ok,st=pcall(function()return r.Tackle:InvokeServer("state")end);if ok and st and st.bait=="Crumbs"then baitChoice="ขนมปัง"end end
local baitMap:any={["ขนมปัง"]="Crumbs",["ไส้เดือน"]="Crawlers"}
baitSection:Dropdown({Title="เลือกเหยื่อ",Name="เลือกเหยื่อ",Description="เลือกก่อนกดยืนยัน",Options={"ขนมปัง","ไส้เดือน"},Default=baitChoice,Callback=function(v:any)if type(v)=="string"and baitMap[v]then baitChoice=v end end})
button(baitSection,"ใช้เหยื่อที่เลือก","ยืนยันเปลี่ยนเหยื่อ",function()return a.equipBait(baitMap[baitChoice])end)
local baitAuto:any=fishTab:Section("เติมเหยื่ออัตโนมัติ")
autoToggle(baitAuto,"bait","Auto เติมเหยื่อปัจจุบัน")
a.uiSliders.baitTarget=baitAuto:Slider({Name="จำนวนเหยื่อเป้าหมาย",Min=1,Max=20,Step=1,Default=10,Suffix=" ชิ้น",Callback=function(v:number)buyState.target=math.clamp(math.floor(v+.5),1,20)end})

group(invTab,"คลังปลา",{{"เปิดกล่องปลา",nil,"cooler"},{"ข้อมูลคลังปลา",nil,"inventory"},{"ตรวจปลาธรรมดาที่เลือก",nil,"commonInfo"}})
group(invTab,"ช่องจัดแสดงปลา",{{"ตรวจช่องวางปลา",nil,"slotInfo"},{"วางปลาธรรมดา 1 ตัว",nil,"placeCommon"}})
group(invTab,"ขายปลา",{{"ขายปลาธรรมดา 1 ตัว",nil,"sellCommon"},{"ตั้งค่าขายอัตโนมัติของเกม","ใช้เมนูปกติ","openNativeSell"},{"เก็บปลา Mutation ใน Auto Sell","เก็บปลา Mutation","nativeSellProtect"}})
group(upTab,"ตาข่าย",{{"ตรวจราคาอัปเกรด",nil,"netUpgradeInfo"},{"อัปเกรดตาข่าย 1 ระดับ",nil,"upgradeNet"}})
group(upTab,"อัปเกรดด่วน",{{"อัปเกรดเบ็ดผู้ช่วย",nil,"helperRod"},{"อัปเกรดเครื่องยนต์เรือ",nil,"boatEngine"}})
group(upTab,"ตัวเรือ",{{"ตรวจราคาและเงื่อนไขตัวเรือ",nil,"hullInfo"},{"อัปเกรดตัวเรือ 1 ระดับ",nil,"upgradeHull"}})
local helperOptions:any={["เบ็ดตกปลา"]="Rod",["ความเร็ว"]="Speed",["ความจุถัง"]="Line",["ระยะตกปลา"]="Range",["กล่องอุปกรณ์"]="Tackle",["ตะขอประกาย"]="Shiny",["เหยื่อน้ำลึก"]="Bait"}
local boatOptions:any={["เครื่องยนต์"]="Engine",["ตาข่ายลาก"]="Trawl"}
local helperChoice="ความจุถัง"
local boatChoice="ตาข่ายลาก"
local function upgradeQuote(kind:string,id:string):any
 local d=data()
 if kind=="helper" then
  local def=f.HelperById[id];if not def then return nil end
  local lv=d.Helper[id] or 0
  return {level=lv,max=def.Max,cost=f.HelperCost(id,lv),allowed=lv<def.Max and f.HelperLevelOk(d,def,lv+1),cash=d.Cash}
 end
 if id~="Engine" and id~="Trawl" then return nil end
 local lv=d.Boat[id] or 0;local max=f.BoatMaxLevel(d.Boat.Hull)
 return {level=lv,max=max,cost=f.BoatCost(id,lv),allowed=d.Boat.Hull>0 and lv<max,cash=d.Cash}
end
local function quoteText(q:any):string
 if not q then return "ไม่พบรายการ" end
 return ("ระดับ %s/%s | ราคา $%s | %s"):format(tostring(q.level),tostring(q.max),tostring(q.cost),q.allowed and "ปลดล็อก" or "ยังไม่พร้อม/เต็มระดับ")
end
local function selectedUpgrade(kind:string,id:string): (boolean,string)
 local q=upgradeQuote(kind,id)
 if not q or not q.allowed then return false,quoteText(q) end
 if type(q.cost)~="number" or q.cost<0 or q.cost>10000 or q.cash-q.cost<50000 then return false,"เกินงบ $10000 หรือเงินสำรองไม่พอ | "..quoteText(q) end
 local remote:any=if kind=="helper" then r.HelperAction else r.BoatAction
 remote:InvokeServer("buy",id)
 local z=upgradeQuote(kind,id)
 local ok=z and z.level==q.level+1
 return ok==true,(ok and "อัปเกรดสำเร็จ | " or "ยังไม่ยืนยัน | ")..quoteText(z)
end
a.selectedUpgrade=selectedUpgrade
a.upgradeQuote=upgradeQuote
local upgrades:any=upTab:Section("เลือกอุปกรณ์อัปเกรด")
upgrades:Dropdown({Title="เลือกอุปกรณ์ผู้ช่วย",Name="เลือกอุปกรณ์ผู้ช่วย",Options={"เบ็ดตกปลา","ความเร็ว","ความจุถัง","ระยะตกปลา","กล่องอุปกรณ์","ตะขอประกาย","เหยื่อน้ำลึก"},Default=helperChoice,Callback=function(v:any)if helperOptions[v] then helperChoice=v end end})
button(upgrades,"ตรวจราคาผู้ช่วยที่เลือก","อ่านระดับและราคา",function()return quoteText(upgradeQuote("helper",helperOptions[helperChoice]))end)
button(upgrades,"ยืนยันอัปเกรดผู้ช่วยที่เลือก","งบต่อครั้ง $10000",function()return selectedUpgrade("helper",helperOptions[helperChoice])end)
upgrades:Dropdown({Title="เลือกอุปกรณ์เรือ",Name="เลือกอุปกรณ์เรือ",Options={"เครื่องยนต์","ตาข่ายลาก"},Default=boatChoice,Callback=function(v:any)if boatOptions[v] then boatChoice=v end end})
button(upgrades,"ตรวจราคาเรือที่เลือก","อ่านระดับและราคา",function()return quoteText(upgradeQuote("boat",boatOptions[boatChoice]))end)
button(upgrades,"ยืนยันอัปเกรดเรือที่เลือก","งบต่อครั้ง $10000",function()return selectedUpgrade("boat",boatOptions[boatChoice])end)

local netAuto:any=upTab:Section("อัปเกรดตาข่ายอัตโนมัติ")
autoToggle(netAuto,"net","Auto ตาข่าย")
local helperAuto:any=upTab:Section("อัปเกรดผู้ช่วยอัตโนมัติ")
for _,v in ipairs({{"Rod","Auto เบ็ดผู้ช่วย"},{"Speed","Auto ความเร็วผู้ช่วย"},{"Line","Auto ความจุถัง"},{"Range","Auto ระยะตกปลา"},{"Tackle","Auto กล่องอุปกรณ์"},{"Shiny","Auto ตะขอประกาย"},{"Bait","Auto เหยื่อน้ำลึก"}})do autoToggle(helperAuto,v[1],v[2])end
local boatAuto:any=upTab:Section("อัปเกรดเรืออัตโนมัติ")
autoToggle(boatAuto,"Hull","Auto ตัวเรือ")
autoToggle(boatAuto,"Engine","Auto เครื่องยนต์")
autoToggle(boatAuto,"Trawl","Auto ตาข่ายลาก")
group(questTab,"เควส",{{"ตรวจสอบเควส",nil,"quests"},{"รับรางวัลเควส",nil,"claimQuest"}})
local rewardSec:any=group(questTab,"รางวัล",{{"ตรวจสอบรางวัล",nil,"rewards"},{"รับรางวัลรายวัน",nil,"claimDaily"},{"รับรางวัลเงินเวลาเล่น",nil,"claimCashGift"}})
rewardSec:Toggle({Title="รับรางวัลที่พร้อมอัตโนมัติ",Name="รับรางวัลที่พร้อมอัตโนมัติ",Desc="ไม่ใช้โบนัสจำกัดเวลา",Default=false,Callback=a.setRewardLoop})
group(progressTab,"ความคืบหน้า",{{"ข้อมูลความคืบหน้า",nil,"progress"},{"ตรวจความพร้อมรวม",nil,"preflight"}})
a.prepareRebirth=function()
 local d=data()
 local ok=f.CanRebirth(d)
 if not ok then return false,a.rebirthInfo() end
 local opened,msg=a.openRebirthMenu()
 if not opened then return false,msg end
 return true,"พร้อม Rebirth | ตรวจรายละเอียดและยืนยันเองในหน้าเกม"
end
local rebirthSection:any=progressTab:Section("Rebirth")
button(rebirthSection,"ตรวจเงื่อนไข Rebirth","อ่านเงินและจำนวนปลาที่ต้องใช้",a.rebirthInfo)
button(rebirthSection,"เตรียม Rebirth เมื่อพร้อม","เปิดหน้าตรวจสอบ ไม่รีเซ็ตอัตโนมัติ",a.prepareRebirth)
button(rebirthSection,"ปิดหน้า Rebirth","ปิดโดยไม่รีเซ็ต",a.closeRebirthMenu)
group(progressTab,"สัตว์เลี้ยง",{{"เปิดหน้าสัตว์เลี้ยง",nil,"openPetMenu"}})
a.autoThrowInfo=function()
 if p:GetAttribute("Pass_AutoThrow")~=true then return "Auto Throw | ยังไม่มี Game Pass" end
 return "Auto Throw | "..(p:GetAttribute("Set_AutoThrow")~=false and "เปิด" or "ปิด")
end
a.nativeAutoThrow=function(on:boolean)
 if p:GetAttribute("Pass_AutoThrow")~=true then return false,"ต้องมี Game Pass Auto Throw ก่อน" end
 if (p:GetAttribute("Set_AutoThrow")~=false)==on then return true,a.autoThrowInfo() end
 local g:any=p.PlayerGui:FindFirstChild("CastHUD")
 local frame=g and g:FindFirstChild("AutoThrowToggle",true)
 if not frame or not visible(frame,g) then return false,"ปุ่ม Auto Throw ของเกมยังไม่พร้อม" end
 local b=frame:FindFirstChildWhichIsA("GuiButton",true)
 if not signal(b) then return false,"ไม่พบปุ่มปกติของเกม" end
 return waitFor(function()return (p:GetAttribute("Set_AutoThrow")~=false)==on end,3),a.autoThrowInfo()
end
a.petSlotsInfo=function()
 local st:any=r.Pets:InvokeServer("state")
 local owned=0;for _,n in pairs(st.pets or {})do owned+=math.max(0,tonumber(n) or 0) end
 local equipped=0;for _,v in pairs(st.equipN or {})do if v then equipped+=1 end end
 return ("มีสัตว์เลี้ยง %s | ใช้ช่อง %s/%s | %s"):format(tostring(owned),tostring(equipped),tostring(st.slots),st.restricted and "จำกัดสิทธิ์" or (owned==0 and "ยังไม่มีสัตว์เลี้ยง" or "เปิดเมนูเพื่อเลือกสัตว์เลี้ยง"))
end
a.crateReady=function()
 local d=data();local n=tonumber(d.Pearls) or 0
 return "Ocean Crate | ไข่มุก "..tostring(n).."/1000 | "..(n>=1000 and "มีไข่มุกเพียงพอ" or "ขาดอีก "..tostring(1000-n))
end
local natFish:any=fishTab:Section("จับปลาอัตโนมัติของเกม")
button(natFish,"ตรวจสิทธิ์จับปลาอัตโนมัติ","ตรวจ Game Pass",a.autoThrowInfo)
button(natFish,"เปิดจับปลาอัตโนมัติ","ใช้ปุ่มปกติเมื่อมีสิทธิ์",function()return a.nativeAutoThrow(true)end)
button(natFish,"ปิดจับปลาอัตโนมัติ","ใช้ปุ่มปกติเมื่อมีสิทธิ์",function()return a.nativeAutoThrow(false)end)
local petStatus:any=progressTab:Section("จัดการสัตว์เลี้ยงและกล่อง")
button(petStatus,"ตรวจช่องสวมใส่สัตว์เลี้ยง","อ่านสถานะจริง",a.petSlotsInfo)
button(petStatus,"ตรวจความพร้อมเปิดกล่อง Ocean","ตรวจไข่มุก ไม่ซื้อกล่อง",a.crateReady)
a.openCrateMenu=function()
 local g:any=p.PlayerGui:FindFirstChild("StoreUI")
 if not g then return false,"ไม่พบร้านกล่อง" end
 bus.fire("OpenStore","OceanCrates")
 return waitFor(function()return visible(g:FindFirstChild("Window"),g) end,4),"เปิดหน้ากล่อง Ocean เท่านั้น ไม่ซื้อ"
end
a.petEquipReadiness=function()
 local st:any=r.Pets:InvokeServer("state")
 if st.restricted then return false,"เกมจำกัดสิทธิ์สัตว์เลี้ยง" end
 if next(st.pets or {})==nil then return false,"ยังไม่มีสัตว์เลี้ยงให้สวมใส่" end
 local free=0;for i=1,st.slots do if not st.equipN[i] then free+=1 end end
 if free==0 then return false,"ช่องเต็ม ไม่ถอดสัตว์เลี้ยงเดิม" end
 return true,"ช่องว่าง "..tostring(free).." | เปิดหน้าสัตว์เลี้ยงเพื่อเลือก"
end
local function closeNativeWindow(name:string)
 local g:any=p.PlayerGui:FindFirstChild(name)
 local w=g and g:FindFirstChild("Window")
 if not w then return false,"ไม่พบหน้าต่าง" end
 if not visible(w,g) then return true,"ปิดอยู่แล้ว" end
 local h=w:FindFirstChild("Header")
 if not signal(h and h:FindFirstChild("Button"))then return false,"ไม่พบปุ่มปิดของเกม" end
 local ok=waitFor(function()return not visible(w,g) end,4)
 return ok,ok and "ปิดหน้าต่างแล้ว" or "หน้าต่างยังไม่ตอบสนอง"
end
a.closeCrateMenu=function()return closeNativeWindow("StoreUI")end
a.closePetMenu=function()return closeNativeWindow("CoolerUI")end
button(petStatus,"เปิดหน้ากล่อง Ocean ของเกม","เปิดดูเท่านั้น ไม่ซื้อ",a.openCrateMenu)
button(petStatus,"ปิดหน้ากล่อง Ocean","ปิดร้านโดยไม่ซื้อ",a.closeCrateMenu)
button(petStatus,"ปิดหน้าสัตว์เลี้ยง","ปิดหน้าต่างโดยไม่เปลี่ยนข้อมูล",a.closePetMenu)
button(petStatus,"ตรวจพร้อมสวมใส่สัตว์เลี้ยง","ไม่ถอดสัตว์เลี้ยงเดิม",a.petEquipReadiness)
local function petPlanFrom(st:any): (string?,number?,string)
 if type(st)~="table" or type(st.equipN)~="table" or type(st.pets)~="table" then return nil,nil,"ข้อมูลสัตว์เลี้ยงไม่พร้อม" end
 if st.restricted then return nil,nil,"เกมจำกัดสิทธิ์สัตว์เลี้ยง" end
 local slot:number?=nil
 local used:any={}
 for i=1,tonumber(st.slots) or 0 do
  local id=st.equipN and st.equipN[i]
  if id then used[id]=(used[id] or 0)+1 elseif not slot then slot=i end
 end
 if not slot then return nil,nil,"ไม่มีช่องว่าง" end
 local best:any=nil
 for _,def in ipairs(f.Pets or {})do
  local n=tonumber(st.pets and st.pets[def.Id]) or 0
  if n>(used[def.Id] or 0) then
   if not best or (tonumber(def.Rarity) or 0)>(tonumber(best.Rarity) or 0) then best=def end
  end
 end
 if not best then return nil,nil,"ไม่มีสัตว์เลี้ยงที่ยังไม่ได้สวมใส่" end
 return best.Id,slot,"เลือก "..tostring(best.Name or best.Id).." | ช่อง "..tostring(slot)
end
local function petPlan()return petPlanFrom(r.Pets:InvokeServer("state"))end
a.petPlan=petPlan
a.equipEmptyPet=function()
 local id,slot,msg=petPlan()
 if not id or not slot then return false,msg end
 local st:any=r.Pets:InvokeServer("state")
 local nextId,nextSlot=petPlanFrom(st)
 if nextId~=id or nextSlot~=slot then return false,"ข้อมูลสัตว์เลี้ยงเปลี่ยน กรุณาตรวจใหม่" end
 local sent,err=pcall(function()return r.Pets:InvokeServer("equip",id,slot)end)
 if not sent then return false,"คำสั่งสวมใส่ไม่สำเร็จ" end
 local z:any=r.Pets:InvokeServer("state")
 local ok=type(z)=="table" and type(z.equipN)=="table" and z.equipN[slot]==id
 return ok,ok and ("สวมใส่สำเร็จช่อง "..tostring(slot)) or "เซิร์ฟเวอร์ยังไม่ยืนยันการสวมใส่"
end
button(petStatus,"ดูแผนสวมใส่สัตว์เลี้ยง","เลือกจากสัตว์เลี้ยงที่มีจริง",function()local _,_,msg=petPlan();return msg end)
button(petStatus,"สวมใส่สัตว์เลี้ยงในช่องว่าง","ไม่ถอดตัวเดิม ไม่ซื้อสัตว์เลี้ยง",a.equipEmptyPet)
petAuto.widget=petStatus:Toggle({Title="Auto เลือกสัตว์เลี้ยงที่ดีที่สุด",Name="Auto เลือกสัตว์เลี้ยงที่ดีที่สุด",Default=false,Callback=a.setBestPet})
petStatus:Label("เลือกตัวคูณสูงสุดก่อน | ไม่ซื้อ ไม่สุ่ม ไม่ขาย")
button(petStatus,"ตรวจสถานะ Auto สัตว์เลี้ยง","ตรวจจำนวนครั้งและผลล่าสุด",a.bestPetInfo)
local tr:any=travelTab:Section("เดินทางภายในฐาน")
button(tr,"เดินไปจุดวางปลา","เดินตามเส้นทาง",function()return nav.navigate("Place Fish")end)
button(tr,"เดินไปกล่องเก็บปลา","เดินไปฐานตัวเอง",function()return nav.navigate("Open Cooler")end)
button(tr,"เดินไปร้านเหยื่อ","เดินไปฐานตัวเอง",function()return nav.navigate("Bait Shop")end)
button(tr,"หยุดการเดินทาง","หยุดคำสั่งเดิน",function()nav.stop();return true,"หยุดแล้ว"end)
local playSec:any=autoTab:Section("Auto Play")
playState.widget=playSec:Toggle({Title="Auto Play",Name="Auto Play",Desc="จัดคิวงาน 1–7 | โยนตาข่ายเมื่อพร้อม",Default=false,Callback=a.setAutoPlay})
playSec:Dropdown({Title="โหมด Auto Play",Name="โหมด Auto Play",Options={"เน้นหาเงิน","อัปเกรดตามงบ"},Default="เน้นหาเงิน",Callback=function(v:any)if v=="เน้นหาเงิน"or v=="อัปเกรดตามงบ"then playState.mode=v end end})
a.uiSliders.playInterval=playSec:Slider({Name="ช่วงวน Auto Play",Min=10,Max=60,Step=5,Default=10,Suffix=" วินาที",Callback=function(v:number)playState.interval=math.clamp(v,10,60)end})
button(playSec,"ตรวจสถานะ Auto Play","แสดงขั้นและจำนวนรอบ",a.autoPlayInfo)
playSec:Label("1 รีเฟรช | 2 รางวัล | 3 เหยื่อ")
playSec:Label("4 โยนตาข่าย | 5 รอจบรอบ")
playSec:Label("6 จัดการปลา | 7 อัปเกรด")
playSec:Label("โหมดซื้อ: เลือก Auto รายการที่ต้องการก่อน")
local stopSection:any=autoTab:Section("สถานะและควบคุมงาน")
stopSection:Button({Title="หยุดทุกงานของ MXH",Name="หยุดทุกงานของ MXH",Description="หยุดงานและการเดินทาง",Callback=function()if alive()then local ok,x,y=pcall(a.stopAll);UI:SetStatus(ok and tostring(y or x)or "เกิดข้อผิดพลาด")end end})
button(stopSection,"ตรวจสถานะงาน","แสดงงานปัจจุบัน จำนวนครั้ง และค่าใช้จ่าย",a.jobInfo)
local spendSec:any=autoTab:Section("ตั้งค่าซื้อเมื่อมีเงิน")
button(spendSec,"ตรวจสถานะซื้ออัตโนมัติ","ดูจำนวนและค่าใช้จ่าย",a.autoBuyInfo)
a.uiSliders.reserve=spendSec:Slider({Name="เงินสำรองขั้นต่ำ",Min=50000,Max=1000000,Step=10000,Default=50000,Suffix=" $",Callback=function(v:number)buyState.reserve=math.clamp(v,50000,1000000)end})
local chosenPriceCap=100000
local capMode="จำกัดตามแถบเลื่อน"
a.uiSliders.priceCap=spendSec:Slider({Name="ราคาสูงสุดต่อครั้ง",Min=0,Max=1000000,Step=10000,Default=100000,Suffix=" $",Callback=function(v:number)chosenPriceCap=math.clamp(v,0,1000000);if capMode=="จำกัดตามแถบเลื่อน"then buyState.cap=chosenPriceCap end end})
spendSec:Dropdown({Title="โหมดเพดานราคา",Name="โหมดเพดานราคา",Options={"จำกัดตามแถบเลื่อน","ไม่จำกัดราคา"},Default=capMode,Callback=function(v:any)
 if v~="จำกัดตามแถบเลื่อน" and v~="ไม่จำกัดราคา"then return end
 capMode=v;buyState.cap=if v=="ไม่จำกัดราคา"then math.huge else chosenPriceCap
end})
spendSec:Label("ไม่จำกัดราคา: ยังต้องเหลือเงินสำรองขั้นต่ำ")
a.uiSliders.buyInterval=spendSec:Slider({Name="ช่วงตรวจเงิน",Min=5,Max=60,Step=5,Default=10,Suffix=" วินาที",Callback=function(v:number)buyState.interval=math.clamp(v,5,60)end})
local jobOptions:any={["วางปลาช่องว่าง"]="place",["อัปเกรดตาข่าย"]="net",["อัปเกรดเบ็ดผู้ช่วย"]="helper",["อัปเกรดเครื่องยนต์เรือ"]="boat",["เติมเหยื่อปัจจุบัน"]="bait"}
local jobChoice="เติมเหยื่อปัจจุบัน"
local jobBudget=1000
local jobLimit=2
local jobPanel:any=autoTab:Section("ตั้งค่างานอัตโนมัติ")
jobPanel:Dropdown({Title="เลือกประเภทงาน",Name="เลือกประเภทงาน",Options={"วางปลาช่องว่าง","อัปเกรดตาข่าย","อัปเกรดเบ็ดผู้ช่วย","อัปเกรดเครื่องยนต์เรือ","เติมเหยื่อปัจจุบัน"},Default=jobChoice,Callback=function(v:any)if jobOptions[v] then jobChoice=v end end})
a.uiSliders.budget=jobPanel:Slider({Name="งบประมาณสูงสุด",Min=0,Max=10000,Step=500,Default=1000,Suffix=" $",Callback=function(v:number)jobBudget=math.clamp(math.floor(v/500+.5)*500,0,10000)end})
a.uiSliders.limit=jobPanel:Slider({Name="จำนวนครั้งสูงสุด",Min=1,Max=7,Step=1,Default=2,Suffix=" ครั้ง",Callback=function(v:number)jobLimit=math.clamp(math.floor(v+.5),1,7)end})
jobPanel:Label("วางปลา 1-7 ครั้ง | งานซื้อ/อัปเกรด 1-3 ครั้ง")
a.jobPlan=function()
 local kind=jobOptions[jobChoice];local cap=math.min(jobLimit,kind=="place" and 7 or 3)
 local budget=kind=="place" and 0 or jobBudget
 return jobChoice.." | สูงสุด "..tostring(cap).." ครั้ง | งบ $"..tostring(budget).." | สำรอง $50000",kind,cap,budget
end
button(jobPanel,"ตรวจแผนงานที่เลือก","อ่านค่าที่เลือก ยังไม่เริ่มงาน",function()local msg=a.jobPlan();return msg end)
jobPanel:Button({Title="เริ่มงานที่เลือก",Name="เริ่มงานที่เลือก",Description="เริ่มเมื่อยืนยันเท่านั้น",Callback=function()
 if not alive()then return end
 local _,kind,cap,budget=a.jobPlan()
 local ok,x,y=pcall(a.startJob,kind,cap,budget)
 UI:SetStatus(ok and tostring(y or x)or "เกิดข้อผิดพลาด")
end})
jobPanel:Button({Title="หยุดงานที่เลือก",Name="หยุดงานที่เลือก",Description="หยุดก่อนคำสั่งถัดไป",Callback=function()if alive()then a.stopJob();UI:SetStatus("หยุดงานแล้ว")end end})
local native:any=autoTab:Section("โหมด AFK ของเกม")
button(native,"เปิด AFK ของเกม","ตรวจสิทธิ์",function()return a.nativeAFK(true)end)
button(native,"ออกจาก AFK ของเกม","ใช้ปุ่มปกติ",function()return a.nativeAFK(false)end)
if dry then local keys={};for k,v in pairs(a)do if type(v)=="function"then table.insert(keys,k)end end;manifest.actions=keys;return manifest end
e.__MXHVerifiedTab=autoTab;e.__MXHVerifiedSection=stopSection;e.__MXHVerifiedActions=a;e.__MXHBoundedJobs=job;e.__MXHLocalRefresh=refresh;e.__MXHRewardLoop=reward;e.__MXHFishing=nav
local function enableDockScroll()
 local first=UI.Root:FindFirstChild("TabBtn_MAIN",true)
 if not first then return end
 local dock=first.Parent
 if not dock or dock:IsA("ScrollingFrame") then return end
 local scroll=Instance.new("ScrollingFrame")
 scroll.Name="MXHTabScroll"
 scroll.Size=UDim2.new(1,0,1,-54)
 scroll.Position=UDim2.fromOffset(0,0)
 scroll.BackgroundTransparency=1
 scroll.BorderSizePixel=0
 scroll.ScrollBarThickness=3
 scroll.ScrollBarImageColor3=Color3.fromRGB(110,226,255)
 scroll.ScrollBarImageTransparency=.25
 scroll.ScrollingDirection=Enum.ScrollingDirection.Y
 scroll.ScrollingEnabled=true
 scroll.ElasticBehavior=Enum.ElasticBehavior.Never
 scroll.ClipsDescendants=true
 scroll.Active=true
 scroll.ZIndex=first.ZIndex
 local height=0
 for _,v in ipairs(dock:GetChildren())do
  if v:IsA("GuiObject") and (v.Name=="DockLens" or v.Name:sub(1,7)=="TabBtn_") then
   height=math.max(height,v.Position.Y.Offset+v.Size.Y.Offset)
   v.Parent=scroll
  end
 end
 scroll.CanvasSize=UDim2.fromOffset(0,height+8)
 scroll.Parent=dock
end
enableDockScroll()
UI.Root.Destroying:Connect(function()runtimeAlive=false;cleanup()end)
pcall(a.refreshMain)
UI:SetStatus("พร้อมใช้งาน");UI:Toggle(true)
return {ready=true,place=game.PlaceId}
