//
//  DataBaseTool.h
//  JMCarDemo
//
//  Created by HsuKit on 2020/12/1.
//  Copyright © 2020 Hsukit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYFMDBTool.h"
#import "topFreeAppModel.h"
#import "recommendAppModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DataBaseTool : NSObject

single_interface(DataBaseTool)

/**
 *  创建数据库
 */
- (FMDatabaseQueue *)sharedDataBase;

/**
 *  创建recommend表
 */
- (void)createRecommendTable;

/**
 *  创建topfree表
 */
- (void)createTopFreeApplicationTable;

- (void)insertTopFreeAppModel:(topFreeAppModel *)model;
- (void)insertRecommendModel:(recommendAppModel *)model;

- (void)updateAppScoreWithAppid:(NSString *)appid inTopFreeAppModel:(topFreeAppModel *)model;
- (void)updateCommendWithAppid:(NSString *)appid inTopFreeAppModel:(topFreeAppModel *)model;
- (BOOL)isHaveThisAppWithAppid:(NSString *)appid;

- (NSMutableArray *)searchTopFreeAppWithKeyWord:(NSString *)keyword;

- (NSMutableArray *)getAllTopFreeCache;
- (NSMutableArray *)getAllRecommendCache;
@end

NS_ASSUME_NONNULL_END
