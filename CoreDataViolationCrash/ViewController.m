//
//  ViewController.m
//  CoreDataViolationCrash
//
//  Created by Kentaro Matsumae on 2016/06/17.
//  Copyright © 2016年 kenmaz.net. All rights reserved.
//

#import "ViewController.h"
#import "MyEntity.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MyEntity fetch];
}

@end
