//
//  KJTestViewController.m
//  KJBannerViewDemo
//
//  Created by 杨科军 on 2020/1/15.
//  Copyright © 2020 杨科军. All rights reserved.
//

#import "KJTestViewController.h"
#import "KJBannerHeader.h"

@interface KJTestViewController ()
@property (nonatomic,strong) UILabel *label1,*label2,*label3;
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation KJTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColor.whiteColor;
    CGFloat w = self.view.frame.size.width;
//    CGFloat h = self.view.frame.size.height;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 64 + 60, w-40, 20)];
    self.label1 = label;
    label.textColor = UIColor.blueColor;
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame) + 20, w-40, 20)];
    self.label2 = label2;
    label2.textColor = UIColor.blueColor;
    label2.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label2.frame) + 20, w-40, 20)];
    self.label3 = label3;
    label3.textColor = UIColor.blueColor;
    label3.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label3];
        
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0, 0, 150, 40);
    button.center = self.view.center;
    button.backgroundColor = UIColor.yellowColor;
    [button setTitle:@"重新获取" forState:(UIControlStateNormal)];
    [button setTitleColor:UIColor.blueColor forState:(UIControlStateNormal)];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height-180-40, w-40, 180)];
    imageView.backgroundColor = [UIColor.greenColor colorWithAlphaComponent:0.3];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    kGCD_async(^{
        NSData *data = [KJBannerViewLoadManager kj_downloadDataWithURL:@"http://photos.tuchong.com/285606/f/4374153.jpg" progress:nil];
        kGCD_main(^{
            CALayer *layer = (CALayer*)[self.imageView performSelector:@selector(kj_setLayerImageContents:) withObject:[UIImage imageWithData:data]];
            layer.contentsGravity = kCAGravityResizeAspect;
        });
    });
    
    [self buttonAction];
    
    kGCD_async(^{
        [KJBannerViewLoadManager kj_downloadDataWithURL:@"https://mp4.vjshi.com/2018-03-30/1f36dd9819eeef0bc508414494d34ad9.mp4" progress:^(KJBannerDownloadProgress * _Nonnull downloadProgress) {
        }];
    });
    kGCD_async(^{
        [KJBannerViewLoadManager kj_downloadDataWithURL:@"https://mp4.vjshi.com/2018-03-30/1f36dd9819eeef0bc508414494d34ad9.mp4" progress:^(KJBannerDownloadProgress * _Nonnull downloadProgress) {
        }];
    });
}
- (void)buttonAction{
    kGCD_async(^{
        [KJBannerViewLoadManager kj_downloadDataWithURL:@"https://mp4.vjshi.com/2018-03-30/1f36dd9819eeef0bc508414494d34ad9.mp4" progress:^(KJBannerDownloadProgress * _Nonnull downloadProgress) {
            kGCD_main(^{
                self.label1.text = [NSString stringWithFormat:@"已下载：%.2fkb",downloadProgress.downloadBytes/1024.];
                self.label2.text = [NSString stringWithFormat:@"总大小：%.2fkb",downloadProgress.totalBytes/1024.];
                self.label3.text = [NSString stringWithFormat:@"下载速度：%.2fkb/s",downloadProgress.speed];
            });
            NSLog(@"---\nbytesWritten:%lld,\ndownloadBytes:%lld,\ntotalBytes:%lld,\nspeed:%f,\nprogress:%f",downloadProgress.bytesWritten,downloadProgress.downloadBytes,downloadProgress.totalBytes,downloadProgress.speed,downloadProgress.progress);
        }];
    });
}
NS_INLINE void kGCD_async(dispatch_block_t block) {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {
        block();
    }else{
        dispatch_async(queue, block);
    }
}
/// 主线程
NS_INLINE void kGCD_main(dispatch_block_t block) {
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

@end
