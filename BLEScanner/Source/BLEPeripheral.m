//
//  BLEPeripheral.m
//  BLEScanner
//
//  Created by Liam Nichols on 22/02/2015.
//  Copyright (c) 2015 Liam Nichols. All rights reserved.
//

#import "BLEPeripheral-Private.h"

@implementation BLEPeripheral

- (instancetype)initWithIdentifier:(NSString *)identifier RSSI:(NSNumber *)RSSI
{
    self = [super init];
    if (self) {
        __internalIdentifier = identifier;
        _RSSI = RSSI;
    }
    return self;
}

//TODO: do something with RSSI.

#pragma mark - Subclassing

+ (BOOL)supportsAdvertismentData:(NSData *)data
{
    return NO;
}

+ (NSString *)uniqueIdentifierForAdvertismentData:(NSData *)data
{
    return nil;
}

- (void)receivedAdvertismentData:(NSData *)data
{
    
}

@end
