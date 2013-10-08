SWEP.Base					= "weapon_base";
SWEP.HoldType 				= "smg"; //How the weapon should be held
SWEP.ViewModel				= "models/weapons/v_smg1.mdl"; //How the gun looks in 1st person
SWEP.WorldModel				= "models/weapons/w_smg1.mdl"; //How the gun looks in 3rd person
SWEP.ViewModelFOV			= 80;
SWEP.ViewModelFlip			= true;
SWEP.PrintName				= "CoverSMG";

SWEP.Primary.Automatic		= true;
SWEP.Primary.Ammo			= "smg1";
SWEP.Primary.ClipSize		= 50;
SWEP.Primary.DefaultClip    = 50;

function SWEP:Initialize()
	self:SetDeploySpeed( 1.0 );
	self:SetWeaponHoldType( self.HoldType );
end

function SWEP:Precache()
end

function SWEP:Equip()
end

function SWEP:Deploy()
end

function SWEP:PrimaryAttack()
	if ( self.Owner:IsCovering() && !self.Owner:IsPeekingLeft() && !self.Owner:IsPeekingRight() ) then return; end
	
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
	self:ShootBullet( self.Owner );
	
	self:SetNextPrimaryFire( CurTime() + 0.08 );
end

function SWEP:ShootBullet( pl )
	local dmg = 30;
	local fSpread = 0.02;
	
	local pos = self.Owner:GetShootPos();
	if ( self.Owner:IsPeekingLeft() ) then
		pos = pos + (self.Owner:GetRight() * -20);
	elseif ( self.Owner:IsPeekingRight() ) then
		pos = pos + (self.Owner:GetRight() * 20);
	end
	
	local bullet = {}
		bullet.Num 		  = self.NumShots;
		bullet.Src 		  = pos;
		bullet.Dir 		  = self.Owner:GetAimVector();
		bullet.Spread 	  = Vector(fSpread, fSpread, 0);
		bullet.Tracer	  = 1;
		bullet.TracerName = TracerName;
		bullet.Force	  = dmg * 0.5;
		bullet.Damage	  = dmg;
		bullet.AmmoType   = self.Primary.Ammo;
		
	pl:FireBullets( bullet );
	
	self.Weapon:MuzzleFlash();
	
	self:TakePrimaryAmmo( 1 );
end

function SWEP:SecondaryAttack()
	return false;
end

function SWEP:Reload()
	self:DefaultReload( ACT_VM_RELOAD );
end