//
//  BarcodeViewController.m
//  Check-In
//
//  Created by Timothy Roe Jr. on 1/5/16.
//
//

#import "BarcodeViewController.h"

@interface BarcodeViewController () {
    MTBBarcodeScanner *scanner;
    NSArray *data;
}
@property (strong, nonatomic) IBOutlet UIView *barcodeScannerView;

@end

@implementation BarcodeViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [self getDataFromParse];
    [super viewDidLoad];
    [self startScanning];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startScanning {
    scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.barcodeScannerView];
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            [scanner toggleTorch];
            [scanner startScanningWithResultBlock:^(NSArray *codes) {
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                NSLog(@"Found Code: %@", code.stringValue);
                [self getUserAndCheckInFromId:code.stringValue];
            }];
        } else {
            NSLog(@"User Denied Access To Camera");
        }
    }];
}

-(void)getUserAndCheckInFromId:(NSString *)idNumber {
    [scanner freezeCapture];
    PFQuery *query = [PFQuery queryWithClassName:@"sadies"];
    [query whereKey:@"studentId" equalTo:idNumber];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        object[@"checkIn"] = @"YES";
        NSLog(@"Checked In Student");
        NSString *studentName = object[@"studentname"];
        NSString *tableNumber = object[@"tableNumber"];
        if (!error) {
            UIImage *imageData = [self getPhotoFromMyWCSWithId:idNumber];
            self.image.image = imageData;
            self.nsm.text = studentName;
            self.table.text = tableNumber;
            [object saveInBackground];
            sleep(1);
            [scanner unfreezeCapture];
        }
        else {
            studentName = @"No ID Found";
            self.nsm.text = studentName;
            self.table.text = @"No Table Found";
            self.image.image = NULL;
            [scanner unfreezeCapture];
        }
    }];
}

-(UIImage *)getPhotoFromMyWCSWithId:(NSString *) idNumber{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://westernchristian.myschoolapp.com/ftpimages/808/user/large_user_%@.jpg?ver=1454045763184", idNumber]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

- (IBAction)flashlightAction:(id)sender {
    AVCaptureDevice *dev = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([dev isTorchAvailable] && [dev isTorchModeSupported:AVCaptureTorchModeOn]) {
        BOOL success = [dev lockForConfiguration:nil];
        if (success) {
            if ([dev isTorchActive]) {
                [dev setTorchMode:AVCaptureTorchModeOff];
                self.flashlightbutton.title = @"Turn on Flashlight";
            } else {
                [dev setTorchMode:AVCaptureTorchModeOn];
                self.flashlightbutton.title = @"Turn off Flashlight";
            }
        }
    }
}

-(void)getDataFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"hcParseData"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        data = objects;
    }];
    
}

-(UIView *)checkinView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    [view addSubview:imageView];
    return view;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
