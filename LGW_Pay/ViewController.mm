//
//  ViewController.m
//  LGW_Pay
//
//  Created by Lilong on 16/4/21.
//  Copyright © 2016年 第七代目. All rights reserved.
//

#import "ViewController.h"

#import "PaySettlement.h"

//aliPay
#import <AlipaySDK/AlipaySDK.h>
//.m使用
#import "DataSigner.h"
//.mm使用
#import "RSADataSigner.h"

//----unionpay----
#import "UPPayPlugin.h"

//model
#import "Order.h"
#import "Product.h"
@interface ViewController ()<UPPayPluginDelegate>
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

// 支付宝支付
- (IBAction)aliPayAction:(id)sender {
    /*
     *prodcut实例并初始化订单信息
     */
    Product *product = [[Product alloc] init];;
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */

    /*需要填写商户app申请的*/

    NSString *partner = @"";
    NSString *seller = @"";
    NSString *privateKey = @""; // 私钥

    //partner和seller获取失败,提示
//    if ([partner length] == 0 ||
//        [seller length] == 0 ||
//        [privateKey length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"缺少partner或者seller或者私钥。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = product.subject; //商品标题
    order.productDescription = product.body; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"lgwpay";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    
    //test
    orderString = @"_input_charset=utf-8&notify_url=http%3A%2F%2Ftest.api.ppche.com%2Fnotify%2Fcard&out_trade_no=C201604210000524&partner=2088611132155870&payment_type=1&seller_id=mall%40ppche.com&service=mobile.securitypay.pay&subject=PP%E8%BD%A6%E4%BC%9A%E5%91%98%E5%85%85%E5%80%BC&total_fee=0.01&sign=FEezBXhtXrV6J%2BLQt8Zt%2B4XLCnfqb%2BSMxSWa3Xl6Ob22rexysh%2Fv08ZSwjJdnZkQ0IgEkrbyiiY4DYYSxHy6kT30Vtoi5XJGw9uJShJ0xH%2BW6kJiQtpDMhs4AjZIS82fpbc4Q7vsABqSqJ7M4MH5RtSikv4XCDbtYAHlVOUzQdo%3D&sign_type=RSA";
    //
    
    NSDictionary *dict = @{@"orderString":orderString,
                           @"appScheme":appScheme};
    [PaySettlement payForAliPayWithDict:dict];
    
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];

        NSDictionary *dict = @{@"orderString":orderString,
                               @"appScheme":appScheme};
        [PaySettlement payForAliPayWithDict:dict];
    }
}
// 微信支付
- (IBAction)wechatPayAction:(id)sender {
    NSDictionary *dict = @{
                           @"appid":@"wxf073589fe4d04a0b",
                           @"noncestr":@"X8EPBNruFg1MIpd4",
                           @"package":@"Sign=WXPay",
                           @"partnerid":@"1276437001",
                           @"sign":@"86F116FC031529138AE933EDF84959B0",
                           @"prepayid":@"wx20160421165155ce0308a6260814610448",
                           @"timestamp":@"1461228715"};
    [PaySettlement payForWechatWithDict:dict];
}
// 苹果支付
- (IBAction)applePayAction:(id)sender {
    
}
// 银联支付
- (IBAction)unionPayAction:(id)sender {
    //测试环境  上线时，请改为“00”
    NSString *tnMode = @"01";
    NSString *tn = @"201508281139266004168";
    //union pay
    [UPPayPlugin startPay:tn mode:tnMode viewController:self delegate:self];
}

#pragma mark UPPayPluginResult
- (void)UPPayPluginResult:(NSString *)result{
    NSString* msg = [NSString stringWithFormat:@"%@", result];
    NSLog(@"msg%@",msg);
    
    if ([result isEqualToString:@"msgcancel"]) {
        NSLog(@"取消银联支付...");
    }
    else if([result containsString:@"success"]){
        NSLog(@"支付成功");
        
    }
}

#pragma mark AliPay
#pragma mark   ==============产生随机订单号==============


- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.moneyTF resignFirstResponder];
}

@end
