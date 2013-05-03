//
//  PLOpenGLView.m
//  PlayerGL
//
//  Created by Karim DRIDI on 30/04/13.
//  Copyright (c) 2013 Karim DRIDI. All rights reserved.
//

#import "PGLOpenGLView.h"

#import <player/factory.h>


static std::unique_ptr<player::commons::engine> engine(nullptr);

#import <player/commons/ticker.h>

@implementation PGLOpenGLView

- (void)heartbeat
{
    [self update];
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

- (void)executeAndFlushBuffer:(BOOL)flush action:(void (^)())block
{
    NSOpenGLContext* context = [self openGLContext];
    if (context)
    {
        [context makeCurrentContext];
        block();
        if (flush)
        {
            [context flushBuffer];
        }
    }
}

// /////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject
// /////////////////////////////////////////////////////////////////////////////
- (void)awakeFromNib
{
    [super awakeFromNib];
    [[self window] makeFirstResponder:self];
    [[self window] setAcceptsMouseMovedEvents:YES];
}

// /////////////////////////////////////////////////////////////////////////////
#pragma mark - NSView
// /////////////////////////////////////////////////////////////////////////////
- (void)mouseMoved:(NSEvent *)theEvent
{
    [super mouseMoved:theEvent];
    [self executeAndFlushBuffer:NO action:^()
    {
        NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:self];
        engine->mouse(location.x / [self frame].size.width, location.y / [self frame].size.height);
    }];
}

// /////////////////////////////////////////////////////////////////////////////
#pragma mark - NSView
// /////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(NSRect)frameRect
{
    return [self initWithFrame:frameRect pixelFormat:[PGLOpenGLView initPixelFormat:nil]];
}

// /////////////////////////////////////////////////////////////////////////////
#pragma mark - NSOpenGLView
// /////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(NSRect)frameRect pixelFormat:(NSOpenGLPixelFormat*)format
{
    self = [super initWithFrame:frameRect pixelFormat:[PGLOpenGLView initPixelFormat:format]];
    if (self)
    {
        _initNSOpenGLContext = YES;
    }
    return self;
}

- (NSOpenGLContext*)openGLContext
{
    NSOpenGLContext* context = [super openGLContext];
    if (_initNSOpenGLContext)
    {
        _initNSOpenGLContext = NO;
        {
            GLint interval = 1;
            [context setValues:&interval forParameter:NSOpenGLCPSwapInterval];
        }
        if (true)
        {
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
    return context;
}

- (void)update
{
    [super update];
    [self executeAndFlushBuffer:YES action:^()
    {
        static player::commons::ticker ticker(1000);
        static float previous = ticker.tick();
        
        float next = ticker.tick();
        engine->update(next - previous);
        engine->draw();
        previous = next;
    }];
}

- (void)reshape
{
    [super reshape];
    [self executeAndFlushBuffer:NO action:^()
    {
        engine->reshape(self.bounds.size.width, self.bounds.size.height);
    }];
}

- (void)prepareOpenGL
{
    [super prepareOpenGL];
    [self executeAndFlushBuffer:NO action:^()
    {
        engine = player::factory::create();
        engine->initialize();
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
}

@end
