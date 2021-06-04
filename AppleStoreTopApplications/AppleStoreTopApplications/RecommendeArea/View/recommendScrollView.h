//
//  recommendScrollView.h
//  AppleStoreTopApplications
//
//  Created by HsuKit on 2021/6/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface recommendScrollView : UIView
@property(nonatomic,strong)NSArray *contentArray;
-(instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
