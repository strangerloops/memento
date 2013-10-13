//
//  MementoPictureStore.h
//  Memento
//
//  Created by   on 10/12/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MementoPicture.h"

@interface MementoPictureStore : NSObject

@property (readonly, strong, nonatomic) NSMutableArray *allPictures;
@property (readonly, strong, nonatomic) NSMutableArray *allThumbnails;

+ (MementoPictureStore *)sharedStore;

- (void)addPicture:(UIImage *)p;
- (void)addThumbnail:(UIImage *)t;

@end
