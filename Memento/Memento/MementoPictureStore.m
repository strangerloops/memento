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
        allPictures = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)allPictures
{
    return allPictures;
}

- (void)addPicture:(MementoPicture *)p
{
    [[[MementoPictureStore sharedStore] allPictures] addObject:p];
}

// UICollectionViewDataSource protocol methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[MementoPictureStore sharedStore] allPictures] count];
}

@end
