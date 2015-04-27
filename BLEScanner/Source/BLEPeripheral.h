//
//  BLEPeripheral.h
//  BLEScanner
//
//  Created by Liam Nichols on 22/02/2015.
//  Copyright (c) 2015 Liam Nichols. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEPeripheral : NSObject

/// The last RSSI value of the reciever.
@property (nonatomic, strong, readonly) NSNumber *RSSI;

/// The date the peripheral was last updated.
@property (nonatomic, copy, readonly) NSDate *lastUpdate;

/// Used to determine if the peripheral supports the advertisment packet.
+ (BOOL)supportsAdvertismentData:(NSData *)data;

/// Used to idenfify a peripheral. This value should be unique per each peripheral. the return value must not be nil.
+ (NSString *)uniqueIdentifierForAdvertismentData:(NSData *)data;

/// Called whenever the BLEPeripheralManager receives new advertisment data for the receiver.
- (void)receivedAdvertismentData:(NSData *)data;

@end
