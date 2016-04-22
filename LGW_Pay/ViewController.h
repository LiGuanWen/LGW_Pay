//
//  ViewController.h
//  LGW_Pay
//
//  Created by Lilong on 16/4/21.
//  Copyright © 2016年 第七代目. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end
/*
  如果是不要银联支付功能 将DataSigner改回.m  和 viewcontroller切换成.m
  可能遇到银联c++编译问题，把对应的viewcontroller切换成.mm，编译看看。若有CreateRSADataSigner arm64的，请将支付宝给的DataSigner改成.mm即可。
*/