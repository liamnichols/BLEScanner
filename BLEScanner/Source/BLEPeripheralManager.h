//
//  BLEPeripheralManager.h
//  BLEScanner
//
//  Created by Liam Nichols on 22/02/2015.
//  Copyright (c) 2015 Liam Nichols. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BLEPeripheral;
@protocol BLEPeripheralManagerDelegate;

@interface BLEPeripheralManager : NSObject

- (void)registerPeripheralClass:(Class)peripheralClass;

- (void)startScanning;

- (void)stopScanning;

@property (nonatomic, weak) id<BLEPeripheralManagerDelegate> delegate;

@end

@protocol BLEPeripheralManagerDelegate <NSObject>

@optional

- (void)peripheralManagerDidStartScanning:(BLEPeripheralManager *)manager;

- (void)peripheralManagerDidStopScanning:(BLEPeripheralManager *)manager;

- (void)peripheralManager:(BLEPeripheralManager *)manager didUpdatePeripheral:(BLEPeripheral *)peripheral;

@end
