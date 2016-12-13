module Fsnake2(clk, VGA_R,VGA_B,VGA_G,VGA_BLANK_N, VGA_SYNC_N , VGA_HS, VGA_VS, rst, VGA_CLK, Button3, Button2, Button1, Button0, restart,KB_entry,KB_clock,extraclock);

//======Borrowed Code======//
//outputs the colors, determined from the color module.
output [7:0] VGA_R, VGA_B, VGA_G;

//Makes sure the screen is synced right.
output VGA_HS, VGA_VS, VGA_BLANK_N, VGA_CLK, VGA_SYNC_N;

//Basic inputs. Switches and buttons.
input clk, rst; //clk is taken from the onboard clock. rst is taken from a switch.
input Button0, Button1, Button2, Button3;//control Snakehead
input restart;//restart game -- This was not fully implemented.

wire WireButton0, WireButton1, WireButton2, WireButton3; //appleSry the button signals to various places.
wire CLK108; //Clock for the VGA
wire [30:0]X, Y; //Coordinates of the pixel being assigned. Moves top to bottom, left to right.

input KB_entry;
input KB_clock;
input extraclock;

wire eclock = extraclock;
wire KB_clk = KB_clock;
wire KB_input = KB_entry;
wire [7:0]KB_output;
reg [1:0]controller;

keyboard KB(eclock,KB_input,KB_clk,KB_output);


//Not sure what these are, probably have to do with the display output system.
wire [7:0]countRef;
wire [31:0]countSample;

//======New code======// 
/*Coordinates of Snakehead. Used only when the game is started for the 
first time. Had we implemented a true restart, these coordinates would
be called at the beginning of each restart. True for all coordinates
in this code block.*/
reg [31:0]SnakeheadX = 31'd640, SnakeheadY = 31'd512;


reg [31:0]neckX = 31'd15, neckY = 31'd15;		//coordinates of neck
reg [31:0]appleX = 31'd320, appleY = 31'd256;	//coordinates of apple
reg [31:0]body1X = 31'd15, body1Y = 31'd15;	//coordinates of body1
reg [31:0]body2X = 31'd15, body2Y = 31'd15;	//coordinates of body2
reg [31:0]body3X = 31'd15, body3Y = 31'd15;	//coordinates of body3
reg [31:0]body4X = 31'd15, body4Y = 31'd15;	//coordinates of body4
reg [31:0]body5X = 31'd15, body5Y = 31'd15;	//coordinates of body5
reg [31:0]body6X = 31'd15, body6Y = 31'd15;		//coordinates of body6
reg [31:0]body7X = 31'd15, body7Y = 31'd15;		//coordinates of body7
reg [31:0]body8X = 31'd15, body8Y = 31'd15;		//coordinates of body8
reg [31:0]body9X = 31'd15, body9Y = 31'd15;		//coordinates of body9
reg [31:0]body10X = 31'd15, body10Y = 31'd15;		//coordinates of body10
reg [31:0]body11X = 31'd15, body11Y = 31'd15;		//coordinates of body11
reg [31:0]body12X = 31'd15, body12Y = 31'd15;	//coordinates of body12
reg [31:0]body13X = 31'd15, body13Y = 31'd15;	//coordinates of body13
reg [31:0]body14X = 31'd15, body14Y = 31'd15;	//coordinates of body14

//======Borrowed Code======//
//This doesn't actually do anything because the restart wasn't implemented.
//Just an open ended switch.
assign restartGame = (restart);

//Gets the inputs from the buttons so that Snakehead can be controlled.
assign WireButton0=Button0;
assign WireButton1=Button1;
assign WireButton2=Button2;
assign WireButton3=Button3;	 
assign refresh= (X==0)&&(Y==0);

//======New Code======//
/*This code block creates a 'game object' with parameters for its boundaries.
Each game block's name is a True/False signal, set by logic that goes true if
the pixel being displayed is within the boundaries of the object.
*/
wire Snakehead, Wall, WallR, neck, apple, body1, body2, body3, body4, body5, body6, body7, body8, body9, body10, body11, body12, body13, body14, WallB, WallT;

//========= EDGE =========//
//Wall_Parameters
assign Wall = ((X >= 31'd0) && (X <= 31'd200) && (Y >= 31'd0) && (Y <= 31'd1024));

