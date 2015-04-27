//
//  ViewController.m
//  BLEScanner
//
//  Created by Liam Nichols on 21/02/2015.
//  Copyright (c) 2015 Liam Nichols. All rights reserved.
//

#import "ViewController.h"
#import "BLEPeripheralManager.h"
#import "BLEStickerPeripheral.h"


@interface ViewController () <BLEPeripheralManagerDelegate>

@property (nonatomic, strong) BLEPeripheralManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.manager = [BLEPeripheralManager new];
    self.manager.delegate = self;
    [self.manager registerPeripheralClass:[BLEStickerPeripheral class]];
    [self.manager startScanning];
}

- (void)peripheralManager:(BLEPeripheralManager *)manager didUpdatePeripheral:(BLEPeripheral *)peripheral
{
    NSLog(@"didUpdatePeripheral: %@", peripheral);
}

@end
