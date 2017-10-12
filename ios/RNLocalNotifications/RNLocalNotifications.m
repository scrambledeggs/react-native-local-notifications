#import <UIKit/UIKit.h>
#import "RCTBridgeModule.h"
#import "RCTEventEmitter.h"

@interface RNLocalNotifications : RCTEventEmitter <RCTBridgeModule>
@end

@implementation RNLocalNotifications {
    bool hasListeners;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(createNotification:(NSInteger *)id text:(NSString *)text datetime:(NSString *)datetime sound:(NSString *)sound data:(NSString *)data)
{
    [self createAlarm:id text:text datetime:datetime sound:sound update:FALSE data:data];
};

RCT_EXPORT_METHOD(deleteNotification:(NSInteger *)id)
{
    [self deleteAlarm:id];
};

RCT_EXPORT_METHOD(updateNotification:(NSInteger *)id text:(NSString *)text datetime:(NSString *)datetime sound:(NSString *)sound data:(NSString *)data)
{
    [self createAlarm:id text:text datetime:datetime sound:sound update:TRUE data:data];
};

- (void)createAlarm:(NSInteger *)id text:(NSString *)text datetime:(NSString *)datetime sound:(NSString *)sound update:(Boolean *)update data:(NSString *)data {
    if(update){
        [self deleteAlarm:id];
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *fireDate = [dateFormat dateFromString:datetime];
    if ([[NSDate date]compare: fireDate] == NSOrderedAscending) { //only schedule items in the future!
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = fireDate;
        if(![sound isEqualToString:@""] && ![sound isEqualToString:@"silence"]){
            notification.soundName = @"alarm.caf";
        }
        else {
            notification.soundName = @"silence.caf";
        }
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = text;
        notification.alertAction = @"Open";
        int a = ((int)[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
        notification.applicationIconBadgeNumber = a;
        NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
        [md setValue:[NSNumber numberWithInteger:id] forKey:@"id"];
        [md setValue:text forKey:@"text"];
        [md setValue:datetime forKey:@"datetime"];
        [md setValue:sound forKey:@"sound"];
        [md setValue:data forKey:@"data"];

        notification.userInfo = md;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (void)deleteAlarm:(NSInteger *)id {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    for (UILocalNotification * notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSMutableDictionary *md = [notification userInfo];
        if ([[md valueForKey:@"id"] integerValue] == [[NSNumber numberWithInteger:id] integerValue]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

//Override methods

// Will be called when this module's first listener is added.
-(void)startObserving {
    hasListeners = YES;
    // Set up any upstream listeners or background tasks as necessary
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving {
    hasListeners = NO;
    // Remove upstream listeners, stop unnecessary background tasks
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"LocalNotifReceived"];
}

- (void)localNotifReceived: (UILocalNotification *)notification {
    if (hasListeners) {
        [self sendEventWithName:@"LocalNotifReceived" body:notification.userInfo[@"data"]];
    }
}

@end
