//
//  BarcodeViewController.h
//  Check-In
//
//  Created by Timothy Roe Jr. on 1/5/16.
//
//

#import <UIKit/UIKit.h>
#import "MTBBarcodeScanner.h"
#import "CustomIOSAlertView.h"
#import "CheckedInViewBarcode.h"
#import <Parse/Parse.h>

@interface BarcodeViewController : UIViewController <CustomIOSAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *flashlightbutton;
- (IBAction)flashlightAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *nsm;
@property (strong, nonatomic) IBOutlet UILabel *table;

-(void)getDataFromParse;

@end
