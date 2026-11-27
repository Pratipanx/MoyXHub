-- MoyXHub | Thai Amulet Master Simulator | V23 Mobile Beta
-- Six bundled modules; no GitHub BASE_URL required. Prism UI loads externally.
-- V14 noclip is not included. Unfinished features remain beta.
assert(game.PlaceId==79029248570139,"Wrong place")

-- MoyXHub_ThaiAmulet_AutoV13.lua
do
local fn,err=loadstring([=[
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


UI:SetTitle("MoyXHub | Thai Amulet Master")
local player=game.Players.LocalPlayer
local gui=player:WaitForChild("PlayerGui")
local active=false
local mode="ฝึกวิชา"
local train="สมาธิ"
local search="กองพระแบกะดินข้างวัด"
local job="ร้านกาแฟโบราณลุงชิต"
local mission="รับถุงข้าวมันไก่"
local jobs={["รับถุงข้าวมันไก่"]={id="M_Chicken_BagPickup",shop="Job_ChickenRice",target="Job_Grocery"},["รับนมข้นหวาน"]={id="M_Coffee_MilkPickup",shop="Job_Coffee",target="Job_Grocery"},["รับน้ำยาขัดเงิน"]={id="M_Repair_ChemicalPickup",shop="Job_Repair",target="Job_Grocery"},["ส่งเอกสารที่ซุ้มวัด"]={id="M_Delivery_GateGuard",shop="Job_Delivery",target="ลุงยามสมบัติ"},["ส่งข้าวมันไก่"]={id="M_Chicken_DeliverPerm",shop="Job_ChickenRice",target="ลุงเพิ่ม"}}
jobs["รับม้วนกระดาษห่อ"]={id="M_Grocery_PaperPickup",shop="Job_Grocery"}
jobs["ส่งหนังสือพิมพ์ด่วน"]={id="M_Delivery_UncleChit",shop="Job_Delivery"}
jobs["ส่งกาแฟถวายพระ"]={id="M_Coffee_DeliverMonk",shop="Job_Coffee"}
jobs["เก็บฟันเฟืองเงิน"]={id="M_Repair_ScavengeGears",shop="Job_Repair"}
jobs["เก็บว่านตาเพชร"]={id="M_Grocery_Herbs",shop="Job_Grocery"}
local rs=game:GetService("ReplicatedStorage")
local rem=rs:WaitForChild("AmuletRemotes")
local jobEvent=rem:WaitForChild("JobEvent") :: RemoteEvent
local jobRemote=rem:WaitForChild("JobRemote") :: RemoteFunction
local trainFn=rs:WaitForChild("TrainingRemotes"):WaitForChild("TrainFn") :: RemoteFunction
local questData:any=nil
local accepted=false
local completed=0
local shoo=false
local lastShoo=0
local lastAction=0
local questConn=jobEvent.OnClientEvent:Connect(function(kind,data)
    if kind=="StartQuestTracker" or kind=="UpdateQuestObjective" then
        questData=questData or {};for k,v in pairs(data or {}) do questData[k]=v end
    elseif kind=="ClearQuestTracker" then
        if accepted then completed+=1 end
        accepted=false;questData=nil
    end
end)
local quest="ฟันเฟืองเงินโบราณ"
local travel="ห้างพระเครื่อง"
local delaySeconds=3
local hp=75
local serial=0
local visited={}
local done=false
local status="พร้อมใช้งาน • Auto ปิด"
local function say(s)
    if status~=s then status=s;pcall(function() UI:SetStatus(s) end) end
end
local function char()
    local c=player.Character
    return c and c:FindFirstChildOfClass("Humanoid"),c and c:FindFirstChild("HumanoidRootPart")
end
local function stop()
    local h,r=char()
    if h and r and r:IsA("BasePart") then h:MoveTo(r.Position) end
end
local function reset()
    serial+=1;table.clear(visited);done=false;stop()
end
local function health()
    local h=char()
    return h and h.Health>0 and h.MaxHealth>0 and h.Health/h.MaxHealth*100>=hp
end
local function valid(id)
    return active and serial==id and UI.Root.Parent~=nil and health()
end
local function pos(p)
    local a=p.Parent
    if a and a:IsA("Attachment") then return a.WorldPosition end
    if a and a:IsA("BasePart") then return a.Position end
    return nil
end
local function shown(g,n)
    local a=gui:FindFirstChild(g);local b=a and a:FindFirstChild(n,true)
    return a and a:IsA("ScreenGui") and a.Enabled and b and b:IsA("GuiObject") and b.Visible
end
local function match(p)
    if mode=="ฝึกวิชา" then return p.Name=="TrainPrompt" and p.ObjectText==(train=="สมาธิ" and "ฝึกสมาธิ" or "ฝึกหนังเหนียว") end
    if mode=="ค้นหาพระ" then return p.ActionText=="ค้นหาพระเครื่อง" and p.ObjectText==search end
    if mode=="ทำงาน" then return p.Name=="JobPrompt" and p.ObjectText==job end
    if mode=="เก็บของเควส" then return p.Name=="ScavengePrompt" and string.find(p.ActionText,quest,1,true)~=nil and not visited[p] end
    if mode=="เดินทาง" then
        if travel=="ห้างพระเครื่อง" then return p.ActionText=="ส่องแผงเช่าพระ" end
        if travel=="ร้านรับซื้อพระ" then return p.ActionText=="เปิดโต๊ะเจรจาขายพระ" end
        if travel=="สมาคมตรวจพระ" then return p.ActionText=="ส่งพระตรวจออกใบรับรอง" end
        if travel=="วัด" then return p.Name=="TrainPrompt" and string.find(p:GetFullName(),"TrainingSites.Temple",1,true)~=nil end
        if travel=="ท่าเรือดงสมิง" then return p.Name=="BoatPrompt" end
    end
    return false
end
local function nearest(filter:any?)
    local _,r=char()
    if not r or not r:IsA("BasePart") then return nil end
    local best,d=nil,math.huge
    for _,p in ipairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.Enabled and (if filter then filter(p) else match(p)) then
            local v=pos(p)
            if v then local dist=(v-r.Position).Magnitude;if dist<d then best,d=p,dist end end
        end
    end
    return best
end



local pf=game:GetService("PathfindingService")
local minimumHP=75
local clearanceLimit=35
local busy=false
local running=true
local counters={moves=0,unsupported=0,blocked=0}
local function clearance(at:Vector3):number
    local folder=workspace:FindFirstChild("LiveMonsters")
    local best=math.huge
    if folder then for _,m in ipairs(folder:GetChildren()) do
        if m:IsA("Model") then local q=m:GetPivot().Position;best=math.min(best,Vector2.new(q.X-at.X,q.Z-at.Z).Magnitude) end
    end end
    return best
end
local function ground(at:Vector3):boolean
    local rp=RaycastParams.new()
    rp.FilterType=Enum.RaycastFilterType.Exclude
    rp.RespectCanCollide=true
    local excluded:{Instance}={}
    if player.Character then table.insert(excluded,player.Character) end
    local monsters=workspace:FindFirstChild("LiveMonsters")
    if monsters then table.insert(excluded,monsters) end
    rp.FilterDescendantsInstances=excluded
    local hit=workspace:Raycast(at+Vector3.new(0,1,0),Vector3.new(0,-11,0),rp)
    return hit~=nil and hit.Normal.Y>=.35
end
local function go(dest:Vector3,range:number,keep:any):boolean
    if busy or not running or not keep() then return false end
    local h,r=char()
    local c=player.Character
    if not c or not h or not r or not r:IsA("BasePart") then return false end
    if h.Health<h.MaxHealth*minimumHP/100 then say("พักฟื้นก่อนเดินทาง");return false end
    if (r.Position-dest).Magnitude<=range then return true end
    busy=true
    local function flat(a:Vector3,b:Vector3) return Vector2.new(a.X-b.X,a.Z-b.Z).Magnitude end
    local function alive() return running and keep() and player.Character==c and h.Health>=h.MaxHealth*minimumHP/100 end
    local function safe() return alive() and clearance(r.Position)>=clearanceLimit-5 end
    local function supported(at:Vector3)
        if ground(at) then return true end
        counters.unsupported+=1
        return false
    end
    local ok,arrived=pcall(function()
        if h.Sit then h.Sit=false;h.Jump=true;task.wait(.3) end
        if not safe() or not supported(r.Position) then return false end
        for _=1,3 do
            if not safe() then return false end
            if (r.Position-dest).Magnitude<=range then return true end
            local chosen:any=nil;local shortest=math.huge
            for i=0,8 do
                if not safe() then return false end
                local angle=i*math.pi/4;local rad=math.max(0,range-2)
                local goal=if i==0 then dest else dest+Vector3.new(math.cos(angle)*rad,-1,math.sin(angle)*rad)
                local path=pf:CreatePath({AgentRadius=2,AgentHeight=5,AgentCanJump=true,WaypointSpacing=5})
                local success=pcall(function() path:ComputeAsync(r.Position,goal) end)
                if success and path.Status==Enum.PathStatus.Success then
                    local w=path:GetWaypoints();local validPath=true;local length=0;local prev=r.Position
                    for _,v in ipairs(w) do
                        if clearance(v.Position)<clearanceLimit or not ground(v.Position) then validPath=false;break end
                        length+=(v.Position-prev).Magnitude;prev=v.Position
                    end
                    if validPath and length<shortest then chosen=w;shortest=length end
                end
            end
            if not chosen then counters.blocked+=1;say("ไม่มีทางปลอดภัย");return false end
            local stuck=false
            say("เดินตามทางปลอดภัย")
            for _,w in ipairs(chosen) do
                if (r.Position-dest).Magnitude<=range then return true end
                if not safe() then return false end
                if flat(r.Position,w.Position)>2 then
                    if w.Action==Enum.PathWaypointAction.Jump then h.Jump=true end
                    h:MoveTo(w.Position)
                    local started=os.clock()
                    while flat(r.Position,w.Position)>2 and os.clock()-started<2.5 do
                        if not safe() then return false end
                        if (r.Position-dest).Magnitude<=range then return true end
                        if h:GetState()~=Enum.HumanoidStateType.Jumping and h:GetState()~=Enum.HumanoidStateType.Freefall and not supported(r.Position) then return false end
                        task.wait(.08)
                    end
                    if flat(r.Position,w.Position)>3.5 then
                        h.Jump=true;h:MoveTo(w.Position);local retry=os.clock()
                        while safe() and flat(r.Position,w.Position)>2 and os.clock()-retry<1.4 do task.wait(.08) end
                        if flat(r.Position,w.Position)>3.5 then stuck=true;break end
                    end
                end
            end
            if not stuck and (r.Position-dest).Magnitude>range and (r.Position-dest).Magnitude<=range+4 and safe() and ground(dest) then
                h:MoveTo(dest);local t=os.clock()
                while safe() and (r.Position-dest).Magnitude>range and os.clock()-t<1.5 do task.wait(.05) end
            end
            if (r.Position-dest).Magnitude<=range then return true end
            h:MoveTo(r.Position)
        end
        return false
    end)
    if r.Parent and h.Parent then h:MoveTo(r.Position) end
    busy=false
    if ok and arrived then counters.moves+=1;say("ถึงจุดหมายปลอดภัย");return true end
    counters.blocked+=1;say("หยุด • เส้นทางไม่ปลอดภัยหรือเดินติด");return false
end
env.__MoyTravelV10={go=go,stats=function() return {moving=busy,moves=counters.moves,unsupported=counters.unsupported,blocked=counters.blocked} end}
env.__MoySafeV11={go=go,ground=ground,status=function()return status end,busy=function()return busy end}
local function walk(p,id)
    local v=pos(p)
    if not v then return false end
    return go(v,math.max(2,p.MaxActivationDistance-1),function() return valid(id) and p.Parent~=nil and p.Enabled end)
end
local function interact(p,id)
    if not p or not walk(p,id) or not valid(id) or not p.Enabled then return false end
    local _,r=char();local v=pos(p)
    if not r or not r:IsA("BasePart") or not v or (r.Position-v).Magnitude>p.MaxActivationDistance then return false end
    return pcall(function() fireproximityprompt(p) end)
end
local function jobTick(id)
    local selected=jobs[mission]
    if not selected or os.clock()-lastAction<2 then return end
    if shown("JobMinigameGui","QuestTracker") then
        local v:Vector3?=nil
        if questData then local t=questData.TargetPos;if type(t)=="table" and tonumber(t[1]) and tonumber(t[2]) and tonumber(t[3]) then v=Vector3.new(t[1],t[2],t[3]) end end
        if not v then local mark=workspace:FindFirstChild("QuestWaypointMarker");if mark and mark:IsA("BasePart") then v=mark.Position-Vector3.new(0,4.5,0) end end
        if not v then say("รอข้อมูลจุดหมายภารกิจ");return end
        accepted=true
        local p:ProximityPrompt?=nil;local best=math.huge
        for _,a in ipairs(workspace:GetDescendants()) do
            if a:IsA("ProximityPrompt") and a.Enabled and (a.Name=="JobPrompt" or a.Name=="DeliverPrompt" or a.Name=="ScavengePrompt") then
                local pp=pos(a);if pp then local d=(pp-v).Magnitude;if d<best and d<45 then p=a;best=d end end
            end
        end
        if not p then say("ไม่พบจุดส่งของ");return end
        if interact(p,id) then lastAction=os.clock() elseif valid(id) then say("ทางไปเควสไม่ปลอดภัย • รอ") end
        return
    end
    if accepted then say("รอเซิร์ฟเวอร์อัปเดตภารกิจ");return end
    local p=nearest(function(a) return a.Name=="JobPrompt" and string.find(a:GetFullName(),selected.shop,1,true)~=nil end)
    if not p then say("ไม่พบร้านรับงาน");return end
    if not interact(p,id) then return end
    task.wait(.5)
    if not valid(id) then return end
    lastAction=os.clock()
    local ok,res=pcall(function() return jobRemote:InvokeServer("AcceptMission",{MissionId=selected.id}) end)
    if ok and type(res)=="table" and res.Success then accepted=true;say("รับภารกิจสำเร็จ • "..mission) else say("รับงานไม่ได้ • "..tostring(type(res)=="table" and res.Message or res)) end
end
local autoDig=true
local deepDig=true
local digSuccess=0
local lockSuccess=0
local function visible(v)
    local a=v
    while a do
        if a:IsA("GuiObject") and not a.Visible then return false end
        if a:IsA("ScreenGui") then return a.Enabled end
        a=a.Parent
    end
    return false
end
local function button(root,phrase)
    for _,v in ipairs(root:GetDescendants()) do if v:IsA("TextButton") and visible(v) and string.find(v.Text,phrase,1,true) then return v end end
    return nil
end
local function label(root,phrase)
    for _,v in ipairs(root:GetDescendants()) do if v:IsA("TextLabel") and visible(v) and string.find(v.Text,phrase,1,true) then return v end end
    return nil
end
local function click(b)
    if not b or not visible(b) then return false end
    for _,c in ipairs(getconnections(b.Activated)) do if c.Enabled and type(c.Function)=="function" then return pcall(c.Function) end end
    return false
end
local function lockPlay(lock,id)
    local last:any=nil;local lastAt=0;local attempts=0;local deadline=os.clock()+24
    while valid(id) and lock.Parent and visible(lock) and os.clock()<deadline and attempts<9 do
        local needle:any=nil
        for _,v in ipairs(lock:GetDescendants()) do if v:IsA("Frame") and visible(v) and v.ZIndex==66 and v.Size.Y.Offset==5 then needle=v;break end end
        if needle and (needle~=last or os.clock()-lastAt>1.3) then
            local c=needle.BackgroundColor3
            if c.G>.95 and c.R<.65 and c.B<.75 then
                local btn=button(lock,"ดันสลัก");local fired=false
                if btn then for _,conn in ipairs(getconnections(btn.InputBegan)) do if conn.Enabled and type(conn.Function)=="function" then fired=pcall(conn.Function,{UserInputType=Enum.UserInputType.MouseButton1});if fired then break end end end end
                if not fired then fired=pcall(function() keypress(0x20);task.wait(.03);keyrelease(0x20) end) end
                if fired then attempts+=1;last=needle;lastAt=os.clock();task.wait(.14) end
            end
        end
        task.wait()
    end
end
local function clue(t)
    if string.find(t,"🔥",1,true) then return 1 end
    if string.find(t,"♨",1,true) then return 2 end
    if string.find(t,"🌤",1,true) then return 3 end
    if string.find(t,"❄",1,true) then return 4 end
    return nil
end
local function gridPlay(grid,id)
    local start=button(grid,"เริ่มขุด");if start then click(start);task.wait(.4) end
    local cells={}
    for _,v in ipairs(grid:GetDescendants()) do if v:IsA("TextButton") then local i=tonumber(string.match(v.Name,"^Cell(%d+)$"));if i then cells[i]=v end end end
    local n=#cells;if n~=20 then say("รอผู้เล่น • รองรับกระดานปลอดภัย 5x4");return end
    local function heat(a,b) return math.min(4,math.max(math.abs((a-1)%5-(b-1)%5),math.abs(math.floor((a-1)/5)-math.floor((b-1)/5)))) end
    for _=1,9 do
        if not valid(id) or not grid.Parent or not visible(grid) then return end
        if label(grid,"ขุดเจอพระ") or label(grid,"หาพระไม่เจอ") then return end
        local candidates={};local available={}
        for i=1,n do
            local t=cells[i].Text
            if string.find(t,"📿",1,true) or string.find(t,"🔒",1,true) then return end
            if t=="" then table.insert(available,i) end
        end
        for _,i in ipairs(available) do
            local possible=true
            for j=1,n do local h=clue(cells[j].Text);if h and heat(i,j)~=h then possible=false;break end end
            if possible then table.insert(candidates,i) end
        end
        if #candidates==0 then say("คำใบ้ไม่พอ");return end
        local best,score=nil,math.huge
        for _,i in ipairs(available) do
            local bins={};for _,j in ipairs(candidates) do local h=heat(i,j);bins[h]=(bins[h] or 0)+1 end
            local cost=0;for _,k in pairs(bins) do cost+=k*k end;if table.find(candidates,i) then cost-=.1 end
            if cost<score then best,score=i,cost end
        end
        if not best then return end
        local cell=cells[best];if not click(cell) then return end
        local t=os.clock();while valid(id) and cell.Parent and (cell.Text=="" or cell.Text=="⛏️") and os.clock()-t<2.5 do task.wait(.05) end
        if not cell.Parent or cell.Text=="" or cell.Text=="⛏️" or string.find(cell.Text,"📿",1,true) or string.find(cell.Text,"🔒",1,true) then return end
        task.wait(.25)
    end
end
local function digTick(id)
    local g=gui:FindFirstChild("DigHuntGui");if not g then return false end
    local lock=g:FindFirstChild("LockPick",true);local flow=g:FindFirstChild("SearchFlow",true);local grid=g:FindFirstChild("DigHunt",true)
    if not ((lock and visible(lock)) or (flow and visible(flow)) or (grid and visible(grid))) then return false end
    if not autoDig or search~="กองพระแบกะดินข้างวัด" then say("รอผู้เล่น • โซนอื่นยังไม่รองรับ Auto");return true end
    if lock and visible(lock) then say("ไขกุญแจ");lockPlay(lock,id);return true end
    if grid and visible(grid) then
        local result=button(grid,"ตกลง")
        if result then if label(grid,"ขุดเจอพระ") then digSuccess+=1;say("ขุดเจอพระสำเร็จ") end;click(result);task.wait(.4);return true end
        gridPlay(grid,id);return true
    end
    if flow and visible(flow) then
        if label(flow,"เปิดกรุชั้นแรกสำเร็จ") then
            local b=if deepDig then button(flow,"ขุดต่อ!") else button(flow,"เก็บของ กลับบ้าน")
            if b and click(b) then lockSuccess+=1;task.wait(.4) end
        else local b=button(flow,"ตกลง");if b then click(b);task.wait(.4) end end
        return true
    end
    return true
end
local function tick(id)
    if done then return end
    if not health() then stop();say("พัก • HP ต่ำ / รอเกิดใหม่");return end
    local _,r=char()
    if not r or not r:IsA("BasePart") then return end
    if clearance(r.Position)<clearanceLimit-5 then stop();say("มอนอยู่ใกล้ • หยุดกิจกรรม");return end
    if mode=="หาเงินรับส่งของ" then jobTick(id);return end
    if mode=="ฝึกวิชา" and shown("TrainingGui","TrainHUD") then
        if shoo and shown("TrainingGui","Disturb") and os.clock()-lastShoo>2 then lastShoo=os.clock();pcall(function() trainFn:InvokeServer("Shoo") end) end
        say("กำลังฝึกวิชา");return
    end
    if mode=="ค้นหาพระ" then
        if search~="กองพระแบกะดินข้างวัด" then say("โซนเสี่ยง • ยังไม่เปิด Auto");return end
        if digTick(id) then return end
        if shown("SearchMinigameGui","Panel") then say("รอทำมินิเกมค้นหาพระ");return end
    end
    local p=nearest();if not p then say("ไม่มีเป้าหมายที่พร้อม");return end
    if not walk(p,id) or not valid(id) then return end
    if mode=="เดินทาง" then done=true;say("ถึงแล้ว • "..p.ObjectText);return end
    if interact(p,id) then
        if mode=="ทำงาน" then done=true end
        if mode=="เก็บของเควส" then visited[p]=true end
        say("เปิดกิจกรรม • "..p.ObjectText)
    else say("เปิดกิจกรรมไม่สำเร็จ") end
end
local function toggle(v) active=v;reset();say(v and "Auto • กำลังเริ่ม" or "พร้อมใช้งาน • Auto ปิด") end
local M=UI:Tab("MAIN"):Section("ระบบเล่นอัตโนมัติ")
M:Toggle({Name="เปิดระบบ Auto",Desc="เลือกกิจกรรมก่อนเปิด • ไม่ใช้ Robux",Default=false,Callback=toggle})
M:Dropdown({Name="กิจกรรมหลัก",Options={"ฝึกวิชา","หาเงินรับส่งของ","ค้นหาพระ","ทำงาน","เก็บของเควส","เดินทาง"},Default=mode,Callback=function(v) mode=v;reset() end})
M:Slider({Name="เวลารอระหว่างกิจกรรม",Min=2,Max=15,Step=1,Default=3,Suffix=" วินาที",Callback=function(v) delaySeconds=v end})
M:Slider({Name="พักเมื่อ HP ต่ำกว่า",Min=10,Max=90,Step=5,Default=75,Suffix="%",Callback=function(v) hp=v end})
M:Label("ทุก Auto ใช้เส้นทางปลอดภัยเดียวกัน")
local Move=UI:Tab("MOVE"):Section("การเดินทางปลอดภัย")
Move:Slider({Name="ระยะหลบมอนสเตอร์",Min=30,Max=70,Step=5,Default=35,Suffix=" studs",Callback=function(v) clearanceLimit=v end})
Move:Slider({Name="พักเมื่อ HP ต่ำกว่า",Min=60,Max=95,Step=5,Default=75,Suffix="%",Callback=function(v) minimumHP=v end})
Move:Label("ตรวจเฉพาะพื้นชนได้ • ไม่ฝืนบินในเซิร์ฟเวอร์ที่จำกัด")
local F=UI:Tab("FARM"):Section("ค้นหาพระและรับงาน")
F:Dropdown({Name="เลือกแหล่งค้นหา",Options={"กองพระแบกะดินข้างวัด","กุฏิไม้สักเก่าหลังวัด","บ้านร้างเศรษฐีโบราณ","ป่าช้าอาถรรพ์ท้ายวัด (เฮี้ยนจัด!)"},Default=search,Callback=function(v) search=v;reset() end})
F:Dropdown({Name="เลือกร้านรับงาน",Options={"ร้านกาแฟโบราณลุงชิต","ร้านของชำเจ๊บ๊วย","ร้านข้าวมันไก่ตอนเฮียโก๋","ร้านซ่อมเครื่องเงินตาศิลป์","แผงหนังสือพิมพ์น้าแดง"},Default=job,Callback=function(v) job=v;reset() end})
F:Dropdown({Name="งานรับส่งของอัตโนมัติ",Options={"รับถุงข้าวมันไก่","รับนมข้นหวาน","รับน้ำยาขัดเงิน","ส่งเอกสารที่ซุ้มวัด","ส่งข้าวมันไก่","รับม้วนกระดาษห่อ","ส่งหนังสือพิมพ์ด่วน","ส่งกาแฟถวายพระ","เก็บฟันเฟืองเงิน","เก็บว่านตาเพชร"},Default=mission,Callback=function(v) mission=v;reset() end})
F:Label("เลือก หาเงินรับส่งของ ใน MAIN • รับและเดินตามเควสจริง")
F:Toggle({Name="ขุดและไขกุญแจอัตโนมัติ",Desc="รองรับกองพระแบกะดินข้างวัด • ใช้คำใบ้จริง",Default=true,Callback=function(v) autoDig=v end})
F:Toggle({Name="ขุดต่อกรุชั้นลึก",Desc="ใช้หลังเปิดกรุชั้นแรกสำเร็จ",Default=true,Callback=function(v) deepDig=v end})
F:Label("มินิเกมงานร้านยังต้องเล่นเอง")
local T=UI:Tab("TRAINING"):Section("ฝึกวิชา")
T:Dropdown({Name="เลือกวิชาที่ต้องการฝึก",Options={"สมาธิ","หนังเหนียว"},Default=train,Callback=function(v) train=v;reset() end})
T:Toggle({Name="ไล่ผีรบกวนอัตโนมัติ",Desc="เฉพาะขณะฝึกและมีหน้าต่างผี",Default=false,Callback=function(v) shoo=v end})
T:Label("เริ่มฝึกที่จุดว่าง • รอขณะกำลังฝึก")
local Q=UI:Tab("QUEST"):Section("วัตถุดิบภารกิจ")
Q:Dropdown({Name="เลือกวัตถุดิบ",Options={"ฟันเฟืองเงินโบราณ","ว่านสมุนไพรตาเพชร"},Default=quest,Callback=function(v) quest=v;reset() end})
Q:Label("ต้องมีภารกิจที่เกี่ยวข้อง")
local V=UI:Tab("TRAVEL"):Section("เดินทาง")
V:Dropdown({Name="เลือกจุดหมาย",Options={"ห้างพระเครื่อง","ร้านรับซื้อพระ","สมาคมตรวจพระ","วัด","ท่าเรือดงสมิง"},Default=travel,Callback=function(v) travel=v;reset() end})
V:Label("เลือกเดินทางใน MAIN • ถึงแล้วหยุด")
local I=UI:Tab("INFO"):Section("ข้อมูลระบบ")
I:Label("Auto V13 • แก้ตัวตรวจพื้นและการเดินค้าง")
I:Label("ขุดโซนปลอดภัยรองรับแล้ว • ระบบเสริมโหลดแยก")
I:Button({Name="ตรวจสอบสถานะล่าสุด",Callback=function() UI:SetStatus(status) end})
UI:AddSettingsTab()
UI:SetStatus(status)
UI:Toggle(true)
env.__MoyAutoV1={status=function() return status end,enabled=function() return active end,target=function() local p=nearest();return p and p.ObjectText end,qa=function(v,m,j) if m then mode=m end;if j then mission=j end;toggle(v) end,completed=function() return completed end,quest=function() return questData end,dig=function() return digSuccess,lockSuccess end}
local old=UI.Destroy
UI.Destroy=function(self) running=false;active=false;serial+=1;stop();questConn:Disconnect();env.__MoyAutoV1=nil;old(self) end
task.spawn(function()
    while UI.Root.Parent do
        if active then local id=serial;local ok,e=pcall(tick,id);if not ok and active then say("พัก • "..tostring(e)) end end
        task.wait(active and delaySeconds or .5)
    end
    if active then active=false;stop() end
end)
]=],"MoyXHub_ThaiAmulet_AutoV13.lua")
assert(fn,tostring(err))
fn()
end