//WallR_Parameters
assign WallR = ((X >= 31'd1080) && (Y >= 31'd0) && (Y <= 31'd1024));

//bottomWall_Parameters
assign WallB = ((X >= 31'd0) && (Y >= 31'd864));

//topWall_Parameters
assign WallT = ((X >= 31'd0) && (Y >= 31'd1) && (Y <= 31'd160));

/*The T and L parameters of each object set the top left corner of the object's
reference frame. If Snakehead_L is not Zero, then all of Snakehead's positions will
be shifted right by the value of Snakehead_L. This only affects how much usable screen 
there is, so we left it zeroed.
The B and R parameters of each object set the size of the object, where B sets the 
height and R sets the width. Changing B changes the place of the bottom edge, never
the top. Changing R works in the same way.
*/
//======== BLOKKER =======//
//Snakehead_Parameters
localparam Snakehead_L = 31'd0;
localparam Snakehead_R = Snakehead_L + 31'd40;
localparam Snakehead_T = 31'd0;
localparam Snakehead_B = Snakehead_T + 31'd40;
assign Snakehead =((X >= Snakehead_L + SnakeheadX)&&(X <= Snakehead_R + SnakeheadX)&&(Y >= Snakehead_T+ SnakeheadY)&&(Y <= Snakehead_B+ SnakeheadY));


//========= appleSS ========//
//neck_Parameters
localparam neck_L = 31'd0;
localparam neck_R = neck_L + 31'd40;
localparam neck_T = 31'd0;
localparam neck_B = neck_T + 31'd40;
assign neck =((X >= neck_L + neckX)&&(X <= neck_R + neckX)&&(Y >= neck_T+ neckY)&&(Y <= neck_B + neckY));

//apple_Parameters
localparam apple_L = 31'd0;
localparam apple_R = apple_L + 31'd20;
localparam apple_T = 31'd0;
localparam apple_B = apple_T + 31'd20;
assign apple =((X >= apple_L + appleX)&&(X <= apple_R + appleX)&&(Y >= apple_T+ appleY)&&(Y <= apple_B + appleY));

//body1_Parameters
localparam body1_L = 31'd0;
localparam body1_R = body1_L + 31'd40;
localparam body1_T = 31'd0;
localparam body1_B = body1_T + 31'd40;
assign body1 =((X >= body1_L + body1X)&&(X <= body1_R + body1X)&&(Y >= body1_T+ body1Y)&&(Y <= body1_B + body1Y));

//body2_Parameters
localparam body2_L = 31'd0;
localparam body2_R = body2_L + 31'd40;
localparam body2_T = 31'd0;
localparam body2_B = body2_T + 31'd40;
assign body2 =((X >= body2_L + body2X)&&(X <= body2_R + body2X)&&(Y >= body2_T+ body2Y)&&(Y <= body2_B + body2Y));

//body3_Parameters
localparam body3_L = 31'd0;
localparam body3_R = body3_L + 31'd40;
localparam body3_T = 31'd0;
localparam body3_B = body3_T + 31'd40;
assign body3 =((X >= body3_L + body3X)&&(X <= body3_R + body3X)&&(Y >= body3_T+ body3Y)&&(Y <= body3_B + body3Y));

//body4_Parameters
localparam body4_L = 31'd0;
localparam body4_R = body4_L + 31'd40;
localparam body4_T = 31'd0;
localparam body4_B = body4_T + 31'd40;
assign body4 =((X >= body4_L + body4X)&&(X <= body4_R + body4X)&&(Y >= body4_T+ body4Y)&&(Y <= body4_B + body4Y));

//========= bodyS ========//
//body5_Parameters
localparam body5_L = 31'd0;
localparam body5_R = body5_L + 31'd40;
localparam body5_T = 31'd0;
localparam body5_B = body5_T + 31'd40;
assign body5 =((X >= body5_L + body5X)&&(X <= body5_R + body5X)&&(Y >= body5_T+ body5Y)&&(Y <= body5_B + body5Y));

//body6_Parameters
localparam body6_L = 31'd0;
localparam body6_R = body6_L + 31'd40;
localparam body6_T = 31'd0;
localparam body6_B = body6_T + 31'd40;
assign body6 =((X >= body6_L + body6X)&&(X <= body6_R + body6X)&&(Y >= body6_T+ body6Y)&&(Y <= body6_B + body6Y));

//body7_Parameters
localparam body7_L = 31'd0;
localparam body7_R = body7_L + 31'd40;
localparam body7_T = 31'd0;
localparam body7_B = body7_T + 31'd40;
assign body7 =((X >= body7_L + body7X)&&(X <= body7_R + body7X)&&(Y >= body7_T+ body7Y)&&(Y <= body7_B + body7Y));

//body8_Parameters
localparam body8_L = 31'd0;
localparam body8_R = body8_L + 31'd40;
localparam body8_T = 31'd0;
localparam body8_B = body8_T + 31'd40;
assign body8 =((X >= body8_L + body8X)&&(X <= body8_R + body8X)&&(Y >= body8_T+ body8Y)&&(Y <= body8_B + body8Y));

//body9_Parameters
localparam body9_L = 31'd0;
localparam body9_R = body9_L + 31'd40;
localparam body9_T = 31'd0;
localparam body9_B = body9_T + 31'd40;
assign body9 =((X >= body9_L + body9X)&&(X <= body9_R + body9X)&&(Y >= body9_T+ body9Y)&&(Y <= body9_B + body9Y));

//body10_Parameters
localparam body10_L = 31'd0;
localparam body10_R = body10_L + 31'd40;
localparam body10_T = 31'd0;
localparam body10_B = body10_T + 31'd40;
assign body10 =((X >= body10_L + body10X)&&(X <= body10_R + body10X)&&(Y >= body10_T+ body10Y)&&(Y <= body10_B + body10Y));

//========= bodyES ========//
//body11_Parameters
localparam body11_L = 31'd0;
localparam body11_R = body11_L + 31'd40;
localparam body11_T = 31'd0;
localparam body11_B = body11_T + 31'd40;
assign body11 =((X >= body11_L + body11X)&&(X <= body11_R + body11X)&&(Y >= body11_T+ body11Y)&&(Y <= body11_B + body11Y));

//body12_Parameters
localparam body12_L = 31'd0;
localparam body12_R = body12_L + 31'd40;
localparam body12_T = 31'd0;
localparam body12_B = body12_T + 31'd40;
assign body12 =((X >= body12_L + body12X)&&(X <= body12_R + body12X)&&(Y >= body12_T+ body12Y)&&(Y <= body12_B + body12Y));

//body13_Parameters
localparam body13_L = 31'd0;
localparam body13_R = body13_L + 31'd40;
localparam body13_T = 31'd0;
localparam body13_B = body13_T + 31'd40;
assign body13 =((X >= body13_L + body13X)&&(X <= body13_R + body13X)&&(Y >= body13_T+ body13Y)&&(Y <= body13_B + body13Y));

//body14_Parameters
localparam body14_L = 31'd0;
localparam body14_R = body14_L + 31'd40;
localparam body14_T = 31'd0;
localparam body14_B = body14_T + 31'd40;
assign body14 =((X >= body14_L + body14X)&&(X <= body14_R + body14X)&&(Y >= body14_T+ body14Y)&&(Y <= body14_B + body14Y));

//======Borrowed Code======//
//==========DO NOT EDIT==========//
countingRefresh(X, Y, clk, countRef );
clock108(rst, clk, CLK_108, locked);

wire hblank, vblank, clkLine, blank;

//Sync the display
H_SYNC(CLK_108, VGA_HS, hblank, clkLine, X);
V_SYNC(clkLine, VGA_VS, vblank, Y);
//=======CONTINUE EDITING=======//

//======New Code======//
/*This code block sets the priority of the game objects so that they're displayed in the right order. 
Changing the placement of an object in the list changes what is displayed on top of it, and what is
displayed under it. In most cases, this doesn't change anything. The important one is the Wall being 
before everything except Snakehead.
The lowercase variables translate the object-to-be-displayed decision to the color module.
*/
reg player, appleS, body, bodyE, bottomWall, side, topWall;

//drawing shapes	
always@(*)
begin

	if(Snakehead) begin
		player = 1'b1;
		side = 1'b0;
		appleS = 1'b0;
		body = 1'b0;
		bodyE = 1'b0;
		bottomWall = 1'b0;
		topWall = 1'b0;
		end
	else if(Wall | WallR) begin
		player = 1'b0;
		side = 1'b1;
		appleS = 1'b0;
		body = 1'b0;
		bodyE = 1'b0;
		bottomWall = 1'b0;
		topWall = 1'b0;
		end
	else if( apple ) begin
		player = 1'b0;
		side = 1'b0;
		appleS = 1'b1;
		body = 1'b0;
		bodyE = 1'b0;
		bottomWall = 1'b0;
		topWall = 1'b0;
		end
	else if(neck | body5 | body1 | body2 | body3 | body4| body6 | body7 | body8 | body9 | body10) begin
		player = 1'b0;
		side = 1'b0;
		appleS = 1'b0;
		body = 1'b1;
		bodyE = 1'b0;
		bottomWall = 1'b0;
		topWall = 1'b0;
		end
	else if(body11 | body12 | body13 | body14) begin
		player = 1'b0;
		side = 1'b0;
		appleS = 1'b0;
		body = 1'b0;
		bodyE = 1'b1;
		bottomWall = 1'b0;
		topWall = 1'b0;
		end
	else if(WallB) begin
		player = 1'b0;
		side = 1'b0;
		appleS = 1'b0;
		body = 1'b0;
		bodyE = 1'b0;
		bottomWall = 1'b1;
		topWall = 1'b0;
		end
	else if(WallT) begin
		player = 1'b0;
		side = 1'b0;
		appleS = 1'b0;
		body = 1'b0;
		bodyE = 1'b0;
		bottomWall = 1'b0;
		topWall = 1'b1;
		end
	else begin
		player = 1'b0;
		side = 1'b0;
		appleS = 1'b0;
		body = 1'b0;
		bodyE = 1'b0;
		bottomWall = 1'b0;
		topWall = 1'b0;
		end
	end

/*This next block is tricky. temp and count were borrowed from the other project.
They keep everything running smoothly and at a good speed. We're not sure why temp is
necessary, but without it the code consistently breaks. It MUST be included in the else
statement of any if/else structure in this block, not including else if's. All code besides
temp, count, and the WireButtons is new code.
*/
reg temp;
reg [31:0]count;

//Speed control
reg [2:0]thing1  = 1'd1; 
reg [3:0]thing2  = 1'd1; 
reg [1:0]thing3  = 1'd1; 

reg [15:0]size = 16'd2;
reg [15:0] delay = 16'd0;

reg [11: 0]randcountX = 12'd250;
reg [11: 0]randcountY = 12'd220;
//controls game objects	
always@(posedge clk)	
begin
		
		randcountX <= randcountX + 11'd5; 
		randcountY <= randcountY + 11'd3;
		
		if(randcountX >= 1040) 
			randcountX <= 12'd280;
		if(randcountY >= 760) 
			randcountY <= 12'd240;
			
		
		else begin
			count<=count+1;
			//Collision detection
			if(Snakehead && (body2| body3 | body4 | body5 | body6 | body7 | body8 | body9 | body10 | body11 | body12 | body13 | body14)) begin
				SnakeheadX <= 31'd640;
				SnakeheadY <= 31'd512;
				size <= 16'd2;
				body14X <= 32'd15;
				body14Y <= 32'd15;
				body13X <= 32'd15;
				body13Y <= 32'd15;
				body12X <= 32'd15;
				body12Y <= 32'd15;
				body11X <= 32'd15;
				body11Y <= 32'd15;
				body10X <= 32'd15;
				body10Y <= 32'd15;
				body9X <= 32'd15;
				body9Y <= 32'd15;
				body8X <= 32'd15;
				body8Y <= 32'd15;
				body7X <= 32'd15;
				body7Y <= 32'd15;
				body6X <= 32'd15;
				body6Y <= 32'd15;
				body5X <= 32'd15;
				body5Y <= 32'd15;
				body4X <= 32'd15;
				body4Y <= 32'd15;
				body3X <= 32'd15;
				body3Y <= 32'd15;
				body2X <= 32'd15;
				body2Y <= 32'd15;
				body1X <= 32'd15;
				body1Y <= 32'd15;
				neckX <= 32'd15;
				neckY <= 32'd15;
				end
			else if( Snakehead && apple) begin
				appleX <= randcountX;
				appleY <= randcountY;
				size <= size + 16'd1;
				
				end
			else begin
			
			if(delay == 16'd44)
			begin
		
				if(size >= 15)
				begin
				
				body14X <= body13X;
				body14Y <= body13Y;
				
				
				end
				else
					temp <= temp;
					
				 if (size >= 14)
				begin
				body13X <= body12X;
				body13Y <= body12Y;
				
				end
				else
					temp <= temp;
					
				 if (size >= 13)
				begin
				body12X <= body11X;
				body12Y <= body11Y;
				
				end
				else
					temp <= temp;
					
				 if (size >= 12)
				begin
				body11X <= body10X;
				body11Y <= body10Y;
				
				end
				else
					temp <= temp;
					
				 if (size >= 11)
				begin
				body10X <= body9X;
				body10Y <= body9Y;
				
			end
			else
					temp <= temp;
					
			 if (size >= 10)
			begin
				body9X <= body8X;
				body9Y <= body8Y;
				
			end
			else
					temp <= temp;
					
			 if (size >= 9)
			begin
				body8X <= body7X;
				body8Y <= body7Y;
				
			end
			else
					temp <= temp;
					
			if (size >= 8)
			begin
				body7X <= body6X;
				body7Y <= body6Y;
				
			end
			else
					temp <= temp;
					
			if (size >= 7)
			begin
				body6X <= body5X;
				body6Y <= body5Y;
				
			end
			else
					temp <= temp;
					
			if (size >= 6)
			begin
				body5X <= body4X;
				body5Y <= body4Y;
				
			end
			else
					temp <= temp;
					
			if (size >= 5)
			begin
				body4X <= body3X;
				body4Y <= body3Y;
				
			end
			else
					temp <= temp;
					
			if (size >= 4)
			begin
				body3X <= body2X;
				body3Y <= body2Y;
				
			end
			else
					temp <= temp;
					
			if (size >= 3)
			begin
			
				body2X <= body1X;
				body2Y <= body1Y;
				
				
			end
			else
					temp <= temp;
					
			if (size >= 2)
			begin
				body1X <= neckX;
				body1Y <= neckY;
				
			end
			else
					temp <= temp;
					
			
				neckX <= SnakeheadX;
				neckY <= SnakeheadY;
				
			
			delay <= 16'd0;
		end
		else
					temp <= temp;
			
			
			
				case(KB_output)
					8'h1D: begin
								controller <= 2'b00;
							 end
					8'h1C: begin
								controller <= 2'b01;
							 end
					8'h1B: begin
								controller <= 2'b10;
							 end
					8'h23: begin
								controller <= 2'b11;
							 end
					endcase
			
				case(controller)
					2'b00: begin
								if(count == 31'd100000)
								begin
								SnakeheadY <= SnakeheadY- 2'd1;
								delay <= delay+ 16'd1;
								end
								else
					temp <= temp;
							 end
					2'b01: begin
								if(count == 31'd100000)
								begin
								SnakeheadX <= SnakeheadX - 2'd1;
								delay <= delay + 16'd1;
								end
								else
					temp <= temp;
							 end
					2'b10: begin
								if(count == 31'd100000)
								begin
								SnakeheadY <= SnakeheadY + 2'd1;
								delay <= delay + 16'd1;
								end
								else
					temp <= temp;
							 end
					2'b11: begin
								if(count == 31'd100000)
								begin
								SnakeheadX <= SnakeheadX + 2'd1;
								delay <= delay + 16'd1;
								end
								else
							temp <= temp;
							 end
					endcase
				//Snakehead movement X axis
				if(WireButton3 == 1'b0 && count == 31'd100000)
					begin
						appleX <= randcountX;
						appleY <= randcountY;
					end
					else
					temp <= temp;
				
				if(SnakeheadX >= 31'd1040) begin //Right-edge boundary
					SnakeheadX <= 31'd640;
					SnakeheadY <= 31'd512;
					controller <= 2'b00;
					size <= 16'd2;
					body14X <= 32'd15;
				body14Y <= 32'd15;
				body13X <= 32'd15;
				body13Y <= 32'd15;
				body12X <= 32'd15;
				body12Y <= 32'd15;
				body11X <= 32'd15;
				body11Y <= 32'd15;
				body10X <= 32'd15;
				body10Y <= 32'd15;
				body9X <= 32'd15;
				body9Y <= 32'd15;
				body8X <= 32'd15;
				body8Y <= 32'd15;
				body7X <= 32'd15;
				body7Y <= 32'd15;
				body6X <= 32'd15;
				body6Y <= 32'd15;
				body5X <= 32'd15;
				body5Y <= 32'd15;
				body4X <= 32'd15;
				body4Y <= 32'd15;
				body3X <= 32'd15;
				body3Y <= 32'd15;
				body2X <= 32'd15;
				body2Y <= 32'd15;
				body1X <= 32'd15;
				body1Y <= 32'd15;
				neckX <= 32'd15;
				neckY <= 32'd15;
					end
					else
					temp <= temp;
				if(SnakeheadX <= 31'd200) begin //Left-edge boundary
					SnakeheadX <= 31'd640;
					SnakeheadY <= 31'd512;
					controller <= 2'b00;
					size <= 16'd2;
					body14X <= 32'd15;
				body14Y <= 32'd15;
				body13X <= 32'd15;
				body13Y <= 32'd15;
				body12X <= 32'd15;
				body12Y <= 32'd15;
				body11X <= 32'd15;
				body11Y <= 32'd15;
				body10X <= 32'd15;
				body10Y <= 32'd15;
				body9X <= 32'd15;
				body9Y <= 32'd15;
				body8X <= 32'd15;
				body8Y <= 32'd15;
				body7X <= 32'd15;
				body7Y <= 32'd15;
				body6X <= 32'd15;
				body6Y <= 32'd15;
				body5X <= 32'd15;
				body5Y <= 32'd15;
				body4X <= 32'd15;
				body4Y <= 32'd15;
				body3X <= 32'd15;
				body3Y <= 32'd15;
				body2X <= 32'd15;
				body2Y <= 32'd15;
				body1X <= 32'd15;
				body1Y <= 32'd15;
				neckX <= 32'd15;
				neckY <= 32'd15;
					end
					else
					temp <= temp;
				
				/*if(WireButton2 == 1'b0 && count == 31'd100000)begin
				size <= 16'd2;
				body14X <= 32'd15;
				body14Y <= 32'd15;
				body13X <= 32'd15;
				body13Y <= 32'd15;
				body12X <= 32'd15;
				body12Y <= 32'd15;
				body11X <= 32'd15;
				body11Y <= 32'd15;
				body10X <= 32'd15;
				body10Y <= 32'd15;
				body9X <= 32'd15;
				body9Y <= 32'd15;
				body8X <= 32'd15;
				body8Y <= 32'd15;
				body7X <= 32'd15;
				body7Y <= 32'd15;
				body6X <= 32'd15;
				body6Y <= 32'd15;
				body5X <= 32'd15;
				body5Y <= 32'd15;
				body4X <= 32'd15;
				body4Y <= 32'd15;
				body3X <= 32'd15;
				body3Y <= 32'd15;
				body2X <= 32'd15;
				body2Y <= 32'd15;
				body1X <= 32'd15;
				body1Y <= 32'd15;
				neckX <= 32'd15;
				neckY <= 32'd15;
				end
				else
					temp <= temp;
					*/
					
				
				if(SnakeheadY >= 31'd823) begin
					SnakeheadX <= 31'd640;
					SnakeheadY <= 31'd512;
					controller <= 2'b00;
					size <= 16'd2;
					body14X <= 32'd15;
				body14Y <= 32'd15;
				body13X <= 32'd15;
				body13Y <= 32'd15;
				body12X <= 32'd15;
				body12Y <= 32'd15;
				body11X <= 32'd15;
				body11Y <= 32'd15;
				body10X <= 32'd15;
				body10Y <= 32'd15;
				body9X <= 32'd15;
				body9Y <= 32'd15;
				body8X <= 32'd15;
				body8Y <= 32'd15;
				body7X <= 32'd15;
				body7Y <= 32'd15;
				body6X <= 32'd15;
				body6Y <= 32'd15;
				body5X <= 32'd15;
				body5Y <= 32'd15;
				body4X <= 32'd15;
				body4Y <= 32'd15;
				body3X <= 32'd15;
				body3Y <= 32'd15;
				body2X <= 32'd15;
				body2Y <= 32'd15;
				body1X <= 32'd15;
				body1Y <= 32'd15;
				neckX <= 32'd15;
				neckY <= 32'd15;
					end
					else
					temp <= temp;
				if(SnakeheadY <= 31'd160) begin 
					SnakeheadX <= 31'd640;
					SnakeheadY <= 31'd512;
					controller <= 2'b00;
					size <= 16'd2; 
					body14X <= 32'd15;
				body14Y <= 32'd15;
				body13X <= 32'd15;
				body13Y <= 32'd15;
				body12X <= 32'd15;
				body12Y <= 32'd15;
				body11X <= 32'd15;
				body11Y <= 32'd15;
				body10X <= 32'd15;
				body10Y <= 32'd15;
				body9X <= 32'd15;
				body9Y <= 32'd15;
				body8X <= 32'd15;
				body8Y <= 32'd15;
				body7X <= 32'd15;
				body7Y <= 32'd15;
				body6X <= 32'd15;
				body6Y <= 32'd15;
				body5X <= 32'd15;
				body5Y <= 32'd15;
				body4X <= 32'd15;
				body4Y <= 32'd15;
				body3X <= 32'd15;
				body3Y <= 32'd15;
				body2X <= 32'd15;
				body2Y <= 32'd15;
				body1X <= 32'd15;
				body1Y <= 32'd15;
				neckX <= 32'd15;
				neckY <= 32'd15;
					end
					else
					temp <= temp;
				end
			
			
			end
			if(count>=31'd100010)
			count<=0;
end

//======Modified Borrowed Code======//
//Determines the color output based on the decision from the priority block
color(clk, VGA_R, VGA_B, VGA_G, player, appleS, body, side, bodyE, bottomWall, topWall);

//======Borrowed code======//
assign VGA_CLK = CLK_108;
assign VGA_BLANK_N = VGA_VS&VGA_HS;
assign VGA_SYNC_N = 1'b0;
	 
endmodule

//Controls the counter
module countingRefresh(X, Y, clk, count);
input [31:0]X, Y;
input clk;
output [7:0]count;
reg[7:0]count;
always@(posedge clk)
begin
	if(X==0 &&Y==0)
		count<=count+1;
	else if(count==7'd11)
		count<=0;
	else
		count<=count;
end

endmodule

//======Formatted like Borrowed code, but all new parameters======//
//============================//
//========== COLOR ===========//
//============================//
module color(clk, red, blue, green, player, appleS, body, side, bodyE, bottomWall, topWall);

input clk, player, appleS, body, side, bodyE, bottomWall, topWall;

output [7:0] red, blue, green;

reg[7:0] red, green, blue;

always@(*)
begin
	if(side) begin
		red = 8'd150;
		blue = 8'd150;
		green = 8'd150;
		end
	else if(player) begin
		red = 8'd250;
		blue = 8'd255;
		green = 8'd255;
		end
	else if(appleS) begin
		red = 8'd250;
		blue = 8'd25;
		green = 8'd25;
		end
	else if(body) begin
		red = 8'd250;
		blue = 8'd255;
		green = 8'd255;
		end
	else if(bodyE) begin
		red = 8'd250;
		blue = 8'd255;
		green = 8'd255;
		end
	else if(bottomWall) begin
		red = 8'd150;
		blue = 8'd150;
		green = 8'd150;
		end
	else if(topWall) begin
		red = 8'd150;
		blue = 8'd150;
		green = 8'd150;
		end
	else begin
		red = 8'd0;
		blue = 8'd0;
		green = 8'd0;
		end
	end
	
endmodule




module keyboard (
	input clk,
	input PS2_DATA,
	input PS2_CLOCK,
	output reg [7:0] keycode
						);

//from Isaac Steiger
//code from Funkheld on http://www.alteraforum.com/forum/showthread.php?t=46549
parameter idle = 2'b01;
parameter receive = 2'b10;
parameter ready = 2'b11;

reg [7:0] previousKey;
reg [1:0] state=idle;
reg [15:0] rxtimeout=16'b0000000000000000;
reg [10:0] rxregister=11'b11111111111;
reg [1:0] datasr=2'b11;
reg [1:0] clksr=2'b11;
reg [7:0] rxdata;

reg datafetched;
reg rxactive;
reg dataready;

always @(posedge clk )
begin

	if(datafetched==1)
		begin
			if(previousKey != 8'hF0)
				begin
					keycode<=rxdata;
				end
				previousKey <=rxdata;
			end
		end

always @(posedge clk )
begin
	rxtimeout<=rxtimeout+1;
	datasr <= {datasr[0],PS2_DATA};
	clksr <= {clksr[0],PS2_CLOCK};
	
	if(clksr==2'b10)
		rxregister<= {datasr[1],rxregister[10:1]};
		
		case (state)
		idle: begin
			rxregister <=11'b11111111111;
			rxactive <=0;
			dataready <=0;
			datafetched <=0;
			rxtimeout <=16'b0000000000000000;
			if(datasr[1]==0 && clksr[1]==1)
				begin
					state<=receive;
					rxactive<=1;
				end
			end
		receive: begin
			if(rxtimeout==50000)
				state<=idle;
			else if(rxregister[0]==0)
				begin
					dataready<=1;
					rxdata<=rxregister[8:1];
					state<=ready;
					datafetched<=1;
				end
			end
		ready: begin
			if(datafetched==1)
				begin
					state <=idle;
					dataready <=0;
					rxactive <=0;
					datafetched <=0;
				end
			end
		endcase
	end
endmodule










/*module keyboard(KB_input, KB_clk, KB_out);

	input KB_clk, KB_input;
	//output reg [3:0] KB_out;
	output reg [1:0]KB_out;
	reg [7:0] code;
	reg [10:0]keyCode, previousCode;
	integer count = 0;
	
	always @ (negedge KB_clk)
		begin
			keyCode[count] = KB_input;
			count = count + 1;
			if(count == 11)
			begin	
				if(previousCode == 8'hF0)
				begin
					code <= keyCode[8:1];
				end
				previousCode = keyCode[8:1];
				count = 0;
				end
			end
			
			always @ (code)
			begin
				if(code ==8'h1D)
					KB_out = 2'b00;
				else if(code == 8'h1C)
					KB_out = 2'b01;
				else if(code == 8'h1B)
					KB_out = 2'b10;
				else if(code == 8'h23)
					KB_out = 2'b11;
			end
			
			always @ (*)
			begin
			/*case(lightcode)
				2'b00:begin	
						 KB_out[0] = 1'b1;
						 KB_out[1] = 1'b0;
						 KB_out[2] = 1'b0;
						 KB_out[3] = 1'b0;
						 end
				2'b01: begin
						 KB_out[0] = 1'b0;
						 KB_out[1] = 1'b1;
						 KB_out[2] = 1'b0;
						 KB_out[3] = 1'b0;
						 end
				2'b10: begin 
						 KB_out[0] = 1'b0;
						 KB_out[1] = 1'b0;
						 KB_out[2] = 1'b1;
						 KB_out[3] = 1'b0;
						 end
				2'b11: begin
						 KB_out[0] = 1'b0;
						 KB_out[1] = 1'b0;
						 KB_out[2] = 1'b0;
						 KB_out[3] = 1'b1;
						 end
				endcase
			end
endmodule*/


//======All Borrowed code past here======//
//====================================//
//========DO NOT EDIT PAST HERE=======//
//====================================//
module H_SYNC(clk, hout, bout, newLine, Xcount);

input clk;
output hout, bout, newLine;
output [31:0] Xcount;
	
reg [31:0] count = 32'd0;
reg hsync, blank, new1;

always @(posedge clk) 
begin
	if (count <  1688)
		count <= Xcount + 1;
	else 
      count <= 0;
   end 

always @(*) 
begin
	if (count == 0)
		new1 = 1;
	else
		new1 = 0;
   end 

always @(*) 
begin
	if (count > 1279) 
		blank = 1;
   else 
		blank = 0;
   end

always @(*) 
begin
	if (count < 1328)
		hsync = 1;
   else if (count > 1327 && count < 1440)
		hsync = 0;
   else    
		hsync = 1;
	end

assign Xcount=count;
assign hout = hsync;
assign bout = blank;
assign newLine = new1;

endmodule

module V_SYNC(clk, vout, bout, Ycount);

input clk;
output vout, bout;
output [31:0]Ycount; 
	  
reg [31:0] count = 32'd0;
reg vsync, blank;

always @(posedge clk) 
begin
	if (count <  1066)
		count <= Ycount + 1;
   else 
            count <= 0;
   end 

always @(*) 
begin
	if (count < 1024) 
		blank = 1;
   else 
		blank = 0;
   end

always @(*) 
begin
	if (count < 1025)
		vsync = 1;
	else if (count > 1024 && count < 1028)
		vsync = 0;
	else    
		vsync = 1;
	end

assign Ycount=count;
assign vout = vsync;
assign bout = blank;

endmodule

//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module clock108 (areset, inclk0, c0, locked);

input     areset;
input     inclk0;
output    c0;
output    locked;

`ifndef ALTERA_RESERVED_QIS
 //synopsys translate_off
`endif

tri0      areset;

`ifndef ALTERA_RESERVED_QIS
 //synopsys translate_on
`endif

wire [0:0] sub_wire2 = 1'h0;
wire [4:0] sub_wire3;
wire  sub_wire5;
wire  sub_wire0 = inclk0;
wire [1:0] sub_wire1 = {sub_wire2, sub_wire0};
wire [0:0] sub_wire4 = sub_wire3[0:0];
wire  c0 = sub_wire4;
wire  locked = sub_wire5;
	 
altpll  altpll_component (
            .areset (areset),
            .inclk (sub_wire1),
            .clk (sub_wire3),
            .locked (sub_wire5),
            .activeclock (),
            .clkbad (),
            .clkena ({6{1'b1}}),
            .clkloss (),
            .clkswitch (1'b0),
            .configupdate (1'b0),
            .enable0 (),
            .enable1 (),
            .extclk (),
            .extclkena ({4{1'b1}}),
            .fbin (1'b1),
            .fbmimicbidir (),
            .fbout (),
            .fref (),
            .icdrclk (),
            .pfdena (1'b1),
            .phasecounterselect ({4{1'b1}}),
            .phasedone (),
            .phasestep (1'b1),
            .phaseupdown (1'b1),
            .pllena (1'b1),
            .scanaclr (1'b0),
            .scanclk (1'b0),
            .scanclkena (1'b1),
            .scandata (1'b0),
            .scandataout (),
            .scandone (),
            .scanread (1'b0),
            .scanwrite (1'b0),
            .sclkout0 (),
            .sclkout1 (),
            .vcooverrange (),
            .vcounderrange ());
defparam
    altpll_component.bandwidth_type = "AUTO",
    altpll_component.clk0_divide_by = 25,
    altpll_component.clk0_duty_cycle = 50,
    altpll_component.clk0_multiply_by = 54,
    altpll_component.clk0_phase_shift = "0",
    altpll_component.compensate_clock = "CLK0",
    altpll_component.inclk0_input_frequency = 20000,
    altpll_component.intended_device_family = "Cyclone IV E",
    altpll_component.lpm_hint = "CBX_MODULE_PREFIX=clock108",
    altpll_component.lpm_type = "altpll",
    altpll_component.operation_mode = "NORMAL",
    altpll_component.pll_type = "AUTO",
    altpll_component.port_activeclock = "PORT_UNUSED",
    altpll_component.port_areset = "PORT_USED",
    altpll_component.port_clkbad0 = "PORT_UNUSED",
    altpll_component.port_clkbad1 = "PORT_UNUSED",
    altpll_component.port_clkloss = "PORT_UNUSED",
    altpll_component.port_clkswitch = "PORT_UNUSED",
    altpll_component.port_configupdate = "PORT_UNUSED",
    altpll_component.port_fbin = "PORT_UNUSED",
    altpll_component.port_inclk0 = "PORT_USED",
    altpll_component.port_inclk1 = "PORT_UNUSED",
    altpll_component.port_locked = "PORT_USED",
    altpll_component.port_pfdena = "PORT_UNUSED",
    altpll_component.port_phasecounterselect = "PORT_UNUSED",
    altpll_component.port_phasedone = "PORT_UNUSED",
    altpll_component.port_phasestep = "PORT_UNUSED",
    altpll_component.port_phaseupdown = "PORT_UNUSED",
    altpll_component.port_pllena = "PORT_UNUSED",
    altpll_component.port_scanaclr = "PORT_UNUSED",
    altpll_component.port_scanclk = "PORT_UNUSED",
    altpll_component.port_scanclkena = "PORT_UNUSED",
    altpll_component.port_scandata = "PORT_UNUSED",
    altpll_component.port_scandataout = "PORT_UNUSED",
    altpll_component.port_scandone = "PORT_UNUSED",
    altpll_component.port_scanread = "PORT_UNUSED",
    altpll_component.port_scanwrite = "PORT_UNUSED",
    altpll_component.port_clk0 = "PORT_USED",
    altpll_component.port_clk1 = "PORT_UNUSED",
    altpll_component.port_clk2 = "PORT_UNUSED",
    altpll_component.port_clk3 = "PORT_UNUSED",
    altpll_component.port_clk4 = "PORT_UNUSED",
    altpll_component.port_clk5 = "PORT_UNUSED",
    altpll_component.port_clkena0 = "PORT_UNUSED",
    altpll_component.port_clkena1 = "PORT_UNUSED",
    altpll_component.port_clkena2 = "PORT_UNUSED",
    altpll_component.port_clkena3 = "PORT_UNUSED",
    altpll_component.port_clkena4 = "PORT_UNUSED",
    altpll_component.port_clkena5 = "PORT_UNUSED",
    altpll_component.port_extclk0 = "PORT_UNUSED",
    altpll_component.port_extclk1 = "PORT_UNUSED",
    altpll_component.port_extclk2 = "PORT_UNUSED",
    altpll_component.port_extclk3 = "PORT_UNUSED",
    altpll_component.self_reset_on_loss_lock = "OFF",
    altpll_component.width_clock = 5;

endmodule