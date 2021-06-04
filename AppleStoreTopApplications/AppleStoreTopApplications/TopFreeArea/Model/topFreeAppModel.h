//
//  topFreeAppModel.h
//  AppleStoreTopApplications
//
//  Created by HsuKit on 2021/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface topFreeAppModel : NSObject
@property(nonatomic,strong)NSString *appName;
@property(nonatomic,strong)NSString *appIconUrl;
@property(nonatomic,strong)NSString *appCategory;
@property(nonatomic,strong)NSString *appId;
@property(nonatomic,strong)NSString *appDesc;
@property(nonatomic,strong)NSString *appDev;
@property(nonatomic,strong)NSString *commendCount;
@property(nonatomic,strong)NSString *appScore;
@property(nonatomic,strong)NSString *index;
@end

NS_ASSUME_NONNULL_END
