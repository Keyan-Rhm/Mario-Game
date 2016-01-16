%import GUI
import GUI
%Page Changer
var PageChange : int := 1
%%%%%%%%%%TITLE PAGE%%%%%%%%%%%%
setscreen ("graphics:1011;640")
View.Set ("offscreenonly")
%%%%%%%%Music for the game%%%%%%%%%%%
process playsong
    %Repeatedly plays the song
    Music.PlayFileLoop ("mariosong.mp3")
end playsong
%Plays the song
%fork playsong
%%%%%%%End of music%%%%%%%%%%%%%%
%%%%%%%%%%Character widths, Mario
var CharacterWidth : int := 30
var CharacterHeight : int := 30
%%%%%%%%%%%Character widths, Luigi
var CharacterWidth2 : int := 30
var CharacterHeight2 : int := 30

%%%%%%%%%MARIO VARIABLES
var MarioStars : int := 0
var Mario : int := Pic.FileNew ("Mario.jpg")
var MarioReverse : int := Pic.Mirror (Mario)
var Mx : int := 0
var My : int := 53
%resizing a picture, Mario
var LuigiStars : int := 0
var z := Pic.Scale (Mario, CharacterWidth, CharacterHeight)
var z2 := Pic.Scale (MarioReverse, CharacterWidth, CharacterHeight)
var PictureM : int := z
var key : array char of boolean

%%%%%%%%%%%%%%%%%%LUIGI VARIABLES
var Luigi : int := Pic.FileNew ("Luigi.jpg")
var LuigiReverse : int := Pic.Mirror (Luigi)
var Lx : int := maxx - CharacterWidth2
var Ly : int := 53

%%%%%%%%%%%%%%%%%%resizing a picture, Luigi
var l := Pic.Scale (Luigi, CharacterWidth2, CharacterHeight2)
var l2 := Pic.Scale (LuigiReverse, CharacterWidth2, CharacterHeight2)
var PictureL : int := l

%%%%%%%%%%%%%%%%%%%%%MAP VARIABLES
var Map : int := Pic.FileNew ("WholeBackground.jpg")
var Goomba : int := Pic.FileNew ("Goomba.jpg")
var GoombaX : int := maxx div 2
var ground : int := My
var GoombaY : int := ground
var GoombaHeight : int := 50 %%Still 50
var GoombaWidth : int := 50 %%Still 50
var z3 := Pic.Scale (Goomba, GoombaHeight, GoombaWidth)
var BrickFile : int := Pic.FileNew ("brick.jpg")
var SecretBox : int := Pic.FileNew ("box.jpg")
var Star : int := Pic.FileNew ("star.jpg")
var BoxWidth : int := 55
var brick := Pic.Scale (BrickFile, BoxWidth, BoxWidth)
var mystery := Pic.Scale (SecretBox, BoxWidth, BoxWidth)
var chars : array char of boolean
var MapScale := Pic.Scale (Map, maxx, maxy)
var StarScale := Pic.Scale (Star, 40, 40)


%OPENS ANY PIC TO FULL SCREEN
procedure OpeningPicture (picture : int)
    % Sets background image size, and place image/ reloads image for backgorund
    var width : int := Pic.Width (picture)
    var height : int := Pic.Height (picture)
    var xb, yb : int := 0
    %basically we keep posting larger and larger jpegs
    %until it fits the screen
    loop
	exit when yb > maxy
	loop
	    exit when xb > maxx
	    Pic.Draw (picture, xb, yb, picCopy)
	    xb := xb + width
	end loop
	xb := 0
	yb := yb + height
    end loop
end OpeningPicture
%Drawing Mario
procedure DrawMario (PictureM, Mx, My : int)
    %draws the picture
    Pic.Draw (PictureM, Mx, My, picMerge)
end DrawMario

%Drawing Luigi
procedure DrawLuigi (PictureM, Mx, My : int)
    %draws the picture
    Pic.Draw (PictureM, Mx, My, picMerge)
end DrawLuigi

%Drawing the goomba
procedure DrawGoomba (PictureM, GoombaX, GoombaY : int)
    %draws the picture
    Pic.Draw (z3, GoombaX, GoombaY, picMerge)
    delay (1)
end DrawGoomba

%%%%%%%%%%X and Y for star spawn
var a : int := 0
var b : int := 0

