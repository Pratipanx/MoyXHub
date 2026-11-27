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


-- MoyXHub | School Duel: single-file gameplay controller, phase 1.
local P=game:GetService("Players").LocalPlayer
local RS=game:GetService("ReplicatedStorage")
local PG=P:WaitForChild("PlayerGui")
local ctl:any={Running=true,AutoJoin=false,AutoStart=false,AutoSetup=false,AutoMath=false,Answers=0,LastAnswerKey="",LastAnswer="",Monitor=true,Delay=3,Size="ทั้งหมด",LastAction=0,LastState="",Joins=0,Starts=0}
if type(env.MoySchool)=="table" then env.MoySchool.Running=false end
env.MoySchool=ctl
local function say(s:string)
    ctl.LastState=s
    pcall(function() UI:SetStatus(s) end)
end
local function visible(v:Instance?):boolean
    while v and v~=PG do
        if v:IsA("GuiObject") and not v.Visible then return false end
        if v:IsA("LayerCollector") and not v.Enabled then return false end
        v=v.Parent
    end
    return v==PG
end
local function humanoid():Humanoid?
    return P.Character and P.Character:FindFirstChildOfClass("Humanoid")
end
local function quiz():boolean
    local g=PG:FindFirstChild("QuizHUD")
    return g~=nil and g:IsA("ScreenGui") and g.Enabled
end
local function crossActive():boolean
    local g=PG:FindFirstChild("WordCrossHUD")
    return g~=nil and g:IsA("ScreenGui") and g.Enabled
end
local function picker():boolean
    local g=PG:FindFirstChild("CategoryPicker")
    return visible(g and g:FindFirstChild("MainPanel"))
end
local function seat():Seat?
    local h=humanoid()
    local tables=workspace:FindFirstChild("Tables")
    local root=P.Character and P.Character:FindFirstChild("HumanoidRootPart")
    if not (h and tables and root and root:IsA("BasePart")) then return nil end
    local best:Seat?=nil
    local dist=math.huge
    for _,m in ipairs(tables:GetChildren()) do
        local candidates:{Seat}={}
        local total=0
        local occupied=false
        for _,v in ipairs(m:GetDescendants()) do
            if v:IsA("Seat") then
                total+=1
                if v.Occupant then occupied=true elseif not v.Disabled then table.insert(candidates,v) end
            end
        end
        if not occupied and (ctl.Size=="ทั้งหมด" or tostring(total)==ctl.Size) then
            for _,v in ipairs(candidates) do
                local d=(v.Position-root.Position).Magnitude
                if d<dist then best=v;dist=d end
            end
        end
    end
    return best
end
local function join()
    local h=humanoid()
    if not (h and h.Health>0 and P.Character) or h.Sit or quiz() or crossActive() or picker() then return end
    local target=seat()
    if not target then say("ไม่พบโต๊ะว่างตามตัวเลือก");return end
    -- Same seating route as the game's QuickPlayNewbie button.
    P.Character:PivotTo(target.CFrame+Vector3.new(0,3,0))
    ctl.LastAction=os.clock()
    say("กำลังเข้าโต๊ะ "..target.Parent.Name)
end
local function solo():boolean
    local h=humanoid()
    local t=workspace:FindFirstChild("Tables")
    if not (h and h.SeatPart and t and h.SeatPart:IsDescendantOf(t)) then return false end
    local m:Instance?=h.SeatPart
    while m and m.Parent~=t do m=m.Parent end
    if not m then return false end
    for _,v in ipairs(m:GetDescendants()) do
        if v:IsA("Seat") and v.Occupant and v.Occupant~=h and game:GetService("Players"):GetPlayerFromCharacter(v.Occupant.Parent) then return false end
    end
    return true
end
local function nativeClick(b:Instance?,signal:string,source:string):boolean
    if not (b and b:IsA("GuiButton") and visible(b)) then return false end
    local button:any=b
    for _,c in ipairs(getconnections(button[signal])) do
        local f=c.Function
        if c.Enabled and type(f)=="function" then
            local s=debug.info(f,"s")
            if s and string.find(s,source,1,true) then
                local ok,err=pcall(f)
                if not ok then say("ปุ่มเกมผิดพลาด: "..tostring(err)) end
                return ok
            end
        end
    end
    return false
end
local function start()
    if not solo() or quiz() or crossActive() or picker() then return end
    local bot=PG:FindFirstChild("BotOfferGui")
    if bot then
        for _,v in ipairs(bot:GetDescendants()) do
            if v:IsA("GuiButton") and visible(v) then
                local l=v:FindFirstChild("Label")
                if l and l:IsA("TextLabel") and l.Text=="ฝึกคนเดียว" then
                    if nativeClick(v,"MouseButton1Click","PlayerScripts.Minigames.BotOfferClient") then
                        ctl.LastAction=os.clock();return
                    end
                end
            end
        end
    end
    local t=PG:FindFirstChild("TableStartGui")
    if nativeClick(t and t:FindFirstChild("StartBtn"),"Activated","PlayerScripts.TableStartClient") then
        ctl.LastAction=os.clock();return
    end
    local party=PG:FindFirstChild("PartyUI")
    if nativeClick(party and party:FindFirstChild("StartBtn"),"Activated","PlayerScripts.PartyClient") then
        ctl.LastAction=os.clock()
    end
end

ctl.Mode="คณิตศาสตร์";ctl.AutoRewards=false;ctl.AutoQuest=false;ctl.AutoEvent=false;ctl.AutoCross=false
ctl.RewardConfirmed=0;ctl.QuestConfirmed=0;ctl.CrossMoves=0;ctl.RewardBusy=false;ctl.EventBusy=false
ctl.RewardStatus="";ctl.QuestStatus="";ctl.CrossStatus="";ctl.LastCross=0
local function labelText(v:Instance):string
    local l=v:FindFirstChildWhichIsA("TextLabel",true)
    return if l then l.Text else ""
end





local function hud(n:string):boolean
 local g=PG:FindFirstChild(n);return g~=nil and g:IsA("ScreenGui") and g.Enabled
end
local function playingAny():boolean return quiz() or crossActive() or hud("WordSearchHUD") or hud("DominoHUD") end
local function setup()
 if not solo() or not picker() or playingAny() then return end
 local g:any=PG:FindFirstChild("CategoryPicker");local b=g and g.MainPanel.Body;if not b then return end
 local modes={["ครอสอังกฤษ"]="WordCross",["ค้นหาคำ"]="WordSearch",["โดมิโน"]="Domino",["คณิตศาสตร์"]="Quiz"}
 local cats={["ครอสอังกฤษ"]="WC_English",["ค้นหาคำ"]="WS_All",["โดมิโน"]="Domino_Classic",["คณิตศาสตร์"]="Math"}
 local target:Instance?=nil
 if b.Step1View.Visible then target=b.Step1View.ModeScroll:FindFirstChild(modes[ctl.Mode] or "Quiz")
 elseif b.Step2View.Visible then target=b.Step2View.RightArea.ListScroll:FindFirstChild(cats[ctl.Mode] or "Math",true)
 elseif b.Step3View.Visible and ctl.AutoStart then
  for _,v in ipairs(b.Step3View:GetDescendants()) do
   if v:IsA("GuiButton") then local t=labelText(v)
    if (ctl.Mode=="ครอสอังกฤษ" and (t=="9x9 เล็ก" or t=="5 นาที")) or (ctl.Mode=="ค้นหาคำ" and t=="ง่าย") or (ctl.Mode=="โดมิโน" and (t=="เล็ก 0-6 (28)" or t=="1 ยกจบ" or t=="ง่าย")) then nativeClick(v,"Activated","TableCategoryPicker") end
   end
  end
  target=b.Step3View.StartWaitBtn:FindFirstChild("Btn")
 end
 if target and nativeClick(target,"Activated","TableCategoryPicker") then ctl.LastAction=os.clock() end
end
local function solveMath(q:string):number?
 q=q:gsub("×","*"):gsub("÷","/"):gsub("−","-"):gsub("–","-")
 local e=q:match("^%s*(.-)%s*=%s*%?%s*$");if not e then return nil end
 e=e:gsub("%s+","");if #e>150 or e:find("[^%d%.%+%-%*%/%(%)]") then return nil end
 local i=1;local expr:any
 local function factor():number?
  local c=e:sub(i,i)
  if c=="+" or c=="-" then i+=1;local v=factor();if v==nil then return nil end;return if c=="-" then -v else v
  elseif c=="(" then i+=1;local v=expr();if v==nil or e:sub(i,i)~=")" then return nil end;i+=1;return v end
  local n=e:sub(i):match("^%d+%.?%d*");if not n then return nil end;i+=#n;return tonumber(n)
 end
 local function term():number?
  local x=factor();if x==nil then return nil end
  while true do local c=e:sub(i,i);if c~="*" and c~="/" then break end;i+=1;local y=factor();if y==nil or (c=="/" and y==0) then return nil end;x=if c=="*" then x*y else x/y end
  return x
 end
 expr=function():number?
  local x=term();if x==nil then return nil end
  while true do local c=e:sub(i,i);if c~="+" and c~="-" then break end;i+=1;local y=term();if y==nil then return nil end;x=if c=="+" then x+y else x-y end
  return x
 end
 local x=expr();if i<=#e or x==nil or math.abs(x)==math.huge or x~=x then return nil end;return x
