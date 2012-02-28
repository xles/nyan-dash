//
//  rainbow_nyanView.m
//  rainbow-nyan
//
//  Created by xles on 28-02-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "rainbow_nyanView.h"

@implementation rainbow_nyanView

static NSString * const MyModuleName = @"org.mirakulix.rainbow-nyan";

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self) 
    {
        ScreenSaverDefaults *defaults;
        
        defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
        
        // Register our default values
        [defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                    @"NO", @"DrawFilledShapes",
                                    @"NO", @"DrawOutlinedShapes",
                                    @"YES", @"DrawBoth",
                                    nil]];
        
        [self setAnimationTimeInterval:1/30.0];
    }
    
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    NSImage *image;
    NSRect myRect;
    NSSize mySize;
	
    image = [NSImage imageNamed:@"frame-000001.png"];
    
    mySize = [image size];
    
    myRect.origin.x = 0;
    myRect.origin.y = 0;
    myRect.size = mySize;
    
//    [image lockFocus];
    [image drawInRect:[self bounds] fromRect:myRect
            operation:NSCompositeCopy fraction:0.5];
//    [image unlockFocus];
}

- (BOOL)hasConfigureSheet
{
    return YES;
}

- (NSWindow*)configureSheet
{
    ScreenSaverDefaults *defaults;
    
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
    
    if (!configSheet)
    {
        if (![NSBundle loadNibNamed:@"ConfigureSheet" owner:self]) 
        {
            NSLog( @"Failed to load configure sheet." );
            NSBeep();
        }
    }
    
    [drawFilledShapesOption setState:[defaults 
                                      boolForKey:@"DrawFilledShapes"]];
    [drawOutlinedShapesOption setState:[defaults 
                                        boolForKey:@"DrawOutlinedShapes"]];
    [drawBothOption setState:[defaults boolForKey:@"DrawBoth"]];
    
    return configSheet;
}

- (IBAction)cancelClick:(id)sender
{
    [[NSApplication sharedApplication] endSheet:configSheet];
}
- (IBAction) okClick: (id)sender
{
    ScreenSaverDefaults *defaults;
    
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
    
    // Update our defaults
    [defaults setBool:[drawFilledShapesOption state] 
               forKey:@"DrawFilledShapes"];
    [defaults setBool:[drawOutlinedShapesOption state] 
               forKey:@"DrawOutlinedShapes"];
    [defaults setBool:[drawBothOption state] 
               forKey:@"DrawBoth"];
    
    // Save the settings to disk
    [defaults synchronize];
    
    // Close the sheet
    [[NSApplication sharedApplication] endSheet:configSheet];
}
@end