%Procedure which randomly places the star
proc StarSpawn (x : int)
    %Variable for random number
    var r : int
    var XLoc : array 1 .. 5 of int := init (595, 700, 185, 375, 0)
    var YLoc : array 1 .. 5 of int := init (252, 421, 272, 401, 485)
    var xlocation, ylocation : int
    xlocation := XLoc (x)
    ylocation := YLoc (x)
    a := xlocation
    b := ylocation
    Pic.Draw (StarScale, xlocation, ylocation, picMerge)
end StarSpawn

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%VARIABLES FOR MOVEMENT, MARIO
var CurrHeight : int := My
var JumpHeight : int := CurrHeight
var MaxJump : int := CurrHeight + 250
var JumpDelay : int := 0
var JumpDelayChange : int := CurrHeight + 237
var JumpLeft : int := 1
var JumpRight : int := 1

%%%%%%%%%%%%%%%Luigi Variables
var CurrHeight2 : int := Ly
var JumpHeight2 : int := CurrHeight2
var MaxJump2 : int := CurrHeight2 + 250
var JumpDelay2 : int := 0
var JumpDelayChange2 : int := CurrHeight2 + 237
var JumpLeft2 : int := 1
var JumpRight2 : int := 1

%The function that detects borders
%%%%%%%%%%MARIO BORDERS

function borders (Mx, CurrHeight : int) : boolean
    %Bottom left border
    if Mx + 30 >= 158 and Mx <= 296 and CurrHeight + 30 >= 224 and CurrHeight <= 271 then
	result true
	%Bottom right border
    elsif Mx + 30 >= 548 and Mx <= 687 and CurrHeight + 30 >= 204 and CurrHeight <= 251 then
	result true
	%Top right border
    elsif Mx + 30 >= 674 and Mx <= 812 and CurrHeight + 30 >= 372 and CurrHeight <= 420 then
	result true
	%Middle right border
    elsif Mx + 30 >= 378 and Mx <= 471 and CurrHeight + 30 >= 353 and CurrHeight <= 400 then
	result true
	%Top left border
    elsif Mx + 30 >= 0 and Mx <= 136 and CurrHeight + 30 >= 438 and CurrHeight <= 484 then
	result true
	%The mystery box
    elsif Mx + 30 >= maxx div 2 - 104 and Mx <= maxx div 2 - 55 and CurrHeight + 30 >= maxy - 115 and CurrHeight <= maxy - 67 then
	result true
    else
	result false
    end if
end borders

function top (Mx, CurrHeight : int) : boolean
    %Bottom left border
    if Mx + 30 >= 159 and Mx <= 295 and CurrHeight >= 271 and CurrHeight <= 272 then
	result true
	%Bottom right border
    elsif Mx + 30 >= 549 and Mx <= 686 and CurrHeight >= 251 and CurrHeight <= 254 then
	result true
	%Top right border
    elsif Mx + 30 >= 674 and Mx <= 813 and CurrHeight >= 419 and CurrHeight <= 422 then
	result true
	%Middle right border
    elsif Mx + 30 >= 378 and Mx <= 472 and CurrHeight >= 399 and CurrHeight <= 401 then
	result true
	%Top left border
    elsif Mx + 30 >= 0 and Mx <= 137 and CurrHeight >= 483 and CurrHeight <= 485 then
	result true
	%The mystery box
    elsif Mx + 30 >= maxx div 2 - 103 and Mx <= maxx div 2 - 56 and CurrHeight >= maxy - 68 and CurrHeight <= maxy - 64 then
	result true
    else
	result false
    end if
end top
%%%%%%%%%%%%%%%%%LUIGI BORDERS%%%%%%%%%%%%%%%%%%%%
function borders2 (Lx, CurrHeight2 : int) : boolean
    %Bottom left border
    if Lx + 30 >= 158 and Lx <= 296 and CurrHeight2 + 30 >= 224 and CurrHeight2 <= 271 then
	result true
	%Bottom right border
    elsif Lx + 30 >= 548 and Lx <= 687 and CurrHeight2 + 30 >= 204 and CurrHeight2 <= 251 then
	result true
	%Top right border
    elsif Lx + 30 >= 674 and Lx <= 812 and CurrHeight2 + 30 >= 372 and CurrHeight2 <= 420 then
	result true
	%Middle right border
    elsif Lx + 30 >= 378 and Lx <= 471 and CurrHeight2 + 30 >= 353 and CurrHeight2 <= 400 then
	result true
	%Top left border
    elsif Lx + 30 >= 0 and Lx <= 136 and CurrHeight2 + 30 >= 438 and CurrHeight2 <= 484 then
	result true
	%The mystery box
    elsif Lx + 30 >= maxx div 2 - 104 and Lx <= maxx div 2 - 55 and CurrHeight2 + 30 >= maxy - 115 and CurrHeight2 <= maxy - 67 then
	result true
    else
	result false
    end if
