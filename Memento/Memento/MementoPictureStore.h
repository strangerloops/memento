//
//  MementoPictureStore.h
//  Memento
//
//  Created by   on 10/12/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MementoPicture.h"

@interface MementoPictureStore : NSObject <UICollectionViewDataSource>
{
    NSMutableArray *allPictures;
}

+ (MementoPictureStore *)sharedStore;

- (NSMutableArray *)allPictures;
- (void)addPicture:(MementoPicture *)p;

@end
