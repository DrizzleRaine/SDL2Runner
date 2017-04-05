// Microsoft Public License (MS-PL) - Copyright (C) Shawn Rakowski
// This file is subject to the terms and conditions defined in
// file 'LICENSE', which is part of this source code package.

#include <assert.h>
#include <stdlib.h>
#include "util.h"
#include "chip.h"
#include "spritechip.h"
#include "colorchip.h"

typedef struct spriteChip {
    chip base; // must be first
    int spriteWidth;
    int spriteHeight;
    int spritesLen;
    TextureData *sprites;
} spriteChip;

static void spriteChip_Destroy(SpriteChip self);
static void spriteChip_Init(SpriteChip self, GetChip getChip);
static void spriteChip_Dispose(SpriteChip self);

SpriteChip spriteChip_Create(int spriteWidth, int spriteHeight, TextureData spriteSheet)
{
    assert(spriteWidth > 0); 
    assert(spriteHeight > 0);
    assert(spriteSheet);

    SpriteChip self = NULL;

    self = (SpriteChip)calloc(1, sizeof(spriteChip));
    if (self == NULL)
        return NULL;

    strncpy(self->base.name, nameof(SpriteChip), sizeof(self->base.name) - 1);
    self->base.destroy = spriteChip_Destroy;
    self->base.init = spriteChip_Init;

    self->spriteWidth = spriteWidth;
    self->spriteHeight = spriteHeight;

    int textureWidth = textureData_GetWidth(spriteSheet);
    int cols = textureWidth / spriteWidth;
    
    int textureHeight = textureData_GetHeight(spriteSheet);
    int rows = textureHeight / spriteHeight;

    self->spritesLen = rows * cols;
    self->sprites = (TextureData *)calloc(self->spritesLen, sizeof(TextureData));
    if (self->sprites == NULL)
    {
        free(self);
        return NULL;
    }

    int spriteIdx = 0;
    for (int r = 0; r < rows; r++)
        for (int c = 0; c < cols; c++)
        {
            self->sprites[spriteIdx] = textureData_Create(spriteWidth, spriteHeight);
            int tIdx = 0;
            for (int y = (r * spriteHeight); y < (r * spriteHeight) + spriteHeight; y++)
                for (int x = (c * spriteWidth); x < (c * spriteWidth) + spriteWidth; x++)
                {
                    int cIdx = (y * textureWidth) + x;
                    int val = textureData_GetPixelAt(spriteSheet, cIdx);
                    textureData_SetPixelAt(self->sprites[spriteIdx], tIdx, val);
                    tIdx++;
                }
            spriteIdx++;
        }


    return self;
}

static void spriteChip_Destroy(SpriteChip self)
{
    assert(self);
    spriteChip_Dispose(self);
    memset(self, 0, sizeof(spriteChip));
    free(self);
}

static void spriteChip_Init(SpriteChip self, GetChip getChip)
{
    assert(self);
    assert(getChip);
    //spriteChip_Dispose(self);

    //CartridgeChip cartridgeChip = (CartridgeChip)func_Invoke(getChip, nameof(CartridgeChip));
    //if (cartridgeChip == NULL)
    //    return;

    //// need colors for color refs from cartridge
    //ColorChip colorChip = (ColorChip)func_Invoke(getChip, nameof(ColorChip));
    //if (colorChip == NULL)
    //    return;

    //GetColorRef getColorRef = func_Create(colorChip, colorChip_FindColorRef);
    //self->sprites = cartridgeChip_GetSprites(cartridgeChip, 
    //    self->spriteWidth, self->spriteHeight, getColorRef, &self->spritesLen);
    //func_Destroy(getColorRef);
}

static void spriteChip_Dispose(SpriteChip self)
{
    assert(self);
    if (self->sprites != NULL)
    {
        for (int idx = 0; idx < self->spritesLen; idx++)
        {
            if (self->sprites[idx] == NULL)
                continue;

            textureData_Destroy(self->sprites[idx]);
            self->sprites[idx] = NULL;
        }
        self->spritesLen = 0;
    }
}

TextureData spriteChip_GetSprite(SpriteChip self, int id)
{
    assert(self);
    assert(id >= 0);
    if (self->sprites == NULL || id >= self->spritesLen)
        return NULL;
    return self->sprites[id];
}

int spriteChip_GetSpriteWidth(SpriteChip self)
{
    assert(self);
    return self->spriteWidth;
}

int spriteChip_GetSpriteHeight(SpriteChip self)
{
    assert(self);
    return self->spriteHeight;
}