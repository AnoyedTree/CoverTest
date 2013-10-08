AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include( "shared.lua" );

util.AddNetworkString( "pl-Cover" );

function GM:PlayerInitialSpawn( ply )
	ply.cover = {};
		ply.cover.side = 0; //1 = left, 2 = right, 0 = nil
		ply.cover.ang = 0; //saves the angle when player presses "E"
end

function GM:PlayerSpawn( ply )
	ply:SetModel( "models/player/Group03/male_0" .. math.random( 1, 9 ) .. ".mdl" );
	ply:Give( "weapon_smg1_c" );
	ply:GiveAmmo( 800, "smg1" );
end

function GM:KeyPress( ply, key )
	if ( key == IN_USE ) then
		if ( ply.cover.side <= 0 && ply:IsLookingAtWall() ) then
			if ( ply:CanCoverLeft() ) then
				ply.cover.side = 1;
				ply.cover.ang = (ply:GetAngles().y);
				net.Start( "pl-Cover" );
					net.WriteEntity( ply );
					net.WriteTable( ply.cover );
				net.Broadcast();
				ply:PlayerTakeCover( true );
			elseif ( ply:CanCoverRight() ) then
				ply.cover.side = 2;
				ply.cover.ang = (ply:GetAngles().y);
				net.Start( "pl-Cover" );
					net.WriteEntity( ply );
					net.WriteTable( ply.cover );
				net.Broadcast();
				ply:PlayerTakeCover( true );
			end
		elseif ( ply.cover.side > 0 ) then
			ply:PlayerTakeCover( false );
			ply.cover.side = 0;
			ply.cover.ang = 0;
			net.Start( "pl-Cover" );
				net.WriteEntity( ply );
				net.WriteTable( ply.cover );
			net.Broadcast();
		end
	end
end