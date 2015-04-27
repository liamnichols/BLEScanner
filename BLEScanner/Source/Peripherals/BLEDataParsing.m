//
//  BLEDataParsing.m
//  BLEScanner
//
//  Created by Liam Nichols on 22/02/2015.
//  Copyright (c) 2015 Liam Nichols. All rights reserved.
//

#import "BLEDataParsing.h"

@implementation BLEDataParsing

+ (NSString *)hexStringWithRange:(NSRange)range fromData:(NSData *)data
{
    if (data.length >= NSMaxRange(range)) {
        
        Byte bytes[range.length];
        [data getBytes:&bytes range:range];
        
        if (bytes != NULL) {
            
            NSMutableString *hexString = [NSMutableString stringWithCapacity:sizeof(bytes)];
            for (int i = 0; i < sizeof(bytes); i++) {
                [hexString appendFormat:@"%02x", bytes[i]];
            }
            return [hexString copy];
        }
    }
    return nil;
}

@end
