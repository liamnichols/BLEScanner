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
@property (nonatomic, strong) NSArray *sections;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // create an array of sections that the ui supports
    self.sections = @[
        @{
            @"title" : @"iBeacons",
            @"class" : [BLEPeripheral class], //TODO: iBeacon Support
            @"columns" : @[
                @"uuid",
                @"rssi"
            ]
        },
        @{
            @"title" : @"Estimote Stickers",
            @"class" : [BLEStickerPeripheral class],
            @"columns" : @[
                @"identifier",
                @"rssi"
            ]
         }
    ];
    
    // set the sections on the segmented control
    self.segmentedControl.segmentCount = self.sections.count;
    [self.sections enumerateObjectsUsingBlock:^(NSDictionary *section, NSUInteger idx, BOOL *stop) {
        [self.segmentedControl setLabel:section[@"title"] forSegment:idx];
    }];

    // create an instance of the manager
    self.manager = [BLEPeripheralManager new];
    self.manager.delegate = self;
    [self.sections enumerateObjectsUsingBlock:^(NSDictionary *section, NSUInteger idx, BOOL *stop) {
        [self.manager registerPeripheralClass:section[@"class"]];
    }];
    
    // update the tableView based on the default segment index
    [self segmentedControlSwitched:nil];
}

- (Class)peripheralClassAtSegmentIndex:(NSInteger)index
{
    return self.sections[index][@"class"];
}

#pragma mark - BLEPeripheralManagerDelegate

- (void)peripheralManager:(BLEPeripheralManager *)manager didUpdatePeripheral:(BLEPeripheral *)peripheral
{
    NSLog(@"didUpdatePeripheral: %@", peripheral);
}

#pragma mark - Actions

- (IBAction)segmentedControlSwitched:(id)sender
{
    NSDictionary *section = self.sections[self.segmentedControl.selectedSegment];
    
    // remove the old table columns
    [[self.tableView.tableColumns copy] enumerateObjectsUsingBlock:^(NSTableColumn *column, NSUInteger idx, BOOL *stop) {
        [self.tableView removeTableColumn:column];
    }];
    
    // add the new columns
    [section[@"columns"] enumerateObjectsUsingBlock:^(NSString *identifier, NSUInteger idx, BOOL *stop) {
        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:identifier];
        column.title = identifier;
        [self.tableView addTableColumn:column];
    }];
    
    // reload the tableView
    [self.tableView reloadData];
}

- (IBAction)scanButtonPressed:(id)sender
{
    if (self.scanButton.state == NSOffState) {
        self.scanButton.title = @"Stop Scanning";
        [self.manager startScanning];
    } else {
        self.scanButton.title = @"Start Scanning";
        [self.manager stopScanning];
    }
}

@end
