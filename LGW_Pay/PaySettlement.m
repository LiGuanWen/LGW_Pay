//
//  PaySettlement.m
//  LGW_Pay
//
//  Created by Lilong on 16/4/21.
//  Copyright © 2016年 第七代目. All rights reserved.
//

#import "PaySettlement.h"

//wechatPay
#import "WXApi.h"
//aliPay
#import <AlipaySDK/AlipaySDK.h>

@implementation PaySettlement


// WechatPay
+ (void)payForWechatWithDict:(NSDictionary *)dict{
//    //创建支付签名对象
//    payRequsestHandler *req = [[payRequsestHandler alloc] init];
//    //初始化支付签名对象
//    [req init:APP_ID mch_id:MCH_ID];
//    //设置密钥
//    [req setKey:PARTNER_ID];
    
//    NSMutableDictionary *dict = [req sendPay_demo];
    
    if(dict != nil){
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = @"Sign=WXPay";//[dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
        //日志输出
        NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    }else{
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器返回错误，未获取到json对象" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }
}

// AliPay
+ (void)payForAliPayWithDict:(NSDictionary *)dict{
    
    [[AlipaySDK defaultService] payOrder:dict[@"orderString"] fromScheme:dict[@"appScheme"] callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}




@end
