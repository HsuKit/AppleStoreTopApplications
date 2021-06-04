//
//  BaseViewModel.h
//  AppleStoreTopApplications
//
//  Created by HsuKit on 2021/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, RequestMode) {

RequestModeRefresh,

RequestModeMore,

};
@interface BaseViewModel : NSObject
- (void)getDataWithMode:(RequestMode)requestMode completionHandler:(void(^)(NSError *error))completionHandler;
@end

NS_ASSUME_NONNULL_END
