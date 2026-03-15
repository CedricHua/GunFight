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
        local GameInstance = UE.UGameplayStatics.GetGameInstance(self)
        local Player = PlayerController:K2_GetPawn()
        local PlayerCount = self.ArrPlayerState:Num()
        -- 调用函数加载玩家名
        GameInstance:GetPlayerNameFromCSV()
        -- 设置玩家名字
        if PlayerCount == 0 then
            print("Player1_Name:",GameInstance.Player1_Name)
            if GameInstance.Player1_Name ~= "Default" then
                Player.PlayerState.P_Name = GameInstance.Player1_Name
            else
                Player.PlayerState.P_Name = string.format("PLAYER_%d", Player.PlayerState.PlayerId)
            end
        else
            print("Player2_Name:",GameInstance.Player2_Name)
            if GameInstance.Player2_Name ~= "Default" then
                print("客户端设置玩家名：",GameInstance.Player2_Name)
                Player.PlayerState.P_Name = GameInstance.Player2_Name
            else
                Player.PlayerState.P_Name = string.format("PLAYER_%d", Player.PlayerState.PlayerId)
            end
        end
        
        -- 设置完成将其加入到数组
        self.ArrPlayerState:Add(Player.PlayerState)

        -- 检查玩家是否全部加入
        if self.ArrPlayerState:Num() == 2 then
            
            -- 循环遍历PlayerState设置玩家名
            for i = 1, self.ArrPlayerState:Num() do
                local PS = self.ArrPlayerState:Get(i)
                if PS then
                    PS.P_Index = i
                    --PS.P_Name = string.format("PLAYER_%d", PS.P_Index)  
                    print("Player:",i,"PlayerName",PS.P_Name)
                    PS:SetPlayerName(PS.P_Index, PS.P_Name)
                end
            end
            
            -- 通知GameState可以开始进行计时
            local GS = UE.UGameplayStatics.GetGameState( self)
            if GameInstance.GameTime == 0 then  
                GS:StartCountDown(60)
            else
                GS:StartCountDown(GameInstance.GameTime)
            end

            -- 获取并通知ScoreBoxManager开始生成初始时的ScoreBox
            local ScoreboxManager = UE.UGameplayStatics.GetActorOfClass(self, UE.UClass.Load('/Game/BluePrints/Scene/ScoreBoxManager.ScoreBoxManager_C'))
            ScoreboxManager:StartSpawnBox()  
            
            -- 通知Player游戏开始，可以移动
            Player:GameStart()
            
            -- 删除临时存储玩家名的csv
            GameInstance:ClearCSV()
        end
    end)
    coroutine.resume(co)
end


-- 设置玩家分数
function M:CallSetPlayerScore(PlayerIndex)
    local PS = self.ArrPlayerState:Get(PlayerIndex)
    local Score = math.random(5, 10)
    PS.P_Score = PS.P_Score + Score
    PS:SetPlayerScore(PlayerIndex, PS.P_Score)
end

-- 游戏结束时的结算
-- 通过玩家分数计算winner
function M:CheckWinner()
    if self.ArrPlayerState:Get(1).P_Score > self.ArrPlayerState:Get(2).P_Score then
        return string.format("WINNER IS %s", self.ArrPlayerState:Get(1).P_Name)
    elseif self.ArrPlayerState:Get(1).P_Score < self.ArrPlayerState:Get(2).P_Score then
        return string.format("WINNER IS %s", self.ArrPlayerState:Get(2).P_Name)
    elseif self.ArrPlayerState:Get(1).P_Score == self.ArrPlayerState:Get(2).P_Score then
        return "NO WINNER"
    end
end

-- 有玩家死亡后计算winner
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

-- function M:ReceiveBeginPlay() 
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
