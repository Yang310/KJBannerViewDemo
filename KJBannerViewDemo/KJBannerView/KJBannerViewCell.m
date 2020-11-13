//
//  KJBannerViewCell.m
//  KJBannerView
//
//  Created by 杨科军 on 2018/2/27.
//  Copyright © 2018年 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJBannerViewDemo

#import "KJBannerViewCell.h"

@interface KJBannerViewCell()
@property (nonatomic,strong) KJLoadImageView *loadImageView;
@end

@implementation KJBannerViewCell

- (void)setInfo:(KJBannerDatasInfo*)info{
    switch (info.type) {
        case KJBannerImageInfoTypeLocality:
        case KJBannerImageInfoTypeGIFImage:
            self.loadImageView.image = info.image?:self.placeholderImage;
            break;
        case KJBannerImageInfoTypeNetIamge:
            [self.loadImageView kj_setImageWithURLString:info.imageUrl Placeholder:self.placeholderImage];
            break;
        default:
            break;
    }
}

#pragma mark - lazy
- (KJLoadImageView*)loadImageView{
    if(!_loadImageView){
        _loadImageView = [[KJLoadImageView alloc]initWithFrame:self.bounds];
        _loadImageView.image = self.placeholderImage;
        _loadImageView.contentMode = self.contentMode;
        _loadImageView.kj_isScale = self.kj_scale;
        [self.contentView addSubview:_loadImageView];
        if (self.imgCornerRadius > 0) {
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = ({
                UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_loadImageView.bounds cornerRadius:self.imgCornerRadius];
                path.CGPath;
            });
            _loadImageView.layer.mask = maskLayer;
        }
    }
    return _loadImageView;
}

@synthesize itemView = _itemView;
- (UIView *)itemView{
    if (!_itemView) {
        _itemView = [[UIView alloc] init];
    }
    return _itemView;
}
- (void)setItemView:(UIView *)itemView{
    if (_itemView) [_itemView removeFromSuperview];
    _itemView = itemView;
    [self addSubview:_itemView];
}

@end
