//
//  MementoPictureStore.m
//  Memento
//
//  Created by   on 10/12/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import "MementoPictureStore.h"

@implementation MementoPictureStore

+ (MementoPictureStore *)sharedStore
{
    static MementoPictureStore *sharedStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[super allocWithZone:nil] init];
    });
    
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if(self){
        _allPictures = [[NSMutableArray alloc] init];
        _allThumbnails = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addPicture:(UIImage *)p
{
    [[[MementoPictureStore sharedStore] allPictures] addObject:p];
}

- (void)addThumbnail:(UIImage *)t
{
    [[[MementoPictureStore sharedStore] allThumbnails] addObject:t];
}

@end
