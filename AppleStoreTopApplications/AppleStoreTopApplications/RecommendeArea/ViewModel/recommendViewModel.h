//
//  recommendViewModel.h
//  AppleStoreTopApplications
//
//  Created by HsuKit on 2021/6/2.
//

#import <Foundation/Foundation.h>
#import "recommendAppModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface recommendViewModel : BaseViewModel
@property(nonatomic,strong)NSMutableArray *appInfoArrays;
@end

NS_ASSUME_NONNULL_END
