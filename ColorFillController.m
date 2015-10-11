#import "ColorFillController.h"
#import <QuartzCore/QuartzCore.h>

@interface UIImage (Dominant)
- (UIColor *)dominantColor;
@end

struct pixel {
    unsigned char r, g, b, a;
};


@implementation UIImage (Dominant)
 
- (UIColor *)dominantColor
{
	NSUInteger red = 0;
	NSUInteger green = 0;
	NSUInteger blue = 0;
	struct pixel *pixels = (struct pixel *)calloc(1, self.size.width * self.size.height * sizeof(struct pixel));
	if (pixels != nil)
    {
		CGContextRef context = CGBitmapContextCreate((void*)pixels, self.size.width, self.size.height, 8, self.size.width * 4, CGImageGetColorSpace(self.CGImage), kCGImageAlphaPremultipliedLast);
		if (context != NULL) {
			CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), self.CGImage);
			NSUInteger numberOfPixels = self.size.width * self.size.height;
			for (int i=0; i<numberOfPixels; i++) {
				red += pixels[i].r;
				green += pixels[i].g;
				blue += pixels[i].b;
			}
			red /= numberOfPixels;
			green /= numberOfPixels;
			blue /= numberOfPixels;
			CGContextRelease(context);
		}
		free(pixels);
	}
	return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
}

@end

@implementation ColorFillController

//Shared Instance
+(instancetype)sharedInstance {
	static dispatch_once_t pred;
	static ColorFillController *shared = nil;
	 
	dispatch_once(&pred, ^{
		shared = [[ColorFillController alloc] init];
	});
	return shared;
}

//Widget setup
-(void)setWindowAndImage:(SBWindow*)window image:(UIImage*)image {
	backgroundWindow = window;
	screenShot = image;
}

-(void)setupWidget {

	if (backgroundWindow) {

		if(screenShot)
		{
			NSLog(@"[ColorFill]Valid screenshot.");
			colorFillView = [[UIImageView alloc] initWithFrame:backgroundWindow.bounds];
			UIColor *dominantColor = [screenShot dominantColor];
			[colorFillView setBackgroundColor:dominantColor];
			[backgroundWindow addSubview:colorFillView];
		}	
	}
}

//Bye bye widget
-(void)deconstructWidget {

	if (colorFillView) {
		[colorFillView removeFromSuperview];
		[colorFillView release];
		colorFillView = nil;
	}
}

@end