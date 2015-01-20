#import <UIKit/UIKit.h>

@interface SBWindow : UIWindow
@end

@interface ColorFillController : UIViewController {
	
	SBWindow *backgroundWindow;
	UIImage *screenShot;
	UIImageView * colorFillView;
}

+(instancetype)sharedInstance;
-(void)setWindowAndImage:(SBWindow*)window image:(UIImage*)image;
-(void)setupWidget;
-(void)deconstructWidget;
@end