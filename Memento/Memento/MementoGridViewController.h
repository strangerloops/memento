//
//  MementoTimeViewController.h
//  Memento
//
//  Created by   on 10/12/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class MementoCameraViewController;

@interface MementoGridViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate> {
    IBOutlet UICollectionView *gridView;
    CLLocationManager *locationManager;
}

@property BOOL newMedia;
@property (nonatomic) CLLocation *deviceLocation;

- (void)showCameraMenu:(id)sender;
+ (UIImage *)thumbnailOf:(UIImage *)image;

@end
