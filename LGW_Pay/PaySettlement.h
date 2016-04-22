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
  设置一下search paths
  build setting ->搜索search path，然后你懂的
 
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

/*
 集成 银联支付
 
 ①    支持纯无卡交易静态库，以下简称UPPayPlugin，包含文件： (本demo)
 
 UPPayPlugin.h
 UPPayPluginDelegate.h
 libUPPayPlugin.a
 
 QuartzCore.framework
 AudioToolbox.framework
 
 ②    支持纯无卡交易和VIPOS音频口支付静态库,以下简称UPPayPluginPro，包含文件：

 UPPayPluginPro.h
 UPPayPluginDelegate.h
 libUPPayPluginPro.a
 
 QuartzCore.framework
 Security.framework
*/