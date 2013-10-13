//
//  MementoPhotoViewController.m
//  Memento
//
//  Created by Dan Mundy on 10/13/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import "MementoPhotoViewController.h"
#import "MementoPictureStore.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <ImageIO/ImageIO.h>

@interface MementoPhotoViewController ()

@end

@implementation MementoPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPhoto:(UIImage *)photo andIndex:(NSInteger)index {
    self = [self initWithNibName:nil bundle:nil];
    [self setPhoto:photo];
    [self setIndex:index];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self photoView] setImage:[self photo]];
    [[[self photoView] layer] setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)takeMeThere:(id)sender {
    
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        MementoLocationCoordinate2D *mLocation = [[[MementoPictureStore sharedStore] allLocations] objectAtIndex:[self index]];
        NSLog(@"indexpath: %d", [self index]);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:mLocation->location addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"My Place"];
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
}

@end
