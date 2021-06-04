//
//  recommendScrollView.m
//  AppleStoreTopApplications
//
//  Created by HsuKit on 2021/6/2.
//

#import "recommendScrollView.h"
#import "recommendAppModel.h"
@interface recommendScrollView()
@property(nonatomic,strong)UIScrollView *myScrollView;
@end
@implementation recommendScrollView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *topLine = [[UIView alloc]init];
        topLine.backgroundColor = _GrayColor;
        [self addSubview:topLine];
        
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.top.mas_equalTo(0);
        }];
        
        UIView *bottomLine = [[UIView alloc]init];
        bottomLine.backgroundColor = _GrayColor;
        [self addSubview:bottomLine];
        
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(0);
        }];
        
        UILabel *recommendTipLab = [[UILabel alloc]init];
        recommendTipLab.font = [UIFont boldSystemFontOfSize:20];
        recommendTipLab.text = @"Recommend";
        [self addSubview:recommendTipLab];
        
        [recommendTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(20);
        }];
        
        self.myScrollView = [[UIScrollView alloc]init];
        self.myScrollView.showsVerticalScrollIndicator = NO;
        self.myScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.myScrollView];
        
        [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(recommendTipLab.mas_bottom).offset(5);
            make.bottom.mas_equalTo(bottomLine.mas_top).offset(-5);
        }];
    }
    return self;
}
-(void)setContentArray:(NSArray *)contentArray
{
    _contentArray = contentArray;
    CGFloat kWidth = (kScreenWidth - 60) / 3.5;
    for (NSInteger i = 0; i < contentArray.count; i++) {
        recommendAppModel *model = contentArray[i];
        UIImageView *imgV = [[UIImageView alloc]init];
        imgV.layer.masksToBounds = YES;
        imgV.layer.cornerRadius = 8;
        [imgV sd_setImageWithURL:[NSURL URLWithString:model.appIconUrl]];
        [self.myScrollView addSubview:imgV];
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15 + (15+kWidth)*i);
            make.width.height.mas_equalTo(kWidth);
        }];
        
        UILabel *nameLab = [[UILabel alloc]init];
        nameLab.font = _TitleFont;
        nameLab.text = model.appName;
        nameLab.textAlignment = NSTextAlignmentCenter;
        [self.myScrollView addSubview:nameLab];
        
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgV.mas_left);
            make.right.mas_equalTo(imgV.mas_right);
            make.top.mas_equalTo(imgV.mas_bottom).offset(5);
            make.height.mas_equalTo(17);
        }];
        
        UILabel *typeLab = [[UILabel alloc]init];
        typeLab.font = _TitleFont;
        typeLab.text = model.appCategory;
        typeLab.textColor = _GrayColor;
        typeLab.textAlignment = NSTextAlignmentCenter;
        [self.myScrollView addSubview:typeLab];
        
        [typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgV.mas_left);
            make.right.mas_equalTo(imgV.mas_right);
            make.top.mas_equalTo(nameLab.mas_bottom).offset(3);
            make.height.mas_equalTo(17);
        }];
    }
    self.myScrollView.contentSize = CGSizeMake(15 + (15+kWidth)*contentArray.count, 0);
}

@end
