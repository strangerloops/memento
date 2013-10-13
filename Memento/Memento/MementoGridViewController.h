//
//  MementoTimeViewController.h
//  Memento
//
//  Created by   on 10/12/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MementoCameraViewController;

@interface MementoGridViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate> {
    IBOutlet UICollectionView *gridView;
}

@property BOOL newMedia;
@property (strong, nonatomic) MementoCameraViewController *cameraVC;

- (void)showCameraMenu:(id)sender;
+ (UIImage *)thumbnailOf:(UIImage *)image;

@end
