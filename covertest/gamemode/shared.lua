Cover = {};

COVER_NONE = 0;
COVER_LEFT = 1;
COVER_RIGHT = 2;

GM.Name		 = "CoverTest";
GM.Author 	 = "Annoyed Tree";
GM.Website	 = "";
GM.Folder	 = "cover test"; //Do not edit this...

//Shared PLAYER functions
local meta = FindMetaTable( "Player" );
if ( !meta ) then return; end

function meta:IsLookingAtWall()
	local tr = util.QuickTrace( self:GetShootPos(), self:GetForward() * 24, self );
	if ( tr.HitWorld ) then
		return true;
	end
	return false;
end

function meta:CanCover()
	if ( !self:IsLookingAtWall() ) then return; end
	
	local yaws = { -180, -90, 0, 90, 180 };
	local offset = 16; //Allowed to deviate, so room to move around
	local ang = self:GetAngles();
	
	for i = 1, #yaws do
		local off_neg = yaws[i] - offset;
		local off_pos = yaws[i] + offset;
		
		if ( ang.y > off_neg && ang.y < off_pos ) then
			return true;
		end
	end
	return false;
end

function meta:CanCoverLeft()
	if ( !self:IsLookingAtWall() || !self:CanCover() ) then return; end
	
	local tr = util.QuickTrace( self:GetShootPos(), ((self:GetRight() * -32) + (self:GetForward() * 28)), self );
	if ( !tr.HitWorld ) then
		return true;
	end
	return false;
end

function meta:CanCoverRight()
	if ( !self:IsLookingAtWall() || !self:CanCover() ) then return; end
	
	local tr = util.QuickTrace( self:GetShootPos(), ((self:GetRight() * 32) + (self:GetForward() * 28)), self );
	if ( !tr.HitWorld ) then
		return true;
	end
	return false;
end

function meta:IsPeekingLeft()
	if ( !self.cover || self.cover.side <= 0 || !self:CanPeakLeft() ) then return; end
	
	if ( self:KeyDown( IN_MOVELEFT ) && self.cover.side == 1 ) then
		return true;
	end
	return false;
end

function meta:IsPeekingRight()
	if ( !self.cover || self.cover.side <= 0 || !self:CanPeakRight() ) then return; end
	
	if ( self:KeyDown( IN_MOVERIGHT ) && self.cover.side == 2 ) then
		return true;
	end
	return false;
end

function meta:IsCovering()
	if ( self.cover && self.cover.side > 0 ) then
		return true;
	end
	return false;
end

function meta:CanPeakLeft()
	if ( !self.cover || self.cover.side != 1 ) then return; end
	
	local ang = self:GetAngles();
	if ( ang.y < 0 ) then
		ang.y = ang.y * -1;
	end
	
	local cov_ang = self.cover.ang;
	if ( cov_ang < 0 ) then
		cov_ang = cov_ang * -1;
	end
	
	if ( ang.y > cov_ang-40 && ang.y < cov_ang+40 ) then
		return true;
	end
	return false;
end

function meta:CanPeakRight()
	if ( !self.cover || self.cover.side != 2 ) then return; end
	
	local ang = self:GetAngles();
	if ( ang.y < 0 ) then
		ang.y = ang.y * -1;
	end
	
	local cov_ang = self.cover.ang;
	if ( cov_ang < 0 ) then
		cov_ang = cov_ang * -1;
	end
	
	if ( ang.y > cov_ang-40 && ang.y < cov_ang+40 ) then
		return true;
	end
	return false;
end

