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
        self.RemainingTime = Duration
        print("启动计时器，倒计时：",Duration,"秒")
        -- 设置定时器，用于每秒更新客户端UI的倒计时
        self.TimerHandle = UE.UKismetSystemLibrary.K2_SetTimerDelegate({ self, self.OnTimeCountDown }, 1, true)
    end
end

function M:OnTimeCountDown()  -- 每秒调用更新倒计时
    self.RemainingTime = self.RemainingTime - 1
    self:TimeChange_Server_RPC(self.RemainingTime)
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
