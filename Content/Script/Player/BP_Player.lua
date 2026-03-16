--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_Player_C
local M = UnLua.Class()
local Screen = require("Screen")
function M:ReceiveBeginPlay()
    -- 先锁定玩家控制器
    local PC = UE.UGameplayStatics.GetPlayerController(self,0)
    UE.UWidgetBlueprintLibrary.SetInputMode_UIOnlyEx(PC)
    self:ClientGetPlayerName()
end
function M:ClientGetPlayerName_RPC()
    local GI = UE.UGameplayStatics.GetGameInstance(self)
    local msg = string.format("当前PlayerName：%s",GI.Player_Name)
    Screen.Print(msg)
    self:ServerSetPlayerName(GI.Player_Name)
end

function M:ServerSetPlayerName_RPC(PlayerName)
    self.PlayerState.P_Name = PlayerName
end

function M:GameStart_RPC()
    -- 解除锁定玩家控制器
    local PC = UE.UGameplayStatics.GetPlayerController(self,0)
    UE.UWidgetBlueprintLibrary.SetInputMode_GameOnly(PC)
end

function M:ReceivePossessed()
    self.HPChangeEvent:Add(self,self.OnHPChanged)  -- 绑定血量变化事件
end

-- 血量变化事件
function M:OnHPChanged(NewHP)
    print("PlayerIndex",self.PlayerState.P_Index,"NewHP:",NewHP)
    self:HPChange_Server(NewHP)  -- 血量变化，向服务器发送消息更新UI
    if NewHP <= 0 then
        self:PlayerDie_Server(self.PlayerState.P_Index)
    end
end

function M:PlayerDie_Server_RPC(PlayerIndex)
    local GM = UE.UGameplayStatics.GetGameMode(self)
    local Winner = GM:CheckWinnerOnDie(PlayerIndex)
    self:PlayerDie_Multicast(Winner)
end

function M:PlayerDie_Multicast_RPC(Winner)
    print(Winner)
    -- 在所有客户端执行结算逻辑
    local widget_class = UE.UClass.Load('/Game/BluePrints/UMG/BP_GameOver.BP_GameOver_C')
    local widget_root = NewObject(widget_class, self)
    widget_root:AddToViewport()
    widget_root.Winner:SetText(Winner)
end
function M:HPChange_Server_RPC(NewHP)
    self:UpdatePlayerBar(NewHP)  -- 服务器收到消息，向所有客户端广播
end

function M:UpdatePlayerBar_RPC(NewHP)  -- 在所有客户端执行更新UI操作
    local MaxHP = self.MyAS.Max_HP.CurrentValue
    local PC = UE.UGameplayStatics.GetPlayerController(self,0)
    if PC then
        PC:UpDateUI_PlayerHPBar(self.PlayerState.P_Index,NewHP,MaxHP)
    end
end

-- 来自GA_Fire调用
-- 客户端执行播放蒙太奇
function M:PlayMontage_RPC()
    print("进入播放动画")
    local AnimInstance = self.FP_SkeletalMesh:GetAnimInstance()  -- 确保 Mesh 上有有效的 AnimInstance
    if AnimInstance then
        local MontageToPlay = UE.LoadObject('/Game/BluePrints/Player/Fire_Montage.Fire_Montage')
        if MontageToPlay then
            -- 播放蒙太奇
            AnimInstance:Montage_Play(MontageToPlay, 1.0, UE.EMontagePlayReturnType.MontageLength, 0.0, true)
            local Index = self.PlayerState.P_Index
            local trans = self.FP_MuzzleLocation:K2_GetComponentToWorld()
            self:ServerSpawnBullet(self,Index,trans)
        end
    end
end

-- 服务器执行生成子弹
function M:ServerSpawnBullet_RPC(Player,PlayerIndex,Transform)
    if self:HasAuthority() then
        print("当前子弹生成者序号：",PlayerIndex)
        if Player then
            -- 发射物部分
            local BulletClass = Player.ProjectileClass
            if BulletClass then
                local World = Player:GetWorld()
                if World then
                    -- 使用传递的 Transform 生成子弹
                    local Bullet =  World:SpawnActor(BulletClass, Transform)
                    Bullet.Index = PlayerIndex
                end
            end
        end
    end
end

-- 来自子弹碰撞事件接口
function M:OnHitByBullet(BulletIndex)
    local GEClass = UE.UClass.Load('/Game/GAS/PlayerAbility/GE_Bullet_Damage.GE_Bullet_Damage_C')
    self:ServerApplyGE(GEClass,BulletIndex)
end

function M:ServerApplyGE_RPC(GEClass,BulletIndex)
    -- 保证在服务端，并且子弹与碰撞玩家非自己才可继续执行应用GE
    if self:HasAuthority() and BulletIndex ~= self.PlayerState.P_Index then
        self.MyASC:ApplyGEToPlayer(GEClass)
    end
end


-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end




-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return M