end
ctl.SolveMath=solveMath
local function mathAnswer()
 if not quiz() then ctl.LastAnswerKey="";return end;if not solo() then return end
 local g:any=PG:FindFirstChild("QuizHUD");local root=g and g:FindFirstChild("Root");if not root then return end
 local card=root:FindFirstChild("QuestionCard");local q=card and card:FindFirstChild("QuestionText");local banner=card and card:FindFirstChild("Banner",true)
 local info=root:FindFirstChild("InfoText",true);local choices=root:FindFirstChild("Answers")
 if not (q and q:IsA("TextLabel") and visible(q) and banner and banner:IsA("TextLabel") and banner.Text=="ถึงตาคุณตอบ" and choices) then return end
 local k=q.Text.."|"..(if info and info:IsA("TextLabel") then info.Text else "");if ctl.LastAnswerKey==k then return end
 local ans=solveMath(q.Text);if ans==nil then return end;local target:GuiButton?=nil
 for _,v in ipairs(choices:GetChildren()) do if v:IsA("GuiButton") and v.Active and visible(v) then local l=v:FindFirstChild("Label");local n=if l and l:IsA("TextLabel") then tonumber(l.Text) else nil;if n and math.abs(n-ans)<.000001 then if target then return end;target=v end end end
 if target and nativeClick(target,"MouseButton1Click","PlayerScripts.Minigames.QuizClient") then ctl.LastAnswerKey=k;ctl.Answers+=1;ctl.LastAnswer=q.Text.." → "..tostring(ans) end
end
local function status():string
 local h=humanoid()
 if crossActive() then return "ครอสคำ • "..ctl.CrossStatus elseif hud("WordSearchHUD") then return "ค้นหาคำ • "..tostring(ctl.WSStatus) elseif hud("DominoHUD") then return "โดมิโน • "..tostring(ctl.DominoStatus)
 elseif quiz() then local q=PG.QuizHUD:FindFirstChild("QuestionText",true);return "กำลังเล่น: "..(if q and q:IsA("TextLabel") then q.Text else "ตอบคำถาม")
 elseif picker() then return "เลือกโหมดและหมวด" elseif h and h.Sit then return "นั่งโต๊ะแล้ว" else return "Lobby • พร้อมใช้งาน" end
end
local function invokeNative(v:GuiButton,source:string):boolean
 for _,c in ipairs(getconnections(v.MouseButton1Click)) do if c.Enabled and type(c.Function)=="function" and (debug.info(c.Function,"s") or ""):find(source,1,true) then local ok,e=pcall(c.Function);if not ok then ctl.LastError=tostring(e) end;return ok end end;return false
end
local function claim(rewards:boolean,quests:boolean)
 if not ctl.Running or ctl.RewardBusy or game.GameId~=10343576166 then return end;ctl.RewardBusy=true
 task.spawn(function()
  local ok,err=pcall(function()
   if rewards then
    local main=PG:FindFirstChild("Main");local frames=main and main:FindFirstChild("Frames")
    if frames then for _,name in ipairs({"DailyRewards","TimeRewards"}) do local fr=frames:FindFirstChild(name);local holder=fr and fr:FindFirstChild("Holder")
     if holder then for _,row in ipairs(holder:GetChildren()) do local btn=row:FindFirstChild("Redeem")
      if btn and btn:IsA("GuiButton") and btn.Visible and labelText(btn)=="รับ" then
       local src=if name=="DailyRewards" then "DailyRewardsController" else "PlaytimeRewardsController"
       if invokeNative(btn,src) then for _=1,15 do if labelText(btn)=="รับแล้ว" then break end;task.wait(.1) end;if labelText(btn)=="รับแล้ว" then ctl.RewardConfirmed+=1 end end
      end
     end end
    end end;ctl.RewardStatus="รับรางวัล "..ctl.RewardConfirmed
   end
   if quests then local rem:any=RS:FindFirstChild("QuestRemotes");if not rem then return end
    local data=rem.GetQuestData:InvokeServer();if type(data)~="table" then return end
    local done=0;local summary={}
    for i,v in ipairs(data.Quests or {}) do
     if v.Progress>=v.Target then
      if not v.Special then done+=1 end
      if not v.Claimed then rem.ClaimQuest:InvokeServer(i);local d=rem.GetQuestData:InvokeServer();if d and d.Quests and d.Quests[i] and d.Quests[i].Claimed then ctl.QuestConfirmed+=1;v.Claimed=true end end
     end
     table.insert(summary,tostring(v.Title).." "..v.Progress.."/"..v.Target..(if v.Claimed then " รับแล้ว" else ""))
    end
    if done>=3 and not data.BonusClaimed then rem.ClaimBonus:InvokeServer();local d=rem.GetQuestData:InvokeServer();if d and d.BonusClaimed then ctl.QuestConfirmed+=1 end end
    ctl.QuestStatus=table.concat(summary," | ")
   end
  end);ctl.RewardBusy=false;if not ok then ctl.LastError=tostring(err) end
 end)
end
ctl.Claim=claim
local function freeEvent()
 if not ctl.Running or ctl.EventBusy or game.GameId~=10343576166 then return end;ctl.EventBusy=true
 task.spawn(function()
  local ok,e=pcall(function()
   local cfg=RS:FindFirstChild("Configuration");local mod=cfg and cfg:FindFirstChild("LoyKrathong");if not mod or not mod:IsA("ModuleScript") then return end
   local data=require(mod);local ev=RS.MinigameRemotes.LoyKrathong
   for _,x in ipairs({{key="Leaf",flag="LKFreeToday"},{key="Lantern",flag="LKLanternFreeToday"}}) do local item=data.BY_KEY[x.key]
    if item and (item.Currency=="Free" or item.FreeDaily==true) and P:GetAttribute(x.flag)==false then local before=P:GetAttribute("LKOwned_"..x.key) or 0;ev:FireServer("Buy",x.key)
     for _=1,20 do if P:GetAttribute(x.flag)==true then break end;task.wait(.1) end
     if P:GetAttribute(x.flag)==true and (P:GetAttribute("LKOwned_"..x.key) or 0)>before then ctl.EventResult="รับฟรี "..x.key.." สำเร็จ" end
    end
   end
   if P:GetAttribute("LKFreeToday")==true and P:GetAttribute("LKLanternFreeToday")==true then ctl.EventResult="ใช้สิทธิ์ฟรีทั้งสองแล้ว" end
  end);ctl.EventBusy=false;if not ok then ctl.LastError=tostring(e) end
 end)
end
ctl.FreeEvent=freeEvent
local function eventStatus():string return "กระทงฟรี "..tostring(P:GetAttribute("LKFreeToday")).." | โคมฟรี "..tostring(P:GetAttribute("LKLanternFreeToday")).." | บุญ "..tostring(P:GetAttribute("LKMerit") or 0) end
local function releaseFree(key:string)
 if ctl.EventBusy or playingAny() or not ctl.Running then return end
 local h=humanoid();if not h or h.Sit or (P:GetAttribute("LKOwned_"..key) or 0)~=1 then return end
 if P:GetAttribute(if key=="Leaf" then "LKFreeToday" else "LKLanternFreeToday")~=true then return end
 ctl.EventBusy=true
 task.spawn(function()
  local ok,e=pcall(function()
   local map:any=workspace:FindFirstChild("Map");local zone=map and map:FindFirstChild("LoyKrathongZone");if not zone then return end
   local pr=if key=="Leaf" then zone.Ghats.MoatPiers.MoatPier_Left.FloatPrompt else zone.LanternField.LanternSpot1.LanternRelease.LanternPrompt
   local ev=RS.MinigameRemotes.LoyKrathong;local before=P:GetAttribute("LKMerit") or 0
   if P:GetAttribute("LKHeld")~=key then ev:FireServer("Hold",key);task.wait(.6) end
   if P:GetAttribute("LKHeld")~=key or not P.Character then return end
   P.Character:PivotTo(CFrame.new(pr.Parent.Position+Vector3.new(0,3,0)));task.wait(.8)
   local g:any=PG:FindFirstChild("LoyKrathongUI")
   for _=1,3 do if g and g.Enabled then break end;fireproximityprompt(pr);task.wait(.9) end
   if not g or not g.Enabled then return end
   for _,v in ipairs(g:GetDescendants()) do if v:IsA("GuiButton") and visible(v) and labelText(v)=="ขอให้มีความสุขทุกวัน" then invokeNative(v,"LoyKrathongClient");break end end
   local label=if key=="Leaf" then "ลอยกระทง" else "ปล่อยโคม"
   for _,v in ipairs(g:GetDescendants()) do if v:IsA("GuiButton") and visible(v) and labelText(v)==label then invokeNative(v,"LoyKrathongClient");break end end
   task.wait(1);ctl.EventResult=if (P:GetAttribute("LKOwned_"..key) or 0)==0 and (P:GetAttribute("LKMerit") or 0)>before then label.." สำเร็จ" else label.." ยังไม่ยืนยัน"
  end);ctl.EventBusy=false;if not ok then ctl.LastError=tostring(e) end
 end)
end
ctl.ReleaseFree=releaseFree
local function crossHint()
 if not crossActive() or not solo() then return end;local g:any=PG:FindFirstChild("WordCrossHUD")
 if labelText(g.Side.Header)~="ตาของคุณ" then return end
 for _,v in ipairs(g.Side.Buttons:GetDescendants()) do if v:IsA("GuiButton") and visible(v) and (tonumber(labelText(v):match("^ใบ้%s+(%d+)$")) or 0)>0 then invokeNative(v,"WordCrossClient");return end end
