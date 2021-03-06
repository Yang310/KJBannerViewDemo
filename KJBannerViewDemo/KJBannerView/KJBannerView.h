//
//  KJBannerView.h
//  KJBannerView
//
//  Created by 杨科军 on 2018/2/27.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJBannerViewDemo
//  轮播图

#import <UIKit/UIKit.h>
#import "KJBannerViewType.h"
#import "KJBannerViewProtocol.h"
#import "KJPageView.h"
NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE
@interface KJBannerView : UIView
/// 代理方法
@property (nonatomic,weak) id<KJBannerViewDelegate> delegate;
@property (nonatomic,weak) id<KJBannerViewDataSource> dataSource;
/// 暂停计时器滚动处理，备注：在viewDidDisappear当中实现
- (void)kj_pauseTimer;
/// 继续计时器滚动，备注：在viewDidAppear当中实现
- (void)kj_repauseTimer;
/// 滚动到指定位置，备注：需要在设置数据源之后调用
- (void)kj_makeScrollToIndex:(NSInteger)index;
/// 使用Masonry自动布局，请在设置布局之后调用该方法
- (void)kj_useMasonry;

//************************ 数据源API ************************
/// 数据源
@property (nonatomic,strong) NSArray<NSString*>*imageDatas;
/// 自动滚动间隔时间，默认2s
@property (nonatomic,assign) IBInspectable CGFloat autoTime;
/// 是否无线循环，默认yes
@property (nonatomic,assign) IBInspectable BOOL infiniteLoop;
/// 是否自动滑动，默认yes
@property (nonatomic,assign) IBInspectable BOOL autoScroll;
/// 是否缩放，默认不缩放
@property (nonatomic,assign) IBInspectable BOOL isZoom;
/// cell宽度，左右宽度
@property (nonatomic,assign) IBInspectable CGFloat itemWidth;
/// cell间距，默认为0
@property (nonatomic,assign) IBInspectable CGFloat itemSpace;
/// 是否显示分页控件，默认yes
@property (nonatomic,assign) IBInspectable BOOL showPageControl;
/// 滚动方向，默认从右到左
@property (nonatomic,assign) KJBannerViewRollDirectionType rollType;
/// 分页控制器
@property (nonatomic,strong,readonly) KJPageView *pageControl;

//************************ 废弃属性方法 *****************************/
/// 支持自定义Cell，自定义Cell需继承自 KJBannerViewCell
@property (nonatomic,strong) Class itemClass DEPRECATED_MSG_ATTRIBUTE("Please use dataSource [kj_BannerView:BannerViewCell:ImageDatas:Index:]");

@end

//******************** 自带KJBannerViewCell可设置属性 ********************
@interface KJBannerView (KJBannerViewCell)
/// imagView圆角，默认为0px
@property (nonatomic,assign) IBInspectable CGFloat bannerRadius;
/// cell的占位图，用于网络未加载到图片时
@property (nonatomic,strong) IBInspectable UIImage *placeholderImage;
/// 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill
@property (nonatomic,assign) UIViewContentMode bannerContentMode;
/// 是否裁剪，默认NO
@property (nonatomic,assign) BOOL bannerScale;

@end

@interface KJBannerView (KJBannerBlock)
/// 点击回调
@property (nonatomic,readwrite,copy) void(^kSelectBlock)(KJBannerView *banner,NSInteger idx);
/// 滚动回调
@property (nonatomic,readwrite,copy) void(^kScrollBlock)(KJBannerView *banner,NSInteger idx);

@end
NS_ASSUME_NONNULL_END
