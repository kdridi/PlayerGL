//
//  PLOpenGLView.m
//  PlayerGL
//
//  Created by Karim DRIDI on 30/04/13.
//  Copyright (c) 2013 Karim DRIDI. All rights reserved.
//

#import "PLOpenGLView.h"
#import "player.h"

#define LOG if(false) NSLog

@implementation PLOpenGLView

- (void)heartbeat
{
    if (true) {
//        LOG(@"PLOpenGLView << %@", NSStringFromSelector(_cmd));
        [self update];
//        LOG(@"PLOpenGLView >> %@", NSStringFromSelector(_cmd));
    }
}

+ (NSOpenGLPixelFormat*)initPixelFormat:(NSOpenGLPixelFormat*)pixelFormat
{
    if (pixelFormat == nil) {
        NSOpenGLPixelFormatAttribute attributes[] =	{
            NSOpenGLPFADoubleBuffer,
            NSOpenGLPFADepthSize, 12,
            NSOpenGLPFAStencilSize, 8,
            0
        };
        pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attributes];
    }
    return pixelFormat;
}

- (void)executeAndFlushBuffer:(BOOL)flush action:(void (^)(player* const))block
{
    NSOpenGLContext* context = [self openGLContext];
    if (context) {
        [context makeCurrentContext];
        block(player::instance());
        if (flush) {
            [context flushBuffer];
        }
    }
}

// /////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject
// /////////////////////////////////////////////////////////////////////////////
- (id)init
{
    LOG(@"NSObject << %@", NSStringFromSelector(_cmd));
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    LOG(@"NSObject >> %@", NSStringFromSelector(_cmd));
    return self;
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    LOG(@"NSObject << %@", NSStringFromSelector(_cmd));
    self = [super awakeAfterUsingCoder:aDecoder];
    if (self) {
        // Initialization code here.
    }
    LOG(@"NSObject >> %@", NSStringFromSelector(_cmd));
    return self;
}

- (void)awakeFromNib
{
    LOG(@"NSObject << %@", NSStringFromSelector(_cmd));
    [super awakeFromNib];
    [[self window] makeFirstResponder:self];
    [[self window] setAcceptsMouseMovedEvents:YES];
    LOG(@"NSObject >> %@", NSStringFromSelector(_cmd));
}

// /////////////////////////////////////////////////////////////////////////////
#pragma mark - NSView
// /////////////////////////////////////////////////////////////////////////////
- (void)mouseDown:(NSEvent *)theEvent
{
    LOG(@"NSResponder << %@", NSStringFromSelector(_cmd));
    [super mouseDown:theEvent];
    LOG(@"NSResponder >> %@", NSStringFromSelector(_cmd));
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
    LOG(@"NSResponder << %@", NSStringFromSelector(_cmd));
    [super rightMouseDown:theEvent];
    LOG(@"NSResponder >> %@", NSStringFromSelector(_cmd));
}

- (void)otherMouseDown:(NSEvent *)theEvent
{
    LOG(@"NSResponder << %@", NSStringFromSelector(_cmd));
    [super otherMouseDown:theEvent];
    LOG(@"NSResponder >> %@", NSStringFromSelector(_cmd));
}

- (void)mouseUp:(NSEvent *)theEvent
{
    LOG(@"NSResponder << %@", NSStringFromSelector(_cmd));
    [super mouseUp:theEvent];
    LOG(@"NSResponder >> %@", NSStringFromSelector(_cmd));
}

- (void)rightMouseUp:(NSEvent *)theEvent
{
    LOG(@"NSResponder << %@", NSStringFromSelector(_cmd));
    [super rightMouseUp:theEvent];
    LOG(@"NSResponder >> %@", NSStringFromSelector(_cmd));
}

