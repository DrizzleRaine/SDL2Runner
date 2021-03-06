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

-- The Font Demo illustrates how to render text to the DisplayChip.You'll learn how to display fronts as sprites
-- and how to also write font data into the ScreenBufferChip optimize draw calls.

-- This string represents the default characters fonts can display. Font sprites map to the ASCII
-- values of each character starting with an empty space at 32.
local lines = {" !\"#$%&'()*+,-",
			   "./0123456789:;<",
			   "=>?@ABCDEFGHIJK",
			   "LMNOPQRSTUVWXYZ",
			   "[\\]^_`abcdefgh",
			   "ijklmnopqrstuvw",
			   "xyz{|}~"}

-- We'll use this field to keep track of the current time that has elapsed since the game has started.
local time = 0

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw some text to the display.
function Init()

	-- Before we start, we need to set a background color and rebuild the ScreenBufferChip. The screen buffer
	-- allows us to draw our fonts into the background layer to save on draw calls.
	apiBridge:ChangeBackgroundColor(32)

	-- Pixel Vision 8 limits the number of sprites it can render to the display on each frame. This value is
	-- set to 64 by default. Since each font character is a single sprite it would be too expensive to draw 
	-- significant amounts of text at once. To get around this limitation, we are going to render the font 
	-- characters into the ScreenBufferChip which manages the background layer.

	-- This will display the title for the first demo. When calling DrawFontToBuffer you'll need to pass in
	-- the text to render, an X and Y position as well as the font name and finally the letter spacing.
	apiBridge:DrawFontToBuffer("large-font", 1, 1, "large-font", 0)
	
	-- Now we can loop through each of the supported characters and display them in the ScreenBufferChip.
	for i=1,#lines do
		apiBridge:DrawFontToBuffer(lines[i], 1, 2 + i, "large-font", 0)
	end

	-- Here we are going to draw the second font into the ScreenBufferChip. We'll change the letter space
	-- value to -4 since each character is 5 x 4 pixels instead of the default 8 x 8 pixels.
	apiBridge:DrawFontToBuffer("small-font", 1, 11, "small-font", -4)
	
	-- By default, the engine treats each character as an 8x8 sprite. When working with fonts that are smaller
	-- than this size, you can change the offset to combine characters into more optimized sprite groups. 
	
	-- Again we are going to draw all of the supported characters for the new font.
	for i=1,#lines do
		apiBridge:DrawFontToBuffer(lines[i], 1, 12 + i, "small-font", -4)
	end

end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame before
-- the Draw() method. It accepts one argument, timeDelta, which is the difference in milliseconds since
-- the last frame. We are going to use this timeDelta value to keep track of the total time the game has
-- been running.
function Update(timeDelta)
	time = time + timeDelta
end

-- The Draw() method is part of the game's life cycle. It is called after Update() and
-- is where all of our draw calls should go. We'll be using this to render font characters to the display.
function Draw()

	-- It's important to clear the display on each frame. There are two ways to do this. Here 
	-- we are going to use the DrawScreenBuffer() way to copy over the existing buffer and clear
	-- all of the previous pixel data.
	apiBridge:DrawScreenBuffer()

	-- For dynamic text, such as the time value we are tracking, it will be too expensive to update the 
	-- ScreenBufferChip on each frame. So, in this case, we are going to display the font characters as sprites.
	apiBridge:DrawFont("Dynamic Text ".. time, 1*8, 22 * 8, "large-font", 0)

	-- If you leave the demo running for long enough, eventually characters will start to disappear when the 
    -- DisplayChip hits the sprite limit. Rendering dynamic text in a game is very expensive and should be avoided as much as possible.

end