end borders2

function top2 (Lx, CurrHeight2 : int) : boolean
    %Bottom left border
    if Lx + 30 >= 159 and Lx <= 295 and CurrHeight2 >= 271 and CurrHeight2 <= 272 then
	result true
	%Bottom right border
    elsif Lx + 30 >= 549 and Lx <= 686 and CurrHeight2 >= 251 and CurrHeight2 <= 254 then
	result true
	%Top right border
    elsif Lx + 30 >= 674 and Lx <= 813 and CurrHeight2 >= 419 and CurrHeight2 <= 422 then
	result true
	%Middle right border
    elsif Lx + 30 >= 378 and Lx <= 472 and CurrHeight2 >= 399 and CurrHeight2 <= 401 then
	result true
	%Top left border
    elsif Lx + 30 >= 0 and Lx <= 137 and CurrHeight2 >= 483 and CurrHeight2 <= 485 then
	result true
	%The mystery box
    elsif Lx + 30 >= maxx div 2 - 103 and Lx <= maxx div 2 - 56 and CurrHeight2 >= maxy - 68 and CurrHeight2 <= maxy - 64 then
	result true
    else
	result false
    end if
end top2



%%%%%%%%%%%%%%%%%%VARIABLES FOR STAR SPAWN
var StarAppear : boolean := false
var r : int := 0
var x : int := 0

%Detects collsion for mario and a star
proc StarCollision
    var StarCol : boolean := false
    %If the locations match, collision does occur
    if Mx + 30 >= a and Mx <= a + 40 and CurrHeight + 30 >= b and CurrHeight + 30 <= b + 40 then
	StarCol := true
	if StarCol = true and StarAppear = true
		then
	    MarioStars := MarioStars + 1
	end if
	%If it's true erase the star
	if StarCol = true then
	    StarAppear := false
	end if
    else
	StarCol := false
    end if
    % if StarCol = true then
    % MarioStars += 1
    % end if
end StarCollision

%Detects Collision for Luigi and a star
proc StarCollision2
    var StarCol2 : boolean := false
    %If the locations match, collision does occur
    if Lx + 30 >= a and Lx <= a + 40 and CurrHeight2 >= b and CurrHeight2 <= b + 40 then
	StarCol2 := true
	if StarCol2 = true and StarAppear = true
		then
	    LuigiStars := LuigiStars + 1
	end if
	%If it's true erase the star
	if StarCol2 = true then
	    StarAppear := false
	end if
    else
	StarCol2 := false
    end if
end StarCollision2

%to see if we need to spawn a star
proc CheckStarSpawn
    if StarAppear = false then
	randint (r, 1, 500)
	randint (x, 1, 5)
    end if
    if r = 5 then
	StarAppear := true
	%delay (3000)
    else
	StarAppear := false
    end if
    if StarAppear = true then
	StarSpawn (x)
    end if
end CheckStarSpawn

%%%%%%%%%%%%%BOOLEAN VARIABLES
var MarioGoingUp : boolean := false
var MarioGoingDown : boolean := false
var LuigiGoingUp : boolean := false
var LuigiGoingDown : boolean := false
var MysteryOrBrick : boolean := true

%Draws Background
proc DrawBack
    %background
    Pic.Draw (Map, 0, 0, 0)
    %Mystery box, top centre
    if MysteryOrBrick = true then
	Pic.Draw (mystery, maxx div 2 - 110, maxy - 120, picMerge)
    else
	Pic.Draw (brick, maxx div 2 - 110, maxy - 120, picMerge)
    end if
end DrawBack

