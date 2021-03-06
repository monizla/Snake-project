## Snake-project
Final project report below

A snake game made on the FPGA using keyboard input and VGA output

Project for ECE 287

Lucas Moniz, Brandon Wallace

## Our Goal

for our project, we wanted to make a snake game using the FPGA board. Our game was planned to use the PS/2 port to implement a keyboard for input, and a VGA to output display to a monitor. Our challenges for this project were implementing a keyboard to the FPGA board, displaying our game via the VGA port, and implementing the logic for snake with minimal bugs in our design.
  
## The report

 	beginning and PS/2 Keyboard
   We began our work researching how to implement the VGA port and PS/2 port on the FPGA board. The PS/2 keyboard that we designed functioned by searching for the "break" signal which is represented by a hexadecimal value "F0" from the PS/2 input signal. This design was flawed because it relied on "negedge clk" which would cause the keyboard to lock up after a few clock cycles. We fixed this by implementing our directional design with a separate keyboard module, which made the keyboard function by searching for the hex code for the input from the keyboard instead of the break code. We implemented this with a "controller" variable that was passed to a case statement that increased the respective X or Y position of the character's head.

   	VGA output
Our VGA output uses an X and Y position of all game objects, along with a width and height of each object. Our game uses 6 types of objects; a player head, the body of the snake, the apple or "food", the left and right walls, the top wall, and the bottom wall. Each of these objects is passed to a color module which assigns the pixels a color based on the objects that occupy each pixel. The order that the objects are assigned a color determines when they appear on the monitor, allowing for objects to be printed a layer above or below the other objects. Each pixel is given its color from left to right, top to bottom, at a speed determined by the clock on the FPGA board.

  	 Snake Logic and issues
  For the logic of our game, we started by making the objects proper colors and sizes for display. Then, all of our unnecessary objects were hidden behind the sides of the snake board to make an illusion of the tail of the snake appearing from nothing. We came across an issue where hiding the tail pieces close to the outer boundaries of the monitor would cause display errors, this was corrected by hiding them closer to the game board. The apple has a pseudo-random placement on the board, this was created by 2 registers that were constantly being increased on each clock tick, and cycling within the borders of the game board. Whenever the snake head successfully touched the apple, the apple was assigned the X and Y of the rotating registers, which placed it at a (mostly) random point on the game board.
  
  The snake's movement is where alot of our challenges originated from, mainly a bug that causes the snake tail to stand in place during movement, and requires the recollection of apples to recollect the still tail pieces. This bug occured very inconsistenly, and changes in logic would cause the pieces to move on their own, with no patterns causing it to occur, but this bug would be very frequent when it occured. Our snake movement was based on a previous project from ECE 102, which was completed in processing by Lucas, and used very similar logic. The snake head moved from the keyboard input on a delayed clock tick, during this time, a delay was incremented which was used to have gaps between the block movement rather than one long snake. Before any movement, we checked to see if the snake head was making contact with the walls, the tail, or the apple. Each would trigger either a game over, or an increase in player score. When the delay hit a value of 44, the snake moved piece by piece, from the back of the snake to the front. initially, the snake would be killed immediately upon moving, this was because the piece of the 2 pieces of the snake before the head would intersect the head of the snake. These issues were fixed by removing their detection with the head, which allowed for smooth turning and movement without the risk of the snake killing itself due to a bug.
   
   
  	conclusion

Our project allowed us to get an understanding of a VGA and PS/2 keyboard to create a game based solely in hardware, which is a more practical application of the FPGA that we've been using this semester than many projects we worked on in the past. Many stages in our game brought major problems, which we had to cooperate to find solutions to, these issues mainly arose during the programming of the VGA  module which took up a majority of our project design time. Though some bugs are still present, we feel that the game is the most bug-free and optimal solution to our problem that could be achieved with the approach we took to the problem, as a state machine was not directly designed for our project. Other improvements that could be made include; a hardcoded prevention of moving in the oposite direction of current motion, making the player head move along with the delay included for body parts to make a more retro movement style, creating an array that can store more than 16 blocks to allow for endless gameplay, and an ending screen for the game that displays the final score.

## Citations
   Our final project was started from a previous project, this project can be found at:
  https://github.com/bdshaffer73/Blokker-fpga
  
  Though our original design for keyboard input is available, a more efficient version of a keyboard was shared to us by isaac Steiger, the code was found at: 
  http://www.alteraforum.com/forum/showthread.php?t=46549
  
  Code that was borrowed from previous projects, and NOT marked as such in the .v file:
  ```
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
```
This code was included in the blokker program, we edited the localparam statements, but assign statements are as they were in the previous project, as they are implementations for the VGA and would potentially cause errors if edited.

```
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
```
This code was used to tell the VGA how to print the game objects, we edited the variable names to make our code easier to read, and changed the if statements on some of the parameters to allow the code to function as a snake game.


