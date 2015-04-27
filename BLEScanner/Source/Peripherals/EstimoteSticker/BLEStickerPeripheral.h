//
//  BLEStickerPeripheral.h
//  BLEScanner
//
//  Created by Liam Nichols on 22/02/2015.
//  Copyright (c) 2015 Liam Nichols. All rights reserved.
//

#import "BLEPeripheral.h"

@interface BLEStickerPeripheral : BLEPeripheral

@property (nonatomic, assign, readonly) uint8_t protocolVersion;

@property (nonatomic, copy, readonly) NSString *identifier;

@property (nonatomic, assign, readonly) uint8_t hardwareRevision;

@property (nonatomic, assign, readonly) uint8_t appRevision;

@property (nonatomic, assign, readonly) uint8_t bootRevision;



@property (nonatomic, assign, readonly) uint16_t temperature; // need to translate to degrees still



@property (nonatomic, assign, readonly) BOOL inMotion;

@property (nonatomic, copy, readonly) NSNumber *stressVoltage;

@property (nonatomic, copy, readonly) NSNumber *idleVoltage;



@property (nonatomic, assign, readonly) float accelerationX;

@property (nonatomic, assign, readonly) float accelerationY;

@property (nonatomic, assign, readonly) float accelerationZ;

@end
