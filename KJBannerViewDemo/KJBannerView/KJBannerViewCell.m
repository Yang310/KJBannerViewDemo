//
//  KJBannerViewCell.m
//  KJBannerView
//
//  Created by 杨科军 on 2018/2/27.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJBannerViewDemo

#import "KJBannerViewCell.h"
#import "UIImageView+KJWebImage.h"
#import "UIImage+KJBannerGIF.h"
@interface KJBannerViewCell()
@property (nonatomic,strong) UIImageView *bannerImageView;
@end
@implementation KJBannerViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        self.layer.drawsAsynchronously = YES;
    }
    return self;
}
- (void)setItemView:(UIView*)itemView{
    if (_itemView) [_itemView removeFromSuperview];
    _itemView = itemView;
    [self.contentView addSubview:itemView];
}

- (void)setBannerDatas:(KJBannerDatas*)info{
    _bannerDatas = info;
    if (info.bannerImage) {
        self.bannerImageView.image = info.bannerImage;
    }else{
        if (kBannerLocality(info.bannerURLString)) {
            NSData *data = kBannerGetLocalityGIFData(info.bannerURLString);
            if (data) {
                self.bannerImageView.image = [UIImage kj_bannerGIFImageWithData:data]?:self.bannerPlaceholder;
            }else{
                self.bannerImageView.image = [UIImage imageNamed:info.bannerURLString]?:self.bannerPlaceholder;
            }
            info.bannerImage = self.bannerImageView.image;
        }else{
            [self performSelector:@selector(kj_bannerImageView) withObject:nil afterDelay:0.0 inModes:@[NSDefaultRunLoopMode]];
        }
    }
}
/// 下载图片，并渲染到cell上显示
- (void)kj_bannerImageView{
    __banner_weakself;
    [self.bannerImageView kj_setImageWithURL:[NSURL URLWithString:self.bannerDatas.bannerURLString] handle:^(id<KJBannerWebImageHandle>handle) {
        handle.placeholder = weakself.bannerPlaceholder;
        if (weakself.imageType == KJBannerViewImageTypeNetIamge) {
            handle.URLType = KJBannerImageURLTypeCommon;
        }else if (weakself.imageType == KJBannerImageInfoTypeGIFImage) {
            handle.URLType = KJBannerImageURLTypeGif;
        }else if (weakself.imageType != KJBannerViewImageTypeNetIamge) {
            handle.URLType = KJBannerImageURLTypeMixture;
        }
        handle.cropScale = weakself.bannerScale;
        handle.completed = ^(KJBannerImageType imageType, UIImage * _Nullable image, NSData * _Nullable data) {
            weakself.bannerDatas.bannerImage = image;
        };
    }];
}

#pragma mark - lazy
- (UIImageView*)bannerImageView{
    if(!_bannerImageView){
        _bannerImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _bannerImageView.contentMode = self.bannerContentMode;
        [self.contentView addSubview:_bannerImageView];
        if (self.bannerRadius > 0) {
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = ({
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_bannerImageView.bounds cornerRadius:self.bannerRadius];
                path.CGPath;
            });
            _bannerImageView.layer.mask = maskLayer;
        }
    }
    return _bannerImageView;
}

@end
@implementation KJBannerDatas

@end
