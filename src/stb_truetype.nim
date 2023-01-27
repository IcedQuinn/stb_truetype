import unicode

when defined(windows) and defined(vcc):
  {.pragma: stbcall, stdcall.}
else:
  {.pragma: stbcall, cdecl.}

{.compile: "stb_truetype.c".}

type
  stbttBuf = object
    data: ptr cuchar
    cursor: cint
    size: cint

  FontInfo* = ref object
    userData: pointer
    data: ptr cuchar
    fontStart: ptr cint
    numGlyphs: cint
    loca, head, glyf, hhea, hmtx, kern, gpos, svg: cint
    indexMap: cint
    indexToLocFormat: cint
    cff, charstrings, gsubrs, subrs, fontdicts, fdselect: stbttBuf

proc stbtt_InitFont(
  fontInfo: FontInfo,
  buffer: ptr cuchar,
  offset: cint
) {.importc: "stbtt_InitFont", stbcall.}

proc initFont*(buffer: string): FontInfo =
  result = FontInfo()
  stbtt_InitFont(
    result,
    cast[ptr cuchar](buffer[0].unsafeAddr),
    0
  )

proc stbtt_FindGlyphIndex(
  fontInfo: FontInfo,
  unicodeCodepoint: cint
): cint {.importc: "stbtt_FindGlyphIndex", stbcall.}

proc findGlyphIndex*(fontInfo: FontInfo, rune: Rune): uint16 =
  result = stbtt_FindGlyphIndex(fontInfo, rune.cint).uint16

proc stbtt_GetFontVMetrics(
  fontInfo: FontInfo,
  ascent, descent, lineGap: ptr cint
) {.importc: "stbtt_GetFontVMetrics", stbcall.}

proc getFontVMetrics*(fontInfo: FontInfo, ascent, descent, lineGap: var cint) =
  stbtt_GetFontVMetrics(fontInfo, ascent.addr, descent.addr, lineGap.addr)

proc stbtt_GetCodepointHMetrics(
  fontInfo: FontInfo,
  codepoint: cint,
  advanceWidth, leftSideBearing: ptr cint
) {.importc: "stbtt_GetCodepointHMetrics", stbcall.}

proc getCodepointHMetrics*(fontInfo: FontInfo, rune: Rune, advanceWidth, leftSideBearing: var cint) =
  stbtt_GetCodepointHMetrics(fontInfo, rune.cint, advanceWidth.addr, leftSideBearing.addr)

proc stbtt_GetCodepointKernAdvance(
  fontInfo: FontInfo,
  ch1, ch2: cint
): cint {.importc: "stbtt_GetCodepointKernAdvance", stbcall.}

proc getCodepointKernAdvance*(fontInfo: FontInfo, left, right: Rune): cint =
  stbtt_GetCodepointKernAdvance(fontInfo, left.cint, right.cint)

proc stbtt_FreeBitmap(bitmap: cstring, userdata: pointer) {.importc: "stbtt_FreeBitmap", stbcall.}

proc freeBitmap*(bitmap: cstring, pointer, userdata: pointer) =
   stbtt_FreeBitmap(bitmap, userdata)

proc stbtt_GetCodepointBox(info: FontInfo, codepoint: cint, x0, y0, x1, y1: ptr cint): cint {.importc: "stbtt_GetCodepointBox", stbcall.}

proc getCodepointBox*(info: FontInfo, codepoint: Rune, x0, y0, x1, y1: var cint): cint =
   return stbtt_GetCodepointBox(info, codepoint.cint, x0.addr, y0.addr, x1.addr, y1.addr)

proc stbtt_GetCodepointBitmapBox(font: FontInfo, codepoint: cint, scale_x, scale_y: cfloat, ix0, iy0, ix1, iy1: ptr cint): cstring {.importc: "stbtt_GetCodepointBitmapBox", stbcall.}

proc getCodepointBitmapBox*(font: FontInfo, codepoint: Rune, scale_x, scale_y: cfloat, ix0, iy0, ix1, iy1: var cint): cstring =
   stbtt_GetCodepointBitmapBox(font, codepoint.cint, scale_x, scale_y, ix0.addr, iy0.addr, ix1.addr, iy1.addr)

proc stbtt_GetCodepointBitmapBoxSubpixel(font: FontInfo, codepoint: cint, scale_x, scale_y: cfloat, ix0, iy0, ix1, iy1: ptr cint): cstring {.importc: "stbtt_GetCodepointBitmapBoxSubpixel", stbcall.}

proc getCodepointBitmapBoxSubpixel*(font: FontInfo, codepoint: Rune, scale_x, scale_y: cfloat, ix0, iy0, ix1, iy1: var cint): cstring =
   stbtt_GetCodepointBitmapBoxSubpixel(font, codepoint.cint, scale_x, scale_y, ix0.addr, iy0.addr, ix1.addr, iy1.addr)

proc stbtt_GetCodepointBitmapBoxSubpixel(font: FontInfo, codepoint: cint, scale_x, scale_y, shift_x, shift_y: cfloat, ix0, iy0, ix1, iy1: ptr cint): cstring {.importc: "stbtt_GetCodepointBitmapBoxSubpixel", stbcall.}

proc getCodepointBitmapBoxSubpixel*(font: FontInfo, codepoint: Rune, scale_x, scale_y, shift_x, shift_y: cfloat, ix0, iy0, ix1, iy1: var cint): cstring =
   return stbtt_GetCodepointBitmapBoxSubpixel(font, codepoint.cint, scale_x, scale_y, shift_x, shift_y, ix0.addr, iy0.addr, ix1.addr, iy1.addr)

proc stbtt_ScaleForPixelHeight(info: FontInfo, pixels: cfloat): cfloat {.importc: "stbtt_ScaleForPixelHeight", stbcall.}
proc stbtt_ScaleForMappingEmToPixels(info: FontInfo, pixels: cfloat): cfloat {.importc: "stbtt_ScaleForMappingEmToPixels", stbcall.}

proc scaleForPixelHeight*(info: FontInfo, pixels: cfloat): cfloat =
   return stbtt_ScaleForPixelHeight(info, pixels)

proc scaleForMappingEmToPixels*(info: FontInfo, pixels: cfloat): cfloat =
   return stbtt_ScaleForMappingEmToPixels(info, pixels)

# this is not a mistake; out_* are not written to, you pass in previously calculated results there
proc stbtt_MakeCodepointBitmap(info: FontInfo, output: cstring, out_w, out_h, out_stride: cint, scale_x, scale_y: cfloat, codepoint: cint) {.importc: "stbtt_MakeCodepointBitmap", stbcall.}
proc stbtt_MakeCodepointBitmapSubpixel(info: cstring, output: cstring, out_w, out_h, out_stride: cint, scale_x, scale_y, shift_x, shift_y: cfloat, codepoint: cint) {.importc: "stbtt_MakeCodepointBitmapSubpixel", stbcall.}

proc makeCodepointBitmap*(info: FontInfo, output: cstring, out_w, out_h, out_stride: cint, scale_x, scale_y: cfloat, codepoint: cint) =
   stbtt_MakeCodepointBitmap(info, output, out_w, out_h, out_stride, scale_x, scale_y, codepoint)

proc makeCodepointBitmapSubpixel*(info: cstring, output: cstring, out_w, out_h, out_stride: cint, scale_x, scale_y, shift_x, shift_y: cfloat, codepoint: cint) =
   stbtt_MakeCodepointBitmapSubpixel(info, output, out_w, out_h, out_stride, scale_x, scale_y, shift_x, shift_y, codepoint)

