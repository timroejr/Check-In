//
//  CheckedInViewBarcode.m
//  Check-In
//
//  Created by Timothy Roe Jr. on 1/5/16.
//
//

#import "CheckedInViewBarcode.h"

@implementation CheckedInViewBarcode

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)loadStudentInfoForId:(NSString *)studentId name:(NSString *)name {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://westernchristian.myschoolapp.com/ftpimages/808/user/thumb_user_%@.jpg", studentId]];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *imageToShow = [UIImage imageWithData:imageData];
    self.image.image = imageToShow;
    self.studentName.text = name;
}

@end
