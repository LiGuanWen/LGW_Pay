//
//  AppDelegate.m
//  LGW_Pay
//
//  Created by Lilong on 16/4/21.
//  Copyright © 2016年 第七代目. All rights reserved.
//

#import "AppDelegate.h"
// wechat
#import "WXApi.h"
//aliPay
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 微信支付
    [WXApi registerApp:@"wxf073589fe4d04a0b" withDescription:@"PPChe"];
    return YES;
}
#pragma mark - AppDelegate
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
     return  [WXApi handleOpenURL:url delegate:self];
}
// iOS 7,8
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // 跳转微信钱包进行支付，需要将微信钱包的支付结果回传给SDK
    if ([url.description hasPrefix:@"wxf073589fe4d04a0b://"]) {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    
    // 跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.absoluteString rangeOfString:@"LGW_Pay"].location != NSNotFound) {
        // 支付宝支付
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             
             if (resultDic) {
                 NSInteger statusCode = [resultDic[@"resultStatus"] integerValue];
                 
                 if (statusCode == 9000) { //success
                     [[NSNotificationCenter defaultCenter] postNotificationName:PaymentSuccess object:@{@"status":@"1"}];
                 }else{  //失败
                     [[NSNotificationCenter defaultCenter] postNotificationName:PaymentFail object:@{@"status":@"0"}];
                     UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alter show];
                 }
             }
             
         }];
        return YES;
    }else
    {
        return YES;
    }
    return YES;
}

// iOS 9
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    // 跳转微信钱包进行支付，需要将微信钱包的支付结果回传给SDK
    if ([url.description hasPrefix:@"wxf073589fe4d04a0b://"]) {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    // 跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.absoluteString rangeOfString:@"LGW_Pay"].location != NSNotFound) {
        // 支付宝支付
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             
             if (resultDic) {
                 NSInteger statusCode = [resultDic[@"resultStatus"] integerValue];
                 
                 if (statusCode == 9000) { //success
                     [[NSNotificationCenter defaultCenter] postNotificationName:PaymentSuccess object:@{@"status":@"1"}];
                 }else{  //失败
                     [[NSNotificationCenter defaultCenter] postNotificationName:PaymentFail object:@{@"status":@"0"}];
                     UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alter show];
                 }
             }
             
         }];
        return YES;
    }else
    {
        return YES;
    }

    return YES;
}

// 微信支付回调
-(void)onResp:(BaseResp*)resp
{
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:
                [[NSNotificationCenter defaultCenter] postNotificationName:PaymentSuccess object:@{@"status":@"1"}];
                break;
            default:
                [[NSNotificationCenter defaultCenter] postNotificationName:PaymentFail object:@{@"status":@"0"}];
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alter show];
                break;
        }
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
