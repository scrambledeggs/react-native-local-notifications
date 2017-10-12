//
//  RNLocalNotifications.h
//  RNLocalNotifications
//
//  Created by Jett Robin Andres on 12/10/2017.
//  Copyright © 2017 Scrambled Eggs Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTBridgeModule.h"
#import "RCTEventEmitter.h"

@interface RNLocalNotifications : RCTEventEmitter <RCTBridgeModule>
- (void)localNotifReceived: (UILocalNotification *)notification;
@end
