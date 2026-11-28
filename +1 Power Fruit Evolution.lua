--!nonstrict
if game.PlaceId~=109238145423218 then return end
-- MoyXHub | Prism UI Base
-- Power Fruit | MoyXHub + external Tora UI adapter.
local env=getgenv()
local UI: any = (function()
    local TS=game:GetService("TweenService")
    local Core=game:GetService("CoreGui")
    local preview=env.__MoyXHubUIOnly
    if preview then pcall(function() preview:Destroy() end);env.__MoyXHubUIOnly=nil end
    local source=game:HttpGet("https://ai.zeinstore.xyz/prism.luau")
    -- Keep the multi-select dropdown expanded while toggling its entries.
    local needle="dropdownApi:Set(optName)\n                        toggleDropdown(false)"
    local first,last=string.find(source,needle,1,true)
    if first and last then
        source=source:sub(1,first-1).."dropdownApi:Set(optName)\n                        if not opts.KeepOpen then toggleDropdown(false) end"..source:sub(last+1)
    end
    -- Strong contrast for SELL multi-select options only.
    local function replacePlain(textValue,old,new)
        local a,b=string.find(textValue,old,1,true)
        if not a then return textValue end
        return textValue:sub(1,a-1)..new..textValue:sub(b+1)
    end
    source=replacePlain(source,'optBtn.Parent = optionsHolder', [=[
                    local moyMulti = opts.KeepOpen == true
                    local moyChecked = moyMulti and string.sub(tostring(optName),1,#"[✓]")=="[✓]"
                    if moyMulti then
                        optBtn.BackgroundColor3 = moyChecked and Color3.fromRGB(91,49,151) or Color3.fromRGB(24,20,39)
                        optBtn.BackgroundTransparency = moyChecked and 0.04 or 0.18
                        optBtn.TextColor3 = moyChecked and Color3.fromRGB(255,255,255) or Color3.fromRGB(190,198,216)
                        optBtn.Font = moyChecked and Enum.Font.GothamBold or Enum.Font.GothamMedium
                        local outline=Instance.new("UIStroke")
                        outline.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
                        outline.Color=moyChecked and Color3.fromRGB(143,102,198) or Color3.fromRGB(73,61,99)
                        outline.Thickness=moyChecked and 2 or 1
                        outline.Transparency=moyChecked and 0.05 or 0.55
                        outline.Parent=optBtn
                        optBtn.Text = "   "..(moyChecked and "✓  " or "○  ")..tostring(optName):gsub("^%b[]%s*","")
                    end
                    optBtn.Parent = optionsHolder
    ]=])
    source=replacePlain(source,'{ BackgroundTransparency = 0.90 }):Play()\n                    end)\n\n                    optBtn.MouseLeave', '{ BackgroundTransparency = moyMulti and (moyChecked and 0 or 0.08) or 0.90 }):Play()\n                    end)\n\n                    optBtn.MouseLeave')
    source=replacePlain(source,'{ BackgroundTransparency = 0.97 }):Play()\n                    end)\n\n                    optBtn.MouseButton1Click', '{ BackgroundTransparency = moyMulti and (moyChecked and 0.04 or 0.18) or 0.97 }):Play()\n                    end)\n\n                    optBtn.MouseButton1Click')
    local loader,err=loadstring(source)
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



local Core=game:GetService("CoreGui")
local H=game:GetService("HttpService")
local path="MoyHub/109238145423218.json"
local config:any={}
if isfile(path) then
    local ok,data=pcall(function() return H:JSONDecode(readfile(path)) end)
    if ok and type(data)=="table" then config=data end
end
env.MoyToraConfigToken=nil
env.MoyPowerFruitToken=nil
local token={}
env.MoyPowerFruitToken=token
local function save()
    local ok,err=pcall(function() writefile(path,H:JSONEncode(config)) end)
    if not ok then warn("[Moy Config] "..tostring(err)) end
end
local function hide(g)
    if g and g:IsA("ScreenGui") then g.Enabled=false end
end
local function getTora()
    local g=Core:FindFirstChild("ToraScript")
    if g then hide(g);return g end
    local ok,err=pcall(function()
        local source=game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/1PowerFruitEvolution")
        local f,e=loadstring(source)
        assert(f,e)
        f()
    end)
    if not ok then warn("[Moy Tora] "..tostring(err));return nil end
    g=Core:WaitForChild("ToraScript",10)
    hide(g)
    return g
end
local tora=getTora()
local items={{"Auto Stage","AutoStage"},{"Insta Kill [HP<80%]","InstaKill"},{"Fast Train","FastTrain"},{"Auto Rebirth","AutoRebirth"}}
local function locate(name)
    if not tora or not tora.Parent then return nil,nil end
    for _,v in ipairs(tora:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text:match("^%s*(.-)%s*$")==name then
            for _,f in ipairs(v:GetDescendants()) do
                if f:IsA("Frame") and f.ClipsDescendants and f:FindFirstChildWhichIsA("ImageLabel") then return v,f end
            end
        end
    end
    return nil,nil
end
local function read(name)
    local _,f=locate(name)
    if not f then return nil end
    return f.Size.X.Scale>0 or f.Size.X.Offset>0
end
local function invoke(label,signal,input)
    local list=getconnections(label[signal])
    local ran=false
    for _,connection in ipairs(list) do
        if connection.Enabled~=false and type(connection.Function)=="function" then
            local ok,err=pcall(connection.Function,input)
            if not ok then return false,tostring(err) end
            ran=true
        end
    end
    return ran,ran and "" or "ไม่พบ Callback"
end
local function apply(name,value)
    local label,_=locate(name)
    if not label then return false,"ไม่พบปุ่มต้นฉบับ" end
    if read(name)==value then return true,"สถานะตรงกัน" end
    local input:any={UserInputType=Enum.UserInputType.MouseButton1,UserInputState=Enum.UserInputState.Begin,Position=Vector3.new(0,0,0),KeyCode=Enum.KeyCode.Unknown}
    local ok,err=invoke(label,"InputBegan",input)
    if not ok then return false,err end
    input.UserInputState=Enum.UserInputState.End
    local ended,endErr=invoke(label,"InputEnded",input)
    if not ended then return false,endErr end
for _=1,10 do
        task.wait(.1)
        if read(name)==value then return true,"สถานะตรงกัน" end
    end
    return false,"สถานะ Tora ไม่เปลี่ยน"
end
local main=UI:Tab("MAIN")
local section=main:Section("ระบบฟาร์ม")
local ready=false
local busy=false
local stageMax=24
local stageBox=tora and tora:FindFirstChildWhichIsA("TextBox",true)
local function normalizeStage(n) return math.clamp(math.round(tonumber(n) or 1),1,stageMax) end
local function setStage(n)
    n=normalizeStage(n)
    if not stageBox or not stageBox.Parent then return false,"ไม่พบช่อง Stage Number" end
    stageBox.Text=tostring(n)
    local count=0
    for _,c in ipairs(getconnections(stageBox.FocusLost)) do
        if c.Enabled~=false and type(c.Function)=="function" then
            local ok,err=pcall(c.Function,true,nil)
            if not ok then return false,tostring(err) end
            count+=1
        end
    end
    if count==0 or tonumber(stageBox.Text)~=n then return false,"Stage ไม่ตรงกัน" end
    config.Stage=n;save()
    return true,"Stage "..n
end
local defaultStage=normalizeStage(config.Stage or (stageBox and stageBox.Text))
local stageSlider:any
local stageReady=false
stageSlider=section:Slider({Name="เลือก Stage",Min=1,Max=stageMax,Step=1,Default=defaultStage,Callback=function(v)
    if not stageReady then return end
    local previous=config.Stage or defaultStage
    local ok,msg=setStage(v)
    if not ok then stageSlider:Set(previous,true) end
    UI:SetStatus(ok and msg or "Stage: เชื่อมไม่สำเร็จ")
end})
stageReady=true
setStage(defaultStage)
for _,item in ipairs(items) do
    local name,key=item[1],item[2]
    local current=read(name)
    if config[key]==nil then config[key]=current==true end
    section:Toggle({Name=name,Default=config[key]==true,Desc="ToraScript • บันทึกอัตโนมัติ",Callback=function(v)
        if not ready then return end
        if busy then UI:SetStatus("รอคำสั่งก่อนหน้า");return end
        busy=true
        local success,ok,msg=pcall(apply,name,v==true)
        busy=false
        if success and ok then config[key]=v==true;save();UI:SetStatus(name.." • "..(v and "ON" or "OFF"))
        else UI:SetStatus(name.." • เชื่อมไม่สำเร็จ");warn("[Moy Tora] "..tostring(success and msg or ok)) end
    end})
end
local P=game:GetService("Players").LocalPlayer
local R=game:GetService("ReplicatedStorage")
local sellTab=UI:Tab("SELL")
local ss=sellTab:Section("ขายของในกระเป๋า")
local function module(path)
    local node:any=R
    for _,part in ipairs(string.split(path,".")) do node=node:WaitForChild(part,5);assert(node,part) end
    return require(node)
end
local loaded,Seed,Evolution,Net=pcall(function()
    return module("Shared.Configs.SeedConfig"),module("Shared.Configs.EvolutionConfig"),module("Shared.Lib.Net")
end)
local function counts(attr)
    local raw=P:GetAttribute(attr)
    if type(raw)~="string" then return {} end
    local ok,data=pcall(function() return H:JSONDecode(raw) end)
    return ok and type(data)=="table" and data or {}
end
local function inventory()
    local list={}
    if not loaded then return list end
    local eq=tonumber(P:GetAttribute("EquippedEvolution")) or 0
    local skin=tonumber(P:GetAttribute("FruitSkin")) or 0
    for k,q in pairs(counts("EvolutionCounts")) do
        local id=tonumber(k)
        local d=id and Evolution.Get(id)
        local n=(tonumber(q) or 0)-((id==eq or id==skin) and 1 or 0)
        if d and id~=1 and not d.Exclusive and (d.SellPrice or 0)>0 and n>0 then
            table.insert(list,{key="Fruit:"..id,id=id,kind="Fruit",name=d.DisplayName,count=n,price=d.SellPrice})
        end
    end
    for k,q in pairs(counts("SeedsJson")) do
        local id=tonumber(k)
        local d=id and Seed.Get(id)
        local n=tonumber(q) or 0
        if d and n>0 and (d.SellPrice or 0)>0 then table.insert(list,{key="Seed:"..id,id=id,kind="Seed",name=d.Name,count=n,price=d.SellPrice}) end
    end
    table.sort(list,function(a,b) return a.key<b.key end)
    return list
end
local choices,selected={},{}
local dd:any
local pending=nil
local selling=false
local autoSell=false
local autoHandle:any
local function refresh()
    local options={}
    local total,chosen,chosenQty=0,0,0
    choices={}
    for _,item in ipairs(inventory()) do
        local checked=selected[item.key]==true
        local label=(checked and "[✓] " or "[ ] ")..item.name.." x"..item.count.." | "..item.price.." Gold"
        choices[label]=item;table.insert(options,label);total+=item.count
        if checked then chosen+=1;chosenQty+=item.count end
    end
    if #options==0 then options={"ไม่มีของที่ขายได้"} end
    if dd then dd:SetOptions(options);dd:Set("เลือกแล้ว "..chosen.." รายการ ("..chosenQty.." ชิ้น)",true) end
    return total,options,chosen,chosenQty
end
dd=ss:Dropdown({Name="เลือกของหลายรายการ",Options={"กำลังโหลด"},Default="กำลังโหลด",KeepOpen=true,Callback=function(v)
    local item=choices[v]
    if item then if selected[item.key] then selected[item.key]=nil else selected[item.key]=true end;pending=nil end
    local _,_,n,q=refresh();UI:SetStatus("เลือกแล้ว "..n.." รายการ • "..q.." ชิ้น")
end})
local function selection(mode)
    local chosen,total={},0
    for _,item in ipairs(inventory()) do
        if mode=="all" or selected[item.key] then
            local quantity=mode=="one" and 1 or item.count
            table.insert(chosen,{key=item.key,id=item.id,kind=item.kind,name=item.name,count=quantity,owned=item.count})
            total+=quantity
        end
    end
    return chosen,total
end
local function requestSale(mode)
    if selling or not loaded then return end
    local chosen,total=selection(mode)
    if total==0 then UI:SetStatus("ไม่มีของที่เลือก");return end
    local signature=mode
    for _,v in ipairs(chosen) do signature=signature.."|"..v.key..":"..v.count..":"..v.owned end
    if not pending or pending.signature~=signature or os.clock()>pending.expires then
        pending={signature=signature,expires=os.clock()+8}
        UI:SetStatus("ยืนยันขาย "..total.." ชิ้น • กดปุ่มเดิมซ้ำ");return
    end
    pending=nil;selling=true
    local sold=0
    -- Use the checked inventory for all modes, including SELL ALL.
    for _,item in ipairs(chosen) do
        local available=false
        for _,v in ipairs(inventory()) do if v.key==item.key and v.count>=item.count then available=true;break end end
        if available then
            local ok,res=pcall(function() return Net:InvokeServer(item.kind=="Fruit" and "SellFruit" or "SellSeed",item.id,item.count) end)
            if ok and type(res)=="table" and res.ok then sold+=item.count end
            task.wait(.4)
        end
    end
    selling=false;refresh();UI:SetStatus("ขายสำเร็จ "..sold.." ชิ้น")
end
local function stopAuto(message)
    autoSell=false
    if autoHandle then autoHandle:Set(false,true) end
    if message then UI:SetStatus(message) end
end
local function autoPlan() return selection("stack") end
autoHandle=ss:Toggle({Name="Auto Sell",Default=false,Desc="ขายเฉพาะชนิดที่เลือก",Callback=function(v)
    pending=nil
    if v and (not loaded or next(selected)==nil) then stopAuto("เลือกของก่อนเปิด Auto Sell");return end
    autoSell=v==true
end})
task.spawn(function()
    while UI.Root.Parent and env.MoyPowerFruitToken==token do
        if autoSell and not selling then
            local plan,total=autoPlan()
            if total>0 then
                selling=true
                for _,item in ipairs(plan) do
                    if not autoSell or not UI.Root.Parent or not selected[item.key] then break end
                    local quantity=0
                    for _,v in ipairs(inventory()) do if v.key==item.key then quantity=math.min(v.count,item.count);break end end
                    if quantity>0 then
                        local ok,res=pcall(function() return Net:InvokeServer(item.kind=="Fruit" and "SellFruit" or "SellSeed",item.id,quantity) end)
                        if not ok or type(res)~="table" or not res.ok then stopAuto("Auto Sell: เกมไม่ยืนยัน");break end
                        task.wait(.4)
                    end
                end
                selling=false;refresh()
            end
        end
        task.wait(2)
    end
end)
ss:Button({Name="รีเฟรชของในตัว",Callback=function() refresh() end})
ss:Button({Name="เลือกทั้งหมด",Callback=function() pending=nil;for _,item in ipairs(inventory()) do selected[item.key]=true end;refresh() end})
ss:Button({Name="ล้างการเลือก",Callback=function() pending=nil;stopAuto(nil);table.clear(selected);refresh() end})
ss:Button({Name="Sell Selected x1",Callback=function() requestSale("one") end})
ss:Button({Name="Sell Selected All",Callback=function() requestSale("stack") end})
ss:Button({Name="SELL ALL",Callback=function() requestSale("all") end})
ss:Label("กดปุ่มขายซ้ำภายใน 8 วินาทีเพื่อยืนยัน")
local sellConnections={}
for _,attr in ipairs({"SeedsJson","EvolutionCounts","EquippedEvolution","FruitSkin"}) do
    table.insert(sellConnections,P:GetAttributeChangedSignal(attr):Connect(function()
        if UI.Root.Parent then pending=nil;pcall(refresh) end
    end))
end
UI.Root.Destroying:Once(function() for _,c in ipairs(sellConnections) do c:Disconnect() end end)
env.MoySellPreview={inventory=inventory,refresh=refresh,dropdown=dd,selection=selection,autoPlan=autoPlan,autoHandle=autoHandle,isAuto=function() return autoSell end}
task.defer(function() pcall(refresh) end)
local economyReady,Upgrade,Enhance,Shop=pcall(function()
    return module("Shared.Configs.UpgradeConfig"),module("Shared.Configs.EnhanceConfig"),module("Shared.Configs.ShopConfig")
end)
local ut=UI:Tab("UPGRADES")
local us=ut:Section("อัปเกรดด้วย Gold")
local et=UI:Tab("ENHANCE")
local es=et:Section("ตีบวกผลไม้และฮาคิ")
local spendBusy=false
local autoUpgrade,upgradeHandles,target={},{},{}
local enhanceAuto=false
local enhanceHandle:any
local enhanceDD:any
local enhanceKey=nil
local enhanceOptions={}
local reserve=math.clamp(tonumber(config.GoldReserve) or 0,0,1000000)
local enhanceTarget=math.clamp(tonumber(config.EnhanceTarget) or 5,1,30)
local function gold() return tonumber(P:GetAttribute("Gold")) or 0 end
local function affordable(cost) return type(cost)=="number" and cost>0 and gold()-cost>=reserve end
local function upgradePlan(key)
    if not economyReady then return nil end
    local d=Upgrade.Get(key)
    if not d then return nil end
    local level=tonumber(P:GetAttribute("Upgrade"..key)) or 0
    return {key=key,name=d.DisplayName,level=level,max=d.MaxLevel,cost=Upgrade.Cost(key,level)}
end
local function enhanceList()
    local a={}
    if not economyReady then return a end
    local levels=Enhance.Parse(P:GetAttribute("EnhanceJson"))
    local highest=Shop.HighestWorldOf(P)
    for _,kind in ipairs({"Fruit","Haki"}) do
        for k,q in pairs(counts(kind=="Fruit" and "EvolutionCounts" or "HakiArmorCounts")) do
            local id=kind=="Fruit" and tonumber(k) or tostring(k)
            local d=id and Enhance.Item(kind,id)
            if d and (tonumber(q) or 0)>0 then
                local lv=Enhance.LevelOf(levels,kind,d.Key)
                table.insert(a,{id=id,key=kind..":"..tostring(id),kind=kind,name=d.Name,level=lv,cost=Enhance.Cost(d.Rarity,Enhance.PriceWorld(d.World,highest),lv),chance=Enhance.Chance(lv)})
            end
        end
    end
    table.sort(a,function(x,y) return x.key<y.key end)
    return a
end
local function refreshEnhance()
    local options={}
    local chosen=nil
    enhanceOptions={}
    for _,item in ipairs(enhanceList()) do
        local label=item.kind.." | "..item.name.." +"..item.level
        enhanceOptions[label]=item.key;table.insert(options,label)
        if item.key==enhanceKey then chosen=label end
    end
    if #options==0 then options={"ไม่มีของที่ตีบวกได้"} end
    chosen=chosen or options[1];enhanceKey=enhanceOptions[chosen]
    if enhanceDD then enhanceDD:SetOptions(options);enhanceDD:Set(chosen,true) end
    return options,chosen
end
local function chosenEnhance()
    for _,item in ipairs(enhanceList()) do if item.key==enhanceKey then return item end end
    return nil
end
local function perform(kind,item)
    if spendBusy or selling then return false,"รอคำสั่งก่อนหน้า" end
    if not item or not affordable(item.cost) then return false,"Gold ไม่พอหรือถึงระดับสูงสุด" end
    spendBusy=true
    local ok,res=pcall(function()
        if kind=="upgrade" then return Net:InvokeServer("BuyUpgrade",item.key) end
        return Net:InvokeServer("Enhance",item.kind,item.id)
    end)
    spendBusy=false
    if not ok or type(res)~="table" or not res.ok then return false,tostring(ok and type(res)=="table" and res.reason or "เกมไม่ยืนยัน") end
    if kind=="enhance" then return true,item.name.." • "..(res.success and "สำเร็จ" or "ไม่สำเร็จ").." +"..tostring(res.level or item.level) end
    return true,item.name.." • อัปเกรดสำเร็จ"
end
local confirmation=nil
local function manual(kind,key)
    local item=kind=="upgrade" and upgradePlan(key) or chosenEnhance()
    if not item or not affordable(item.cost) then UI:SetStatus("Gold ไม่พอหรือถึงระดับสูงสุด");return end
    local signature=kind..item.key..":"..item.level..":"..item.cost
    if not confirmation or confirmation.signature~=signature or os.clock()>confirmation.expires then
        confirmation={signature=signature,expires=os.clock()+8}
        UI:SetStatus("ยืนยัน "..item.name.." • "..item.cost.." Gold • กดซ้ำ")
        return
    end
    confirmation=nil
    local ok,msg=perform(kind,item)
    UI:SetStatus((ok and "" or "หยุด: ")..msg)
    refreshEnhance()
end
us:Slider({Name="Gold สำรอง (ใช้ร่วมสองระบบ)",Min=0,Max=1000000,Step=500,Default=reserve,Callback=function(v)
    reserve=v
    config.GoldReserve=v
    save()
end})
us:Label("เปิดเฉพาะรายการที่ต้องการ • ค่าเริ่มต้นปิด")
if economyReady and loaded then
    for _,d in ipairs(Upgrade.Upgrades) do
        local key=d.Key
        local row=ut:Section(d.DisplayName)
        local plan=upgradePlan(key)
        target[key]=math.clamp(tonumber(config["UpgradeTarget"..key]) or math.min(plan.level+1,d.MaxLevel),0,d.MaxLevel)
        row:Slider({Name="Level เป้าหมาย",Min=0,Max=d.MaxLevel,Step=1,Default=target[key],Callback=function(v)
            target[key]=v
            config["UpgradeTarget"..key]=v
            save()
        end})
        upgradeHandles[key]=row:Toggle({Name="Auto "..d.DisplayName,Default=false,Desc="หยุดเมื่อถึงเป้าหมายหรือ Gold ไม่พอ",Callback=function(v) autoUpgrade[key]=v==true end})
        row:Button({Name="Upgrade x1",Callback=function() manual("upgrade",key) end})
        row:Label("ตอนเปิด UI: Lv "..plan.level.." | "..(plan.cost and tostring(plan.cost).." Gold" or "MAX"))
    end
else
    us:Label("โหลดข้อมูลอัปเกรดไม่สำเร็จ")
end
local opts,default={"กำลังโหลดของในตัว"},"กำลังโหลดของในตัว"
enhanceDD=es:Dropdown({Name="เลือกของในตัว",Options=opts,Default=default,Callback=function(v)
    enhanceKey=enhanceOptions[v]
    enhanceAuto=false
    if enhanceHandle then enhanceHandle:Set(false,true) end
    confirmation=nil
end})
es:Slider({Name="ระดับเป้าหมาย +",Min=1,Max=30,Step=1,Default=enhanceTarget,Callback=function(v)
    enhanceTarget=v
    config.EnhanceTarget=v
    save()
end})
enhanceHandle=es:Toggle({Name="Auto Enhance",Default=false,Desc="ใช้ Gold เท่านั้น • หยุดเมื่อถึงเป้าหมาย",Callback=function(v)
    enhanceAuto=v==true and chosenEnhance()~=nil
    if v and not enhanceAuto then enhanceHandle:Set(false,true) end
end})
es:Button({Name="Enhance x1",Callback=function() manual("enhance") end})
es:Button({Name="รีเฟรชของและราคา",Callback=function()
    refreshEnhance()
    local item=chosenEnhance()
    if item then UI:SetStatus(item.name.." +"..item.level.." • "..tostring(item.cost or "MAX").." Gold • "..math.floor((item.chance or 0)*100+.5).."%") end
end})
es:Label("ตีบวกมีโอกาสล้มเหลว • ไม่ใช้ SUPER / Robux")
local econCon={}
for _,attr in ipairs({"EvolutionCounts","HakiArmorCounts","EnhanceJson"}) do
    table.insert(econCon,P:GetAttributeChangedSignal(attr):Connect(function()
        if UI.Root.Parent then refreshEnhance() end
    end))
end
UI.Root.Destroying:Once(function() for _,c in ipairs(econCon) do c:Disconnect() end end)
env.MoyUpgradeEnhance={upgradePlan=upgradePlan,enhanceList=enhanceList,chosenEnhance=chosenEnhance,affordable=affordable,states=function() return autoUpgrade,enhanceAuto end}
task.spawn(function()
    while UI.Root.Parent and env.MoyPowerFruitToken==token do
        if economyReady and loaded and not spendBusy and not selling then
            local acted=false
            for _,d in ipairs(Upgrade.Upgrades) do
                local k=d.Key
                if autoUpgrade[k] then
                    local item=upgradePlan(k)
                    if not item or item.level>=target[k] or not affordable(item.cost) then
                        autoUpgrade[k]=false
                        upgradeHandles[k]:Set(false,true)
                    else
                        local ok,msg=perform("upgrade",item)
                        UI:SetStatus(msg)
                        if not ok then autoUpgrade[k]=false;upgradeHandles[k]:Set(false,true) end
                        acted=true
                        break
                    end
                end
            end
            if enhanceAuto and not acted then
                local item=chosenEnhance()
                if not item or item.level>=enhanceTarget or not affordable(item.cost) then
                    enhanceAuto=false
                    enhanceHandle:Set(false,true)
                    UI:SetStatus("Auto Enhance: หยุด • ถึงเป้าหมายหรือ Gold ไม่พอ")
                else
                    local ok,msg=perform("enhance",item)
                    UI:SetStatus(msg)
                    if not ok then enhanceAuto=false;enhanceHandle:Set(false,true) end
                end
            end
        end
        task.wait(2)
    end
end)

do
local M:any={amount=4,reserve=0,best=false,mode="Fruit",selected={},auto=false,busy=false}
local G=module("Shared.Configs.GreenhouseConfig")
function M.snapshot() return counts("SeedsJson") end
function M.world() return Seed.SeedWorldFor(tonumber(P:GetAttribute("World")) or 1) end
function M.plan(raw,world,amount,keep,best,selected)
    amount=math.clamp(math.floor(tonumber(amount) or 4),G.MinSeeds,G.MaxSeeds)
    keep=math.max(0,math.floor(tonumber(keep) or 0))
    local list,total={},0
    for k,q in pairs(raw) do
        local id=tonumber(k);local d=id and Seed.Get(id);local n=math.floor(tonumber(q) or 0)
        if d and n>0 and Seed.WorldOf(id)==world then
            total+=n
            if best or selected[id] then table.insert(list,{id=id,count=n,value=d.GrowValue or 0,name=d.Name}) end
        end
    end
    if total-amount<keep then return nil,"เมล็ดไม่พอหรือเกินจำนวนสำรอง" end
    table.sort(list,function(a,b) if a.value~=b.value then return a.value>b.value end;return a.id<b.id end)
    local slots,remaining={},amount
    for _,item in ipairs(list) do
        if remaining<=0 or #slots>=G.MaxSlots then break end
        local n=math.min(remaining,item.count)
        if n>0 then table.insert(slots,{seedId=item.id,count=n});remaining-=n end
    end
    if remaining>0 then return nil,"เมล็ดที่เลือกไม่พอภายใน 4 ช่อง" end
    local normalized,why=G.Normalize(slots)
    if not normalized then return nil,tostring(why) end
    local w,e=G.GrowWorld(normalized)
    if w~=world then return nil,tostring(e or "MixedWorlds") end
    return {slots=slots,amount=amount,world=w,odds=G.OddsForSlots(normalized,Upgrade.LuckPoints(tonumber(P:GetAttribute("UpgradeLuck")) or 0),0),multiplier=G.SeedMultiplier(normalized)}
end
function M.current() return M.plan(M.snapshot(),M.world(),M.amount,M.reserve,M.best,M.selected) end
function M.items()
    local out={}
    for k,q in pairs(M.snapshot()) do
        local id=tonumber(k);local d=id and Seed.Get(id)
        if d and Seed.WorldOf(id)==M.world() and (tonumber(q) or 0)>0 then table.insert(out,{id=id,name=d.Name,count=tonumber(q),value=d.GrowValue}) end
    end
    table.sort(out,function(a,b) return a.id<b.id end)
    return out
end
function M.grow()
    if M.busy or selling then return false,"รอผลก่อนหน้า" end
    local plan,why=M.current()
    if not plan then return false,why end
    M.busy=true
    local ok,res=pcall(function() return Net:InvokeServer("GreenhouseGrow",plan.slots,M.mode,false) end)
    M.busy=false
    if not ok or type(res)~="table" or not res.ok then return false,tostring(ok and type(res)=="table" and res.reason or "เกมไม่ยืนยัน") end
    return true,tostring(res.rarity or "สำเร็จ")
end
env.MoyGardenModel=M
local sec=UI:Tab("GARDEN"):Section("สวนผสมเมล็ด")
local dd:any
local auto:any
local labels={}
local pending=nil
local function refreshGarden()
    local options={}
    labels={}
    local n=0
    for _,item in ipairs(M.items()) do
        local label=(M.selected[item.id] and "[✓] " or "[ ] ")..item.name.." x"..item.count
        labels[label]=item.id;table.insert(options,label)
        if M.selected[item.id] then n+=1 end
    end
    if #options==0 then options={"ไม่มีเมล็ดในตัว"} end
    if dd then dd:SetOptions(options);dd:Set("เลือกแล้ว "..n.." ชนิด",true) end
    return options
end
sec:Dropdown({Name="ประเภทผลลัพธ์",Options={"Fruits","Haki"},Default="Fruits",Callback=function(v) M.mode=v=="Haki" and "Armor" or "Fruit";pending=nil end})
dd=sec:Dropdown({Name="เลือกเมล็ดหลายชนิด",Options={"กำลังโหลด"},Default="กำลังโหลด",KeepOpen=true,Callback=function(v)
    local id=labels[v];if id then M.selected[id]=not M.selected[id];pending=nil end;refreshGarden()
end})
sec:Slider({Name="จำนวนเมล็ดต่อรอบ",Min=4,Max=10,Step=1,Default=4,Callback=function(v) M.amount=v;pending=nil end})
sec:Slider({Name="เมล็ดสำรอง",Min=0,Max=100,Step=1,Default=0,Callback=function(v) M.reserve=v;pending=nil end})
sec:Toggle({Name="Auto Best Seeds",Default=false,Callback=function(v) M.best=v==true;pending=nil end})
sec:Button({Name="รีเฟรชเมล็ดในตัว",Callback=refreshGarden})
sec:Button({Name="ล้างการเลือก",Callback=function() table.clear(M.selected);M.auto=false;auto:Set(false,true);pending=nil;refreshGarden() end})
sec:Button({Name="Preview Chance",Callback=function()
    local plan,why=M.current();if not plan then UI:SetStatus(why);return end
    local a={}
    for _,n in ipairs({"Common","Uncommon","Rare","Epic","Elemental","Beast","Ancient","Mythical"}) do if (plan.odds[n] or 0)>0 then table.insert(a,n.." "..string.format("%.2f%%",plan.odds[n]*100)) end end
    UI:SetStatus(table.concat(a," | "))
end})
sec:Button({Name="Grow x1",Callback=function()
    local plan,why=M.current();if not plan then UI:SetStatus(why);return end
    local key=M.mode..H:JSONEncode(plan.slots)
    if not pending or pending.key~=key or os.clock()>pending.expires then pending={key=key,expires=os.clock()+8};UI:SetStatus("ยืนยันใช้ "..plan.amount.." เมล็ด • กดซ้ำ");return end
    pending=nil;local ok,msg=M.grow();UI:SetStatus(msg);refreshGarden()
end})
auto=sec:Toggle({Name="Auto Garden",Default=false,Desc="ไม่ใช้ Robux",Callback=function(v) M.auto=v==true end})
sec:Label("ผสม 4–10 เมล็ด • สูงสุด 4 ชนิด • โลกเดียวกัน")
M.refresh=refreshGarden;M.autoHandle=auto
local con=P:GetAttributeChangedSignal("SeedsJson"):Connect(function() if UI.Root.Parent then pcall(refreshGarden) end end)
UI.Root.Destroying:Once(function() M.auto=false;con:Disconnect() end)
task.defer(function() pcall(refreshGarden) end)
task.spawn(function()
    while UI.Root.Parent and env.MoyGardenModel==M do
        if M.auto and not M.busy and not selling then
            local plan,why=M.current()
            if plan then local ok,msg=M.grow();UI:SetStatus(msg);if not ok then M.auto=false;auto:Set(false,true) end
            else UI:SetStatus("Garden รอ: "..why) end
        end
        task.wait(3)
    end
end)
end
do
local M:any={auto=false,alive=true,busy=false,count=1,reserve=0,last=-100,lastResult=nil}
function M.scrolls() return tonumber(P:GetAttribute("Scrolls")) or 0 end
function M.plan(n,available,reserve)
    if n~=1 and n~=10 then return false,"จำนวนสุ่มต้องเป็น 1 หรือ 10" end
    if available-n<math.max(0,reserve) then return false,"Scrolls ไม่พอหรือถึงจำนวนสำรอง" end
    return true,"พร้อมสุ่ม"
end
function M.pull(n)
    if not M.alive or not UI.Root.Parent or M.busy or os.clock()-M.last<2 then return false,"รอก่อนสุ่ม" end
    local before=M.scrolls();local allowed,why=M.plan(n,before,M.reserve)
    if not allowed then return false,why end
    M.busy=true;M.last=os.clock()
    local ok,res=pcall(function() return Net:InvokeServer("Summon",n) end)
    if not ok or type(res)~="table" or not res.ok or type(res.results)~="table" then M.busy=false;return false,tostring(ok and type(res)=="table" and res.reason or "เกมไม่ยืนยัน") end
    for _=1,25 do if M.scrolls()<=before-n then break end;task.wait(.1) end
    local after=M.scrolls();M.lastResult={count=n,results=res.results,before=before,after=after};M.busy=false
    if #res.results~=n or before-after~=n then return false,"จำนวน Scrolls ยังไม่ตรง" end
    return true,"Summon x"..n.." สำเร็จ • เหลือ "..after.." Scrolls"
end
local sec=UI:Tab("SUMMON"):Section("สุ่มพันธมิตร")
local pending=nil
local handle:any
function M.stop(msg) M.auto=false;if handle then handle:Set(false,true) end;if msg then UI:SetStatus(msg) end end
function M.manual(n)
    if M.auto then UI:SetStatus("ปิด Auto Summon ก่อน");return end
    local ok,why=M.plan(n,M.scrolls(),M.reserve);if not ok then UI:SetStatus(why);return end
    if not pending or pending.count~=n or pending.expires<os.clock() then pending={count=n,expires=os.clock()+8};UI:SetStatus("ยืนยันใช้ "..n.." Scrolls • กดซ้ำ");return end
    pending=nil;local success,msg=M.pull(n);UI:SetStatus(msg)
end
sec:Label("สุ่มด้วย Scrolls เท่านั้น • ไม่ใช้ Robux")
sec:Button({Name="Summon x1",Callback=function() M.manual(1) end})
sec:Button({Name="Summon x10",Callback=function() M.manual(10) end})
sec:Dropdown({Name="จำนวนสุ่มอัตโนมัติ",Options={"x1","x10"},Default="x1",Callback=function(v) M.stop(nil);M.count=v=="x10" and 10 or 1;pending=nil end})
M.reserveHandle=sec:Slider({Name="Scrolls สำรอง",Min=0,Max=1000,Step=1,Default=0,Callback=function(v) M.reserve=v;pending=nil end})
handle=sec:Toggle({Name="Auto Summon",Default=false,Callback=function(v)
    pending=nil
    if v then local ok,why=M.plan(M.count,M.scrolls(),M.reserve);if not ok then M.stop(why);return end end
    M.auto=v==true
end})
sec:Button({Name="ตรวจสอบ Scrolls",Callback=function() UI:SetStatus("Scrolls: "..M.scrolls()) end})
M.autoHandle=handle;env.MoySummon=M
UI.Root.Destroying:Once(function() M.auto=false;M.alive=false end)
task.spawn(function()
    while M.alive and UI.Root.Parent and env.MoySummon==M do
        if M.auto and not M.busy and os.clock()-M.last>=3 then
            local ok,msg=M.pull(M.count);UI:SetStatus(msg);if not ok then M.stop(msg) end
        end
        task.wait(.3)
    end
end)
end
do
local Gift=module("Shared.Configs.PlaytimeRewardsConfig")
local M:any={alive=true,auto=false,busy=false,last={},rounds=0}
local function invokeReward(name,...)
    local args=table.pack(...)
    local ok,res=pcall(function() return Net:InvokeServer(name,table.unpack(args,1,args.n)) end)
    return ok and type(res)=="table" and res or nil
end
local function fireReward(name,...)
    local args=table.pack(...)
    return pcall(function() Net:FireServer(name,table.unpack(args,1,args.n)) end)
end
local function attr(k) return tonumber(P:GetAttribute(k)) or 0 end
local function indexCount()
    local gui=P.PlayerGui:FindFirstChild("FusionUI");local r=gui and gui:FindFirstChild("IndexRoot")
    local b=r and r:FindFirstChild("ClaimAllBtn",true)
    if b then
        for _,v in ipairs(b:GetDescendants()) do if v:IsA("TextLabel") then local n=v.Text:match("CLAIM ALL %((%d+)%)");if n then return tonumber(n) or 0 end end end
        if b:IsA("TextButton") then return tonumber(b.Text:match("CLAIM ALL %((%d+)%)")) or 0 end
    end
    return 0
end
function M.snapshot()
    return {gold=attr("Gold"),scrolls=attr("Scrolls"),power=attr("Power"),xp=attr("IndexXp"),indexLevel=attr("IndexLevel"),indexRewardLevel=attr("IndexRewardLevel"),seasonXp=attr("SeasonXp"),seasonReady=attr("SeasonReady"),playtimeReady=attr("PlaytimeReady"),seeds=P:GetAttribute("SeedsJson"),robux=attr("RobuxSpent")}
end
function M.cycle()
    if not M.alive or not UI.Root.Parent or M.busy then return nil end
    M.busy=true
    local log={}
    local function record(kind,ok,details) table.insert(log,{kind=kind,ok=ok==true,details=details}) end
    local success,err=pcall(function()
        local gift=invokeReward("GetGiftState")
        if gift and gift.tiers then
            for _,t in ipairs(Gift.Tiers) do
                local state=gift.tiers[t.id]
                if state and (tonumber(state.used) or 0)<t.daily and (tonumber(gift.elapsed) or 0)-(tonumber(state.at) or 0)>=t.every then
                    local res=invokeReward("ClaimGift",t.id);record(t.id,res and res.ok,res);task.wait(.4)
                end
            end
        end
        if indexCount()>0 then local res=invokeReward("ClaimIndexAll");record("Index All",res and res.ok,res);task.wait(.6) end
        for _=1,10 do
            if attr("IndexRewardLevel")>=attr("IndexLevel") then break end
            local res=invokeReward("ClaimIndexLevel");record("Index Level",res and res.ok,res)
            if not res or not res.ok then break end;task.wait(.5)
        end
        local season=invokeReward("GetSeasonPassState")
        if season then
            for _,q in ipairs(season.quests or {}) do
                if not q.claimed and type(q.key)=="string" and (tonumber(q.progress) or 0)>=(tonumber(q.target) or math.huge) then
                    local sent=fireReward("ClaimSeasonQuest",q.key);task.wait(.6)
                    local state=invokeReward("GetSeasonPassState");local confirmed=false
                    for _,v in ipairs(state and state.quests or {}) do if v.key==q.key and v.claimed then confirmed=true end end
                    record("Season Quest: "..q.key,sent and confirmed)
                end
            end
            season=invokeReward("GetSeasonPassState")
            if season then
                for i=1,math.min(tonumber(season.tier) or 0,#(season.free or {})) do
                    if season.free[i]==false then
                        local sent=fireReward("ClaimSeasonReward","free",i);task.wait(.5)
                        local state=invokeReward("GetSeasonPassState");record("Season Free "..i,sent and state and state.free and state.free[i]==true)
                    end
                end
            end
        end
        local daily=invokeReward("GetDailyRewardsState")
        if daily and daily.canClaim then
            local sent=fireReward("ClaimDailyReward");task.wait(.6)
            local after=invokeReward("GetDailyRewardsState");record("Daily",sent and after and after.canClaim==false)
        end
        local group=invokeReward("GetGroupRewardState")
        if group and group.canClaim and group.inGroup and not group.claimed then
            local sent=fireReward("ClaimGroupReward");task.wait(.6)
            local after=invokeReward("GetGroupRewardState");record("Group",sent and after and after.claimed==true)
        end
        local offline=invokeReward("GetOfflineRewardState")
        if offline and offline.pending then
            local sent=fireReward("ClaimOfflineReward");task.wait(.6)
            local after=invokeReward("GetOfflineRewardState");record("Offline",sent and after and after.pending==false)
        end
    end)
    M.busy=false
    if not success then record("Error",false,tostring(err)) end
    M.last=log;M.rounds+=1
    local passed,failed=0,0
    for _,v in ipairs(log) do if v.ok then passed+=1 else failed+=1 end end
    UI:SetStatus("Claim All: "..passed.." สำเร็จ • "..failed.." ไม่ยืนยัน")
    if failed>0 then M.auto=false;if M.handle then M.handle:Set(false,true) end end
    return log
end
local sec=UI:Tab("CLAIM"):Section("รับรางวัลฟรี")
sec:Label("Free Gifts • Index • Season • Daily • Group • Offline")
sec:Button({Name="Claim All",Callback=function() M.cycle() end})
M.handle=sec:Toggle({Name="Auto Claim All",Default=false,Desc="ตรวจทุก 30 วินาที",Callback=function(v) M.auto=v==true end})
sec:Label("ไม่ซื้อ Premium • ไม่กดโฆษณา • ไม่ใช้ Robux")
env.MoyClaim=M
UI.Root.Destroying:Once(function() M.auto=false;M.alive=false end)
task.spawn(function()
    while M.alive and UI.Root.Parent and env.MoyClaim==M do
        if M.auto and not M.busy then M.cycle();for _=1,30 do if not M.auto or not M.alive then break end;task.wait(1) end
        else task.wait(.5) end
    end
end)
end
do
local B=module("Shared.Configs.HakiArmorConfig")
local T=module("Shared.Configs.TitleConfig")
local G=module("Shared.Configs.PoneglyphConfig")
local A=module("Shared.Configs.AwakeningConfig")
local Trial=module("Shared.Configs.SeaTrialsConfig")
local Modes=module("Shared.Configs.TrialModesConfig")
local Signals=module("Shared.Client.ClientSignals")
local Reg=module("Shared.Lib.ClientRegistry")
local M:any={alive=true,auto={},handles={},busy=false,priority={Title="Power",Poneglyph="Power",Awakening="Power"},chosen={},dropdowns={},maps={},nextSkill=0}
local kinds={"Fruit","Seed","Haki","Title","Poneglyph","Awakening"}
local function attr(k) return tonumber(P:GetAttribute(k)) or 0 end
local function score(b,stat) return tonumber(b and b[stat]) or 0 end
function M.items(kind)
    local rows={}
    local function add(id,name,value,extra) table.insert(rows,{id=id,name=name,value=tonumber(value) or 0,extra=extra}) end
    if kind=="Fruit" then
        local lvls=Enhance.Parse(P:GetAttribute("EnhanceJson"))
        for k,q in pairs(counts("EvolutionCounts")) do
            local id=tonumber(k);local d=id and Evolution.Get(id)
            if d and (tonumber(q) or 0)>0 and (d.World or 1)<=math.max(1,attr("World")) then
                add(id,d.DisplayName,Evolution.DamageFor(id,math.max(1,attr("World"))),{count=q,level=Enhance.LevelOf(lvls,"Fruit",tostring(id))})
            end
        end
    elseif kind=="Seed" then
        for k,q in pairs(counts("SeedsJson")) do local id=tonumber(k);local d=id and Seed.Get(id);if d and (tonumber(q) or 0)>0 then add(id,d.Name,d.GrowValue,{count=q,rarity=d.Rarity}) end end
    elseif kind=="Haki" then
        for id,q in pairs(counts("HakiArmorCounts")) do local d=B.Get(id);if d and (tonumber(q) or 0)>0 then add(id,d.Name,B.DefenseFor(id),{count=q}) end end
    elseif kind=="Title" then
        for _,id in ipairs(counts("TitlesJson").o or {}) do local d=T.Get(id);if d then add(id,d.Name,score(d.Bonus,M.priority.Title),d.Bonus) end end
    elseif kind=="Poneglyph" then
        for id,lv in pairs(counts("PoneglyphsJson").o or {}) do local d=G.Get(id);if d and tonumber(lv) then add(id,d.Name,score(G.BuffsFor(id,G.ClampLevel(lv)),M.priority.Poneglyph),{level=lv}) end end
    elseif kind=="Awakening" then
        for id,v in pairs(counts("AwakeningsJson").o or {}) do
            local d=A.Get(id);local xp=type(v)=="table" and (v.xp or v[1]) or v
            if d and tonumber(xp) then local lv=A.LevelFor(tonumber(xp));add(id,d.Name,score(A.BuffsFor(id,lv),M.priority.Awakening),{level=lv}) end
        end
    end
    table.sort(rows,function(a,b) if a.value~=b.value then return a.value>b.value end;return tostring(a.id)<tostring(b.id) end)
    return rows
end
function M.equipped(kind,id)
    if kind=="Fruit" then return attr("EquippedEvolution")==id end
    if kind=="Haki" then return P:GetAttribute("EquippedHakiArmor")==id end
    if kind=="Title" then return counts("TitlesJson").e==id or P:GetAttribute("TitleId")==id end
    if kind=="Poneglyph" then return table.find(counts("PoneglyphsJson").e or {},id)~=nil end
    if kind=="Awakening" then return counts("AwakeningsJson").e==id or P:GetAttribute("EquippedAwakening")==id end
    return false
end
local remotes={Fruit="EquipEvolution",Haki="EquipHakiArmor",Title="EquipTitle",Poneglyph="EquipPoneglyph",Awakening="EquipAwakening"}
local function invokeEquip(name,...)
    local args=table.pack(...)
    local ok,res=pcall(function() return Net:InvokeServer(name,table.unpack(args,1,args.n)) end)
    return ok and type(res)=="table" and res or nil
end
function M.equip(kind,id)
    if M.busy or not M.alive or selling then return false,"ระบบไม่พร้อม" end
    if not remotes[kind] then return false,"ไม่ใช่อุปกรณ์" end
    local found=false
    for _,v in ipairs(M.items(kind)) do if v.id==id then found=true;break end end
    if not found then return false,"ไม่มีไอเทมในตัว" end
    if M.equipped(kind,id) then return true,"สวมใส่อยู่แล้ว" end
    if kind=="Poneglyph" and #(counts("PoneglyphsJson").e or {})>=G.EquipSlots then return false,"ช่องเต็ม • ถอดชิ้นเดิมก่อน" end
    M.busy=true
    local res=invokeEquip(remotes[kind],id)
    for _=1,20 do if M.equipped(kind,id) then break end;task.wait(.1) end
    local ok=M.equipped(kind,id);M.busy=false
    return ok,ok and "สวมใส่สำเร็จ" or tostring(res and res.reason or "เกมไม่ยืนยัน")
end
function M.best(kind)
    local r=M.items(kind);if not r[1] then return false,"ไม่มีไอเทมในตัว" end
    return M.equip(kind,r[1].id)
end
function M.unequipPG()
    if M.busy then return false,"รอคำสั่งก่อนหน้า" end
    local id=(counts("PoneglyphsJson").e or {})[1]
    if not id then return false,"ไม่มีศิลาสวมอยู่" end
    M.busy=true;local res=invokeEquip("UnequipPoneglyph",id);task.wait(.6)
    local ok=not M.equipped("Poneglyph",id);M.busy=false
    return ok,ok and "ถอดสำเร็จ" or tostring(res and res.reason or "เกมไม่ยืนยัน")
end
function M.roll()
    if M.busy or not M.alive then return false,"ระบบไม่พร้อม" end
    local before=tonumber(counts("AwakeningsJson").t) or 0
    if before<1 then return false,"ไม่มี Awakening Token" end
    M.busy=true;local res=invokeEquip("RollAwakening");task.wait(.6);M.busy=false
    local ok=res and res.ok==true and (tonumber(counts("AwakeningsJson").t) or 0)<before
    return ok==true,ok and ("ได้รับ "..tostring(res.id)) or tostring(res and res.reason or "เกมไม่ยืนยัน")
end
function M.skill()
    local c=Reg.TryGet("AwakeningController");local state=c and c.GetState and c.GetState()
    if not state or not state.owned or (counts("AwakeningsJson").e or "")=="" then return false,"ยังไม่ได้สวม Awakening" end
    if attr("FarmStage")<=0 and P:GetAttribute("InTrial")~=true and P:GetAttribute("InRaid")~=true then return false,"ยังไม่อยู่ในการต่อสู้" end
    if os.clock()<M.nextSkill then return false,"รอ Cooldown" end
    M.nextSkill=os.clock()+2;Signals:Get("AwakeningActivate"):Fire()
    return true,"ส่งคำสั่งใช้สกิล"
end
function M.trial()
    if M.busy then return false,"รอคำสั่งก่อนหน้า" end
    if P:GetAttribute("InTrial")==true then return false,"อยู่ใน Sea Trials แล้ว" end
    if P:GetAttribute("InRaid")==true or attr("FarmStage")>0 then return false,"ออกจากการต่อสู้ก่อน" end
    if attr("SeaTrialTickets")<Trial.TicketCost(1) then return false,"ไม่มี Sea Trial Ticket" end
    if not Modes.IsOpen("SeaTrials",workspace:GetServerTimeNow()) then return false,"Sea Trials ยังไม่เปิด" end
    M.busy=true;local res=invokeEquip("TrialStart",1,"SeaTrials");task.wait(.5);M.busy=false
    return res and res.ok==true or false,res and res.ok and "เริ่ม Sea Trials สำเร็จ" or tostring(res and res.reason or "เกมไม่ยืนยัน")
end
function M.options(kind)
    local opts,map={},{}
    for _,v in ipairs(M.items(kind)) do
        local label=v.name.." | "..string.format("%.4g",v.value)
        if kind=="Seed" then label=v.name.." x"..tostring(v.extra.count) end
        map[label]=v.id;table.insert(opts,label)
    end
    if #opts==0 then opts={"ไม่มีของในตัว"} end
    M.maps[kind]=map;M.chosen[kind]=map[opts[1]]
    return opts
end
local tab=UI:Tab("EQUIP")
local names={Fruit="ผลไม้",Seed="เมล็ด",Haki="เกราะฮาคิ",Title="ฉายา",Poneglyph="ศิลาจารึก",Awakening="พลังตื่นรู้"}
local function say(msg) UI:SetStatus(msg) end
local function refreshEquip(k)
    local opts=M.options(k);local dd=M.dropdowns[k]
    if dd then dd:SetOptions(opts);dd:Set(opts[1],true) end
end
local function toggle(sec,key,name,desc)
    M.handles[key]=sec:Toggle({Name=name,Default=false,Desc=desc,Callback=function(v) M.auto[key]=v==true end})
end
for _,kind in ipairs(kinds) do
    local k=kind
    local sec=tab:Section(names[k])
    if M.priority[k] then
        local opts=k=="Title" and {"Power","Gold","Damage"} or {"Power","Gold","Luck","Defense","Health","Speed"}
        sec:Dropdown({Name="เน้นโบนัส",Options=opts,Default="Power",Callback=function(v) M.priority[k]=v;pcall(refreshEquip,k) end})
    end
    M.maps[k]={}
    M.dropdowns[k]=sec:Dropdown({Name="เลือก "..names[k],Options={"กำลังโหลด"},Default="กำลังโหลด",Callback=function(v) M.chosen[k]=M.maps[k][v] end})
    sec:Button({Name="รีเฟรช "..names[k],Callback=function() pcall(refreshEquip,k) end})
    if k=="Seed" then
        sec:Button({Name="ตรวจเมล็ดในตัว",Callback=function() local n=0;for _,v in ipairs(M.items(k)) do n+=tonumber(v.extra.count) or 0 end;say("เมล็ด "..n.." ชิ้น • ใช้แท็บ SELL / GARDEN") end})
    else
        sec:Button({Name="Equip Selected",Callback=function() local ok,msg=M.equip(k,M.chosen[k]);say(msg) end})
        sec:Button({Name="Equip Best "..k,Callback=function() local ok,msg=M.best(k);say(msg) end})
        toggle(sec,k,"Auto Equip Best "..k,"เลือกจากของที่มีเท่านั้น")
    end
    if k=="Poneglyph" then
        sec:Button({Name="Unequip Poneglyph",Callback=function() local ok,msg=M.unequipPG();say(msg) end})
        toggle(sec,"Trial","Auto Poneglyph Trial","เข้า Sea Trials เมื่อมีตั๋ว • ใช้ตั๋วจริง")
        sec:Label("เข้า Trial อัตโนมัติเท่านั้น • ไม่รวมระบบต่อสู้")
    elseif k=="Awakening" then
        sec:Button({Name="Roll Awakening x1",Callback=function() local ok,msg=M.roll();say(msg) end})
        toggle(sec,"Roll","Auto Roll Awakening","ใช้ Token ที่มีจริงเท่านั้น")
        toggle(sec,"Skill","Auto Skill Awakening","ใช้สกิลปกติของเกม")
    end
end
env.MoyInventory=M
task.defer(function() for _,k in ipairs(kinds) do pcall(refreshEquip,k) end end)
UI.Root.Destroying:Once(function() M.alive=false;table.clear(M.auto) end)
task.spawn(function()
    while M.alive and UI.Root.Parent and env.MoyInventory==M do
        for _,k in ipairs({"Fruit","Haki","Title","Poneglyph","Awakening"}) do
            if M.auto[k] and not M.busy then
                local rows=M.items(k)
                if rows[1] and not M.equipped(k,rows[1].id) then local ok,msg=M.best(k);say(k..": "..msg);if not ok then M.auto[k]=false;M.handles[k]:Set(false,true) end end
            end
        end
        if M.auto.Roll and not M.busy then local ok,msg=M.roll();if not ok then M.auto.Roll=false;M.handles.Roll:Set(false,true) end;say(msg) end
        if M.auto.Skill then M.skill() end
        if M.auto.Trial and not M.busy and P:GetAttribute("InTrial")~=true then local ok,msg=M.trial();say(msg);if not ok then M.auto.Trial=false;M.handles.Trial:Set(false,true) end end
        task.wait(3)
    end
end)
end
UI:AddSettingsTab()
do
local root=UI.Root
local first=root:FindFirstChild("TabBtn_MAIN",true)
if first and first.Parent then
    local dock=first.Parent
    local lens=dock:FindFirstChild("DockLens")
    local player=dock:FindFirstChild("DockPlayer")
    local clock=dock:FindFirstChild("DockClock")
    if lens and player and clock then
        local order={"MAIN","GARDEN","SUMMON","EQUIP","UPGRADES","ENHANCE","SELL","CLAIM","SETTINGS"}
        local scroll=Instance.new("ScrollingFrame")
        scroll.Name="MoyTabScroll"
        scroll.BackgroundTransparency=1
        scroll.BorderSizePixel=0
        scroll.Position=UDim2.fromOffset(0,8)
        scroll.Size=UDim2.new(1,0,1,-64)
        scroll.ClipsDescendants=true
        scroll.Active=true
        scroll.ScrollingDirection=Enum.ScrollingDirection.Y
        scroll.ScrollBarThickness=3
        scroll.ScrollBarImageColor3=Color3.fromRGB(172,139,215)
        scroll.ScrollBarImageTransparency=.3
        scroll.CanvasSize=UDim2.fromOffset(0,6+#order*38+4)
        scroll.Parent=dock
        local divider=Instance.new("Frame")
        divider.Name="MoyProfileDivider"
        divider.BackgroundColor3=Color3.fromRGB(126,104,158)
        divider.BackgroundTransparency=.45
        divider.BorderSizePixel=0
        divider.Position=UDim2.new(0,10,1,-51)
        divider.Size=UDim2.new(1,-20,0,1)
        divider.Parent=dock
        local connections={}
        local active=nil
        lens.Parent=scroll
        for i,k in ipairs(order) do
            local b=root:FindFirstChild("TabBtn_"..k,true)
            local page=root:FindFirstChild("Page_"..k,true)
            if b and page then
                b.Parent=scroll
                b.Position=UDim2.fromOffset(8,6+(i-1)*38)
                b.Size=UDim2.new(1,-18,0,30)
                if page.Visible then active=b end
                table.insert(connections,page:GetPropertyChangedSignal("Visible"):Connect(function()
                    if not page.Visible then return end
                    task.defer(function()
                        if not scroll.Parent or not page.Visible then return end
                        local top=scroll.AbsolutePosition.Y+4
                        local bottom=scroll.AbsolutePosition.Y+scroll.AbsoluteWindowSize.Y-4
                        local bt=b.AbsolutePosition.Y
                        local bb=bt+b.AbsoluteSize.Y
                        local y=scroll.CanvasPosition.Y
                        if bt<top then y+=bt-top elseif bb>bottom then y+=bb-bottom end
                        scroll.CanvasPosition=Vector2.new(0,math.clamp(y,0,math.max(0,scroll.AbsoluteCanvasSize.Y-scroll.AbsoluteWindowSize.Y)))
                    end)
                end))
            end
        end
        lens.Size=UDim2.new(1,-18,0,30)
        if active then lens.Position=UDim2.fromOffset(8,active.Position.Y.Offset) end
        player.Position=UDim2.new(0,10,1,-28)
        clock.Position=UDim2.new(0,10,1,-10)
        env.MoyDockLayout={scroll=scroll,order=order,connections=connections,dock=dock}
        UI.Root.Destroying:Once(function() for _,c in ipairs(connections) do c:Disconnect() end end)
    end
end
UI:SetTitle("MoyXHub | +1 Power Fruit Evolution")
for _,v in ipairs(root:GetDescendants()) do
    if v:IsA("TextLabel") and v.Name=="Title" and v.Text=="MoyXHub | +1 Power Fruit Evolution" then
        v.Size=UDim2.new(1,-398,0,22)
        v.TextSize=16
        v.TextTruncate=Enum.TextTruncate.AtEnd
        break
    end
end
end
UI:Toggle(true)
ready=true
task.defer(function()
    if UI.Root.Parent then
        local ok,err=pcall(refreshEnhance)
        if not ok then warn("[Moy Enhance] "..tostring(err)) end
    end
end)
save()
UI:SetStatus(tora and "ToraScript: เชื่อมต่อ • ซ่อน UI" or "ToraScript: โหลดไม่สำเร็จ")
env.MoyPowerFruit={config=config,ui=UI,read=read,apply=apply,tora=tora,stageSlider=stageSlider,setStage=setStage,stageBox=stageBox}
local oldDestroy=UI.Destroy
UI.Destroy=function(self)
    ready=false
    if env.MoyPowerFruitToken==token then env.MoyPowerFruitToken=nil end
    -- Restore the original panel so any running functions can be managed manually.
    if tora and tora.Parent and tora:IsA("ScreenGui") then tora.Enabled=true end
    oldDestroy(self)
end
task.spawn(function()
    while env.MoyPowerFruitToken==token and UI.Root.Parent do
        if tora and tora.Parent then hide(tora) end
        task.wait(1)
    end
end)
