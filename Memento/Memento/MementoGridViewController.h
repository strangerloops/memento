//
//  MementoTimeViewController.h
//  Memento
//
//  Created by   on 10/12/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MementoGridViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate> {
    IBOutlet UICollectionView *gridView;
}

- (void)showCameraMenu:(id)sender;

@end
