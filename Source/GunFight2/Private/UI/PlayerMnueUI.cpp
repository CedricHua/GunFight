// Fill out your copyright notice in the Description page of Project Settings.


#include "UI/PlayerMnueUI.h"
#include "Components/Button.h"
#include "Components/EditableTextBox.h"
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

	// 创建主房间（监听服务器）
	UGameplayStatics::OpenLevelBySoftObjectPtr(this,HostingLevel,true,TEXT("listen"));
}

void UPlayerMnueUI::JoinButtonClicked()
{
	const FString Address = TextBox_IpAddress->GetText().ToString();
	// 加入主房间
	if (Address.IsEmpty()) return;
	UGameplayStatics::OpenLevel(this,*Address);
	
	FInputModeGameOnly InputMode;
	GetOwningPlayer()->SetInputMode(InputMode);
	GetOwningPlayer()->SetShowMouseCursor(false);
}
