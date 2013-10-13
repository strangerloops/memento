//
//  MementoTimeViewController.m
//  Memento
//
//  Created by   on 10/12/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import "MementoGridViewController.h"
#import "MementoPictureStore.h"
#import "MementoPhotoViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>
#import <CoreLocation/CoreLocation.h>

@implementation MementoGridViewController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    NSBundle *appBundle = [NSBundle mainBundle];
    self = [super initWithNibName:@"MementoGridViewController" bundle:appBundle];
    if (self){
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Memento"];
        locationManager = [CLLocationManager new];
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    
    return self;
}

- (void)viewDidLoad {
    // Set up the grid
    
    [gridView setDataSource:self];
    [gridView setDelegate:self];
    [gridView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [gridView setCollectionViewLayout:flowLayout];
    
    [gridView setBackgroundColor:[UIColor whiteColor]];
    
    // Set up the navigation bar
    
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showCameraMenu:)]];
    [[self navigationItem] setTitle:@"Photos"];
}

- (void)viewWillAppear:(BOOL)animated
{
    // iterate through sharedstore's array of pictures, display
    [gridView reloadData];
    NSLog(@"Data was reloaded apparently", nil);
}

- (void)showCameraMenu:(id)sender {
    // Show an action sheet with three options
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a photo", @"Choose existing photo", @"Use last photo taken", nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    [actionSheet showInView:[self view]];
}

// UIActionSheetDelegate protocol methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0: // Take a photo
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                [imagePicker setDelegate:self];
                [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                [imagePicker setMediaTypes:@[(NSString *) kUTTypeImage]];
                [imagePicker setAllowsEditing:NO];
                [self presentViewController:imagePicker
                                   animated:YES completion:nil];
                _newMedia = YES;
                
                [locationManager startUpdatingLocation]; // Begin polling location
            }
            break;
        case 1: // Choose existing photo
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
                imagePicker.allowsEditing = NO;
                [self presentViewController:imagePicker
                                   animated:YES completion:nil];
                _newMedia = NO;
            }
            break;
        case 2: // Use last photo taken
            break;
            
        default:
            break;
    }
}

