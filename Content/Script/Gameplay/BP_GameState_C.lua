--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_GFGameState_C
local M = UnLua.Class()

function M:StartCountDown(Duration)
    if self:HasAuthority() then
        self.RemainingTime = Duration+1
        print("启动计时器，倒计时：",Duration,"秒")
        -- 设置定时器，用于每秒更新客户端UI的倒计时
        self.TimerHandle = UE.UKismetSystemLibrary.K2_SetTimerDelegate({ self, self.OnTimeCountDown }, 1, true)
    end
end

function M:OnTimeCountDown()  -- 每秒调用更新倒计时
    self.RemainingTime = self.RemainingTime - 1
    if self.RemainingTime <= 0 then
       
        -- 当倒计时结束时发送游戏结束通知
        self:TimeEnd_Server()
        
        UE.UKismetSystemLibrary.K2_ClearTimerHandle(self, self.TimerHandle) -- 清除定时器
        self.TimerHandle = nil
    else
        -- 倒计时未结束时发送时间改变的消息
        self:TimeChange_Server(self.RemainingTime)  
    end
end

function M:TimeChange_Server_RPC(RemainingTime)
    self:TimeChange_Multicast(RemainingTime)  -- 服务端转发消息
end

function M:TimeChange_Multicast_RPC(RemainingTime)  -- 所有客户端同步倒计时
    local PC = UE.UGameplayStatics.GetPlayerController(self,0)
    if PC then
        PC:UpDateUI(RemainingTime)
    end
end

-- 游戏结束
function M:TimeEnd_Server_RPC()
    local GM = UE.UGameplayStatics.GetGameMode(self)
    local Winner = GM:CheckWinner()
    self:TimerEnd_Multicast(Winner)  -- 由服务器进行组播
end

function M:TimerEnd_Multicast_RPC(Winner)
    -- 在所有客户端执行结算逻辑
    local widget_class = UE.UClass.Load('/Game/BluePrints/UMG/BP_GameOver.BP_GameOver_C')
    local widget_root = NewObject(widget_class, self)
    widget_root:AddToViewport()
    widget_root.Winner:SetText(Winner)
end

-- function M:ReceiveBeginPlay()
-- end

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
