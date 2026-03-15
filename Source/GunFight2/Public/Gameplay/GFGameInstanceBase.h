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
	UPROPERTY(EditDefaultsOnly,BlueprintReadWrite,Category="Gameplay")
	FString Player1_Name = "Default";  // 玩家1姓名

	UPROPERTY(EditDefaultsOnly,BlueprintReadWrite,Category="Gameplay")
	FString Player2_Name = "Default";  // 玩家2姓名
	
	UPROPERTY(EditDefaultsOnly,BlueprintReadWrite,Category="Gameplay")
	int32 GameTime = 60;

	UFUNCTION(BlueprintCallable,Category="GameSystem")
	void CreateSystemTipUI(FString TipText);  // Lua中实现

	UFUNCTION(BlueprintCallable,Category="Player")
	void GetPlayerNameFromCSV();

	UFUNCTION(BlueprintCallable,Category="Player")
	void ClearCSV();


};
