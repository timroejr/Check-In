//
//  CheckedInViewBarcode.h
//  Check-In
//
//  Created by Timothy Roe Jr. on 1/5/16.
//
//

#import <UIKit/UIKit.h>

@interface CheckedInViewBarcode : UIView
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *studentName;

-(void)loadStudentInfoForId:(NSString *)studentId name:(NSString *)name tableAssignment:(NSString *)tableAssignment;

@end
