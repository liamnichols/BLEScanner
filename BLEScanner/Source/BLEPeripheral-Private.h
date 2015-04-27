//
//  BLEPeripheral-Private.h
//  BLEScanner
//
//  Created by Liam Nichols on 22/02/2015.
//  Copyright (c) 2015 Liam Nichols. All rights reserved.
//

#ifndef BLEScanner_BLEPeripheral_Private_h
#define BLEScanner_BLEPeripheral_Private_h

#import "BLEPeripheral.h"

@interface BLEPeripheral ()

@property (nonatomic, strong) NSString *_internalIdentifier;
@property (nonatomic, strong) NSNumber *RSSI;
@property (nonatomic, copy) NSDate *lastUpdate;

- (instancetype)initWithIdentifier:(NSString *)identifier RSSI:(NSNumber *)RSSI;

@end

#endif