end
ctl.CrossHint=crossHint
local words,dict={},{}
for w in ("AM AN AS AT BE BY DO GO HE IF IN IS IT ME MY NO OF ON OR OX SO TO UP US WE ACE ACT ADD AGE AGO AID AIM AIR ALE ALL AND ANT ANY APE APP ARC ARE ARM ART ASH ASK ATE AWE AXE BAD BAG BAR BAT BAY BED BEE BET BIG BIN BIT BOW BOX BOY BUD BUG BUS BUT BUY CAB CAN CAP CAR CAT CAW COB COD COG CON COO COP COT COW COY CRY CUB CUP CUT DAD DAY DEN DEW DID DIE DIG DIM DIP DOG DOT DRY DUB DUE DUG DYE EAR EAT EEL EGG EGO ELF ELK ELM END ERA EVE EWE EYE FAN FAR FAT FAX FED FEE FEW FIG FIN FIR FIT FIX FLY FOE FOG FOR FOX FRY FUN FUR GAG GAP GAS GEL GEM GET GIN GOD GOO GOT GUM GUN GUT GUY GYM HAD HAM HAS HAT HAY HEN HER HEW HEX HEY HID HIM HIP HIS HIT HOB HOE HOG HOP HOT HOW HUB HUE HUG HUM HUT ICE ILL IMP INK ION IRE IVY JAM JAR JAW JAY JET JEW JOB JOG JOY JUG KEN KEY KID KIN KIT LAB LAD LAG LAP LAW LAY LEA LED LEE LEG LET LID LIE LIP LIT LOB LOG LOP LOT LOW LUG MAD MAN MAP MAT MAW MAY MEN MET MEW MID MIX MOB MOM MOP MOW MUD MUG NAB NAG NAP NAY NET NEW NIB NIL NIP NIT NOD NOR NOT NOW NUN NUT OAK OAR OAT ODD ODE OFF OIL OLD ONE OPT ORB ORE OUR OUT OVA OWE OWL OWN PAD PAL PAN PAP PAR PAT PAW PAY PEA PEG PEN PET PEW PIE PIG PIN PIP PIT POD POP POT POW POX PRO PRY PUB PUG PUN PUP PUT RAG RAM RAN RAP RAT RAW RAY RED REF REP RIB RID RIG RIM RIP ROB ROD ROE ROT ROW RUB RUE RUG RUM RUN RUT RYE SAC SAD SAG SAP SAT SAW SAY SEA SEE SET SEW SEX SHE SHY SIP SIR SIS SIT SIX SKI SKY SLY SOB SOD SON SOP SOW SOY SPA SPY SUB SUE SUM SUN SUP TAB TAD TAG TAN TAP TAR TAT TAX TEA TEE TEN THE THY TIC TIE TIN TIP TOE TON TOO TOP TOT TOW TOY TRY TUB TUG TWO URN USE VAN VAT VET VEX VIA VIE VOW WAD WAG WAR WAS WAX WAY WEB WED WEE WET WHO WHY WIG WIN WIT WOE WOK WON WOW YAK YAM YAP YAW YEA YES YET YOU ZAP ZEN ZIP ZOO ABLE ACID ACME ACRE AGED AIDE AIMS AIRS AKE ALAS ALTO AMEN AMID AMOK ANEW ANTE ANTS APES APEX ARCH AREA ARID ARMS ARMY ARTS ASKS ATOM AUNT AUTO AWAY AXIS BABE BACK BAKE BALD BALE BALL BALM BAND BANE BANG BANK BARE BARK BARN BASE BASH BASK BASS BATH BEAD BEAK BEAM BEAN BEAR BEAT BEEF BEEN BEER BELL BELT BEND BENT BEST BETA BIAS BIDE BIKE BILL BIND BIRD BITE BLOW BLUE BLUR BOAR BOAT BODY BOIL BOLD BOLT BOMB BOND BONE BONG BOOK BOOM BOON BOOT BORE BORN BOSS BOTH BOUT BOWL BOXY BRAG BRAN BRAT BRAY BRED BREW BRIM BRIT BROW BUCK BUDS BUFF BULB BULK BULL BUMP BUNK BUNT BURN BURP BURY BUSH BUSY BUTT BUZZ CAFE CAGE CAKE CALF CALL CALM CAME CAMP CANE CANT CAPE CARD CARE CARP CART CASE CASH CASK CAST CATS CAVE CELL CENT CHAT CHEF CHEW CHIN CHIP CHIT CHOP CHOW CITE CITY CLAD CLAM CLAN CLAP CLAW CLAY CLEF CLIP CLOD CLOG CLOT CLUB CLUE COAL COAT COAX COCK COCO CODA CODE COED COIL COIN COKE COLA COLD COLE COLT COMA COMB COME CONE COOK COOL COOP COPE COPY CORD CORE CORK CORN COST COSY COTS COUP COVE COWL COZY CRAB CRAM CRAP CRAW CREW CRIB CROP CROW CUBE CUBS CUFF CULL CULT CUPS CURB CURD CURE CURL CUTE DAME DAMN DAMP DARE DARK DARN DART DASH DATA DATE DAWN DAYS DEAD DEAF DEAL DEAN DEAR DECK DEED DEEM DEEP DEER DEFT DELI DELL DEMO DENT DENY DESK DIAL DICE DIET DILL DIME DINE DING DINT DIRT DISC DISH DISK DIVE DOCK DODO DOES DOGS DOLE DOLL DOLT DOME DONE DOOM DOOR DOPE DORM DOSE DOTE DOTS DOUR DOVE DOWN DOZE DRAB DRAG DRAW DREW DRIP DROP DRUG DRUM DUAL DUCK DUDE DUEL DUES DUET DUKE DULL DUMB DUMP DUNE DUNG DUNK DUSK DUST DUTY DYED EACH EARL EARN EARS EASE EAST EASY EATS ECHO EDGE EDIT EELS EGGS ELKS EMIT ENDS ENVY EPIC EROS ETCH EVEN EVER EVIL EXAM EXIT EYED EYES FACE FACT FADE FAIL FAIR FAKE FALL FAME FANG FARE FARM FAST FATE FAWN FAZE FEAR FEAT FEED FEEL FEES FEET FELL FELT FEND FERN FEUD FIEF FIJI FILE FILL FILM FINE FINK FIRE FIRM FISH FIST FIVE FLAG FLAK FLAN FLAP FLAT FLAW FLAX FLEA FLED FLEE FLEW FLEX FLIP FLIT FLOP FLOW FLUE FOAL FOAM FOGS FOIL FOLD FOLK FOND FONT FOOD FOOL FOOT FORD FORE FORK FORM FORT FOUL FOUR FOWL FRED FREE FRET FROG FROM FUEL FULL FUME FUND FUNK FUSE FUSS GAIN GAIT GALA GALE GAME GANG GAPE GASH GASP GATE GAVE GAWK GAZE GEAR GEEK GELD GELS GENE GENT GERM GIFT GILL GILT GIRL GIST GIVE GLAD GLEE GLEN GLIB GLOB GLOP GLOW GLUE GLUM GOAD GOAL GOAT GOER GOES GOLD GOLF GONE GOOD GOOF GORE GORY GOSH GOTH GOUT GOWN GRAB GRAD GRAM GRAY GREW GREY GRID GRIM GRIN GRIP GRIT GROW GRUB GULF GULL GULP GURU GUSH GUST GUTS HACK HAIL HAIR HAKE HALE HALF HALL HALO HALT HAND HANG HANK HARD HARE HARK HARM HARP HASH HAST HATE HATS HAUL HAVE HAWK HAZE HEAD HEAL HEAP HEAR HEAT HEED HEEL HEIR HELD HELL HELM HELP HEMP HENS HERB HERD HERE HERO HERS HEWN HIDE HIGH HIKE HILL HILT HIND HINT HIRE HISS HITS HIVE HOAX HOBO HOCK HOED HOES HOGS HOLD HOLE HOLM HOLY HOME HONE HONG HOOD HOOF HOOK HOOP HOOT HOPE HORN HOSE HOST HOUR HOWL HUFF HUGE HULL HUMP HUNG HUNK HUNT HURL HURT HUSH HUSK HYMN HYPE ICED ICON IDEA IDLE IDOL IFFY INCH INFO INKS INKY INTO IONS IOTA IRIS IRON ISLE ITEM JACK JADE JAIL JAMB JAMS JANE JARS JAVA JAWS JAZZ JEAN JEEP JEST JETS JIBE JILT JIVE JOBS JOCK JOGS JOIN JOKE JOLT JUDO JUGS JUKE JUMP JUNE JUNK JURY JUST KALE KART KEEL KEEN KEEP KELP KENT KEPT KERN KEYS KHAN KICK KIDS KILL KILN KILO KILT KIND KING KINK KISS KITE KNEE KNEW KNIT KNOB KNOT KNOW LACE LACK LACY LADY LAID LAIN LAIR LAKE LAMB LAME LAMP LAND LANE LANK LARD LARK LASH LAST LATE LAUD LAVA LAWN LAWS LAYS LAZE LAZY LEAD LEAF LEAK LEAN LEAP LEEK LEER LEFT LEND LENS LENT LESS LEST LEVI LEWD LIAR LICE LICK LIED LIEF LIEN LIES LIEU LIFE LIFT LIKE LILY LIMB LIME LIMP LINE LINK LINT LION LIPS LIRA LIST LITE LIVE LOAD LOAF LOAM LOAN LOBE LOCH LOCK LOFT LOGO LOIN LOLL LONE LONG LOOK LOOM LOOP LOOT LORD LORE LOSE LOSS LOST LOTH LOUD LOUT LOVE LOWS LUCE LUCK LULL LUMP LUNA LUNG LURE LURK LUSH LUST LUTE LYNX LYRE MACE MADE MAIL MAIN MALE MALL MALT MAMA MANE MANY MARE MARK MARS MART MASH MASK MASS MAST MATE MATH MAUL MAZE MEAD MEAL MEAN MEAT MEEK MEET MELD MELT MEMO MEND MENU MERE MESH MESS MICE MILD MILE MILK MILL MIME MIND MINE MINK MINT MIRE MISS MIST MITE MOAN MOAT MOCK MODE MOLD MOLE MOLT MONK MOOD MOON MOOR MOOT MOPE MORE MORN MOSS MOST MOTH MOVE MOWN MULE MULL MUSE MUSH MUST MUTE MYTH NAIL NAME NAPE NAVY NEAR NEAT NECK NEED NEON NERD NEST NEWS NEXT NICE NICK NIGH NINE NOAH NODE NOEL NONE NOOK NOON NORM NOSE NOSY NOTE NOUN NOVA NUMB NUTS OATH OBEY OBOE ODDS ODES ODOR OGRE OILY OINK OKAY OMEN OMIT ONCE ONES ONLY ONTO ONUS OOZE OPAL OPEN ORES ORGY ORCA ORAL OVAL OVEN OVER OWED OWLS PACE PACK PACT PAGE PAID PAIL PAIN PAIR PALE PALM PANE PANG PANT PAPA PARE PARK PART PASS PAST PATE PATH PAVE PAWN PAYS PEAK PEAL PEAR PEAS PEAT PECK PEEL PEEP PEER PELT PENS PEON PERK PERM PERT PEST PETS PICK PIER PIES PIGS PIKE PILE PILL PIMP PINE PING PINK PINT PIPE PITH PITY PLAN PLAT PLAY PLEA PLOD PLOP PLOT PLOW PLOY PLUG PLUM PLUS POEM POET POKE POLE POLL POLO POMP POND PONE PONY POOL POOR POPE PORE PORK PORT POSE POSH POST POTS POUR POUT PRAY PREP PREY PRIM PROD PROP PROW PUCK PUFF PULL PULP PUMA PUMP PUNK PUNT PUNY PUPA PURE PURR PUSH PUSS PUTS QUAD QUAY QUID QUIP QUIT QUIZ RACE RACK RACY RAFT RAGE RAGS RAID RAIL RAIN RAKE RAMP RANG RANK RANT RAPT RARE RASH RASP RATE RATS RAVE RAYS RAZE READ REAL REAM REAP REAR RECK REED REEF REEK REEL REIN RELY REND RENT REST RHEA RICE RICH RICK RIDE RIFE RIFF RIFT RILE RILL RIME RIMS RIND RING RIOT RIPE RISE RISK RITE ROAD ROAM ROAN ROAR ROBE ROCK RODE ROIL ROLE ROLL ROMP ROOF ROOK ROOM ROOT ROPE ROSE ROSY ROTA ROTE ROTS ROVE ROWS RUBE RUBY RUDE RUIN RULE RUMP RUNE RUNG RUNS RUNT RUSE RUSH RUST RUTH SACK SAGE SAGO SAID SAIL SAKE SALE SALT SAME SAND SANE SANG SANK SARI SASH SATE SAVE SCAB SCAM SCAN SCAR SCAT SCUM SEAL SEAM SEAR SEAS SEAT SECT SEED SEEK SEEM SEEN SEER SELF SELL SEND SENT SERA SERF SETS SEWN SHAD SHAG SHAM SHED SHIM SHIN SHIP SHOE SHOO SHOP SHOT SHOW SHUN SHUT SICK SIDE SIFT SIGH SIGN SILK SILL SILO SILT SINE SING SINK SIRE SITE SITS SIZE SKEW SKID SKIM SKIN SKIP SKIT SLAB SLAG SLAM SLAP SLAT SLAY SLED SLEW SLID SLIM SLIP SLIT SLOB SLOG SLOP SLOT SLOW SLUG SLUM SMOG SMUG SNAG SNAP SNIP SNOB SNOT SNOW SNUB SNUG SOAK SOAP SOAR SOCK SODA SOFA SOFT SOIL SOLD SOLE SOLO SOME SONG SOON SOOT SORE SORT SOUL SOUP SOUR SOWN SPAM SPAN SPAR SPAT SPAY SPEC SPED SPEW SPIN SPIT SPOT SPRY SPUD SPUR STAB STAG STAR STAY STEM STEP STEW STIR STOP STOW STUB STUD STUN SUCH SUDS SUED SUEZ SUIT SULK SUMO SUNG SUNK SURE SURF SWAB SWAG SWAM SWAN SWAP SWAT SWAY SWIM SWUM SYNC TABS TACK TACT TAIL TAKE TALE TALK TALL TAME TAMP TANG TANK TANS TAPE TAPS TARE TARN TARP TART TASK TATS TAUT TAXI TEAK TEAL TEAM TEAR TEAS TEAT TEEM TEEN TELL TEMP TEND TENT TERM TERN TEST TEXT THAN THAT THAW THEE THEM THEN THEY THIN THIS THUD THUG TICK TIDE TIDY TIED TIER TIES TIFF TILE TILL TILT TIME TINE TINT TINY TIRE TOAD TOED TOES TOGA TOIL TOLD TOLL TOMB TOME TONE TONG TONS TOOK TOOL TOOT TOPS TORE TORN TOSS TOTE TOUR TOUT TOWN TOYS TRAM TRAP TRAY TREE TREK TRIM TRIO TRIP TROT TRUE TUBA TUBE TUCK TUFT TUNA TUNE TURF TURN TUSK TUTU TWIG TWIN TWIT TYPE TYRE UGLY UNDO UNTO UPON URGE USED USER USES VAIN VALE VAMP VANE VANS VARY VASE VAST VATS VEER VEIL VEIN VEND VENT VERB VEST VETO VIAL VICE VIEW VILE VINE VISA VISE VOID VOLE VOLT VOTE VOWS WADE WAGE WAIL WAIT WAKE WALE WALK WALL WAND WANE WANT WARD WARE WARM WARN WARP WART WARY WASH WASP WATT WAVE WAVY WAXY WAYS WEAK WEAL WEAN WEAR WEBB WEDS WEED WEEK WEEP WEIR WELD WELL WELT WEND WENT WEPT WERE WEST WETS WHAT WHEN WHET WHEY WHIM WHIP WHIR WHIT WHIZ WHOM WICK WIDE WIFE WILD WILL WILT WILY WIND WINE WING WINK WINO WINS WIPE WIRE WIRY WISE WISH WISP WITH WITS WOKE WOLF WOMB WOOD WOOF WOOL WORD WORE WORK WORM WORN WORT WOVE WRAP WREN WRIT YAKS YAMS YANG YANK YARD YARN YAWN YEAH YEAR YEAS YELL YELP YENS YETI YOGA YOGI YOKE YOLK YORE YOUR YULE ZEAL ZEBU ZERO ZEST ZINC ZING ZIPS ZONE ZOOM APPLE ANGLE ALONE ALERT ALTER BAKER BEACH BEANS BEAST BLACK BLAME BLAND BLANK BLAST BLOCK BLOOM BOARD BOAST BRAIN BRAND BRAVE BREAD BREAK BRICK BRING BROAD BROWN CANDY CHAIR CHALK CHAMP CHANT CHARM CHART CHASE CHEAP CHEAT CHECK CHEST CHIEF CHILD CHILL CHINA CHIPS CLEAN CLEAR CLERK CLICK CLIMB CLOCK CLOSE CLOTH CLOUD COACH COAST COCOA COLOR CORAL COUCH COULD COUNT CRANE CRASH CREAM CRISP CROSS CROWD CROWN CURVE DANCE DELAY DELTA DEPTH DIARY DITCH DOUBT DOUGH DRAFT DRAIN DRAMA DRAWN DREAM DRESS DRIED DRIFT DRILL DRINK DRIVE DROVE EAGLE EARLY EARTH EIGHT ELBOW EMPTY ENEMY ENJOY ENTER ENTRY EQUAL ERROR EVENT EVERY EXACT EXTRA FAINT FAIRY FAITH FALSE FANCY FATAL FAULT FEAST FENCE FEVER FIBER FIELD FIERY FIFTY FIGHT FINAL FIRST FLAME FLASH FLEET FLESH FLIES FLOAT FLOOD FLOOR FLOUR FLUID FLUSH FOCUS FORCE FORTH FORTY FRAME FRANK FRAUD FRESH FRIED FRONT FROST FRUIT FUNNY GHOST GIANT GIVEN GLASS GLOBE GLOVE GRACE GRADE GRAIN GRAND GRANT GRAPE GRAPH GRASS GRAVE GREAT GREEN GREET GRIEF GRILL GRIND GROSS GROUP GUARD GUESS GUEST GUIDE HABIT HAPPY HARSH HASTE HATCH HAVEN HEART HEAVY HELLO HINGE HIPPO HOBBY HONEY HORSE HOTEL HOUSE HUMAN HUMOR HURRY IDEAL IMAGE INDEX INNER INPUT ISSUE IVORY JEANS JEWEL JOINT JOKER JUDGE JUICE JUMBO KAYAK KNEEL KNIFE KNOBS KNOWN LABEL LABOR LANCE LARGE LASER LATER LAUGH LAYER LEARN LEASE LEAST LEAVE LEGAL LEMON LEVEL LIGHT LIKED LIMIT LINEN LIVER LOCAL LODGE LOGIC LOOSE LOVER LOWER LOYAL LUCKY LUNCH LUNAR MAGIC MAJOR MAKER MANGO MAPLE MARCH MARRY MARSH MATCH MAYOR MEDIA MELON MERCY MERGE METAL METER MIDST MINOR MIXED MODEL MONEY MONTH MORAL MOTOR MOUNT MOUSE MOUTH MOVIE MUSIC NAKED NERVE NEVER NIGHT NINJA NOBLE NOISE NORTH NOVEL NURSE OASIS OCEAN OLIVE ONION OPERA ORBIT ORDER ORGAN OTHER OTTER OUGHT OUNCE OUTER OWNER PAINT PANEL PANIC PAPER PARTY PASTE PATCH PAUSE PEACE PEACH PEARL PEDAL PENCE PIANO PIECE PILOT PINCH PITCH PIZZA PLACE PLAIN PLANE PLANT PLATE PLAZA PLEAD PLEAT PLUCK POINT POLAR POUND POWER PRESS PRICE PRIDE PRIME PRINT PRIOR PRIZE PROOF PROSE PROUD PROVE PULSE PUNCH PUPIL QUEEN QUERY QUEST QUEUE QUICK QUIET QUITE QUOTE RADAR RADIO RAISE RALLY RANCH RANGE RAPID RATIO REACH REACT READY REALM REBEL REFER REIGN RELAX RELAY REMIT RENEW REPAY REPLY RESET RESIN RETRO RHYME RIDER RIDGE RIFLE RIGHT RINSE RISKY RIVAL RIVER ROAST ROBIN ROBOT ROCKY ROGUE ROUGE ROUGH ROUND ROUTE ROYAL RUGBY RULER RUMOR RURAL SADLY SAINT SALAD SALLY SALON SALSA SALTY SANDY SAUCE SCALE SCARE SCARF SCENE SCENT SCOPE SCORE SCOUT SCREW SEIZE SENSE SERVE SEVEN SHADE SHAKE SHALL SHAME SHAPE SHARE SHARK SHARP SHEEP SHEER SHEET SHELF SHELL SHIFT SHINE SHIRT SHOAL SHOCK SHOES SHOOT SHORE SHORT SHOUT SHOWN SIGHT SIGMA SILLY SINCE SIXTH SKATE SKILL SKIRT SKULL SLATE SLAVE SLEEP SLICE SLIDE SLOPE SMALL SMART SMELL SMILE SMOKE SNAIL SNAKE SNARE SNEAK SOLAR SOLID SOLVE SORRY SOUND SOUTH SPACE SPADE SPARE SPARK SPEAK SPEED SPELL SPEND SPICE SPIKE SPILL SPINE SPOIL SPOKE SPOON SPORT SPRAY SQUAD STACK STAFF STAGE STAIN STAIR STAKE STALE STAMP STAND STARE STARK START STATE STEAL STEAM STEEL STEEP STEER STERN STICK STILL STING STINK STOCK STOLE STONE STOOD STORM STORY STOVE STRAP STRAW STRIP STUCK STUDY STUFF STYLE SUGAR SUITE SUNNY SUPER SURGE SUSHI SWEAR SWEAT SWEET SWEPT SWIFT SWING SWORD SYRUP TABLE TAKEN TANGO TASTE TASTY TEACH TEARS TEASE TEETH TEMPO TENOR TENSE TENTH TERMS THANK THEFT THEME THERE THESE THICK THIEF THING THINK THIRD THOSE THREE THROW THUMB TIGER TIGHT TIMER TIMID TIRED TITAN TITLE TOAST TODAY TOKEN TONAL TOOTH TOPIC TOTAL TOUCH TOUGH TOWEL TOWER TOXIC TRACE TRACK TRADE TRAIL TRAIN TRAIT TRASH TREAT TREND TRIAL TRIBE TRICK TRIED TROOP TROUT TRUCK TRULY TRUMP TRUNK TRUST TRUTH TULIP TUTOR TWICE TWIST TYING ULTRA UNCLE UNDER UNDUE UNFIT UNION UNITY UNTIL UPPER UPSET URBAN USAGE USUAL UTTER VAGUE VALID VALUE VALVE VAULT VENOM VENUE VERGE VERSE VIDEO VIRAL VIRUS VISIT VITAL VIVID VOCAL VODKA VOGUE VOICE VOTER WAGON WAIST WASTE WATCH WATER WAXEN WEARY WEAVE WEDGE WEIGH WEIRD WELSH WHEAT WHEEL WHERE WHICH WHILE WHITE WHOLE WHOSE WIDEN WIDTH WITCH WOMAN WOMEN WORLD WORRY WORSE WORST WORTH WOULD WOUND WRATH WRITE WRONG WROTE YACHT YEARN YEAST YIELD YOUNG YOURS ZEBRA ZESTY AH EH KA TA HA"):gmatch("%u+") do if not dict[w] then dict[w]=true;table.insert(words,w) end end
local pts={A=1,B=4,C=3,D=3,E=1,F=4,G=4,H=3,I=2,J=8,K=4,L=2,M=4,N=2,O=2,P=3,Q=8,R=2,S=1,T=2,U=4,V=6,W=3,X=8,Y=5,Z=8}
local function candidates(board:any,rack:any,n:number,prem:any?)
 local found={};local count=0;for _ in pairs(board) do count+=1 end
 local function get(r:number,c:number):string? return board[r*100+c] end
 for _,word in ipairs(words) do local len=#word
  for dir=1,2 do local dr,dc=if dir==1 then 0 else 1,if dir==1 then 1 else 0
   for r=1,n-(len-1)*dr do for c=1,n-(len-1)*dc do if not get(r-dr,c-dc) and not get(r+len*dr,c+len*dc) then
    local used,move={},{};local contact,valid=false,true;local blanks,base,mult,extra=0,0,1,0
    for k=1,len do local rr,cc=r+(k-1)*dr,c+(k-1)*dc;local ch=word:sub(k,k);local old=get(rr,cc)
     if old then if old~=ch then valid=false;break end;contact=true;base+=pts[ch] or 1
     else local idx=nil;local blank=false
      for _,tile in ipairs(rack) do if not used[tile.index] and tile.letter==ch then idx=tile.index;break end end
      if not idx then for _,tile in ipairs(rack) do if not used[tile.index] and tile.letter=="?" then idx=tile.index;blank=true;break end end end
      if not idx then valid=false;break end;used[idx]=true;if blank then table.insert(move,{idx,rr,cc,ch:lower()});blanks+=1 else table.insert(move,{idx,rr,cc}) end
      local bonus=prem and prem[rr*100+cc];local lm=if bonus=="L3" then 3 elseif bonus=="L2" then 2 else 1;local wm=if bonus=="W3" then 3 elseif bonus=="W2" then 2 else 1
      local val=if blank then 0 else (pts[ch] or 1);base+=val*lm;mult*=wm
      local pd,pc=dc,dr;local pre,post="","";local x,y=rr-pd,cc-pc
      while get(x,y) do pre=get(x,y)..pre;x-=pd;y-=pc end;x,y=rr+pd,cc+pc
      while get(x,y) do post..=get(x,y);x+=pd;y+=pc end
      if #pre+#post>0 then contact=true;if not dict[pre..ch..post] then valid=false;break end;local sub=val*lm;for t in (pre..post):gmatch("%u") do sub+=pts[t] or 1 end;extra+=sub*wm end
     end
     if count==0 and rr==math.ceil(n/2) and cc==math.ceil(n/2) then contact=true end
    end
    if valid and contact and #move>0 then table.insert(found,{word=word,move=move,rank=base*mult+extra+#move*2-blanks*8}) end
   end end end
  end
 end
 table.sort(found,function(a,b) if a.rank==b.rank then return a.word<b.word end;return a.rank>b.rank end);return found
