//
//  DataBaseTool.m
//  JMCarDemo
//
//  Created by HsuKit on 2020/12/1.
//  Copyright © 2020 Hsukit. All rights reserved.
//

#import "DataBaseTool.h"
#import "FMDatabaseQueue.h"
#import "topFreeAppModel.h"
@interface DataBaseTool (){
    TYCommonDatabaseAccess *_dataAccess;
}
@end
@implementation DataBaseTool
single_implementation(DataBaseTool)

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataAccess = [[TYCommonDatabaseAccess alloc] init];
        
    }
    return self;
}

- (FMDatabaseQueue *)sharedDataBase{
    //    return [TYDatebaseFactory sharedDatabaseWithPath:kDocDir withDatabaseName:@"TopApplications.db"];
//    NSLog(@"-----%@",kDocDir);
    return [TYDatebaseQueueFactory sharedDatabaseQueueWithPath:kDocDir withDatabaseName:@"TopApplications.db"];
}

/**
 *  创建recommend表
 */
- (void)createRecommendTable
{
    FMDatabaseQueue *fmdq = [self sharedDataBase];
    
    [fmdq inDatabase:^(FMDatabase *db) {
        BOOL res = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS RecommendList (AppName text, AppType text, AppIcon text)" ];
        if (res) {
            NSLog(@"success");
        }else{
            NSLog(@"failed");
        }
        [db close];
    }];
    //    FMDatabaseQueue *db = [self sharedDataBase];
    //
    //    if ([db open]) {
    //        BOOL res = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS RecommendList (AppName text, AppType text, Appdec text, AppIcon text)" ];
    //        if (res) {
    //            NSLog(@"success");
    //        }else{
    //            NSLog(@"failed");
    //        }
    //        [db close];
    //    }
}
/**
 *  创建TopFreeApplication表
 */
- (void)createTopFreeApplicationTable
{
    FMDatabaseQueue *fmdq = [self sharedDataBase];
    [fmdq inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL res = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS TopFreeApplicationList (AppName text, AppType text, Appdec text, AppDev text, AppComment text, AppScore text, AppIcon text, AppId text,AppIndex text)" ];
        if (res) {
            NSLog(@"success");
        }else{
            NSLog(@"failed");
        }
        [db close];
    }];
    //    if ([db open]) {
    //        BOOL res = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS TopFreeApplicationList (AppName text, AppType text, Appdec text, AppDev text, AppComment text, AppScore text, AppIcon text, AppId text)" ];
    //        if (res) {
    //            NSLog(@"success");
    //        }else{
    //            NSLog(@"failed");
    //        }
    //        [db close];
    //    }
}

