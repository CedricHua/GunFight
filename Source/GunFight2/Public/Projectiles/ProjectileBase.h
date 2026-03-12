// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "ProjectileBase.generated.h"

class USphereComponent;
class UProjectileMovementComponent;
UCLASS()
class GUNFIGHT2_API AProjectileBase : public AActor
{
	GENERATED_BODY()
	
public:	

	AProjectileBase();
	
	UPROPERTY(EditAnywhere, Category="Projectile")
	USphereComponent* CollisionComp;  // 球体碰撞组件
	
	UPROPERTY(EditAnywhere, BlueprintReadOnly, Category = "Movement", meta = (AllowPrivateAccess = "true"))
	UProjectileMovementComponent* ProjectileMovement;  // 抛体组件

	UPROPERTY(EditAnywhere,BlueprintReadWrite,Category="Player",Replicated)
	int32 Index = 0;  // 标记生成此Actor的玩家序号


protected:
	virtual void BeginPlay() override;
	virtual void GetLifetimeReplicatedProps(TArray<FLifetimeProperty>& OutLifetimeProps) const override;

};
