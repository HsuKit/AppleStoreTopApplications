//
//  macro.h
//  AppleStoreTopApplications
//
//  Created by HsuKit on 2021/6/1.
//

#ifndef macro_h
#define macro_h

//字体区域
#define _TitleFont [UIFont systemFontOfSize:17]
#define _DescriptionFont [UIFont systemFontOfSize:15]
#define _NumberFont [UIFont systemFontOfSize:13]

//颜色区域

#define kGetColorFromRGB(x,y,z,a) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a]

#define kGetColorFromHex(_f, _a)  [UIColor colorWithRed:((float)((_f & 0xFF0000) >> 16))/255.0 \
green:((float)((_f & 0xFF00)    >> 8))/255.0 \
blue:((float) (_f & 0xFF)           )/255.0 \
alpha:(_a)]

#define _BlackColor [UIColor blackColor]
#define _GrayColor kGetColorFromRGB(186, 186, 186, 1)
#define _SeperatorColor   kGetColorFromRGB(214, 214, 214, 1)


//尺寸相关
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kNavAndStatusHight  (self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height)
#define kStatusHight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kHaveSafeArea \
({\
BOOL safeArea = NO;\
if (@available(iOS 11.0,*)) {\
safeArea = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(safeArea);\
})

#define kSafeBottomHeight (kHaveSafeArea ? 34 : 0)

// 文件夹
#define kDocDir         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]

////单例相关
// .h
#define single_interface(class)  + (class *)shared##class;
// .m
// \ 代表下一行也属于宏
// ## 是分隔符
#define single_implementation(class) \
static class *_instance; \
 \
+ (class *)shared##class \
{ \
    if (_instance == nil) { \
        _instance = [[self alloc] init]; \
    } \
    return _instance; \
} \
 \
+ (id)allocWithZone:(NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
}

#endif /* macro_h */
