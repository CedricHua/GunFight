--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type ScoreBoxManager_C
local M = UnLua.Class()

function M:ReceiveBeginPlay()
    
end

function M:StartSpawnBox()
    -- 初始时生成三个ScoreBox，后续不再调用
    local i = 0
    local ScoreBoxLocationArray = self.ScoreBoxLocation
    local CheckLocationArray = self.CheckLocation
    while i < 3 do
        local RandIndex = UE.UKismetMathLibrary.RandomInteger(ScoreBoxLocationArray:Num())+1
        if not CheckLocationArray:Get(RandIndex) then
            local Location = ScoreBoxLocationArray:Get(RandIndex)
            local Success = self:SpawnScoreBox(RandIndex,Location)
            if Success then
                CheckLocationArray:Set(RandIndex,true)
                i = i + 1
            end
        end
    end
end

-- 找到销毁的ScoreBox位置，并将对应位置置为false
function M:FindIndexFromLocation(Location)
    for i = 1 , self.ScoreBoxLocation:Num() do
        local ScoreBoxLocation = self.ScoreBoxLocation:Get(i)
        if ScoreBoxLocation == Location then
            self.CheckLocation:Set(i,false)  -- 定位到坐标，将CheckLocation置为false
        end
    end
end

-- Manager接收ScoreBox的消息，并生成新的ScoreBox
function M:ScoreBoxToManager(Location)
    self:FindIndexFromLocation(Location)
    local ScoreBoxLocationArray = self.ScoreBoxLocation
    local CheckLocationArray = self.CheckLocation
    while true do
        local RandIndex = UE.UKismetMathLibrary.RandomInteger(ScoreBoxLocationArray:Num())+1
        if not CheckLocationArray:Get(RandIndex) then
            local Location = ScoreBoxLocationArray:Get(RandIndex)
            local Success = self:SpawnScoreBox(RandIndex,Location)
            if Success then
                CheckLocationArray:Set(RandIndex,true)
                break
            end
        end
    end
end

function M:SpawnScoreBox(index,Location)
    local World = self:GetWorld()
    if World then
        local ScoreBoxClass = UE.UClass.Load("/Game/BluePrints/Scene/ScoreBox.ScoreBox_C")
        local DefaultRotation = UE.FRotator(0, 0, 0)  -- 默认旋转
        local Transform = UE.FTransform(DefaultRotation, Location)
        local NewScoreBox = World:SpawnActor(ScoreBoxClass,Transform )  -- 传入位置和旋转
        if NewScoreBox then
            return true
        end
    end
    return false
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
