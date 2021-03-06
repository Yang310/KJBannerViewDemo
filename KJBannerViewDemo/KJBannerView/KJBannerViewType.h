//
//  KJBannerViewType.h
//  KJBannerViewDemo
//
//  Created by 杨科军 on 2020/12/7.
//  Copyright © 2020 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJBannerViewDemo
//  枚举文件夹

#ifndef KJBannerViewType_h
#define KJBannerViewType_h
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, KJBannerImageType) {
    KJBannerImageTypeUnknown = 0, /// 未知
    KJBannerImageTypeJpeg    = 1, /// jpg
    KJBannerImageTypePng     = 2, /// png
    KJBannerImageTypeGif     = 3, /// gif
    KJBannerImageTypeTiff    = 4, /// tiff
    KJBannerImageTypeWebp    = 5, /// webp
};
/// 滚动方法
typedef NS_ENUM(NSInteger, KJBannerViewRollDirectionType) {
    KJBannerViewRollDirectionTypeRightToLeft, /// 默认，从右往左
    KJBannerViewRollDirectionTypeLeftToRight, /// 从左往右
    KJBannerViewRollDirectionTypeBottomToTop, /// 从下往上
    KJBannerViewRollDirectionTypeTopToBottom, /// 从上往下
};

NS_INLINE void kGCD_banner_async(dispatch_block_t _Nonnull block) {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {
        block();
    }else{
        dispatch_async(queue, block);
    }
}
NS_INLINE void kGCD_banner_main(dispatch_block_t _Nonnull block) {
    dispatch_queue_t queue = dispatch_get_main_queue();
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {
        block();
    }else{
        if ([[NSThread currentThread] isMainThread]) {
            dispatch_async(queue, block);
        }else{
            dispatch_sync(queue, block);
        }
    }
}
/// 判断是网络图片还是本地
NS_INLINE bool kBannerLocality(NSString * _Nonnull urlString){
    return ([urlString hasPrefix:@"http://"] || [urlString hasPrefix:@"https://"]) ? false : true;
}
/// 判断该字符串是不是一个有效的URL
NS_INLINE bool kBannerValid(NSString * _Nonnull urlString){
    NSString *regex = @"[a-zA-z]+://[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:urlString];
}
/// 根据DATA判断图片类型
NS_INLINE KJBannerImageType kBannerContentType(NSData * _Nonnull data){
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return KJBannerImageTypeJpeg;
        case 0x89:
            return KJBannerImageTypePng;
        case 0x47:
            return KJBannerImageTypeGif;
        case 0x49:
        case 0x4D:
            return KJBannerImageTypeTiff;
        case 0x52:
            if ([data length] < 12) return KJBannerImageTypeUnknown;
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) return KJBannerImageTypeWebp;
            return KJBannerImageTypeUnknown;
    }
    return KJBannerImageTypeUnknown;
}
/// 等比改变图片尺寸
NS_INLINE UIImage * _Nullable kBannerCropImage(UIImage * _Nonnull image, CGSize size){
    CGFloat scale = UIScreen.mainScreen.scale;
    float imgHeight = image.size.height;
    float imgWidth  = image.size.width;
    float maxHeight = size.width * scale;
    float maxWidth = size.height * scale;
    if (imgHeight <= maxHeight && imgWidth <= maxWidth) return image;
    float imgRatio = imgWidth/imgHeight;
    float maxRatio = maxWidth/maxHeight;
    if (imgHeight > maxHeight || imgWidth > maxWidth) {
        if (imgRatio < maxRatio) {
            imgRatio = maxHeight / imgHeight;
            imgWidth = imgRatio * imgWidth;
            imgHeight = maxHeight;
        }else if (imgRatio > maxRatio) {
            imgRatio = maxWidth / imgWidth;
            imgWidth = maxWidth;
            imgHeight = imgRatio * imgHeight;
        }else {
            imgWidth = maxWidth;
            imgHeight = maxHeight;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, imgWidth, imgHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#define __banner_weakself __weak __typeof(&*self) weakself = self

/// 图片下载完成回调
typedef void (^_Nullable KJWebImageCompleted)(KJBannerImageType imageType, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error);
NS_ASSUME_NONNULL_END
#endif /* KJBannerViewType_h */
