//
//  NetworkManger.h
//  AppleStoreTopApplications
//
//  Created by HsuKit on 2021/6/1.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum{
    requestTypeGET,
    requestTypePOST
}requestType;
@interface NetworkManger : AFHTTPSessionManager
//单例
+ (instancetype)shareNetworkManger;
+(id)allocWithZone:(NSZone *)zone;


//第二次封装,简化参数,把没有用的参数去掉
- (void)requestWithType:(requestType)type URLString:(nonnull NSString *)URLString parameters:(nullable id)parameters success:(nullable void (^)(id _Nullable responseObject))success  failure:(nullable void (^)(NSError *_Nonnull error))failure;

//第三次封装,直接使用类方法,外部调用单例避免重复
+ (void)requestWithType:(requestType)type URLString:(nonnull NSString *)URLString parameters:(nullable id)parameters success:(nullable void (^)(id _Nullable responseObject))success  failure:(nullable void (^)(NSError *_Nonnull error))failure;
@end
NS_ASSUME_NONNULL_END