%%%%%%%%%%%%%%%%%%%%%GOOMBA MOVEMENTS%%%%%%%%%%%%%%%%%%%%%%%
var Movement : int := 3
var MarioGoombaCollision : boolean := false
var LuigiGoombaCollision : boolean := false
var MarioTaken : boolean := false
var LuigiTaken : boolean := false

%Making the Goomba Move
proc GoombaMovements
    if GoombaX + 30 + 1 >= maxx or GoombaX <= 0 then %%%%% Changed to 30, changing goombawidth would squish everything. Let's give it a run
	Movement *= -1
    end if
    GoombaX += Movement
end GoombaMovements
%Recognizing Mario gets hit by Goomba (-1 star)
proc MarioGoomba (Mx, CurrHeight, GoombaX : int)
    if Mx + 30 >= GoombaX and Mx + CharacterHeight <= GoombaX + 30 and GoombaY = CurrHeight and MarioTaken = false and MarioStars > 0 then
	% MarioGoombaCollision := true
	%if MarioGoombaCollision = true and MarioStars > 0 then
	MarioStars -= 1
	MarioTaken := true
	%end if
    elsif Mx + 30 < GoombaX or Mx + CharacterHeight > GoombaX + 30 then
	MarioTaken := false
    end if
end MarioGoomba
%Recognizign Luigi gets hti by the Goomba(-1 star)
proc LuigiGoomba (Lx, CurrHeight2, GoombaX : int)
    if Lx + 30 >= GoombaX and Lx + CharacterHeight <= GoombaX + 30 and GoombaY = CurrHeight2 and LuigiTaken = false and LuigiStars > 0 then
	% LuigiGoombaCollision := true
	% if LuigiGoombaCollision = true and LuigiTaken = false and LuigiStars > 0 then
	LuigiStars -= 1
	LuigiTaken := true
	% end if
    elsif Lx + 30 < GoombaX or Lx + CharacterHeight > GoombaX + 30 then
	LuigiTaken := false
    end if
end LuigiGoomba
%%%%%%%%%%%%%%%%%%%%%%%%%%%END GOOMBA MOVEMENTS%%%%%%%%%%%

%%%%%%%%%%%LUIGI MOVEMENTS START HERE
%Luigi moving right in the air
proc LuigiRightAir
    if key ('d') and Lx + JumpRight2 + CharacterWidth2 <= maxx and borders2 (Lx + JumpRight2, CurrHeight2) = false then
	Lx := Lx + JumpRight2
	PictureL := l
	delay (JumpDelay2)
    end if
end LuigiRightAir

%Luigi movng left in the air
proc LuigiLeftAir
    if key ('a') and Lx - JumpLeft2 >= 0 and borders2 (Lx - JumpLeft2, CurrHeight2) = false then
	Lx := Lx - JumpLeft2
	PictureL := l2
	delay (JumpDelay2)
    end if
end LuigiLeftAir

%Luigi going up
proc LuigiJumpUp
    if CurrHeight2 > JumpDelayChange2 then
	if borders2 (Lx, CurrHeight2 + 1) = false then
	    CurrHeight2 := CurrHeight2 + 1
	    delay (JumpDelay2)
	else
	    LuigiGoingUp := false
	    LuigiGoingDown := true
	end if
    else
	if borders2 (Lx, CurrHeight2 + 3) = false then
	    CurrHeight2 := CurrHeight2 + 3
	    delay (JumpDelay2)
	else
	    LuigiGoingUp := false
	    LuigiGoingDown := true
	end if
    end if
end LuigiJumpUp

%Luigi coming down
proc LuigiJumpDown
    if CurrHeight2 > JumpDelayChange2 then
	if borders2 (Lx, CurrHeight2 - 1) = false then
	    CurrHeight2 := CurrHeight2 - 1
	    delay (JumpDelay2)
	end if
    else
	if borders2 (Lx, CurrHeight2 - 3) = false then
	    CurrHeight2 := CurrHeight2 - 3
	    delay (JumpDelay2)
	end if
    end if
end LuigiJumpDown

%Adjusting luigi's jump
proc LuigiAdjustJump
    MaxJump2 := CurrHeight2 + 250
    JumpDelayChange2 := CurrHeight2 + 237
end LuigiAdjustJump

%Luigi moving right
proc LuigiMoveRight
    if key ('d') and Lx + CharacterWidth2 + 2 <= maxx then
	Lx := Lx + 2
	PictureL := l
    end if
