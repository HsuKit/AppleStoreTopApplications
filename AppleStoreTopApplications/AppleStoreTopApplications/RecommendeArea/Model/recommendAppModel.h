//
//  recommendAppModel.h
//  AppleStoreTopApplications
//
//  Created by HsuKit on 2021/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface recommendAppModel : NSObject
@property(nonatomic,strong)NSString *appName;
@property(nonatomic,strong)NSString *appIconUrl;
@property(nonatomic,strong)NSString *appCategory;
@end

NS_ASSUME_NONNULL_END
