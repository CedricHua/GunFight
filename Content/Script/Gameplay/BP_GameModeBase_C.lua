--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_GameModeBase_C
local M = UnLua.Class()

function M:K2_PostLogin(PlayerController)

    local co = coroutine.create(function()
        UE.UKismetSystemLibrary.Delay(self, 0.5)
        local Player = PlayerController:K2_GetPawn()
        print("Player加入游戏:",PlayerController:GetName())
        self.ArrPlayerState:Add(Player.PlayerState)
        -- 当玩家完全加入进来时
        if self.ArrPlayerState:Num() == 2 then

            local GS = UE.UGameplayStatics.GetGameState( self)
            GS:StartCountDown(30)  -- 通知GameState可以开始进行计时
            
            local ScoreboxManager = UE.UGameplayStatics.GetActorOfClass(self, UE.UClass.Load('/Game/BluePrints/Scene/ScoreBoxManager.ScoreBoxManager_C'))
            ScoreboxManager:StartSpawnBox()  -- 通知ScoreBoxManager开始生成初始时的ScoreBox
            
            Player:GameStart()
            -- 循环遍历PlayerState设置玩家名
            for i = 1, self.ArrPlayerState:Num() do
                local PS = self.ArrPlayerState:Get(i)
                if PS then
                    PS.P_Index = i  
                    PS.P_Name = string.format("PLAYER_%d", PS.P_Index)  
                    PS:SetPlayerName(PS.P_Index, PS.P_Name)
                end
            end
        end
    end)
    coroutine.resume(co)
end

function M:CallSetPlayerScore(PlayerIndex)
    local PS = self.ArrPlayerState:Get(PlayerIndex)
    local Score = math.random(5, 10)
    PS.P_Score = PS.P_Score + Score
    PS:SetPlayerScore(PlayerIndex, PS.P_Score)
end

-- 游戏结束时的结算
function M:CheckWinner()
    if self.ArrPlayerState:Get(1).P_Score > self.ArrPlayerState:Get(2).P_Score then
        return string.format("WINNER IS %s", self.ArrPlayerState:Get(1).P_Name)
    elseif self.ArrPlayerState:Get(1).P_Score < self.ArrPlayerState:Get(2).P_Score then
        return string.format("WINNER IS %s", self.ArrPlayerState:Get(2).P_Name)
    elseif self.ArrPlayerState:Get(1).P_Score == self.ArrPlayerState:Get(2).P_Score then
        return "NO WINNER"
    end
end

function M:CheckWinnerOnDie(PlayerIndex)
    local GS = UE.UGameplayStatics.GetGameState(self)
    UE.UKismetSystemLibrary.K2_ClearTimerHandle(GS, GS.TimerHandle) -- 清除定时器
    GS.TimerHandle = nil
    if PlayerIndex == 1 then
        return string.format("WINNER IS %s", self.ArrPlayerState:Get(2).P_Name)
    else
        return string.format("WINNER IS %s", self.ArrPlayerState:Get(1).P_Name)
    end
end

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

--function M:ReceiveBeginPlay()
--    
--end

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
