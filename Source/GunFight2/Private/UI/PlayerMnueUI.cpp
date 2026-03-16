// Fill out your copyright notice in the Description page of Project Settings.


#include "UI/PlayerMnueUI.h"
#include "Misc/FileHelper.h"
#include "HAL/PlatformFilemanager.h"
#include "Components/Button.h"
#include "Components/EditableTextBox.h"
#include "Gameplay/GFGameInstanceBase.h"
#include "Kismet/GameplayStatics.h"

void UPlayerMnueUI::NativeConstruct()
{
	Super::NativeConstruct();
	
	FInputModeUIOnly InputMode;
	GetOwningPlayer()->SetInputMode(InputMode);
	GetOwningPlayer()->SetShowMouseCursor(true);

	
	Button_Host->OnClicked.AddDynamic(this,&ThisClass::HostButtonClicked);
	Button_Join->OnClicked.AddDynamic(this,&ThisClass::JoinButtonClicked);
}

void UPlayerMnueUI::HostButtonClicked()
{
	FInputModeGameOnly InputMode;
	GetOwningPlayer()->SetInputMode(InputMode);
	GetOwningPlayer()->SetShowMouseCursor(false);

	const FString PlayerName = TextBox_PlayerName->GetText().ToString();  // 获取玩家姓名
	UE_LOG(LogTemp,Error,TEXT("主机输入游戏姓名：%s"),*PlayerName);
	const FString TimeStr = TextBox_GameTime->GetText().ToString();  // 获取游戏时间
	int32 GameTime;
	LexFromString(GameTime, *TimeStr);

	UWorld* World = GetWorld();
	if (! World) return;
	UGFGameInstanceBase* GameInstance = Cast<UGFGameInstanceBase>(World->GetGameInstance());
	if (PlayerName == "")
	{
		GameInstance->Player_Name = "Default";
	}
	else
	{
		GameInstance->Player_Name = PlayerName;
		UE_LOG(LogTemp,Error,TEXT("主机加入游戏玩家姓名：%s"),*GameInstance->Player_Name);
	}
	if (GameTime == 0)
	{
		return;
	}
	GameInstance->GameTime = GameTime;
	
	// 创建主房间（监听服务器）
	UGameplayStatics::OpenLevelBySoftObjectPtr(this,HostingLevel,true,TEXT("listen"));
}


void UPlayerMnueUI::JoinButtonClicked()
{
	const FString Address = TextBox_IpAddress->GetText().ToString();
	// 加入主房间
	const FString PlayerName = TextBox_PlayerName->GetText().ToString();  // 获取玩家姓名
	UE_LOG(LogTemp,Error,TEXT("客户输入游戏姓名：%s"),*PlayerName);
	UWorld* World = GetWorld();
	if (! World) return;
	UGFGameInstanceBase* GameInstance = Cast<UGFGameInstanceBase>(World->GetGameInstance());

	if (PlayerName == "")
	{
		GameInstance->Player_Name = "Default";
	}
	else
	{
		GameInstance->Player_Name = PlayerName;
		UE_LOG(LogTemp,Error,TEXT("客户加入游戏玩家姓名：%s"),*GameInstance->Player_Name);
	}
	
	if (Address.IsEmpty()) return;
	UGameplayStatics::OpenLevel(this,*Address);
	
	FInputModeGameOnly InputMode;
	GetOwningPlayer()->SetInputMode(InputMode);
	GetOwningPlayer()->SetShowMouseCursor(false);
}







