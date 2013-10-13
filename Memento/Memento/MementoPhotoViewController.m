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
    
    MementoLocationCoordinate2D *mLocation =[[[MementoPictureStore sharedStore] allLocations] objectAtIndex:[self index]];
    [self setLocation:mLocation->location];
    
    [[self photoView] setImage:[self photo]];
    [[[self photoView] layer] setMasksToBounds:YES];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:_location.latitude longitude:_location.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
        [[self locationLabel] setText:[NSString stringWithFormat:@"%@, %@", [[placemarks firstObject] locality], [[placemarks firstObject] administrativeArea]]];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)takeMeThere:(id)sender {
    
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:[self location] addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"My Place"];
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
}

@end
