//
//  topFreeViewModel.h
//  AppleStoreTopApplications
//
//  Created by HsuKit on 2021/6/2.
//

#import "BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface topFreeViewModel : BaseViewModel
@property(nonatomic,strong)NSMutableArray *appInfoArrays;
@property(nonatomic,assign)int page;
@end

NS_ASSUME_NONNULL_END