-- MoyXHub_ThaiAmulet_AutoV21_Addon.lua
do
local fn,err=loadstring([=[
-- MoyXHub V6 expansion. Run after ThaiAmulet AutoV5.
local env=getgenv()
local UI:any=env.__MoyXHubUIOnly
local base:any=env.__MoyAutoV1
assert(UI and base and env.__MoyTravelV10,"Run MoyXHub_ThaiAmulet_AutoV10 first")
assert(game.PlaceId==79029248570139,"Wrong place")
local pl=game:GetService("Players").LocalPlayer
local rs=game:GetService("ReplicatedStorage")
local action=rs:WaitForChild("AmuletRemotes"):WaitForChild("ActionRemote") :: RemoteFunction
local ctx:any=nil
for _,b in ipairs(pl.PlayerGui:WaitForChild("SianPhraSimulatorUI"):GetDescendants()) do
    if b:IsA("TextButton") and string.find(b.Text,"กระเป๋าพระ",1,true) then
        for _,c in ipairs(getconnections(b.Activated)) do
            if type(c.Function)=="function" then
                for _,v in pairs(debug.getupvalues(c.Function)) do
                    if type(v)=="table" and type(v.State)=="table" and type(v.invoke)=="function" then ctx=v end
                end
            end
        end
    end
end
assert(ctx,"Cannot read local inventory UI")
local config=ctx.Config
local flags={equip=false,clan=false,talent=false,buy=false,sell=false,combat=false,weapon=false,certify=false,inspect=false,chant=false,skin=false,bargain=false}
local ranks={Common=1,Rare=2,Legendary=3,Mythical=4,Secret=5,Heavenly=6}
local goal="Rare"
local reserve=3000
local maxBuy=1000
local minSell=50
local sellUnknown=false
local buyUnknown=false
local maxCert=500
local hpStop=85
local stall="Stall_UncleChom"
local status="V21 พร้อมใช้งาน"
local buyer="Buyer_UncleMai"
local minPatience=65
local trainFn=rs:WaitForChild("TrainingRemotes"):WaitForChild("TrainFn") :: RemoteFunction
local skinStart:any=nil
local onceKey:string?=nil
local count={equip=0,clan=0,talent=0,buy=0,sell=0,weapon=0,attack=0,certify=0,inspect=0,correct=0,chant=0,skin=0,bargain=0}
local running=true
local function say(v) status=v;pcall(function() UI:SetStatus(v) end) end
local function invoke(name,payload)
    local ok,r=pcall(function() return action:InvokeServer(name,payload or {}) end)
    if ok and type(r)=="table" then return r end
    return {Success=false,Message=tostring(r)}
end
local function state() return ctx.State end
local function result(key,r)
    if r.Success then count[key]+=1 end
    say((r.Success and "สำเร็จ • " or "รอ / ไม่สำเร็จ • ")..tostring(r.Message or key))
    return r.Success==true
end
local function character()
    local c=pl.Character
    return c and c:FindFirstChildOfClass("Humanoid"),c and c:FindFirstChild("HumanoidRootPart")
end
local function stop()
    local h,r=character()
    if h and r and r:IsA("BasePart") then h:MoveTo(r.Position) end
end
local function permitted(key)
    local h=character()
    local job=env.__MoyJobV15
    return running and UI.Root.Parent~=nil and flags[key] and not base.enabled() and not (job and job.status().enabled) and h and h.Health>0 and h.Health/h.MaxHealth*100>=hpStop
end
local function walk(dest:Vector3,range:number,key:string)
    local travel=env.__MoyTravelV10
    if not travel then say("ต้องโหลด AutoV10 ก่อน");return false end
    return travel.go(dest,range,function() return permitted(key) end)
end
local function promptFor(name)
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Enabled and string.find(v:GetFullName(),name,1,true) and v.Parent:IsA("BasePart") then return v end
    end
    return nil
end
local function equip()
    return result("equip",invoke("EquipBestAmulet",{}))
end
local function roll(kind)
    local s=state()
    local current=if kind=="Clan" then config.GetClanById(s.ClanId) else config.GetTalentById(s.TalentId)
    local tokens=if kind=="Clan" then s.ClanTokens else s.TalentTokens
    local key=string.lower(kind)
    if (ranks[current and current.Rarity or "Common"] or 1)>=(ranks[goal] or 2) then say("ถึงระดับที่ต้องการแล้ว • "..kind);return false end
    if not tokens or tokens<1 then say("ตั๋วสุ่มหมด");return false end
    local slots=if kind=="Clan" then s.ClanSlots else s.TalentSlots
    local total=if kind=="Clan" then s.ClanSlotCount else s.TalentSlotCount
    if total and total>0 and not slots[1] and not slots["1"] then
        local saved=invoke("GachaSlotSave",{Kind=kind,Slot=1})
        if not saved.Success then say("เก็บตัวเดิมไม่ได้ • ไม่สุ่ม");return false end
    end
    return result(key,invoke("Reroll"..kind,{Lucky=false}))
end
local function inspectOne(payload,key)
    local start=invoke("InspectStart",payload)
    if not start.Success then say(start.Message or "เริ่มส่องไม่สำเร็จ");return nil end
    if not start.LabelOK or type(start.Spots)~="table" then say("สายตายังไม่ถึงระดับพระ");return nil end
    local begin=invoke("InspectBegin",{Token=start.Token})
    if not begin.Success then say(begin.Message or "เปิดการส่องไม่สำเร็จ");return nil end
    local maxD,clear=0,0
    for _,p in ipairs(start.Spots) do
        if not permitted(key) then return nil end
        task.wait(.8)
        if not permitted(key) then return nil end
        local spot=invoke("InspectSpot",{Token=start.Token,Spot=p.Index})
        if spot.Success and spot.Clear and type(spot.D)=="number" then
            clear+=1;maxD=math.max(maxD,spot.D)
        end
    end
    if clear<2 then say("จุดส่องไม่ชัดพอ • ไม่ฟันธง");return nil end
    local guess=if maxD>.45 then "Fake" else "Real"
    if maxD>.2 and maxD<=.45 then say("ผลไม่ชัดเจน • ไม่ฟันธง");return nil end
    local res=invoke("InspectSubmit",{Token=start.Token,Guess=guess})
    if res.Success then
        count.inspect+=1
        if res.Correct then count.correct+=1 end
    end
    say(tostring(res.Message or "จบการส่องพระ"))
    return res
end
local function inspectInventory()
    local s=state()
    for _,v in ipairs(s.Inventory or {}) do
        if v.KnowState=="Unknown" and not v.AppraisedByPlayer and v.RequiredLevel<=(s.Stats and s.Stats.EffectiveSightLevel or s.AppraisalLevel) and v.Rarity=="Common" then
            return inspectOne({UID=v.UID},"inspect")
        end
    end
    say("ไม่มีพระ Common ที่ยังไม่ส่อง")
    return nil
end
local function buy()
    local s=state()
    local r=invoke("StallView",{StallId=stall})
    if not r.Success then say(r.Message or "เปิดร้านไม่สำเร็จ");return false end
    local best:any=nil
    for _,v in ipairs(r.Stock or {}) do
        if type(v.Price)=="number" and v.Price<=maxBuy and s.Cash-v.Price>=reserve and (buyUnknown or not v.Inspected or v.IsReal==true or v.DisplayAuthenticity=="Real" or v.DisplayAuthenticity=="แท้" or v.KnowState=="Real") then
            if not best or v.Price<best.Price then best=v end
        end
    end
    if not best then say("ไม่พบพระที่ผ่านเงื่อนไขซื้อ");return false end
    local p=promptFor(stall.."_Point")
    if not p or not p.Parent:IsA("BasePart") or not walk(p.Parent.Position,p.MaxActivationDistance-1,"buy") then say("เดินไปร้านไม่สำเร็จ");return false end
    if not permitted("buy") then return false end
    if not buyUnknown and not best.Inspected then
        local check=inspectOne({StallId=stall,UID=best.UID},"buy")
        if not check or not check.Success or not check.CanSeeTruth or not check.IsReal then say("ไม่ยืนยันว่าแท้ • ไม่ซื้อ");return false end
    end
    if not permitted("buy") or state().Cash-best.Price<reserve then return false end
    return result("buy",invoke("StallBuy",{StallId=stall,UID=best.UID}))
end
local function sell()
    local s=state()
    local counts={}
    for _,v in ipairs(s.Inventory or {}) do counts[v.AmuletId]=(counts[v.AmuletId] or 0)+1 end
    for _,v in ipairs(s.Inventory or {}) do
        local display=tonumber(v.DisplayValue)
        local value=tonumber(v.QuickSellPrice) or (display and math.floor(display*.8))
        if v.Rarity=="Common" and (counts[v.AmuletId] or 0)>1 and v.UID~=s.EquippedUID and not v.Certified and ((v.KnowState~="Unknown" and value and value>=minSell) or (sellUnknown and v.KnowState=="Unknown" and minSell==0)) then
            return result("sell",invoke("QuickSellAmulet",{UID=v.UID}))
        end
    end
    say("ไม่มีพระซ้ำ Common ที่ผ่านเงื่อนไขขาย");return false
end
local function certify()
    local s=state()
    local item:any=nil
    local fee=0
    for _,v in ipairs(s.Inventory or {}) do
        local cost=(config.Rarities[v.Rarity] or {}).CertifyCost
        if v.KnowState=="Unknown" and not v.Certified and type(cost)=="number" and cost<=maxCert and s.Cash-cost>=reserve then
            if not item or cost<fee then item=v;fee=cost end
        end
    end
    if not item then say("ไม่มีพระที่ตรวจได้ในงบ");return false end
    local p=promptFor("ExpertCertifierShop_Point")
    if not p or not p.Parent:IsA("BasePart") or not walk(p.Parent.Position,p.MaxActivationDistance-1,"certify") then say("เดินไปสมาคมตรวจพระไม่สำเร็จ");return false end
    if not permitted("certify") then return false end
    return result("certify",invoke("CertifyAmulet",{UID=item.UID}))
end
local function weapon()
    local s=state()
    if s.OwnedWeapons and s.OwnedWeapons.MagicKnife then say("มีมีดหมอแล้ว");return false end
    if s.Cash-1500<reserve then say("เงินไม่พอซื้อมีดหมอตามเงินสำรอง");return false end
    local p=promptFor("MagicShop_Point")
    if not p or not p.Parent:IsA("BasePart") or not walk(p.Parent.Position,p.MaxActivationDistance-1,"weapon") then say("เดินไปร้านอาวุธไม่สำเร็จ");return false end
    if not permitted("weapon") then return false end
    return result("weapon",invoke("BuyMagicItem",{ItemId="MagicKnife"}))
end
local function chant()
    local h,r=character()
    if not h or not r or not r:IsA("BasePart") then return end
    local sites=workspace:FindFirstChild("TrainingSites")
    local temple=sites and sites:FindFirstChild("Temple")
    local altar:any=nil;local dist=math.huge
    if temple then for _,v in ipairs(temple:GetDescendants()) do if v:IsA("BasePart") and v.Name=="ChantAltar" then local d=(r.Position-v.Position).Magnitude;if d<dist then altar=v;dist=d end end end end
    if not altar then say("ไม่พบแท่นคาถา");return end
    if dist>11 and not walk(altar.Position,11,"chant") then say("เดินไปแท่นคาถาไม่สำเร็จ");return end
    local gui=pl.PlayerGui:FindFirstChild("TrainingGui")
    local button=gui and gui:FindFirstChild("ChantButton",true)
    if not button or not button:IsA("TextButton") or not button.Visible then say("รอจุดฝึกคาถาเปิด");return end
    for _=1,8 do
        if not permitted("chant") or not button.Visible then break end
        for _,conn in ipairs(getconnections(button.Activated)) do if conn.Enabled and type(conn.Function)=="function" then local ok=pcall(conn.Function);if ok then count.chant+=1 end;break end end
        task.wait(.25)
    end
    say("กำลังฝึกคาถา • วัดปลอดภัย")
end
local function skin()
    local h,r=character()
    if not h or not r or not r:IsA("BasePart") or not permitted("skin") then return false end
    local res=trainFn:InvokeServer("GetState")
    local stateNow=res and res.State
    if not stateNow then say("อ่านค่าฝึกไม่ได้");return false end
    if stateNow.Mode=="Skin" and h.Sit then
        if not skinStart then skinStart=stateNow.Skin or 0 end
        local delta=(stateNow.Skin or 0)-skinStart
        count.skin=math.max(0,delta)
        say("ฝึกหนังเหนียว • +"..tostring(delta).." แต้ม")
        return delta>=15
    end
    local temple=workspace:FindFirstChild("TrainingSites")
    temple=temple and temple:FindFirstChild("Temple")
    local best:any=nil
    local dist=math.huge
    if temple then
        for _,v in ipairs(temple:GetDescendants()) do
            if v:IsA("ProximityPrompt") and v.Enabled and v.ObjectText=="ฝึกหนังเหนียว" and v.Parent:IsA("BasePart") then
                local d=(v.Parent.Position-r.Position).Magnitude
                if d<dist then best=v;dist=d end
            end
        end
    end
    if not best then say("ไม่พบจุดฝึกหนังเหนียว");return false end
    if not walk(best.Parent.Position,best.MaxActivationDistance-1,"skin") or not permitted("skin") then return false end
    skinStart=stateNow.Skin or 0
    fireproximityprompt(best)
    say("เริ่มฝึกหนังเหนียว")
    return false
end
local function bargain()
    local s=state()
    local counts={}
    for _,v in ipairs(s.Inventory or {}) do counts[v.AmuletId]=(counts[v.AmuletId] or 0)+1 end
    local item:any=nil
    local floor=0
    for _,v in ipairs(s.Inventory or {}) do
        local q=tonumber(v.QuickSellPrice)
        if v.Rarity=="Common" and v.KnowState~="Unknown" and not v.Certified and v.UID~=s.EquippedUID and (counts[v.AmuletId] or 0)>1 and q and q>=minSell then
            item=v;floor=q;break
        end
    end
    if not item then say("ไม่มีพระซ้ำที่ผ่านเงื่อนไขเจรจา");return false end
    local p=promptFor(buyer.."_Point")
    if not p or not p.Parent:IsA("BasePart") or not walk(p.Parent.Position,p.MaxActivationDistance-1,"bargain") then say("เดินไปร้านรับซื้อไม่สำเร็จ");return false end
    if not permitted("bargain") then return false end
    local started=invoke("StartBargain",{BuyerId=buyer,UID=item.UID})
    if not started.Success or not started.Session then say(started.Message or "เปิดเจรจาไม่ได้");return false end
    local session=started.Session
    for _=1,2 do
        if not permitted("bargain") or (tonumber(session.Patience) or 0)<minPatience then break end
        if (tonumber(session.CurrentOffer) or 0)>=floor*1.10 then break end
        task.wait(.35)
        local response=invoke("AdjustBargain",{Direction="PLUS"})
        if response.DealBroken then say("ดีลล่ม • ไม่ขาย");return false end
        if not response.Session then break end
        session=response.Session
    end
    if not permitted("bargain") or (tonumber(session.CurrentOffer) or 0)<floor or (tonumber(session.Patience) or 0)<35 then
        invoke("CancelBargain",{});say("ข้อเสนอไม่ถึงราคาขายด่วน • เก็บพระไว้");return false
    end
    local before=state().Cash
    local res=invoke("ConfirmBargainDeal",{})
    if res.Success then count.bargain+=1;say("เจรจาสำเร็จ • "..tostring(res.SoldPrice or state().Cash-before).." ฿");return true end
    invoke("CancelBargain",{});say(res.Message or "ขายไม่สำเร็จ");return false
end
local function combat()
    say("ปิดการต่อสู้ • ใช้ระบบบินหลบมอนใน MOVE")
end
local function switch(k,v)
    flags[k]=v
    if not v and (k=="combat" or k=="weapon" or k=="buy" or k=="certify" or k=="chant" or k=="bargain" or k=="skin") then stop() end
    if k=="skin" and not v then local h=character();if h and h.Sit then h.Sit=false;h.Jump=true end;skinStart=nil end
end
local trade=UI:Tab("TRADE"):Section("ซื้อขายพระและจัดกระเป๋า")
trade:Toggle({Name="สวมพระที่ดีที่สุดอัตโนมัติ",Default=false,Callback=function(v) switch("equip",v) end})
trade:Toggle({Name="ซื้อพระแท้ที่ตรวจแล้ว",Desc="ไม่ซื้อพระที่ยังไม่รู้ผล",Default=false,Callback=function(v) switch("buy",v) end})
trade:Toggle({Name="อนุญาตซื้อพระยังไม่ส่อง",Desc="เสี่ยงได้พระเก๊ • ค่าเริ่มต้นปิด",Default=false,Callback=function(v) buyUnknown=v end})
trade:Dropdown({Name="เลือกร้าน",Options={"Stall_UncleChom","Stall_HiaMooVIP","Stall_PraKru","Stall_RianKanajan"},Default=stall,Callback=function(v) stall=v end})
trade:Slider({Name="ราคาซื้อสูงสุด",Min=100,Max=10000,Step=100,Default=1000,Suffix=" ฿",Callback=function(v) maxBuy=v end})
trade:Slider({Name="เงินสำรองขั้นต่ำ",Min=0,Max=20000,Step=100,Default=3000,Suffix=" ฿",Callback=function(v) reserve=v end})
trade:Toggle({Name="ส่องพระอัตโนมัติ",Desc="พระ Common • ใช้จุดตรวจจริง ไม่ฟันธงเมื่อข้อมูลไม่ชัด",Default=false,Callback=function(v) switch("inspect",v) end})
trade:Toggle({Name="ส่งพระตรวจออกใบเซอร์อัตโนมัติ",Desc="ใช้เงินในเกมและรักษาเงินสำรอง",Default=false,Callback=function(v) switch("certify",v) end})
trade:Slider({Name="ค่าตรวจสูงสุดต่อองค์",Min=500,Max=12000,Step=500,Default=500,Suffix=" ฿",Callback=function(v) maxCert=v end})
trade:Toggle({Name="ขายพระซ้ำ Common",Desc="เก็บอย่างน้อย 1 องค์ ไม่ขายพระที่สวมอยู่หรือมีใบเซอร์",Default=false,Callback=function(v) switch("sell",v) end})
trade:Slider({Name="ราคาขายขั้นต่ำ",Min=0,Max=2000,Step=50,Default=50,Suffix=" ฿",Callback=function(v) minSell=v end})
trade:Toggle({Name="อนุญาตขายพระซ้ำที่ยังไม่ส่อง",Desc="ต้องตั้งราคาขั้นต่ำ 0 ด้วย",Default=false,Callback=function(v) sellUnknown=v end})
trade:Toggle({Name="เจรจาขายพระซ้ำ",Desc="ขายเมื่อราคาไม่ต่ำกว่าขายด่วน • ไม่ขายองค์ที่สวม",Default=false,Callback=function(v) switch("bargain",v) end})
trade:Dropdown({Name="เลือกร้านเจรจา",Options={"Buyer_UncleMai","Buyer_HiaTong","Buyer_SiaSongpol","Buyer_JaePen"},Default=buyer,Callback=function(v) buyer=v end})
trade:Slider({Name="ความอดทนขั้นต่ำก่อนต่อราคา",Min=50,Max=90,Step=5,Default=65,Suffix="%",Callback=function(v) minPatience=v end})
local rollSec=UI:Tab("ROLL"):Section("สุ่มด้วยตั๋วฟรี")
rollSec:Toggle({Name="สุ่มตระกูลอัตโนมัติ",Default=false,Callback=function(v) switch("clan",v) end})
rollSec:Toggle({Name="สุ่มพรสวรรค์อัตโนมัติ",Default=false,Callback=function(v) switch("talent",v) end})
rollSec:Dropdown({Name="หยุดเมื่อถึงระดับ",Options={"Rare","Legendary","Mythical","Secret"},Default=goal,Callback=function(v) goal=v end})
rollSec:Label("เก็บตัวเดิมเมื่อช่องว่าง • ไม่ใช้ Robux")
local fight=UI:Tab("COMBAT"):Section("หลีกเลี่ยงการต่อสู้")
fight:Toggle({Name="ซื้อมีดหมออาคม",Desc="ใช้เงินในเกม 1,500 บาท ตามเงินสำรอง",Default=false,Callback=function(v) switch("weapon",v) end})
fight:Slider({Name="หยุดเมื่อ HP ต่ำกว่า",Min=30,Max=90,Step=5,Default=85,Suffix="%",Callback=function(v) hpStop=v end})
fight:Label("ไม่โจมตีมอนสเตอร์ • ใช้เส้นทางปลอดภัย")
local chants=UI:Tab("CHANT"):Section("ฝึกคาถา")
chants:Toggle({Name="ฝึกคาถาอัตโนมัติ",Desc="เดินไปแท่นที่วัดและใช้ปุ่มท่องคาถา",Default=false,Callback=function(v) switch("chant",v) end})
chants:Toggle({Name="ฝึกหนังเหนียวอัตโนมัติ",Desc="เดินเข้าจุดฝึกที่วัด • หยุดและลุกเมื่อปิด",Default=false,Callback=function(v) switch("skin",v) end})
local ext=UI:Tab("AUTO+"):Section("สถานะระบบเสริม")
ext:Label("ระบบเสริมทำงานเมื่อ Auto ใน MAIN ปิดอยู่")
ext:Button({Name="ดูสถานะล่าสุด",Callback=function() say(status) end})
UI:Toggle(true)
env.__MoyAutoV6={flags=flags,count=count,state=state,status=function() return status end,test=function(k) if k=="equip" then return equip() elseif k=="clan" then return roll("Clan") elseif k=="talent" then return roll("Talent") end;return false end,qa=function(k,v,budget,shop) if flags[k]==nil then return false end;if budget then maxBuy=budget end;if shop then stall=shop end;onceKey=if v then k else nil;switch(k,v);return true end,stop=function() for k in pairs(flags) do if flags[k] then switch(k,false) end end;onceKey=nil;stop() end}
local lifecycle:any=(getfenv() :: any).STATE
if lifecycle then lifecycle.onCleanup(function() running=false;stop();env.__MoyAutoV6=nil end) end
task.spawn(function()
    local lastEquip=0
    local order={"weapon","inspect","certify","buy","sell","bargain","clan","talent","equip","chant","skin","combat"}
    local nextIndex=1
    while running and UI.Root.Parent do
        if not base.enabled() and not (env.__MoyJobV15 and env.__MoyJobV15.status().enabled) then
            local ok,e=pcall(function()
                for _=1,#order do
                    local k=order[nextIndex];nextIndex=nextIndex%#order+1
                    if flags[k] then
                        if k=="weapon" then weapon()
                        elseif k=="certify" then certify()
                        elseif k=="inspect" then inspectInventory()
                        elseif k=="buy" then if buy() and onceKey==k then switch(k,false);onceKey=nil end
                        elseif k=="sell" then sell()
                        elseif k=="bargain" then if bargain() and onceKey==k then switch(k,false);onceKey=nil end
                        elseif k=="clan" then roll("Clan")
                        elseif k=="talent" then roll("Talent")
                        elseif k=="equip" and os.clock()-lastEquip>15 then lastEquip=os.clock();equip()
                        elseif k=="chant" then chant()
                        elseif k=="skin" then if skin() and onceKey==k then switch(k,false);onceKey=nil end
                        elseif k=="combat" then combat() end
                        break
                    end
                end
            end)
            if not ok then say("ระบบเสริม • "..tostring(e)) end
        end
        task.wait(flags.combat and .5 or 3)
    end
end)
]=],"MoyXHub_ThaiAmulet_AutoV21_Addon.lua")
assert(fn,tostring(err))
fn()
end