end LuigiMoveRight

%Luigi moving left
proc LuigiMoveLeft
    if key ('a') and Lx - 2 >= 0 then
	Lx := Lx - 2
	PictureL := l2
    end if
end LuigiMoveLeft

%%%%%%%%%%%%%END LUIGI MOVEMENTS
%%%%%%%%%%%MARIO MOVEMENTS START HERE
%Mario moving right in the air
proc MarioRightAir
    if chars (KEY_RIGHT_ARROW) and Mx + JumpRight + CharacterWidth <= maxx and borders (Mx + JumpRight, CurrHeight) = false then
	Mx := Mx + JumpRight
	PictureM := z
	delay (JumpDelay)
    end if
end MarioRightAir

%Mario moving left in the air
proc MarioLeftAir
    if chars (KEY_LEFT_ARROW) and Mx - JumpLeft >= 0 and borders (Mx - JumpLeft, CurrHeight) = false then
	Mx := Mx - JumpLeft
	PictureM := z2
	delay (JumpDelay)
    end if
end MarioLeftAir

%Mario jumping up
proc MarioJumpUp
    if CurrHeight > JumpDelayChange then
	if borders (Mx, CurrHeight + 1) = false then
	    CurrHeight := CurrHeight + 1
	    delay (JumpDelay)
	else
	    MarioGoingUp := false
	    MarioGoingDown := true
	end if
    else
	if borders (Mx, CurrHeight + 3) = false then
	    CurrHeight := CurrHeight + 3
	    delay (JumpDelay)
	else
	    MarioGoingUp := false
	    MarioGoingDown := true
	end if
    end if
end MarioJumpUp

%Mario coming down
proc MarioJumpDown
    if CurrHeight > JumpDelayChange then
	if borders (Mx, CurrHeight - 1) = false then
	    CurrHeight := CurrHeight - 1
	    delay (JumpDelay)
	end if
    else
	if borders (Mx, CurrHeight - 3) = false then
	    CurrHeight := CurrHeight - 3
	    delay (JumpDelay)
	end if
    end if
end MarioJumpDown

%Mario jump adjust
proc MarioAdjustJump
    MaxJump := CurrHeight + 250
    JumpDelayChange := CurrHeight + 237
end MarioAdjustJump

%Mario Moving right
proc MarioMoveRight
    if chars (KEY_RIGHT_ARROW) and Mx + CharacterWidth + 2 <= maxx then
	Mx := Mx + 2
	PictureM := z
    end if
end MarioMoveRight

%Mario moving left
proc MarioMoveLeft
    if chars (KEY_LEFT_ARROW) and Mx - 2 >= 0 then
	Mx := Mx - 2
	PictureM := z2
    end if
end MarioMoveLeft
%%%%%%%%%%%%END MARIO MOVEMENTS
%%%%%%%%%%%%%%%%%%MARIO AND LUIGI COLLISIONS%%%%%%%%%%%%%%
var LuigiKO : boolean := false
proc CharacterCollision (Lx, CurrHeight2, Mx, CurrHeight : int)
    if Lx + 30 >= Mx and Lx + CharacterHeight <= Mx + 30 and CurrHeight > CurrHeight2 and CurrHeight < CurrHeight2 + 30 and LuigiKO = false and LuigiStars > 0 and LuigiGoingDown = true
	    then
	% LuigiGoombaCollision := true
	% if LuigiGoombaCollision = true and LuigiTaken = false and LuigiStars > 0 then
	LuigiStars -= 1
	LuigiKO := true
	% end if
    elsif Lx + 30 < Mx or Lx + CharacterHeight > Mx + 30 or CurrHeight < CurrHeight2 or CurrHeight > CurrHeight2 + 30 then
	LuigiKO := false
    end if
end CharacterCollision

var MarioKO : boolean := false
proc CharacterCollision2 (Lx, CurrHeight2, Mx, CurrHeight : int)
    if Mx + 30 >= Lx and Mx + CharacterHeight <= Lx + 30 and CurrHeight2 > CurrHeight and CurrHeight2 < CurrHeight + 30 and MarioKO = false and MarioStars > 0 and MarioGoingDown = true
	    then
	% LuigiGoombaCollision := true
	% if LuigiGoombaCollision = true and LuigiTaken = false and LuigiStars > 0 then
	MarioStars -= 1
	MarioKO := true
	% end if
    elsif Mx + 30 < Lx or Mx + CharacterHeight > Lx + 30 or CurrHeight2 < CurrHeight or CurrHeight2 > CurrHeight + 30 then
	MarioKO := false
    end if
