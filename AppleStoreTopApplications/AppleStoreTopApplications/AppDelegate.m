//
//  AppDelegate.m
//  AppleStoreTopApplications
//
//  Created by HsuKit on 2021/6/1.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //创建数据库
    [[DataBaseTool sharedDataBaseTool] createRecommendTable];
    [[DataBaseTool sharedDataBaseTool] createTopFreeApplicationTable];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    self.window.rootViewController = [[ViewController alloc] init];;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}





@end
