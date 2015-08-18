#import <UIKit/UIKit.h>

/**
 *  All Around generic web view controller
 */
@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSURL *url;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)backBtnPressed:(id)sender;
- (IBAction)closeBtnPressed:(id)sender;

@end
