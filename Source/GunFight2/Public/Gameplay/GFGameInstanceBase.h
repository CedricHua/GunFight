// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Engine/GameInstance.h"
#include "GFGameInstanceBase.generated.h"

/**
 * 
 */
UCLASS()
class GUNFIGHT2_API UGFGameInstanceBase : public UGameInstance
{
	GENERATED_BODY()
	
public:
	UPROPERTY(EditDefaultsOnly,BlueprintReadWrite,Category="Gameplay",Replicated)
	FString Player_Name = "Default";  // 暂存玩家姓名
	
	UPROPERTY(EditDefaultsOnly,BlueprintReadWrite,Category="Gameplay")
	int32 GameTime = 60;

	UFUNCTION(BlueprintCallable,Category="GameSystem")
	void CreateSystemTipUI(FString TipText);  // Lua中实现
	// 网络复制设置，用于标记需要复制的变量
	virtual void GetLifetimeReplicatedProps(TArray<FLifetimeProperty>& OutLifetimeProps) const override;
};