end CharacterCollision2
loop
    %Activate goomba stuff
    CharacterCollision (Lx, CurrHeight2, Mx, CurrHeight)
    CharacterCollision2 (Lx, CurrHeight2, Mx, CurrHeight)
    GoombaMovements
    MarioGoomba (Mx, CurrHeight, GoombaX)
    LuigiGoomba (Lx, CurrHeight2, GoombaX)
    locate (1, 1)
    put "Luigi stars:", LuigiStars
    locate (2, 1)
    put "Mario Stars:", MarioStars

    %%%%%%%%%%%%%%%%% MARIO MOVING %%%%%%%%%%%%%%%%
    %Avoids glitchiness
    View.Update
    Input.KeyDown (chars)
    if chars (KEY_UP_ARROW) and CurrHeight + CharacterWidth + 2 <= maxy and CurrHeight not= MaxJump and MarioGoingDown not= true then
	MarioGoingUp := true
    end if
    %Mario coming down
    if CurrHeight + CharacterWidth + 2 > maxy or CurrHeight = MaxJump then
	MarioGoingUp := false
	MarioGoingDown := true
    end if
    %If Mario is on the ground
    if CurrHeight = ground then
	MarioGoingDown := false
    end if

    %Mario jumping
    if chars (KEY_UP_ARROW) and top (Mx, CurrHeight) = true then
	MarioGoingUp := true
	MarioGoingDown := false
    end if
    %What happens during mario's jump
    if MarioGoingUp = true then
	MarioJumpUp
	MarioRightAir
	MarioLeftAir
    end if
    %What happens when amrio comes down
    if MarioGoingDown = true then
	%Activate some procedures
	MarioJumpDown
	MarioRightAir
	MarioLeftAir
    end if
    DrawBack
    if CurrHeight <= ground or borders (Mx, CurrHeight) = true then
	%Mario moving right
	MarioMoveRight
	%Mario moving left
	MarioMoveLeft
    end if

    %%%%%%%%%END OF MARIO MOVING%%%%%%%%%%%

    %%%%%%%%%%%%%%%LUIGI MOVEMENTS%%%%%%%%%%%%%%
    Input.KeyDown (key)
    %Luigi going up
    if key ('w') and CurrHeight2 + CharacterWidth2 + 2 <= maxy and CurrHeight2 not= MaxJump2 and LuigiGoingDown not= true then
	LuigiGoingUp := true
    end if
    %Luigi coming down
    if CurrHeight2 + CharacterWidth2 + 2 > maxy or CurrHeight2 = MaxJump2 then
	LuigiGoingUp := false
	LuigiGoingDown := true
    end if
    %Luigi on the ground
    if CurrHeight2 = ground then
	LuigiGoingDown := false
    end if
    %Luigi going up
    if key ('w') and top2 (Lx, CurrHeight2) = true then
	LuigiGoingUp := true
	LuigiGoingDown := false
    end if
    %Luigi going up
    if LuigiGoingUp = true then
	LuigiJumpUp
	LuigiRightAir
	LuigiLeftAir
    end if
    %Luigi going down
    if LuigiGoingDown = true then
	LuigiJumpDown
	LuigiRightAir
	LuigiLeftAir
    end if
    DrawBack
    %Luigi lateral movements
    if CurrHeight2 <= ground or borders2 (Lx, CurrHeight2) = true then
	%Mario moving right
	LuigiMoveRight
	%Mario moving left
	LuigiMoveLeft
    end if
    %Draw mario and luigi
    DrawLuigi (PictureL, Lx, CurrHeight2)
    DrawMario (PictureM, Mx, CurrHeight)
    DrawGoomba (z3, GoombaX, GoombaY)
    %Star stuff
    CheckStarSpawn
    StarCollision
    StarCollision2
    %Mario and luigi jump adjust
    if top (Mx, CurrHeight) = true or CurrHeight = ground then
	MarioAdjustJump
    end if
    if top2 (Lx, CurrHeight2) = true or CurrHeight2 = ground then
	LuigiAdjustJump
    end if
end loop
