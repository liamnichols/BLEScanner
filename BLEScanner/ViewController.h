//
//  ViewController.h
//  BLEScanner
//
//  Created by Liam Nichols on 21/02/2015.
//  Copyright (c) 2015 Liam Nichols. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak) IBOutlet NSSegmentedControl *segmentedControl;
@property (weak) IBOutlet NSButton *scanButton;
@property (weak) IBOutlet NSTableView *tableView;

- (IBAction)segmentedControlSwitched:(id)sender;
- (IBAction)scanButtonPressed:(id)sender;

@end