-- MoyXHub_ThaiAmulet_JobsV20.lua
do
local fn,err=loadstring([=[
-- MoyXHub V15: play shop minigames via visible game UI and claim actual result.
local e=getgenv()
local ui:any=e.__MoyXHubUIOnly
local base:any=e.__MoyAutoV1
local extra:any=e.__MoyAutoV6
local direct:any=e.__MoyTravelV10
assert(ui and base and extra and direct,"Load V13 and Addon first")
local p=game:GetService("Players").LocalPlayer
local root=p.PlayerGui:WaitForChild("JobMinigameGui")
local remote=game:GetService("ReplicatedStorage"):WaitForChild("AmuletRemotes"):WaitForChild("JobRemote") :: RemoteFunction
local rs=game:GetService("RunService")
local jobs={
    ["จัดของชำ"]={id="M_Grocery_Clean",shop="Job_Grocery"},
    ["ชงกาแฟ"]={id="M_Coffee_Brew",shop="Job_Coffee"},
    ["สับไก่และจัดจาน"]={id="M_Chicken_Chop",shop="Job_ChickenRice"},
    ["ขัดเครื่องเงิน"]={id="M_Repair_Polish",shop="Job_Repair"},
    ["ส่งหนังสือพิมพ์"]={id="M_Delivery_Toss",shop="Job_Delivery"},
}
local selected="จัดของชำ"
local activeJob=""
local once=false
local history={}
local enabled=false
local running=true
local count=0
local lastScore=0
local lastResult=""
local status="พร้อมใช้งาน"
local attempts=0
local serial=0
local function say(t) status=t;pcall(function()ui:SetStatus(t)end)end
local function alive(id)
    local c=p.Character;local h=c and c:FindFirstChildOfClass("Humanoid")
    return running and enabled and id==serial and ui.Root.Parent~=nil and h and h.Health>=h.MaxHealth*.85 and not base.enabled()
end
local function visible(v)
    local a=v
    while a do
        if a:IsA("GuiObject") and not a.Visible then return false end
        if a:IsA("ScreenGui") then return a.Enabled end
        a=a.Parent
    end
    return false
end
local function list(class)
    local t={}
    for _,v in ipairs(root:GetDescendants()) do if v:IsA(class) and visible(v) then t[#t+1]=v end end
    return t
end
local function find(class,phrase,exact)
    for _,v in ipairs(list(class)) do
        if (v:IsA("TextButton") or v:IsA("TextLabel")) and (if exact then v.Text==phrase else string.find(v.Text,phrase,1,true)~=nil) then return v end
    end
    return nil
end
local function click(b)
    if not b or not visible(b) then return false end
    for _,c in ipairs(getconnections(b.Activated)) do if c.Enabled and type(c.Function)=="function" then return pcall(c.Function) end end
    return false
end
local function btn(t,exact) return find("TextButton",t,exact) end
local function label(t) return find("TextLabel",t,false) end
local recipes={
 ["กาแฟดำร้อน"]={"ผงกาแฟ","น้ำร้อน"},["โอเลี้ยง"]={"ผงกาแฟ","น้ำตาล","น้ำแข็ง"},["กาแฟเย็น"]={"ผงกาแฟ","นมข้น","น้ำตาล","น้ำแข็ง"},["ชาเย็น"]={"ผงชา","นมข้น","น้ำตาล","น้ำแข็ง"},["ชาดำเย็น"]={"ผงชา","น้ำตาล","น้ำแข็ง"},["กาแฟใส่ไข่"]={"ผงกาแฟ","น้ำร้อน","ไข่ลวก"},["ชาร้อนใส่นม"]={"ผงชา","น้ำร้อน","นมข้น"}
}
local shelf={}
for cat,words in pairs({["ขนม"]={"ลูกอม","คุกกี้","ช็อกโกแลต","ถั่วอบ","ข้าวเกรียบ","ขนมไม้"},["เครื่องดื่ม"]={"น้ำอัดลม","น้ำผลไม้","นมกล่อง","ชาเขียว","เหล้าขาว","น้ำแข็ง"},["ของใช้"]={"แชมพู","สบู่","ฟองน้ำ","ทิชชู่","เทียนไข","ไม้กวาด"},["ยา"]={"ยาแก้ปวด","พลาสเตอร์","ยาดม","ยาธาตุ","ปรอท","ยาหยอดตา"}}) do for _,w in ipairs(words) do shelf[w]=cat end end
local coffeeRound=""
local plateOrder={}
local plateKey=""
local plateDone=false
local jumped:any={}
local lastScrub=0
local polishRow=0
local pourStarted=0
local ingredientIndex=0
local lastCoffeeStep=0
local function solveCoffee(id)
    if os.clock()-lastCoffeeStep<.09 then return end
    lastCoffeeStep=os.clock()
    if not alive(id) then return end
    local order=label("แก้วนึงจ้า")
    local round=label("ลูกค้า ")
    if not order or not round or not round:IsA("TextLabel") or not order:IsA("TextLabel") then return end
    local roundText=round.Text
    local roundN=tonumber(string.match(roundText,"(%d+)/")) or 1
    local name=string.match(order.Text,'ขอ "(.-)"')
    local recipe=name and recipes[name]
    if not recipe then return end
    if roundText~=coffeeRound then coffeeRound=roundText;ingredientIndex=0;pourStarted=0;click(btn("เททิ้ง",false));return end
    if btn("ล้น!",false) then ingredientIndex=0;pourStarted=0;click(btn("เททิ้ง",false));return end
    local stop=btn("หยุด!",false)
    if stop then
        if pourStarted==0 then pourStarted=os.clock() end
        if os.clock()-pourStarted>=.815/(.42+roundN*.03) then pourStarted=0;click(stop) end
        return
    end
    local pour=btn("เทน้ำ",false)
    if not pour then
        for _,v in ipairs(list("TextButton")) do
            if v:IsA("TextButton") and string.match(v.Text,"💧 %d+%%") then click(btn("เสิร์ฟ!",false));return end
        end
        return
    end
    if ingredientIndex<#recipe then
        local b=btn(recipe[ingredientIndex+1],false)
        if b then ingredientIndex+=1;click(b) end
        return
    end
    pourStarted=os.clock();click(pour)
end
local function solveGrocery()
    local roach=btn("🦗",true);if roach then click(roach) end
    for _,v in ipairs(list("TextLabel")) do
        if v:IsA("TextLabel") and v.TextSize==26 then
            for word,cat in pairs(shelf) do
                if string.find(v.Text,word,1,true) then click(btn(cat,false));return end
            end
        end
    end
end
local plateIndex=0
local lastPlateStep=0
local function solveChicken(id)
    local chop=btn("สับ!",false)
    if chop then
        for _,v in ipairs(list("TextLabel")) do
            if v:IsA("TextLabel") and v.Text=="🍗" and math.abs(v.Position.X.Scale-.14)<.025 then click(chop);return end
        end
    end
    if os.clock()-lastPlateStep<.12 then return end
    local order=label("จานที่ ")
    if order and order:IsA("TextLabel") then
        local key=string.match(order.Text,"จานที่ (%d+)")
        if key and not string.find(order.Text,"❓",1,true) and string.find(order.Text,": ",1,true) then
            if key~=plateKey then
                plateKey=key;plateDone=false;plateIndex=0;table.clear(plateOrder)
                local body=string.match(order.Text,": (.+)")
                if body then for _,v in ipairs(string.split(body," → ")) do table.insert(plateOrder,v) end end
            end
        end
        if not plateDone and #plateOrder>0 and (label("กดตามลำดับเลย!") or (plateIndex>0 and string.find(order.Text,"❓",1,true))) then
            local v=plateOrder[plateIndex+1]
            if not v then plateDone=true;return end
            local b=btn(v,true)
            if b then plateIndex+=1;lastPlateStep=os.clock();click(b) end
            if plateIndex>=#plateOrder then plateDone=true end
        end
    end
end
local function solvePaper()
    local jump=btn("กระโดด",false)
    local toss=btn("โยน!",false)
    if not jump or not toss then return end
    for _,v in ipairs(list("TextLabel")) do
        if v:IsA("TextLabel") and (v.Text=="🐕" or v.Text=="🕳️" or v.Text=="🐈" or v.Text=="🧱") and v.Position.X.Scale>.135 and v.Position.X.Scale<.19 and not jumped[v] then
            if click(jump) then jumped[v]=true end
        end
    end
    local best:any=nil
    for _,v in ipairs(list("TextLabel")) do
        if v:IsA("TextLabel") and (v.Text=="📰 รับ นสพ." or v.Text=="🚫 ไม่รับ") then
            local f=v.Parent
            if f and f:IsA("GuiObject") and f.Position.X.Scale>=.15 and f.Position.X.Scale<=.37 then
                if not best or f.Position.X.Scale<best.Parent.Position.X.Scale then best=v end
            end
        end
    end
    if best and best.Text=="📰 รับ นสพ." and best.Parent.Position.X.Scale<.32 then click(toss) end
end
local function solvePolish(id)
    if os.clock()-lastScrub<.25 then return end
    lastScrub=os.clock()
    local canvas:any=nil
    for _,v in ipairs(list("CanvasGroup")) do if v:IsA("CanvasGroup") then
        for _,child in ipairs(v:GetChildren()) do
            if child:IsA("Frame") and child:FindFirstChildOfClass("UIGridLayout") and #child:GetChildren()>=96 then canvas=v;break end
        end
    end;if canvas then break end end
    if not canvas then return end
    if not isrbxactive() then say("ขัดเงิน • รอหน้าต่าง Roblox อยู่ในโฟกัส");return end
    local grid:any=nil
    for _,v in ipairs(canvas:GetChildren()) do if v:IsA("Frame") and v:FindFirstChildOfClass("UIGridLayout") then grid=v;break end end
    if not grid or grid.AbsoluteSize.X<1 then return end
    local a=grid.AbsolutePosition;local z=grid.AbsoluteSize
    polishRow=polishRow%8+1
    local row=polishRow
    local ok,err=pcall(function()
        local y=a.Y+(row-.5)*z.Y/8
        local x=a.X+z.X/24
        mousemoveabs(math.floor(x),math.floor(y));task.wait(.06)
        if not alive(id) or not isrbxactive() then return end
        mouse1press()
        for col=1,12 do
            if not alive(id) or not isrbxactive() then break end
            x=a.X+(col-.5)*z.X/12
            mousemoveabs(math.floor(x),math.floor(y))
            task.wait(.055)
        end
    end)
    pcall(mouse1release)
    if not ok then say("ขัดเงิน • "..tostring(err)) end
end
local function openJob(id)
    local j=jobs[selected];if not j then return end
    local prompt:any=nil
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Enabled and v.Name=="JobPrompt" and string.find(v:GetFullName(),j.shop,1,true) and v.Parent:IsA("BasePart") then prompt=v;break end
    end
    if not prompt then say("ไม่พบร้าน");return end
    say("เดินไปทำงาน • "..selected)
    if not direct.go(prompt.Parent.Position,prompt.MaxActivationDistance-1,function()return alive(id)end) or not alive(id) then return end
    fireproximityprompt(prompt);task.wait(.4)
    if not alive(id) then return end
    local result=remote:InvokeServer("AcceptMission",{MissionId=j.id})
    if result and result.Success then activeJob=selected;attempts+=1;coffeeRound="";pourStarted=0;table.clear(plateOrder);plateKey="";plateDone=false;table.clear(jumped);polishRow=0;say("รับงาน • "..selected)
    else say(tostring(result and result.Message or "รับงานไม่ได้")) end
    task.wait(.4)
end
local function tick(id)
    if not alive(id) then return end
    if label("ชงกาแฟโบราณตามออเดอร์") then activeJob="ชงกาแฟ" elseif btn("เครื่องดื่ม",false) then activeJob="จัดของชำ" elseif btn("สับ!",false) or label("จานที่ ") then activeJob="สับไก่และจัดจาน" elseif btn("โยน!",false) then activeJob="ส่งหนังสือพิมพ์" elseif label("เงาวับ") then activeJob="ขัดเครื่องเงิน" end
    local claim=btn("รับค่าจ้าง",false)
    if claim then
        local score=label("คะแนนฝีมือ")
        lastScore=if score and score:IsA("TextLabel") then tonumber(string.match(score.Text,"(%d+)%%")) or 0 else 0
        local before=extra.state().Cash
        if click(claim) then
            task.wait(.7)
            local gain=extra.state().Cash-before
            if gain>0 then count+=1;lastResult=(activeJob~="" and activeJob or "ไม่ทราบงาน").." • "..lastScore.."% • +"..gain.." ฿";history[#history+1]={job=activeJob,score=lastScore,gain=gain};activeJob="";say(lastResult);if once then enabled=false;serial+=1 end else say("ยังไม่ยืนยันเงินรางวัล") end
        end
        task.wait(1.2);return
    end
    local start=btn("เริ่มทำงาน!",false)
    if start then click(start);task.wait(.25);return end
    if btn("เสิร์ฟ!",false) then solveCoffee(id)
    elseif btn("เครื่องดื่ม",false) then solveGrocery();task.wait(.16)
    elseif btn("สับ!",false) or label("จานที่ ") then solveChicken(id)
    elseif btn("โยน!",false) then solvePaper()
    elseif label("เงาวับ") then solvePolish(id)
    elseif label("ค่าจ้าง ฿") or label("สับไก่ตามจังหวะ") then return
    else openJob(id);task.wait(1) end
end
local function toggle(v) enabled=v;serial+=1;say(v and "เริ่มงานอัตโนมัติ" or "ปิด Auto งานร้าน") end
local section=ui:Tab("JOB"):Section("งานร้านทั้ง 5 แบบ")
section:Dropdown({Name="เลือกงาน",Options={"จัดของชำ","ชงกาแฟ","สับไก่และจัดจาน","ขัดเครื่องเงิน","ส่งหนังสือพิมพ์"},Default=selected,Callback=function(v)selected=v;serial+=1 end})
section:Toggle({Name="ทำงานร้านอัตโนมัติ",Desc="อ่านข้อมูลมินิเกมจริงและรับค่าจ้าง",Default=false,Callback=function(v)once=false;toggle(v)end})
section:Label("ปิด Auto ใน MAIN ก่อนใช้ JOB • ใช้การเดินปกติในการทดสอบ")
section:Label("ขัดเครื่องเงินต้องโฟกัสหน้าต่าง Roblox • ยังไม่ผ่าน QA")
section:Button({Name="สถานะงานล่าสุด",Callback=function()say(lastResult~="" and lastResult or status)end})
e.__MoyJobV15={qa=function(v,j)if j then selected=j end;once=true;toggle(v)end,status=function()return {enabled=enabled,count=count,score=lastScore,result=lastResult,status=status,attempts=attempts,activeJob=activeJob,history=history}end}
local life:any=(getfenv() :: any).STATE
if life then life.onCleanup(function()running=false;enabled=false;serial+=1;e.__MoyJobV15=nil end)end
task.spawn(function()
    while running and ui.Root.Parent do
        if enabled then local id=serial;local ok,err=xpcall(function()tick(id)end,debug.traceback);if not ok then say("JOB • "..tostring(err));task.wait(1) end end
        rs.Heartbeat:Wait()
    end
end)
]=],"MoyXHub_ThaiAmulet_JobsV20.lua")
assert(fn,tostring(err))
fn()
end

-- MoyXHub_ThaiAmulet_RecoveryV23.lua
do
local fn,err=loadstring([=[
-- MoyXHub V22: settings persistence and guarded recovery.
local e=getgenv()
local ui:any=e.__MoyXHubUIOnly
local base:any=e.__MoyAutoV1
local jobs:any=e.__MoyJobV15
local ext:any=e.__MoyAutoV6
assert(ui and base and jobs and ext,"Load V13, V21 and V20 first")
local p=game:GetService("Players").LocalPlayer
local http=game:GetService("HttpService")
local file="MoyXHub_ThaiAmulet_Config_v2.json"
local opts={threshold=85,restore=98,autoSave=false,scale=1}
local running=true
local paused=false
local message="พร้อมใช้งาน"
local previousCharacter=p.Character
local lastSave=0
local recoveries=0
local function say(t:string) message=t;pcall(function()ui:SetStatus(t)end) end
local function decision(hp:number,maxHP:number,changed:boolean,waiting:boolean):string
    if changed or hp<=0 or maxHP<=0 then return "stop" end
    local pct=hp/maxHP*100
    if waiting then return if pct>=opts.restore then "ready" else "wait" end
    return if pct<opts.threshold then "stop" else "normal"
end
local function stopAll()
    base.qa(false);jobs.qa(false);ext.stop()
    local c=p.Character
    local h=c and c:FindFirstChildOfClass("Humanoid")
    local r=c and c:FindFirstChild("HumanoidRootPart")
    if h and r and r:IsA("BasePart") then h:MoveTo(r.Position) end
end
local function save():boolean
    local data={version=2,place=game.PlaceId,scale=opts.scale,threshold=opts.threshold,restore=opts.restore,autoSave=opts.autoSave}
    local ok,err=pcall(function()writefile(file,http:JSONEncode(data))end)
    if ok then lastSave=os.clock();say("บันทึกการตั้งค่าแล้ว") else say("บันทึกไม่ได้ • "..tostring(err)) end
    return ok
end
local function load():boolean
    local ok,data=pcall(function()
        if not isfile(file) then return nil end
        return http:JSONDecode(readfile(file))
    end)
    if not ok or type(data)~="table" or data.version~=2 or data.place~=game.PlaceId then say("ไม่พบ Config ที่ตรงกับแมพ");return false end
    if type(data.scale)=="number" then opts.scale=math.clamp(data.scale,.75,1.25);ui:SetScale(opts.scale) end
    if type(data.threshold)=="number" then opts.threshold=math.clamp(data.threshold,65,95) end
    if type(data.restore)=="number" then opts.restore=math.clamp(data.restore,opts.threshold,100) end
    opts.autoSave=data.autoSave==true
    say("โหลดการตั้งค่าแล้ว • ไม่เปิด Auto เอง")
    return true
end
local function update()
    if opts.autoSave then save() end
end
local function tick()
    local c=p.Character
    local h=c and c:FindFirstChildOfClass("Humanoid")
    local changed=c~=previousCharacter
    previousCharacter=c
    local hp=h and h.Health or 0
    local maxHP=h and h.MaxHealth or 0
    local d=decision(hp,maxHP,changed,paused)
    if d=="stop" then
        if not paused then recoveries+=1 end
        paused=true
        stopAll()
        say("พักฟื้น • หยุด Auto ทุกระบบ")
    elseif d=="wait" then
        if base.enabled() or jobs.status().enabled then stopAll() end
        for _,v in pairs(ext.flags) do if v then stopAll();break end end
    elseif d=="ready" then
        paused=false
        say("ฟื้นฟูแล้ว • พร้อมให้เปิด Auto ใหม่")
    end
    if opts.autoSave and os.clock()-lastSave>=30 then save() end
end
if isfile(file) then load() end
local sec=ui:Tab("RECOVERY"):Section("ป้องกันเสียชีวิต")
sec:Slider({Name="หยุด Auto เมื่อ HP ต่ำกว่า",Min=65,Max=95,Step=5,Default=opts.threshold,Suffix="%",Callback=function(v)opts.threshold=v;opts.restore=math.max(v,opts.restore);update()end})
sec:Slider({Name="ฟื้นฟูจนถึง HP",Min=95,Max=100,Step=1,Default=opts.restore,Suffix="%",Callback=function(v)opts.restore=math.max(v,opts.threshold);update()end})
sec:Button({Name="หยุด Auto ทุกระบบทันที",Callback=function()stopAll();say("หยุดทั้งหมดแล้ว")end})
sec:Label("หยุดเมื่อเลือดต่ำหรือเกิดใหม่ • ไม่ใช้ยาอัตโนมัติ")
local cfg=ui:Tab("CONFIG"):Section("บันทึกการตั้งค่า")
cfg:Toggle({Name="บันทึกการตั้งค่าอัตโนมัติ",Default=opts.autoSave,Callback=function(v)opts.autoSave=v;save()end})
cfg:Slider({Name="ขนาด UI ที่บันทึก",Min=75,Max=125,Step=5,Default=math.floor(opts.scale*100+.5),Suffix="%",Callback=function(v)opts.scale=v/100;ui:SetScale(opts.scale);update()end})
cfg:Button({Name="บันทึก Config",Callback=function()save()end})
cfg:Button({Name="โหลด Config",Callback=function()load()end})
cfg:Label("บันทึกขนาด UI และเกณฑ์ HP • ไม่บันทึกสวิตช์เปิด Auto")
cfg:Label("โหลดค่าขณะเริ่มสคริปต์ • สไลเดอร์ปรับได้จากแท็บนี้")
e.__MoyV22={save=save,load=load,options=opts,decision=decision,applyScale=function(v) opts.scale=math.clamp(v,.75,1.25);ui:SetScale(opts.scale);update() end,stop=stopAll,status=function()return {paused=paused,recoveries=recoveries,status=message}end}
local life:any=(getfenv() :: any).STATE
if life then life.onCleanup(function()running=false;e.__MoyV22=nil end)end
task.spawn(function()
    while running and ui.Root.Parent do
        local ok,err=pcall(tick)
        if not ok then say("RECOVERY • "..tostring(err)) end
        task.wait(.5)
    end
end)
]=],"MoyXHub_ThaiAmulet_RecoveryV23.lua")
assert(fn,tostring(err))
fn()
end

-- MoyXHub_SidebarScroll.lua
do
local fn,err=loadstring([=[
-- MoyXHub sidebar scrolling fix. Load after UI and tabs.
local env=getgenv()
local ui:any=env.__MoyXHubUIOnly
assert(ui and ui.Root,"MoyXHub UI not loaded")
local root=ui.Root
local main=root:FindFirstChild("TabBtn_MAIN",true)
assert(main and main:IsA("TextButton"),"MAIN tab missing")
local dock=main.Parent
assert(dock and dock:IsA("GuiObject"),"Dock missing")
local player=dock:FindFirstChild("DockPlayer")
local clock=dock:FindFirstChild("DockClock")
local lens=dock:FindFirstChild("DockLens")
local oldPlayer=player and player:IsA("GuiObject") and player.Position
local oldClock=clock and clock:IsA("GuiObject") and clock.Position
local oldClip=dock.ClipsDescendants
local scroll=Instance.new("ScrollingFrame")
scroll.Name="MoyTabScroll"
scroll.BackgroundTransparency=1
scroll.BorderSizePixel=0
scroll.Position=UDim2.fromOffset(0,0)
scroll.Size=UDim2.new(1,0,1,-56)
scroll.CanvasSize=UDim2.fromOffset(0,0)
scroll.AutomaticCanvasSize=Enum.AutomaticSize.None
scroll.ScrollingDirection=Enum.ScrollingDirection.Y
scroll.ScrollBarThickness=3
scroll.ScrollBarImageColor3=Color3.fromRGB(177,91,255)
scroll.ScrollBarImageTransparency=.2
scroll.ElasticBehavior=Enum.ElasticBehavior.Never
scroll.ClipsDescendants=true
scroll.Active=true
scroll.ZIndex=dock.ZIndex
scroll.Parent=dock
dock.ClipsDescendants=true
if player and player:IsA("GuiObject") then player.Position=UDim2.new(0,10,1,-36) end
if clock and clock:IsA("GuiObject") then clock.Position=UDim2.new(0,10,1,-19) end
local links:{RBXScriptConnection}={}
local alive=true
local function refresh()
    if not alive or not scroll.Parent then return end
    local bottom=0
    for _,v in ipairs(scroll:GetChildren()) do
        if v:IsA("TextButton") and string.sub(v.Name,1,7)=="TabBtn_" then
            bottom=math.max(bottom,v.Position.Y.Offset+v.Size.Y.Offset)
        end
    end
    scroll.CanvasSize=UDim2.fromOffset(0,bottom+12)
end
local function adopt(v:Instance)
    if v==lens or (v:IsA("TextButton") and string.sub(v.Name,1,7)=="TabBtn_") then
        v.Parent=scroll
        if v:IsA("TextButton") then
            table.insert(links,v:GetPropertyChangedSignal("Position"):Connect(refresh))
            table.insert(links,v:GetPropertyChangedSignal("Size"):Connect(refresh))
        end
        refresh()
    end
end
for _,v in ipairs(dock:GetChildren()) do adopt(v) end
table.insert(links,dock.ChildAdded:Connect(adopt))
table.insert(links,scroll.ChildRemoved:Connect(refresh))
refresh()
env.__MoySidebarScroll=scroll
local life:any=(getfenv() :: any).STATE
if life then life.onCleanup(function()
    alive=false
    for _,c in ipairs(links) do c:Disconnect() end
    if dock.Parent and scroll.Parent then
        for _,v in ipairs(scroll:GetChildren()) do v.Parent=dock end
        dock.ClipsDescendants=oldClip
        if player and player:IsA("GuiObject") and oldPlayer then player.Position=oldPlayer end
        if clock and clock:IsA("GuiObject") and oldClock then clock.Position=oldClock end
    end
    scroll:Destroy()
    env.__MoySidebarScroll=nil
end) end
]=],"MoyXHub_SidebarScroll.lua")
assert(fn,tostring(err))
fn()
end

-- MoyXHub_MobileResponsive.lua
do
local fn,err=loadstring([=[
-- MoyXHub adaptive mobile layout. Load after SidebarScroll.
local env=getgenv()
local ui:any=env.__MoyXHubUIOnly
local root=ui and ui.Root
assert(root,"MoyXHub UI not loaded")
local input=game:GetService("UserInputService")
local container=root:WaitForChild("Container") :: Frame
local scale=container:FindFirstChildOfClass("UIScale")
local title=root:FindFirstChild("Title",true) :: TextLabel
local controls=title.Parent:FindFirstChild("RightControls") :: Frame
local header=title:FindFirstAncestor("SlabRoot") :: Frame
local scroll=env.__MoySidebarScroll :: ScrollingFrame
assert(scroll and scroll.Parent,"Load SidebarScroll first")
local dock=scroll:FindFirstAncestor("SlabRoot") :: Frame
local page=root:FindFirstChild("Page_MAIN",true) :: ScrollingFrame
local body=page:FindFirstAncestor("SlabRoot") :: Frame
local status=root:FindFirstChild("StatusText",true) :: TextLabel
local footer=status:FindFirstAncestor("SlabRoot") :: Frame
local grip=container:FindFirstChild("ResizeGrip") :: GuiObject
local orb=root:FindFirstChild("PrismOrb") :: GuiObject
local running=true
local mobile=false
local portrait=false
local menuOpen=false
local preview:Vector2?=nil
local previousView:Vector2?=nil
local previousScale=0
local connections:{RBXScriptConnection}={}
local original={}
local function remember(v:GuiObject)
    if not original[v] then original[v]={Size=v.Size,Position=v.Position,Visible=v.Visible,AnchorPoint=v.AnchorPoint} end
end
for _,v in ipairs({container,header,dock,body,footer,controls,title,grip,orb,scroll}) do remember(v) end
local function bind(s:RBXScriptSignal,f:any) table.insert(connections,s:Connect(f)) end
local function button(parent:Instance,name:string,text:string):TextButton
    local b=Instance.new("TextButton")
    b.Name=name;b.Text=text;b.Font=Enum.Font.SourceSansSemibold;b.TextSize=17
    b.BackgroundColor3=Color3.fromRGB(39,28,62);b.TextColor3=Color3.fromRGB(247,239,255)
    b.BackgroundTransparency=.06;b.AutoButtonColor=true;b.ZIndex=20;b.Parent=parent
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,9);corner.Parent=b
    local stroke=Instance.new("UIStroke");stroke.Color=Color3.fromRGB(177,91,255);stroke.Transparency=.35;stroke.Parent=b
    return b
end
local menu=button(title.Parent,"MoyTouchMenu","เมนู")
local hide=button(title.Parent,"MoyTouchHide","ซ่อน")
local open=button(root,"MoyTouchOpen","MH")
open.TextColor3=Color3.fromRGB(215,180,255)
open.AnchorPoint=Vector2.new(1,.5)
open.Position=UDim2.new(1,-14,.32,0)
open.Size=UDim2.fromOffset(54,54)
open.ZIndex=100
local function restore(v:GuiObject)
    local x=original[v]
    if x and v.Parent then v.Size=x.Size;v.Position=x.Position;v.AnchorPoint=x.AnchorPoint;v.Visible=x.Visible end
end
local function desktop()
    if mobile then
        for v in pairs(original) do restore(v) end
    end
    mobile=false;portrait=false;menuOpen=false
    menu.Visible=false;hide.Visible=false;open.Visible=false
end
local function arrangeTabs(on:boolean)
    local buttons={}
    for _,b in ipairs(scroll:GetChildren()) do
        if b:IsA("TextButton") and string.sub(b.Name,1,7)=="TabBtn_" then remember(b);buttons[#buttons+1]=b end
    end
    table.sort(buttons,function(a,b) return original[a].Position.Y.Offset<original[b].Position.Y.Offset end)
    local lens=scroll:FindFirstChild("DockLens")
    if lens and lens:IsA("GuiObject") then remember(lens) end
    if on then
        local logical=math.max(42,math.ceil(44/math.max(.1,scale and scale.Scale or 1)))
        for i,b in ipairs(buttons) do
            local selected=lens and lens:IsA("GuiObject") and math.abs(lens.Position.Y.Offset-b.Position.Y.Offset)<1
            b.Size=UDim2.new(1,-16,0,logical)
            b.Position=UDim2.fromOffset(8,8+(i-1)*(logical+6))
            if selected and lens and lens:IsA("GuiObject") then lens.Size=b.Size;lens.Position=b.Position end
        end
    end
end
local function viewSize():Vector2
    local cam=workspace.CurrentCamera
    return preview or (cam and cam.ViewportSize or Vector2.new(680,440))
end
local function layout(force:boolean?)
    if not running or not container.Parent then return end
    local view=viewSize()
    local k=scale and scale.Scale or 1
    if k<.1 then k=1 end
    local shouldMobile=preview~=nil or input.TouchEnabled or view.X<760 or view.Y<500
    if not shouldMobile then desktop();previousView=view;previousScale=k;return end
    local newPortrait=view.Y>view.X
    if not force and mobile and previousView==view and math.abs(previousScale-k)<.001 then return end
    if not mobile or newPortrait~=portrait then menuOpen=false end
    mobile=true;portrait=newPortrait
    previousView=view;previousScale=k
    local w=math.floor((view.X-20)/k)
    local h=math.floor((view.Y-24)/k)
    if not portrait then w=math.min(w,760);h=math.min(h,540) end
    local top=math.max(56,math.ceil(54/k))
    local foot=34
    local gap=8
    local side=math.max(108,math.ceil(118/k))
    container.Size=UDim2.fromOffset(w,h)
    container.AnchorPoint=Vector2.new(.5,.5)
    container.Position=UDim2.fromScale(.5,.5)
    header.Size=UDim2.fromOffset(w,top)
    header.Position=UDim2.fromOffset(0,0)
    controls.Visible=false;grip.Visible=false
    title.Position=UDim2.new(0,50,.5,0)
    title.Size=UDim2.fromOffset(math.max(65,w-50-126),22)
    local touchW=math.max(52,math.ceil(48/k))
    local touchH=math.max(42,math.ceil(44/k))
    hide.AnchorPoint=Vector2.new(1,.5);hide.Size=UDim2.fromOffset(touchW,touchH);hide.Position=UDim2.new(1,-8,.5,0);hide.Visible=true
    menu.AnchorPoint=Vector2.new(1,.5);menu.Size=UDim2.fromOffset(touchW,touchH);menu.Position=UDim2.new(1,-touchW-14,.5,0);menu.Visible=portrait
    menu.Text=menuOpen and "กลับ" or "เมนู"
    local y=top+gap
    local bw=portrait and w or w-side-gap
    local bx=portrait and 0 or side+gap
    dock.Position=UDim2.fromOffset(0,y);dock.Size=UDim2.fromOffset(portrait and w or side,math.max(80,h-y))
    dock.Visible=container.Visible and (not portrait or menuOpen)
    body.Position=UDim2.fromOffset(bx,y);body.Size=UDim2.fromOffset(bw,math.max(60,h-y-foot-gap))
    body.Visible=container.Visible and (not portrait or not menuOpen)
    footer.Position=UDim2.fromOffset(bx,h-foot);footer.Size=UDim2.fromOffset(bw,foot)
    footer.Visible=body.Visible
    scroll.ScrollBarThickness=6
    arrangeTabs(true)
    for _,v in ipairs(body:GetDescendants()) do
        if v:IsA("ScrollingFrame") then v.ScrollBarThickness=5;v.ScrollingDirection=Enum.ScrollingDirection.Y end
    end
    if orb then orb.Visible=false end
    open.Visible=not container.Visible
end
bind(menu.Activated,function() menuOpen=not menuOpen;layout(true) end)
bind(hide.Activated,function()ui:Toggle(false);task.defer(function()if mobile then open.Visible=true;if orb then orb.Visible=false end end end)end)
bind(open.Activated,function()ui:Toggle(true);task.delay(.1,function()layout(true)end)end)
local function attachTab(v:Instance)
    if v:IsA("TextButton") and string.sub(v.Name,1,7)=="TabBtn_" then
        bind(v.MouseButton1Click,function()
            if mobile and portrait then menuOpen=false;task.defer(function()layout(true)end) end
        end)
    end
end
for _,v in ipairs(scroll:GetChildren()) do attachTab(v) end
bind(scroll.ChildAdded,function(v)attachTab(v);task.defer(function()layout(true)end)end)
bind(container:GetPropertyChangedSignal("Visible"),function()
    if mobile then task.defer(function()layout(true)end) end
end)
local cam=workspace.CurrentCamera
if cam then bind(cam:GetPropertyChangedSignal("ViewportSize"),function()task.defer(function()layout(true)end)end) end
if scale then bind(scale:GetPropertyChangedSignal("Scale"),function()task.defer(function()layout(true)end)end) end
layout(true)
env.__MoyMobileUI={preview=function(v:Vector2?) preview=v;layout(true) end,menu=function(v:boolean)menuOpen=v;layout(true)end,state=function()return {mobile=mobile,portrait=portrait,menu=menuOpen,view=viewSize(),size=container.AbsoluteSize,body=body.Visible,dock=dock.Visible,open=open.Visible}end}
local life:any=(getfenv() :: any).STATE
if life then life.onCleanup(function()
    running=false
    for _,c in ipairs(connections) do c:Disconnect() end
    desktop()
    menu:Destroy();hide:Destroy();open:Destroy()
    env.__MoyMobileUI=nil
end) end
]=],"MoyXHub_MobileResponsive.lua")
assert(fn,tostring(err))
fn()
end
