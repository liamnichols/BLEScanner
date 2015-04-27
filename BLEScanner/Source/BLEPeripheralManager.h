//
//  BLEPeripheralManager.h
//  BLEScanner
//
//  Created by Liam Nichols on 22/02/2015.
//  Copyright (c) 2015 Liam Nichols. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEPeripheralManager : NSObject

- (void)registerPeripheralClass:(Class)peripheralClass;

- (void)startScanning;

- (void)stopScanning;

@end