// UIImagePickerControllerDelegate protocol methods

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        if (_newMedia){
            ALAssetsLibrary *lib = [ALAssetsLibrary new];
            void (^libBlock)(NSURL*,NSError*) = ^(NSURL *assetURL, NSError *error) {
                ALAssetsLibrary *al = [ALAssetsLibrary new];
                [al assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                    [[MementoPictureStore sharedStore] addPicture:image];
                    UIImage *thumbnail = [MementoGridViewController thumbnailOf:image];
                    [[MementoPictureStore sharedStore] addThumbnail:thumbnail];
                    CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
                    MementoLocationCoordinate2D *mLocation = [[MementoLocationCoordinate2D alloc] initWithLocation:location.coordinate];
                    [[MementoPictureStore sharedStore] addLocation:mLocation];
                    [gridView reloadData];
                    [self dismissViewControllerAnimated:YES completion:nil];
                } failureBlock:nil];
            };
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:info[UIImagePickerControllerMediaMetadata]];
            NSMutableDictionary *gps = [NSMutableDictionary new];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            if (_deviceLocation.coordinate.latitude < 0.0) {
                gps[(__bridge NSString *)kCGImagePropertyGPSLatitude] = [NSNumber numberWithFloat:-_deviceLocation.coordinate.latitude];
                gps[(__bridge NSString *)kCGImagePropertyGPSLatitudeRef] = @"S";
            } else {
                gps[(__bridge NSString *)kCGImagePropertyGPSLatitude] = [NSNumber numberWithFloat:_deviceLocation.coordinate.latitude];
                gps[(__bridge NSString *)kCGImagePropertyGPSLatitudeRef] = @"N";
            }
            if (_deviceLocation.coordinate.longitude < 0.0) {
                gps[(__bridge NSString *)kCGImagePropertyGPSLongitude] = [NSNumber numberWithFloat:-_deviceLocation.coordinate.longitude];
                gps[(__bridge NSString *)kCGImagePropertyGPSLongitudeRef] = @"W";
            } else {
                gps[(__bridge NSString *)kCGImagePropertyGPSLongitude] = [NSNumber numberWithFloat:_deviceLocation.coordinate.longitude];
                gps[(__bridge NSString *)kCGImagePropertyGPSLongitudeRef] = @"E";
            }
            df.dateFormat = @"yyyy:MM:dd";
            gps[(__bridge NSString *)kCGImagePropertyGPSDateStamp] = [df stringFromDate:[NSDate date]];
            df.dateFormat = @"HH:mm:ss";
            gps[(__bridge NSString *)kCGImagePropertyGPSTimeStamp] = [df stringFromDate:[NSDate date]];
            dict[(__bridge NSString *)kCGImagePropertyGPSDictionary] = gps;
            UIImage *img = info[UIImagePickerControllerEditedImage] ? info[UIImagePickerControllerEditedImage] : info[UIImagePickerControllerOriginalImage];
            [lib writeImageToSavedPhotosAlbum:img.CGImage metadata:dict completionBlock:libBlock];
        } else {
            ALAssetsLibrary *al = [ALAssetsLibrary new];
            [al assetForURL:info[UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
                UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                [[MementoPictureStore sharedStore] addPicture:image];
                UIImage *thumbnail = [MementoGridViewController thumbnailOf:image];
                [[MementoPictureStore sharedStore] addThumbnail:thumbnail];
                CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
                MementoLocationCoordinate2D *mLocation = [[MementoLocationCoordinate2D alloc] initWithLocation:location.coordinate];
                [[MementoPictureStore sharedStore] addLocation:mLocation];
                [self dismissViewControllerAnimated:YES completion:nil];
            } failureBlock:nil];
            return;
        }
        
        [locationManager stopUpdatingLocation];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// UICollectionViewDataSource protocol methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[[MementoPictureStore sharedStore] allThumbnails] objectAtIndex:[indexPath row]]];
    [[cell contentView] addSubview:imageView];
    NSLog(@"%lu", (unsigned long)[[[MementoPictureStore sharedStore] allThumbnails] count]);
    [cell setContentMode:UIViewContentModeScaleAspectFill];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[MementoPictureStore sharedStore] allThumbnails] count];
}

// UICollectionViewDelegate protocol methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MementoPhotoViewController *photoVC = [[MementoPhotoViewController alloc] initWithPhoto:[[[MementoPictureStore sharedStore] allPictures] objectAtIndex:[indexPath row]] andIndex:[indexPath row]];
    NSLog(@"%d", [indexPath row]);
    [[self navigationController] pushViewController:photoVC animated:YES];
}

// CLLocationManagerDelegate protocol methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self setDeviceLocation:[locations lastObject]];
}

// Class methods

+ (UIImage *)thumbnailOf:(UIImage *)image {
	// Create a thumbnail version of the image for the event object.
	CGSize size = image.size;
	CGSize croppedSize;
	CGFloat ratio = 100.0;
	CGFloat offsetX = 0.0;
	CGFloat offsetY = 0.0;
	
	// check the size of the image, we want to make it
	// a square with sides the size of the smallest dimension
	if (size.width > size.height) {
		offsetX = (size.height - size.width) / 2;
		croppedSize = CGSizeMake(size.height, size.height);
	} else {
		offsetY = (size.width - size.height) / 2;
		croppedSize = CGSizeMake(size.width, size.width);
	}
	
	// Crop the image before resize
	CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
	CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
	// Done cropping
	
	// Resize the image
	CGRect rect = CGRectMake(0.0, 0.0, ratio, ratio);
	
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 2.0);
	[[UIImage imageWithCGImage:imageRef] drawInRect:rect];
	UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	// Done Resizing
	
	return thumbnail;
}

@end
