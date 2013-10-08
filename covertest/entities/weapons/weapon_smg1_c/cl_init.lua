
include('shared.lua');

SWEP.Slot				= 0;
SWEP.SlotPos			= 0;
SWEP.DrawAmmo			= false;
SWEP.DrawCrosshair		= false;
SWEP.DrawWeaponInfoBox	= false;
SWEP.BounceWeaponIcon   = false;
SWEP.SwayScale			= 0.0;
SWEP.BobScale			= 0.3;
SWEP.RenderGroup 		= RENDERGROUP_OPAQUE;
SWEP.ViewModelFOV		= 80;

function SWEP:GetViewModelPosition( pos, ang )
	return pos, ang;
end

function SWEP:DrawHUD()
end

function SWEP:TranslateFOV( current_fov )
	return current_fov;
end

function SWEP:DrawWorldModel()
	self.Weapon:DrawModel();
end

function SWEP:DrawWorldModelTranslucent()
	self.Weapon:DrawModel();
end

function SWEP:AdjustMouseSensitivity()
	return nil;
end

function SWEP:GetTracerOrigin()
end