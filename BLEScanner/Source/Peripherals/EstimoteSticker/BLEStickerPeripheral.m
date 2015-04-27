//
//  BLEStickerPeripheral.m
//  BLEScanner
//
//  Created by Liam Nichols on 22/02/2015.
//  Copyright (c) 2015 Liam Nichols. All rights reserved.
//

#import "BLEStickerPeripheral.h"
#import "BLEDataParsing.h"

static NSString * const BLEStickerPeripheralAdvertismentPrefix = @"5d01";

@implementation BLEStickerPeripheral

+ (BOOL)supportsAdvertismentData:(NSData *)data
{
    if (data.length > 4) {
        NSString *advertismentPrefix = [BLEDataParsing hexStringWithRange:NSMakeRange(0, 2) fromData:data];
        if (advertismentPrefix && [advertismentPrefix isEqualToString:BLEStickerPeripheralAdvertismentPrefix]) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)uniqueIdentifierForAdvertismentData:(NSData *)data
{
    return [BLEDataParsing hexStringWithRange:NSMakeRange(3, 8) fromData:data];
}

- (void)receivedAdvertismentData:(NSData *)data
{
    // we already know where to get our identifier from
    _identifier = [[self class] uniqueIdentifierForAdvertismentData:data];
    
    // get the protocol version
    uint8_t protocolVersion;
    [data getBytes:&protocolVersion range:NSMakeRange(2, sizeof(protocolVersion))];
    _protocolVersion = protocolVersion;
    
    // get the hardware revision
    uint8_t hardwareRevision;
    [data getBytes:&hardwareRevision range:NSMakeRange(11, sizeof(hardwareRevision))];
    _hardwareRevision = hardwareRevision;
    
    // get the boot and the app revision (same byte)
    uint8_t bootAndAppRevision;
    [data getBytes:&bootAndAppRevision range:NSMakeRange(12, sizeof(bootAndAppRevision))];
    if (bootAndAppRevision > INT8_MAX) {
        _bootRevision = bootAndAppRevision;
        _appRevision = 0;
    } else {
        _bootRevision = 0;
        _appRevision = bootAndAppRevision;
    }
    
    // get the temperature
    uint16_t temperature;
    [data getBytes:&temperature range:NSMakeRange(13, sizeof(temperature))];
    _temperature = temperature;
    
    // get the battery levels and motion state
    uint8_t voltageAndMotionState;
    [data getBytes:&voltageAndMotionState range:NSMakeRange(15, sizeof(voltageAndMotionState))];
    
    // x1xx xxxx - inMotion = YES
    // x0xx xxxx - inMotion = NO
    _inMotion = (voltageAndMotionState & (1 << 6)) != 0;
    // 1xxx xxxx - voltageIsStress = YES
    // 0xxx xxxx - voltageIsStress = NO
    BOOL voltageIsStress = (voltageAndMotionState & (1 << 7)) != 0;
    // xxxx 0000 - voltage is first 4 bits
    int8_t voltage = (voltageAndMotionState & 0x3F);
    float floatVoltage = (3.6035 / 128.0) * ((voltage * 2.0) + 1.0); // about right.. i don't do maths very well..
    // set the correct level depending on if we got stress or idle back
    if (voltageIsStress) {
        _stressVoltage = @(floatVoltage);
    } else {
        _idleVoltage = @(floatVoltage);
    }
    
    // get the x acceleration
    uint8_t accelerationX;
    [data getBytes:&accelerationX range:NSMakeRange(16, sizeof(accelerationX))];
    _accelerationX = (2000.0 / 128) * (int8_t)accelerationX; //must cast to signed int
    
    // get the y acceleration
    uint8_t accelerationY;
    [data getBytes:&accelerationY range:NSMakeRange(17, sizeof(accelerationY))];
    _accelerationY = (2000.0 / 128) * (int8_t)accelerationY; //must cast to signed int
    
    // get the z acceleration
    uint8_t accelerationZ;
    [data getBytes:&accelerationZ range:NSMakeRange(18, sizeof(accelerationZ))];
    _accelerationZ = (2000.0 / 128) * (int8_t)accelerationZ; //must cast to signed int
}

#pragma mark - Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p; identifier = %@; protocolVersion = %i; hardwareRevision = %i; inMotion = %@; temperature = %i>", NSStringFromClass([self class]), self, self.identifier, self.protocolVersion, self.hardwareRevision, self.inMotion ? @"YES" : @"NO", self.temperature];
}

@end
