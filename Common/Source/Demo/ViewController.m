//
//  ViewController.m
//  QuickUnifyPlatformDemo
//
//  Created by yuhao on 15/6/15.
//  Copyright (c) 2015年 yuhao. All rights reserved.
//
#import "ViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <QuickUnifyPlatform/QuickUnifyPlatform.h>
@interface ViewController ()
{
    NSString * _guid;
}

@end

@implementation ViewController


- (NSString *) qupMD5Hash :(NSString *)str{
    int i = 0;
    NSMutableString *cryptedString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    const char *string = [str UTF8String];
    CC_MD5(string, (CC_LONG)strlen(string), result);
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [cryptedString appendFormat:@"%02x", result[i]];
    }
    return cryptedString;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
}
//初始化成功回调
- (void)loginCallBack:(NSNotification *)notify
{
    
    NSLog(@"loginCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo);
    self.nofTextView.text=[NSString stringWithFormat:@" loginCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo];
     //TODO: 请使用服务器验证登录账号。注意所有UIAlertView 最好使用友好的游戏界面提示。
    if(notify.object==kQUPSDKSuccessResult){
        NSString *token=[notify.userInfo objectForKey:kQUPLoginTokenKey];
        NSString *gamekey=[[[QuickUnifyPlatform getInstance] qupSettingInfo] objectForKey:@"gamekey"];
        NSString *sign=[[self qupMD5Hash:[NSString stringWithFormat:@"%@%@",gamekey,token]]lowercaseString];
        NSString *loginUrl=@"";
        if([[[[QuickUnifyPlatform getInstance] qupSettingInfo] objectForKey:@"isdebug"] boolValue]){
            loginUrl=kQUPDebugSignLoginURL;
        }else{
            loginUrl=kQUPSignLoginURL;
        }
        NSString *urlString = [NSString stringWithFormat:@"%@?tokenKey=%@&sign=%@",loginUrl,token,sign];
        NSLog(@"urlString:%@",urlString);
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setTimeoutInterval:30.0f];
        [urlRequest setHTTPMethod:@"GET"];
        NSOperationQueue *queue=[NSOperationQueue mainQueue];
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSError *jsonError=nil;
            NSDictionary* responseDic=nil;
            if(data!=nil){
                responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            }
            if(connectionError!=nil){
                NSLog(@"connectionError：%@",connectionError);
                self.nofTextView.text=[NSString stringWithFormat:@" loginCallBack notify.object:%@\n notify.userInfo:%@\n serverInfo:%@",notify.object,notify.userInfo,connectionError];
            }else if(jsonError!=nil){
                 NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"jsonError：%@,%@",jsonError,dataStr);
                  self.nofTextView.text=[NSString stringWithFormat:@" loginCallBack notify.object:%@\n notify.userInfo:%@\n serverInfo:%@",notify.object,notify.userInfo,dataStr];
                
            }else if(responseDic!=nil){
               self.nofTextView.text=[NSString stringWithFormat:@" loginCallBack notify.object:%@\n notify.userInfo:%@\n serverInfo:%@",notify.object,notify.userInfo,responseDic];
                if ([[responseDic objectForKey:@"code"] intValue] == 0) {
                    _guid=[[responseDic objectForKey:@"data"] objectForKey:@"guid"];
                    NSLog(@"_guid:%@",_guid);
                }else{
                    NSLog(@"responseDic:%@",responseDic);
                }
            }else{
                NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"dataStr:%@",dataStr);
                self.nofTextView.text=[NSString stringWithFormat:@" loginCallBack notify.object:%@\n notify.userInfo:%@\n serverInfo:%@",notify.object,notify.userInfo,dataStr];
            }
        }];
    }else if(notify.object==kQUPSDKFailedResult){
        NSString *errorMsg=nil;
        if(notify.userInfo!=nil){
            errorMsg=[notify.userInfo objectForKey:kQUPErrorShowKey];
        }
        if(errorMsg==nil||[@"" isEqualToString:errorMsg]){
           errorMsg=@"登录失败";
        }
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:errorMsg message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else if(notify.object==kQUPSDKUserCancelResult){
        [[QuickUnifyPlatform getInstance] qupLogin];
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle: @"未知错误"message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
   
}


- (void)logoutCallBack:(NSNotification *)notify
{
    //TODO: 可以这样处理

    [[QuickUnifyPlatform getInstance] qupLogin];
    NSLog(@"logoutCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo);
    self.nofTextView.text=[NSString stringWithFormat:@" logoutCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo];
}




- (void)payCallBack:(NSNotification *)notify
{
    NSLog(@"payCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo);
    self.nofTextView.text=[NSString stringWithFormat:@" payCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo];
    if(notify.object==kQUPSDKSuccessResult){
        //TODO: 刷新用户数据
    }else if(notify.object==kQUPSDKUserCancelResult){
        //TODO: 刷新用户数据
    }else if(notify.object==kQUPSDKFailedResult){
        //TODO: 刷新用户数据
        //TODO: 提示用户操作失败。
        NSString *errorMsg=nil;
        if(notify.userInfo !=nil){
            errorMsg=[notify.userInfo objectForKey:kQUPErrorShowKey];
        }
        if(errorMsg==nil||[@"" isEqualToString:errorMsg]){
            errorMsg=@"支付失败";
        }
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:errorMsg message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}


- (void)pauseCallBack:(NSNotification *)notify
{
    //TODO: 基本不用处理
    NSLog(@"pauseCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo);
    self.nofTextView.text=[NSString stringWithFormat:@" pauseCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo];
}



- (void)initCallBack:(NSNotification *)notify
{
    //TODO: 游戏初始化代码
    if (notify.object == kQUPSDKSuccessResult) {
        //TODO: 则可以调用登录方法
        //[[QuickUnifyPlatform getInstance] qupLogin];
    }else if(notify.object == kQUPSDKFailedResult){
        //TODO: 可以重新进行初始化
        //[[QuickUnifyPlatform getInstance] qupInit];
    }
    NSLog(@"initCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo);
    self.nofTextView.text=[NSString stringWithFormat:@" initCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo];
    
    
    self.nofTextView.text=[[QuickUnifyPlatform getInstance] qupPlatformInfo];
}

- (void)centerCallBack:(NSNotification *)notify
{
    //TODO: 基本不用处理
    NSLog(@"centerCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo);
    self.nofTextView.text=[NSString stringWithFormat:@" centerCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo];
}


- (void)leaveCallBack:(NSNotification *)notify
{
    //TODO: 基本不用处理
    NSLog(@"leaveCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo);
    self.nofTextView.text=[NSString stringWithFormat:@" leaveCallBack notify.object:%@\n notify.userInfo:%@",notify.object,notify.userInfo];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initSDK{
    
    //游戏初始化代码请放在初始化成功通知中 kQUPSDKInitDidFinishNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initCallBack:) name:kQUPSDKInitDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCallBack:) name:kQUPSDKLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutCallBack:) name:kQUPSDKLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payCallBack:) name:kQUPSDKPayNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(centerCallBack:) name:kQUPSDKCenterNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveCallBack:) name:kQUPSDKLeaveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseCallBack:) name:kQUPSDKPauseDidExitNotification object:nil];
    
    [[QuickUnifyPlatform getInstance] qupInit];
}
- (IBAction)toFun:(id)sender {
    switch ([sender tag]) {
        case 1:
        {
            [self initSDK];
            
        }
            break;
        case 2:
        {
            //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            [[QuickUnifyPlatform getInstance] qupLogin];
        }
            break;
        case 3:
        {
            if(_guid==nil){
                
                return;
            }
            CFUUIDRef theUUID = CFUUIDCreate(NULL);
            CFStringRef guid = CFUUIDCreateString(NULL, theUUID);
            CFRelease(theUUID);
            NSString *uuidString = [((__bridge NSString *)guid) stringByReplacingOccurrencesOfString:@"-" withString:@""];
            CFRelease(guid);
            
            //根据平台规定，定义最小支付金额
            NSString *minMoney=@"0.01";
            if([[QuickUnifyPlatform getInstance] qupPlatformName]==QUPAISISDK){
                minMoney=@"1";
            }else if([[QuickUnifyPlatform getInstance] qupPlatformName]==QUPBAIDUSDK){
                minMoney=@"1";
            }else if([[QuickUnifyPlatform getInstance] qupPlatformName]==QUPXYSDK){
                minMoney=@"1";
            }
            
            //定义支付信息
            QuickProductInfo *info =[[QuickProductInfo alloc] init];
            info.server_id=@"1";
            info.user_id=_guid;
            info.user_extend=@"1元宝";
            info.order_id=uuidString;
            info.money=minMoney;
            
            info.product_id=@"1";
            info.product_name=@"1元宝";
            info.product_desc=@"1元宝";
            info.product_number=@"1";
            
            info.product_price=minMoney;
            [[QuickUnifyPlatform getInstance] qupPayWithProductInfo:info];
            
        }
            break;
        case 4:
        {
            [[QuickUnifyPlatform getInstance] qupLogout];
        }
            break;
        case 5:
        {
            BOOL isMethod=[[QuickUnifyPlatform getInstance] qupRespondsToSelector:@selector(qupShowCenter)];
            [[QuickUnifyPlatform getInstance] qupShowCenter];
            
            self.nofTextView.text=[NSString stringWithFormat:@"qupShowCenter isMethod:%d",isMethod];
        }
            break;
        case 6:
        {
        
           NSDictionary *qupSettingInfo=[[QuickUnifyPlatform getInstance] qupSettingInfo];
            NSLog(@"qupSettingInfo:%@",qupSettingInfo);
            self.nofTextView.text=[NSString stringWithFormat:@"qupSettingInfo:%@",qupSettingInfo];
        }
            break;
        case 7:
        {
           NSDictionary *qupUserInfo=[[QuickUnifyPlatform getInstance] qupUserInfo];
            NSLog(@"qupUserInfo:%@",qupUserInfo);
            self.nofTextView.text=[NSString stringWithFormat:@"qupUserInfo:%@",qupUserInfo];
        }
            break;
        case 8:
        {
            BOOL isMethod=[[QuickUnifyPlatform getInstance] qupRespondsToSelector:@selector(qupHideToolBar:)];
            self.nofTextView.text=[NSString stringWithFormat:@"qupHideToolBar: isMethod:%d",isMethod];
                if(!_isHidden){
                    _isHidden=YES;
                    [[QuickUnifyPlatform getInstance] qupHideToolBar:YES];
                }else{
                    _isHidden=NO;
                    [[QuickUnifyPlatform getInstance] qupHideToolBar:NO];
                }
        }
            break;
        case 9:
        {
            BOOL isMethod=[[QuickUnifyPlatform getInstance] qupRespondsToSelector:@selector(qupOnPause)];
            self.nofTextView.text=[NSString stringWithFormat:@"qupOnPause isMethod:%d",isMethod];
        }
            break;
        case 10:
        {
            BOOL isMethod=[[QuickUnifyPlatform getInstance] qupRespondsToSelector:@selector(qupHandleWithapplication:openURL:sourceApplication:annotation:)];
            self.nofTextView.text=[NSString stringWithFormat:@"qupHandleWithapplication:openURL:sourceApplication:annotation: isMethod:%d",isMethod];
            [[QuickUnifyPlatform getInstance] qupHandleWithapplication:nil openURL:nil sourceApplication:nil annotation:nil];
            
        }
            break;
      
        default:
            break;
    }
}



#pragma mark - iOS 版本 < 6.0 设置旋转支持
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //iOS版本 < 6.0，请根据需要设置成支持横屏或者竖屏。建议不要同时支持横竖屏。
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"QuickManifest" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    BOOL islandscape = [[data objectForKey:@"islandscape"] boolValue];
    if(islandscape){
        if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            return YES;
        }
    }else{
        if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - iOS 版本 >= 6.0 设置旋转支持
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"QuickManifest" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    BOOL islandscape = [[data objectForKey:@"islandscape"] boolValue];
    return islandscape?UIInterfaceOrientationMaskLandscape:UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
   
}


@end