- (void)otherMouseUp:(NSEvent *)theEvent
{
    LOG(@"NSResponder << %@", NSStringFromSelector(_cmd));
    [super otherMouseUp:theEvent];
    LOG(@"NSResponder >> %@", NSStringFromSelector(_cmd));
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    LOG(@"NSResponder << %@", NSStringFromSelector(_cmd));
    [super mouseMoved:theEvent];
    [self executeAndFlushBuffer:NO action:^(player *const player) {
        NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:self];
        player->mouse(location.x / [self frame].size.width, location.y / [self frame].size.height);
    }];
    LOG(@"NSResponder >> %@", NSStringFromSelector(_cmd));
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    LOG(@"NSResponder << %@", NSStringFromSelector(_cmd));
    [super mouseDragged:theEvent];
    LOG(@"NSResponder >> %@", NSStringFromSelector(_cmd));
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    LOG(@"NSResponder << %@", NSStringFromSelector(_cmd));
    [super scrollWheel:theEvent];
    LOG(@"NSResponder >> %@", NSStringFromSelector(_cmd));
}

- (void)rightMouseDragged:(NSEvent *)theEvent
{
    LOG(@"NSResponder << %@", NSStringFromSelector(_cmd));
    [super rightMouseDragged:theEvent];
    LOG(@"NSResponder >> %@", NSStringFromSelector(_cmd));
}

- (void)otherMouseDragged:(NSEvent *)theEvent
{
    LOG(@"NSResponder << %@", NSStringFromSelector(_cmd));
    [super otherMouseDragged:theEvent];
    LOG(@"NSResponder >> %@", NSStringFromSelector(_cmd));
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    LOG(@"NSResponder << %@", NSStringFromSelector(_cmd));
    [super mouseEntered:theEvent];
    LOG(@"NSResponder >> %@", NSStringFromSelector(_cmd));
}

- (void)mouseExited:(NSEvent *)theEvent
{
    LOG(@"NSResponder << %@", NSStringFromSelector(_cmd));
    [super mouseExited:theEvent];
    LOG(@"NSResponder >> %@", NSStringFromSelector(_cmd));
}

- (BOOL)acceptsFirstResponder
{
    LOG(@"NSResponder << %@", NSStringFromSelector(_cmd));
    BOOL result = [super acceptsFirstResponder];
    LOG(@"NSResponder >> %@", NSStringFromSelector(_cmd));
    return result;
}

- (BOOL)becomeFirstResponder
{
    LOG(@"NSResponder << %@", NSStringFromSelector(_cmd));
    BOOL result = [super becomeFirstResponder];
    LOG(@"NSResponder >> %@", NSStringFromSelector(_cmd));
    return result;
}

- (BOOL)resignFirstResponder
{
    LOG(@"NSResponder << %@", NSStringFromSelector(_cmd));
    BOOL result = [super resignFirstResponder];
    LOG(@"NSResponder >> %@", NSStringFromSelector(_cmd));
    return result;
}

// /////////////////////////////////////////////////////////////////////////////
#pragma mark - NSView
// /////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(NSRect)frameRect
{
    LOG(@"NSView << %@", NSStringFromSelector(_cmd));
    self = [self initWithFrame:frameRect pixelFormat:[PLOpenGLView initPixelFormat:nil]];
    if (self) {
        // Initialization code here.
    }
    LOG(@"NSView >> %@", NSStringFromSelector(_cmd));
    return self;
}

// /////////////////////////////////////////////////////////////////////////////
#pragma mark - NSOpenGLView
// /////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(NSRect)frameRect pixelFormat:(NSOpenGLPixelFormat*)format
{
    LOG(@"NSOpenGLView << %@", NSStringFromSelector(_cmd));
    self = [super initWithFrame:frameRect pixelFormat:[PLOpenGLView initPixelFormat:format]];
    if (self) {
        _initNSOpenGLContext = YES;
    }
    LOG(@"NSOpenGLView >> %@", NSStringFromSelector(_cmd));
    return self;
}

- (void)setOpenGLContext:(NSOpenGLContext*)context
{
    LOG(@"NSOpenGLView << %@", NSStringFromSelector(_cmd));
    [super setOpenGLContext:context];
    LOG(@"NSOpenGLView >> %@", NSStringFromSelector(_cmd));
}