- (void)insertTopFreeAppModel:(topFreeAppModel *)model
{
    FMDatabaseQueue *fmdq = [self sharedDataBase];
    [fmdq inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL res = [db executeUpdate:@"INSERT INTO TopFreeApplicationList (AppName, AppType, Appdec, AppDev, AppComment, AppScore,AppIcon,AppId,AppIndex) VALUES (?,?,?,?,?,?,?,?,?)",model.appName,model.appCategory,model.appDesc,model.appDev,@"0",@"0",model.appIconUrl,model.appId,model.index];
        if (res) {
//            NSLog(@"插入成功");
        }else{
//            NSLog(@"插入失败");
        }
        [db close];
    }];
}
- (void)insertRecommendModel:(recommendAppModel *)model
{
    FMDatabaseQueue *fmdq = [self sharedDataBase];
    [fmdq inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL res = [db executeUpdate:@"INSERT INTO RecommendList (AppName, AppType,AppIcon) VALUES (?,?,?)",model.appName,model.appCategory,model.appIconUrl];
        if (res) {
//            NSLog(@"插入成功");
        }else{
//            NSLog(@"插入失败");
        }
        [db close];
    }];
}
- (void)updateAppScoreWithAppid:(NSString *)appid inTopFreeAppModel:(topFreeAppModel *)model
{
    FMDatabaseQueue *fmdq = [self sharedDataBase];
    [fmdq inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL res = [db executeUpdate:@"UPDATE TopFreeApplicationList SET AppScore = ? WHERE AppId = ?",model.appScore,model.appId];
        if (res) {
            NSLog(@"更新AppScore成功");
        }else{
            NSLog(@"更新AppScore失败");
        }
        [db close];
    }];
}
- (void)updateCommendWithAppid:(NSString *)appid inTopFreeAppModel:(topFreeAppModel *)model
{
    
    
    FMDatabaseQueue *fmdq = [self sharedDataBase];
    
    [fmdq inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL res = [db executeUpdate:@"UPDATE TopFreeApplicationList SET AppComment = ? WHERE AppId = ?",model.commendCount,model.appId];
        if (res) {
            NSLog(@"更新Commend成功");
        }else{
            NSLog(@"更新Commend失败");
        }
        [db close];
    }];
}
- (BOOL)isHaveThisAppWithAppid:(NSString *)appid
{
    BOOL isHaveThisApp = NO;
    
    NSString *sql = [NSString stringWithFormat:@"select * from TopFreeApplicationList where AppId = %@",appid];
    NSMutableArray *arrm = [self getReArrFromSql:sql];
    if (arrm.count != 0) {
        isHaveThisApp = YES;
    }
    return isHaveThisApp;
}
-(NSMutableArray *)getReArrFromSql:(NSString *)sql
{
    FMDatabaseQueue *fmdq = [self sharedDataBase];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [fmdq inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs = [db executeQuery:sql];
                while ([rs next]) {
                    topFreeAppModel *model = [[topFreeAppModel alloc] init];
                    model.appName = [rs stringForColumn:@"AppName"];
                    model.appCategory = [rs stringForColumn:@"AppType"];
                    model.appDesc = [rs stringForColumn:@"Appdec"];
                    model.appDev = [rs stringForColumn:@"AppDev"];
                    model.commendCount = [rs stringForColumn:@"AppComment"];
                    model.appScore = [rs stringForColumn:@"AppScore"];
                    model.appIconUrl = [rs stringForColumn:@"AppIcon"];
                    model.appId = [rs stringForColumn:@"AppId"];
                    model.index = [rs stringForColumn:@"AppIndex"];
                    [arr addObject:model];
                }
        [db close];

    }];

    return arr;
}
-(NSMutableArray *)getAllTopFreeCache
{
    FMDatabaseQueue *fmdq = [self sharedDataBase];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [fmdq inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs = [db executeQuery:@"select * from TopFreeApplicationList"];
                while ([rs next]) {
                    topFreeAppModel *model = [[topFreeAppModel alloc] init];
                    model.appName = [rs stringForColumn:@"AppName"];
                    model.appCategory = [rs stringForColumn:@"AppType"];
                    model.appDesc = [rs stringForColumn:@"Appdec"];
                    model.appDev = [rs stringForColumn:@"AppDev"];
                    model.commendCount = [rs stringForColumn:@"AppComment"];
                    model.appScore = [rs stringForColumn:@"AppScore"];
                    model.appIconUrl = [rs stringForColumn:@"AppIcon"];
                    model.appId = [rs stringForColumn:@"AppId"];
                    model.index = [rs stringForColumn:@"AppIndex"];
                    [arr addObject:model];
                }
        [db close];
    }];

    return arr;
}
- (NSMutableArray *)getAllRecommendCache
{
    FMDatabaseQueue *fmdq = [self sharedDataBase];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [fmdq inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs = [db executeQuery:@"select * from RecommendList"];
                while ([rs next]) {
                    recommendAppModel *model = [[recommendAppModel alloc] init];
                    model.appName = [rs stringForColumn:@"AppName"];
                    model.appCategory = [rs stringForColumn:@"AppType"];
                    model.appIconUrl = [rs stringForColumn:@"AppIcon"];
                    [arr addObject:model];
                }
        [db close];
    }];

    return arr;
}
- (NSMutableArray *)searchTopFreeAppWithKeyWord:(NSString *)keyword
{
    FMDatabaseQueue *fmdq = [self sharedDataBase];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [fmdq inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = [NSString stringWithFormat:@"select * from TopFreeApplicationList where AppName like '%%%@%%' or Appdec like '%%%@%%' or Appdev like '%%%@%%'",keyword,keyword,keyword];
        FMResultSet *rs = [db executeQuery:sql];
                while ([rs next]) {
                    topFreeAppModel *model = [[topFreeAppModel alloc] init];
                    model.appName = [rs stringForColumn:@"AppName"];
                    model.appCategory = [rs stringForColumn:@"AppType"];
                    model.appDesc = [rs stringForColumn:@"Appdec"];
                    model.appDev = [rs stringForColumn:@"AppDev"];
                    model.commendCount = [rs stringForColumn:@"AppComment"];
                    model.appScore = [rs stringForColumn:@"AppScore"];
                    model.appIconUrl = [rs stringForColumn:@"AppIcon"];
                    model.appId = [rs stringForColumn:@"AppId"];
                    model.index = [rs stringForColumn:@"AppIndex"];
                    [arr addObject:model];
                }
        [db close];
    }];

    return arr;
}

@end
