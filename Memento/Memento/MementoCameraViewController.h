//
//  MementoCameraViewController.h
//  Memento
//
//  Created by   on 10/12/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MementoCameraViewController : UIViewController <UIImagePickerControllerDelegate>

@property BOOL newMedia;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)useCamera:(id)sender;
- (IBAction)useCameraRoll:(id)sender;

@end
