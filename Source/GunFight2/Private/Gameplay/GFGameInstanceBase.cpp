// Fill out your copyright notice in the Description page of Project Settings.

#include "Misc/FileHelper.h"
#include "HAL/PlatformFilemanager.h"
#include "Gameplay/GFGameInstanceBase.h"


void UGFGameInstanceBase::CreateSystemTipUI(FString TipText)
{
}

void UGFGameInstanceBase::GetPlayerNameFromCSV()
{
	// 目标CSV文件路径
	// 获取游戏的 Saved 目录路径
	FString SaveDirectory = FPaths::ProjectSavedDir(); 
	// 设置文件名
	const FString FileName = TEXT("GFPlayerName.csv");
	// 构建完整的文件路径
	FString FilePath = SaveDirectory / FileName;

	// 读取文件内容
	FString CsvContent;
	if (!FFileHelper::LoadFileToString(CsvContent, * FilePath))
	{
		UE_LOG(LogTemp, Error, TEXT("Failed to load CSV file: %s"), * FilePath);
		return;
	}

	// 分割CSV内容，根据换行符分割
	TArray<FString> Lines;
	CsvContent.ParseIntoArrayLines(Lines);

	// 确保有足够的行数来读取 Player1 和 Player2
	// 解析每一行，获取Player1和Player2名字
	if (Lines.Num() == 1)
	{
		Player1_Name = Lines[0].RightChop(11); 
	}
	else if (Lines.Num() == 2)
	{
		Player1_Name = Lines[0].RightChop(11); 
		Player2_Name = Lines[1].RightChop(11); 
	}
	UE_LOG(LogTemp, Warning, TEXT("Player1 Name: %s, Player2 Name: %s"), *Player1_Name, *Player2_Name);
}

void UGFGameInstanceBase::ClearCSV()
{
	// 目标CSV文件路径
	FString SaveDirectory = FPaths::ProjectSavedDir(); 
	// 设置文件名
	const FString FileName = TEXT("GFPlayerName.csv");
	// 构建完整的文件路径
	FString FilePath = SaveDirectory / FileName;
	// 获取文件管理器实例
	IFileManager& FileManager = IFileManager::Get();

	// 尝试删除文件
	if (FileManager.FileExists(*FilePath))
	{
		FileManager.Delete(*FilePath);  // 删除文件
		UE_LOG(LogTemp, Warning, TEXT("CSV file deleted successfully: %s"), *FilePath);
	}
	else
	{
		UE_LOG(LogTemp, Error, TEXT("File does not exist: %s"), *FilePath);
	}
}