end
ctl.CrossCandidates=candidates
local function faceLetter(root:Instance):string?
 for _,f in ipairs(root:GetDescendants()) do if f.Name=="Face" then local l=f:FindFirstChildWhichIsA("TextLabel");if l and visible(l) and (l.Text:match("^%a$") or l.Text=="?") then return l.Text:upper() end end end;return nil
end
local function crossTurn(g:any):boolean
 local h=humanoid();local tables=workspace:FindFirstChild("Tables")
 return ctl.Running and crossActive() and h~=nil and h.SeatPart~=nil and tables~=nil and h.SeatPart:IsDescendantOf(tables) and P:GetAttribute("G67LastCat")=="WC_English" and labelText(g.Side.Header)=="ตาของคุณ" and not g.End.Visible
end
ctl.CrossPasses=0;ctl.CrossSwaps=0;ctl.CrossLog={};ctl.CrossRounds=0;ctl.CrossWins=0;ctl.CrossRetry=true;ctl.CrossEndText="";ctl.CrossEndSeen=false;ctl.CrossAttempt=0;ctl.CrossFallback=false
local function crossPlay()
 local g:any=PG:FindFirstChild("WordCrossHUD");if ctl.CrossBusy or not g or not crossTurn(g) or os.clock()-ctl.LastCross<1.5 then return end
 ctl.LastCross=os.clock();ctl.CrossBusy=true;local manual=not ctl.AutoCross
 task.spawn(function()
  local ok,e=pcall(function()
   local board,rack,prem={},{},{};local n=0
   for _,v in ipairs(g.Board.Grid:GetChildren()) do local a,b=v.Name:match("^(%d+)_(%d+)$");local rr,cc=tonumber(a),tonumber(b)
    if rr and cc then n=math.max(n,rr,cc);local letter=faceLetter(v)
     if letter and letter~="?" then board[rr*100+cc]=letter else local bg=v:FindFirstChild("Bg");local l=bg and bg:FindFirstChildWhichIsA("TextLabel");if l then local t=l.Text;if t:find("×3",1,true) then prem[rr*100+cc]=if t:find("คำ",1,true) then "W3" else "L3" elseif t:find("×2",1,true) then prem[rr*100+cc]=if t:find("คำ",1,true) then "W2" else "L2" end end end
    end
   end
   local byIndex={}
   for _,v in ipairs(g.Side.Rack.Frame:GetChildren()) do local letter=faceLetter(v);local hit=v:FindFirstChild("Hit",true)
    if letter and hit and hit:IsA("GuiObject") then for _,c in ipairs(getconnections(hit.InputBegan)) do if type(c.Function)=="function" and (debug.info(c.Function,"s") or ""):find("WordCrossClient",1,true) then local idx=debug.getupvalues(c.Function)[3];if type(idx)=="number" then table.insert(rack,{letter=letter,index=idx});byIndex[idx]=letter end;break end end end
   end
   if n<3 or n>15 or #rack==0 then return end
   local key={};for k,v in pairs(board) do table.insert(key,tostring(k)..v) end;for _,v in ipairs(rack) do table.insert(key,tostring(v.index)..v.letter) end;table.sort(key);local sig=table.concat(key,"|")
   if ctl.CrossKey~=sig or not ctl.CrossSearch then local list=candidates(board,rack,n,prem);ctl.CrossCleanCount=#list;ctl.CrossKey=sig;ctl.CrossSearch={list=list,next=1,checked={},attempts=0} elseif not ctl.CrossRetry and not manual then return end
   local search=ctl.CrossSearch;if search.next>#search.list then ctl.CrossStatus="ค้นครบ "..search.attempts.." คำ • ไม่กดผ่าน";return end
   local rem:any=RS:FindFirstChild("MinigameRemotes");if not rem then return end
   local attempts,valid=0,0;local best:any=nil
   local function still():boolean return crossTurn(g) and (manual or ctl.AutoCross) end
   while search.next<=#search.list and attempts<18 and valid<3 do
    if not still() then return end;local x=search.list[search.next];local parts={};for _,v in ipairs(x.move) do table.insert(parts,table.concat(v,":")) end;table.sort(parts);local id=table.concat(parts,"|")
    if search.checked[id] then search.next+=1;continue end
    attempts+=1;ctl.CrossStatus="ตรวจ "..x.word
    local reply=rem.WordCrossCheck:InvokeServer(x.move)
    if type(reply)=="table" and reply.Busy then task.wait(.5);if not still() then return end;reply=rem.WordCrossCheck:InvokeServer(x.move);if type(reply)=="table" and reply.Busy then break end end
    search.checked[id]=true;search.next+=1;search.attempts+=1;ctl.CrossAttempt=search.attempts
    if type(reply)=="table" and reply.Ok==true then valid+=1;local value=tonumber(reply.Score) or 0;if not best or value>best.score then best={x=x,score=value} end;if value>=35 then break end end;task.wait(.35)
   end
   if not still() then return end
   if best then local x=best.x;rem.WordCross:FireServer("Play",x.move);for _=1,35 do task.wait(.1);if labelText(g.Side.Header)~="ตาของคุณ" or g.End.Visible then break end end
    local confirmed=true;for _,tile in ipairs(x.move) do local cell=g.Board.Grid:FindFirstChild(tostring(tile[2]).."_"..tostring(tile[3]));local l=cell and faceLetter(cell);if l~=(if tile[4] then tile[4]:upper() else byIndex[tile[1]]) then confirmed=false;break end end
    if confirmed then ctl.CrossMoves+=1;ctl.CrossStatus=x.word.." • +"..tostring(best.score);table.insert(ctl.CrossLog,{word=x.word,score=best.score});ctl.CrossSearch=nil;ctl.CrossKey=nil else ctl.CrossStatus="ส่งแล้วแต่ยังไม่ยืนยัน" end
   else ctl.CrossStatus="ตรวจ "..search.attempts.."/"..#search.list.." • ไม่กดผ่าน" end
  end);ctl.CrossBusy=false;if not ok then ctl.LastError=tostring(e);ctl.CrossKey=nil;ctl.CrossSearch=nil end
 end)