- (NSOpenGLContext*)openGLContext
{
//    LOG(@"NSOpenGLView << %@", NSStringFromSelector(_cmd));
    NSOpenGLContext* context = [super openGLContext];
    if (_initNSOpenGLContext) {
        _initNSOpenGLContext = NO;
        {
            GLint interval = 1;
            [context setValues:&interval forParameter:NSOpenGLCPSwapInterval];
        }
        if (true) {
            CGLContextObj ctx = CGLGetCurrentContext();
            assert(CGLEnable(ctx, kCGLCEMPEngine) == kCGLNoError);
            assert(CGLEnable(ctx, kCGLCECrashOnRemovedFunctions) == kCGLNoError);
            assert(CGLEnable(ctx, kCGLCEDisplayListOptimization) == kCGLNoError);
            assert(CGLEnable(ctx, kCGLCERasterization) == kCGLNoError);
            assert(CGLEnable(ctx, kCGLCEStateValidation) == kCGLNoError);
            assert(CGLEnable(ctx, kCGLCESwapLimit) == kCGLNoError);
            assert(CGLDisable(ctx, kCGLCESwapRectangle) == kCGLNoError);
            assert(CGLDisable(ctx, kCGLCESurfaceBackingSize) == kCGLNoError);
        }
    }
//    LOG(@"NSOpenGLView >> %@", NSStringFromSelector(_cmd));
    return context;
}

- (void)clearGLContext
{
    LOG(@"NSOpenGLView << %@", NSStringFromSelector(_cmd));
    [super clearGLContext];
    LOG(@"NSOpenGLView >> %@", NSStringFromSelector(_cmd));
}

- (void)update
{
//    LOG(@"NSOpenGLView << %@", NSStringFromSelector(_cmd));
    [super update];
    [self executeAndFlushBuffer:YES action:^(player *const player) {
        player->update();
    }];
//    LOG(@"NSOpenGLView >> %@", NSStringFromSelector(_cmd));
}

- (void)reshape{
    LOG(@"NSOpenGLView << %@", NSStringFromSelector(_cmd));
    LOG(@"NSOpenGLView :: %@ frame %.02f x %.02f", NSStringFromSelector(_cmd), self.frame.size.width, self.frame.size.height);
    LOG(@"NSOpenGLView :: %@ bounds %.02f x %.02f", NSStringFromSelector(_cmd), self.bounds.size.width, self.bounds.size.height);
    [super reshape];
    [self executeAndFlushBuffer:NO action:^(player *const player) {
        player->reshape(self.bounds.size.width, self.bounds.size.height);
    }];
    LOG(@"NSOpenGLView >> %@", NSStringFromSelector(_cmd));
}

- (void)setPixelFormat:(NSOpenGLPixelFormat*)pixelFormat
{
    LOG(@"NSOpenGLView << %@", NSStringFromSelector(_cmd));
    [super setPixelFormat:pixelFormat];
    LOG(@"NSOpenGLView >> %@", NSStringFromSelector(_cmd));
}

- (NSOpenGLPixelFormat*)pixelFormat
{
    LOG(@"NSOpenGLView << %@", NSStringFromSelector(_cmd));
    NSOpenGLPixelFormat* format = [super pixelFormat];
    LOG(@"NSOpenGLView >> %@", NSStringFromSelector(_cmd));
    return format;
}

- (void)prepareOpenGL
{
    LOG(@"NSOpenGLView << %@", NSStringFromSelector(_cmd));
    [super prepareOpenGL];
    
    [self executeAndFlushBuffer:NO action:^(player *const player) {
        player->prepareOpenGL();
    }];

    NSTimer* timer = [NSTimer timerWithTimeInterval:1.0f / 120.0f
                                             target:self
                                           selector:@selector(heartbeat)
                                           userInfo:nil
                                            repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer
                                 forMode:NSDefaultRunLoopMode];
    
    [[NSRunLoop currentRunLoop] addTimer:timer
                                 forMode:NSEventTrackingRunLoopMode];
    



    LOG(@"NSOpenGLView >> %@", NSStringFromSelector(_cmd));
}

@end

std::string player::readFile(const char* name, const char* extension)
{
    auto nsstring = [](const char* value) -> NSString* {
        return value == nullptr ? nil : [NSString stringWithFormat:@"%s", value];
    };
    NSError* error;
    NSString* content = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:nsstring(name)
                                                                                  withExtension:nsstring(extension)]
                                                 encoding:NSUTF8StringEncoding error:&error];
    assert(error == nil);
    return content.UTF8String;
}
