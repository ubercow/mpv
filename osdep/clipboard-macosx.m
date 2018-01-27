/*
 * This file is part of mpv.
 *
 * mpv is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * mpv is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with mpv.  If not, see <http://www.gnu.org/licenses/>.
 */

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#include "osdep/clipboard.h"


void mp_clipboard_write_image(struct mp_image *img, struct mp_log *log)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];

    struct mp_image *res = convert_image(img, IMGFMT_RGBA, log);
    talloc_free(img);

    NSBitmapImageRep *imgRep = [[NSBitmapImageRep alloc]
        initWithBitmapDataPlanes:(res->planes)
        pixelsWide:(res->w)
        pixelsHigh:(res->h)
        bitsPerSample:8
        samplesPerPixel:4
        hasAlpha:YES
        isPlanar:NO
        colorSpaceName:NSDeviceRGBColorSpace
        bytesPerRow:0
        bitsPerPixel:0];

    NSImage *image = [[NSImage alloc] initWithCGImage:[imgRep CGImage] size:NSMakeSize(res->w,res->h)];

    NSArray *objs = @[image];

    [pasteboard clearContents];
    [pasteboard writeObjects:objs];

    [pool release];
    talloc_free(res);
}

void mp_clipboard_write_string(const char *contents, struct mp_log *log)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *stringContents = [[NSString alloc] initWithUTF8String:contents];
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    
    [pasteboard clearContents];
    [pasteboard setString:stringContents forType:NSPasteboardTypeString];
    [pool release];
}