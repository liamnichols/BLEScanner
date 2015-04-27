//
//  BLEPeripheralManager.m
//  BLEScanner
//
//  Created by Liam Nichols on 22/02/2015.
//  Copyright (c) 2015 Liam Nichols. All rights reserved.
//

#import "BLEPeripheralManager.h"
#import "BLEPeripheral-Private.h"
@import CoreBluetooth;

@interface BLEPeripheralManager () <CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) NSMutableArray *peripheralClasses;
@property (nonatomic, strong) NSMutableDictionary *peripherals;

@property (nonatomic, assign) BOOL shouldScan;

@end

@implementation BLEPeripheralManager

+ (dispatch_queue_t)centralManagerQueue
{
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.liamnichols.BLEScanner.centeralManagerQueue", 0);
    });
    return queue;
}

+ (NSDictionary *)centralManagerOptions
{
    static NSDictionary *options = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        options = @{
            
        };
    });
    return options;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // should scan just yet.
        self.shouldScan = NO;
        
        // somewhere to store all our peripheral subclasses.
        self.peripheralClasses = [NSMutableArray array];
        
        // somewhere to store all our peripherals.
        self.peripherals = [NSMutableDictionary dictionary];
        
        // load the central manager.
        dispatch_queue_t queue = [[self class] centralManagerQueue];
        NSDictionary *options = [[self class] centralManagerOptions];
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:queue options:options];
    }
    return self;
}

#pragma mark - Registering different types of peripherals

- (void)registerPeripheralClass:(Class)peripheralClass
{
    Class baseClass = [BLEPeripheral class];
    NSAssert([peripheralClass isSubclassOfClass:baseClass], @"Peripheral classes must inherit from the %@ class.", NSStringFromClass(baseClass));
    
    // add to our peripheral classes array.
    if ([peripheralClass isSubclassOfClass:baseClass]) {
        [self.peripheralClasses addObject:peripheralClass];
    }
}

#pragma mark - Starting/Stopping scan

- (void)startScanning
{
    if (!self.shouldScan) {
        
        // remove any previously stored peripherals
        [self.peripherals removeAllObjects];
        
        // flag us as should scan
        self.shouldScan = YES;
        
        // if the central manager is ready, start scanning.
        if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
            [self _beginCenteralManagerScan];
        } else {
            NSLog(@"scanning will start when centeral manager state recieves powered on.");
        }
    }
}

- (void)stopScanning
{
    self.shouldScan = NO;
    [self _endCenteralManagerScan];
}

- (void)_beginCenteralManagerScan
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.centralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @(YES) }];
}

- (void)_endCenteralManagerScan
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.centralManager stopScan];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // store our own state?
    if (self.centralManager.state == CBCentralManagerStatePoweredOn && self.shouldScan) {
        [self _beginCenteralManagerScan];
    } else if (self.shouldScan) {
        [self _endCenteralManagerScan];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)dictionary RSSI:(NSNumber *)RSSI
{
    // get the advertisment data and the class registered to support it.
    NSData *advertismentData = dictionary[CBAdvertisementDataManufacturerDataKey];
    Class blePeripheralClass = [self classOfRegisteredPeripheralSupportingAdvertismentData:advertismentData];
    
    // nothing has registered to suppport this class
    if (!blePeripheralClass) {
        return;
    }
    
    // get the identifier from the peripheral class
    NSString *identifier = [blePeripheralClass uniqueIdentifierForAdvertismentData:advertismentData];
    
    // we require an identifier to be returned
    if (!identifier) {
        return;
    }
    
    // append the class name to the identifier
    identifier = [NSString stringWithFormat:@"%@/%@", NSStringFromClass(blePeripheralClass), identifier];
    
    // if we already have a peripheral for this identifier then we don't need to verifiy the advertismentData.
    BLEPeripheral *blePeripheral = self.peripherals[identifier];
    
    // if we already have a peripheral with this info
    if (blePeripheral) {
        
        // just update the peripheral with the recieved data
        [blePeripheral receivedAdvertismentData:advertismentData];
        [blePeripheral setRSSI:RSSI];
    } else if (advertismentData != nil) {
        
        if (blePeripheralClass) {
            
            // create an instance of that class and pass it the mfr data.
            blePeripheral = [[blePeripheralClass alloc] initWithIdentifier:identifier RSSI:RSSI];
            [blePeripheral receivedAdvertismentData:advertismentData];
            
            // keep a reference of this peripheral
            self.peripherals[identifier] = blePeripheral;
        }
    }
    
    // set the last update date
    if (blePeripheral) {
        blePeripheral.lastUpdate = [NSDate date];
    }
    
    // TODO: do something with a delegate?
}

- (Class)classOfRegisteredPeripheralSupportingAdvertismentData:(NSData *)data
{
    __block Class class = nil;
    [self.peripheralClasses enumerateObjectsUsingBlock:^(Class peripheralClass, NSUInteger idx, BOOL *stop) {
        if ([peripheralClass supportsAdvertismentData:data]) {
            class = peripheralClass;
            *stop = YES;
        }
    }];
    return class;
}

@end
