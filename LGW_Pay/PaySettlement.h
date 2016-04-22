//
//  PaySettlement.h
//  LGW_Pay
//
//  Created by Lilong on 16/4/21.
//  Copyright © 2016年 第七代目. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PaySettlement : NSObject

// WechatPay
+ (void)payForWechatWithDict:(NSDictionary *)dict;

// AliPay
+ (void)payForAliPayWithDict:(NSDictionary *)dict;
@end



/*
集成 微信sdk
 CoreTelephony.framework
 libsqlite3.0.tbd
 libc++.tbd
 libz.tbd
 SystemConfiguration.framework
*/
/*
  集成  支付宝sdk
  AlipaySDK.bundle
  AlipaySDK.framework
 
  SystemConfiguration.framework
  libc++.tbd
  libz.tbd
  CoreTelephony.framework
  QuartzCore.framework
  CoreText.framework
  CoreGraphics.framework
  UIKit.framework
  Foundation.framework
  CFNetwork.framework
  CoreMotion.framework
*/