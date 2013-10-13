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
        [tbi setTitle:@"Timeline"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [gridView setDataSource:self];
    [gridView setDelegate:self];
    [gridView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(200, 200)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [gridView setCollectionViewLayout:flowLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    // iterate through sharedstore's array of pictures, display
    [gridView reloadData];
    NSLog(@"Data was reloaded apparently", nil);
}

// UICollectionViewDataSource protocol methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[[MementoPictureStore sharedStore] allPictures] objectAtIndex:[indexPath row]]];
    [[cell contentView] addSubview:imageView];
    NSLog(@"%d", [[[MementoPictureStore sharedStore] allPictures] count]);
    
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[MementoPictureStore sharedStore] allPictures] count];
}

@end
