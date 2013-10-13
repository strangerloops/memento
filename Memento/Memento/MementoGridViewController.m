//
//  MementoTimeViewController.m
//  Memento
//
//  Created by   on 10/12/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import "MementoGridViewController.h"
#import "MementoPictureStore.h"

@implementation MementoGridViewController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    NSBundle *appBundle = [NSBundle mainBundle];
    self = [super initWithNibName:@"MementoGridViewController" bundle:appBundle];
    if (self){
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Photos"];
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

// UICollectionViewDataSource protocol methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[[MementoPictureStore sharedStore] allThumbnails] objectAtIndex:[indexPath row]]];
    [[cell contentView] addSubview:imageView];
    NSLog(@"%d", [[[MementoPictureStore sharedStore] allThumbnails] count]);
    [cell setContentMode:UIViewContentModeScaleAspectFill];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[MementoPictureStore sharedStore] allThumbnails] count];
}

@end
