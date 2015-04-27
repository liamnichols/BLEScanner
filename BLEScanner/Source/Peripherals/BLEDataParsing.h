//
//  BLEDataParsing.h
//  BLEScanner
//
//  Created by Liam Nichols on 22/02/2015.
//  Copyright (c) 2015 Liam Nichols. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEDataParsing : NSObject

+ (NSString *)hexStringWithRange:(NSRange)range fromData:(NSData *)data;

+ (int64_t)integerWithRange:(NSRange)range fromData:(NSData *)data;

@end
