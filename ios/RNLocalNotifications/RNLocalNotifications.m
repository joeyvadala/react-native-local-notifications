#import <UIKit/UIKit.h>
#import "RCTBridgeModule.h"
#import <UserNotifications/UserNotifications.h>

@interface RNLocalNotifications : NSObject <RCTBridgeModule>
@end

@implementation RNLocalNotifications

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(createNotification:(NSInteger *)id text:(NSString *)text datetime:(NSString *)datetime sound:(NSString *)sound repeatType:(NSString *)repeatType)
{
    [self createAlarm:id text:text datetime:datetime sound:sound update:FALSE repeatType:repeatType];
};

RCT_EXPORT_METHOD(deleteNotification:(NSInteger *)id)
{
    [self deleteAlarm:id];
};

RCT_EXPORT_METHOD(updateNotification:(NSInteger *)id text:(NSString *)text datetime:(NSString *)datetime sound:(NSString *)sound repeatType:(NSString *)repeatType)
{
    [self createAlarm:id text:text datetime:datetime sound:sound update:TRUE repeatType:repeatType];
};

- (void)createAlarm:(NSInteger *)id text:(NSString *)text datetime:(NSString *)datetime sound:(NSString *)sound update:(bool)update repeatType:(NSString *)repeatType {
    if (update) {
        [self deleteAlarm:id];
    }
//
//    // Rewritten to use UNUserNotificationCenter by Joseph Vadala 2.26.18
//
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
//
//    [center requestAuthorizationWithOptions:options
//                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
//                              if (!granted) {
//                                  NSLog(@"Something went wrong");
//                              }
//                          }];
//
//    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
//    content.title = @"She Reads Truth";
//    content.body = text;
//    content.sound = [UNNotificationSound defaultSound];
//
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSDate *fireDate = [dateFormat dateFromString:datetime];
//
//    // Temp hourly repeat for testing
//    // NSDateComponents *triggerDate = [[NSCalendar currentCalendar] components:NSCalendarUnitHour + NSCalendarUnitMinute + NSCalendarUnitSecond fromDate:fireDate];
//    NSDateComponents *triggerDate = [[NSCalendar currentCalendar] components:NSCalendarUnitMinute + NSCalendarUnitSecond fromDate:fireDate];
//
//    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:YES];
//
//    NSString *identifier = @"SRTLocalNotification";
//    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
//
//    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
//        if (error != nil) {
//            NSLog(@"Something went wrong: %@", error);
//        }
//    }];
    
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

        // Added by Joseph W Vadala on 11/20/2017
        // Made this the default because we need to make this work
        // Temp change to Minute to test
        notification.repeatInterval = NSCalendarUnitMinute;

        int a = ((int)[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
        notification.applicationIconBadgeNumber = a;
        NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
        [md setValue:[NSNumber numberWithInteger:id] forKey:@"id"];
        [md setValue:text forKey:@"text"];
        [md setValue:datetime forKey:@"datetime"];
        [md setValue:sound forKey:@"sound"];
        notification.userInfo = md;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (void)deleteAlarm:(NSInteger *)id {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
    for (UILocalNotification * notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithDictionary:[notification userInfo]];
        if ([[md valueForKey:@"id"] integerValue] == [[NSNumber numberWithInteger:id] integerValue]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

@end
