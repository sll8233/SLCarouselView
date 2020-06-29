//
//  SLCarouselView.h
//  SLCardScrollView
//
//  Created by sll on 2020/6/29.
//  Copyright © 2020 SLL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLCarouselView : UIView

/// 带间距的
/// @param frame <#frame description#>
/// @param imageSpacing 片间 间距
/// @param imageWidth 图片宽
+(instancetype)initWithFrame:(CGRect)frame
                imageSpacing:(CGFloat)imageSpacing
                  imageWidth:(CGFloat)imageWidth;


/// 重写了系统方法，相当于不带间距的 这种暂时没加describeLabel
/// @param frame <#frame description#>
//-(instancetype)initWithFrame:(CGRect)frame;


/// 点击中间图片的回调
@property (nonatomic, copy) void (^clickImageBlock)(NSInteger currentIndex);
/// 图片的圆角半径
@property(nonatomic, assign) CGFloat imageRadius;
/// 数据源
@property (nonatomic,strong) NSArray *data;

/// 显示文字数组
@property (nonatomic,strong) NSArray *describeArray;


///图片高度差 默认0
@property (nonatomic, assign) CGFloat imageHeightPoor;
/// 初始alpha默认1
@property (nonatomic, assign) CGFloat initAlpha;

/// 是否显示分页控件
@property (nonatomic, assign) BOOL showPageControl;
/// 是否显示描述label
@property (nonatomic, assign) BOOL showDescribeLabel;
/// 当前小圆点颜色
@property(nonatomic,retain)UIColor *curPageControlColor;

/// 其余小圆点颜色
@property(nonatomic,retain)UIColor *otherPageControlColor;



/// 占位图
@property (nonatomic,strong) UIImage  *placeHolderImage;

/// 是否在只有一张图时隐藏pagecontrol，默认为YES
@property(nonatomic) BOOL hidesForSinglePage;

/// 自动滚动间隔时间,默认2s
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/// 是否自动滚动,默认Yes
@property (nonatomic,assign) BOOL autoScroll;

@end

NS_ASSUME_NONNULL_END