if ( SERVER ) then
	function meta:PlayerTakeCover( bool )
		if ( bool ) then
			self:SetWalkSpeed( 1 );
			self:SetRunSpeed( 1 );
			self:TranslateModel( "humans" );
		else
			self:SetWalkSpeed( 180 );
			self:SetRunSpeed( 210 );
			self:TranslateModel( "player" );
		end
	end
	
	function meta:TranslateModel( str )
		local mdl = self:GetModel();
		
		if ( str == "player" ) then
			mdl = string.gsub( mdl, "models/humans", "models/player" );
		elseif ( str == "humans" ) then
			mdl = string.gsub( mdl, "models/player", "models/humans" );
		end
		
		if ( self:GetModel() == mdl ) then return; end
		self:SetModel( mdl );
	end
end
//Animations
local coveranim = {}
	coveranim[ "Cover_R" ] = "Cover_L";
	coveranim[ "Cover_L" ] = "Cover_R";
	coveranim[ "Cover_Low_R" ] = "CoverLow_L";
	coveranim[ "Cover_Low_L" ] = "CoverLow_R";
	coveranim[ "Cover_R_Peek" ] = "Cover_LToShootSMG1";
	coveranim[ "Cover_L_Peek" ] = "Cover_RToShootSMG1";
	coveranim[ "Cover_Low_R_Peek" ] = "CoverLow_LToShootSMG1";
	coveranim[ "Cover_Low_L_Peek" ] = "CoverLow_RToShootSMG1";
	
function GM:CalcMainActivity( ply )
	ply.CalcIdeal = ACT_MP_STAND_IDLE;
	ply.CalcSeqOverride = -1;
	
	if ( !IsValid( ply ) || !ply:Alive() ) then return ply.CalcIdeal, ply.CalcSeqOverride; end
	local velocity = ply:GetVelocity():Length() or 0;
	
	if( GAMEMODE:HandlePlayerJumping( ply, velocity ) ) then
	elseif( ply:Crouching() ) then
		
		if( velocity > 0.5 ) then
			ply.CalcIdeal = ACT_MP_CROUCHWALK;
		else
			ply.CalcIdeal = ACT_MP_CROUCH_IDLE;
		end
		
	else
		
		if( velocity > 150 ) then
			ply.CalcIdeal = ACT_MP_RUN;
		elseif( velocity > 0.5 ) then
			ply.CalcIdeal = ACT_MP_WALK;
		end
		
	end
	
	if ( ply:WaterLevel() == 2 || ply:WaterLevel() == 3 || ply:GetMoveType() == 8 ) then
		ply.CalcIdeal = ACT_MP_SWIM;
	end
	
	if ( !ply:IsCovering() ) then return ply.CalcIdeal, ply.CalcSeqOverride; end
	
	local str = "Cover_";
	
	if ( ply:Crouching() ) then
		str = str .. "Low_";
	end
	
	if ( ply.cover.side == 1 ) then //left cover
		str = str .. "L";
	elseif ( ply.cover.side == 2 ) then //right cover
		str = str .. "R";
	end
	
	if ( ply:IsPeekingLeft() || ply:IsPeekingRight() ) then
		str = str .. "_Peek"
	end
	
	str = coveranim[ str ];
	ply.CalcSeqOverride = ply:LookupSequence( str );
	
	if ( ply:GetSequence() != ply.CalcSeqOverride ) then
		ply:ResetSequence( ply.CalcSeqOverride );
		ply:SetPlaybackRate( 1.0 );
		ply:SetCycle( 0 );
	end
	
	return ply.CalcIdeal, ply.CalcSeqOverride;
end

function GM:UpdateAnimation( ply, vel )
	if ( !ply:Alive() ) then return; end
	
	local len = vel:Length2D();
	local movefactor = len / 600;
	ply:SetPoseParameter( "move_factor", movefactor );
	
	if ( ply:IsCovering() ) then
		ply:SetRenderAngles( Angle( 0, ply.cover.ang + 180, 0 ) );
	end
	
	if ( ply:IsPeekingLeft() || ply:IsPeekingRight() ) then
		local yaw = ply:GetAngles().y;
		yaw = yaw - 180;
		
		ply:SetRenderAngles( Angle( 0, yaw, 0 ) );
	end
end