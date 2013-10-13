//
//  MementoPhotoViewController.h
//  Memento
//
//  Created by Dan Mundy on 10/13/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MementoPhotoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) UIImage *photo;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (nonatomic) NSInteger index;

// Inits
- (id)initWithPhoto:(UIImage *)photo andIndex:(NSInteger)index;

// Instance methods
- (IBAction)takeMeThere:(id)sender;

@end
