//
//  AppDelegate.m
//  SLCardScrollView
//
//  Created by sll on 2020/6/29.
//  Copyright © 2020 SLL. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()


//没找到适合需求的第三方库，纠结了一下动手造个轮子算了，弄个简单点的也不是很费劲。。。。
//需求如下：
//1.滚动banner图然后左右两边要让出距离，可以看到上一张和下一张的边，
//2.中间一张图要稍微有一个缩放效果
//3.要带title，不需要带pageControl

//因为原项目有sdwebimage支持，所以使用的时候不需要把sdwebimage拖进项目，有些sd方法可能会因为sd版本不同，报错的话手动改一下就好

@end

@implementation AppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


@end
