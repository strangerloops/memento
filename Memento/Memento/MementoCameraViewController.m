//
//  MementoCameraViewController.m
//  Memento
//
//  Created by   on 10/12/13.
//  Copyright (c) 2013 strangerware. All rights reserved.
//

#import "MementoCameraViewController.h"

@implementation MementoCameraViewController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    NSBundle *appBundle = [NSBundle mainBundle];
    self = [super initWithNibName:@"MementoCameraViewController" bundle:appBundle];
    if (self){
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Camera"];
        
        //        UIImage *i = [UIImage imageNamed:@"Records.png"];
        //        [tbi setImage:i];
    }
    
    return self;
}

@end
