// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Blueprint/UserWidget.h"
#include "PlayerMnueUI.generated.h"

/**
 * 
 */

class UButton;
class UEditableTextBox;

UCLASS()
class GUNFIGHT2_API UPlayerMnueUI : public UUserWidget
{
	GENERATED_BODY()
public:

	virtual void NativeConstruct() override;
	
	UPROPERTY(meta =(BindWidget))
	UEditableTextBox* TextBox_IpAddress;  // IP

	UPROPERTY(meta =(BindWidget))
	UEditableTextBox* TextBox_PlayerName;  // 玩家名
	
	UPROPERTY(meta =(BindWidget))
	UEditableTextBox* TextBox_GameTime;  // 游戏时长
	
	UPROPERTY(meta =(BindWidget))
	UButton* Button_Host;
	
	UPROPERTY(meta =(BindWidget))
	UButton* Button_Join;

	UPROPERTY(EditDefaultsOnly)
	TSoftObjectPtr<UWorld> HostingLevel;

	UFUNCTION()
	void HostButtonClicked();
	UFUNCTION()
	void JoinButtonClicked();

	UFUNCTION()
	void SavePlayerNameToCSV(const FString& PLayerName);
	
};
