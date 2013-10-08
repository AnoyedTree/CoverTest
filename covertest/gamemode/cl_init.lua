include( "shared.lua" );

//Thirdperson view
function GM:CalcView( ply, pos, ang, fov )
	local view = {};
    view.origin = pos;
    view.angles = angles;
    view.fov = fov;
	
	view.origin = view.origin + (ply:GetForward() * -60);
	view.origin = view.origin + (ply:GetUp() * 3);
	view.origin = view.origin + (ply:GetRight() * 15);
	
	if ( ply:IsPeekingLeft() ) then
		view.origin = view.origin + (ply:GetRight() * -38);
	elseif ( ply:IsPeekingRight() ) then
		view.origin = view.origin + (ply:GetRight() * 22);
	end
	
    return view
end

function GM:ShouldDrawLocalPlayer()
	return true;
end

//HUD
function GM:HUDPaint()
	local ply = LocalPlayer();
	local x = ScrW()/2;
	local y = ScrH()/2;
	
	local ang = ply:GetAngles();
	draw.DrawText( math.Round(ang.y), "Default", x, y * 1.83, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER );

	if ( ply:IsCovering() ) then
		if ( ply:IsPeekingLeft() || ply:IsPeekingRight() ) then
			draw.DrawText( "[PEEKING]", "Default", x, y * 1.80, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER );
		else
			draw.DrawText( "[IN COVER]", "Default", x, y * 1.80, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER );
		end
		return;	
	elseif ( ply:IsLookingAtWall() ) then
		draw.DrawText( "[E]", "Default", x, y * 1.80, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER );
		if ( ply:CanCoverLeft() ) then
			draw.DrawText( "<", "Default", x * 0.98, y * 1.80, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT );
		elseif ( ply:CanCoverRight() ) then
			draw.DrawText( ">", "Default", x * 1.02, y * 1.80, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT );
		end
	end
end

function GM:PlayerBindPress( ply, bind )
	if ( bind == "+jump" && ply:IsCovering() ) then
		return true;
	end
end

//Net Vars
net.Receive( "pl-Cover", function( len )
	local ply = net.ReadEntity();
	local tbl = net.ReadTable();
	
	ply.cover = tbl;
end );