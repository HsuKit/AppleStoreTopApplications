//
//  NetworkManger.m
//  AppleStoreTopApplications
//
//  Created by HsuKit on 2021/6/1.
//

#import "NetworkManger.h"

static NetworkManger *instance = nil;

@implementation NetworkManger

+ (instancetype)shareNetworkManger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         if (instance == nil) {
           instance = [[super allocWithZone:NULL] init];
        }
        //  让AFN默认也支持接收text/html文件类型
        instance.responseSerializer.acceptableContentTypes
        = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", nil];
    });
    return instance;
}

//MARK: 一次封装的网络工具类
- (void)requestWithType:(requestType)type URLString:(NSString *)URLString parameters:(nullable id)parameters progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    if (type == requestTypeGET) {
        [instance GET:URLString parameters:parameters headers:nil progress:downloadProgress success:success failure:failure];

    } else if (type == requestTypePOST) {
        [instance POST:URLString parameters:parameters headers:nil progress:downloadProgress success:success failure:failure];
        
    }
}

//MARK: 二次封装的网络工具类
- (void)requestWithType:(requestType)type URLString:(nonnull NSString *)URLString parameters:(nullable id)parameters success:(nullable void (^)(id _Nullable responseObject))success  failure:(nullable void (^)(NSError *_Nonnull error))failure{
    //(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
    void (^orginalSuccess)(NSURLSessionDataTask * _Nullable, id  _Nullable) = ^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
//        success((NSDictionary *)responseObject);
        success(responseObject);
    };
    //(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure
    void (^orginalFailure)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    };
    [self requestWithType:type URLString:URLString parameters:parameters progress:nil success:orginalSuccess failure:orginalFailure];
}

//MARK: 三次封装的网络工具类
+ (void)requestWithType:(requestType)type URLString:(nonnull NSString *)URLString parameters:(nullable id)parameters success:(nullable void (^)(id _Nullable responseObject))success  failure:(nullable void (^)(NSError *_Nonnull error))failure {
    [[NetworkManger shareNetworkManger] requestWithType:type URLString:URLString parameters:parameters success:success failure:failure];
}

+(id)allocWithZone:(NSZone *)zone{
  return [NetworkManger shareNetworkManger];
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone{
    return [NetworkManger shareNetworkManger];
}
-(id)mutableCopyWithZone:(NSZone *)zone{
    return [NetworkManger shareNetworkManger];
}
@end
