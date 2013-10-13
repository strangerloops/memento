//
//  MementoPictureStore.h
//  Memento
//
//  Created by   on 10/12/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MementoPicture.h"
#import <CoreLocation/CoreLocation.h>

// SORRYYYYYY
@interface MementoLocationCoordinate2D : NSObject {
    @public
    CLLocationCoordinate2D location;
}

- (id)initWithLocation:(CLLocationCoordinate2D)l;

@end


@interface MementoPictureStore : NSObject

@property (readonly, strong, nonatomic) NSMutableArray *allPictures;
@property (readonly, strong, nonatomic) NSMutableArray *allThumbnails;
@property (readonly, strong, nonatomic) NSMutableArray *allLocations;

+ (MementoPictureStore *)sharedStore;

- (void)addPicture:(UIImage *)p;
- (void)addThumbnail:(UIImage *)t;
- (void)addLocation:(MementoLocationCoordinate2D *)l;

@end
