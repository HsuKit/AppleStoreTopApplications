//
//  recommendViewModel.m
//  AppleStoreTopApplications
//
//  Created by HsuKit on 2021/6/2.
//

#import "recommendViewModel.h"

@implementation recommendViewModel
-(void)getDataWithMode:(RequestMode)requestMode completionHandler:(void (^)(NSError * _Nonnull))completionHandler
{
    [[NetworkManger shareNetworkManger] requestWithType:requestTypePOST URLString:@"https://itunes.apple.com/hk/rss/topgrossingapplications/limit=10/json" parameters:nil success:^(id  _Nullable responseObject) {
        NSDictionary *objDict = responseObject;
        NSArray *appArrays = objDict[@"feed"][@"entry"];
        self->_appInfoArrays = [[NSMutableArray alloc]init];
        for (NSDictionary *appDict in appArrays) {
            recommendAppModel *model = [[recommendAppModel alloc]init];
            model.appName = appDict[@"im:name"][@"label"];
            model.appIconUrl = ((NSArray *)appDict[@"im:image"]).lastObject[@"label"];
            model.appCategory = appDict[@"category"][@"attributes"][@"label"];
            [[DataBaseTool sharedDataBaseTool] insertRecommendModel:model];
            [self->_appInfoArrays addObject:model];
        }
        NSError *error;
        !completionHandler ?: completionHandler(error);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
@end
