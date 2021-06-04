//
//  TopFreeAppCell.m
//  AppleStoreTopApplications
//
//  Created by HsuKit on 2021/6/2.
//

#import "TopFreeAppCell.h"
#import "ZZStarView.h"
@interface TopFreeAppCell()
@property(nonatomic,strong)UIImageView *iconImg;
@property(nonatomic,strong)UILabel *numberLab;
@property(nonatomic,strong)UILabel *appNameLab;
@property(nonatomic,strong)UILabel *appCategoryLab;
@property(nonatomic,strong)ZZStarView *starView;
@property(nonatomic,strong)UILabel *commendLab;
@end
@implementation TopFreeAppCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _numberLab = [[UILabel alloc]init];
        _numberLab.textColor = _GrayColor;
        _numberLab.font = _DescriptionFont;
        [self.contentView addSubview:_numberLab];
        [_numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(15);
        }];
        
        _iconImg = [[UIImageView alloc]init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 12;
        [self.contentView addSubview:_iconImg];
        [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_numberLab.mas_right).offset(5);
            make.width.height.mas_equalTo(50);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _appNameLab = [[UILabel alloc]init];
        _appNameLab.textColor = _BlackColor;
        _appNameLab.font = _TitleFont;
        [self.contentView addSubview:_appNameLab];
        [_appNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_iconImg.mas_right).offset(3);
            make.top.mas_equalTo(_iconImg.mas_top);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(17);
        }];
        
        _appCategoryLab = [[UILabel alloc]init];
        _appCategoryLab.textColor = _GrayColor;
        _appCategoryLab.font = _DescriptionFont;
        [self.contentView addSubview:_appCategoryLab];
        [_appCategoryLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_iconImg.mas_right).offset(3);
            make.top.mas_equalTo(_appNameLab.mas_bottom).offset(5);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(15);
        }];
        
        _starView = [[ZZStarView alloc]initWithImage:[UIImage imageNamed:@"Star_appraise_genger"] selectImage:[UIImage imageNamed:@"Star_appraise_select"] starWidth:15 starHeight:15 starMargin:1 starCount:5 callBack:^(CGFloat userGrade, CGFloat finalGrade) {
            
        }];
        
        [self.contentView addSubview:_starView];
        [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_iconImg.mas_right).offset(3);
            make.top.mas_equalTo(_appCategoryLab.mas_bottom).offset(5);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(15);
        }];
        
        
        _commendLab = [[UILabel alloc]init];
        _commendLab.textColor = _GrayColor;
        _commendLab.font = _NumberFont;
        [self.contentView addSubview:_commendLab];
        [_commendLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_starView.mas_right).offset(-8);
            make.centerY.mas_equalTo(_starView.mas_centerY);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(15);
        }];
        
    }
    return self;
}
-(void)setModel:(topFreeAppModel *)model
{
    _appNameLab.text = model.appName;
    _appCategoryLab.text = model.appCategory;
    _numberLab.text = model.index;
    if ([model.index intValue] % 2 == 0) {
        _iconImg.layer.cornerRadius = 25;
    }else{
        _iconImg.layer.cornerRadius = 12;
    }
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:model.appIconUrl]];
    
    if (model.appScore != nil) {
        _starView.grade = [model.appScore floatValue];
        _commendLab.text = [NSString stringWithFormat:@"(%@)",model.commendCount];
    }
}
@end
