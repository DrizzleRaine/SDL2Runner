--  
-- Copyright (c) Jesse Freeman. All rights reserved.  
-- 
-- Licensed under the Microsoft Public License (MS-PL) License. 
-- See LICENSE file in the project root for full license information. 
-- 
-- Contributors
-- --------------------------------------------------------
-- This is the official list of Pixel Vision 8 contributors:
--  
-- Jesse Freeman - @JesseFreeman
-- Christer Kaitila - @McFunkypants
-- Pedro Medeiros - @saint11
-- Shawn Rakowski - @shwany
--

-- These values represent the shell's position, speed, animation
-- time and frame.
local shellAPos = {x = 0, y = 8*8}
local shellBPos = {x = 8*22, y = 0}

-- This 2D array stores sprite IDs for the turtle shell animations.
-- Each shell is a made up of 4 sprites in a 2x2 grid.
local shellSprites = {{0,1,6,7}, {2,3,8,9}}

local speed = 100;

local time = 0
local frame = 1

-- The Init() method is part of the game's lifecycle and called a game
-- starts. We are going to use this method to configure the DisplayChip,
-- ScreenBufferChip and also draw fonts into the background layer.
function Init()

	-- Here we are starting by changing the background color and telling
	-- the DisplayChip to wrap.
	apiBridge:ChangeBackgroundColor(32)

	-- Here we are rebuilding the screen buffer so we can draw tile and
	-- fonts to it. This will cut down on our draw calls.
	apiBridge:RebuildScreenBuffer()

	-- With the ScreenBuffer ready, we can now draw fonts into it. Here
	-- we are creating two new labels to display under our demo sprites.
	apiBridge:DrawTileText("Sprite Test", 1, 1, "large-font", 0)
	apiBridge:DrawTileText("Position Wrap Test", 1, 6, "large-font", 0)

end

-- The Update() method is part of the game's life cycle. The engine
-- calls Update() on every frame before the Draw() method. It accepts
-- one argument, timeDelta, which is the difference in milliseconds
-- since the last frame. We are going to keep track of time to sync
-- up our sprite animation as well as move the sprites across the screen.
function Update(timeDelta)
	
	-- We are going to move the sprite positions by calculating the speed by 
	-- the timeDelata. We can then add this to the x or y position of our sprite
	-- vector.
	shellAPos.x = shellAPos.x + (speed * timeDelta)
	shellBPos.y = shellBPos.y + (speed * timeDelta)


	-- We are going to keep track of the time by adding timeDelta to our time 
    -- field. We can then use this to tell if we should change our animation frame.
	time = time + timeDelta

	-- Here we'll determine when it's time to change the sprite frame.
	if(time > 0.09) then

		-- If time is past the frame we'll increase the frame number to advance the animation.
		frame = frame + 1
		
		-- We need to reset the frame number if it is greater than the number of frames.
		if(frame > #shellSprites) then
			frame = 1
		end

		-- Now we can reset time back to 0 to start tracking the next frame change.
		time = 0

	end

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and
-- is where all of our draw calls should go. We'll be using this to render each of
-- the sprites and font characters to the display.
function Draw()
	
	-- It's important to clear the display on each frame. There are two ways to do this. Here 
	-- we are going to use the DrawScreenBuffer() way to copy over the existing buffer and clear
	-- all of the previous pixel data.
	apiBridge:DrawScreenBuffer()

	-- Here we are going to draw the first example. The turtle shell is made up of 4 sprites.
	-- We'll draw each sprite out with a few pixels between them so you can see how they are
	-- put together.
	apiBridge:DrawSprite(0, 8, 24, false, false, true, 0)
	apiBridge:DrawSprite(1, 18, 24, false, false, true, 0)
	apiBridge:DrawSprite(6, 8, 34, false, false, true, 0)
	apiBridge:DrawSprite(7, 18, 34, false, false, true, 0)
	
	-- For the next two examples we'll use the DrawSprites() method which allows us to combine sprites together into 
	-- a single draw request. Each sprite still counts as a draw call but this simplifies drawing
	-- larger sprites in your game.
	apiBridge:DrawSprites(shellSprites[1], 32, 24, 2, false, false, true, 0)
	apiBridge:DrawSprites(shellSprites[frame], 54, 24, 2, false, false, true, 0)
	
	-- Here we are drawing a turtle shell along the x and y axis. We'll take advantage of the Display's wrap
	-- setting so that the turtle will appear on the opposite side of the screen even when the x or y
	-- position is out of bounds.
	local x = math.ceil(shellAPos.x)
	local y = math.ceil(shellAPos.y)
	apiBridge:DrawSprites(shellSprites[frame], x, y, 2, false, false, true, 0)
	apiBridge:DrawSpriteText("("..x..","..y..")", x, y + 20, "large-font", 0)
	
	-- The last thing we are going to do is draw text below each of our moving turtles so we can see the
	-- x and y position as they wrap around the display.
	x = math.ceil(shellBPos.x)
	y = math.ceil(shellBPos.y)
	apiBridge:DrawSprites(shellSprites[frame], x, y, 2, false, false, true, 0)
	apiBridge:DrawSpriteText("("..x..","..y..")", x, y + 20, "large-font", 0)

end
