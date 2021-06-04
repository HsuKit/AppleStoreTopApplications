//
//  topFreeViewModel.m
//  AppleStoreTopApplications
//
//  Created by HsuKit on 2021/6/2.
//

#import "topFreeViewModel.h"
#import "topFreeAppModel.h"
@implementation topFreeViewModel
{
    dispatch_semaphore_t semaphore;
    dispatch_group_t group;
    BOOL isLoadingData;
}
-(NSMutableArray *)appInfoArrays
{
    if (!_appInfoArrays) {
        _appInfoArrays = [[NSMutableArray alloc]init];
    }
    return _appInfoArrays;
}
-(void)getDataWithMode:(RequestMode)requestMode completionHandler:(void (^)(NSError * _Nonnull))completionHandler
{
    if (requestMode == RequestModeRefresh) {
        isLoadingData = YES;
        self.page = 1;
        [self.appInfoArrays removeAllObjects];
        //        NSLog(@"----开始刷新");
    }
    if (semaphore == nil) {
        semaphore = dispatch_semaphore_create(0);
        group = dispatch_group_create();
    }
    [[NetworkManger shareNetworkManger] requestWithType:requestTypePOST URLString:[NSString stringWithFormat:@"https://itunes.apple.com/hk/rss/topfreeapplications/limit=%d/json",self.page*10] parameters:nil success:^(id  _Nullable responseObject) {
        self->isLoadingData = NO;
        //        NSLog(@"----刷新停止");
        NSDictionary *objDict = responseObject;
        NSArray *appArrays = objDict[@"feed"][@"entry"];
        for (int i = (self.page - 1)*10; i < appArrays.count; i++) {
            NSDictionary *appDict = appArrays[i];
            topFreeAppModel *model = [[topFreeAppModel alloc]init];
            model.appName = appDict[@"im:name"][@"label"];
            model.appIconUrl = ((NSArray *)appDict[@"im:image"]).lastObject[@"label"];
            model.appCategory = appDict[@"category"][@"attributes"][@"label"];
            model.appId = appDict[@"id"][@"attributes"][@"im:id"];
            model.appDesc = appDict[@"summary"][@"label"];
            model.appDev = appDict[@"im:artist"][@"label"];
            model.index = [NSString stringWithFormat:@"%d",i + 1];
            if (![[DataBaseTool sharedDataBaseTool] isHaveThisAppWithAppid:model.appId]) {
                [[DataBaseTool sharedDataBaseTool] insertTopFreeAppModel:model];
//                NSLog(@"11111111111111");
            }
            
            [self->_appInfoArrays addObject:model];
        }
        NSError *error;
        !completionHandler ?: completionHandler(error);
        
        
        NSArray *tempArray = [[NSArray alloc]initWithArray:self->_appInfoArrays];
        for (int i = (self.page - 1)*10; i < tempArray.count; i++) {
            
            dispatch_group_async(self->group, dispatch_queue_create("com.dispatch.test", DISPATCH_QUEUE_CONCURRENT), ^{
//                NSLog(@"开始第%d个----线程--%@",i,[NSThread currentThread]);
                topFreeAppModel *model = tempArray[i];
                [[NetworkManger shareNetworkManger] requestWithType:requestTypePOST URLString:[NSString stringWithFormat:@"https://itunes.apple.com/hk/lookup?id=%@",model.appId] parameters:nil success:^(id  _Nullable responseObject) {
                    NSDictionary *objDict = responseObject;
                    NSDictionary *resultDict = objDict[@"results"][0];
                    model.appScore = [NSString stringWithFormat:@"%.2f",[resultDict[@"averageUserRating"] floatValue]];
                    model.commendCount = [NSString stringWithFormat:@"%@",resultDict[@"userRatingCountForCurrentVersion"]];
                    [[DataBaseTool sharedDataBaseTool] updateCommendWithAppid:model.appId inTopFreeAppModel:model];
                    [[DataBaseTool sharedDataBaseTool] updateAppScoreWithAppid:model.appId inTopFreeAppModel:model];
                    //                        NSLog(@"收到第%d个----线程--%@",i,[NSThread currentThread]);
                    !completionHandler ?: completionHandler(error);
                    [self.appInfoArrays replaceObjectAtIndex:i withObject:model];
                    
                } failure:^(NSError * _Nonnull error) {
                    
                }];
            });
            
        }
        //        dispatch_group_notify(self->group, dispatch_get_main_queue(), ^{
        //            NSLog(@"11111111");
        //            !completionHandler ?: completionHandler(error);
        //            });
        
        
        
        
        
        
        
        
        
        //        dispatch_group_async(self->group, dispatch_queue_create("com.dispatch.test", DISPATCH_QUEUE_CONCURRENT), ^{
        //            NSArray *tempArray = [[NSArray alloc]initWithArray:self->_appInfoArrays];
        //            for (int i = (self.page - 1)*10; i < tempArray.count; i++) {
        //
        //                if (self->isLoadingData) {
        //                    dispatch_semaphore_signal(self->semaphore);
        //                    return;
        //                }
        //                NSLog(@"开始第%d个",i);
        //                topFreeAppModel *model = tempArray[i];
        //                [[NetworkManger shareNetworkManger] requestWithType:requestTypePOST URLString:[NSString stringWithFormat:@"https://itunes.apple.com/hk/lookup?id=%@",model.appId] parameters:nil success:^(id  _Nullable responseObject) {
        //                    NSDictionary *objDict = responseObject;
        //                    NSDictionary *resultDict = objDict[@"results"][0];
        //                    model.appScore = [NSString stringWithFormat:@"%.2f",[resultDict[@"averageUserRating"] floatValue]];
        //                    model.commendCount = [NSString stringWithFormat:@"%@",resultDict[@"userRatingCountForCurrentVersion"]];
        //                    if (self->isLoadingData) {
        //                        dispatch_semaphore_signal(self->semaphore);
        //                        return;
        //                    }
        //                    NSLog(@"收到第%d个",i);
        //                    [self.appInfoArrays replaceObjectAtIndex:i withObject:model];
        //                    dispatch_semaphore_signal(self->semaphore);
        //                } failure:^(NSError * _Nonnull error) {
        //
        //                }];
        //                dispatch_semaphore_wait(self->semaphore, DISPATCH_TIME_FOREVER);
        //            }
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //
        //                !completionHandler ?: completionHandler(error);
        //            });
        //
        //        });
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
@end