end
ctl.CrossPlay=crossPlay
local function crossMonitor()
 local g:any=PG:FindFirstChild("WordCrossHUD");if not g or not crossActive() then ctl.CrossKey=nil;ctl.CrossSearch=nil;ctl.CrossEndSeen=false;return end
 if g.End.Visible then if not ctl.CrossEndSeen then local labels={};for _,v in ipairs(g.End:GetDescendants()) do if v:IsA("TextLabel") and visible(v) and v.Text~="" then table.insert(labels,v.Text) end end;ctl.CrossEndText=table.concat(labels," | ");ctl.CrossRounds+=1;if ctl.CrossEndText:find("คุณชนะ",1,true) then ctl.CrossWins+=1 end;ctl.CrossEndSeen=true;ctl.CrossStatus=ctl.CrossEndText end;return end
 ctl.CrossEndSeen=false;if labelText(g.Side.Header)~="ตาของคุณ" and not ctl.CrossBusy then ctl.CrossKey=nil;ctl.CrossSearch=nil end;if ctl.AutoCross then crossPlay() end
end
ctl.AutoWordSearch=false;ctl.AutoDomino=false
local wsDict={}
for w in ("เต่าทะเล วิ่ง สับปะรด ห่าน ปลาหมึก ช้าง ต้มยำกุ้ง กุ้ง ฝรั่ง สมุด โทรทัศน์ ด้วง ฮิปโป โลมา แมลงวัน มะพร้าว ตั๊กแตน กระต่าย วาฬ แมลงกินูน ปลาฉลาม เงาะ เสือ องุ่น กล้วย ยางลบ แมลงสาบ ส้ม ปลาดุก มะม่วง แมลงทับ ม้าลาย หมี เครื่องซักผ้า ข้าวมันไก่ ต่อ ผัดไทย หอยแมลงภู่ ดินสอ ปากกา ม้า แมงป่อง นกอินทรี นกแก้ว ตะกวด แมว หอยนางรม เทนนิส แกงเขียวหวาน ขนมจีน โต๊ะ หอยแครง ปลาทู ผีเสื้อ จระเข้ ลำไย ตู้เสื้อผ้า เก้าอี้ แบดมินตัน ปูทะเล แตงโม แมลงดานา หอยเชลล์ มะนาว บาสเกตบอล จิ้งหรีด นกกระจอก ว่ายน้ำ แมงมุม งู ข้าวผัด มังคุด สิงโต ไข่เจียว นกยูง ก๋วยเตี๋ยว มะละกอ วอลเลย์บอล สตรอว์เบอร์รี ปลานิล หนังสือ ผ้าห่ม แมวน้ำ ปลาทอง ผึ้ง แอปเปิล ปลาตะเพียน ปลาโลมา แพนด้า พะยูน หอยขม ตู้เย็น ปูม้า เป็ด มวยไทย แตน สุนัข กวาง นกฮูก ปิงปอง ปลาไหล แมลงปอ หอยลาย ปลาการ์ตูน ทุเรียน ฟุตบอล ปลาช่อน เตียง ไม้บรรทัด แรด คอมพิวเตอร์ ลิ้นจี่ ยุง พัดลม กระจก ม้าน้ำ มะเขือเทศ หมอน แมงกะพรุน ไก่ หอยเป๋าฮื้อ แมลงหวี่ ข้าวเหนียว แมลงเม่า ปลากัด เต่า ลิง ส้มตำ มดแดง ยีราฟ"):gmatch("%S+") do wsDict[w]=true end
ctl.WSDict=wsDict;ctl.WSFound=0;ctl.WSStatus="";ctl.WSTried={};ctl.WSKey=""
local function wsGrid()
 local g=PG:FindFirstChild("WordSearchHUD");if not g or not g:IsA("ScreenGui") or not g.Enabled then return nil,nil,nil,nil end
 local cells={};local progress,round
 for _,v in ipairs(g:GetDescendants()) do if v:IsA("TextLabel") and visible(v) then if v.Parent.Name=="Face" and v.Text~="" then table.insert(cells,{x=v.AbsolutePosition.X,y=v.AbsolutePosition.Y,t=v.Text}) elseif v.Text:find("เจอแล้ว ",1,true) then progress=v.Text elseif v.Text:find("รอบ ",1,true) then round=v.Text end end end
 local n=math.floor(math.sqrt(#cells));if n<3 or n*n~=#cells then return nil,nil,nil,nil end
 table.sort(cells,function(a,b) if math.abs(a.y-b.y)<1 then return a.x<b.x else return a.y<b.y end end)
 local board,key={},{};for i,v in ipairs(cells) do local r=math.floor((i-1)/n)+1;board[r]=board[r] or {};board[r][(i-1)%n+1]=v.t;table.insert(key,v.t) end
 return board,n,table.concat(key,"|")..tostring(round),progress
end
local function wsCandidates(board:any,n:number)
 local found={}
 for r=1,n do for col=1,n do for dr=-1,1 do for dc=-1,1 do if dr~=0 or dc~=0 then local word="";for k=0,n-1 do local y,x=r+k*dr,col+k*dc;if not board[y] or not board[y][x] then break end;word..=board[y][x];if k>0 and wsDict[word] then table.insert(found,{word=word,x=col,y=r,ex=x,ey=y,len=k+1}) end end end end end end end
 table.sort(found,function(a,b) return a.len>b.len end);return found
end
ctl.WSCandidates=wsCandidates
local function wordSearchStep()
 if not ctl.Running or not solo() or ctl.WSBusy then return end;local board,n,key,progress=wsGrid();if not board or not n or not progress then return end
 local oldN,total=progress:match("(%d+)/(%d+)");if oldN and total and oldN==total then return end
 if ctl.WSKey~=key then ctl.WSKey=key;ctl.WSTried={};ctl.WSCached=wsCandidates(board,n) end
 local list=ctl.WSCached or {}
 for _,v in ipairs(list) do local id=table.concat({v.x,v.y,v.ex,v.ey},":");if not ctl.WSTried[id] then
  ctl.WSTried[id]=true;ctl.WSBusy=true;local ok,e=pcall(function()
   RS.MinigameRemotes.WordSearch:FireServer("Find",v.x,v.y,v.ex,v.ey);task.wait(.85)
   local _,_,key2,new=wsGrid();local before=tonumber(oldN);local after=new and tonumber(new:match("(%d+)/"))
   if key==key2 and before and after and after>before then ctl.WSFound+=after-before;ctl.WSStatus=v.word.." • "..new else ctl.WSStatus="ตรวจ "..v.word end
  end);ctl.WSBusy=false;if not ok then ctl.LastError=tostring(e) end;return
 end end;ctl.WSStatus="ตรวจครบ "..#list.." ทางเลือก"
end
ctl.WordSearchStep=wordSearchStep
local module=RS:FindFirstChild("DominoShared");local shared:any=nil
if module and module:IsA("ModuleScript") then local ok,v=pcall(require,module);if ok then shared=v end end
ctl.DominoMoves=0;ctl.DominoDraws=0;ctl.DominoPasses=0;ctl.DominoStatus=""
local function dominoState(g:any)
 for _,v in ipairs(g.Side.Buttons:GetDescendants()) do if v:IsA("GuiButton") and labelText(v)=="ส่ง" then for _,x in ipairs(getconnections(v.Activated)) do if type(x.Function)=="function" and (debug.info(x.Function,"s") or ""):find("DominoClient",1,true) then local u=debug.getupvalues(x.Function);if type(u[1])=="table" and type(u[2])=="table" and u[1].isMyTurn and u[2].Hand then return u[1],u[2] end end end end end;return nil,nil
end
local function dominoSolve(state:any,api:any)
 local best:any=nil;local bestScore=-1;local occ=api.effectiveOccupied();local nodes=0
 for arm,e in pairs(api.effectiveEnds()) do local used,path={},{}
  local function dfs(endp:any,o:any,score:number)
   nodes+=1;if nodes>2000 then return end;if #path>0 and score>bestScore then bestScore=score;best={arm=arm,indices=table.clone(path)} end;if #path>=shared.MAX_COMBO then return end
   for i,t in ipairs(state.Hand) do if not used[i] and shared.CanPlayTileOnEnd(t,endp) then local nextOcc=shared.CloneOccupied(o);local geom,nextEnd=shared.PreviewChainStep(nextOcc,endp,t,state.ArmsMode)
    if geom and nextEnd then shared.MarkOccupied(nextOcc,geom.X,geom.Y,geom.Dir);used[i]=true;table.insert(path,i);dfs(nextEnd,nextOcc,score+100+t.A+t.B);table.remove(path);used[i]=nil end
   end end
  end;dfs(e,occ,0)
 end;return best
end
local function dominoStep()
 local g:any=PG:FindFirstChild("DominoHUD");if not shared or not ctl.Running or not g or not g.Enabled or g.End.Visible or not solo() or ctl.DominoBusy then return end
 local api,state=dominoState(g);if not api or not api.isMyTurn() or state.CommitHidden or #state.Pending.Steps~=0 then return end
 ctl.DominoBusy=true;local ok,e=pcall(function()
  local best=dominoSolve(state,api)
  if best then local before=#state.Hand;local count=0;for _,idx in ipairs(best.indices) do if api.isMyTurn() and api.pushPendingStep(idx,best.arm,false) then count+=1 else break end end
   if count>0 and api.isMyTurn() then api.commitPendingChain();for _=1,15 do task.wait(.1);if #state.Hand<before then break end end;if #state.Hand<before then ctl.DominoMoves+=before-#state.Hand;ctl.DominoStatus="ลง "..(before-#state.Hand).." เบี้ย" end end
  elseif state.BoneyardCount>0 and not state.DrawnThisTurn then RS.MinigameRemotes.Domino:FireServer("Draw");ctl.DominoDraws+=1;ctl.DominoStatus="จั่ว";task.wait(.8)
  else RS.MinigameRemotes.Domino:FireServer("Pass");ctl.DominoPasses+=1;ctl.DominoStatus="ไม่มีเบี้ยที่ลงได้";task.wait(.8) end
 end);ctl.DominoBusy=false;if not ok then ctl.LastError=tostring(e) end
end
ctl.DominoStep=dominoStep
local hs=game:GetService("HttpService");local configPath="MoyXHub_School_Config.json"
ctl.ConfigEnabled=true;ctl.AutoExecute=false;ctl.AutoFreeRelease=false
local function saveConfig():boolean
 local ok,e=pcall(function() writefile(configPath,hs:JSONEncode({version=1,Mode=ctl.Mode,Size=ctl.Size,Delay=ctl.Delay,Monitor=ctl.Monitor,Retry=ctl.CrossRetry,AutoExecute=ctl.AutoExecute,SaveConfig=ctl.ConfigEnabled})) end);if not ok then ctl.ConfigError=tostring(e) end;return ok
end
local function loadConfig():boolean
 if not isfile(configPath) then return false end;local ok,d=pcall(function() return hs:JSONDecode(readfile(configPath)) end);if not ok or type(d)~="table" or d.version~=1 then return false end
 if ({["คณิตศาสตร์"]=true,["ครอสอังกฤษ"]=true,["ค้นหาคำ"]=true,["โดมิโน"]=true})[d.Mode] then ctl.Mode=d.Mode end
 if ({["ทั้งหมด"]=true,["2"]=true,["3"]=true,["4"]=true,["6"]=true})[d.Size] then ctl.Size=d.Size end
 if type(d.Delay)=="number" then ctl.Delay=math.clamp(d.Delay,2,10) end;if type(d.Monitor)=="boolean" then ctl.Monitor=d.Monitor end;if type(d.Retry)=="boolean" then ctl.CrossRetry=d.Retry end
 ctl.AutoExecute=d.AutoExecute==true;ctl.ConfigEnabled=d.SaveConfig~=false;return true
end
ctl.SaveConfig=saveConfig;ctl.LoadConfig=loadConfig;loadConfig()
local function changed() if ctl.ConfigEnabled then saveConfig() end end
local function stop()
 ctl.AutoJoin=false;ctl.AutoStart=false;ctl.AutoSetup=false;ctl.AutoMath=false;ctl.AutoRewards=false;ctl.AutoQuest=false;ctl.AutoEvent=false;ctl.AutoCross=false;ctl.AutoWordSearch=false;ctl.AutoDomino=false;ctl.AutoFreeRelease=false;say("หยุดอัตโนมัติทั้งหมด")
end
local Main=UI:Tab("MAIN"):Section("ระบบเข้าเล่น")
Main:Label("เข้าโต๊ะและเล่นแยกกัน • Auto Join ปิดเริ่มต้น")
Main:Toggle({Name="เข้าโต๊ะว่างอัตโนมัติ",Default=false,Callback=function(v:boolean) ctl.AutoJoin=v end})
Main:Toggle({Name="เลือกโหมดอัตโนมัติ",Default=false,Callback=function(v:boolean) ctl.AutoSetup=v end})
Main:Toggle({Name="เริ่มเกมอัตโนมัติ",Default=false,Callback=function(v:boolean) ctl.AutoStart=v end})
Main:Dropdown({Name="โหมดการเล่น",Options={"คณิตศาสตร์","ครอสอังกฤษ","ค้นหาคำ","โดมิโน"},Default=ctl.Mode,Callback=function(v:string) ctl.Mode=v;changed() end})
Main:Dropdown({Name="จำนวนที่นั่ง",Options={"ทั้งหมด","2","3","4","6"},Default=ctl.Size,Callback=function(v:string) ctl.Size=v;changed() end})
Main:Toggle({Name="Save Config",Default=ctl.ConfigEnabled,Callback=function(v:boolean) ctl.ConfigEnabled=v;saveConfig() end})
Main:Toggle({Name="Auto Execute",Default=ctl.AutoExecute,Desc="เปิด UI เมื่อเข้าแมพนี้ • ไม่เปิด Auto Join",Callback=function(v:boolean) ctl.AutoExecute=v;saveConfig() end})
Main:Button({Name="บันทึกการตั้งค่า",Callback=function() say(if saveConfig() then "บันทึกสำเร็จ" else "บันทึกไม่สำเร็จ") end})
Main:Slider({Name="เวลารอก่อนลองใหม่ (วินาที)",Min=2,Max=10,Default=ctl.Delay,Increment=1,Callback=function(v:number) ctl.Delay=math.clamp(v,2,10);changed() end})
Main:Button({Name="เข้าโต๊ะว่างทันที",Callback=join})
Main:Button({Name="เริ่มเกมเมื่อพร้อม",Callback=start})
Main:Button({Name="หยุดทั้งหมด",Callback=stop})
local Q=UI:Tab("QUIZ"):Section("ตรวจสถานะคำถาม")
Q:Toggle({Name="ติดตามสถานะรอบ",Default=ctl.Monitor,Callback=function(v:boolean) ctl.Monitor=v;changed() end})
Q:Button({Name="อ่านสถานะปัจจุบัน",Callback=function() say(status()) end})
Q:Toggle({Name="ตอบโจทย์คณิตอัตโนมัติ",Default=false,Desc="เฉพาะโต๊ะที่ไม่มีผู้เล่นอื่น และโจทย์เลขที่คำนวณได้",Callback=function(v:boolean) ctl.AutoMath=v end})
Q:Button({Name="ดูคำตอบล่าสุด",Callback=function() say(if ctl.LastAnswer~="" then ctl.LastAnswer else "ยังไม่ได้ส่งคำตอบ") end})
Q:Label("ไม่สุ่มตอบเมื่อโจทย์ไม่รองรับ")
local R=UI:Tab("REWARDS"):Section("รางวัลและเควส")
R:Toggle({Name="รับรางวัลอัตโนมัติ",Default=false,Desc="รายวันและเวลาเล่นที่พร้อมรับเท่านั้น",Callback=function(v:boolean) ctl.AutoRewards=v end})
R:Button({Name="รับรางวัลที่พร้อมรับ",Callback=function() claim(true,false) end})
R:Toggle({Name="รับเควสที่สำเร็จอัตโนมัติ",Default=false,Callback=function(v:boolean) ctl.AutoQuest=v end})
R:Button({Name="รับรางวัลเควสที่สำเร็จ",Callback=function() claim(false,true) end})
R:Button({Name="ตรวจผลรับรางวัลและเควส",Callback=function() say(ctl.RewardStatus.." | "..ctl.QuestStatus) end})
R:Label("ไม่ใช้ Robux และไม่กดปลดล็อกรางวัล")
local E=UI:Tab("EVENT"):Section("กิจกรรมและมินิเกม")
E:Label("ครอสคำ / ค้นหาคำ / โดมิโน / งานวัด / ลอยกระทง")
E:Button({Name="ตรวจสิทธิ์กิจกรรมและคูปอง",Callback=function() say(eventStatus()) end})
E:Toggle({Name="รับกระทงฟรีอัตโนมัติ",Default=false,Desc="รับเฉพาะกระทงใบตองฟรีวันละครั้ง",Callback=function(v:boolean) ctl.AutoEvent=v end})
E:Button({Name="รับกระทงฟรี",Callback=freeEvent})
E:Button({Name="ตรวจผลกิจกรรม",Callback=function() say(ctl.EventResult or eventStatus()) end})
local X=UI:Tab("CROSS"):Section("ครอสอังกฤษ")
X:Label("เลือกครอสอังกฤษใน MAIN เพื่อเข้าโต๊ะอัตโนมัติ")
X:Button({Name="ใช้คำใบ้ของเกม",Callback=crossHint})
X:Toggle({Name="ลงคำอังกฤษอัตโนมัติ",Default=false,Desc="ใช้คำที่มีในคลังและตรวจสอบกับเกมก่อนลง",Callback=function(v:boolean) ctl.AutoCross=v end})
X:Button({Name="ค้นหาและลงคำหนึ่งตา",Callback=crossPlay})
X:Button({Name="ดูผลครอสคำ",Callback=function() say(ctl.CrossStatus.." | ยืนยัน "..ctl.CrossMoves.." ตา") end})
X:Toggle({Name="ค้นคำต่อจนจบรอบ",Default=ctl.CrossRetry,Desc="ตรวจคำชุดถัดไปโดยไม่กดผ่านหรือสลับเบี้ย",Callback=function(v:boolean) ctl.CrossRetry=v;changed() end})
X:Button({Name="ดูผลการแข่งขันล่าสุด",Callback=function() say(if ctl.CrossEndText~="" then ctl.CrossEndText else "ยังไม่จบรอบ") end})
X:Label("ครอสอังกฤษ • จัดลำดับตามคะแนนและตรวจคำก่อนลง")
E:Label("รับและปล่อยของฟรี • ไม่ซื้อเพิ่ม")

E:Button({Name="ลอยกระทงฟรีที่มีอยู่",Callback=function() releaseFree("Leaf") end})
E:Button({Name="ปล่อยโคมฟรีที่มีอยู่",Callback=function() releaseFree("Lantern") end})
E:Toggle({Name="ลอยกระทงและโคมฟรีอัตโนมัติ",Default=false,Callback=function(v:boolean) ctl.AutoFreeRelease=v end})
local W=UI:Tab("WORD SEARCH"):Section("ค้นหาคำ")
W:Toggle({Name="ค้นหาคำอัตโนมัติ",Default=false,Callback=function(v:boolean) ctl.AutoWordSearch=v end})
W:Button({Name="ค้นคำหนึ่งครั้ง",Callback=function() task.spawn(wordSearchStep) end})
W:Button({Name="ดูผลค้นคำ",Callback=function() say(ctl.WSStatus.." • "..ctl.WSFound.." คำ") end})
W:Label("เฉพาะโต๊ะฝึก • คลังคำยังไม่ครบ")
local D=UI:Tab("DOMINO"):Section("โดมิโน")
D:Toggle({Name="เล่นโดมิโนอัตโนมัติ",Default=false,Callback=function(v:boolean) ctl.AutoDomino=v end})
D:Button({Name="ลงเบี้ยหนึ่งตา",Callback=function() task.spawn(dominoStep) end})
D:Button({Name="ดูผลโดมิโน",Callback=function() say(ctl.DominoStatus.." • "..ctl.DominoMoves.." เบี้ย") end})
D:Label("ทดสอบโหมดคลาสสิกกับบอท")
local T=UI:Tab("QUEST"):Section("เควส")
T:Button({Name="ตรวจและรับรางวัลเควส",Callback=function() claim(false,true) end})
T:Button({Name="ดูความคืบหน้าเควส",Callback=function() say(ctl.QuestStatus) end})
T:Label("เปิดรับเควสอัตโนมัติได้ใน REWARDS")
local F=UI:Tab("FAIR"):Section("เกมงานวัด")
F:Label("ยิงเป้า / ปาโป่ง / บิงโก / ระบายสี • ยังไม่เปิดอัตโนมัติ")
F:Button({Name="ตรวจค่ากิจกรรม",Callback=function() say("ค่าเล่น 200 Cash ต่อครั้ง") end})
UI:AddSettingsTab()
local function setupDock()
 local p=UI.Root:FindFirstChild("DockPlayer",true);if not p or not p:IsA("TextLabel") then return end
 local d=p.Parent;if not d or not d:IsA("GuiObject") then return end
 local c=d:FindFirstChild("DockClock");local lens=d:FindFirstChild("DockLens");if not c or not c:IsA("TextLabel") or not lens or not lens:IsA("GuiObject") then return end
 local sc=Instance.new("ScrollingFrame");sc.Name="MoyTabScroll";sc.BackgroundTransparency=1;sc.BorderSizePixel=0;sc.Position=UDim2.fromOffset(0,7);sc.Size=UDim2.new(1,0,1,-54);sc.CanvasSize=UDim2.fromOffset(0,0);sc.ScrollingDirection=Enum.ScrollingDirection.Y;sc.ScrollBarThickness=3;sc.ScrollBarImageColor3=Color3.fromRGB(110,197,230);sc.ElasticBehavior=Enum.ElasticBehavior.Never;sc.ClipsDescendants=true;sc.Active=true;sc.Parent=d;lens.Parent=sc
 local order={MAIN=1,QUIZ=2,REWARDS=3,EVENT=4,CROSS=5,["WORD SEARCH"]=6,DOMINO=7,QUEST=8,FAIR=9,SETTINGS=10}
 local function update()
  local tabs={};for _,root in ipairs({d,sc}) do for _,v in ipairs(root:GetChildren()) do if v:IsA("TextButton") and v.Name:sub(1,7)=="TabBtn_" then table.insert(tabs,v) end end end
  table.sort(tabs,function(a,b) local x,y=order[a.Text] or 100,order[b.Text] or 100;if x==y then return a.Text<b.Text end;return x<y end)
  for i,v in ipairs(tabs) do v.Parent=sc;v.Position=UDim2.fromOffset(8,14+(i-1)*36);v.Size=UDim2.new(1,-18,0,30);v.TextTruncate=Enum.TextTruncate.AtEnd end;sc.CanvasSize=UDim2.fromOffset(0,14+#tabs*36+4)
 end
 local sep=Instance.new("Frame");sep.Name="MoyDockDivider";sep.BackgroundColor3=Color3.fromRGB(110,197,230);sep.BackgroundTransparency=.62;sep.BorderSizePixel=0;sep.Position=UDim2.new(0,10,1,-40);sep.Size=UDim2.new(1,-20,0,1);sep.Parent=d
 p.AnchorPoint=Vector2.zero;c.AnchorPoint=Vector2.zero;p.Position=UDim2.new(0,10,1,-35);c.Position=UDim2.new(0,10,1,-19);p.ZIndex=3;c.ZIndex=3;p.TextTruncate=Enum.TextTruncate.AtEnd;update()
 ctl.DockConnection=d.ChildAdded:Connect(function(v) if v:IsA("TextButton") and v.Name:sub(1,7)=="TabBtn_" then task.defer(update) end end)
end
setupDock()

local oldDestroy=UI.Destroy
UI.Destroy=function(self:any)
    ctl.Running=false;stop();if ctl.DockConnection then ctl.DockConnection:Disconnect() end;oldDestroy(self)
end
if game.GameId==10343576166 then
    task.spawn(function()
        while ctl.Running do
            if ctl.AutoRewards or ctl.AutoQuest then claim(ctl.AutoRewards,ctl.AutoQuest) end
            if ctl.AutoEvent then freeEvent() end
            if ctl.AutoFreeRelease and not ctl.EventBusy and not playingAny() then if P:GetAttribute("LKOwned_Leaf")==1 then releaseFree("Leaf") elseif P:GetAttribute("LKOwned_Lantern")==1 then releaseFree("Lantern") end end
            for _=1,15 do if not ctl.Running then break end;task.wait(1) end
        end
    end)
    task.spawn(function()
        local lastSeat=false
        local lastQuiz=false
        while ctl.Running do
            local ok,err=pcall(function()
                local h=humanoid()
                local seated=h~=nil and h.Sit
                local playing=playingAny()
                if seated and not lastSeat then ctl.Joins+=1 end
                if playing and not lastQuiz then ctl.Starts+=1 end
                lastSeat=seated;lastQuiz=playing
                if os.clock()-ctl.LastAction>=ctl.Delay then
                    if ctl.AutoJoin and not seated and not playing then join()
                    elseif ctl.AutoSetup and seated and not playing and picker() then setup()
                    elseif ctl.AutoStart and seated and not playing then start() end
                end
                if ctl.AutoMath then mathAnswer() end
                crossMonitor()
                if ctl.AutoWordSearch and not ctl.WSBusy and hud("WordSearchHUD") then task.spawn(wordSearchStep) end
                if ctl.AutoDomino and not ctl.DominoBusy and hud("DominoHUD") then task.spawn(dominoStep) end
                if not playing then ctl.LastAnswerKey="" end
                if ctl.Monitor then say(status()) end
            end)
            if not ok then ctl.LastError=tostring(err);stop();say("ข้อผิดพลาด: "..tostring(err)) end
            task.wait(.25)
        end
    end)
    say("พร้อมใช้งาน • ระบบเข้าโต๊ะ")
else
    stop();say("ไม่ใช่แมพโรงเรียนดวลปัญญา")
end
UI:Toggle(true)
