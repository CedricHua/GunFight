// Fill out your copyright notice in the Description page of Project Settings.

#include "Gameplay/GFGameInstanceBase.h"

#include "Net/UnrealNetwork.h"


void UGFGameInstanceBase::CreateSystemTipUI(FString TipText)
{
}

void UGFGameInstanceBase::GetLifetimeReplicatedProps(TArray<FLifetimeProperty>& OutLifetimeProps) const
{
	Super::GetLifetimeReplicatedProps(OutLifetimeProps);
	DOREPLIFETIME(UGFGameInstanceBase,Player_Name);
}

